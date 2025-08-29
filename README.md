# Garmodoro
Pomodoro for Garmin devices using Connect IQ

## Features

* A lightweight and clean implementation of the [Pomodoro technique](https://en.wikipedia.org/wiki/Pomodoro_Technique).
* Keeps track of time left in your Pomodoro session, as well as break time and overal number of Pomodoros.
* **Mimics the ticking of a real physical Pomodoro** by using short vibrations.
* Alerts you using vibrations and tones.
* **Supports all Garmin devices** using Connect IQ.
* You can customize many aspects of the technique:
   * length of one Pomodoro (default: 25 minutes)
   * length of the short break between Pomodoros (default: 5 minutes)
   * length of the long break between groups of Pomodoros (default: 30 minutes)
   * the number of Pomodoros in a group (default: 4)
   * the strength and duration of the vibration "tick" (set either to `0` to disable)

## Development

To run the project, you can either import the project into Eclipse the usual way. Or use the `Makefile`:
 * Edit `properties.mk` file and make sure the paths there are valid on your computer. Change the `DEVICE` variable if you want/need.
 * Run `make run` to build the project and run the Connect IQ simulator on the chosen `DEVICE`.
 * Run `make update-devices` to update `manifest.xml` with new devices. If a device has been tested and is not possible to support it (rare, but happens), its entry will be commented out and will remain that way on subsequent runs.

See https://github.com/danielsiwiec/garmin-connect-seed for the full list of supported targets and variables.

## Screenshots

<img width="395" alt="screen shot 2017-05-03 at 00 14 46" src="https://user-images.githubusercontent.com/3392497/53386026-6bdcc500-3978-11e9-893d-c8d26818e7d2.jpg">
<img width="399" alt="screen shot 2017-05-03 at 00 15 17" src="https://user-images.githubusercontent.com/3392497/53385814-b0b42c00-3977-11e9-83b3-a7e56401d30d.jpg">
<img width="402" alt="screen shot 2017-05-03 at 00 15 52" src="https://user-images.githubusercontent.com/3392497/53385815-b0b42c00-3977-11e9-9b98-ca4a74020a8c.jpg">
<img width="401" alt="screen shot 2017-05-03 at 00 16 54" src="https://user-images.githubusercontent.com/3392497/53385816-b0b42c00-3977-11e9-8f45-88a8241adba2.jpg">
<img width="401" alt="screen shot 2017-05-03 at 00 18 01" src="https://user-images.githubusercontent.com/3392497/53385817-b0b42c00-3977-11e9-86d1-1ad18f670628.jpg">
