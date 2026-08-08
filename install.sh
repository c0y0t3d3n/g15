#!/bin/bash -x 
REPO=https://gitlab.com/menelkir
IFACE=`ip link | grep '^.:' | grep -v 'lo:' | cut -d: -f2 | head -1`
if [ "$2" != '' ]; then
	ACTION=$2
else
	ACTION='install'
fi
sudo apt install git build-essential autoconf libtool libusb-dev libgtop2-dev xorg-dev -y || exit
for r in libg15 libg15render g15daemon g15stats g15macro g15message
do
	if [ "$1" = "" -o "$1" = "$r" ]; then
		rm -rf $r
		git clone $REPO/$r.git
		pushd $r
		if [ -f ../$r.patch ]; then
			patch -p1 < ../$r.patch
		fi	
		autoreconf --install && ./configure --libdir=/usr/lib && make && sudo make $ACTION || exit
		if [ -f ../$r.service ]; then
			sed 's/$IFACE/'"$IFACE"'/' ../$r.service > $r.service
			sudo cp $r.service /etc/systemd/system/
		elif [ -f contrib/init/$r.service ]; 
			then sudo cp -v contrib/init/$r.service /etc/systemd/system/; 
		fi
		if [ -f /etc/systemd/system/$r.service ]; then
			sudo systemctl daemon-reload
			sudo systemctl enable --now $r
			sudo systemctl restart $r
		fi
		if [ -f ../$r.desktop ]; then
			cp -v ../$r.desktop ~/.local/share/applications
		fi
		popd
		if [ "$1" = "" ]; then rm -rf $r; fi
	fi
done
