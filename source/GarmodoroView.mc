using Toybox.Application as Application;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

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
		View.initialize();
	}

	function onLayout( dc ) {
		pomodoroSubtitle = Ui.loadResource( Rez.Strings.PomodoroSubtitle );
		shortBreakLabel = Ui.loadResource( Rez.Strings.ShortBreakLabel );
		longBreakLabel = Ui.loadResource( Rez.Strings.LongBreakLabel );
		readyLabel = Ui.loadResource( Rez.Strings.ReadyLabel );

		centerX = dc.getWidth() / 2;
		centerY = dc.getHeight() / 2;
	}

	function onShow() {
	}

	function onUpdate( dc ) {
		dc.setColor( Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK );
		dc.clear();
		if ( isBreakTimerStarted ) {
			dc.setColor( Gfx.COLOR_DK_GREEN, Gfx.COLOR_TRANSPARENT );
			var isLongBreak = ( pomodoroNumber % me.numberOfPomodorosBeforeLongBreak ) == 0;
			dc.drawText( me.centerX, ( me.centerY - 80 ), Gfx.FONT_MEDIUM, isLongBreak ? me.longBreakLabel : me.shortBreakLabel, Gfx.TEXT_JUSTIFY_CENTER );

			dc.setColor( Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT );
			dc.drawText( me.centerX, ( me.centerY - 70 ), Gfx.FONT_NUMBER_THAI_HOT, minutesOfBreakLeft.format( "%02d" ), Gfx.TEXT_JUSTIFY_CENTER );

			dc.setColor( Gfx.COLOR_DK_GREEN, Gfx.COLOR_TRANSPARENT );
			dc.drawText( me.centerX, ( me.centerY + 30 ), Gfx.FONT_TINY, me.pomodoroSubtitle, Gfx.TEXT_JUSTIFY_CENTER );
		} else if ( isPomodoroTimerStarted ) {
			dc.setColor( Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT );
			dc.drawText( me.centerX, ( me.centerY - 70 ), Gfx.FONT_NUMBER_THAI_HOT, minutes.format( "%02d" ), Gfx.TEXT_JUSTIFY_CENTER );
			dc.setColor( Gfx.COLOR_DK_RED, Gfx.COLOR_TRANSPARENT );
			dc.drawText( me.centerX, ( me.centerY + 30 ), Gfx.FONT_TINY, me.pomodoroSubtitle, Gfx.TEXT_JUSTIFY_CENTER );
		} else {
			dc.setColor( Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT );
			dc.drawText( me.centerX, ( me.centerY - 20 ), Gfx.FONT_LARGE, me.readyLabel, Gfx.TEXT_JUSTIFY_CENTER );
		}

		dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
		dc.drawText( me.centerX, ( me.centerY + 50 ), Gfx.FONT_MEDIUM, "Pomodoro #" + pomodoroNumber, Gfx.TEXT_JUSTIFY_CENTER );
	}

	function onHide() {
	}
}
