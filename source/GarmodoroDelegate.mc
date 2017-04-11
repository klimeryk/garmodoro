using Toybox.Attention as Attention;
using Toybox.System as System;
using Toybox.WatchUi as Ui;

var timer;
var tickTimer;
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
	hidden var tickStrength = APP.getProperty( "tickStrength" );
	hidden var tickDuration = APP.getProperty( "tickDuration" );

	function initialize() {
		System.println( "GomodoroDelegate: initialize" );
		Ui.BehaviorDelegate.initialize();
	}

	function pomodoroCallback() {
		minutes -= 1;

		if ( minutes == 0 ) {
			ping( 100, 1500 );
			tickTimer.stop();
			timer.stop();
			isPomodoroTimerStarted = false;

			var minutesOfBreak = ( pomodoroNumber % me.numberOfPomodorosBeforeLongBreak ) == 0 ? me.longBreakLength : me.shortBreakLength;
			timer.start( method( :breakCallback ), minutesOfBreak * 60 * 1000, false );
			isBreakTimerStarted = true;
		}

		Ui.requestUpdate();
	}

	function breakCallback() {
		ping( 100, 1500 );
		isBreakTimerStarted = false;
		pomodoroNumber += 1;
		minutes = me.pomodoroLength;

		Ui.requestUpdate();
	}

	function tickCallback() {
		ping( me.tickStrength, me.tickDuration );
	}

	function onBack() {
		System.exit();
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
			ping( 50, 1500 );
			tickTimer.stop();
			timer.stop();
			minutes = me.pomodoroLength;
			pomodoroNumber = 1;
			isPomodoroTimerStarted = false;

			Ui.requestUpdate();
		} else {
			ping( 75, 1500 );
			minutes = me.pomodoroLength;
			timer.start( method( :pomodoroCallback ), 60 * 1000, true );
			if ( me.tickStrength > 0 && me.tickDuration > 0 ) {
				tickTimer.start( method( :tickCallback ), 1000, true );
			}
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
