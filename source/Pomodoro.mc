// this file encapsulates the core Pomodoro functionality.

using Toybox.Timer as Timer;

// TODO: move global variables concerning Pomodoro to here
// TODO: move Pomodoro global variables into module Pomodoro

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
