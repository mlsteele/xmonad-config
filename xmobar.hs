Config { font = "xft:DejaVu Sans-9:weight=book"
       , bgColor = "black"
       , fgColor = "grey"
       , position = TopW L 90
       , commands = [ Run Weather "KCAPALOA15" ["-t", " <tempF>F", "-L", "64", "-H", "77", "--normal", "green", "--high", "red", "--low", "lightblue"] 36000
                    , Run Cpu ["-L", "3", "-H", "50", "--normal", "green", "--high", "red"] 10
                    , Run Memory ["-t", "Mem: <usedratio>%"] 10
                    , Run Swap [] 10
                    , Run Battery ["--Low", "30", "--High", "60", "--high", "green", "--normal", "yellow", "--low", "red", "--template", "Bat: <left>% <timeleft>"] 200
                    , Run Date "%a %b %_d %l:%M" "date" 10
                    , Run StdinReader
                    -- Com ProgramName Args Alias RefreshRate(tenths of second)
                    , Run Com "/home/miles/.xmonad/scripts/getvolume-pulse.sh" [] "volume" 1
                    --, Run Com "/home/miles/.xmonad/scripts/getvolume-pulse.sh" [] "Battery" 1
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "%StdinReader% }{ %cpu%  %memory%  %swap% | Vol: %volume% | %battery% |%KCAPALOA15% | <fc=#ee9a00>%date%</fc>"
       }
