#!/usr/bin/env ruby
# Toggle mute for all channels based on Master's mute flag.

master = `amixer sget Master`
# interesting_line = "Mono: Playback 32 [50%] [-32.00dB] [on]"
interesting_line = master.split("\n")[4]
_, vol_perc, is_on_str = *(interesting_line.match /.*Playback.*\[(.*)%\].*\[(.*)\]/)
is_on = is_on_str == "on"
# puts is_on ? "#{vol_perc.rjust(3, ' ')}%" : "<fc=#f50>  0%</fc>"

new_is_on = is_on ? "off" : "on"
`amixer set Master #{new_is_on}`
`amixer set Headphone #{new_is_on}`
`amixer set Speaker #{new_is_on}`
`amixer set "Bass Speaker" #{new_is_on}`
