using Toybox.Application as App;
using Toybox.Attention as Attention;
using Toybox.WatchUi as Ui;
using Toybox.Timer as Timer;
using Toybox.ActivityRecording as ActivityRecording;
using Toybox.Position;

import Toybox.Lang;

const MINUTE_IN_MILISECONDS = 60 * 1000;

var timer as Timer.Timer = new Timer.Timer();
var tickTimer as Timer.Timer = new Timer.Timer();
var minutes as Number = 0;
var pomodoroNumber as Number = 1;
var isPomodoroTimerStarted as Boolean = false;
var isBreakTimerStarted as Boolean = false;
var needsClear as Boolean = true;
var strongVibration as Attention.VibeProfile = new Attention.VibeProfile( 100, 1500);
var softVibration as Attention.VibeProfile = new Attention.VibeProfile( 70, 1500 );
var session as ActivityRecording.Session?;

(:newPropertiesApi)
function getProperty(property as App.PropertyKeyType) as App.PropertyValueType {
	return App.Properties.getValue( property );
}

(:oldPropertiesApi)
function getProperty(property as App.PropertyKeyType) as App.PropertyValueType {
	return App.getApp().getProperty( property );
}

function ping( vibeProfile as Attention.VibeProfile ) as Void {
	if ( Attention has :vibrate ) {
		Attention.vibrate( [ vibeProfile ] );
	}
}

function play( tone as Attention.Tone ) as Void {
	if ( Attention has :playTone && ! ( getProperty( "muteSounds" ) as Boolean ) ) {
		Attention.playTone( tone );
	}
}

function requestViewUpdate( withClear as Boolean ) as Void {
	needsClear = withClear || ! ( getProperty( "optimizeRendering" ) as Boolean );
	Ui.requestUpdate();
}

function isLongBreak() as Boolean {
	return ( pomodoroNumber % getProperty( "numberOfPomodorosBeforeLongBreak" ) as Number ) == 0;
}

function resetMinutes() as Void {
	minutes = getProperty( "pomodoroLength" ) as Number;
}

class GarmodoroDelegate extends Ui.BehaviorDelegate {
	hidden var tickVibration as Attention.VibeProfile = new Attention.VibeProfile( getProperty( "tickStrength" ) as Number, getProperty( "tickDuration" ) as Number );

	function idleCallback() as Void {
		requestViewUpdate( false );
	}

	function initialize() {
		Ui.BehaviorDelegate.initialize();
		timer.start( method( :idleCallback ), MINUTE_IN_MILISECONDS, true );
	}

	function pomodoroCallback() as Void {
		minutes -= 1;

		if ( minutes == 0 ) {
			play( Attention.TONE_LAP );
			ping( strongVibration );
			tickTimer.stop();
			timer.stop();
			isPomodoroTimerStarted = false;

			// Stop and save activity session
			stopActivitySession();

			minutes = getProperty( isLongBreak() ? "longBreakLength" : "shortBreakLength" ) as Number;

			timer.start( method( :breakCallback ), MINUTE_IN_MILISECONDS, true );
			isBreakTimerStarted = true;
		}

		requestViewUpdate( isBreakTimerStarted );
	}

	function breakCallback() as Void {
		minutes -= 1;

		if ( minutes == 0 ) {
			play( Attention.TONE_INTERVAL_ALERT );
			ping( strongVibration );
			timer.stop();

			isBreakTimerStarted = false;
			pomodoroNumber += 1;
			resetMinutes();
			timer.start( method( :idleCallback ), MINUTE_IN_MILISECONDS, true );
		}

		requestViewUpdate( ! isBreakTimerStarted );
	}

	function shouldTick() as Boolean {
		return getProperty( "tickStrength" ) as Number > 0;
	}

	function tickCallback() as Void {
		ping( me.tickVibration );
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

		// Show task selection menu
		showTaskSelectionMenu();
		return true;
	}

	// Show menu for task selection
	function showTaskSelectionMenu() as Void {
		var menu = TaskMenuBuilder.buildMenu();
		var delegate = new TaskMenuDelegate(method(:startTimerAfterSelection));
		Ui.pushView(menu, delegate, Ui.SLIDE_UP);
	}

	// Callback after task selection
	function startTimerAfterSelection() as Void {
		play( Attention.TONE_START );
		ping( softVibration );
		timer.stop();
		resetMinutes();

		// Start activity recording session
		startActivitySession();

		timer.start( method( :pomodoroCallback ), MINUTE_IN_MILISECONDS, true );
		if ( me.shouldTick() ) {
			tickTimer.start( method( :tickCallback ), getProperty( "tickFrequency" ) as Number * 1000, true );
		}
		isPomodoroTimerStarted = true;

		requestViewUpdate( true );
	}

	// Start activity recording session
	function startActivitySession() as Void {
		if (session != null) {
			try {
				session.stop();
				session.save();
			} catch (e) {
				// Ignore errors from previous session
			}
			session = null;
		}

		var sport = App.Properties.getValue("current_sport");
		var subsport = App.Properties.getValue("current_subsport");
		var taskName = App.Properties.getValue("current_task_name");

		// Protection from null
		if (sport == null) { sport = 0; }
		if (subsport == null) { subsport = 0; }
		if (taskName == null) { taskName = "Pomodoro"; }

		// Disable GPS to save battery
		if (Toybox has :Position) {
			Position.enableLocationEvents(Position.LOCATION_DISABLE, null);
		}

		try {
			session = ActivityRecording.createSession({
				:name => taskName,
				:sport => sport,
				:subSport => subsport
			});

			session.start();

			System.println("Activity session started: " + taskName +
			               " (sport=" + sport + ", subsport=" + subsport + ")");
		} catch (e) {
			System.println("Failed to start activity session: " + e);
			session = null;
		}
	}

	// Stop and save activity recording session
	function stopActivitySession() as Void {
		if (session != null) {
			try {
				session.stop();
				session.save();
				System.println("Activity session saved");
			} catch (e) {
				System.println("Failed to save activity session: " + e);
			}
			session = null;
		}
	}
}
