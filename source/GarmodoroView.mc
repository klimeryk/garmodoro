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
	hidden var centerY;

	// all offsets are in Y direction
	hidden var pomodoroOffset;
	hidden var captionOffset;
	hidden var readyLabelOffset;
	hidden var minutesOffset;
	hidden var timeOffset;

	function initialize() {
		View.initialize();
	}

	function loadResources() {
		pomodoroSubtitle = Ui.loadResource( Rez.Strings.PomodoroSubtitle );
		shortBreakLabel = Ui.loadResource( Rez.Strings.ShortBreakLabel );
		longBreakLabel = Ui.loadResource( Rez.Strings.LongBreakLabel );
		readyLabel = Ui.loadResource( Rez.Strings.ReadyLabel );
	}

	function calculateDrawingPositions() {
		var height = dc.getHeight();
		centerX = dc.getWidth() / 2;
		centerY = height / 2;

		var mediumOffset = Gfx.getFontHeight( Gfx.FONT_MEDIUM );
		var mediumOffsetHalf = mediumOffset / 2;
		var mildOffset = Gfx.getFontHeight( Gfx.FONT_NUMBER_MILD );
		var screenShape = System.getDeviceSettings().screenShape;

		me.timeOffset = height - mildOffset;
		me.pomodoroOffset = 5;
		if ( System.SCREEN_SHAPE_RECTANGLE != screenShape ) {
			me.pomodoroOffset += mediumOffset;
			me.timeOffset -= 5;
		}

		me.readyLabelOffset = me.centerY - 
					( Gfx.getFontHeight( Gfx.FONT_LARGE ) / 2 );
		me.minutesOffset = me.centerY - 
					( Gfx.getFontHeight( Gfx.FONT_NUMBER_THAI_HOT ) / 2 );
		me.captionOffset = me.timeOffset - 
					Gfx.getFontHeight( Gfx.FONT_TINY );	
	}

	function onLayout( dc ) {
		// TODO can we move these to initialize() ?
		me.loadResources();
		me.calculateDrawingPositions();
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
		// TODO inline format() in getMinutesLeft()
		var minutesAsText = Pomodoro.getMinutesLeft().format( "%02d" );
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
		dc.drawText( self.centerX, self.timeOffset, Gfx.FONT_NUMBER_MILD,
					self.getTime(), Gfx.TEXT_JUSTIFY_CENTER );
	}

	function getTime() {
		var today = Gregorian.info( Time.now(), Time.FORMAT_SHORT );
		return Lang.format( "$1$:$2$", [
			today.hour.format( "%02d" ),
			today.min.format( "%02d" ),
		] );
	}
}
