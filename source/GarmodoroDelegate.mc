using Toybox.Application as App;
using Toybox.Attention as Attention;
using Toybox.WatchUi as Ui;
using Toybox.Timer as Timer;

import Toybox.Lang;

const MINUTE_IN_MILISECONDS = 60 * 1000;

var timer as Timer.Timer = new Timer.Timer();
var tickTimer as Timer.Timer = new Timer.Timer();
var minutes as Number = 0;
var pomodoroNumber as Number = 1;
var isPomodoroTimerStarted as Boolean = false;
var isBreakTimerStarted as Boolean = false;
var needsClear as Boolean = true;

(:newPropertiesApi)
function getProperty(property as App.PropertyKeyType) as App.PropertyValueType {
	return App.Properties.getValue( property );
}

(:oldPropertiesApi)
function getProperty(property as App.PropertyKeyType) as App.PropertyValueType {
	return App.getApp().getProperty( property );
}

function ping( dutyCycle as Number, length as Number ) as Void {
	if ( Attention has :vibrate ) {
		Attention.vibrate( [ new Attention.VibeProfile( dutyCycle, length ) ] );
	}
}

function play( tone as Attention.Tone ) as Void {
	if ( Attention has :playTone && ! ( getProperty( "muteSounds" ) as Boolean ) ) {
		Attention.playTone( tone );
	}
}

function isLongBreak() as Boolean {
	return ( pomodoroNumber % getProperty( "numberOfPomodorosBeforeLongBreak" ) as Number ) == 0;
}

function resetMinutes() as Void {
	minutes = getProperty( "pomodoroLength" ) as Number;
}

class GarmodoroDelegate extends Ui.BehaviorDelegate {
	function idleCallback() as Void {
		Ui.requestUpdate();
	}

	function initialize() {
		Ui.BehaviorDelegate.initialize();
		timer.start( method( :idleCallback ), MINUTE_IN_MILISECONDS, true );
	}

	function pomodoroCallback() as Void {
		minutes -= 1;

		if ( minutes == 0 ) {
			play( Attention.TONE_LAP );
			ping( 100, 1500 );
			tickTimer.stop();
			timer.stop();
			isPomodoroTimerStarted = false;
			minutes = getProperty( isLongBreak() ? "longBreakLength" : "shortBreakLength" ) as Number;

			timer.start( method( :breakCallback ), MINUTE_IN_MILISECONDS, true );
			needsClear = true;
			isBreakTimerStarted = true;
		}

		Ui.requestUpdate();
	}

	function breakCallback() as Void {
		minutes -= 1;

		if ( minutes == 0 ) {
			play( Attention.TONE_INTERVAL_ALERT );
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

	function shouldTick() as Boolean {
		return getProperty( "tickStrength" ) as Number > 0;
	}

	function tickCallback() as Void {
		ping( getProperty( "tickStrength" ) as Number, getProperty( "tickDuration" ) as Number );
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

		play( Attention.TONE_START );
		ping( 75, 1500 );
		timer.stop();
		resetMinutes();
		timer.start( method( :pomodoroCallback ), MINUTE_IN_MILISECONDS, true );
		if ( me.shouldTick() ) {
			tickTimer.start( method( :tickCallback ), getProperty( "tickFrequency" ) as Number * 1000, true );
		}
		isPomodoroTimerStarted = true;
		needsClear = true;

		Ui.requestUpdate();

		return true;
	}
}
