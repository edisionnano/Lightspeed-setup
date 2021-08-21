#!/usr/bin/env sh
# Prepare environment
INSTALLDIR=~/.local/share/Lightspeed
mkdir -p $INSTALLDIR && cd $INSTALLDIR
#Define the functions
makealias() {
    ALIAS='alias startserver="sudo echo "hi" && nohup sh '$INSTALLDIR'/startserver.sh"'
    if [ -z "${SHELL##*zsh*}" ]; then
        FILE="/home/${USER}/.zshrc"
    elif [ -z "${SHELL##*bash*}" ]; then
        FILE="/home/${USER}/.bashrc"
    fi
    if [ -f $FILE ]; then
        sed -i '/alias startserver/d' $FILE
        echo $ALIAS >> $FILE
    else 
        echo $ALIAS > $FILE
    fi
    alias startserver="sudo echo "hi" && nohup sh '$INSTALLDIR'/startserver.sh"
}
install () {
    git clone https://github.com/GRVYDEV/Lightspeed-ingest.git
    git clone https://github.com/GRVYDEV/Lightspeed-webrtc.git
    git clone https://github.com/GRVYDEV/Lightspeed-react.git
    cd Lightspeed-webrtc
    GO111MODULE=on go build
    cd ../Lightspeed-react
    sudo npm install -g serve npm
    npm install
    npm run build
    sed -i 's/stream.gud.software/127.0.0.1/g' build/config.json
    cd ..
    echo "#!/bin/bash" > startserver.sh
    echo "cd $INSTALLDIR/Lightspeed-ingest && STREAM_KEY=pineapple cargo run --release &" >> startserver.sh
    echo "$INSTALLDIR/Lightspeed-webrtc/lightspeed-webrtc &" >> startserver.sh
    echo "cd $INSTALLDIR/Lightspeed-react && sudo serve -s build -l 80 &" >> startserver.sh
}
install
makealias
printf "Install successful!\n"
printf "Your stream key is:77-pineapple\n"
printf "Use the command startserver to start the server\n"

