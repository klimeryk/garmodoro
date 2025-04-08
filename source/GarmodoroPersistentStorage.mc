using Toybox.Time;
using Toybox.Background;
using Toybox.Math;
using Toybox.Application.Storage;

const ENDTIME_PROPERTY_STORAGE_KEY = "end_time";
const POMODORO_NUMBER_PROPERTY_STORAGE_KEY = "pomodoro_number";
const POMODORO_TIMER_STARTED_PROPERTY_STORAGE_KEY = "pomodoro_timer_started";
const BREAK_TIMER_STARTED_PROPERTY_STORAGE_KEY = "break_timer_started";

function setEndTimeBySeconds(seconds) {
  var date =
    seconds != null ? Time.now().add(new Time.Duration(seconds)).value() : null;
  Storage.setValue(ENDTIME_PROPERTY_STORAGE_KEY, date);
  if (Background.getTemporalEventRegisteredTime() != null) {
    Background.deleteTemporalEvent();
  }
  if (seconds != null) {
    Background.registerForTemporalEvent(new Time.Duration(seconds));
  }
}

function setStorageValue(key, value) {
  Storage.setValue(key, value);
}

function getStorageValue(key, defaultValue) {
  var value = Storage.getValue(key);
  return value != null ? value : defaultValue;
}

function getSeconds() {
  var currentTime = Time.now();
  var endTime = getStorageValue(ENDTIME_PROPERTY_STORAGE_KEY, null);
  if (endTime == null) {
    return null;
  }
  var remainingSeconds = endTime - currentTime.value();
  return remainingSeconds;
}

function getMinutes() {
  var remainingSeconds = getSeconds();
  if (remainingSeconds == null) {
    return null;
  }
  var remainingMinutes = Math.ceil(remainingSeconds.toFloat() / 60); // Convert seconds to minutes
  return remainingMinutes;
}
