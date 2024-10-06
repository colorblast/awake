// awake
public class Awake.Indicator : Wingpanel.Indicator {
    private Gtk.Image main_image;

    private Gtk.Grid main_widget;
    private Granite.Widgets.ModeButton mode_btn;
    private GLib.Settings settings;

    private Pid child_pid = 0;

    public Indicator () {
        Object (
                code_name: "awake-indicator"
        );
    }

    private void set_state (int state) {
        mode_btn.set_active (state);
    }

    private void update_state (int state) {
        settings.set_int ("button-state", state);
    }

    private void maybe_kill_proc () {
        if (child_pid > 0) {
            try {
                string cmd = "kill " + ((int) child_pid).to_string ();
                GLib.Process.spawn_command_line_async (cmd);
            } catch (SpawnError e) {
                print ("Could not kill process %s\n", e.message);
            }
        }
    }

    private void start_sleep (int sleep_amt) {

        maybe_kill_proc ();

        try {
            GLib.Process.spawn_async (null, { "systemd-inhibit", "--what=idle:sleep:shutdown", "sleep", sleep_amt.to_string () }, null, SpawnFlags.SEARCH_PATH, null, out child_pid);
        } catch (Error e) {
            print ("Error: %s\n", e.message);
        }

        Timeout.add (1000, () => {
            return false;
        });
    }

    construct {

        string css = """
        .icon {
            color: white;
        }
        """;

        // Load the CSS from the string
        var css_provider = new Gtk.CssProvider ();
        try {
            css_provider.load_from_data (css, -1); // Load the inline CSS
        } catch (GLib.Error err) {
        }


        Gtk.StyleContext.add_provider_for_screen (
                                                  Gdk.Screen.get_default (),
                                                  css_provider,
                                                  Gtk.STYLE_PROVIDER_PRIORITY_USER
        );

        // main_image = new Gtk.Image.from_icon_name ("24.svg", Gtk.IconSize.LARGE_TOOLBAR);
        main_image = new Gtk.Image.from_resource ("/io/github/colorblast/awake/icons/24.svg");
        // main_image.set_size_request (16, 16);
        main_image.set_pixel_size (24);

        main_image.get_style_context ().add_class ("icon");
        // main_image.set_from_file (GLib.Environment.get_current_dir () + "/share/icons/24.svg");
        debug (GLib.Environment.get_user_data_dir ());

        var separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL) {
            margin_top = 3,
            margin_bottom = 0
        };

        var compositing_switch = new Granite.SwitchModelButton (_("Awake"));

        mode_btn = new Granite.Widgets.ModeButton ();
        mode_btn.append_text ("15");
        mode_btn.append_text ("30");
        mode_btn.append_text ("45");
        mode_btn.append_text ("1");
        mode_btn.append_text ("2");

        var separator2 = new Gtk.Separator (Gtk.Orientation.HORIZONTAL) {
            margin_top = 0,
            margin_bottom = 3,
        };

        main_widget = new Gtk.Grid ();
        main_widget.attach (compositing_switch, 0, 1);
        main_widget.attach (separator, 0, 2);
        main_widget.attach (mode_btn, 0, 3);
        main_widget.attach (separator2, 0, 4);

        main_widget.column_spacing = 0;
        main_widget.row_spacing = 0;

        /* Indicator should be visible at startup */
        this.visible = true;

        settings = new GLib.Settings ("io.github.colorblast.awake");
        int state = settings.get_int ("button-state");
        set_state (state);

        mode_btn.mode_changed.connect (() => {
            update_state (state);
            int val = int.parse (((mode_btn.get_children ().nth_data (mode_btn.selected) as Gtk.ToggleButton).get_child () as Gtk.Label).get_text ());
            if (val > 10) {
                start_sleep (val * 60);
            } else {
                start_sleep (val * 60 * 60);
            }
        });

        compositing_switch.notify["active"].connect (() => {
            if (compositing_switch.active) {
                mode_btn.set_sensitive (true);
            } else {
                mode_btn.set_sensitive (false);
                maybe_kill_proc ();
            }
        });
    }

    /* This method is called to get the widget that is displayed in the panel */
    public override Gtk.Widget get_display_widget () {
        return main_image;
    }

    /* This method is called to get the widget that is displayed in the popover */
    public override Gtk.Widget? get_widget () {
        return main_widget;
    }

    /* This method is called when the indicator popover opened */
    public override void opened () {
        /* Use this method to get some extra information while displaying the indicator */
    }

    /* This method is called when the indicator popover closed */
    public override void closed () {
        /* Your stuff isn't shown anymore, now you can free some RAM, stop timers or anything else... */
    }
}

/*
 * This method is called once after your plugin has been loaded.
 * Create and return your indicator here if it should be displayed on the current server.
 */
public Wingpanel.Indicator ? get_indicator (Module module, Wingpanel.IndicatorManager.ServerType server_type) {
    debug ("Activating Awake Indicator");

    if (server_type != Wingpanel.IndicatorManager.ServerType.SESSION) {
        return null;
    }

    var indicator = new Awake.Indicator ();

    return indicator;
}