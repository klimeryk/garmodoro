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

	hidden var pomodoroOffset;
	hidden var captionOffset;
	hidden var breakLabelOffset;
	hidden var readyLabelOffset;

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
		var largeOffset = Gfx.getFontHeight( Gfx.FONT_LARGE );
		var mediumOffset = Gfx.getFontHeight( Gfx.FONT_MEDIUM );
		var mediumOffsetHalf = mediumOffset / 2;
		var screenShape = System.getDeviceSettings().screenShape;

		me.pomodoroOffset = me.height - 5 - mediumOffset;
		if ( System.SCREEN_SHAPE_ROUND == screenShape ) {
			me.pomodoroOffset -= mediumOffsetHalf;
		}
		me.captionOffset = me.pomodoroOffset - Gfx.getFontHeight( Gfx.FONT_TINY );	

		me.breakLabelOffset = 5;
		if ( System.SCREEN_SHAPE_RECTANGLE != screenShape ) {
			me.breakLabelOffset += mediumOffsetHalf;
		}

		me.readyLabelOffset = me.centerY - ( largeOffset / 2 );
	}

	function onShow() {
	}

	function onUpdate( dc ) {
		dc.setColor( Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK );
		dc.clear();
		if ( isBreakTimerStarted ) {
			dc.setColor( Gfx.COLOR_DK_GREEN, Gfx.COLOR_TRANSPARENT );
			dc.drawText( me.centerX, me.breakLabelOffset, Gfx.FONT_MEDIUM, isLongBreak() ? me.longBreakLabel : me.shortBreakLabel, Gfx.TEXT_JUSTIFY_CENTER );

			dc.setColor( Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT );
			dc.drawText( me.centerX, me.centerY - me.thaiHotOffset, Gfx.FONT_NUMBER_THAI_HOT, minutes.format( "%02d" ), Gfx.TEXT_JUSTIFY_CENTER );

			dc.setColor( Gfx.COLOR_DK_GREEN, Gfx.COLOR_TRANSPARENT );
			me.drawCaption( dc );
		} else if ( isPomodoroTimerStarted ) {
			dc.setColor( Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT );
			dc.drawText( me.centerX, me.centerY - me.thaiHotOffset, Gfx.FONT_NUMBER_THAI_HOT, minutes.format( "%02d" ), Gfx.TEXT_JUSTIFY_CENTER );
			dc.setColor( Gfx.COLOR_DK_RED, Gfx.COLOR_TRANSPARENT );
			me.drawCaption( dc );
		} else {
			dc.setColor( Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT );
			dc.drawText( me.centerX, me.readyLabelOffset, Gfx.FONT_LARGE, me.readyLabel, Gfx.TEXT_JUSTIFY_CENTER );
		}

		dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
		dc.drawText( me.centerX, me.pomodoroOffset, Gfx.FONT_MEDIUM, "Pomodoro #" + pomodoroNumber, Gfx.TEXT_JUSTIFY_CENTER );
	}

	hidden function drawCaption( dc ) {
		dc.drawText( me.centerX, me.captionOffset, Gfx.FONT_TINY, me.pomodoroSubtitle, Gfx.TEXT_JUSTIFY_CENTER );
	}

	function onHide() {
	}
}
