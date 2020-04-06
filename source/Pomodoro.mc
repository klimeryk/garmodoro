// this file encapsulates the core Pomodoro functionality.

using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Attention as Attention;
using Toybox.Timer as Timer;
using Toybox.Lang as Lang;

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

function shouldTick() {
	return App.getApp().getProperty( "tickStrength" ) > 0;
}

// acts a a singleton, hence no class
module Pomodoro {
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

	function isInReadyState() {
		return ! isPomodoroTimerStarted && 
					! isBreakTimerStarted;
	}

	// TODO: inline isLongBreak() and rename
	function isLongBreak2() {
		return isLongBreak();
	}

	function countdownMinutesInRunning() {
		minutes -= 1;

		if ( minutes == 0 ) {
			// TODO extract to beginBreak()
			play( 10 ); // Attention.TONE_LAP
			ping( 100, 1500 );
			tickTimer.stop();
			timer.stop();
			isPomodoroTimerStarted = false;
			minutes = App.getApp().getProperty( isLongBreak() ?
						"longBreakLength" :
						"shortBreakLength" );
			var breakTimerRoutine =
						new Lang.Method(Pomodoro, :countdownMinutesInBreak);
			timer.start( breakTimerRoutine, 60 * 1000, true );
			isBreakTimerStarted = true;
		}

		Ui.requestUpdate();
	}

	// TODO merge this with Pomodoro.countdownMinutesInRunning()
	function countdownMinutesInBreak() {
		minutes -= 1;

		if ( minutes == 0 ) {
			// TODO: extract to beginReadyState()
			play( 7 ); // Attention.TONE_INTERVAL_ALERT
			ping( 100, 1500 );
			timer.stop();

			isBreakTimerStarted = false;
			pomodoroNumber += 1;
			resetMinutes();
		}

		Ui.requestUpdate();
	}

	function makeTickingSound() {
		var strength = App.getApp().getProperty( "tickStrength" );
		var duration = App.getApp().getProperty( "tickDuration" );
		ping( strength, duration );
	}

	// start ticking once a second, if enabled
	function beginTicking() {
		if ( shouldTick() ) {
			var tickTimerRoutine =
						new Lang.Method(Pomodoro, :makeTickingSound);
			tickTimer.start( tickTimerRoutine, 1000, true );
		}
	}

	// begin pomodoro countdown
	function beginPomodoro() {
		play( 1 ); // Attention.TONE_START
		ping( 75, 1500 );
		resetMinutes();
		var pomodoroTimerRoutine =
					new Lang.Method(Pomodoro, :countdownMinutesInRunning);
		timer.start( pomodoroTimerRoutine, 60 * 1000, true );
		isPomodoroTimerStarted = true;

		beginTicking();
	}
}
