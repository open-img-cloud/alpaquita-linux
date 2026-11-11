#!/bin/sh
# cloud-init per-instance script (runs after the users are created).
#
# cloud-init locks the default user's password with "!" in /etc/shadow.
# Without PAM (musl), OpenSSH treats a "!" password as a locked account and
# refuses even public-key logins. Replace "!" by "*": the password stays
# unusable, but the account is no longer considered locked by sshd.
sed -i -E 's/^([^:]+):!+:/\1:*:/' /etc/shadow
