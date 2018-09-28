#!/bin/bash

TMP_FOLDER=$(mktemp -d)
CONFIG_FILE='argo.conf'
CONFIGFOLDER='/root/.argocore'
DATAFOLDER='/root/ARGO'
TMP_DATAFOLDER=$TMP_FOLDER/argocore-1.1.0/bin/
SENTINEL_CONF=$DATAFOLDER/sentinel/sentinel.conf
COIN_DAEMON='argod'
COIN_CLI='argo-cli'
COIN_PATH='/usr/local/bin/'
COIN_LATEST_RELEASE='argocore-1.1.0-x86_64-unknown-linux-gnu.tar.gz'
COIN_TGZ=$(curl -s https://api.github.com/repos/Argo20/argo/releases/latest | grep -i $COIN_LATEST_RELEASE | grep -i "browser_download_url" | awk -F" " '{print $2}' | sed 's/"//g')
COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
COIN_CHAIN_FILE='argo-blockchain.tar.gz'
COIN_CHAIN='https://node-support.network/bootstrap/'$COIN_CHAIN_FILE
PHYS_MEM=$(echo $(($(getconf _PHYS_PAGES) * $(getconf PAGE_SIZE) / (1024 * 1024))))
COIN_NAME='ARGO'
COIN_PORT=8989
RPC_PORT=8988

NODEIP=$(curl -s4 icanhazip.com)


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'


function download_node() {
  echo -e "Prepare to download ${GREEN}$COIN_NAME${NC}."
  cd $TMP_FOLDER >/dev/null 2>&1
  wget -q $COIN_TGZ
  compile_error
  tar xvzf $COIN_ZIP
  cd $TMP_DATAFOLDER
  chmod +x $COIN_DAEMON $COIN_CLI
  cp $COIN_DAEMON $COIN_CLI $COIN_PATH
  cd ~ >/dev/null 2>&1
  rm -rf $TMP_FOLDER >/dev/null 2>&1
  clear
}


function configure_systemd() {
  cat << EOF > /etc/systemd/system/$COIN_NAME.service
[Unit]
Description=$COIN_NAME service
After=network.target

[Service]
User=root
Group=root

Type=forking
#PIDFile=$CONFIGFOLDER/$COIN_NAME.pid

ExecStart=$COIN_PATH$COIN_DAEMON -daemon -conf=$CONFIGFOLDER/$CONFIG_FILE -datadir=$CONFIGFOLDER
ExecStop=-$COIN_PATH$COIN_CLI -conf=$CONFIGFOLDER/$CONFIG_FILE -datadir=$CONFIGFOLDER stop

Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=5

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 3
  systemctl start $COIN_NAME.service
  systemctl enable $COIN_NAME.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $COIN_DAEMON)" ]]; then
    echo -e "${RED}$COIN_NAME is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $COIN_NAME.service"
    echo -e "systemctl status $COIN_NAME.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
}


function create_config() {
  mkdir $CONFIGFOLDER >/dev/null 2>&1
  RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $CONFIGFOLDER/$CONFIG_FILE
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
#rpcport=$RPC_PORT
rpcallowip=127.0.0.1
listen=1
server=1
daemon=0
port=$COIN_PORT
EOF
}

function create_key() {
  clear
  echo -e "Enter your ${RED}$COIN_NAME Masternode Private Key${NC}. Leave it blank to generate a new ${RED}Masternode Private Key${NC} for you:"
  read -e COINKEY
  if [[ -z "$COINKEY" ]]; then
  $COIN_PATH$COIN_DAEMON -daemon
  sleep 30
  if [ -z "$(ps axo cmd:100 | grep $COIN_DAEMON)" ]; then
   echo -e "${RED}$COIN_NAME server couldn not start. Check /var/log/syslog for errors.{$NC}"
   exit 1
  fi
  COINKEY=$($COIN_PATH$COIN_CLI masternode genkey)
  if [ "$?" -gt "0" ];
    then
    echo -e "${RED}Wallet not fully loaded. Let us wait and try again to generate the Private Key${NC}"
    sleep 30
    COINKEY=$($COIN_PATH$COIN_CLI masternode genkey)
  fi
  $COIN_PATH$COIN_CLI stop
fi
clear
}

function update_config() {
  sed -i 's/daemon=1/daemon=0/' $CONFIGFOLDER/$CONFIG_FILE
  cat << EOF >> $CONFIGFOLDER/$CONFIG_FILE
logintimestamps=1
maxconnections=64
masternode=1
externalip=$NODEIP:$COIN_PORT
masternodeprivkey=$COINKEY
addnode=173.212.203.209
addnode=173.249.11.174
EOF
}


function enable_firewall() {
  echo -e "Installing and setting up firewall to allow ingress on port ${GREEN}$COIN_PORT${NC}"
  ufw allow $COIN_PORT/tcp comment "$COIN_NAME MN port" >/dev/null 2>&1
  ufw allow ssh comment "SSH" >/dev/null 2>&1
  ufw limit ssh/tcp >/dev/null 2>&1
  ufw default allow outgoing >/dev/null 2>&1
  echo "y" | ufw enable >/dev/null 2>&1
}


function get_ip() {
  declare -a NODE_IPS
  for ips in $(netstat -i | awk '!/Kernel|Iface|lo/ {print $1," "}')
  do
    NODE_IPS+=($(curl --interface $ips --connect-timeout 2 -s4 icanhazip.com))
  done

  if [ ${#NODE_IPS[@]} -gt 1 ]
    then
      echo -e "${GREEN}More than one IP. Please type 0 to use the first IP, 1 for the second and so on...${NC}"
      INDEX=0
      for ip in "${NODE_IPS[@]}"
      do
        echo ${INDEX} $ip
        let INDEX=${INDEX}+1
      done
      read -e choose_ip
      NODEIP=${NODE_IPS[$choose_ip]}
  else
    NODEIP=${NODE_IPS[0]}
  fi
}


function compile_error() {
if [ "$?" -gt "0" ];
 then
  echo -e "${RED}Failed to compile $COIN_NAME. Please investigate.${NC}"
  exit 1
fi
}


function checks() {
if [[ $(lsb_release -d) != *16.04* ]]; then
  echo -e "${RED}You are not running Ubuntu 16.04. Installation is cancelled.${NC}"
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}$0 must be run as root.${NC}"
   exit 1
fi

if [ -n "$(pidof $COIN_DAEMON)" ] || [ -e "$COIN_DAEMOM" ] ; then
  echo -e "${RED}$COIN_NAME is already installed.${NC}"
  exit 1
fi
}

function prepare_system() {
echo -e "Prepare the system to install ${GREEN}$COIN_NAME${NC} master node."
apt-get update >/dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get update >/dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y -qq upgrade >/dev/null 2>&1
apt install -y software-properties-common >/dev/null 2>&1
echo -e "${GREEN}Adding bitcoin PPA repository"
apt-add-repository -y ppa:bitcoin/bitcoin >/dev/null 2>&1
echo -e "Installing required packages, it may take some time to finish.${NC}"
apt-get update >/dev/null 2>&1
apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" make software-properties-common \
build-essential libtool autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev libboost-program-options-dev \
libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git wget curl libdb4.8-dev bsdmainutils libdb4.8++-dev \
libminiupnpc-dev libgmp3-dev ufw pkg-config libevent-dev libdb5.3++ unzip libzmq5 >/dev/null 2>&1
if [ "$?" -gt "0" ];
  then
    echo -e "${RED}Not all required packages were installed properly. Try to install them manually by running the following commands:${NC}\n"
    echo "apt-get update"
    echo "apt -y install software-properties-common"
    echo "apt-add-repository -y ppa:bitcoin/bitcoin"
    echo "apt-get update"
    echo "apt install -y make build-essential libtool software-properties-common autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev \
libboost-program-options-dev libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git curl libdb4.8-dev \
bsdmainutils libdb4.8++-dev libminiupnpc-dev libgmp3-dev ufw pkg-config libevent-dev libdb5.3++ unzip libzmq5"
 exit 1
fi
clear
}

function setup_sentinel() {
echo -e "Installing and configuring ${GREEN}Sentinel${NC}."
mkdir $DATAFOLDER >/dev/null 2>&1
cd $DATAFOLDER >/dev/null 2>&1
sudo apt-get -y install python-virtualenv virtualenv >/dev/null 2>&1
git clone https://github.com/Argo20/sentinel.git && cd sentinel >/dev/null 2>&1
virtualenv ./venv >/dev/null 2>&1
./venv/bin/pip install -r requirements.txt >/dev/null 2>&1
./venv/bin/python bin/sentinel.py >/dev/null 2>&1
touch  /var/spool/cron/crontabs/root >/dev/null 2>&1
chmod 0600 /var/spool/cron/crontabs/root >/dev/null 2>&1
(crontab -l 2>/dev/null; echo "* * * * * cd $DATAFOLDER/sentinel && SENTINEL_DEBUG=1 ./venv/bin/python bin/sentinel.py") | crontab -
(crontab -l 2>/dev/null; echo "0 0 * * 0 rm $DATAFOLDER/sentinel/sentinel.log") | crontab -

echo 'argo_conf='$CONFIGFOLDER/$CONFIG_FILE$'
network=mainnet
db_name=database/sentinel.db
db_driver=sqlite' | sudo -E tee $SENTINEL_CONF >/dev/null 2>&1
chmod -R 755 $DATAFOLDER/sentinel/database
clear
}

function create_swap() {
SWAP_FILE=$(free -m | grep -i swap | awk -F" " '{print $2}')
if [[ $SWAP_FILE == 0 ]]; then
   read -e -p "Is your VPS Provider allowing to create SWAP file? If not sure hit enter! [Y/n] : " swapallowed
   if [[ ("$swapallowed" == "y" || "$swapallowed" == "Y") ]]; then
     echo "Creating SWAP file..."
     sudo touch /mnt/swap.img >/dev/null 2>&1
     sudo chmod 0600 /mnt/swap.img >/dev/null 2>&1
     dd if=/dev/zero of=/mnt/swap.img bs=1024k count=$PHYS_MEM >/dev/null 2>&1
     sudo mkswap /mnt/swap.img >/dev/null 2>&1
     sudo swapon /mnt/swap.img >/dev/null 2>&1
     sudo echo "/mnt/swap.img none swap sw 0 0" >> /etc/fstab >/dev/null 2>&1
     clear
   fi
fi
}

function bootstrap() {
TMP_PATH='/root/bootstrap_temp'
mkdir $TMP_PATH >/dev/null 2>&1
cd $TMP_PATH >/dev/null 2>&1
echo -e "Downloading and extracting $COIN_NAME blockchain files."
wget -q $COIN_CHAIN
tar -xzvf $COIN_CHAIN_FILE -C $TMP_PATH/ >/dev/null 2>&1
rm -rf $CONFIGFOLDER/blocks/ >/dev/null 2>&1
rm -rf $CONFIGFOLDER/chainstate/ >/dev/null 2>&1
mv $TMP_PATH/root/Bootstrap/.argocore/blocks/ $CONFIGFOLDER/ >/dev/null 2>&1
mv $TMP_PATH/root/Bootstrap/.argocore/chainstate/ $CONFIGFOLDER/ >/dev/null 2>&1
cd ~
rm -r $TMP_PATH >/dev/null 2>&1
}

function important_information() {
 echo -e "================================================================================================================================"
 echo -e "$COIN_NAME Masternode is up and running listening on port ${RED}$COIN_PORT${NC}."
 echo -e "Configuration file is: ${RED}$CONFIGFOLDER/$CONFIG_FILE${NC}"
 echo -e "Start: ${RED}systemctl start $COIN_NAME.service${NC}"
 echo -e "Stop: ${RED}systemctl stop $COIN_NAME.service${NC}"
 echo -e "VPS_IP:PORT ${RED}$NODEIP:$COIN_PORT${NC}"
 echo -e "MASTERNODE PRIVATEKEY is: ${RED}$COINKEY${NC}"
 echo -e "Please check ${RED}$COIN_NAME${NC} daemon is running with the following command: ${RED}systemctl status $COIN_NAME.service${NC}"
 echo -e "Use ${RED}$COIN_CLI masternode status${NC} to check your MN."
 if [[ -n $SENTINEL_REPO  ]]; then
  echo -e "${RED}Sentinel${NC} is installed in ${RED}$CONFIGFOLDER/sentinel${NC}"
  echo -e "Sentinel logs is: ${RED}$CONFIGFOLDER/sentinel.log${NC}"
 fi
 echo -e "================================================================================================================================"
}

function setup_node() {
  get_ip
  create_config
  bootstrap
  create_key
  update_config
  enable_firewall
  configure_systemd
}


##### Main #####
clear

checks
create_swap
prepare_system
download_node
setup_node
setup_sentinel
important_information
