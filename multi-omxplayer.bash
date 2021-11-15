#!/bin/bash

### TODO pass dir path as an argument or playlist file
PLAY_LIST="playlist.bash"

function create_playlist() {
  VIDEOS_DIR="/mnt/videos"
  echo "" > ${PLAY_LIST}
  if [ -d "${VIDEOS_DIR}" ]; then
      for file in ${VIDEOS_DIR}/*.mp4; do
        echo "omxplayer -o both -b \"${file}\"" >> ${PLAY_LIST}
      done
  else
    echo "${VIDEOS_DIR} does not exist."
    exit 1
  fi
}
if [ $(ps aux | grep /usr/bin/omxplayer.bin | wc -l) -gt 1 ]; then
  echo "video already running"
  exit 1
else
  echo "start Loop"
fi

create_playlist
chmod +x ${PLAY_LIST}
while true; do
  ./${PLAY_LIST} || break
done
