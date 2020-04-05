// this file encapsulates the core Pomodoro functionality.

using Toybox.Application as App;
using Toybox.Attention as Attention;
using Toybox.Timer as Timer;

// global variables and functions
// TODO: move Pomodoro global variables into module Pomodoro
var timer;
var tickTimer;
var minutes = 0;
var pomodoroNumber = 1;
var isPomodoroTimerStarted = false;
var isBreakTimerStarted = false;

function ping( dutyCycle, length ) {
	if ( Attention has :vibrate ) {
		Attention.vibrate( [ new Attention.VibeProfile( dutyCycle, length ) ] );
	}
}

function play( tone ) {
	if ( Attention has :playTone && ! App.getApp().getProperty( "muteSounds" ) ) {
		Attention.playTone( tone );
	}
}

function isLongBreak() {
	return ( pomodoroNumber % App.getApp().getProperty( "numberOfPomodorosBeforeLongBreak" ) ) == 0;
}

function resetMinutes() {
	minutes = App.getApp().getProperty( "pomodoroLength" );
}


// acts a a singleton, hence no class
module Pomodoro {
// TODO: move pomodoro code from other files here

	// called when app is started for the first time
	function initialize() {	
		timer = new Timer.Timer();
		tickTimer = new Timer.Timer();
	}

	function stopTimers() {
		tickTimer.stop();
		timer.stop();
	}

	// called when "reset" action is selected in menu
	function resetFromMenu() {
		play( 9 ); // Attention.TONE_RESET
		ping( 50, 1500 );

		stopTimers();

		resetMinutes();
		pomodoroNumber = 1;
		isPomodoroTimerStarted = false;
		isBreakTimerStarted = false;
	}

	// for displaying
	function getMinutesLeft() {
		return minutes;
	}

	// for displaying
	function getIteration() {
		return pomodoroNumber;
	}

	function isInBreakState() {
		return isBreakTimerStarted;
	}

	function isInRunningState() {
		return isPomodoroTimerStarted;
	}

	// TODO: inline isLongBreak() and rename
	function isLongBreak2() {
		return isLongBreak();
	}
}
