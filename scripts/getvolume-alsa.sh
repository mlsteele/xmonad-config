#!/usr/bin/env ruby
# Get master volume info from amixer.

master = `amixer sget Master`
# interesting_line = "Mono: Playback 32 [50%] [-32.00dB] [on]"
interesting_line = master.split("\n")[4]
_, vol_perc, is_on_str = *(interesting_line.match /.*Playback.*\[(.*)%\].*\[(.*)\]/)
is_on = is_on_str == "on"
puts is_on ? "#{vol_perc.rjust(3, ' ')}%" : "<fc=#f50>  0%</fc>"
