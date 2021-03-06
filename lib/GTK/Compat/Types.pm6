use v6.c;

use nqp;
use NativeCall;

use Cairo;

use GTK::Roles::Pointers;

# Number of times I've had to force compile the whole project.
constant forced = 26;

our $DEBUG is export = 0;

unit package GTK::Compat::Types;

# Cribbed from https://github.com/CurtTilmes/perl6-dbmysql/blob/master/lib/DB/MySQL/Native.pm6
sub malloc  (size_t --> Pointer)                   is export is native {}
sub realloc (Pointer, size_t --> Pointer)          is export is native {}
sub calloc  (size_t, size_t --> Pointer)           is export is native {}
sub memcpy  (Pointer, Pointer ,size_t --> Pointer) is export is native {}
sub memset  (Pointer, int32, size_t)               is export is native {}

our proto sub free (|) is export { * }
multi sub free (Pointer)                           is export is native {}

# Cribbed from https://stackoverflow.com/questions/1281686/determine-size-of-dynamically-allocated-memory-in-c
sub malloc_usable_size (Pointer --> size_t)        is export is native {}

# Implement memcpy_pattern. Take pattern and write pattern.^elem bytes to successive areas in dest.

sub cast($cast-to, $obj) is export {
  nativecast($cast-to, $obj);
}

sub sprintf-vv(Blob, Str, & () --> int64)
  is native is symbol('sprintf') { * }

sub sprintf-vp(Blob, Str, & (Pointer) --> int64 )
  is native is symbol('sprintf') { * }

sub set_func_pointer(
  \func,
  &sprint = &sprintf-vv
) is export {
  my $buf = buf8.allocate(20);
  my $len = &sprint($buf, '%lld', func);
  Pointer.new( $buf.subbuf(^$len).decode.Int );
}

constant glib       is export = 'glib-2.0',v0;
constant gio        is export = 'gio-2.0',v0;
constant gobject    is export = 'gobject-2.0',v0;
constant cairo      is export = 'cairo',v2;
constant gdk        is export = 'gdk-3',v0;
constant gdk-pixbuf is export = 'gdk_pixbuf-2.0',v0;
constant gtk        is export = 'gtk-3',v0;

sub g_destroy_none(Pointer)
  is export
  { }

sub g_free (Pointer)
  is native(glib)
  is export
  { * }

class GError is repr('CStruct') does GTK::Roles::Pointers is export {
  has uint32        $.domain;
  has int32         $.code;
  has Str           $.message;
}

our $ERROR is export;

sub gerror is export {
  my $cge = CArray[Pointer[GError]].new;
  $cge[0] = Pointer[GError];
  $cge;
}

sub g_error_free(GError $err)
  is native(glib)
  is export
  { *  }

sub clear_error($error = $ERROR) is export {
  g_error_free($error) with $error;
  $ERROR = Nil;
}

sub set_error(CArray $e) is export {
  $ERROR = $e[0].deref with $e[0];
}

sub unstable_get_type($name, &sub, $n is rw, $t is rw) is export {
  return $t if ($n // 0) > 0;
  repeat {
    $t = &sub();
    die "{ $name }.get_type could not get stable result"
      if $n++ > 20;
  } until $t == &sub();
  $t;
}

constant GDK_MAX_TIMECOORD_AXES is export = 128;

constant cairo_t             is export := Cairo::cairo_t;
constant cairo_format_t      is export := Cairo::cairo_format_t;
constant cairo_pattern_t     is export := Cairo::cairo_pattern_t;
constant cairo_region_t      is export := Pointer;

constant gboolean            is export := uint32;
constant gchar               is export := Str;
constant gconstpointer       is export := Pointer;
constant gdouble             is export := num64;
constant gfloat              is export := num32;
constant gint                is export := int32;
constant gint8               is export := int8;
constant gint16              is export := int16;
constant gint32              is export := int32;
constant gint64              is export := int64;
constant glong               is export := int64;
constant goffset             is export := uint64;
constant gpointer            is export := Pointer;
constant gsize               is export := uint64;
constant gssize              is export := int64;
constant guchar              is export := Str;
constant gshort              is export := int8;
constant gushort             is export := uint8;
constant guint               is export := uint32;
constant guint8              is export := uint8;
constant guint16             is export := uint16;
constant guint32             is export := uint32;
constant guint64             is export := uint64;
constant gulong              is export := uint64;
constant gunichar            is export := uint32;
constant va_list             is export := Pointer;
constant time_t              is export := uint64;

# Function Pointers
constant GAsyncReadyCallback     is export := Pointer;
constant GBindingTransformFunc   is export := Pointer;
constant GCallback               is export := Pointer;
constant GCancellable            is export := Pointer;
constant GCompareDataFunc        is export := Pointer;
constant GCompareFunc            is export := Pointer;
constant GCopyFunc               is export := Pointer;
constant GClosureNotify          is export := Pointer;
constant GDestroyNotify          is export := Pointer;
constant GEqualFunc              is export := Pointer;
constant GFunc                   is export := Pointer;
constant GIOFunc                 is export := Pointer;
constant GLogFunc                is export := Pointer;
constant GLogWriterFunc          is export := Pointer;
constant GPrintFunc              is export := Pointer;
constant GSettingsBindGetMapping is export := Pointer;
constant GSettingsBindSetMapping is export := Pointer;
constant GSettingsGetMapping     is export := Pointer;
constant GSignalAccumulator      is export := Pointer;
constant GSignalEmissionHook     is export := Pointer;
constant GSignalCMarshaller      is export := Pointer;
constant GSignalCVaMarshaller    is export := Pointer;
constant GThreadFunc             is export := Pointer;

constant GDate                   is export := uint64;
constant GPid                    is export := gint;
constant GQuark                  is export := uint32;
constant GStrv                   is export := CArray[Str];
constant GTimeSpan               is export := int64;
constant GType                   is export := uint64;

constant GdkFilterFunc                  is export := Pointer;
constant GdkPixbufDestroyNotify         is export := Pointer;
constant GdkPixbufSaveFunc              is export := Pointer;
constant GdkSeatGrabPrepareFunc         is export := Pointer;
constant GdkWindowChildFunc             is export := Pointer;
constant GdkWindowInvalidateHandlerFunc is export := Pointer;
constant GdkWMFunction                  is export := Pointer;

class GTypeInstance is repr('CStruct') does GTK::Roles::Pointers is export { ... }

sub g_type_check_instance_is_a (
  GTypeInstance  $instance,
  GType          $iface_type
)
  returns uint32
  is native(gobject)
{ * }

sub real-resolve-uint64($v) is export {
  $v +& 0xffffffffffffffff;
}


class GTypeClass is repr('CStruct') does GTK::Roles::Pointers is export {
  has GType      $.g_type;
}
class GTypeInstance {
  has GTypeClass $.g_class;

  method checkType($compare_type) {
    my GType $ct = real-resolve-uint64($compare_type);
    self.g_class.defined ??
      $ct == self.g_class.g_type               !!
      g_type_check_instance_is_a(self, $ct) ;
  }

  method getType {
    self.g_class.g_type;
  }
}

# Used ONLY in those situations where cheating is just plain REQUIRED.
class GObjectStruct is repr('CStruct') does GTK::Roles::Pointers is export {
  HAS GTypeInstance  $.g_type_instance;
  has uint32         $.ref_count;
  has gpointer       $!qdata;

  method checkType ($compare_type) {
    self.g_type_instance.checkType($compare_type)
  }

  method getType {
    self.g_type_instance.getType
  }
}

class GList is repr('CStruct') does GTK::Roles::Pointers is export {
  has Pointer $!data;
  has GList   $.next;
  has GList   $.prev;

  method data is rw {
    Proxy.new:
      FETCH => -> $      { $!data },
      STORE => -> $, $nv {
        my $err = qq:to/DIE/.chomp;
          Cannot store { $nv.^name } values in a GList as they must be of{
          } CStruct or CPointer representation.
          DIE

        die $err unless $nv ~~ Pointer || $nv.REPR eq <CStruct CPointer>.any;

        nqp::bindattr(
          nqp::decont(self),
          GList,
          '$!data',
          nqp::decont( nativecast(Pointer, $nv) )
        )
      };
  }
}

class GPermission is repr('CStruct') does GTK::Roles::Pointers is export {
  has uint64 $.dummy1;
  has uint64 $.dummy2;
  has uint64 $.dummy3;
  has uint64 $.dummy4;
}

class GSList is repr('CStruct') does GTK::Roles::Pointers is export {
  has Pointer $!data;
  has GSList  $.next;
}

class GString is repr('CStruct') does GTK::Roles::Pointers is export {
  has Str     $.str;
  has uint64  $.len;              # NOTE: Should be processor wordsize, so using 64 bit.
  has uint64  $.allocated_len;    # NOTE: Should be processor wordsize, so using 64 bit.
}

class GTypeValueList is repr('CUnion') does GTK::Roles::Pointers is export {
  has int32	          $.v_int     is rw;
  has uint32          $.v_uint    is rw;
  has long            $.v_long    is rw;
  has ulong           $.v_ulong   is rw;
  has int64           $.v_int64   is rw;
  has uint64          $.v_uint64  is rw;
  has num32           $.v_float   is rw;
  has num64           $.v_double  is rw;
  has OpaquePointer   $.v_pointer is rw;
};

class GValue is repr('CStruct') does GTK::Roles::Pointers is export {
  has ulong           $.g_type is rw;
  HAS GTypeValueList  $.data1  is rw;
  HAS GTypeValueList  $.data2  is rw;
}

class GPtrArray is repr('CStruct') does GTK::Roles::Pointers is export {
  has CArray[Pointer] $.pdata;
  has guint           $.len;
}

class GSignalInvocationHint is repr('CStruct')
  does GTK::Roles::Pointers
  is export
{
  has guint   $.signal_id;
  has GQuark  $.detail;
  has guint32 $.run_type;             # GSignalFlags
}

class GSignalQuery is repr('CStruct') does GTK::Roles::Pointers is export {
  has guint          $.signal_id;
  has Str            $.signal_name;
  has GType          $.itype;
  has guint32        $.signal_flags;  # GSignalFlags
  has GType          $.return_type;
  has guint          $.n_params;
  has CArray[uint64] $.param_types;
}

class GLogField is repr('CStruct') does GTK::Roles::Pointers is export {
  has Str     $.key;
  has Pointer $.value;
  has int64   $.length;
}

class GPollFDNonWin is repr('CStruct') does GTK::Roles::Pointers is export {
  has gint	    $.fd;
  has gushort 	$.events;
  has gushort 	$.revents;
}
class GPollFDWin is repr('CStruct') does GTK::Roles::Pointers is export {
  has gushort 	$.events;
  has gushort 	$.revents;
}

constant GPollFD is export := GPollFDNonWin;

class GTimeVal is repr('CStruct') does GTK::Roles::Pointers is export {
  has glong $.tv_sec;
  has glong $.tv_usec;
};

class GValueArray is repr('CStruct') does GTK::Roles::Pointers is export {
  has guint    $.n_values;
  has gpointer $.values; # GValue *
};

our enum GTypeEnum is export (
  G_TYPE_INVALID   => 0,
  G_TYPE_NONE      => (1  +< 2),
  G_TYPE_INTERFACE => (2  +< 2),
  G_TYPE_CHAR      => (3  +< 2),
  G_TYPE_UCHAR     => (4  +< 2),
  G_TYPE_BOOLEAN   => (5  +< 2),
  G_TYPE_INT       => (6  +< 2),
  G_TYPE_UINT      => (7  +< 2),
  G_TYPE_LONG      => (8  +< 2),
  G_TYPE_ULONG     => (9  +< 2),
  G_TYPE_INT64     => (10 +< 2),
  G_TYPE_UINT64    => (11 +< 2),
  G_TYPE_ENUM      => (12 +< 2),
  G_TYPE_FLAGS     => (13 +< 2),
  G_TYPE_FLOAT     => (14 +< 2),
  G_TYPE_DOUBLE    => (15 +< 2),
  G_TYPE_STRING    => (16 +< 2),
  G_TYPE_POINTER   => (17 +< 2),
  G_TYPE_BOXED     => (18 +< 2),
  G_TYPE_PARAM     => (19 +< 2),
  G_TYPE_OBJECT    => (20 +< 2),
  G_TYPE_VARIANT   => (21 +< 2),

  G_TYPE_RESERVED_GLIB_FIRST => 22,
  G_TYPE_RESERVED_GLIB_LAST  => 31,
  G_TYPE_RESERVED_BSE_FIRST  => 32,
  G_TYPE_RESERVED_BSE_LAST   => 48,
  G_TYPE_RESERVED_USER_FIRST => 49
);

constant GTimeType is export  := guint;
our enum GTimeTypeEnum is export <
  G_TIME_TYPE_STANDARD
  G_TIME_TYPE_DAYLIGHT
  G_TIME_TYPE_UNIVERSAL
>;

# Uint32. Be careful not to conflate this with GVariantType which is a pointer!
our enum GVariantTypeEnum is export <
  G_VARIANT_CLASS_BOOLEAN
  G_VARIANT_CLASS_BYTE
  G_VARIANT_CLASS_INT16
  G_VARIANT_CLASS_UINT16
  G_VARIANT_CLASS_INT32
  G_VARIANT_CLASS_UINT32
  G_VARIANT_CLASS_INT64
  G_VARIANT_CLASS_UINT64
  G_VARIANT_CLASS_HANDLE
  G_VARIANT_CLASS_DOUBLE
  G_VARIANT_CLASS_STRING
  G_VARIANT_CLASS_OBJECT_PATH
  G_VARIANT_CLASS_SIGNATURE
  G_VARIANT_CLASS_VARIANT
  G_VARIANT_CLASS_MAYBE
  G_VARIANT_CLASS_ARRAY
  G_VARIANT_CLASS_TUPLE
  G_VARIANT_CLASS_DICT_ENTRY
>;

our enum GApplicationFlags is export (
  G_APPLICATION_FLAGS_NONE           => 0,
  G_APPLICATION_IS_SERVICE           => 1,
  G_APPLICATION_IS_LAUNCHER          => 2,
  G_APPLICATION_HANDLES_OPEN         => 4,
  G_APPLICATION_HANDLES_COMMAND_LINE => 8,
  G_APPLICATION_SEND_ENVIRONMENT     => 16,
  G_APPLICATION_NON_UNIQUE           => 32,
  G_APPLICATION_CAN_OVERRIDE_APP_ID  => 64
);

our enum GSettingsBindFlags is export (
  G_SETTINGS_BIND_DEFAULT        => 0,        # Assumption! See /usr/include/glib-2.0/gio/gsettings.h
  G_SETTINGS_BIND_GET            => 1,
  G_SETTINGS_BIND_SET            => 1 +< 1,
  G_SETTINGS_BIND_NO_SENSITIVITY => 1 +< 2,
  G_SETTINGS_BIND_GET_NO_CHANGES => 1 +< 3,
  G_SETTINGS_BIND_INVERT_BOOLEAN => 1 +< 4
);

our enum GBindingFlags is export (
  G_BINDING_DEFAULT        => 0,
  G_BINDING_BIDIRECTIONAL  => 1,
  G_BINDING_SYNC_CREATE    => 1 +< 1,
  G_BINDING_INVERT_BOOLEAN => 1 +< 2
);

our enum GNotificationPriority is export <
  G_NOTIFICATION_PRIORITY_NORMAL
  G_NOTIFICATION_PRIORITY_LOW
  G_NOTIFICATION_PRIORITY_HIGH
  G_NOTIFICATION_PRIORITY_URGENT
>;

our enum GIOChannelError is export <
  G_IO_CHANNEL_ERROR_FBIG
  G_IO_CHANNEL_ERROR_INVAL
  G_IO_CHANNEL_ERROR_IO
  G_IO_CHANNEL_ERROR_ISDIR
  G_IO_CHANNEL_ERROR_NOSPC
  G_IO_CHANNEL_ERROR_NXIO
  G_IO_CHANNEL_ERROR_OVERFLOW
  G_IO_CHANNEL_ERROR_PIPE
  G_IO_CHANNEL_ERROR_FAILED
>;

our enum GIOError is export <
  G_IO_ERROR_NONE
  G_IO_ERROR_AGAIN
  G_IO_ERROR_INVAL
  G_IO_ERROR_UNKNOWN
>;

our enum GIOStatus is export <
  G_IO_STATUS_ERROR
  G_IO_STATUS_NORMAL
  G_IO_STATUS_EOF
  G_IO_STATUS_AGAIN
>;

our enum GSeekType is export <
  G_SEEK_CUR
  G_SEEK_SET
  G_SEEK_END
>;

our enum GIOFlags is export (
  G_IO_FLAG_APPEND       => 1,
  G_IO_FLAG_NONBLOCK     => 2,
  G_IO_FLAG_IS_READABLE  => 1 +< 2,      # Read only flag
  G_IO_FLAG_IS_WRITABLE  => 1 +< 3,      # Read only flag
  G_IO_FLAG_IS_WRITEABLE => 1 +< 3,      # Misspelling in 2.29.10 and earlier
  G_IO_FLAG_IS_SEEKABLE  => 1 +< 4,      # Read only flag
  G_IO_FLAG_MASK         => (1 +< 5) - 1,
  G_IO_FLAG_GET_MASK     => (1 +< 5) - 1,
  G_IO_FLAG_SET_MASK     => 1 +| 2
);

# cw: These values are for LINUX!
our enum GIOCondition is export (
  G_IO_IN     => 1,
  G_IO_OUT    => 4,
  G_IO_PRI    => 2,
  G_IO_ERR    => 8,
  G_IO_HUP    => 16,
  G_IO_NVAL   => 32,
);

constant GChecksumType is export := guint;
our enum GChecksumTypeEnum is export <
  G_CHECKSUM_MD5,
  G_CHECKSUM_SHA1,
  G_CHECKSUM_SHA256,
  G_CHECKSUM_SHA512,
  G_CHECKSUM_SHA384
>;

# In the future, this mechanism may need to be used via BEGIN block for all
# enums that vary by OS -- Kaiepi++!
#
# my constant TheseChangeByOS = Metamodel::EnumHOW.new_type: :name<TheseChangeByOS>, :base_type(Int);
# TheseChangeByOS.^add_role: NumericEnumeration;
# TheseChangeByOS.^set_package: OUR
# TheseChangeByOS.^compose;
# if $*DISTRO.is-win {
#     TheseChangeByOS.^add_enum_value: 'a' => ...;
#     TheseChangeByOS.^add_enum_value: 'b' => ...;
#     TheseChangeByOS.^add_enum_value: 'c' => ...;
#     TheseChangeByOS.^add_enum_value: 'd' => ...;
# } else {
#     TheseChangeByOS.^add_enum_value: 'a' => ...;
#     TheseChangeByOS.^add_enum_value: 'b' => ...;
#     TheseChangeByOS.^add_enum_value: 'c' => ...;
#     TheseChangeByOS.^add_enum_value: 'd' => ...;
# }
# TheseChangeByOS.^compose_values;

our enum GdkDragAction is export (
  GDK_ACTION_DEFAULT => 1,
  GDK_ACTION_COPY    => 2,
  GDK_ACTION_MOVE    => (1 +< 2),
  GDK_ACTION_LINK    => (1 +< 3),
  GDK_ACTION_PRIVATE => (1 +< 4),
  GDK_ACTION_ASK     => (1 +< 5)
);

our enum GdkGravity is export (
  'GDK_GRAVITY_NORTH_WEST' => 1,
  'GDK_GRAVITY_NORTH',
  'GDK_GRAVITY_NORTH_EAST',
  'GDK_GRAVITY_WEST',
  'GDK_GRAVITY_CENTER',
  'GDK_GRAVITY_EAST',
  'GDK_GRAVITY_SOUTH_WEST',
  'GDK_GRAVITY_SOUTH',
  'GDK_GRAVITY_SOUTH_EAST',
  'GDK_GRAVITY_STATIC'
);

our enum GdkWindowTypeHint is export <
  GDK_WINDOW_TYPE_HINT_NORMAL
  GDK_WINDOW_TYPE_HINT_DIALOG
  GDK_WINDOW_TYPE_HINT_MENU
  GDK_WINDOW_TYPE_HINT_TOOLBAR
  GDK_WINDOW_TYPE_HINT_SPLASHSCREEN
  GDK_WINDOW_TYPE_HINT_UTILITY
  GDK_WINDOW_TYPE_HINT_DOCK
  GDK_WINDOW_TYPE_HINT_DESKTOP
  GDK_WINDOW_TYPE_HINT_DROPDOWN_MENU
  GDK_WINDOW_TYPE_HINT_POPUP_MENU
  GDK_WINDOW_TYPE_HINT_TOOLTIP
  GDK_WINDOW_TYPE_HINT_NOTIFICATION
  GDK_WINDOW_TYPE_HINT_COMBO
  GDK_WINDOW_TYPE_HINT_DND
>;

our enum GdkModifierType is export (
  GDK_SHIFT_MASK                 => 1,
  GDK_LOCK_MASK                  => 1 +< 1,
  GDK_CONTROL_MASK               => 1 +< 2,
  GDK_MOD1_MASK                  => 1 +< 3,
  GDK_MOD2_MASK                  => 1 +< 4,
  GDK_MOD3_MASK                  => 1 +< 5,
  GDK_MOD4_MASK                  => 1 +< 6,
  GDK_MOD5_MASK                  => 1 +< 7,
  GDK_BUTTON1_MASK               => 1 +< 8,
  GDK_BUTTON2_MASK               => 1 +< 9,
  GDK_BUTTON3_MASK               => 1 +< 10,
  GDK_BUTTON4_MASK               => 1 +< 11,
  GDK_BUTTON5_MASK               => 1 +< 12,

  GDK_MODIFIER_RESERVED_13_MASK  => 1 +< 13,
  GDK_MODIFIER_RESERVED_14_MASK  => 1 +< 14,
  GDK_MODIFIER_RESERVED_15_MASK  => 1 +< 15,
  GDK_MODIFIER_RESERVED_16_MASK  => 1 +< 16,
  GDK_MODIFIER_RESERVED_17_MASK  => 1 +< 17,
  GDK_MODIFIER_RESERVED_18_MASK  => 1 +< 18,
  GDK_MODIFIER_RESERVED_19_MASK  => 1 +< 19,
  GDK_MODIFIER_RESERVED_20_MASK  => 1 +< 20,
  GDK_MODIFIER_RESERVED_21_MASK  => 1 +< 21,
  GDK_MODIFIER_RESERVED_22_MASK  => 1 +< 22,
  GDK_MODIFIER_RESERVED_23_MASK  => 1 +< 23,
  GDK_MODIFIER_RESERVED_24_MASK  => 1 +< 24,
  GDK_MODIFIER_RESERVED_25_MASK  => 1 +< 25,

  GDK_SUPER_MASK                 => 1 +< 26,
  GDK_HYPER_MASK                 => 1 +< 27,
  GDK_META_MASK                  => 1 +< 28,

  GDK_MODIFIER_RESERVED_29_MASK  => 1 +< 29,

  GDK_RELEASE_MASK               => 1 +< 30,
  GDK_MODIFIER_MASK              => 0x5c001fff
);

our enum GdkEventMask is export (
  GDK_EXPOSURE_MASK             => 1,
  GDK_POINTER_MOTION_MASK       => 1 +< 2,
  GDK_POINTER_MOTION_HINT_MASK  => 1 +< 3,
  GDK_BUTTON_MOTION_MASK        => 1 +< 4,
  GDK_BUTTON1_MOTION_MASK       => 1 +< 5,
  GDK_BUTTON2_MOTION_MASK       => 1 +< 6,
  GDK_BUTTON3_MOTION_MASK       => 1 +< 7,
  GDK_BUTTON_PRESS_MASK         => 1 +< 8,
  GDK_BUTTON_RELEASE_MASK       => 1 +< 9,
  GDK_KEY_PRESS_MASK            => 1 +< 10,
  GDK_KEY_RELEASE_MASK          => 1 +< 11,
  GDK_ENTER_NOTIFY_MASK         => 1 +< 12,
  GDK_LEAVE_NOTIFY_MASK         => 1 +< 13,
  GDK_FOCUS_CHANGE_MASK         => 1 +< 14,
  GDK_STRUCTURE_MASK            => 1 +< 15,
  GDK_PROPERTY_CHANGE_MASK      => 1 +< 16,
  GDK_VISIBILITY_NOTIFY_MASK    => 1 +< 17,
  GDK_PROXIMITY_IN_MASK         => 1 +< 18,
  GDK_PROXIMITY_OUT_MASK        => 1 +< 19,
  GDK_SUBSTRUCTURE_MASK         => 1 +< 20,
  GDK_SCROLL_MASK               => 1 +< 21,
  GDK_TOUCH_MASK                => 1 +< 22,
  GDK_SMOOTH_SCROLL_MASK        => 1 +< 23,
  GDK_TOUCHPAD_GESTURE_MASK     => 1 +< 24,
  GDK_TABLET_PAD_MASK           => 1 +< 25,
  GDK_ALL_EVENTS_MASK           => 0x3FFFFFE
);

our enum GdkEventType is export (
  GDK_NOTHING             => -1,
  GDK_DELETE              => 0,
  GDK_DESTROY             => 1,
  GDK_EXPOSE              => 2,
  GDK_MOTION_NOTIFY       => 3,
  GDK_BUTTON_PRESS        => 4,
  GDK_2BUTTON_PRESS       => 5,
  GDK_DOUBLE_BUTTON_PRESS => 5,
  GDK_3BUTTON_PRESS       => 6,
  GDK_TRIPLE_BUTTON_PRESS => 6,
  GDK_BUTTON_RELEASE      => 7,
  GDK_KEY_PRESS           => 8,
  GDK_KEY_RELEASE         => 9,
  GDK_ENTER_NOTIFY        => 10,
  GDK_LEAVE_NOTIFY        => 11,
  GDK_FOCUS_CHANGE        => 12,
  GDK_CONFIGURE           => 13,
  GDK_MAP                 => 14,
  GDK_UNMAP               => 15,
  GDK_PROPERTY_NOTIFY     => 16,
  GDK_SELECTION_CLEAR     => 17,
  GDK_SELECTION_REQUEST   => 18,
  GDK_SELECTION_NOTIFY    => 19,
  GDK_PROXIMITY_IN        => 20,
  GDK_PROXIMITY_OUT       => 21,
  GDK_DRAG_ENTER          => 22,
  GDK_DRAG_LEAVE          => 23,
  GDK_DRAG_MOTION         => 24,
  GDK_DRAG_STATUS         => 25,
  GDK_DROP_START          => 26,
  GDK_DROP_FINISHED       => 27,
  GDK_CLIENT_EVENT        => 28,
  GDK_VISIBILITY_NOTIFY   => 29,
  GDK_SCROLL              => 31,
  GDK_WINDOW_STATE        => 32,
  GDK_SETTING             => 33,
  GDK_OWNER_CHANGE        => 34,
  GDK_GRAB_BROKEN         => 35,
  GDK_DAMAGE              => 36,
  GDK_TOUCH_BEGIN         => 37,
  GDK_TOUCH_UPDATE        => 38,
  GDK_TOUCH_END           => 39,
  GDK_TOUCH_CANCEL        => 40,
  GDK_TOUCHPAD_SWIPE      => 41,
  GDK_TOUCHPAD_PINCH      => 42,
  GDK_PAD_BUTTON_PRESS    => 43,
  GDK_PAD_BUTTON_RELEASE  => 44,
  GDK_PAD_RING            => 45,
  GDK_PAD_STRIP           => 46,
  GDK_PAD_GROUP_MODE      => 47,
  'GDK_EVENT_LAST'
);

our enum GdkWindowEdge is export <
  GDK_WINDOW_EDGE_NORTH_WEST
  GDK_WINDOW_EDGE_NORTH
  GDK_WINDOW_EDGE_NORTH_EAST
  GDK_WINDOW_EDGE_WEST
  GDK_WINDOW_EDGE_EAST
  GDK_WINDOW_EDGE_SOUTH_WEST
  GDK_WINDOW_EDGE_SOUTH
  GDK_WINDOW_EDGE_SOUTH_EAST
>;

our enum GTlsCertificateFlags is export (
  G_TLS_CERTIFICATE_UNKNOWN_CA    => (1 +< 0),
  G_TLS_CERTIFICATE_BAD_IDENTITY  => (1 +< 1),
  G_TLS_CERTIFICATE_NOT_ACTIVATED => (1 +< 2),
  G_TLS_CERTIFICATE_EXPIRED       => (1 +< 3),
  G_TLS_CERTIFICATE_REVOKED       => (1 +< 4),
  G_TLS_CERTIFICATE_INSECURE      => (1 +< 5),
  G_TLS_CERTIFICATE_GENERIC_ERROR => (1 +< 6),
  G_TLS_CERTIFICATE_VALIDATE_ALL  => 0x007f
);

our enum GdkCursorType is export (
  GDK_X_CURSOR            => 0,
  GDK_ARROW               => 2,
  GDK_BASED_ARROW_DOWN    => 4,
  GDK_BASED_ARROW_UP      => 6,
  GDK_BOAT                => 8,
  GDK_BOGOSITY            => 10,
  GDK_BOTTOM_LEFT_CORNER  => 12,
  GDK_BOTTOM_RIGHT_CORNER => 14,
  GDK_BOTTOM_SIDE         => 16,
  GDK_BOTTOM_TEE          => 18,
  GDK_BOX_SPIRAL          => 20,
  GDK_CENTER_PTR          => 22,
  GDK_CIRCLE              => 24,
  GDK_CLOCK               => 26,
  GDK_COFFEE_MUG          => 28,
  GDK_CROSS               => 30,
  GDK_CROSS_REVERSE       => 32,
  GDK_CROSSHAIR           => 34,
  GDK_DIAMOND_CROSS       => 36,
  GDK_DOT                 => 38,
  GDK_DOTBOX              => 40,
  GDK_DOUBLE_ARROW        => 42,
  GDK_DRAFT_LARGE         => 44,
  GDK_DRAFT_SMALL         => 46,
  GDK_DRAPED_BOX          => 48,
  GDK_EXCHANGE            => 50,
  GDK_FLEUR               => 52,
  GDK_GOBBLER             => 54,
  GDK_GUMBY               => 56,
  GDK_HAND1               => 58,
  GDK_HAND2               => 60,
  GDK_HEART               => 62,
  GDK_ICON                => 64,
  GDK_IRON_CROSS          => 66,
  GDK_LEFT_PTR            => 68,
  GDK_LEFT_SIDE           => 70,
  GDK_LEFT_TEE            => 72,
  GDK_LEFTBUTTON          => 74,
  GDK_LL_ANGLE            => 76,
  GDK_LR_ANGLE            => 78,
  GDK_MAN                 => 80,
  GDK_MIDDLEBUTTON        => 82,
  GDK_MOUSE               => 84,
  GDK_PENCIL              => 86,
  GDK_PIRATE              => 88,
  GDK_PLUS                => 90,
  GDK_QUESTION_ARROW      => 92,
  GDK_RIGHT_PTR           => 94,
  GDK_RIGHT_SIDE          => 96,
  GDK_RIGHT_TEE           => 98,
  GDK_RIGHTBUTTON         => 100,
  GDK_RTL_LOGO            => 102,
  GDK_SAILBOAT            => 104,
  GDK_SB_DOWN_ARROW       => 106,
  GDK_SB_H_DOUBLE_ARROW   => 108,
  GDK_SB_LEFT_ARROW       => 110,
  GDK_SB_RIGHT_ARROW      => 112,
  GDK_SB_UP_ARROW         => 114,
  GDK_SB_V_DOUBLE_ARROW   => 116,
  GDK_SHUTTLE             => 118,
  GDK_SIZING              => 120,
  GDK_SPIDER              => 122,
  GDK_SPRAYCAN            => 124,
  GDK_STAR                => 126,
  GDK_TARGET              => 128,
  GDK_TCROSS              => 130,
  GDK_TOP_LEFT_ARROW      => 132,
  GDK_TOP_LEFT_CORNER     => 134,
  GDK_TOP_RIGHT_CORNER    => 136,
  GDK_TOP_SIDE            => 138,
  GDK_TOP_TEE             => 140,
  GDK_TREK                => 142,
  GDK_UL_ANGLE            => 144,
  GDK_UMBRELLA            => 146,
  GDK_UR_ANGLE            => 148,
  GDK_WATCH               => 150,
  GDK_XTERM               => 152,
  GDK_LAST_CURSOR         => 153,
  GDK_BLANK_CURSOR        => -2,
  GDK_CURSOR_IS_PIXMAP    => -1
);

our enum GdkVisibilityState is export <
  GDK_VISIBILITY_UNOBSCURED
  GDK_VISIBILITY_PARTIAL
  GDK_VISIBILITY_FULLY_OBSCURED
>;

our enum GdkCrossingMode is export <
  GDK_CROSSING_NORMAL
  GDK_CROSSING_GRAB
  GDK_CROSSING_UNGRAB
  GDK_CROSSING_GTK_GRAB
  GDK_CROSSING_GTK_UNGRAB
  GDK_CROSSING_STATE_CHANGED
  GDK_CROSSING_TOUCH_BEGIN
  GDK_CROSSING_TOUCH_END
  GDK_CROSSING_DEVICE_SWITCH
>;

our enum GdkNotifyType is export (
  GDK_NOTIFY_ANCESTOR           => 0,
  GDK_NOTIFY_VIRTUAL            => 1,
  GDK_NOTIFY_INFERIOR           => 2,
  GDK_NOTIFY_NONLINEAR          => 3,
  GDK_NOTIFY_NONLINEAR_VIRTUAL  => 4,
  GDK_NOTIFY_UNKNOWN            => 5
);

our enum GdkWindowState is export (
  GDK_WINDOW_STATE_WITHDRAWN        => 1,
  GDK_WINDOW_STATE_ICONIFIED        => 1 +< 1,
  GDK_WINDOW_STATE_MAXIMIZED        => 1 +< 2,
  GDK_WINDOW_STATE_STICKY           => 1 +< 3,
  GDK_WINDOW_STATE_FULLSCREEN       => 1 +< 4,
  GDK_WINDOW_STATE_ABOVE            => 1 +< 5,
  GDK_WINDOW_STATE_BELOW            => 1 +< 6,
  GDK_WINDOW_STATE_FOCUSED          => 1 +< 7,
  GDK_WINDOW_STATE_TILED            => 1 +< 8,
  GDK_WINDOW_STATE_TOP_TILED        => 1 +< 9,
  GDK_WINDOW_STATE_TOP_RESIZABLE    => 1 +< 10,
  GDK_WINDOW_STATE_RIGHT_TILED      => 1 +< 11,
  GDK_WINDOW_STATE_RIGHT_RESIZABLE  => 1 +< 12,
  GDK_WINDOW_STATE_BOTTOM_TILED     => 1 +< 13,
  GDK_WINDOW_STATE_BOTTOM_RESIZABLE => 1 +< 14,
  GDK_WINDOW_STATE_LEFT_TILED       => 1 +< 15,
  GDK_WINDOW_STATE_LEFT_RESIZABLE   => 1 +< 16
);

our enum GKeyFileFlags is export (
  G_KEY_FILE_NONE              => 0,
  G_KEY_FILE_KEEP_COMMENTS     => 1,
  G_KEY_FILE_KEEP_TRANSLATIONS => 2
);

our enum GSignalFlags is export (
  G_SIGNAL_RUN_FIRST    => 1,
  G_SIGNAL_RUN_LAST     => 1 +< 1,
  G_SIGNAL_RUN_CLEANUP  => 1 +< 2,
  G_SIGNAL_NO_RECURSE   => 1 +< 3,
  G_SIGNAL_DETAILED     => 1 +< 4,
  G_SIGNAL_ACTION       => 1 +< 5,
  G_SIGNAL_NO_HOOKS     => 1 +< 6,
  G_SIGNAL_MUST_COLLECT => 1 +< 7,
  G_SIGNAL_DEPRECATED   => 1 +< 8
);

our enum GConnectFlags is export (
  G_CONNECT_AFTER       => 1,
  G_CONNECT_SWAPPED     => 2
);

our enum GSignalMatchType is export (
  G_SIGNAL_MATCH_ID        => 1,
  G_SIGNAL_MATCH_DETAIL    => 1 +< 1,
  G_SIGNAL_MATCH_CLOSURE   => 1 +< 2,
  G_SIGNAL_MATCH_FUNC      => 1 +< 3,
  G_SIGNAL_MATCH_DATA      => 1 +< 4,
  G_SIGNAL_MATCH_UNBLOCKED => 1 +< 5
);

our constant G_SIGNAL_MATCH_MASK is export = 0x3f;

our enum GSourceReturn is export <
  G_SOURCE_REMOVE
  G_SOURCE_CONTINUE
>;

our enum GLogLevelFlags is export (
  # log flags
  G_LOG_FLAG_RECURSION          => 1,
  G_LOG_FLAG_FATAL              => 1 +< 1,

  # GLib log levels */>
  G_LOG_LEVEL_ERROR             => 1 +< 2,       # always fatal
  G_LOG_LEVEL_CRITICAL          => 1 +< 3,
  G_LOG_LEVEL_WARNING           => 1 +< 4,
  G_LOG_LEVEL_MESSAGE           => 1 +< 5,
  G_LOG_LEVEL_INFO              => 1 +< 6,
  G_LOG_LEVEL_DEBUG             => 1 +< 7,

  G_LOG_LEVEL_MASK              => 0xfffffffc   # ~(G_LOG_FLAG_RECURSION | G_LOG_FLAG_FATAL)
);

our enum GLogWriterOutput is export (
  G_LOG_WRITER_UNHANDLED => 0,
  G_LOG_WRITER_HANDLED   => 1,
);

our enum GOnceStatus is export <
  G_ONCE_STATUS_NOTCALLED
  G_ONCE_STATUS_PROGRESS
  G_ONCE_STATUS_READY
>;

our enum GPriority is export (
  G_PRIORITY_HIGH         => -100,
  G_PRIORITY_DEFAULT      => 0,
  G_PRIORITY_HIGH_IDLE    => 100,
  G_PRIORITY_DEFAULT_IDLE => 200,
  G_PRIORITY_LOW          => 300
);

class cairo_font_options_t  is repr('CPointer') is export does GTK::Roles::Pointers { }
class cairo_surface_t       is repr('CPointer') is export does GTK::Roles::Pointers { }

class AtkObject             is repr('CPointer') is export does GTK::Roles::Pointers { }

class GAction               is repr('CPointer') is export does GTK::Roles::Pointers { }
class GActionGroup          is repr('CPointer') is export does GTK::Roles::Pointers { }
class GActionMap            is repr('CPointer') is export does GTK::Roles::Pointers { }
class GAppInfo              is repr('CPointer') is export does GTK::Roles::Pointers { }
class GAppInfoMonitor       is repr('CPointer') is export does GTK::Roles::Pointers { }
class GAppLaunchContext     is repr('CPointer') is export does GTK::Roles::Pointers { }
class GApplication          is repr('CPointer') is export does GTK::Roles::Pointers { }
class GAsyncResult          is repr('CPointer') is export does GTK::Roles::Pointers { }
class GBinding              is repr('CPointer') is export does GTK::Roles::Pointers { }
class GBookmarkFile         is repr('CPointer') is export does GTK::Roles::Pointers { }
class GByteArray            is repr('CPointer') is export does GTK::Roles::Pointers { }
class GBytes                is repr('CPointer') is export does GTK::Roles::Pointers { }
class GChecksum             is repr('CPointer') is export does GTK::Roles::Pointers { }
class GClosure              is repr('CPointer') is export does GTK::Roles::Pointers { }
class GDateTime             is repr('CPointer') is export does GTK::Roles::Pointers { }
class GFile                 is repr('CPointer') is export does GTK::Roles::Pointers { }
class GFileAttributeInfo    is repr('CPointer') is export does GTK::Roles::Pointers { }
class GFileInfo             is repr('CPointer') is export does GTK::Roles::Pointers { }
class GFileEnumerator       is repr('CPointer') is export does GTK::Roles::Pointers { }
class GFileInputStream      is repr('CPointer') is export does GTK::Roles::Pointers { }
class GFileIOStream         is repr('CPointer') is export does GTK::Roles::Pointers { }
class GFileMonitor          is repr('CPointer') is export does GTK::Roles::Pointers { }
class GFileOutputStream     is repr('CPointer') is export does GTK::Roles::Pointers { }
class GHmac                 is repr('CPointer') is export does GTK::Roles::Pointers { }
class GHashTable            is repr('CPointer') is export does GTK::Roles::Pointers { }
class GHashTableIter        is repr('CPointer') is export does GTK::Roles::Pointers { }
class GIcon                 is repr('CPointer') is export does GTK::Roles::Pointers { }
class GInputStream          is repr('CPointer') is export does GTK::Roles::Pointers { }
class GIOChannel            is repr('CPointer') is export does GTK::Roles::Pointers { }
class GKeyFile              is repr('CPointer') is export does GTK::Roles::Pointers { }
class GListModel            is repr('CPointer') is export does GTK::Roles::Pointers { }
class GLoadableIcon         is repr('CPointer') is export does GTK::Roles::Pointers { }
class GMainContext          is repr('CPointer') is export does GTK::Roles::Pointers { }
class GMainLoop             is repr('CPointer') is export does GTK::Roles::Pointers { }
class GMarkupParser         is repr('CPointer') is export does GTK::Roles::Pointers { }
class GMenu                 is repr('CPointer') is export does GTK::Roles::Pointers { }
class GMenuItem             is repr('CPointer') is export does GTK::Roles::Pointers { }
class GMenuAttributeIter    is repr('CPointer') is export does GTK::Roles::Pointers { }
class GMenuLinkIter         is repr('CPointer') is export does GTK::Roles::Pointers { }
class GMenuModel            is repr('CPointer') is export does GTK::Roles::Pointers { }
class GMount                is repr('CPointer') is export does GTK::Roles::Pointers { }
class GMountOperation       is repr('CPointer') is export does GTK::Roles::Pointers { }
class GMutex                is repr('CPointer') is export does GTK::Roles::Pointers { }
class GNotification         is repr('CPointer') is export does GTK::Roles::Pointers { }
class GObject               is repr('CPointer') is export does GTK::Roles::Pointers { }
class GOptionEntry          is repr('CPointer') is export does GTK::Roles::Pointers { }
class GOptionGroup          is repr('CPointer') is export does GTK::Roles::Pointers { }
class GOutputStream         is repr('CPointer') is export does GTK::Roles::Pointers { }
class GParamSpec            is repr('CPointer') is export does GTK::Roles::Pointers { }
class GPrivate              is repr('CPointer') is export does GTK::Roles::Pointers { }
class GPropertyAction       is repr('CPointer') is export does GTK::Roles::Pointers { }
class GRand                 is repr('CPointer') is export does GTK::Roles::Pointers { }
class GRWLock               is repr('CPointer') is export does GTK::Roles::Pointers { }
class GSettings             is repr('CPointer') is export does GTK::Roles::Pointers { }
class GSettingsBackend      is repr('CPointer') is export does GTK::Roles::Pointers { }
class GSettingsSchema       is repr('CPointer') is export does GTK::Roles::Pointers { }
class GSettingsSchemaKey    is repr('CPointer') is export does GTK::Roles::Pointers { }
class GSettingsSchemaSource is repr('CPointer') is export does GTK::Roles::Pointers { }
class GSimpleAction         is repr('CPointer') is export does GTK::Roles::Pointers { }
class GSimpleActionGroup    is repr('CPointer') is export does GTK::Roles::Pointers { }
class GSliceConfig          is repr('CPointer') is export does GTK::Roles::Pointers { }
class GSource               is repr('CPointer') is export does GTK::Roles::Pointers { }
class GTlsCertificate       is repr('CPointer') is export does GTK::Roles::Pointers { }
class GThread               is repr('CPointer') is export does GTK::Roles::Pointers { }
class GThreadPool           is repr('CPointer') is export does GTK::Roles::Pointers { }
class GTimer                is repr('CPointer') is export does GTK::Roles::Pointers { }
class GTimeZone             is repr('CPointer') is export does GTK::Roles::Pointers { }
class GVariant              is repr('CPointer') is export does GTK::Roles::Pointers { }
class GVariantBuilder       is repr('CPointer') is export does GTK::Roles::Pointers { }
class GVariantDict          is repr('CPointer') is export does GTK::Roles::Pointers { }
class GVariantIter          is repr('CPointer') is export does GTK::Roles::Pointers { }
class GVariantType          is repr('CPointer') is export does GTK::Roles::Pointers { }
class GVolume               is repr('CPointer') is export does GTK::Roles::Pointers { }

class GFileAttributeInfoList is repr('CStruct') does GTK::Roles::Pointers is export {
  has GFileAttributeInfo $.infos;
  has gint               $.n_infos;
}

sub sprintf-a(Blob, Str, & (GSimpleAction, GVariant, gpointer) --> int64)
    is native is symbol('sprintf') {}

class GActionEntry is repr('CStruct') does GTK::Roles::Pointers is export {
  has Str     $.name;
  has Pointer $.activate;
  has Str     $.parameter_type;
  has Str     $.state;
  has Pointer $.change_state;

  # Padding  - Not accessible
  has uint64  $!pad1;
  has uint64  $!pad2;
  has uint64  $!pad3;

  submethod BUILD (
    :$name,
    :$activate,
    :$parameter_type,
    :$state,
    :$change_state
  ) {
    self.name           = $name;
    self.parameter_type = $parameter_type;
    self.state          = $state;
    self.activate       = $activate     if $activate.defined;
    self.change_state   = $change_state if $change_state.defined
  }

  method change_state is rw {
    Proxy.new:
      FETCH => -> $        { $!activate },
      STORE => -> $, \func {
        $!change_state := set_func_pointer( &(func), &sprintf-a )
      };
  }

  method name is rw {
    Proxy.new:
      FETCH => -> $ { $.name },
      STORE => -> $, Str() $val {
        nqp::bindattr(
          nqp::decont(self),
          GActionEntry,
          '$!name',
          nqp::decont( $val )
        );
      }
  }

  method parameter_type is rw {
    Proxy.new:
      FETCH => -> $ { $.parameter_type },
      STORE => -> $, Str() $val {
        nqp::bindattr(
          nqp::decont(self),
          GActionEntry,
          '$!parameter_type',
          nqp::decont( $val )
        );
      }
  }

  method state is rw {
    Proxy.new:
      FETCH => -> $ { $.state },
      STORE => -> $, Str() $val {
        nqp::bindattr(
          nqp::decont(self),
          GActionEntry,
          '$!state',
          nqp::decont( $val )
        );
      }
  }

  method new (
    $name,
    $activate       = Pointer,
    $state          = Str,
    $parameter_type = Str,
    $change_state   = Pointer
  ) {
    self.bless(:$name, :$activate, :$parameter_type, :$state, :$change_state);
  }

}

class GOnce                is repr('CStruct') does GTK::Roles::Pointers is export {
  has guint    $.status;    # GOnceStatus
  has gpointer $.retval;
};

class GRecMutex            is repr('CStruct') does GTK::Roles::Pointers is export {
  # Private
  has gpointer $!p;
  has uint64   $!i    # guint i[2];
}

class GCond                is repr('CStruct') does GTK::Roles::Pointers is export {
  # Private
  has gpointer $!p;
  has uint64   $!i    # guint i[2];
}


sub sprintf-b(
  Blob,
  Str,
  & (gpointer, GSource, & (gpointer --> guint32),
  gpointer
) --> int64)
    is native is symbol('sprintf') {}

class GSourceCallbackFuncs is repr('CStruct') does GTK::Roles::Pointers is export {
  has Pointer $!ref,   # (gpointer     cb_data);
  has Pointer $!unref, # (gpointer     cb_data);
  has Pointer $!get,   # (gpointer     cb_data,
                       #  GSource     *source,
                       #  GSourceFunc *func,
                       #  gpointer    *data);

   submethod BUILD (:$ref, :$unref, :$get) {
     self.ref   = $ref   if $ref.defined;
     self.unref = $unref if $unref.defined;
     self.get   = $get   if $get.defined;
   }

  method ref is rw {
    Proxy.new:
      FETCH => -> $        { $!ref },
      STORE => -> $, \func {
        $!ref := set_func_pointer( &(func), &sprintf-vp )
      };
  }

  method unref is rw {
    Proxy.new:
      FETCH => -> $        { $!unref },
      STORE => -> $, \func {
        $!unref := set_func_pointer( &(func), &sprintf-vp )
      };
  }

  method get is rw {
    Proxy.new:
      FETCH => -> $        { $!get },
      STORE => -> $, \func {
        $!get := set_func_pointer( &(func), &sprintf-b )
      };
  }
};

sub sprintf-bp (
  Blob,
  Str,
  & (gpointer --> gboolean),
  gpointer
  --> int64
)
    is native is symbol('sprintf') { * }

sub sprintf-c (
  Blob,
  Str,
  & (GSource, gint --> gboolean),
  gpointer
 --> int64
)
    is native is symbol('sprintf') { * }


sub sprintf-d (
  Blob,
  Str,
  & (GSource, & (gpointer --> gboolean), gint --> gboolean),
  gpointer
  --> int64
)
    is native is symbol('sprintf') { * }

class GSourceFuncs is repr('CStruct') does GTK::Roles::Pointers is export {
  has Pointer $!prepare;     # (GSource    *source,
                             #  gint       *timeout);
  has Pointer $!check;       # (GSource    *source);
  has Pointer $!dispatch;    # (GSource    *source,
                             #  GSourceFunc callback,
                             #  gpointer    user_data);
  has Pointer $!finalize;    # (GSource    *source); /* Can be NULL */

  sub cd-default (GSource --> gboolean) { 1 };

  submethod BUILD (
    :$prepare   = -> GSource, gint $t is rw             --> gboolean { $t = 0;
                                                                       1 },
    :$check     = &cd-default,
    :$dispatch,
    :$finalize  = &cd-default
  ) {
    self.prepare  = $prepare;
    self.check    = $check;
    self.dispatch = $dispatch;
    self.finalize = $finalize;
  }

  method prepare is rw {
    Proxy.new:
      FETCH => -> $ { $!prepare },
      STORE => -> $, \func {
        $!prepare := set_func_pointer( &(func), &sprintf-c);
      };
  }

  method check is rw {
    Proxy.new:
      FETCH => -> $ { $!check },
      STORE => -> $, \func {
        $!check := set_func_pointer( &(func), &sprintf-bp);
      }
  }

  method dispatch is rw {
    Proxy.new:
      FETCH => -> $ { $!dispatch },
      STORE => -> $, \func {
        $!dispatch := set_func_pointer( &(func), &sprintf-d);
      }
  }

  method finalize is rw {
    Proxy.new:
      FETCH => -> $ { $!finalize },
      STORE => -> $, \func {
        $!finalize := set_func_pointer( &(func), &sprintf-vp);
      }
  }

  method size-of (GSourceFuncs:U:) { return nativesizeof(GSourceFuncs) }

};

class GdkAppLaunchContext    is repr('CPointer') is export does GTK::Roles::Pointers { }
class GdkAtom                is repr('CPointer') is export does GTK::Roles::Pointers { }
class GdkCursor              is repr('CPointer') is export does GTK::Roles::Pointers { }
class GdkDevice              is repr('CPointer') is export does GTK::Roles::Pointers { }
class GdkDeviceManager       is repr('CPointer') is export does GTK::Roles::Pointers { }
class GdkDeviceTool          is repr('CPointer') is export does GTK::Roles::Pointers { }
class GdkDisplay             is repr('CPointer') is export does GTK::Roles::Pointers { }
class GdkDisplayManager      is repr('CPointer') is export does GTK::Roles::Pointers { }
class GdkDragContext         is repr('CPointer') is export does GTK::Roles::Pointers { }
class GdkDrawingContext      is repr('CPointer') is export does GTK::Roles::Pointers { }
class GdkEventSequence       is repr('CPointer') is export does GTK::Roles::Pointers { }
class GdkFrameClock          is repr('CPointer') is export does GTK::Roles::Pointers { }
class GdkFrameTimings        is repr('CPointer') is export does GTK::Roles::Pointers { }
class GdkGLContext           is repr('CPointer') is export does GTK::Roles::Pointers { }
class GdkKeymap              is repr('CPointer') is export does GTK::Roles::Pointers { }
class GdkMonitor             is repr('CPointer') is export does GTK::Roles::Pointers { }
class GdkPixbuf              is repr('CPointer') is export does GTK::Roles::Pointers { }
class GdkPixbufAnimation     is repr('CPointer') is export does GTK::Roles::Pointers { }
class GdkPixbufAnimationIter is repr('CPointer') is export does GTK::Roles::Pointers { }
class GdkScreen              is repr('CPointer') is export does GTK::Roles::Pointers { }
class GdkSeat                is repr('CPointer') is export does GTK::Roles::Pointers { }
class GdkStyleProvider       is repr('CPointer') is export does GTK::Roles::Pointers { }
class GdkVisual              is repr('CPointer') is export does GTK::Roles::Pointers { }
class GdkWindow              is repr('CPointer') is export does GTK::Roles::Pointers { }

sub gdk_atom_name(GdkAtom)
  returns Str
  is native(gdk)
  is export
  { * }

class GdkColor is repr('CStruct') does GTK::Roles::Pointers is export {
  has guint   $.pixel;
  has guint16 $.red;
  has guint16 $.green;
  has guint16 $.blue;
}

class GdkEventAny is repr('CStruct') does GTK::Roles::Pointers is export {
  has uint32       $.type;              # GdkEventType
  has GdkWindow    $.window;
  has int8         $.send_event;
}

constant GdkEvent is export := GdkEventAny;

class GdkGeometry is repr('CStruct') does GTK::Roles::Pointers is export {
  has gint       $.min_width;
  has gint       $.min_height;
  has gint       $.max_width;
  has gint       $.max_height;
  has gint       $.base_width;
  has gint       $.base_height;
  has gint       $.width_inc;
  has gint       $.height_inc;
  has gdouble    $.min_aspect;
  has gdouble    $.max_aspect;
  has guint      $.win_gravity;         # GdkGravity
}

class GdkRectangle is repr('CStruct') does GTK::Roles::Pointers is export {
  has gint $.x is rw;
  has gint $.y is rw;
  has gint $.width is rw;
  has gint $.height is rw;
}

class GdkPoint is repr('CStruct') does GTK::Roles::Pointers is export {
  has gint $.x is rw;
  has gint $.y is rw;
}

class GdkEventKey is repr('CStruct') does GTK::Roles::Pointers is export {
  has uint32       $.type;              # GdkEventType
  has GdkWindow    $.window;
  has int8         $.send_event;
  has uint32       $.time;
  has uint32       $.state;
  has uint32       $.keyval;
  has int32        $.length;
  has Str          $.string;
  has uint16       $.hardware_keycode;
  has uint8        $.group;
  has uint32       $.is_modifier;
}

class GdkEventButton is repr('CStruct') does GTK::Roles::Pointers is export {
  has uint32         $.type;            # GdkEventType
  has GdkWindow      $.window;
  has int8           $.send_event;
  has guint32        $.time;
  has gdouble        $.x;
  has gdouble        $.y;
  has gdouble        $.axes is rw;
  has guint          $.state;
  has guint          $.button;
  has GdkDevice      $.device;
  has gdouble        $.x_root;
  has gdouble        $.y_root;
}

class GdkEventExpose is repr('CStruct') does GTK::Roles::Pointers is export {
  has uint32         $.type;            # GdkEventType
  has GdkWindow      $.window;
  has int8           $.send_event;
  has GdkRectangle   $.area;
  has cairo_region_t $.region;
  has int32          $.count;
}

class GdkEventCrossing is repr('CStruct')
  does GTK::Roles::Pointers
  is export
{
  has uint32         $.type;            # GdkEventType
  has GdkWindow      $.window;
  has int8           $.send_event;
  has GdkWindow      $.subwindow;
  has uint32         $.time;
  has num64          $.x;
  has num64          $.y;
  has num64          $.x_root;
  has num64          $.y_root;
  has uint32         $.mode;            # GdkCrossingMode
  has uint32         $.detail;          # GdkNotifyType
  has gboolean       $.focus;
  has guint          $.state;
}

class GdkEventFocus is repr('CStruct') does GTK::Roles::Pointers is export {
  has uint32         $.type;            # GdkEventType
  has GdkWindow      $.window;
  has int8           $.send_event;
  has int16          $.in;
}

class GdkEventConfigure is repr('CStruct')
  does GTK::Roles::Pointers
  is export
{
  has uint32         $.type;            # GdkEventType
  has GdkWindow      $.window;
  has int8           $.send_event;
  has int32          $.x;
  has int32          $.y;
  has int32          $.width;
  has int32          $.height;
}

class GdkEventProperty is repr('CStruct')
  does GTK::Roles::Pointers
  is export
{
  has uint32         $.type;            # GdkEventType
  has GdkWindow      $.window;
  has int8           $.send_event;
  has GdkAtom        $.atom;
  has uint32         $.time;
  has uint32         $.state;
}

class GdkEventSelection is repr('CStruct')
  does GTK::Roles::Pointers
  is export
{
  has uint32         $.type;            # GdkEventType
  has GdkWindow      $.window;
  has int8           $.send_event;
  has GdkAtom        $.selection;
  has GdkAtom        $.target;
  has GdkAtom        $.property;
  has uint32         $.time;
  has GdkWindow      $.requestor;
}

class GdkEventDnD is repr('CStruct')
  does GTK::Roles::Pointers
  is export
{
  has uint32         $.type;            # GdkEventType
  has GdkWindow      $.window;
  has int8           $.send_event;
  has GdkDragContext $.context;
  has uint32         $.time;
  has int16          $.x_root;
  has int16          $.y_root;
}

class GdkEventProximity is repr('CStruct')
  does GTK::Roles::Pointers
  is export
{
  has uint32         $.type;            # GdkEventType
  has GdkWindow      $.window;
  has int8           $.send_event;
  has uint32         $.time;
  has GdkDevice      $.device;
}

class GdkEventWindowState is repr('CStruct')
  does GTK::Roles::Pointers
  is export
{
  has uint32         $.type;            # GdkEventType
  has GdkWindow      $.window;
  has int8           $.send_event;
  has uint32         $.changed_mask;
  has uint32         $.new_window_state;
}

class GdkEventSetting is repr('CStruct')
  does GTK::Roles::Pointers
  is export
{
  has uint32         $.type;            # GdkEventType
  has GdkWindow      $.window;
  has int8           $.send_event;
  has uint32         $.action;
  has Str            $.name;
}

class GdkEventOwnerChange is repr('CStruct')
  does GTK::Roles::Pointers
  is export
{
  has uint32         $.type;            # GdkEventType
  has GdkWindow      $.window;
  has int8           $.send_event;
  has GdkWindow      $.owner;
  has uint32         $.reason;          # GdkOwnerChange
  has GdkAtom        $.selection;
  has uint32         $.time;
  has uint32         $.selection_time;
}

class GdkEventMotion is repr('CStruct')
  does GTK::Roles::Pointers
  is export
{
  has uint32         $.type;            # GdkEventType
  has GdkWindow      $.window;
  has int8           $.send_event;
  has guint32        $.time;
  has gdouble        $.x;
  has gdouble        $.y;
  has gdouble        $.axes;
  has guint          $.state;
  has gint16         $.is_hint;
  has GdkDevice      $.device;
  has gdouble        $.x_root;
  has gdouble        $.y_root;
}

class GdkEventGrabBroken is repr('CStruct')
  does GTK::Roles::Pointers
  is export
{
  has uint32         $.type;            # GdkEventType
  has GdkWindow      $.window;
  has int8           $.send_event;
  has gboolean       $.keyboard;
  has gboolean       $.implicit;
  has GdkWindow      $.grab_window;
}

# class GdkEventTouchpadSwipe
# class GdkEventTouchpadPinch
# class GdkEventPadButton
# class GdkEventPadAxis
# class GdkEventPadGroupMode

our subset GdkEvents is export where
  GdkEventAny        | GdkEventButton      | GdkEventExpose    |
  GdkEventDnD        | GdkEventProperty    | GdkEventFocus     |
  GdkEventSetting    | GdkEventProximity   | GdkEventSelection |
  GdkEventConfigure  | GdkEventWindowState | GdkEventCrossing  |
  GdkEventGrabBroken | GdkEventOwnerChange | GdkEventMotion    |
  GdkEventKey;

class GdkWindowAttr is repr('CStruct')
  does GTK::Roles::Pointers
  is export
{
  has Str       $.title             is rw;
  has gint      $.event_mask        is rw;
  has gint      $.x                 is rw;
  has gint      $.y                 is rw;
  has gint      $.width             is rw;
  has gint      $.height            is rw;
  has uint32    $.wclass            is rw;    # GdkWindowWindowClass
  has GdkVisual $!visual                 ;
  has uint32    $.window_type       is rw;    # GdkWindowType
  has GdkCursor $.cursor            is rw;
  has Str       $.wmclass_name;
  has Str       $.wmclass_class;
  has gboolean  $.override_redirect is rw;
  has uint32    $.type_hint         is rw;    # GdkWindowTypeHint

  method cursor is rw {
		Proxy.new:
			FETCH => -> $ { $.cursor },
			STORE => -> $, GdkCursor() $val {
				nqp::bindattr(
				nqp::decont(self),
  				GdkWindowAttr,
  				'$!cursor',
  				nqp::decont( $val )
  			);
      }
	}

  method wmclass_name is rw {
		Proxy.new:
			FETCH => -> $ { $.wmclass_name },
			STORE => -> $, Str() $val {
				nqp::bindattr(
  				nqp::decont(self),
  				GdkWindowAttr,
  				'$!wmclass_name',
  				nqp::decont( $val )
  			);
      }
	}

  method wmclass_class is rw {
    Proxy.new:
      FETCH => -> $ { $.label_name },
      STORE => -> $, Str() $val {
        nqp::bindattr(
          nqp::decont(self),
          GdkWindowAttr,
          '$!wmclass_class',
          nqp::decont( $val )
        );
      }
  }

  method visual is rw {
    Proxy.new:
      FETCH => -> $ { $!visual },
      STORE => -> $, Str() $new {
        nqp::bindattr(
          nqp::decont(self),
          GdkWindowAttr,
          '$!visual',
          nqp::decont($new)
        );
      }
  }

}

class GArray is repr('CStruct') does GTK::Roles::Pointers is export {
  has Str    $.data;
  has uint32 $.len;
}

class GdkTimeCoord is repr('CStruct') does GTK::Roles::Pointers is export {
  has uint32        $.time;
  has CArray[num64] $.axes;
}

class GdkKeymapKey is repr('CStruct') does GTK::Roles::Pointers is export {
  has guint $.keycode;
  has gint  $.group;
  has gint  $.level;
}

our enum GdkWindowWindowClass is export (
  'GDK_INPUT_OUTPUT',             # nick=input-output
  'GDK_INPUT_ONLY'                # nick=input-only
);

our enum GdkWindowHints is export (
  GDK_HINT_POS         => 1,
  GDK_HINT_MIN_SIZE    => 1 +< 1,
  GDK_HINT_MAX_SIZE    => 1 +< 2,
  GDK_HINT_BASE_SIZE   => 1 +< 3,
  GDK_HINT_ASPECT      => 1 +< 4,
  GDK_HINT_RESIZE_INC  => 1 +< 5,
  GDK_HINT_WIN_GRAVITY => 1 +< 6,
  GDK_HINT_USER_POS    => 1 +< 7,
  GDK_HINT_USER_SIZE   => 1 +< 8
);

our enum GdkWMDecoration is export (
  GDK_DECOR_ALL         => 1,
  GDK_DECOR_BORDER      => 1 +< 1,
  GDK_DECOR_RESIZEH     => 1 +< 2,
  GDK_DECOR_TITLE       => 1 +< 3,
  GDK_DECOR_MENU        => 1 +< 4,
  GDK_DECOR_MINIMIZE    => 1 +< 5,
  GDK_DECOR_MAXIMIZE    => 1 +< 6
);

our enum GdkWindowType is export <
  GDK_WINDOW_ROOT
  GDK_WINDOW_TOPLEVEL
  GDK_WINDOW_CHILD
  GDK_WINDOW_TEMP
  GDK_WINDOW_FOREIGN
  GDK_WINDOW_OFFSCREEN
  GDK_WINDOW_SUBSURFACE
>;

our enum GdkAnchorHints is export (
  GDK_ANCHOR_FLIP_X   => 1,
  GDK_ANCHOR_FLIP_Y   => 1 +< 1,
  GDK_ANCHOR_SLIDE_X  => 1 +< 2,
  GDK_ANCHOR_SLIDE_Y  => 1 +< 3,
  GDK_ANCHOR_RESIZE_X => 1 +< 4,
  GDK_ANCHOR_RESIZE_Y => 1 +< 5,
  GDK_ANCHOR_FLIP     =>        1 +| (1 +< 1),
  GDK_ANCHOR_SLIDE    => (1 +< 2) +| (1 +< 3),
  GDK_ANCHOR_RESIZE   => (1 +< 4) +| (1 +< 4)
);

our enum GdkFullscreenMode is export <
  GDK_FULLSCREEN_ON_CURRENT_MONITOR
  GDK_FULLSCREEN_ON_ALL_MONITORS
>;

our enum GdkWindowAttributesType is export (
  GDK_WA_TITLE     => 1,
  GDK_WA_X         => 1 +< 2,
  GDK_WA_Y         => 1 +< 3,
  GDK_WA_CURSOR    => 1 +< 4,
  GDK_WA_VISUAL    => 1 +< 5,
  GDK_WA_WMCLASS   => 1 +< 6,
  GDK_WA_NOREDIR   => 1 +< 7,
  GDK_WA_TYPE_HINT => 1 +< 8
);

our enum GdkVisualType is export <
  GDK_VISUAL_STATIC_GRAY
  GDK_VISUAL_GRAYSCALE
  GDK_VISUAL_STATIC_COLOR
  GDK_VISUAL_PSEUDO_COLOR
  GDK_VISUAL_TRUE_COLOR
  GDK_VISUAL_DIRECT_COLOR
>;

our enum GdkByteOrder is export <
  GDK_LSB_FIRST
  GDK_MSB_FIRST
>;

our enum GdkSubpixelLayout is export <
  GDK_SUBPIXEL_LAYOUT_UNKNOWN
  GDK_SUBPIXEL_LAYOUT_NONE
  GDK_SUBPIXEL_LAYOUT_HORIZONTAL_RGB
  GDK_SUBPIXEL_LAYOUT_HORIZONTAL_BGR
  GDK_SUBPIXEL_LAYOUT_VERTICAL_RGB
  GDK_SUBPIXEL_LAYOUT_VERTICAL_BGR
>;

our enum GdkDragProtocol is export (
  GDK_DRAG_PROTO_NONE => 0,
  'GDK_DRAG_PROTO_MOTIF',
  'GDK_DRAG_PROTO_XDND',
  'GDK_DRAG_PROTO_ROOTWIN',
  'GDK_DRAG_PROTO_WIN32_DROPFILES',
  'GDK_DRAG_PROTO_OLE2',
  'GDK_DRAG_PROTO_LOCAL',
  'GDK_DRAG_PROTO_WAYLAND'
);

sub gdkMakeAtom($i) is export {
  my gint $ii = $i +& 0x7fff;
  my $c = CArray[int64].new($ii);
  nativecast(GdkAtom, $c);
}

our enum GdkSelectionAtom is export (
  GDK_SELECTION_PRIMARY        => 1,
  GDK_SELECTION_SECONDARY      => 2,
  GDK_SELECTION_CLIPBOARD      => 69,
  GDK_TARGET_BITMAP            => 5,
  GDK_TARGET_COLORMAP          => 7,
  GDK_TARGET_DRAWABLE          => 17,
  GDK_TARGET_PIXMAP            => 20,
  GDK_TARGET_STRING            => 31,
  GDK_SELECTION_TYPE_ATOM      => 4,
  GDK_SELECTION_TYPE_BITMAP    => 5,
  GDK_SELECTION_TYPE_COLORMAP  => 7,
  GDK_SELECTION_TYPE_DRAWABLE  => 17,
  GDK_SELECTION_TYPE_INTEGER   => 19,
  GDK_SELECTION_TYPE           => 20,
  GDK_SELECTION_TYPE_WINDOW    => 33,
  GDK_SELECTION_TYPE_STRING    => 31,
);

our enum GdkButtons is export (
  GDK_BUTTON_PRIMARY           => 1,
  GDK_BUTTON_MIDDLE            => 2,
  GDK_BUTTON_SECONDARY         => 3
);

our enum GdkColorspace is export <GDK_COLORSPACE_RGB>;

our enum GdkPixbufError is export (
  # image data hosed */
  'GDK_PIXBUF_ERROR_CORRUPT_IMAGE',
  # no mem to load image
  'GDK_PIXBUF_ERROR_INSUFFICIENT_MEMORY',
  # bad option passed to save routine
  'GDK_PIXBUF_ERROR_BAD_OPTION',
  # unsupported image type (sort of an ENOSYS)
  'GDK_PIXBUF_ERROR_UNKNOWN_TYPE',
  # unsupported operation (load, save) for image type
  'GDK_PIXBUF_ERROR_UNSUPPORTED_OPERATION',
  'GDK_PIXBUF_ERROR_FAILED',
  'GDK_PIXBUF_ERROR_INCOMPLETE_ANIMATION'
);

our enum GdkPixbufAlphaMode is export <
  GDK_PIXBUF_ALPHA_BILEVEL
  GDK_PIXBUF_ALPHA_FULL
>;

our enum GdkInterpType is export <
  GDK_INTERP_NEAREST
  GDK_INTERP_TILES
  GDK_INTERP_BILINEAR
  GDK_INTERP_HYPER
>;

our enum GdkPixbufRotation is export (
  GDK_PIXBUF_ROTATE_NONE             =>   0,
  GDK_PIXBUF_ROTATE_COUNTERCLOCKWISE =>  90,
  GDK_PIXBUF_ROTATE_UPSIDEDOWN       => 180,
  GDK_PIXBUF_ROTATE_CLOCKWISE        => 270
);

our enum GdkDragCancelReason is export <
  GDK_DRAG_CANCEL_NO_TARGET
  GDK_DRAG_CANCEL_USER_CANCELLED
  GDK_DRAG_CANCEL_ERROR
>;

our enum GdkInputSource is export <
  GDK_SOURCE_MOUSE
  GDK_SOURCE_PEN
  GDK_SOURCE_ERASER
  GDK_SOURCE_CURSOR
  GDK_SOURCE_KEYBOARD
  GDK_SOURCE_TOUCHSCREEN
  GDK_SOURCE_TOUCHPAD
  GDK_SOURCE_TRACKPOINT
  GDK_SOURCE_TABLET_PAD
>;

our enum GdkInputMode is export <
  GDK_MODE_DISABLED
  GDK_MODE_SCREEN
  GDK_MODE_WINDOW
>;

our enum GdkDeviceType is export <
  GDK_DEVICE_TYPE_MASTER
  GDK_DEVICE_TYPE_SLAVE
  GDK_DEVICE_TYPE_FLOATING
>;

our enum GdkAxisUse is export <
  GDK_AXIS_IGNORE
  GDK_AXIS_X
  GDK_AXIS_Y
  GDK_AXIS_PRESSURE
  GDK_AXIS_XTILT
  GDK_AXIS_YTILT
  GDK_AXIS_WHEEL
  GDK_AXIS_DISTANCE
  GDK_AXIS_ROTATION
  GDK_AXIS_SLIDER
  GDK_AXIS_LAST
>;

our enum GdkAxisFlags is export (
  GDK_AXIS_FLAG_X        => 1 +< GDK_AXIS_X,
  GDK_AXIS_FLAG_Y        => 1 +< GDK_AXIS_Y,
  GDK_AXIS_FLAG_PRESSURE => 1 +< GDK_AXIS_PRESSURE,
  GDK_AXIS_FLAG_XTILT    => 1 +< GDK_AXIS_XTILT,
  GDK_AXIS_FLAG_YTILT    => 1 +< GDK_AXIS_YTILT,
  GDK_AXIS_FLAG_WHEEL    => 1 +< GDK_AXIS_WHEEL,
  GDK_AXIS_FLAG_DISTANCE => 1 +< GDK_AXIS_DISTANCE,
  GDK_AXIS_FLAG_ROTATION => 1 +< GDK_AXIS_ROTATION,
  GDK_AXIS_FLAG_SLIDER   => 1 +< GDK_AXIS_SLIDER,
);

our enum GdkModifierIntent is export <
  GDK_MODIFIER_INTENT_PRIMARY_ACCELERATOR
  GDK_MODIFIER_INTENT_CONTEXT_MENU
  GDK_MODIFIER_INTENT_EXTEND_SELECTION
  GDK_MODIFIER_INTENT_MODIFY_SELECTION
  GDK_MODIFIER_INTENT_NO_TEXT_INPUT
  GDK_MODIFIER_INTENT_SHIFT_GROUP
  GDK_MODIFIER_INTENT_DEFAULT_MOD_MASK
>;

our enum GdkSeatCapabilities is export (
 GDK_SEAT_CAPABILITY_NONE          => 0,
 GDK_SEAT_CAPABILITY_POINTER       => 1,
 GDK_SEAT_CAPABILITY_TOUCH         => 1 +< 1,
 GDK_SEAT_CAPABILITY_TABLET_STYLUS => 1 +< 2,
 GDK_SEAT_CAPABILITY_KEYBOARD      => 1 +< 3,
 GDK_SEAT_CAPABILITY_ALL_POINTING  => (1 +| 1 +< 1 +| 1 +< 2),
 GDK_SEAT_CAPABILITY_ALL           => (1 +| 1 +< 1 +| 1 +< 2 +| 1 +< 3)
);

our enum GdkGrabStatus is export (
  GDK_GRAB_SUCCESS         => 0,
  GDK_GRAB_ALREADY_GRABBED => 1,
  GDK_GRAB_INVALID_TIME    => 2,
  GDK_GRAB_NOT_VIEWABLE    => 3,
  GDK_GRAB_FROZEN          => 4,
  GDK_GRAB_FAILED          => 5
);
