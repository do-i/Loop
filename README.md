# Loop
### Setup Raspberry Pi with Raspbian Jessie
#### Step 1: https://downloads.raspberrypi.org/raspbian_lite_latest
#### Step 2: Unzip the download archive file
#### Step 3: Move the unzipped img file to a work directory (e.g., ~/)
#### Step 4: Download raspbianizer_loop.bash to a work directory
- TODO download URL
#### Step 5: Make the file executable
```sh
chmod +x ./raspbianizer_loop.bash
```
#### Step 6: Run raspbianizer_loop.bash
- export OS_IMG_FILE variable with os img file
- Specify the correct device path to the fresh SD card (e.g. /dev/sdd, /dev/sde, or /dev/sdx)
- Example:
```sh
export OS_IMG_FILE="2017-01-11-raspbian-jessie.img" && sudo raspbianizer_loop.bash /dev/sdx
```

#### Step 7: Boot
After image copy is completed, take out the sdcard from your computer.
Then, insert it to RaspberryPi 2 or 3

#### Step 8: Plug cables
- Plug keyboard and mouse
- USB thumbdrives
- HDMI cables
- Power cable

#### Step 9: Enable SSH
Open terminal and run
```sh
sudo raspi-config
```
Then, enable SSH

#### Step 10: Download multi-omxplayer.bash into RaspberryPi
- TODO: download URL

#### Step 11: Executable
```sh
  chmod +x multi-omxplayer.bash
```

#### Step 12: bashrc
Add the following into .bashrc
```sh
sudo /etc/init.d/ssh start
/home/pi/multi-omxplayer.bash &
```

#### Step 13: fstab
Add the following into /etc/fstab
```sh
/dev/sda1 /mnt vfat defaults 0 0
```

#### Step 14: Reboot
Just unplug power cable and plug back in
