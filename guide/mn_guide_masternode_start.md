### **[Back to guide main site](readme.md)**

## Masternode start

To start your masternode, open your wallet and goto **Tools -> Open Masternode Configuration File**

<img src="https://node-support.network/coins/argo/mn-guide/masternode_start/1.png">

Notepad opens the masternode.conf file which is empty

<img src="https://node-support.network/coins/argo/mn-guide/masternode_start/2.png">

now we need to add some informations in this file:
1. Masternode alias\
    You can choose a masternode alias name yourself (e.g. mn01)
    
2. IP-Address:port\
    IP-Address of your VPS and ARGO predefined port 8989

3. masternode genkey\
    Masternode genkey which was generated via setup script, or via local desktop wallet

4. Collateral tx / txid\
    Collateral tx / txid which you get via wallet debug console

All informations should be added **in one line** to masternode.conf as you can see my example:

`mn01 95.179.180.218:8989 64xSKa5tJAR3VgAHBTwNmqFHwvo2ia2ZZAJHwqkhJGoQBMt2tgX 806e32c2ccca1dcad3c2be9b2fdb59a90198e00936df982ce63bf30185201aff 1`

<img src="https://node-support.network/coins/argo/mn-guide/masternode_start/3.png">

**Save the masternode.conf file**, close and start your wallet again. After starting wallet and goto **Masternodes** tab and you should see one entry

<img src="https://node-support.network/coins/argo/mn-guide/masternode_start/4.png">

to start the masternode select the entry and hit **Start Alias** button

<img src="https://node-support.network/coins/argo/mn-guide/masternode_start/5.png">

you will be asked if you want to start masternode, just hit **Yes** button

<img src="https://node-support.network/coins/argo/mn-guide/masternode_start/6.png">

you get a confirmation that masternode is successfully started

<img src="https://node-support.network/coins/argo/mn-guide/masternode_start/7.png">

status of masternode in **Masternodes** tab will change to **WATCHDOG_EXPIRED**

<img src="https://node-support.network/coins/argo/mn-guide/masternode_start/8.png">

after ~ 30 mins masternode status should change to **ENABLED**

<img src="https://node-support.network/coins/argo/mn-guide/masternode_start/9.png">

Finally your masternode is started and activated. If you have any issues, feel free to contact us.
