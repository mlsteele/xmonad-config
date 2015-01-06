#!/usr/bin/env ruby
# Get volume info from pulse audio.

# master = `amixer sget Master`
# # interesting_line = "Mono: Playback 32 [50%] [-32.00dB] [on]"
# interesting_line = master.split("\n")[4]
# _, vol_perc, is_on_str = *(interesting_line.match /.*Playback.*\[(.*)%\].*\[(.*)\]/)
# is_on = is_on_str == "on"
# puts is_on ? "#{vol_perc.rjust(3, ' ')}%" : "<fc=#f50>  0%</fc>"

volumes = `pacmd dump-volumes`
# example: Sink 1: reference = 0:  35% 1:  35%, real = 0:  35% 1:  35%, soft = 0: 100% 1: 100%, current_hw = 0:  35% 1:  35%, save = yes
_, vol_str = *(volumes.match /.*Sink 1: reference = 0: +(\d*%).*/)


puts vol_str
