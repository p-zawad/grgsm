# grgsm
Dockerfile for image with Piotr Krysik's GRGSM tools

Ubuntu based Docker image. It has installed `gqrx`, `gnuradio-companion` and other stuff. PLease note, that drivers for `rtl-sdr`, `UHD` and other physical signal sources should be installed in the host system. You can use `grgsm_scanner` to find active BTS in your vicinity. Then use `grgsm_livemon` (the corresponding gnuradio companion file is in `gr-gsm/apps`) to decode data from C0 channel. The received packets can be converted to textual form with `Wireshark`.
```
sudo wireshark -k -f udp -Y gsmtap -i
```
when `grgsm_livemon` is active.

The container has to be run in `priviledged` mode in GUI environment
```
USER_UID=$(id -u) docker run --rm -ti --name "gnuradio" --privileged --net=host --env="DISPLAY" --volume="$HOME/.Xauthority:/root/.Xauthority:rw" -v "$(pwd)persistent_storage":/home/student/persistent -v /var/run/dbus:/var/run/dbus --device /dev/bus/usb --device /dev/snd -v /dev/snd:/dev/snd --volume=/run/user/${USER_UID}/pulse:/run/user/1000/pulse pzawad/gnuradio tilix
```

Please create `persistent_storage` folder in a present working directory to preserve some data between successive runs of the container. You will be working as a user `student` and your password is `qwerty`. You can use `sudo` to gain administrator (inside container) privileges (please note that due to docker's `priviledged` mode this also partially applies to the host system). The access to persistent storage is via `/home/student/persistent` folder.

Before rebuilding the docker image please
```
git clone https://github.com/ptrkrysik/gr-gsm
tar czf gr-gsm.tar.gz
```
in a folder with `Dockerfile`
