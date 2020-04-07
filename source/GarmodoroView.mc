using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Lang;
using Pomodoro;

class GarmodoroView extends Ui.View {
	hidden var pomodoroSubtitle;
	hidden var shortBreakLabel;
	hidden var longBreakLabel;
	hidden var readyLabel;

	// all elements are centered in X direction
	hidden var centerX;

	// all offsets are in Y direction
	hidden var pomodoroOffset;
	hidden var captionOffset;
	hidden var readyLabelOffset;
	hidden var minutesOffset;
	hidden var timeOffset;

	function initialize() {
		View.initialize();
	}

	hidden function loadResources() {
		pomodoroSubtitle = Ui.loadResource( Rez.Strings.PomodoroSubtitle );
		shortBreakLabel = Ui.loadResource( Rez.Strings.ShortBreakLabel );
		longBreakLabel = Ui.loadResource( Rez.Strings.LongBreakLabel );
		readyLabel = Ui.loadResource( Rez.Strings.ReadyLabel );
	}

	hidden function calculateDrawingPositions( dc ) {
		me.centerX = dc.getWidth() / 2;

		// offsets relative to the top and bottom of the watch face
		me.pomodoroOffset = 5;

		var heightOfFontMild = Gfx.getFontHeight( Gfx.FONT_NUMBER_MILD );
		me.timeOffset = height - heightOfFontMild;

		// offsets relative to the center
		var centerY = dc.getHeight() / 2;
		var heightOfFontLarge = Gfx.getFontHeight( Gfx.FONT_LARGE );
		me.readyLabelOffset = centerY - heightOfFontLarge /2;

		var heightOfFontHot = Gfx.getFontHeight( Gfx.FONT_NUMBER_THAI_HOT );
		me.minutesOffset = centerY - heightOfFontHot / 2;

		var heightOfFontTiny = Gfx.getFontHeight( Gfx.FONT_TINY );
		me.captionOffset = me.timeOffset - heightOfFontTiny;

		me.adjustOffsetsForRoundScreen();
	}

	// 'special' case: non rectangular screens
	hidden function adjustOffsetsForRoundScreen() {
		var screenShape = System.getDeviceSettings().screenShape;
		if ( screenShape != System.SCREEN_SHAPE_RECTANGLE ) {
			var heightOfFontMedium = Gfx.getFontHeight( Gfx.FONT_MEDIUM );
			me.pomodoroOffset += heightOfFontMedium;

			me.timeOffset -= 5;
		}
	}

	function onLayout( dc ) {
		me.loadResources();
		me.calculateDrawingPositions( dc );		
	}

	function onShow() {
	}

	function onHide() {
	}

	function onUpdate( dc ) {
		me.drawBackground( dc, Gfx.COLOR_BLACK );

		if ( Pomodoro.isInBreakState() ) {
			me.drawBreakLabel( dc, Gfx.COLOR_GREEN );
			me.drawMinutes( dc, Gfx.COLOR_GREEN );
			me.drawCaption( dc, Gfx.COLOR_DK_GREEN );
		} else if ( Pomodoro.isInRunningState() ) {
			me.drawPomodoroLabel( dc, Gfx.COLOR_LT_GRAY );
			me.drawMinutes( dc, Gfx.COLOR_YELLOW );
			me.drawCaption( dc, Gfx.COLOR_ORANGE );
		} else { // Pomodoro is in ready state
			me.drawPomodoroLabel( dc, Gfx.COLOR_LT_GRAY );
			me.drawReadyLabel( dc, Gfx.COLOR_ORANGE );
		}

		drawTime( dc, Gfx.COLOR_LT_GRAY );
	}

	hidden function drawBackground( dc, backgroundColor ) {
		dc.setColor( Gfx.COLOR_TRANSPARENT, backgroundColor );
		dc.clear();
	}

	hidden function drawPomodoroLabel( dc, foregroundColor ) {
		var pomodoroLabel = "Pomodoro #" + Pomodoro.getIteration();
		dc.setColor( foregroundColor, Gfx.COLOR_TRANSPARENT );
		dc.drawText( me.centerX, me.pomodoroOffset, Gfx.FONT_MEDIUM,
					pomodoroLabel, Gfx.TEXT_JUSTIFY_CENTER );
	}

	hidden function drawBreakLabel( dc, foregroundColor ) {
		var labelForBreak = Pomodoro.isLongBreak() ?
					me.longBreakLabel :
					me.shortBreakLabel;
		dc.setColor( foregroundColor, Gfx.COLOR_TRANSPARENT );
		dc.drawText( me.centerX, me.pomodoroOffset, Gfx.FONT_MEDIUM,
					labelForBreak, Gfx.TEXT_JUSTIFY_CENTER );
	}

	hidden function drawReadyLabel( dc, foregroundColor ) {
		dc.setColor( foregroundColor, Gfx.COLOR_TRANSPARENT );
		dc.drawText( me.centerX, me.readyLabelOffset, Gfx.FONT_LARGE,
					me.readyLabel, Gfx.TEXT_JUSTIFY_CENTER );
	}

	hidden function drawMinutes( dc, foregroundColor ) {
		var minutesAsText = Pomodoro.getMinutesLeft();
		dc.setColor( foregroundColor, Gfx.COLOR_TRANSPARENT );
		dc.drawText( me.centerX, me.minutesOffset, Gfx.FONT_NUMBER_THAI_HOT, 
					minutesAsText, Gfx.TEXT_JUSTIFY_CENTER );
	}

	hidden function drawCaption( dc, foregroundColor ) {
		dc.setColor( foregroundColor, Gfx.COLOR_TRANSPARENT );
		dc.drawText( me.centerX, me.captionOffset, Gfx.FONT_TINY, 
					me.pomodoroSubtitle, Gfx.TEXT_JUSTIFY_CENTER );
	}

	hidden function drawTime( dc, foregroundColor ) {
		dc.setColor( foregroundColor, Gfx.COLOR_TRANSPARENT );
		dc.drawText( me.centerX, me.timeOffset, Gfx.FONT_NUMBER_MILD,
					me.getTime(), Gfx.TEXT_JUSTIFY_CENTER );
	}

	hidden function getTime() {
		var today = Gregorian.info( Time.now(), Time.FORMAT_SHORT );
		return Lang.format( "$1$:$2$", [
			today.hour.format( "%02d" ),
			today.min.format( "%02d" ),
		] );
	}
}
