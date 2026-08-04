#/bin/bash
sudo apt install git build-essential autoconf libtool g15daemon libg15-dev libg15daemon-client-dev libg15render-dev libgtop2-dev xorg-dev -y || exit
rm -rf g15stats
git clone https://gitlab.com/menelkir/g15stats.git
pushd g15stats 
autoreconf --install && ./configure && make && sudo make install || exit 1
popd
rm -rf g15stats
rm -rf g15macro
git clone https://gitlab.com/menelkir/g15macro.git
pushd g15macro
patch -p1 < ../g15macro.patch
autoreconf --install && ./configure && make && sudo make install || exit 1
popd
rm -rf g15macro
sudo cp -v g15daemon.service /usr/lib/systemd/system/
sudo cp -v g15stats.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl restart g15daemon
sudo systemctl enable --now g15stats
sudo systemctl restart g15stats
cp -v g15macro.desktop ~/.local/share/applications
