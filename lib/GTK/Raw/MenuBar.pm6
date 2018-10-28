use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::Types;

unit package GTK::Raw::MenuBar;

sub gtk_menu_bar_get_type ()
  returns GType
  is native($LIBGTK)
  is export
  { * }

sub gtk_menu_bar_new ()
  returns GtkWidget
  is native($LIBGTK)
  is export
  { * }

sub gtk_menu_bar_new_from_model (GMenuModel $model)
  returns GtkWidget
  is native($LIBGTK)
  is export
  { * }

sub gtk_menu_bar_get_child_pack_direction (GtkMenuBar $menubar)
  returns uint32 # GtkPackDirection
  is native($LIBGTK)
  is export
  { * }

sub gtk_menu_bar_get_pack_direction (GtkMenuBar $menubar)
  returns uint32 # GtkPackDirection
  is native($LIBGTK)
  is export
  { * }

sub gtk_menu_bar_set_child_pack_direction (
  GtkMenuBar $menubar,
  uint32 $child_pack_dir        # GtkPackDirection $child_pack_dir
)
  is native($LIBGTK)
  is export
  { * }

sub gtk_menu_bar_set_pack_direction (
  GtkMenuBar $menubar,
  uint32 $pack_dir              # GtkPackDirection $pack_dir
)
  is native($LIBGTK)
  is export
  { * }