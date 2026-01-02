#!/usr/bin/env python3
# JSON to CSV Conversion Logic:
# 1. Reads a JSON file passed as a command-line argument.
# 2. Extracts 'timestamp' (the base time) and 'trace' (the list of flight data points).
# 3. For each data point in the 'trace' list:
#    - Calculates the absolute timestamp by adding the offset (state[0]) to the base timestamp.
#    - Extracts latitude, longitude, altitude, ground speed, and track.
#    - Prints these values as a comma-separated string (CSV format).


import sys, json


with open(sys.argv[1]) as jsonFile:
        data = json.load(jsonFile)

timeZero = data['timestamp']
trace = data['trace']

for i in trace:
    state = i
    ts = timeZero + state[0]
    lat = state[1]
    lon = state[2]
    alt = state[3]
    gs = state[4]
    track = state[5]
    stale = state[6]

    outString = str(ts)
    outString += ',' + str(lat)
    outString += ',' + str(lon)
    outString += ',' + str(alt)
    outString += ',' + str(gs)
    outString += ',' + str(track)

    print(outString)
