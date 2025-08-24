#! /bin/sh

INPUT=${1}
if [ -z "${INPUT}" ]; then
  echo "Must provide input path."
  exit 1
fi

# Generate a short temporary video with a static black image.
# This is much faster than generating a long video to match the audio.
BLACK=$(mktemp).mp4
ffmpeg -f lavfi -i color=black:s=640x480:r=1 -t 1 -x264opts stitchable ${BLACK}
if [ ! -f "${BLACK}" ]; then
  echo "Unable to create an intermediate video with static black image."
fi

# Transmux the audio from the input file into an mp4 container.
# The black video is looped to match the audio.
ffmpeg -i ${INPUT} -i ${BLACK} -loop 1 -c:a copy -c:v copy -map 1:v -map 0:a ${INPUT}.mp4
