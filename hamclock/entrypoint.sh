#!/usr/bin/with-contenv bashio

echo "Run init"
/init & disown
echo "Start HamClock"
/usr/local/bin/hamclock -o
sleep 999999999999999999999999999999999999999999999999999999999999999999999999999