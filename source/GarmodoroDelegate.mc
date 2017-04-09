using Toybox.Attention as Attention;
using Toybox.System as System;
using Toybox.WatchUi as Ui;

var timer;
var minutes = 0;
var pomodoroNumber = 1;
var isPomodoroTimerStarted = false;
var isBreakTimerStarted = false;

class GarmodoroDelegate extends Ui.BehaviorDelegate {
	const APP = Application.getApp();
	hidden var pomodoroLength = APP.getProperty( "pomodoroLength" );
	hidden var shortBreakLength = APP.getProperty( "shortBreakLength" );
	hidden var longBreakLength = APP.getProperty( "longBreakLength" );
	hidden var numberOfPomodorosBeforeLongBreak = APP.getProperty( "numberOfPomodorosBeforeLongBreak" );

	function initialize() {
		System.println( "GomodoroDelegate: initialize" );
		Ui.BehaviorDelegate.initialize();
	}

	function pomodoroCallback() {
		minutes -= 1;

		if ( Attention has :vibrate ) {
			ping( 50, 50 );
		}

		if ( minutes == 0 ) {
			ping( 100, 100 );
			timer.stop();
			isPomodoroTimerStarted = false;

			var minutesOfBreak = pomodoroNumber % me.numberOfPomodorosBeforeLongBreak ? me.longBreakLength : me.shortBreakLength;
			timer.start( method( :breakCallback ), minutesOfBreak * 60 * 1000, false );
			isBreakTimerStarted = true;
		}

		Ui.requestUpdate();
	}

	function breakCallback() {
		ping( 100, 100 );
		isBreakTimerStarted = false;
		pomodoroNumber += 1;
		minutes = me.pomodoroLength;

		Ui.requestUpdate();
	}

	function onBack() {
		System.println( "onBack" );
		return true;
	}

	function onNextMode() {
		System.println( "onNextMode" );
		return true;
	}

	function onNextPage() {
		System.println( "onNextPage" );
		return true;
	}

	function onSelect() {
		if ( isBreakTimerStarted ) {
			return true;
		} else if ( isPomodoroTimerStarted ) {
			ping( 100, 100 );
			timer.stop();
			minutes = me.pomodoroLength;
			pomodoroNumber = 1;
			isPomodoroTimerStarted = false;

			Ui.requestUpdate();
		} else {
			ping( 100, 100 );
			minutes = me.pomodoroLength;
			timer.start( method( :pomodoroCallback ), 60 * 1000, true );
			isPomodoroTimerStarted = true;

			Ui.requestUpdate();
		}
		return true;
	}

	function ping( dutyCycle, length ) {
		if ( Attention has :vibrate ) {
			Attention.vibrate( [ new Attention.VibeProfile( dutyCycle, length ) ] );
		}
	}
}
