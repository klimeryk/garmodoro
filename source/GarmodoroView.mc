using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Lang;

class GarmodoroView extends Ui.View {
	hidden var pomodoroSubtitle;
	hidden var shortBreakLabel;
	hidden var longBreakLabel;
	hidden var readyLabel;

	hidden var centerX;
	hidden var centerY;

	hidden var pomodoroOffset;
	hidden var captionOffset;
	hidden var readyLabelOffset;
	hidden var minutesOffset;
	hidden var timeOffset;

	function initialize() {
		View.initialize();
	}

	function onLayout( dc ) {
		pomodoroSubtitle = Ui.loadResource( Rez.Strings.PomodoroSubtitle );
		shortBreakLabel = Ui.loadResource( Rez.Strings.ShortBreakLabel );
		longBreakLabel = Ui.loadResource( Rez.Strings.LongBreakLabel );
		readyLabel = Ui.loadResource( Rez.Strings.ReadyLabel );

		var height = dc.getHeight();
		centerX = dc.getWidth() / 2;
		centerY = height / 2;
		var mediumOffset = Gfx.getFontHeight( Gfx.FONT_MEDIUM );
		var mildOffset = Gfx.getFontHeight( Gfx.FONT_NUMBER_MILD );
		var screenShape = System.getDeviceSettings().screenShape;

		me.timeOffset = height - mildOffset;
		me.pomodoroOffset = 5;
		if ( System.SCREEN_SHAPE_RECTANGLE != screenShape ) {
			me.pomodoroOffset += mediumOffset;
			me.timeOffset -= 5;
		}

		me.readyLabelOffset = me.centerY - ( Gfx.getFontHeight( Gfx.FONT_LARGE ) / 2 );
		me.minutesOffset = me.centerY - ( Gfx.getFontHeight( Gfx.FONT_NUMBER_THAI_HOT ) / 2 );
		me.captionOffset = me.timeOffset - Gfx.getFontHeight( Gfx.FONT_TINY );
	}

	function onShow() {
	}

	function onUpdate( dc ) {
		dc.setColor( Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK );
		dc.clear();
		if ( isBreakTimerStarted ) {
			dc.setColor( Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT );
			dc.drawText( me.centerX, me.pomodoroOffset, Gfx.FONT_MEDIUM, isLongBreak() ? me.longBreakLabel : me.shortBreakLabel, Gfx.TEXT_JUSTIFY_CENTER );
			me.drawMinutes( dc );

			dc.setColor( Gfx.COLOR_DK_GREEN, Gfx.COLOR_TRANSPARENT );
			me.drawCaption( dc );
		} else if ( isPomodoroTimerStarted ) {
			dc.setColor( Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT );
			me.drawMinutes( dc );
			dc.setColor( Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT );
			me.drawCaption( dc );
		} else {
			dc.setColor( Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT );
			dc.drawText( me.centerX, me.readyLabelOffset, Gfx.FONT_LARGE, me.readyLabel, Gfx.TEXT_JUSTIFY_CENTER );
		}

		if ( ! isBreakTimerStarted ) {
			dc.setColor( Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT );
			dc.drawText( me.centerX, me.pomodoroOffset, Gfx.FONT_MEDIUM, "Pomodoro #" + pomodoroNumber, Gfx.TEXT_JUSTIFY_CENTER );
		}

		dc.setColor( Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT );
		dc.drawText( self.centerX, self.timeOffset, Gfx.FONT_NUMBER_MILD, self.getTime(), Gfx.TEXT_JUSTIFY_CENTER );
	}

	hidden function drawMinutes( dc ) {
		dc.drawText( me.centerX, me.minutesOffset, Gfx.FONT_NUMBER_THAI_HOT, minutes.format( "%02d" ), Gfx.TEXT_JUSTIFY_CENTER );
	}

	hidden function drawCaption( dc ) {
		dc.drawText( me.centerX, me.captionOffset, Gfx.FONT_TINY, me.pomodoroSubtitle, Gfx.TEXT_JUSTIFY_CENTER );
	}

	function onHide() {
	}

	function getTime() {
		var today = Gregorian.info( Time.now(), Time.FORMAT_SHORT );
		return Lang.format( "$1$:$2$", [
			today.hour.format( "%02d" ),
			today.min.format( "%02d" ),
		] );
	}
}
