#!/bin/ash
# Configuration simple de la console série pour Alpaquita Linux

# Activer getty sur ttyS0 dans inittab
sed -i "s|^#ttyS0::|ttyS0::|" /etc/inittab

# Ajouter ttyS0 à securetty si pas déjà présent
grep -q "^ttyS0$" /etc/securetty || echo "ttyS0" >> /etc/securetty
