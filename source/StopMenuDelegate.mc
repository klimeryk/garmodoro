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
			setStorageValue(POMODORO_TIMER_STARTED_PROPERTY_STORAGE_KEY, false);
			setStorageValue(BREAK_TIMER_STARTED_PROPERTY_STORAGE_KEY, false);
			setStorageValue(POMODORO_NUMBER_PROPERTY_STORAGE_KEY, 1);

			setEndTimeBySeconds(null);
			Background.deleteTemporalEvent();			
			timer.start( method( :idleCallback ), 10 * 1000, true );

			Ui.requestUpdate();
		} else if ( item == :exit ) {
			System.exit();
		}
	}
}
