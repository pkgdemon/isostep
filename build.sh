#!/bin/sh

rm -rf live-default
mkdir live-default
cd live-default || exit
lb config --distribution bookworm --archive-areas "main contrib non-free non-free-firmware" --iso-volume "GNUstep Live"

cp -R usr/* chroot/usr/

cat <<EOF > config/hooks/live/gnustep.hook.chroot
#!/bin/sh

set -e

apt install -y git
apt install -y sddm

git clone https://github.com/pkgdemon/debstep
cd /debstep && ./debstep-installer
rm -rf /debstep
rm -rf /gnustep-src
EOF

lb build
