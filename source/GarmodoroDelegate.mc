using Toybox.Application as App;
using Toybox.Attention as Attention;
using Toybox.WatchUi as Ui;
using Toybox.Lang as Lang;

const MINUTE_IN_MILISECONDS = 60 * 1000;

var timer;
var tickTimer;
var minutes = 0;
var pomodoroNumber = 1;
var isPomodoroTimerStarted as Lang.Boolean = false;
var isBreakTimerStarted as Lang.Boolean = false;
var needsClear as Lang.Boolean = true;

(:newPropertiesApi)
function getProperty(property as App.PropertyKeyType) as App.PropertyValueType {
	return App.Properties.getValue( property );
}

(:oldPropertiesApi)
function getProperty(property as App.PropertyKeyType) as App.PropertyValueType {
	return App.getApp().getProperty( property );
}

function ping( dutyCycle, length ) {
	if ( Attention has :vibrate ) {
		Attention.vibrate( [ new Attention.VibeProfile( dutyCycle, length ) ] );
	}
}

function play( tone ) {
	if ( Attention has :playTone && ! getProperty( "muteSounds" ) ) {
		Attention.playTone( tone );
	}
}

function isLongBreak() {
	return ( pomodoroNumber % getProperty( "numberOfPomodorosBeforeLongBreak" ) ) == 0;
}

function resetMinutes() {
	minutes = getProperty( "pomodoroLength" );
}

class GarmodoroDelegate extends Ui.BehaviorDelegate {
	function idleCallback() {
		Ui.requestUpdate();
	}

	function initialize() {
		Ui.BehaviorDelegate.initialize();
		timer.start( method( :idleCallback ), MINUTE_IN_MILISECONDS, true );
	}

	function pomodoroCallback() {
		minutes -= 1;

		if ( minutes == 0 ) {
			play( 10 ); // Attention.TONE_LAP
			ping( 100, 1500 );
			tickTimer.stop();
			timer.stop();
			isPomodoroTimerStarted = false;
			minutes = getProperty( isLongBreak() ? "longBreakLength" : "shortBreakLength" );

			timer.start( method( :breakCallback ), MINUTE_IN_MILISECONDS, true );
			needsClear = true;
			isBreakTimerStarted = true;
		}

		Ui.requestUpdate();
	}

	function breakCallback() {
		minutes -= 1;

		if ( minutes == 0 ) {
			play( 7 ); // Attention.TONE_INTERVAL_ALERT
			ping( 100, 1500 );
			timer.stop();

			needsClear = true;
			isBreakTimerStarted = false;
			pomodoroNumber += 1;
			resetMinutes();
			timer.start( method( :idleCallback ), MINUTE_IN_MILISECONDS, true );
		}

		Ui.requestUpdate();
	}

	function shouldTick() {
		return getProperty( "tickStrength" ) > 0;
	}

	function tickCallback() {
		ping( getProperty( "tickStrength" ), getProperty( "tickDuration" ) );
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
		}

		play( 1 ); // Attention.TONE_START
		ping( 75, 1500 );
		timer.stop();
		resetMinutes();
		timer.start( method( :pomodoroCallback ), MINUTE_IN_MILISECONDS, true );
		if ( me.shouldTick() ) {
			tickTimer.start( method( :tickCallback ), getProperty( "tickFrequency" ) * 1000, true );
		}
		isPomodoroTimerStarted = true;
		needsClear = true;

		Ui.requestUpdate();

		return true;
	}
}
