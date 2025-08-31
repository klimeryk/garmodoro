using Toybox.Attention as Attention;
using Toybox.System as System;
using Toybox.WatchUi as Ui;

class StopMenuDelegate extends Ui.MenuInputDelegate {
	function initialize() {
		MenuInputDelegate.initialize();
	}

	function idleCallback() as Void {
		Ui.requestUpdate();
	}

	function onMenuItem( item ) {
		if ( item == :restart ) {
			play( Attention.TONE_RESET );
			ping( softVibration );

			tickTimer.stop();
			timer.stop();

			resetMinutes();
			pomodoroNumber = 1;
			isPomodoroTimerStarted = false;
			isBreakTimerStarted = false;
			needsClear = true;
			timer.start( method( :idleCallback ), MINUTE_IN_MILISECONDS, true );

			Ui.requestUpdate();
		} else if ( item == :exit ) {
			System.exit();
		}
	}
}
