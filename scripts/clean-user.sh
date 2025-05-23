#!/bin/ash
userdel -r alpaquita 2>/dev/null || true
sed -i "/^alpaquita:/d" /etc/shadow /etc/passwd /etc/group 2>/dev/null || true
rm -rf /home/alpaquita