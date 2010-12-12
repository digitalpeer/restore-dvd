#!/bin/sh

cp target/device/x86/restoredvd/55-cdrom.rules $1/etc/udev/rules.d/ || exit 1
cp target/device/x86/restoredvd/S99restore $1/etc/init.d/ || exit 1

exit 0
