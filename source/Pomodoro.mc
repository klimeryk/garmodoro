// this file encapsulates the core Pomodoro functionality.

using Toybox.Timer as Timer;

// TODO: move global variables concerning Pomodoro to here
// TODO: move Pomodoro global variables into module Pomodoro

// acts a a singleton, hence no class
module Pomodoro {
// TODO: move pomodoro code from other files here

	function initialize() {	
		timer = new Timer.Timer();
		tickTimer = new Timer.Timer();
	}

	function stopTimers() {
		tickTimer.stop();
		timer.stop();
	}
}