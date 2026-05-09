#!/bin/ash
sed -i "s|^#ttyS0::|ttyS0::|" /etc/inittab
grep -q "^ttyS0$" /etc/securetty || echo "ttyS0" >> /etc/securetty
