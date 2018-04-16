# Paddington
Control your Mac from MIDI devices! The [Novation Launchpad (and Launchpad Mini)](https://uk.novationmusic.com/launch/launchpad) are supported at the moment, but thanks to Elixir's behaviours, [it's easy to add new devices](/lib/paddington/transducers/launchpad_transducer.ex)!

## Usage

Paddington requires a `.paddington.yml` file in your home folder to work. This file defines a `device` name, and a list of applications you want to control with paddington. Something like this:
```
device: Launchpad Mini
applications:
- mpc
- iTerm
- Chrome
- iTunes
```

The device name has to be among one of the connected MIDI devices, or the app
will fail with an `:invalid_device_id` error. Launch `mix portmidi.devices`
from the main folder to discover the available devices. 

The applications are Elixir script files (`exs`) defined in the `~/.paddington` folder, and must
follow the naming found in the `.paddington.yml` file. Check out the [`paddington-example`](https://github.com/lucidstack/paddington-example) repo for a quick start. 

As an example, this is
my `~/.paddington/mpc.exs`:
```
app "MPC", :line
osx "iTerm2"

command "Activate" do
  osascript "activate"

  if tmux.current_session == "music" do
    tmux.switch
  else
    tmux.switch "music"
  end
end

command "Previous track" do
  mpc.previous
end

command "Play/Pause" do
  mpc.playpause

  if mpc.playing? do
    led.green
  end
end

command "Next track" do
  mpc.next
end

command "Open in browser" do
  open "http://localhost:6680/spotmop"
end
```

As you can see, different helpers are available in the application files. `app` defines the name of the application, `osx` sets the app to use in osascript ([aka Applescript](https://developer.apple.com/library/mac/documentation/AppleScript/Conceptual/AppleScriptLangGuide/introduction/ASLR_intro.html)), and every `command` block defines what series of commands to fire when a MIDI note is received from the external device.

The commands are collected as the interpreter goes through the file(s). In the case of this configuration, that means that if your device has a grid (like a Launchpad), the pad in the upper left corner will focus on iTerm2 and switch to the tmux session named `music` (or switch back to the previous session, if already on `music`).

You can find all the available helpers in the [helpers folder](lib/paddington/apps/helpers) (they are not that many at the moment, bear with me!).

## Installation

At the moment, the installation is pretty rudimentary:
```
$ git clone https://github.com/lucidstack/paddington.git
$ cd paddington
$ make
$ make install
...
$ paddington
```

## Contributing

Any contribution is welcome! If you have a device you'd like to implement (or see implemented), take a look at the [Launchpad transducer](lib/paddington/transducers/launchpad_transducer.ex) and feel free to ping me for help here, on [twitter](https://twitter.com/lucidstack), or on the Elixir Slack organisation (lucidstack).

As usual, the process is pretty simple: fork, write tests, write code, tests pass, submit a PR! I'll try to get back as soon as possible.

## License

See [LICENSE](LICENSE)
