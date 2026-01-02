#!/bin/bash
# Terrain-limit (Up-In-The-Air) Data Fetching:
# 1. Accepts a HeyWhatsThat.com ID as the first argument (required).
# 2. Accepts altitudes as the second argument (optional, defaults to 12192m / ~40k ft).
# 3. Accepts a tar1090 instance name as the third argument (optional).
# 4. Fetches the JSON data from the HeyWhatsThat API using 'wget'.
# 5. Saves the resulting file to the correct HTML directory as 'upintheair.json' for the specified instance.
umask 022

ID="$1"

if [[ -z $1 ]]; then
    echo "no ID supplied"
    exit
fi

ALTS="12192"
if [[ -n $2 ]]; then
	ALTS="$2"
fi

instance=""
if [[ -n $3 ]]; then
	instance="-$3"
fi


wget -nv -O "/usr/local/share/tar1090/html${instance}/upintheair.json" "http://www.heywhatsthat.com/api/upintheair.json?id=${ID}&refraction=0.25&alts=${ALTS}"

