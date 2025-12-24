using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System;

import Toybox.Lang;

class TaskMenuBuilder {

    const MAX_SLOTS = 5;

    static function buildMenu() as Ui.Menu2 {
        var menu = new Ui.Menu2({:title => "Select Task"});

        var i as Number;
        for (i = 1; i <= MAX_SLOTS; i++) {
            var enabled = App.Properties.getValue("task" + i + "_enabled");

            if (enabled == true) {
                var name = App.Properties.getValue("task" + i + "_name");
                var sport = App.Properties.getValue("task" + i + "_sport");
                var subsport = App.Properties.getValue("task" + i + "_subsport");

                // Protection from null
                if (name == null) { name = "Task " + i; }
                if (sport == null) { sport = 0; }
                if (subsport == null) { subsport = 0; }

                var task = {
                    "name" => name,
                    "sport" => sport,
                    "subsport" => subsport,
                    "slot" => i
                };

                menu.addItem(new Ui.MenuItem(
                    name,
                    null,  // No subtitle for RAM economy
                    task,
                    {}
                ));
            }
        }

        return menu;
    }
}
