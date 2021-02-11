#!/bin/bash


#!/bin/sh
# Copies the Android clipboard to local X11 secondary buffer.
# Useful for debugging.

limit=33
delay=3000
login=# ssh $login or adb $login shell should log you in
while getopts 't:h:q' opt
do
	case $opt in
	h)
		login="$OPTARG";;
	t)
		delay="$OPTARG";;
	q)
		quiet=1;;
	esac
done
[ $# -ge 1 ] && login="$1" && shift
# end constants

# retrieve the hexdump from either ssh or adb
#text="`ssh $login service call clipboard 1 2>/dev/null`" # uncomment to use ssh
text="`adb shell service call clipboard 1 2>/dev/null`" # uncomment to use adb
echo $text

ret=$?
msg(){
	[ -z "$DISPLAY" ] && tput bold && echo -n "$1" && tput sgr0 && echo : && echo "$2" || notify-send -t "$delay" "$1" "$2"
}
case $ret in
255)
	msg "SSH error" "Error connecting";;
0)
	text="`tail -n+3 <<< "$text" | cut -d0 -f3- | xxd -r | tr -d \\\\0 | dd conv=swab 2>/dev/null`"
	[ -z "$DISPLAY" ] && exec echo -n "$text"
	xsel -bi <<< "$text"
	[ "${#text}" -gt "$limit" ] && msg "Copied (preview)" "${text::$[limit-3]}..." || msg Copied "$text";;
*)
	msg "Remote error" "Error code $ret";;
esac
exit $ret
