use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::Dialog;
use GTK::Raw::Types;

use GTK::Box;
use GTK::HeaderBar;
use GTK::Window;

class GTK::Dialog is GTK::Window {
  has GtkDialog $!d;

  method bless(*%attrinit) {
    my $o = self.CREATE.BUILDALL(Empty, %attrinit);
    $o.setType('GTK::Dialog');
    $o;
  }

  submethod BUILD(:$dialog) {
    given $dialog {
      when GtkDialog | GtkWidget {
        self.setDialog($dialog);
      }
      when GTK::Dialog {
      }
      default {
      }
    }
  }

  method setDialog($dialog) {
    my $to-parent;
    $!d = do given $dialog {
      when GtkWidget {
        $to-parent = $_;
        nativecast(GtkDialog, $_);
      }
      when GtkDialog {
        $to-parent = nativecast(GtkWindow, $_);
        $_;
      }
    }
    self.setWindow($to-parent);
  }

  multi method new {
    my $dialog = gtk_dialog_new();
    self.bless(:$dialog);
  }
  multi method new (GtkWidget $dialog) {
    self.bless(:$dialog);
  }

  # ↓↓↓↓ SIGNALS ↓↓↓↓
  # Is originally:

  # GtkDialog, gpointer --> void
  method close {
    self.connect($!d, 'close');
  }

  # Is originally:
  # GtkDialog, gint, gpointer --> void
  # - Made multi so as to not conflict with the method implementing
  #   gtk_response_dialog()
  multi method response {
    self.connect($!d, 'response');
  }
  # ↑↑↑↑ SIGNALS ↑↑↑↑

  # ↓↓↓↓ ATTRIBUTES ↓↓↓↓
  # ↑↑↑↑ ATTRIBUTES ↑↑↑↑

  # ↓↓↓↓ METHODS ↓↓↓↓
  method add_action_widget (GtkWidget() $child, Int() $response_id) {
    my gint $ri = self.RESOLVE-INT($response_id);
    gtk_dialog_add_action_widget($!d, $child, $ri);
  }

  method add_button (Str() $button_text, Int() $response_id) {
    my gint $ri = self.RESOLVE-INT($response_id);
    gtk_dialog_add_button($!d, $button_text, $ri);
  }

  method get_action_area {
    GTK::Box.new( gtk_dialog_get_action_area($!d) );
  }

  method get_content_area {
    GTK::Box.new( gtk_dialog_get_content_area($!d) );
  }

  method get_header_bar {
    GTK::HeaderBar.new( gtk_dialog_get_header_bar($!d) );
  }

  method get_response_for_widget (GtkWidget() $widget) {
    gtk_dialog_get_response_for_widget($!d, $widget);
  }

  method get_type {
    gtk_dialog_get_type();
  }

  method get_widget_for_response (Int() $response_id) {
    my gint $ri = self.RESOLVE-INT($response_id);
    gtk_dialog_get_widget_for_response($!d, $ri);
  }

  # Class method.. but deprecated
  method gtk_alternative_dialog_button_order (GdkScreen $screen)
    is DEPRECATED
  {
    gtk_alternative_dialog_button_order($screen);
  }

  multi method response (Int() $response_id) {
    my gint $ri = self.RESOLVE-INT($response_id);
    gtk_dialog_response($!d, $ri);
  }

  method run {
    my gint $rc = gtk_dialog_run($!d);
    GtkResponseType( $rc );
  }

  method set_alternative_button_order_from_array (
    Int() $n_params,
    Int @new_order
  )
    is DEPRECATED
  {
    my gint $np = self.RESOLVE-INT($n_params);
    my CArray[gint] $no = CArray[gint].new;
    $no[$++] = $_ for @new_order;

    gtk_dialog_set_alternative_button_order_from_array($!d, $np, $no);
  }

  method set_default_response (Int() $response_id) {
    my gint $ri = self.RESOLVE-INT($response_id);
    gtk_dialog_set_default_response($!d, $ri);
  }

  method set_response_sensitive (Int() $response_id, Int() $setting) {
    my gint $ri = self.RESOLVE-INT($response_id);
    my gboolean $s = self.RESOLVE-BOOL($setting);
    gtk_dialog_set_response_sensitive($!d, $ri, $s);
  }
  # ↑↑↑↑ METHODS ↑↑↑↑

}
