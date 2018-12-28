# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=
do.devicecheck=0
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=
device.name2=
device.name3=
device.name4=
device.name5=
supported.versions=
'; } # end properties

# shell variables
block=/dev/block/platform/13500000.dwmmc0/by-name/BOOT;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

ui_print "- Unpacking boot image";

## AnyKernel install
dump_boot;

# Replace FSTAB
ui_print "- Installing new fstab";
replace_file fstab.samsungexynos7885 755 fstab.samsungexynos7885;

# Enable Spectrum Support
ui_print "- Setting Up Spectrum";
replace_file init.spectrum.rc 644 init.spectrum.rc;
replace_file init.spectrum.sh 755 init.spectrum.sh;
insert_line init.samsungexynos7870.rc "import init.spectrum.rc" after "import init.fac.rc" "import init.spectrum.rc";

ui_print "- Disabling some useless samsung stuff";
append_file default.prop "" props;

mount -o rw,remount -t auto /system >/dev/null;
rm -rf /system/bin/vaultkeeper;
rm -rf /system/etc/tima;
rm -rf /system/etc/init/secure_storage_daemon.rc;
rm -rf /system/lib/libvkjni.so;
rm -rf /system/lib/libvkservice.so;
rm -rf /system/lib64/libvkjni.so;
rm -rf /system/lib64/libvkservice.so;
rm -rf /system/priv-app/KLMSAgent;
rm -rf /system/priv-app/KnoxGuard;
rm -rf /system/priv-app/Rlc;
rm -rf /system/priv-app/TeeService;
rm -rf /system/vendor/app/mcRegistry/ffffffffd0000000000000000000000a.tlbin;

# Fix secure storage (Wi-Fi)
cp /tmp/anykernel/tools/libsecure_storage.so /system/vendor/lib/libsecure_storage.so;
chmod 644 /system/vendor/lib/libsecure_storage.so;
cp /tmp/anykernel/tools/libsecure_storage_jni.so /system/vendor/lib/libsecure_storage_jni.so;
chmod 644 /system/vendor/lib/libsecure_storage_jni.so;

umount /system;

ui_print "- Installing new boot image";

write_boot;

ui_print "- Done";
ui_print " ";

## end install
