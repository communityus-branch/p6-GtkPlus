use v6.c;

use GTK::Application;

my $a = GTK::Application.new(:pod($=pod));
$a.activate.tap({
  $a.window.destroy-signal.tap({ $a.exit; });
});

$a.run;

=begin ui
<interface>
  <requires lib="gtk+" version="3.20"/>
  <object class="GtkWindow" id="application">
    <property name="can_focus">False</property>
    <child>
      <placeholder/>
    </child>
    <child>
      <object class="GtkBox" id="box1">
        <property name="visible">True</property>
        <property name="can_focus">False</property>
        <property name="orientation">vertical</property>
        <child>
          <object class="GtkGrid" id="grid1">
            <property name="visible">True</property>
            <property name="can_focus">False</property>
            <property name="column_homogeneous">True</property>
            <child>
              <object class="GtkEntry" id="entry1">
                <property name="visible">True</property>
                <property name="can_focus">True</property>
                <property name="margin_left">5</property>
                <property name="margin_right">5</property>
                <property name="margin_top">5</property>
                <property name="margin_bottom">5</property>
              </object>
              <packing>
                <property name="left_attach">0</property>
                <property name="top_attach">0</property>
              </packing>
            </child>
            <child>
              <object class="GtkLinkButton" id="link1">
                <property name="label" translatable="yes">Xliff</property>
                <property name="visible">True</property>
                <property name="can_focus">True</property>
                <property name="receives_default">True</property>
                <property name="margin_left">2</property>
                <property name="margin_right">2</property>
                <property name="margin_top">2</property>
                <property name="margin_bottom">2</property>
                <property name="relief">half</property>
                <property name="uri">https://github.com/Xliff</property>
              </object>
              <packing>
                <property name="left_attach">1</property>
                <property name="top_attach">0</property>
              </packing>
            </child>
            <child>
              <object class="GtkToggleButton" id="toggle1">
                <property name="label" translatable="yes">Toggle</property>
                <property name="visible">True</property>
                <property name="can_focus">True</property>
                <property name="receives_default">True</property>
              </object>
              <packing>
                <property name="left_attach">2</property>
                <property name="top_attach">0</property>
              </packing>
            </child>
            <child>
              <object class="GtkCheckButton" id="check1">
                <property name="label" translatable="yes">Checked</property>
                <property name="visible">True</property>
                <property name="can_focus">True</property>
                <property name="receives_default">False</property>
                <property name="draw_indicator">True</property>
              </object>
              <packing>
                <property name="left_attach">0</property>
                <property name="top_attach">1</property>
              </packing>
            </child>
            <child>
              <object class="GtkSwitch" id="switch1">
                <property name="visible">True</property>
                <property name="can_focus">True</property>
              </object>
              <packing>
                <property name="left_attach">1</property>
                <property name="top_attach">1</property>
              </packing>
            </child>
            <child>
              <object class="GtkColorButton" id="color1">
                <property name="visible">True</property>
                <property name="can_focus">True</property>
                <property name="receives_default">True</property>
              </object>
              <packing>
                <property name="left_attach">2</property>
                <property name="top_attach">1</property>
              </packing>
            </child>
            <child>
              <object class="GtkSpinButton" id="spin1">
                <property name="visible">True</property>
                <property name="can_focus">True</property>
                <property name="value">25</property>
              </object>
              <packing>
                <property name="left_attach">0</property>
                <property name="top_attach">2</property>
              </packing>
            </child>
            <child>
              <object class="GtkLockButton" id="lock1">
                <property name="visible">True</property>
                <property name="can_focus">True</property>
              </object>
              <packing>
                <property name="left_attach">1</property>
                <property name="top_attach">2</property>
              </packing>
            </child>
            <child>
              <object class="GtkScale" id="scale1">
                <property name="name">scale1</property>
                <property name="visible">True</property>
                <property name="can_focus">True</property>
                <property name="margin_left">10</property>
                <property name="margin_right">10</property>
                <property name="margin_top">10</property>
                <property name="margin_bottom">10</property>
                <property name="round_digits">1</property>
              </object>
              <packing>
                <property name="left_attach">2</property>
                <property name="top_attach">2</property>
              </packing>
            </child>
          </object>
          <packing>
            <property name="expand">False</property>
            <property name="fill">False</property>
            <property name="padding">5</property>
            <property name="position">0</property>
          </packing>
        </child>
        <child>
          <object class="GtkButton" id="okbutton">
            <property name="label" translatable="yes">Ok</property>
            <property name="visible">True</property>
            <property name="can_focus">True</property>
            <property name="receives_default">True</property>
            <property name="margin_left">15</property>
            <property name="margin_right">15</property>
          </object>
          <packing>
            <property name="expand">False</property>
            <property name="fill">False</property>
            <property name="position">1</property>
          </packing>
        </child>
        <child>
          <object class="GtkButton" id="cancelbutton">
            <property name="label" translatable="yes">Cancel</property>
            <property name="visible">True</property>
            <property name="can_focus">True</property>
            <property name="receives_default">True</property>
            <property name="margin_left">10</property>
            <property name="margin_right">10</property>
          </object>
          <packing>
            <property name="expand">False</property>
            <property name="fill">False</property>
            <property name="position">2</property>
          </packing>
        </child>
      </object>
    </child>
  </object>
</interface>
=end ui
