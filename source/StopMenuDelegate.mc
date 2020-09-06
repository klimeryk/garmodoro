using Toybox.Attention as Attention;
using Toybox.System as System;
using Toybox.WatchUi as Ui;

class StopMenuDelegate extends Ui.MenuInputDelegate {
	function initialize() {
		MenuInputDelegate.initialize();
	}

	function onMenuItem( item ) {
		if ( item == :restart ) {
			play( 9 ); // Attention.TONE_RESET
			ping( 50, 1500 );

			tickTimer.stop();
			timer.stop();

			resetMinutes();
			pomodoroNumber = 1;
			isPomodoroTimerStarted = false;
			isBreakTimerStarted = false;
			timer.start( method( :idleCallback ), 60 * 1000, true );

			Ui.requestUpdate();
		} else if ( item == :exit ) {
			System.exit();
		}
	}
}
