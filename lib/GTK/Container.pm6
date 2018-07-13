use v6.c;

use NativeCall;

use GTK::Raw::Types;
use GTK::Widget;

class GTK::Container is GTK::Widget {
  # Maybe this should be done as the base class.
  has GtkContainer $!c;

  has %!signals;

  submethod BUILD (GtkContainer :$container) {
    self.setContainer($container);
  }

  method new(:$container) {
    self.bless(:$container);
  }

  # cw: Should check caller to insure call comes from proper object chain.
  method setContainer(GtkContainer :$container) {
    self.setWidget($!c = $container);
  }

#Function definition finished, but detected no match:
#' void         gtk_container_add_with_properties                (GtkContainer      *container,                      GtkWidget          *widget,                                                      const gchar       *first_prop_name,                                                         ...) G_GNUC_NULL_TERMINATED;'
#Function definition finished, but detected no match:
#' void         gtk_container_child_set                  (GtkContainer      *container,                              GtkWidget          *child,                                                       const gchar       *first_prop_name,                                                         ...) G_GNUC_NULL_TERMINATED;'
#Function definition finished, but detected no match:
#' void         gtk_container_child_get                  (GtkContainer      *container,                              GtkWidget          *child,                                                       const gchar       *first_prop_name,                                                         ...) G_GNUC_NULL_TERMINATED;'

#perl6 -e 'sub a { b(); }; sub b { c(); }; sub c { my @a = Backtrace.new.list; @a[*-2].gist.say }; a()'
#Backtrace::Frame.new(file => "-e", line => 1, code => sub a () { #`(Sub|93842260662800) ... }, subname => "a")

  method resize_mode is rw {
    Proxy,new(
      FETCH => sub ($) {
        gtk_container_get_resize_mode($!c);
      },
      STORE => -> sub ($, $resize_mode is copy) {
        gtk_container_set_resize_mode($!c, $resize_mode);
      }
    );
  }

  method focus_vadjustment is rw {
    Proxy,new(
      FETCH => sub ($) {
        gtk_container_get_focus_vadjustment($!c);
      },
      STORE => -> sub ($, $adjustment is copy) {
        gtk_container_set_focus_vadjustment($!c, $adjustment);
      }
    );
  }

  method focus_child is rw {
    Proxy,new(
      FETCH => sub ($) {
        gtk_container_get_focus_child($!c);
      },
      STORE => -> sub ($, $child is copy) {
        gtk_container_set_focus_child($!c, $child);
      }
    );
  }

  method focus_hadjustment is rw {
    Proxy,new(
      FETCH => sub ($) {
        gtk_container_get_focus_hadjustment($!c);
      },
      STORE => -> sub ($, $adjustment is copy) {
        gtk_container_set_focus_hadjustment($!c, $adjustment);
      }
    );
  }

  method border_width is rw {
    Proxy,new(
      FETCH => sub ($) {
        gtk_container_get_border_width($!c);
      },
      STORE => -> sub ($, $border_width is copy) {
        gtk_container_set_border_width($!c, $border_width);
      }
    );
  }

  method unset_focus_chain (GtkContainer $!c) {
    gtk_container_unset_focus_chain($!c);
  }

  method class_list_child_properties (GObjectClass $cclass, guint $n_properties) {
    gtk_container_class_list_child_properties($cclass, $n_properties);
  }

  method check_resize (GtkContainer $!c) {
    gtk_container_check_resize($!c);
  }

  method child_set_valist (GtkContainer $!c, GtkWidget $child, gchar $first_property_name, va_list $var_args) {
    gtk_container_child_set_valist($!c, $child, $first_property_name, $var_args);
  }

  method foreach (GtkContainer $!c, GtkCallback $callback, gpointer $callback_data) {
    gtk_container_foreach($!c, $callback, $callback_data);
  }

  method get_children (GtkContainer $!c) {
    gtk_container_get_children($!c);
  }

  method child_get_property (GtkContainer $!c, GtkWidget $child, gchar $property_name, GValue $value) {
    gtk_container_child_get_property($!c, $child, $property_name, $value);
  }

  method class_find_child_property (GObjectClass $cclass, gchar $property_name) {
    gtk_container_class_find_child_property($cclass, $property_name);
  }

  method add (GtkContainer $!c, GtkWidget $widget) {
    gtk_container_add($!c, $widget);
  }

  method get_path_for_child (GtkContainer $!c, GtkWidget $child) {
    gtk_container_get_path_for_child($!c, $child);
  }

  method get_focus_chain (GtkContainer $!c, GList $focusable_widgets) {
    gtk_container_get_focus_chain($!c, $focusable_widgets);
  }

  method child_type (GtkContainer $!c) {
    gtk_container_child_type($!c);
  }

  method class_install_child_properties (GtkContainerClass $cclass, guint $n_pspecs, GParamSpec $pspecs) {
    gtk_container_class_install_child_properties($cclass, $n_pspecs, $pspecs);
  }

#  method class_install_child_property (GtkContainerClass $cclass, guint $property_id, GParamSpec $pspec) {
#    gtk_container_class_install_child_property($cclass, $property_id, $pspec);
#  }

  method resize_children (GtkContainer $!c) {
    gtk_container_resize_children($!c);
  }

  method propagate_draw (GtkContainer $!c, GtkWidget $child, cairo_t $cr) {
    gtk_container_propagate_draw($!c, $child, $cr);
  }

  method child_get_valist (GtkContainer $!c, GtkWidget $child, gchar $first_property_name, va_list $var_args) {
    gtk_container_child_get_valist($!c, $child, $first_property_name, $var_args);
  }

  method forall (GtkContainer $!c, GtkCallback $callback, gpointer $callback_data) {
    gtk_container_forall($!c, $callback, $callback_data);
  }

  method set_reallocate_redraws (GtkContainer $!c, gboolean $needs_redraws) {
    gtk_container_set_reallocate_redraws($!c, $needs_redraws);
  }

  method child_set_property (GtkContainer $!c, GtkWidget $child, gchar $property_name, GValue $value) {
    gtk_container_child_set_property($!c, $child, $property_name, $value);
  }

  method class_handle_border_width (GtkContainerClass $klass) {
    gtk_container_class_handle_border_width($klass);
  }

  method remove (GtkContainer $!c, GtkWidget $widget) {
    gtk_container_remove($!c, $widget);
  }

  method get_type () {
    gtk_container_get_type();
  }

  method child_notify_by_pspec (GtkContainer $!c, GtkWidget $child, GParamSpec $pspec) {
    gtk_container_child_notify_by_pspec($!c, $child, $pspec);
  }

  method child_notify (GtkContainer $!c, GtkWidget $child, gchar $child_property) {
    gtk_container_child_notify($!c, $child, $child_property);
  }

}