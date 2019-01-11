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
device.name1=maguro
device.name2=toro
device.name3=toroplus
device.name4=
device.name5=
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

# Enable Spectrum Support
ui_print "- Setting Up Spectrum";
replace_file init.spectrum.rc 644 init.spectrum.rc;
replace_file init.spectrum.sh 755 init.spectrum.sh;
insert_line init.samsungexynos7870.rc "import init.spectrum.rc" after "import init.fac.rc" "import init.spectrum.rc";

ui_print "- Installing new boot image";

write_boot;

ui_print "- Done";
ui_print " ";

## end install
