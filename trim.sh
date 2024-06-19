#!/bin/bash

# Ensure the script exits if any command fails
set -e

# Function to display usage information
usage() {
    echo "Usage: $0 -i input_video -o output_video -d duration_to_trim"
    exit 1
}

# Parse command line arguments
while getopts ":i:o:d:" opt; do
    case ${opt} in
        i )
            INPUT_VIDEO=$OPTARG
            ;;
        o )
            OUTPUT_VIDEO=$OPTARG
            ;;
        d )
            DURATION_TO_TRIM=$OPTARG
            ;;
        \? )
            usage
            ;;
    esac
done

# Check if all parameters are provided
if [ -z "$INPUT_VIDEO" ] || [ -z "$OUTPUT_VIDEO" ] || [ -z "$DURATION_TO_TRIM" ]; then
    usage
fi

# Install ffmpeg if it's not already installed
if ! command -v ffmpeg &> /dev/null
then
    echo "ffmpeg could not be found, installing..."
    sudo apt update
    sudo apt install -y ffmpeg
else
    echo "ffmpeg is already installed"
fi

# Install bc if it's not already installed
if ! command -v bc &> /dev/null
then
    echo "bc could not be found, installing..."
    sudo apt update
    sudo apt install -y bc
else
    echo "bc is already installed"
fi

# Get the duration of the video in seconds
DURATION=$(ffmpeg -i "$INPUT_VIDEO" 2>&1 | grep "Duration" | awk '{print $2}' | tr -d , | awk -F: '{print ($1 * 3600) + ($2 * 60) + $3}')

# Calculate the new end time (total duration - duration to trim)
NEW_END_TIME=$(awk -v duration="$DURATION" -v trim="$DURATION_TO_TRIM" 'BEGIN {print duration - trim}')

# Convert the new end time back to HH:MM:SS format
HH=$(printf "%02d" $(echo "$NEW_END_TIME / 3600" | awk '{print int($1)}'))
MM=$(printf "%02d" $(echo "($NEW_END_TIME % 3600) / 60" | awk '{print int($1)}'))
SS=$(printf "%02d" $(echo "$NEW_END_TIME % 60" | awk '{print int($1)}'))

# Format the new end time
NEW_END_TIME_FORMATTED="${HH}:${MM}:${SS}"

echo $NEW_END_TIME_FORMATTED
# Trim the video using ffmpeg
ffmpeg -i "$INPUT_VIDEO" -to "$NEW_END_TIME_FORMATTED" -c copy "$OUTPUT_VIDEO"

echo "Video trimmed successfully. Output saved to $OUTPUT_VIDEO"
