# AnyKernel2 Ramdisk Mod Script
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
supported.versions=
'; } # end properties

# shell variables
block=/dev/block/platform/13540000.dwmmc0/by-name/BOOT;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;

ui_print "- Unpacking boot image";

## AnyKernel install
dump_boot;


# Disable Forced Encryption
ui_print "- Disabling forceencryption";
patch_fstab fstab.samsungexynos7870 /data ext4 flags "wait,check,forceencrypt=footer" "wait,check,encryptable=footer";

# Disable Samsung Shits
ui_print "- Disabling some useless samsung stuff";
insert_line default.prop "ro.config.tima=0" after "ro.zygote=zygote32" "ro.config.tima=0";
insert_line default.prop "ro.security.vaultkeeper.feature=0" after "ro.config.tima=0" "ro.security.vaultkeeper.feature=0";
insert_line default.prop "ro.securestorage.support=false" after "ro.security.vaultkeeper.feature=0" "ro.securestorage.support=false";
insert_line default.prop "ro.config.dmverity=false" after "ro.securestorage.support=false" "ro.config.dmverity=false";
insert_line default.prop "ro.config.rkp=false" after "ro.config.dmverity=false" "ro.config.rkp=false";
insert_line default.prop "ro.config.kap=false" after "ro.config.rkp=false" "ro.config.kap=false";

ui_print "- Fixing some issues";
umount /system;
mount -o rw -t auto /system;
rm -rf /system/priv-app/KLMSAgent;
rm -rf /system/app/mcRegistry/ffffffffd0000000000000000000000a.tlbin;
rm -rf /system/vendor/lib/libsecure_storage.so;
cp /tmp/anykernel/tools/libsecure_storage.so /system/vendor/lib/libsecure_storage.so;
chmod 644 /system/vendor/lib/libsecure_storage.so;
umount /system;

# Enable Spectrum Support
ui_print "- Setting Up Spectrum";
replace_file init.spectrum.rc 644 init.spectrum.rc;
replace_file init.spectrum.sh 755 init.spectrum.sh;
insert_line init.samsungexynos7870.rc "import init.spectrum.rc" after "import init.fac.rc" "import init.spectrum.rc";

# Add init.oxygen.rc
ui_print "- Installing oxygen addons";
replace_file init.oxygen.rc 644 init.oxygen.rc;
insert_line init.samsungexynos7870.rc "import init.oxygen.rc" after "import init.spectrum.rc" "import init.oxygen.rc";

ui_print "- Installing new boot image";

write_boot;

ui_print "- Done";
ui_print " ";

## end install
