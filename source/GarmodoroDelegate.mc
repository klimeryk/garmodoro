using Toybox.Application as App;
using Toybox.Attention as Attention;
using Toybox.WatchUi as Ui;
using Toybox.System;


var timer;
var tickTimer;

function ping( dutyCycle, length ) {
	if ( Attention has :vibrate ) {
		Attention.vibrate( [ new Attention.VibeProfile( dutyCycle, length ) ] );
	}
}

function play( tone ) {
	if ( Attention has :playTone && ! App.getApp().getProperty( "muteSounds" ) ) {
		Attention.playTone( tone );
	}
}

function idleCallback() {
	Ui.requestUpdate();
}

function isLongBreak() {
  var pomodoroNumber = getStorageValue(POMODORO_NUMBER_PROPERTY_STORAGE_KEY, 1);
  return (
    pomodoroNumber %
      App.getApp().getProperty("numberOfPomodorosBeforeLongBreak") ==
    0
  );
}

function resetMinutes() {
  var minutes = App.getApp().getProperty("pomodoroLength");
  var minutesAsSeconds = minutes * 60;
  setEndTimeBySeconds(minutesAsSeconds);
}

class GarmodoroDelegate extends Ui.BehaviorDelegate {
	function initialize() {
		timer = new Timer.Timer();
    	tickTimer = new Timer.Timer();
		Ui.BehaviorDelegate.initialize();
		timer.start( method( :idleCallback ), 10 * 1000, true );
		var isPomodoroTimerStarted = getStorageValue(POMODORO_TIMER_STARTED_PROPERTY_STORAGE_KEY, false);
		var isBreakTimerStarted = getStorageValue(BREAK_TIMER_STARTED_PROPERTY_STORAGE_KEY, false);

		if(isPomodoroTimerStarted){
			pomodoroCallback();
		}

		if(isBreakTimerStarted){
			breakCallback();
		}
	}

	function pomodoroCallback() {	
		var seconds = getSeconds();
		if (seconds <= 0 ) {
			play( 10 ); // Attention.TONE_LAP
			ping( 100, 1500 );
			tickTimer.stop();
			timer.stop();
			setStorageValue(POMODORO_TIMER_STARTED_PROPERTY_STORAGE_KEY, false);
			var breakLengthInMinutes = App.getApp().getProperty(
			isLongBreak() ? "longBreakLength" : "shortBreakLength"
			);
			setEndTimeBySeconds(breakLengthInMinutes * 60);
			setStorageValue(BREAK_TIMER_STARTED_PROPERTY_STORAGE_KEY, true);
			timer.start( method( :breakCallback ), 10 * 1000, true );
		}

		Ui.requestUpdate();
	}

	function breakCallback() {
		var seconds = getSeconds();
		if ( seconds <= 0 ) {
			play( 7 ); // Attention.TONE_INTERVAL_ALERT
			ping( 100, 1500 );
			timer.stop();
			setStorageValue(BREAK_TIMER_STARTED_PROPERTY_STORAGE_KEY, false);
			var pomodoroNumber = getStorageValue(POMODORO_NUMBER_PROPERTY_STORAGE_KEY, 1);
			setStorageValue(POMODORO_NUMBER_PROPERTY_STORAGE_KEY, pomodoroNumber + 1);
			setStorageValue(POMODORO_TIMER_STARTED_PROPERTY_STORAGE_KEY, true);
			resetMinutes();
			timer.start( method( :idleCallback ), 10 * 1000, true );
		}

		Ui.requestUpdate();
	}

	function shouldTick() {
		return App.getApp().getProperty( "tickStrength" ) > 0;
	}

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
		var isBreakTimerStarted = getStorageValue(BREAK_TIMER_STARTED_PROPERTY_STORAGE_KEY, false);
		var isPomodoroTimerStarted = getStorageValue(POMODORO_TIMER_STARTED_PROPERTY_STORAGE_KEY, false);
		if ( isBreakTimerStarted || isPomodoroTimerStarted ) {
			Ui.pushView( new Rez.Menus.StopMenu(), new StopMenuDelegate(), Ui.SLIDE_UP );
			return true;
		}

		play( 1 ); // Attention.TONE_START
		ping( 75, 1500 );
		timer.stop();
		resetMinutes();
		timer.start( method( :pomodoroCallback ), 10 * 1000, true );
		if ( me.shouldTick() ) {
			tickTimer.start( method( :tickCallback ), App.getApp().getProperty( "tickFrequency" ) * 1000, true );
		}
		setStorageValue(POMODORO_TIMER_STARTED_PROPERTY_STORAGE_KEY, true);
		Ui.requestUpdate();

		return true;
	}
}
