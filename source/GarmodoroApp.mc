using Toybox.Application as App;
using Toybox.System as System;

class GarmodoroApp extends App.AppBase {

	function initialize() {
		System.println("initialize");
		AppBase.initialize();
	}

	// onStart() is called on application start up
	function onStart(state) {
		System.println("onStart");
		timer = new Timer.Timer();
		tickTimer = new Timer.Timer();
	}

	// onStop() is called when your application is exiting
	function onStop(state) {
		System.println("onStop");
		tickTimer.stop();
		timer.stop();
	}

	// Return the initial view of your application here
	function getInitialView() {
		System.println("getInitialView");
		return [ new GarmodoroView(), new GarmodoroDelegate() ];
	}

}
