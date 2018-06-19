use v6.c;

use Data::Dump::Tree;

my $prechop = 11;

sub MAIN ($filename, :$remove) {
  die "Cannot fine '$filename'\n" unless $filename.IO.e;

  say $remove;

  my $contents = $filename.IO.open.slurp-rest;

  my $la;
  my $fd;
  my $i = 1;
  my @detected;
  for $contents.lines -> $l {
    if $l ~~ /^ 'GDK_' [ 'AVAILABLE' | 'DEPRECATED' ] '_'.+ / {
      $la = True;
      next;
    }
    if $la {
      $fd ~= ' ' ~ $l.chomp;
    }

    #say "FD[{ $i++ }]: $fd";

    if $fd && $fd ~~ /';'$$/ {
      my token   p { '*'+ }
      my rule type { 'const'? \w+ }
      my rule  var { <p>?$<t>=[ <[\w _]>+ ] }

      my rule func_def {
        $<returns>=[ $<t>=\w+ <p>? ]
        $<sub>=[ \w+ ]
        [
          '(void)'
          |
          '(' [ <type> <var> ]+ % [ ',' \s* ] ')'
        ]
        #[ <[ A..Z _ ]>+ ]?';'
      }

      my @tv;
      if $fd ~~ /<func_def>/ {
        my @p;

        my @tv = ($/<func_def><type> [Z] $/<func_def><var>);

        @p.push: [ $_[0], $_[1] ] for @tv;

        my @v = @p.map({ '$' ~ $_[1]<t>.Str.trim });
        my @t = @p.map({
          my $t = $_[0].Str.trim;
          if $_[1]<p> {
            $t = "CArray[{ $t.Str.trim }]" for ^($_[1]<p>.Str.trim.chars - 1);
          }
          $t;
        });

        my $call = @v.join(', ');
        my $sig = (@t [Z] @v).map( *.join(' ') ).join(', ');
        my $sub = $/<func_def><sub>.Str.trim;

        my $h = {
          returns => $/<func_def><returns>.Str.trim,
            'sub' => $sub,
           params => @p,
             call => $call,
              sig => $sig
        };

        @detected.push: $h;
      } else {
        say "Function definition finished, but detected no match: \n'$fd'";
      }
      $fd = '';
      $la = False;
    }
  }

  my %methods;
  my %getset;
  for @detected -> $d {
    if $d<p> {
      $d<returns> = "CPointer[{ $d<returns> }]" for ^($d<p>.Str.chars - 1);
    }

    # Convert signatures to perl6.
    #
    #$d<sub> = substr($d<sub>, $prechop);
    if $d<sub> ~~ / '_' ( [ 'get' || 'set' ] ) '_' ( .+ ) / {
      %getset{$/[1]}{$/[0]} = $d;
    } else {
      %methods{$d<sub>} = $d;
    }
  }

  for %getset.keys -> $gs {
    unless
      %getset{$gs}<get>                     &&
      %getset{$gs}<get><params>.elems == 1  &&
      %getset{$gs}<set>                     &&
      %getset{$gs}<set><params>.elems == 2
    {
      say "Removing non-conforming get:set {$gs}...";
      if %getset{$gs}<get>.defined {
        %methods{%getset{$gs}<get><sub>} = %getset{$gs}<get>;
      }
      if %getset{$gs}<set>.defined {
        %methods{%getset{$gs}<set><sub>} = %getset{$gs}<set>
      }
      %getset{$gs}:delete;
    }
  }

  my @subs;

  say "\nGETSET\n------";
  for %getset.keys -> $gs {

    ( my $s = %getset{$gs}<get><sub>.substr($prechop) ) ~~ s/['get' | 'set']_//;
    say qq:to/METHOD/;
      method { $s } is rw \{
        Proxy,new(
          FETCH => \{
            { %getset{$gs}<get><sub> ~ '(' ~ %getset{$gs}<get><call> ~ ')' };
          \},
          STORE => \{
            { %getset{$gs}<set><sub> ~ '(' ~ %getset{$gs}<set><call> ~ ')'};
          \}
        );
      \}
    METHOD

  }


  say "\nMETHODS\n-------";
  #dump %methods;

}
