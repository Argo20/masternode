# Masternode guide and script files related to ARGO masternode

Welcome to our ARGO masternode repository. Here you find guides like how to update your running masternode, how to setup a new masternode and some hints how to fix issues, which we heard about from our community.

## Installing ARGO masternode:

To install a new ARGO masternode (including updates and sentinel), just download our script and execute it and follow steps showed in script.

**Important:** Run this script as **_root_**, if you plan to run this script as non-root user, it may fails!\
**Our script is tested on Ubuntu 16.04**

`sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/Argo20/masternode/master/masternode-setup.sh)"`

## Issue with Wallet status **_WATCHDOG_EXPIRED_**

If you continue to occurs WATCHDOG_EXPIRED error, check the following:  
`argo-cli mnsync status | grep IsSynced`
  
    "IsSynced": true,
  
`argo-cli masternode status | grep status`
  
    "status": "Masternode successfully started"
  
`cd ~/ARGO/sentinel/` \
`./venv/bin/py.test ./test`
  
    ===== 23 passed in 0.25 seconds =====
  
`./venv/bin/python bin/sentinel.py`
  
    There should be NO ERROR.
  
  
If there are **no errors**, please wait about 20 minutes.  
After 20 minutes, "WATCHDOG_EXPIRED" will change to "ENABLED". 
