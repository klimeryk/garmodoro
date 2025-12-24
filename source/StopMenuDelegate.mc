using Toybox.Attention as Attention;
using Toybox.System as System;
using Toybox.WatchUi as Ui;

class StopMenuDelegate extends Ui.MenuInputDelegate {
	function initialize() {
		MenuInputDelegate.initialize();
	}

	function idleCallback() as Void {
		requestViewUpdate( false );
	}

	function onMenuItem( item ) {
		if ( item == :restart ) {
			play( Attention.TONE_RESET );
			ping( softVibration );

			tickTimer.stop();
			timer.stop();

			// Stop and discard activity session
			if (session != null) {
				try {
					session.stop();
					session.discard();
					System.println("Activity session discarded (manual restart)");
				} catch (e) {
					// Ignore errors
				}
				session = null;
			}

			resetMinutes();
			pomodoroNumber = 1;
			isPomodoroTimerStarted = false;
			isBreakTimerStarted = false;
			timer.start( method( :idleCallback ), MINUTE_IN_MILISECONDS, true );

			requestViewUpdate( true );
		} else if ( item == :exit ) {
			// Save session before exit
			if (session != null) {
				try {
					session.stop();
					session.save();
					System.println("Activity session saved before exit");
				} catch (e) {
					// Ignore errors
				}
			}
			System.exit();
		}
	}
}
