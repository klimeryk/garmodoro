using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as System;

class GarmodoroView extends Ui.View {
	hidden var pomodoroSubtitle;
	hidden var shortBreakLabel;
	hidden var longBreakLabel;
	hidden var readyLabel;

	hidden var height;
	hidden var centerX;
	hidden var centerY;
	hidden var thaiHotOffset;
	hidden var largeOffset;
	hidden var mediumOffset;
	hidden var tinyOffset;
	hidden var screenShape;

	function initialize() {
		View.initialize();
	}

	function onLayout( dc ) {
		pomodoroSubtitle = Ui.loadResource( Rez.Strings.PomodoroSubtitle );
		shortBreakLabel = Ui.loadResource( Rez.Strings.ShortBreakLabel );
		longBreakLabel = Ui.loadResource( Rez.Strings.LongBreakLabel );
		readyLabel = Ui.loadResource( Rez.Strings.ReadyLabel );

		height = dc.getHeight();
		centerX = dc.getWidth() / 2;
		centerY = me.height / 2;
		thaiHotOffset = Gfx.getFontHeight( Gfx.FONT_NUMBER_THAI_HOT ) / 2;
		largeOffset = Gfx.getFontHeight( Gfx.FONT_LARGE );
		mediumOffset = Gfx.getFontHeight( Gfx.FONT_MEDIUM );
		tinyOffset = Gfx.getFontHeight( Gfx.FONT_TINY );
		screenShape = System.getDeviceSettings().screenShape;
	}

	function onShow() {
	}

	function onUpdate( dc ) {
		dc.setColor( Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK );
		dc.clear();
		if ( isBreakTimerStarted ) {
			dc.setColor( Gfx.COLOR_DK_GREEN, Gfx.COLOR_TRANSPARENT );
			if ( System.SCREEN_SHAPE_RECTANGLE == me.screenShape ) {
				dc.drawText( me.centerX, 5, Gfx.FONT_MEDIUM, isLongBreak() ? me.longBreakLabel : me.shortBreakLabel, Gfx.TEXT_JUSTIFY_CENTER );
			} else {
				dc.drawText( me.centerX, 5 + ( mediumOffset / 2 ), Gfx.FONT_MEDIUM, isLongBreak() ? me.longBreakLabel : me.shortBreakLabel, Gfx.TEXT_JUSTIFY_CENTER );
			}

			dc.setColor( Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT );
			dc.drawText( me.centerX, me.centerY - me.thaiHotOffset, Gfx.FONT_NUMBER_THAI_HOT, minutes.format( "%02d" ), Gfx.TEXT_JUSTIFY_CENTER );

			dc.setColor( Gfx.COLOR_DK_GREEN, Gfx.COLOR_TRANSPARENT );
			drawSubtitle( dc );
		} else if ( isPomodoroTimerStarted ) {
			dc.setColor( Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT );
			dc.drawText( me.centerX, me.centerY - me.thaiHotOffset, Gfx.FONT_NUMBER_THAI_HOT, minutes.format( "%02d" ), Gfx.TEXT_JUSTIFY_CENTER );
			dc.setColor( Gfx.COLOR_DK_RED, Gfx.COLOR_TRANSPARENT );
			drawSubtitle( dc );
		} else {
			dc.setColor( Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT );
			dc.drawText( me.centerX, me.centerY - ( largeOffset / 2 ), Gfx.FONT_LARGE, me.readyLabel, Gfx.TEXT_JUSTIFY_CENTER );
		}

		dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
		if ( System.SCREEN_SHAPE_ROUND == me.screenShape ) {
			dc.drawText( me.centerX, me.height - 5 - mediumOffset - ( mediumOffset / 2 ), Gfx.FONT_MEDIUM, "Pomodoro #" + pomodoroNumber, Gfx.TEXT_JUSTIFY_CENTER );
		} else {
			dc.drawText( me.centerX, me.height - 5 - mediumOffset, Gfx.FONT_MEDIUM, "Pomodoro #" + pomodoroNumber, Gfx.TEXT_JUSTIFY_CENTER );
		}
	}

	hidden function drawSubtitle( dc ) {
		var offsetY = me.height - 5 - me.mediumOffset - me.tinyOffset;
		if ( System.SCREEN_SHAPE_ROUND == me.screenShape ) {
			offsetY -= me.mediumOffset / 2;
		}
		dc.drawText( me.centerX, offsetY, Gfx.FONT_TINY, me.pomodoroSubtitle, Gfx.TEXT_JUSTIFY_CENTER );
	}

	function onHide() {
	}
}
