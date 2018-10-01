use v6.c;

use NativeCall;

use GTK::Compat::RGBA;
use GTK::Compat::Types;

use GTK::Raw::ColorChooser;
use GTK::Raw::Label;
use GTK::Raw::Types;

use GTK::Box;

class GTK::ColorChooser is GTK::Box {
  has GtkColorChooser $!cc;

  method bless(*%attrinit) {
    my $o = self.CREATE.BUILDALL(Empty, %attrinit);
    $o.setType('GTK::ColorChooser');
    $o;
  }

  submethod BUILD(:$chooser) {
    my $to-parent;
    given $chooser {
      when GtkColorChooser | GtkWidget {
        $!cc = do {
          when GtkWidget {
            $to-parent = $_;
            nativecast(GtkColorChooser, $_);
          }
          when GtkColorChooser {
            $to-parent = nativecast(GtkBox, $_);
            $_;
          }
        };
        self.setBox($to-parent);
      }
      when GTK::ColorChooser {
      }
      default {
      }
    }
  }

  multi method new {
    my $chooser = gtk_color_chooser_widget_new();
    self.bless(:$chooser);
  }
  multi method new (GtkWidget $chooser) {
    self.bless(:$chooser);
  }

  # ↓↓↓↓ SIGNALS ↓↓↓↓
  method color-activated {
    self.connect($!cc, 'color-activated');
  }
  # ↑↑↑↑ SIGNALS ↑↑↑↑

  # ↓↓↓↓ ATTRIBUTES ↓↓↓↓
  method use_alpha is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_color_chooser_get_use_alpha($!cc);
      },
      STORE => sub ($, $use_alpha is copy) {
        gtk_color_chooser_set_use_alpha($!cc, $use_alpha);
      }
    );
  }
  # ↑↑↑↑ ATTRIBUTES ↑↑↑↑

  # ↓↓↓↓ METHODS ↓↓↓↓
  method add_palette (
    Int() $orientation,
    Int() $colors_per_line,
    Int() $n_colors,
    GTK::Compat::RGBA $colors
  ) {
    my uint32 $o = self.RESOLVE-UINT($orientation);
    my @i = ($colors_per_line, $n_colors);
    my gint ($cpl, $nc) = self.RESOLVE-INT(@i);
    gtk_color_chooser_add_palette($!cc, $o, $cpl, $nc, $colors);
  }

  multi method get_rgba (GTK::Compat::RGBA $color is rw) {
    gtk_color_chooser_get_rgba($!cc, $color);
    $color;
  }
  multi method get_rgba {
    my $c = GTK::Compat::RGBA.new;
    samewith($c);
  }

  method get_type {
    gtk_color_chooser_get_type();
  }

  method set_rgba (GTK::Compat::RGBA $color) {
    gtk_color_chooser_set_rgba($!cc, $color);
  }
  # ↑↑↑↑ METHODS ↑↑↑↑

}
