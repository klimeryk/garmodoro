using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.System;

import Toybox.Lang;

class TaskMenuDelegate extends Ui.Menu2InputDelegate {

    private var _startCallback as Method();

    function initialize(startCallback as Method()) {
        Menu2InputDelegate.initialize();
        _startCallback = startCallback;
    }

    function onSelect(item as Ui.MenuItem) as Boolean {
        var task = item.getId() as Dictionary;

        // Save to Properties
        App.Properties.setValue("current_task_name", task["name"]);
        App.Properties.setValue("current_sport", task["sport"]);
        App.Properties.setValue("current_subsport", task["subsport"]);

        System.println("Selected task: " + task["name"] +
                       " (sport=" + task["sport"] +
                       ", subsport=" + task["subsport"] + ")");

        Ui.popView(Ui.SLIDE_DOWN);

        if (_startCallback != null) {
            _startCallback.invoke();
        }

        return true;
    }

    function onBack() as Boolean {
        Ui.popView(Ui.SLIDE_DOWN);
        return true;
    }
}
