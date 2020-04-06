using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Pomodoro;

class GarmodoroDelegate extends Ui.BehaviorDelegate {
	function initialize() {
		Ui.BehaviorDelegate.initialize();
	}

	function onBack() {
		Ui.popView( Ui.SLIDE_RIGHT );
		return true;
	}

	function onNextMode() {
		return true;
	}

	function onNextPage() {
		return true;
	}

	function onSelect() {
		if ( isBreakTimerStarted || isPomodoroTimerStarted ) {
			Ui.pushView( new Rez.Menus.StopMenu(),
						new StopMenuDelegate(), Ui.SLIDE_UP );
			return true;
		} // else: we are in ready state

		Pomodoro.beginPomodoro();

		Ui.requestUpdate();
		return true;
	}
}
