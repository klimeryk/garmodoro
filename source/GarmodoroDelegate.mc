using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class GarmodoroDelegate extends Ui.BehaviorDelegate {
	function initialize() {
		Ui.BehaviorDelegate.initialize();
	}

	// TODO move to Pomodoro.countdownRunningMinutes()
	function pomodoroCallback() {
		minutes -= 1;

		if ( minutes == 0 ) {
			play( 10 ); // Attention.TONE_LAP
			ping( 100, 1500 );
			tickTimer.stop();
			timer.stop();
			isPomodoroTimerStarted = false;
			minutes = App.getApp().getProperty( isLongBreak() ? "longBreakLength" : "shortBreakLength" );

			timer.start( method( :breakCallback ), 60 * 1000, true );
			isBreakTimerStarted = true;
		}

		Ui.requestUpdate();
	}

	// TODO move to Pomodoro.countdownBreakMinutes()
	// TODO merge this with Pomodoro.countdownRunningMinutes()
	function breakCallback() {
		minutes -= 1;

		if ( minutes == 0 ) {
			play( 7 ); // Attention.TONE_INTERVAL_ALERT
			ping( 100, 1500 );
			timer.stop();

			isBreakTimerStarted = false;
			pomodoroNumber += 1;
			resetMinutes();
		}

		Ui.requestUpdate();
	}

	// TODO: move to Pomodoro.makeTickingSound()
	function tickCallback() {
		ping( App.getApp().getProperty( "tickStrength" ), App.getApp().getProperty( "tickDuration" ) );
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
			Ui.pushView( new Rez.Menus.StopMenu(), new StopMenuDelegate(), Ui.SLIDE_UP );
			return true;
		} // else: we are in ready state

		// TODO: extract to Pomodoro.beginPomodoro()
		play( 1 ); // Attention.TONE_START
		ping( 75, 1500 );
		resetMinutes();
		timer.start( method( :pomodoroCallback ), 60 * 1000, true );
		isPomodoroTimerStarted = true;

		// TODO: extract to Pomodoro.beginTicking()
		if ( me.shouldTick() ) {
			tickTimer.start( method( :tickCallback ), 1000, true );
		}

		Ui.requestUpdate();
		return true;
	}
}
