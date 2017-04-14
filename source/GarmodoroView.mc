using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as System;
using Toybox.Timer as Timer;

class GarmodoroView extends Ui.View {
	const APP = Application.getApp();
	hidden var numberOfPomodorosBeforeLongBreak = APP.getProperty( "numberOfPomodorosBeforeLongBreak" );
	hidden var pomodoroSubtitle;
	hidden var shortBreakLabel;
	hidden var longBreakLabel;
	hidden var readyLabel;
	hidden var centerX;
	hidden var centerY;

	function initialize() {
		System.println( "GomodoroView: initialize" );
		View.initialize();
	}

	// Load your resources here
	function onLayout(dc) {
		System.println( "onLayout" );

		pomodoroSubtitle = Ui.loadResource( Rez.Strings.PomodoroSubtitle );
		shortBreakLabel = Ui.loadResource( Rez.Strings.ShortBreakLabel );
		longBreakLabel = Ui.loadResource( Rez.Strings.LongBreakLabel );
		readyLabel = Ui.loadResource( Rez.Strings.ReadyLabel );

		centerX = dc.getWidth() / 2;
		centerY = dc.getHeight() / 2;
	}

	// Called when this View is brought to the foreground. Restore
	// the state of this View and prepare it to be shown. This includes
	// loading resources into memory.
	function onShow() {
		System.println( "onShow" );
	}

	// Update the view
	function onUpdate( dc ) {
		System.println( "onUpdate" );

		dc.setColor( Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK );
		dc.clear();
		if ( isBreakTimerStarted ) {
			dc.setColor( Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT );
			var isLongBreak = ( pomodoroNumber % me.numberOfPomodorosBeforeLongBreak ) == 0;
			dc.drawText( me.centerX, ( me.centerY - 30 ), Gfx.FONT_LARGE, isLongBreak ? me.longBreakLabel : me.shortBreakLabel, Gfx.TEXT_JUSTIFY_CENTER );
		} else if ( isPomodoroTimerStarted ) {
			dc.setColor( Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT );
			dc.drawText( me.centerX, ( me.centerY - 90 ), Gfx.FONT_NUMBER_THAI_HOT, minutes.format( "%02d" ), Gfx.TEXT_JUSTIFY_CENTER );
			dc.setColor( Gfx.COLOR_DK_RED, Gfx.COLOR_TRANSPARENT );
			dc.drawText( me.centerX, ( me.centerY + 10 ), Gfx.FONT_TINY, me.pomodoroSubtitle, Gfx.TEXT_JUSTIFY_CENTER );
		} else {
			dc.setColor( Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT );
			dc.drawText( me.centerX, ( me.centerY - 30 ), Gfx.FONT_LARGE, me.readyLabel, Gfx.TEXT_JUSTIFY_CENTER );
		}

		dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
		dc.drawText( me.centerX, ( me.centerY + 30 ), Gfx.FONT_MEDIUM, "Pomodoro #" + pomodoroNumber, Gfx.TEXT_JUSTIFY_CENTER );
	}

	// Called when this View is removed from the screen. Save the
	// state of this View here. This includes freeing resources from
	// memory.
	function onHide() {
		System.println( "onHide" );
	}
}
