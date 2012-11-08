#!/bin/bash
network=""                                                                          # Some configuration
chan=""
nick=""         
dir="./.irc"
stay=true
lines=`echo $(tput lines) - 1 | bc`
prompt="\033[0;32m$chan> \033[0m"
ii -n $nick -i $dir -s $network &                                                   # client init.
pid=$!
if [ -d $dir ]; then rm -r $dir; mkdir $dir; fi                                     # make sure the place is clean, so we can rely on file existing or not to know connection status.
echo "connecting..."; while [ ! -f $dir/$network/out ]; do echo -n ""; done; clear  # Wait for connection
cd $dir/$network                                                                    # change dir
tail -n $lines out
echo "/join $chan" > in                                                             # join canal
echo "Joining $chan..."; while [ ! -d "$chan" ]; do echo -n ""; done; clear         # Another wait
cd "$chan"                                                                          # another cd
tput cup $lines 0
echo -en $prompt
tput sc
while $stay; do                                                                     # main loop
    tput cup 0 0
    tail -n $lines out
    tput rc
    read -t 1
    tput sc
    if [[ $REPLY == ":q" ]]
    then
        stay=false
    else
        if [[ "$REPLY" != "" ]]
        then
            echo "$REPLY" > in
            clear
            tput cup $lines 0
            echo -en $prompt
            tput sc
        fi
    fi
done
kill $pid                                                                           # destroy the irc client...
clear
