#!/bin/sh
# cloud-init per-boot script (final stage, after users-groups created and
# locked the default user).
#
# cloud-init locks the default user's password ("!" prefix, e.g. "!" or
# "!*"). Without PAM (musl), OpenSSH treats any "!"-prefixed password as a
# locked account and refuses even public-key logins ("User alpaquita not
# allowed because account is locked"). Replace every locked password with
# "*": still unusable for password logins, but not "locked" for sshd.
sed -i -E 's/^([^:]+):![^:]*:/\1:*:/' /etc/shadow
