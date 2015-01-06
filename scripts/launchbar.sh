#!/bin/bash
# dmenu_run -sf white -sb orange -nb black -nf "#0cf"
# ~/.cabal/bin/yeganesh -x -- -i -sf white -sb orange -nb black -nf "#0cf"
exe=`dmenu_path | ~/.cabal/bin/yeganesh -- -i -sf white -sb orange -nb black -nf "#0cf"` && eval "exec $exe"
