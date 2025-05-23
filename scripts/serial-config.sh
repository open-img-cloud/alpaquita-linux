#!/bin/ash
sed -i "s/#ttyS0::respawn:\/sbin\/getty -L 115200 ttyS0 vt100/ttyS0::respawn:\/usr\/sbin\/getty -L 115200 ttyS0 vt100/" /etc/inittab
echo "ttyS0" >> /etc/securetty
cp /etc/init.d/agetty.tty1 /etc/init.d/getty.ttyS0
sed -i "s/agetty.tty1/getty.ttyS0/g" /etc/init.d/getty.ttyS0
sed -i "s/tty1/ttyS0/g" /etc/init.d/getty.ttyS0
sed -i "s/agetty/getty -L 115200/g" /etc/init.d/getty.ttyS0
chmod +x /etc/init.d/getty.ttyS0
rc-update add getty.ttyS0 default