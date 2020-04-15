using Toybox.Application as App;
using Pomodoro;

class GarmodoroApp extends App.AppBase {

	function initialize() {
		AppBase.initialize();
		Pomodoro.initialize();
	}

	function onStart(state) {
	}

	function onStop(state) {
		Pomodoro.stopTimers();
	}

	function getInitialView() {
		return [ new GarmodoroView(), new GarmodoroDelegate() ];
	}
}
