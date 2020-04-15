using Toybox.Attention as Attention;
using Toybox.System as System;
using Toybox.WatchUi as Ui;
using Pomodoro;

class StopMenuDelegate extends Ui.MenuInputDelegate {
	function initialize() {
		MenuInputDelegate.initialize();
	}

	function onMenuItem( item ) {
		if ( item == :restart ) {
			Pomodoro.resetFromMenu();

			Ui.requestUpdate();
		} else if ( item == :exit ) {
			System.exit();
		}
	}
}
