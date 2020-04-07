// this file encapsulates the core Pomodoro functionality.

using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Attention as Attention;
using Toybox.Timer as Timer;
using Toybox.Lang as Lang;

// acts a a singleton, hence no class
module Pomodoro {
	var minuteTimer;
	var tickTimer;
	// pomodoro states: ready -> running -> break -> ready ...
	enum {
		stateReady,
		stateRunning,
		stateBreak
	}
	var currentState = stateReady;
	var pomodoroIteration = 1;
	var minutesLeft = 0;

	// called when app is started for the first time
	function initialize() {	
		minuteTimer = new Timer.Timer();
		tickTimer = new Timer.Timer();
		// refreshes current time displayed on watch
		beginCountdown();
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
		minutesLeft = App.getApp().getProperty( "pomodoroLength" );
	}

	function isLongBreak() {
		var groupLength = App.getApp().getProperty( "numberOfPomodorosBeforeLongBreak" );
		return ( pomodoroIteration % groupLength ) == 0;
	}

	function resetMinutesForBreak() {
		var breakVariant =  isLongBreak() ?
					"longBreakLength" :
					"shortBreakLength";
		minutesLeft = App.getApp().getProperty( breakVariant );
	}

	function shouldTick() {
		return App.getApp().getProperty( "tickStrength" ) > 0;
	}

	// for displaying
	function getMinutesLeft() {
		return minutesLeft.format( "%02d" );
	}

	// for displaying
	function getIteration() {
		return pomodoroIteration;
	}

	function isInBreakState() {
		return currentState == stateBreak;
	}

	function isInRunningState() {
		return currentState == stateRunning;
	}

	function isInReadyState() {
		return currentState == stateReady;
	}

	function stopTimers() {
		tickTimer.stop();
		minuteTimer.stop();
	}

	// called on reset action in stop menu
	function resetFromMenu() {
		playAttentionTone( 9 ); // Attention.TONE_RESET
		vibrate( 50, 1500 );

		stopTimers();
		resetMinutesForPomodoro();
		pomodoroIteration = 1;
		currentState = stateReady;
	}

	function countdownMinutes() {
		minutesLeft -= 1;

		if ( minutesLeft == 0 ) {
			if( isInRunningState() ) {
				beginBreakState();
			} else if (isInBreakState()) {
				beginReadyState();
			} else {
				// nothing in ready state
			}
		}

		Ui.requestUpdate();
	}

	function beginCountdown() {
		var countdown = new Lang.Method(Pomodoro, :countdownMinutes);
		minuteTimer.start( countdown, 60 * 1000, true );
	}

	function beginReadyState() {
		transitionToState( stateReady );
	}

	function makeTickingSound() {
		var strength = App.getApp().getProperty( "tickStrength" );
		var duration = App.getApp().getProperty( "tickDuration" );
		vibrate( strength, duration );
	}

	// one tick every second
	function beginTickingIfEnabled() {
		if ( shouldTick() ) {
			var makeTick = new Lang.Method(Pomodoro, :makeTickingSound);
			tickTimer.start( makeTick, 1000, true );
		}
	}

	function beginRunningState() {
		transitionToState( stateRunning );
	}

	function beginBreakState()
	{
		transitionToState( stateBreak );
	}

	function transitionToState( targetState ) {
		stopTimers();
		currentState = targetState;
		
		if(targetState == stateReady) {
			playAttentionTone( 7 ); // Attention.TONE_INTERVAL_ALERT
			vibrate( 100, 1500 );
			currentState = stateReady;
			pomodoroIteration += 1;
		} else if(targetState== stateRunning) {
			playAttentionTone( 1 ); // Attention.TONE_START
			vibrate( 75, 1500 );
			currentState = stateRunning;
			resetMinutesForPomodoro();
			beginTickingIfEnabled();
		} else { // targetState == stateBreak
			playAttentionTone( 10 ); // Attention.TONE_LAP
			vibrate( 100, 1500 );
			currentState = stateBreak;
			resetMinutesForBreak();
		}
		
		beginCountdown();
	}
}
