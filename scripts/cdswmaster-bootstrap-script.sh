#!/bin/sh
trap exit ERR
exec >~/cdswmaster-bootstrap-script.log 2>&1

<<<<<<< HEAD
# Mount one volume for application data
device="/dev/xvdh"
mount="/var/lib/cdsw"

echo "Making file system"
sudo mkfs.ext4 -F -E lazy_itable_init=1 "$device" -m 0

echo "Mounting $device on $mount"
if [ ! -e "$mount" ]; then
     sudo mkdir -p "$mount"
fi

sudo mount -o defaults,noatime "$device" "$mount"
echo "$device $mount ext4 defaults,noatime 0 0" >> /etc/fstab
=======
# Install iptables-services - this seems only to be necessary for GCP images (centos7, in particular)
# but won't harm if installed for all images
yum -y install iptables-services

# Mount one volume for application data
# NOTE - THE VALUES FOR APP_DISK MUST MATCH WHAT IS SEEN IN */provider.properties for the APP_DISK
case $(dmidecode -s bios-version) in
    *Google*) APP_DISK=/dev/sdc;;
    *amazon*) APP_DISK=/dev/xvdg;;
    090007*) APP_DISK=/dev/sdd;;
    *) echo "Unknown bios-version: $(dmidecode -s bios-version)" 1>&2; exit 1;;
esac

readonly MOUNT=/var/lib/cdsw
readonly LABEL=cdsw

echo "Making file system with label ${LABEL:?}"
mkfs.ext4 -F -E lazy_itable_init=1 "${APP_DISK:?}" -m 0 -L ${LABEL:?}

echo "Mounting ${APP_DISK:?} on ${MOUNT:?}"
mkdir -p "${MOUNT:?}"


echo "LABEL=${LABEL:?} ${MOUNT:?} ext4 defaults,noatime 0 0" >> /etc/fstab
mount "LABEL=${LABEL:?}"
>>>>>>> 7654f59619b687c1b23054eb13616367baffb4c1

exit 0
