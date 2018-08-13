use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::Entry;
use GTK::Raw::Types;

class GTK::Entry is GTK::Widget {
  also does GTK::Roles::Signals;

  has GtkEntry $!e;

  submethod BUILD(:$entry) {
    given $entry {
      when GtkEntry | GtkWidget {
        self.setWidget( nativecast(GtkWidget, $entry) );
      }
      when GTK::Entry {
      }
      default {
      }
    }
  }

  method new {
  }

  # ↓↓↓↓ ATTRIBUTES ↓↓↓↓
  method activates_default is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_entry_get_activates_default($!e);
      },
      STORE => sub ($, $setting is copy) {
        gtk_entry_set_activates_default($!e, $setting);
      }
    );
  }

  method alignment is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_entry_get_alignment($!e);
      },
      STORE => sub ($, $xalign is copy) {
        gtk_entry_set_alignment($!e, $xalign);
      }
    );
  }

  method attributes is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_entry_get_attributes($!e);
      },
      STORE => sub ($, $attrs is copy) {
        gtk_entry_set_attributes($!e, $attrs);
      }
    );
  }

  method buffer is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_entry_get_buffer($!e);
      },
      STORE => sub ($, $buffer is copy) {
        gtk_entry_set_buffer($!e, $buffer);
      }
    );
  }

  method completion is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_entry_get_completion($!e);
      },
      STORE => sub ($, $completion is copy) {
        gtk_entry_set_completion($!e, $completion);
      }
    );
  }

  method cursor_hadjustment is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_entry_get_cursor_hadjustment($!e);
      },
      STORE => sub ($, $adjustment is copy) {
        gtk_entry_set_cursor_hadjustment($!e, $adjustment);
      }
    );
  }

  method has_frame is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_entry_get_has_frame($!e);
      },
      STORE => sub ($, $setting is copy) {
        gtk_entry_set_has_frame($!e, $setting);
      }
    );
  }

  method inner_border is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_entry_get_inner_border($!e);
      },
      STORE => sub ($, $border is copy) {
        gtk_entry_set_inner_border($!e, $border);
      }
    );
  }

  method input_hints is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_entry_get_input_hints($!e);
      },
      STORE => sub ($, $hints is copy) {
        gtk_entry_set_input_hints($!e, $hints);
      }
    );
  }

  method input_purpose is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_entry_get_input_purpose($!e);
      },
      STORE => sub ($, $purpose is copy) {
        gtk_entry_set_input_purpose($!e, $purpose);
      }
    );
  }

  method max_length is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_entry_get_max_length($!e);
      },
      STORE => sub ($, $max is copy) {
        gtk_entry_set_max_length($!e, $max);
      }
    );
  }

  method max_width_chars is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_entry_get_max_width_chars($!e);
      },
      STORE => sub ($, $n_chars is copy) {
        gtk_entry_set_max_width_chars($!e, $n_chars);
      }
    );
  }

  method overwrite_mode is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_entry_get_overwrite_mode($!e);
      },
      STORE => sub ($, $overwrite is copy) {
        gtk_entry_set_overwrite_mode($!e, $overwrite);
      }
    );
  }

  method placeholder_text is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_entry_get_placeholder_text($!e);
      },
      STORE => sub ($, $text is copy) {
        gtk_entry_set_placeholder_text($!e, $text);
      }
    );
  }

  method progress_fraction is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_entry_get_progress_fraction($!e);
      },
      STORE => sub ($, $fraction is copy) {
        gtk_entry_set_progress_fraction($!e, $fraction);
      }
    );
  }

  method progress_pulse_step is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_entry_get_progress_pulse_step($!e);
      },
      STORE => sub ($, $fraction is copy) {
        gtk_entry_set_progress_pulse_step($!e, $fraction);
      }
    );
  }

  method tabs is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_entry_get_tabs($!e);
      },
      STORE => sub ($, $tabs is copy) {
        gtk_entry_set_tabs($!e, $tabs);
      }
    );
  }

  method text is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_entry_get_text($!e);
      },
      STORE => sub ($, $text is copy) {
        gtk_entry_set_text($!e, $text);
      }
    );
  }

  method visibility is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_entry_get_visibility($!e);
      },
      STORE => sub ($, $visible is copy) {
        gtk_entry_set_visibility($!e, $visible);
      }
    );
  }

  method width_chars is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_entry_get_width_chars($!e);
      },
      STORE => sub ($, $n_chars is copy) {
        gtk_entry_set_width_chars($!e, $n_chars);
      }
    );
  }

  # ↑↑↑↑ ATTRIBUTES ↑↑↑↑

  method get_current_icon_drag_source () {
    gtk_entry_get_current_icon_drag_source($!e);
  }

  method get_icon_activatable (GtkEntryIconPosition $icon_pos) {
    gtk_entry_get_icon_activatable($!e, $icon_pos);
  }

  method get_icon_area (GtkEntryIconPosition $icon_pos, GdkRectangle $icon_area) {
    gtk_entry_get_icon_area($!e, $icon_pos, $icon_area);
  }

  method get_icon_at_pos (gint $x, gint $y) {
    gtk_entry_get_icon_at_pos($!e, $x, $y);
  }

  method get_icon_gicon (GtkEntryIconPosition $icon_pos) {
    gtk_entry_get_icon_gicon($!e, $icon_pos);
  }

  method get_icon_name (GtkEntryIconPosition $icon_pos) {
    gtk_entry_get_icon_name($!e, $icon_pos);
  }

  method get_icon_pixbuf (GtkEntryIconPosition $icon_pos) {
    gtk_entry_get_icon_pixbuf($!e, $icon_pos);
  }

  method get_icon_sensitive (GtkEntryIconPosition $icon_pos) {
    gtk_entry_get_icon_sensitive($!e, $icon_pos);
  }

  method get_icon_stock (GtkEntryIconPosition $icon_pos) {
    gtk_entry_get_icon_stock($!e, $icon_pos);
  }

  method get_icon_storage_type (GtkEntryIconPosition $icon_pos) {
    gtk_entry_get_icon_storage_type($!e, $icon_pos);
  }

  method get_icon_tooltip_markup (GtkEntryIconPosition $icon_pos) {
    gtk_entry_get_icon_tooltip_markup($!e, $icon_pos);
  }

  method get_icon_tooltip_text (GtkEntryIconPosition $icon_pos) {
    gtk_entry_get_icon_tooltip_text($!e, $icon_pos);
  }

  method get_invisible_char () {
    gtk_entry_get_invisible_char($!e);
  }

  method get_layout () {
    gtk_entry_get_layout($!e);
  }

  method get_layout_offsets (gint $x, gint $y) {
    gtk_entry_get_layout_offsets($!e, $x, $y);
  }

  method get_text_area (GdkRectangle $text_area) {
    gtk_entry_get_text_area($!e, $text_area);
  }

  method get_text_length () {
    gtk_entry_get_text_length($!e);
  }

  method get_type () {
    gtk_entry_get_type($!e);
  }

  method grab_focus_without_selecting () {
    gtk_entry_grab_focus_without_selecting($!e);
  }

  method im_context_filter_keypress (GdkEventKey $event) {
    gtk_entry_im_context_filter_keypress($!e, $event);
  }

  method layout_index_to_text_index (gint $layout_index) {
    gtk_entry_layout_index_to_text_index($!e, $layout_index);
  }

  method new () {
    gtk_entry_new($!e);
  }

  method new_with_buffer () {
    gtk_entry_new_with_buffer($!e);
  }

  method progress_pulse () {
    gtk_entry_progress_pulse($!e);
  }

  method reset_im_context () {
    gtk_entry_reset_im_context($!e);
  }

  method set_icon_activatable (GtkEntryIconPosition $icon_pos, gboolean $activatable) {
    gtk_entry_set_icon_activatable($!e, $icon_pos, $activatable);
  }

  method set_icon_drag_source (GtkEntryIconPosition $icon_pos, GtkTargetList $target_list, GdkDragAction $actions) {
    gtk_entry_set_icon_drag_source($!e, $icon_pos, $target_list, $actions);
  }

  method set_icon_from_gicon (GtkEntryIconPosition $icon_pos, GIcon $icon) {
    gtk_entry_set_icon_from_gicon($!e, $icon_pos, $icon);
  }

  method set_icon_from_icon_name (GtkEntryIconPosition $icon_pos, gchar $icon_name) {
    gtk_entry_set_icon_from_icon_name($!e, $icon_pos, $icon_name);
  }

  method set_icon_from_pixbuf (GtkEntryIconPosition $icon_pos, GdkPixbuf $pixbuf) {
    gtk_entry_set_icon_from_pixbuf($!e, $icon_pos, $pixbuf);
  }

  method set_icon_from_stock (GtkEntryIconPosition $icon_pos, gchar $stock_id) {
    gtk_entry_set_icon_from_stock($!e, $icon_pos, $stock_id);
  }

  method set_icon_sensitive (GtkEntryIconPosition $icon_pos, gboolean $sensitive) {
    gtk_entry_set_icon_sensitive($!e, $icon_pos, $sensitive);
  }

  method set_icon_tooltip_markup (GtkEntryIconPosition $icon_pos, gchar $tooltip) {
    gtk_entry_set_icon_tooltip_markup($!e, $icon_pos, $tooltip);
  }

  method set_icon_tooltip_text (GtkEntryIconPosition $icon_pos, gchar $tooltip) {
    gtk_entry_set_icon_tooltip_text($!e, $icon_pos, $tooltip);
  }

  method text_index_to_layout_index (gint $text_index) {
    gtk_entry_text_index_to_layout_index($!e, $text_index);
  }

  method unset_invisible_char () {
    gtk_entry_unset_invisible_char($!e);
  }


}
