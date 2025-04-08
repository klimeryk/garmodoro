using Toybox.Application as App;
using Toybox.System;

(:background)
class GarmodoroApp extends App.AppBase {
  function initialize() {
    AppBase.initialize();
  }

  function getInitialView() {
    return [new GarmodoroView(), new GarmodoroDelegate()];
  }

  public function getServiceDelegate() as [System.ServiceDelegate] {
    return [new GarmodoroServiceDelegate()];
  }
}
