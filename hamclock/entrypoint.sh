#!/usr/bin/with-contenv bashio

echo "On entrypoint, start HamClock"
/usr/local/bin/hamclock -o & disown
echo "HamClock started, passing control to s6"
/init # pass control to s6