#!/bin/bash
set -xe
mkdir /os||echo ""

docker build . -t debian_image
CID=$(docker run -d debian_image /bin/true)
docker export -o linux.tar ${CID}
docker stop ${CID}

IMG_SIZE=$(expr 1024 \* 1024 \* 1024);
dd if=/dev/zero of=/os/linux.img bs=${IMG_SIZE} count=1
sfdisk /os/linux.img <<EOF
label: dos
label-id: 0x5d8b75fc
device: new.img
unit: sectors

linux.img1 : start=2048, size=2095104, type=83, bootable
EOF

OFFSET=$(expr 512 \* 2048)
losetup -o ${OFFSET} /dev/loop0 /os/linux.img
mkfs.ext3 /dev/loop0
mkdir /os/mnt
mount -t auto /dev/loop0 /os/mnt/
tar -xvf /os/linux.tar -C /os/mnt/

apt-get update -y
apt-get install -y extlinux

extlinux --install /os/mnt/boot/
cat > /os/mnt/boot/syslinux.cfg <<EOF
DEFAULT linux
  SAY Now booting the kernel from SYSLINUX...
 LABEL linux
  KERNEL /vmlinuz
  APPEND ro root=/dev/sda1 initrd=/initrd.img
EOF

dd if=/usr/lib/syslinux/mbr/mbr.bin of=/os/linux.img bs=440 count=1 conv=notrunc

umount /os/mnt
losetup -D
cp -vf /os/linux.img ./Debian.raw.img
rm -vf linux.tar