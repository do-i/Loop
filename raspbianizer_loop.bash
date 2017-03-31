#!/bin/bash
# Copyright (c) 2017 Joji Doi
# This bash script automates manual installation of omv OS

OS=$(uname)
DEVICE_NAME="${1}"
WORK_DIR=$(pwd)

## check if the ${DEVICE_NAME} exists
if [ "${DEVICE_NAME}" == "" ]; then
  echo "Usage: bash ${0} <DEVICE_NAME> #e.g., /dev/sdx"
  exit 1
fi

if [ "${OS_IMG_FILE}" == "" ]; then
  echo "Specify OS_IMG_FILE variable."
  exit 1
fi
echo "DEVICE_NAME:${DEVICE_NAME}"
echo "OS_IMG_FILE:${OS_IMG_FILE}"
echo "WORK_DIR:${WORK_DIR}"

### Check if the device name ends with a digit (partition number).
function find_partition_count_linux() {
  if [[ ${DEVICE_NAME} =~ [0-9]$ ]]; then
    echo "Do not specify device partition. ${DEVICE_NAME}"
    exit 1
  fi
  CNT=$(sudo fdisk -l | grep ${DEVICE_NAME} | wc -l)
}

function find_partition_count_mac() {
  ### Check if the device name ends with a digit (partition number).
  if [[ ${DEVICE_NAME} =~ ^/dev/disk[2-9]$ ]]; then
    echo "Device name seems valid."
  else
    echo "Bad device name. ${DEVICE_NAME}"
    exit 1
  fi
  CNT=$(diskutil list ${DEVICE_NAME} | grep -e [0-9]: | wc -l)
}

function check_device_status() {
  if [ ${CNT} -eq 0 ]; then
    echo "Specified device ${DEVICE_NAME} does not exist. Please specify the device path to your sdcard."
    exit 1
  else
    echo "Valid Device ${DEVICE_NAME} Recognized."
  fi
}

function delete_partitions_mac() {
  if [ ${CNT} -gt 1 ]; then
    echo "Partition(s) found. They will be wiped out."
    diskutil eraseDisk JHFS+ Bubble ${DEVICE_NAME}
  fi

  diskutil unmountDisk ${DEVICE_NAME}
}

function delete_partitions_linux() {
  if [ ${CNT} -gt 1 ]; then
    echo "Partition(s) found. They will be wiped out."
    for i in $(parted -s ${DEVICE_NAME} print | awk '/^ / {print $1}'); do
      parted -s ${DEVICE_NAME} rm ${i}
    done
  fi
}

function copy_image_to_device() {
  echo "Copying ${WORK_DIR}/${OS_IMG_FILE} to ${DEVICE_NAME}... takes about 7 to 8 minutes. Kick back and relax."
  sudo dd bs=4194304 if=${WORK_DIR}/${OS_IMG_FILE} of=${DEVICE_NAME}
  echo "Sync in progress... do not touch nothing."
  sync
}

if [ "${OS}" == "Darwin" ]; then
  find_partition_count_mac && check_device_status && delete_partitions_mac
elif [ "${OS}" == "Linux" ]; then
  find_partition_count_linux && check_device_status && delete_partitions_linux
else
  echo "This is unsupported OS"
  exit 1
fi

copy_image_to_device
echo "Script completed. Check for errors in case there is any." && \
exit 0
