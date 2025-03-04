using Toybox.System;
using Toybox.Application.Storage;
using Toybox.Time;
using Toybox.Application as App;

(:background)
class GarmodoroServiceDelegate extends System.ServiceDelegate {
  hidden function getStorageValue(key, defaultValue) {
    var value = Storage.getValue(key);
    return value != null ? value : defaultValue;
  }

  hidden function setStorageValue(key, value) {
    Storage.setValue(key, value);
  }

  hidden function getSeconds() {
    var currentTime = Time.now();
    var endTime = getStorageValue(ENDTIME_PROPERTY_STORAGE_KEY, null);
    if (endTime == null) {
      return null;
    }
    var remainingSeconds = endTime - currentTime.value();
    return remainingSeconds;
  }

  public function onTemporalEvent() as Void {
    var seconds = me.getSeconds();
    if (seconds <= 60) {
      var isPomodoroTimerStarted = getStorageValue(
        POMODORO_TIMER_STARTED_PROPERTY_STORAGE_KEY,
        false
      );
      var isBreakTimerStarted = getStorageValue(
        BREAK_TIMER_STARTED_PROPERTY_STORAGE_KEY,
        false
      );

      if (isPomodoroTimerStarted) {
        me.pomodoroLogic();
        var message = isLongBreak()
          ? "Pomodoro is over. Take a long break."
          : "Pomodoro is over. Take a short break.";
        Background.requestApplicationWake(message);
      }

      if (isBreakTimerStarted) {
        me.breakLogic();
        Background.requestApplicationWake(
          "Break is over. Time to start a pomodoro."
        );
      }
      Background.exit(null);
    }
  }

  public function breakLogic() {
    me.setStorageValue(BREAK_TIMER_STARTED_PROPERTY_STORAGE_KEY, false);
    var pomodoroNumber = getStorageValue(
      POMODORO_NUMBER_PROPERTY_STORAGE_KEY,
      1
    );
    me.setStorageValue(
      POMODORO_NUMBER_PROPERTY_STORAGE_KEY,
      pomodoroNumber + 1
    );
    me.setStorageValue(POMODORO_TIMER_STARTED_PROPERTY_STORAGE_KEY, true);
    resetMinutes();
  }

  public function pomodoroLogic() {
    setStorageValue(POMODORO_TIMER_STARTED_PROPERTY_STORAGE_KEY, false);
    var breakLengthInMinutes = App.getApp().getProperty(
      isLongBreak() ? "longBreakLength" : "shortBreakLength"
    );
    setEndTimeBySeconds(breakLengthInMinutes * 60);
    setStorageValue(BREAK_TIMER_STARTED_PROPERTY_STORAGE_KEY, true);
  }

  function isLongBreak() {
    var pomodoroNumber = getStorageValue(
      POMODORO_NUMBER_PROPERTY_STORAGE_KEY,
      1
    );
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

  function setEndTimeBySeconds(seconds) {
    var date =
      seconds != null
        ? Time.now().add(new Time.Duration(seconds)).value()
        : null;
    Storage.setValue(ENDTIME_PROPERTY_STORAGE_KEY, date);
    if (Background.getTemporalEventRegisteredTime() != null) {
      Background.deleteTemporalEvent();
    }
    if (seconds != null) {
      Background.registerForTemporalEvent(new Time.Duration(seconds));
    }
  }
}
