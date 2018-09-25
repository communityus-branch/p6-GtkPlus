use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::ToolItem;
use GTK::Raw::Types;

use GTK::Bin;

class GTK::ToolItem is GTK::Bin {
  has GtkToolItem $!ti;

  method bless(*%attrinit) {
    use nqp;
    my $o = nqp::create(self).BUILDALL(Empty, %attrinit);
    $o.setType('GTK::ToolItem');
    $o;
  }

  submethod BUILD(:$toolitem) {
    given $toolitem {
      when GtkToolItem | GtkWidget {
        self.setToolItem($toolitem);
      }
      when GTK::ToolItem {
      }
      default {
      }
    }
  }

  method new {
    my $toolitem = gtk_tool_item_new();
    self.bless(:$toolitem);
  }

  method new (GtkWidget $toolitem) {
    #use GTK::Widget;

    #my $type = GTK::Widget.getType($toolitem);
    #die "Incorrect type $type passed to " ~ ::?CLASS ~ 'constructor.'
    #  unless $type eq ::?CLASS.name;
    self.bless(:$toolitem);
  }

  method setToolItem($toolitem) {
    my $to-parent;

    $!ti = given $toolitem {
      when GtkToolItem {
        $to-parent = nativecast(GtkBin, $_);
        $_;
      }
      when GtkWidget {
        $to-parent = $_;
        nativecast(GtkToolItem, $_);
      }
    }
    self.setBin($to-parent);
  }

  method GTK::Raw::Types::GtkToolItem {
    $!ti;
  }

  # ↓↓↓↓ SIGNALS ↓↓↓↓

  # Is originally:
  # GtkToolItem, gpointer --> gboolean
  method create-menu-proxy {
    self.connect($!ti, 'create-menu-proxy');
  }

  # Is originally:
  # GtkToolItem, gpointer --> void
  method toolbar-reconfigured {
    self.connect($!ti, 'toolbar-reconfigured');
  }
  # ↑↑↑↑ SIGNALS ↑↑↑↑

  # ↓↓↓↓ ATTRIBUTES ↓↓↓↓
  method expand is rw {
    Proxy.new(
      FETCH => sub ($) {
        Bool( gtk_tool_item_get_expand($!ti) );
      },
      STORE => sub ($, Int() $expand is copy) {
        my gboolean $e = $expand == 0 ?? 0 !! 1;
        gtk_tool_item_set_expand($!ti, $e);
      }
    );
  }

  method homogeneous is rw {
    Proxy.new(
      FETCH => sub ($) {
        Bool( gtk_tool_item_get_homogeneous($!ti) );
      },
      STORE => sub ($, Int() $homogeneous is copy) {
        my gboolean $h = $homogeneous == 0 ?? 0 !! 1;
        gtk_tool_item_set_homogeneous($!ti, $h);
      }
    );
  }

  method is_important is rw {
    Proxy.new(
      FETCH => sub ($) {
        Bool( gtk_tool_item_get_is_important($!ti) );
      },
      STORE => sub ($, Int() $is_important is copy) {
        my gboolean $ii = $is_important == 0 ?? 0 !! 1;
        gtk_tool_item_set_is_important($!ti, $ii);
      }
    );
  }

  method use_drag_window is rw {
    Proxy.new(
      FETCH => sub ($) {
        Bool( gtk_tool_item_get_use_drag_window($!ti) );
      },
      STORE => sub ($, Int() $use_drag_window is copy) {
        my gboolean $udw = $use_drag_window == 0 ?? 0 !! 1;
        gtk_tool_item_set_use_drag_window($!ti, $udw);
      }
    );
  }

  method visible_horizontal is rw {
    Proxy.new(
      FETCH => sub ($) {
        Bool( gtk_tool_item_get_visible_horizontal($!ti) );
      },
      STORE => sub ($, Int() $visible_horizontal is copy) {
        my gboolean $vh = $visible_horizontal == 0 ?? 0 !! 1;
        gtk_tool_item_set_visible_horizontal($!ti, $vh);
      }
    );
  }

  method visible_vertical is rw {
    Proxy.new(
      FETCH => sub ($) {
        Bool( gtk_tool_item_get_visible_vertical($!ti) );
      },
      STORE => sub ($, Int() $visible_vertical is copy) {
        my gboolean $vv = $visible_vertical == 0 ?? 0 !! 1;
        gtk_tool_item_set_visible_vertical($!ti, $vv);
      }
    );
  }
  # ↑↑↑↑ ATTRIBUTES ↑↑↑↑

  # ↓↓↓↓ METHODS ↓↓↓↓
  method get_ellipsize_mode {
    PangoEllipsizeMode( gtk_tool_item_get_ellipsize_mode($!ti) );
  }

  method get_icon_size {
    gtk_tool_item_get_icon_size($!ti);
  }

  method get_orientation {
    gtk_tool_item_get_orientation($!ti);
  }

  method get_proxy_menu_item (gchar $menu_item_id) {
    gtk_tool_item_get_proxy_menu_item($!ti, $menu_item_id);
  }

  method get_relief_style {
    GtkReliefStyle( gtk_tool_item_get_relief_style($!ti) );
  }

  method get_text_alignment {
    gtk_tool_item_get_text_alignment($!ti);
  }

  method get_text_orientation {
    GtkOrientation( gtk_tool_item_get_text_orientation($!ti) );
  }

  method get_text_size_group {
    # GtkSizeGroup -- GObject descendant
    gtk_tool_item_get_text_size_group($!ti);
  }

  method get_toolbar_style {
    GtkToolbarStyle( gtk_tool_item_get_toolbar_style($!ti) );
  }

  method get_type {
    gtk_tool_item_get_type();
  }

  method rebuild_menu {
    gtk_tool_item_rebuild_menu($!ti);
  }

  method retrieve_proxy_menu_item {
    gtk_tool_item_retrieve_proxy_menu_item($!ti);
  }

  method set_proxy_menu_item (
    gchar $menu_item_id,
    GtkWidget() $menu_item
  ) {
    gtk_tool_item_set_proxy_menu_item($!ti, $menu_item_id, $menu_item);
  }

  method set_tooltip_markup (gchar $markup) {
    gtk_tool_item_set_tooltip_markup($!ti, $markup);
  }

  method set_tooltip_text (gchar $text) {
    gtk_tool_item_set_tooltip_text($!ti, $text);
  }

  method toolbar_reconfigured {
    gtk_tool_item_toolbar_reconfigured($!ti);
  }
  # ↑↑↑↑ METHODS ↑↑↑↑

}
