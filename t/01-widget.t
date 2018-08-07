use v6.c;

use lib 't';

use Test;

use NativeCall;

# Could be abstracted away at the module level.
use GTK::Raw::Types;
use GTK::Compat::GList;

use GTK::Application;
use GTK::Button;
use GTK::Box;

use GTK::Raw::Container;

#use GTK::Raw::Subs :app, :window, :widget, :button;

my $a = GTK::Application.new(
  title  => 'org.genex.test.widget',
  width  => 200,
  height => 200
);

#$a.activate.tap({
#  my $win = gtk_application_window_new($a.app);
#  gtk_window_set_title($win, $a.title);
#  gtk_window_set_default_size($win, $a.width, $a.height);
#  gtk_application_add_window($a.app, $win);
#  gtk_widget_show_all($win);
#});
$a.activate.tap({
  my $box = GTK::Box.new-box(GTK_ORIENTATION_HORIZONTAL, 6);

  $a.window.add($box);

  my ($b1, $b2, $b3) = (
    GTK::Button.new_with_label('Click Me'),
    GTK::Button.new_with_mnemonic('_Open'),
    GTK::Button.new_with_mnemonic('_Close')
  );
  $b1.clicked.tap({ say 'Click me button was clicked'; });
  $b2.clicked.tap({ say 'Open button was clicked'; });
  $b3.clicked.tap({ say 'Closing application.'; $a.exit; });
  $box.pack_start($b1, True, True, 0);
  $box.pack_start($b2, True, True, 0);
  $box.pack_start($b3, True, True, 0);

  say "B: " ~ $box;
  say "BW: " ~ $box.widget;
  my $childs = GTK::Compat::GList.new( gtk_container_get_children($box.widget) );
  say "CL: " ~ $childs;

  say $childs.first;

  $a.window.show_all;
});

$a.run;
