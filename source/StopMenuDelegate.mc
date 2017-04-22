using Toybox.Application as Application;
using Toybox.Attention as Attention;
using Toybox.System as System;
using Toybox.WatchUi as Ui;

class StopMenuDelegate extends Ui.MenuInputDelegate {
	const APP = Application.getApp();
	hidden var pomodoroLength = APP.getProperty( "pomodoroLength" );

	function initialize() {
		MenuInputDelegate.initialize();
	}

	function onMenuItem( item ) {
		if ( item == :restart ) {
			play( Attention.TONE_RESET );
			ping( 50, 1500 );

			tickTimer.stop();
			timer.stop();

			minutes = me.pomodoroLength;
			pomodoroNumber = 1;
			isPomodoroTimerStarted = false;
			isBreakTimerStarted = false;

			Ui.requestUpdate();
		} else if ( item == :exit ) {
			System.exit();
		}
	}
}
