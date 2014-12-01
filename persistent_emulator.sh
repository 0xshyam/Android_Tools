#!/bin/sh
#
# This script will install Busybox and other useful applications on the android emulator. 
# Since the changes made to the 'system' does not reflect after the restart of emulator, this script 
# creates and pull the system image to the hard drive. Use this new system.img instead of the one
# that comes with SDK to retain your changes.
#
# This script and other tools used in this scirpt can be downloaded from
# https://github.com/shyam2810/Android_Tools/
# 

echo "[*] Mounting the file system to RW ..."
adb shell "mount -o rw,remount -t yaffs2 /dev/block/mtdblock03 /system  "

echo "[*] Pushing SU binary to /system/xbin ..."
adb push su /system/xbin/su  

echo "[*] changing permissions for /system ..."
adb shell "chmod 06755 /system"  

echo "[*] changing permissions for SU binary ..."
adb shell "chmod 06755 /system/xbin/su"

echo "[*] Making a directory for busybox ..."
adb shell "mkdir /data/busybox"

echo "[*] Pushing busybox to the device ..."
adb push busybox /data/busybox

echo "[*] changing permissions for busybox ..."
adb shell "chmod 775 /data/busybox/busybox"

echo "[*] Installing Busybox ..."
adb shell /data/busybox/busybox --install

echo "[*] Installing SU application ..."
adb install SU.apk

echo "[*] Installing Terminal application .."
adb install Terminal.apk

echo "[*] Installing RootExplorer application ..."
adb install RootExplorer.apk

echo "[*] creating Symlinks ..."
adb shell "/data/busybox/ln -f -s /data/busybox/* /system/xbin"
echo "[*] Creating a Folder for persistent system image ..."
adb shell mkdir /data/local/persitent_image/

echo "[*] Pushing mkfs.yaffs2 to the emulator ..."
adb push mkfs.yaffs2 /data/local/persitent_image/

echo "[*] changing permissions of mkfs.yaffs2 file ..."
adb shell chmod 777 /data/local/persitent_image/mkfs.yaffs2

echo "[*] Creating a system image ..."
echo "[*] This may take a while ..."
adb shell /data/local/persitent_image/mkfs.yaffs2 /system/ /mnt/sdcard/system.img

echo "[*] Pulling the image to drive ..."
adb pull /mnt/sdcard/system.img ./