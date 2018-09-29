# How to update ARGO masternode

To update your local desktop wallet and your masternode, follow our instructions.\
If you have any questions/issues, feel free to contact us via Discord: **https://discord.gg/vxnBpWy**

## Local desktop wallet update
1. Download desktop wallet for Windows, Linux or macOS here: https://github.com/Argo20/argo/releases
2. Make sure, to **create a backup of your wallet.dat!**
3. Close your wallet and replace **argo-qt.exe** with new/downloaded
4. Start new **argo-qt.exe**

## Updating ARGO daemon on VPS
1. Login to your VPS and stop your ARGO daemon using this command: 

   `argo-cli stop`
2. If you're not sure, where argod is located on your VPS use this command to find the file:

   `cd /`\
   `sudo find . -type f -name "argod"`\
   **Hint:** Take this path from output, but without __argod__ and the end from output
   
   Now use the ARGO folder location to stop your masternode:
   
   `./<YOUR-ARGO-FOLDER-LOCATION>/argo-cli stop`
   
3. Download and extract new release:\
It is important to replace **argod** and **argo-cli** in the folder where the files are located!

   `wget https://github.com/Argo20/argo/releases/download/v1.1.0.0/argocore-1.1.0-x86_64-unknown-linux-gnu.tar.gz`\
   `tar -xzvf argocore-1.1.0-x86_64-unknown-linux-gnu.tar.gz`\
   `cp argocore-1.1.0/bin/argod argocore-1.1.0/bin/argo-cli /<YOUR-ARGO-FOLDER-LOCATION>/`

4. Start new ARGO daemon (your masternode)\
__Important:__ Create a backup of your **_argo.conf_** ! If you are not sure, where this file is localted, use this command to find it:\

   `cd /`\
   `sudo find . -type f -name "argo.conf"`

   Start the new ARGO daemon: `/<YOUR-ARGO-FOLDER-LOCATION>/argod -daemon`

   Check if ARGO daemon is running: `/<YOUR-ARGO-FOLDER-LOCATION>/argo-cli getinfo`
   
   Now your ARGO files are updated (argod & argo-cli). Check if your blockchain on your VPS is synched:\
   `/<YOUR-ARGO-FOLDER-LOCATION>/argo-cli getinfo | grep blocks`

   Check your block with ARGO Block-Explorer: <a href="https://altmix.org/coins/45-ARGO/explorer" target="_blank">ARGO Block-Explorer</a>
   
   If Blockchain on your VPS is up to date, continue with next step.
   
5. Start your masternode from desktop wallet \
   Open your desktop wallet, unlock your wallet (Menu __Settings -> Unlock Wallet__), goto __Masternodes__ tab, click on your masternode
   and press __Start alias__ button. Your masternode should be started now.
   
   Check your masternode status on your VPS via:\
   `/<YOUR-ARGO-FOLDER-LOCATION>/argo-cli masternode status | grep status`
   
   If everything went fine, status should be\
   `"status": "Masternode successfully started"`
   
   Masternode status in your desktop wallet will change to **_WATCHDOG_EXPIRED_** but after 20 minutes should change to **_ENABLED_**.\
   After masternode status changed to **__ENABLED__**, you will get ARGO coins after about 30 hours.
   
   If your wallet / masternode have any sync problems, add these nodes to your desktop wallet **__argo.conf__** and / or to your VPS **__argo.conf__**
   
   `addnode=173.212.203.209`\
   `addnode=173.249.11.174`
