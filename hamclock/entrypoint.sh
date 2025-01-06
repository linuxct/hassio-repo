#!/usr/bin/with-contenv bashio

echo "On entrypoint, setup s6"
/init & disown
echo "On entrypoint, start HamClock"
/usr/local/bin/hamclock -o & disown
echo "Finished entrypoint, returning"
exit 0