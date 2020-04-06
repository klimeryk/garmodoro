// this file encapsulates the core Pomodoro functionality.

using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Attention as Attention;
using Toybox.Timer as Timer;
using Toybox.Lang as Lang;

// acts a a singleton, hence no class
module Pomodoro {
	var timer;
	var tickTimer;
	var minutes = 0;
	var pomodoroNumber = 1;
	var isPomodoroTimerStarted = false;
	var isBreakTimerStarted = false;

	// called when app is started for the first time
	function initialize() {	
		timer = new Timer.Timer();
		tickTimer = new Timer.Timer();
	}

	function vibrate( dutyCycle, length ) {
		if ( Attention has :vibrate ) {
			Attention.vibrate([ new Attention.VibeProfile( dutyCycle, length ) ] );
		}
	}

	// if not muted
	function playAttentionTone( tone ) {
		var isMuted =  App.getApp().getProperty( "muteSounds" );
		if ( ! isMuted && Attention has :playTone ) {
			Attention.playTone( tone );
		}
	}

	function resetMinutesForPomodoro() {
		minutes = App.getApp().getProperty( "pomodoroLength" );
	}

	function resetMinutesForBreak() {
		var breakVariant =  isLongBreak() ?
					"longBreakLength" :
					"shortBreakLength";
		minutes = App.getApp().getProperty( breakVariant );
	}

	function shouldTick() {
		return App.getApp().getProperty( "tickStrength" ) > 0;
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

	function stopTimers() {
		tickTimer.stop();
		timer.stop();
	}

	// called when "reset" action is selected in menu
	function resetFromMenu() {
		playAttentionTone( 9 ); // Attention.TONE_RESET
		vibrate( 50, 1500 );

		stopTimers();
		resetMinutesForPomodoro();
		pomodoroNumber = 1;
		isPomodoroTimerStarted = false;
		isBreakTimerStarted = false;
	}

	function countdownMinutes() {
		minutes -= 1;

		if ( minutes == 0 ) {
			if( isInRunningState() ) {
				beginBreakCountdown();
			} else if (isInBreakState()) {
				beginReadyState();
			} else {
				// will never be called in ready state
			}
		}

		Ui.requestUpdate();
	}

	function beginCountdown() {
		var timerRoutine =
					new Lang.Method(Pomodoro, :countdownMinutes);
		timer.start( timerRoutine, 60 * 1000, true );
	}

	function beginReadyState() {
		playAttentionTone( 7 ); // Attention.TONE_INTERVAL_ALERT
		vibrate( 100, 1500 );
		timer.stop();
		isBreakTimerStarted = false;
		pomodoroNumber += 1;
	}

	function isLongBreak() {
		var groupLength = App.getApp().getProperty( "numberOfPomodorosBeforeLongBreak" );
		return ( pomodoroNumber % groupLength ) == 0;
	}

	function makeTickingSound() {
		var strength = App.getApp().getProperty( "tickStrength" );
		var duration = App.getApp().getProperty( "tickDuration" );
		vibrate( strength, duration );
	}

	// one tick every second
	function beginTickingIfEnabled() {
		if ( shouldTick() ) {
			var tickTimerRoutine =
						new Lang.Method(Pomodoro, :makeTickingSound);
			tickTimer.start( tickTimerRoutine, 1000, true );
		}
	}

	function beginPomodoroCountdown() {
		playAttentionTone( 1 ); // Attention.TONE_START
		vibrate( 75, 1500 );

		resetMinutesForPomodoro();
		beginCountdown();
		isPomodoroTimerStarted = true;
		beginTickingIfEnabled();
	}

	function beginBreakCountdown()
	{
		playAttentionTone( 10 ); // Attention.TONE_LAP
		vibrate( 100, 1500 );

		stopTimers();
		isPomodoroTimerStarted = false;
		resetMinutesForBreak();
		beginCountdown();
		isBreakTimerStarted = true;
	}
}
