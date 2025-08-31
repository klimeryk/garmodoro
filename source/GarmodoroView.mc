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

	hidden var centerX as Lang.Float = 0.0;
	hidden var centerY as Lang.Float = 0.0;

	hidden var pomodoroOffset as Lang.Float = 5.0;
	hidden var captionOffset as Lang.Float = 0.0;
	hidden var readyLabelOffset as Lang.Float = 0.0;
	hidden var minutesOffset as Lang.Float = 0.0;
	hidden var timeOffset as Lang.Float = 0.0;

	function initialize() {
		View.initialize();
	}

	function onLayout( dc ) {
		pomodoroSubtitle = Ui.loadResource( Rez.Strings.PomodoroSubtitle );
		shortBreakLabel = Ui.loadResource( Rez.Strings.ShortBreakLabel );
		longBreakLabel = Ui.loadResource( Rez.Strings.LongBreakLabel );
		readyLabel = Ui.loadResource( Rez.Strings.ReadyLabel );

		var height = dc.getHeight();
		centerX = dc.getWidth() / 2.0;
		centerY = height / 2.0;
		var mediumOffset = Gfx.getFontHeight( Gfx.FONT_MEDIUM );
		var mildOffset = Gfx.getFontHeight( Gfx.FONT_NUMBER_MILD );
		var screenShape = System.getDeviceSettings().screenShape;

		me.timeOffset = (height - mildOffset).toFloat();
		if ( System.SCREEN_SHAPE_RECTANGLE != screenShape ) {
			me.pomodoroOffset += mediumOffset;
			me.timeOffset -= 5.0;
		}

		me.readyLabelOffset = me.centerY - ( Gfx.getFontHeight( Gfx.FONT_LARGE ) / 2.0 );
		me.minutesOffset = me.centerY - ( Gfx.getFontHeight( Gfx.FONT_NUMBER_THAI_HOT ) / 2.0 );
		me.captionOffset = me.timeOffset - Gfx.getFontHeight( Gfx.FONT_TINY );
	}

	function onShow() {
	}

	function onUpdate( dc ) {
		if ( needsClear ) {
			dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_BLACK );
			dc.clear();
			needsClear = false;
		}

		if ( isBreakTimerStarted ) {
			dc.setColor( Gfx.COLOR_GREEN, Gfx.COLOR_BLACK );
			dc.drawText( me.centerX, me.pomodoroOffset, Gfx.FONT_MEDIUM, isLongBreak() ? me.longBreakLabel : me.shortBreakLabel, Gfx.TEXT_JUSTIFY_CENTER );
			me.drawMinutes( dc );

			dc.setColor( Gfx.COLOR_DK_GREEN, Gfx.COLOR_BLACK );
			me.drawCaption( dc );
		} else if ( isPomodoroTimerStarted ) {
			dc.setColor( Gfx.COLOR_YELLOW, Gfx.COLOR_BLACK );
			me.drawMinutes( dc );
			dc.setColor( Gfx.COLOR_ORANGE, Gfx.COLOR_BLACK );
			me.drawCaption( dc );
		} else {
			dc.setColor( Gfx.COLOR_ORANGE, Gfx.COLOR_BLACK );
			dc.drawText( me.centerX, me.readyLabelOffset, Gfx.FONT_LARGE, me.readyLabel, Gfx.TEXT_JUSTIFY_CENTER );
		}

		if ( ! isBreakTimerStarted ) {
			dc.setColor( Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK );
			dc.drawText( me.centerX, me.pomodoroOffset, Gfx.FONT_MEDIUM, "Pomodoro #" + pomodoroNumber, Gfx.TEXT_JUSTIFY_CENTER );
		}

		dc.setColor( Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK );
		dc.drawText( self.centerX, self.timeOffset, Gfx.FONT_NUMBER_MILD, self.getTime(), Gfx.TEXT_JUSTIFY_CENTER );
	}

	hidden function drawMinutes( dc ) {
		dc.drawText( me.centerX, me.minutesOffset, Gfx.FONT_NUMBER_THAI_HOT, me.formatAsDoubleDigit( minutes ), Gfx.TEXT_JUSTIFY_CENTER );
	}

	hidden function drawCaption( dc ) {
		dc.drawText( me.centerX, me.captionOffset, Gfx.FONT_TINY, me.pomodoroSubtitle, Gfx.TEXT_JUSTIFY_CENTER );
	}

	function onHide() {
	}

	function getTime() {
		var today = Gregorian.info( Time.now(), Time.FORMAT_SHORT );
		return me.formatAsDoubleDigit( today.hour ) + ":" + me.formatAsDoubleDigit( today.min );
	}

	function formatAsDoubleDigit(number as Lang.Number) as Lang.String {
		if ( number >= 10 ) {
			return number.toString();
		}

		return "0" + number;
	}
}
