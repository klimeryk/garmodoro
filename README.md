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

See https://github.com/danielsiwiec/garmin-connect-seed for the full list of supported targets and variables.

## Screenshots

<img width="395" alt="screen shot 2017-05-03 at 00 14 46" src="https://cloud.githubusercontent.com/assets/3392497/25642395/c15b37ea-2f99-11e7-958e-7320f4cf1703.png">
<img width="399" alt="screen shot 2017-05-03 at 00 15 17" src="https://cloud.githubusercontent.com/assets/3392497/25641940/149f763a-2f97-11e7-8af5-9a3a4dc28002.png">
<img width="402" alt="screen shot 2017-05-03 at 00 15 52" src="https://cloud.githubusercontent.com/assets/3392497/25641941/14a0451a-2f97-11e7-9283-66a4931bfdc5.png">
<img width="401" alt="screen shot 2017-05-03 at 00 16 54" src="https://cloud.githubusercontent.com/assets/3392497/25641939/149f917e-2f97-11e7-96c5-1be149e9a9ce.png">
<img width="401" alt="screen shot 2017-05-03 at 00 18 01" src="https://cloud.githubusercontent.com/assets/3392497/25641938/149f4638-2f97-11e7-9bd5-7ee560150325.png">
<img width="365" alt="screen shot 2017-05-03 at 00 18 38" src="https://cloud.githubusercontent.com/assets/3392497/25642291/35f28d7a-2f99-11e7-8ab9-37249ad9ee7b.png">
<img width="443" alt="screen shot 2017-05-03 at 00 19 28" src="https://cloud.githubusercontent.com/assets/3392497/25641942/14cae176-2f97-11e7-80a9-baf62fc69492.png">
<img width="304" alt="screen shot 2017-05-03 at 00 19 54" src="https://cloud.githubusercontent.com/assets/3392497/25642397/c189a6de-2f99-11e7-8f70-79cf4152a56b.png">
<img width="302" alt="screen shot 2017-05-03 at 00 20 35" src="https://cloud.githubusercontent.com/assets/3392497/25642396/c187cc1a-2f99-11e7-9672-6a72f9034eb0.png">
