# Garmodoro
Pomodoro for Garmin devices using Connect IQ

## Features

* A lightweight and clean implementation of the [Pomodoro technique](https://en.wikipedia.org/wiki/Pomodoro_Technique).
* Keeps track of time left in your Pomodoro session, as well as break time and overal number of Pomodoros.
* **Mimics the ticking of a real physical Pomodoro** by using short vibrations.
* Alerts you using vibrations and tones.
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

See https://github.com/danielsiwiec/garmin-connect-seed for the full list of supported targets and variables.

