use v6.c;

use GTK::CheckMenuItem;
use GTK::Menu;
use GTK::MenuBar;
use GTK::MenuItem;
use GTK::SeparatorMenuItem;

class GTK::Utils::MenuBuilder {
  has $!menu;
  has $!items;

  method menu   { $!menu  }
  method items  { $!items }

  submethod BUILD(:$bar = False, :$button = False, :$TOP) {
    my (%named_items, @m);
    for $TOP.List -> $i {
      given $i.value {
        when Array {
          my @sm;
          for $i.value.List -> $ii {
            my $item-type;
            $item-type = do given $ii {
              when .key ~~ / ^ '-' /        { 'GTK::SeparatorMenuItem'  }

              # Must use parens since adverbs have extremely low priority.
              when (.value<toggled>:exists) |
                   (.value<check>:exists)   |
                   (.value<toggle>:exists)  { 'GTK::CheckMenuItem'      }

              default                       { 'GTK::MenuItem'           }
            }

            # This WILL need recursive processing, but for now...
            my %opts;
            unless $item-type eq 'GTK::SeparatorMenuItem' {
              %opts = do given $ii.value {
                when Array { (submenu => $ii.value).Hash }
                when Hash  { $_ }
              }
            }

            # Last chance to modify/validate %opts
            my $menu_item_id = %opts<id>:delete;
            %opts<clicked> //= %opts<do>; %opts<do>:delete;
            %opts<check toggle>:delete;

            @sm.push: ::($item-type).new($ii.key, |%opts);

            with $menu_item_id {
              if %named_items{ $menu_item_id }:exists {
                die "Cannod add duplicate ID <{ $menu_item_id }> to menu tracking!";
              } else {
                @sm[* - 1].name = $menu_item_id;
                %named_items{ $menu_item_id } = @sm[* - 1];
              }
            }
          }
          @m.push: GTK::MenuItem.new($i.key, :submenu(GTK::Menu.new(@sm)));
        }

        when Hash {
          # Break down option type here. Default is another menu item.
          @m.push: GTK::MenuItem.new($i.key, |$i.value);
        }
      }
    }

    # All UI Menu-based items must now accept the following constructor:
    #         MenuType.new(@MenuItems)
    my $widget = do {
      when $bar    { GTK::MenuBar.new(@m)          }

      when $button { my $w = GTK::MenuButton.new;
                     $w.popup = GTK::Menu.new(@m);
                     $w                            }

      default      { GTK::Menu.new(@m)             }
    };
    ($!menu, $!items) = ($widget, %named_items);
  }

}