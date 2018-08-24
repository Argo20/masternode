# How to update ARGO masternode

To update your local desktop wallet and your masternode, follow our instructions.\
If you have any questions/issues, feel free to contact us via Discord **INVITE LINK TO DISCORD**

## Local desktop wallet update
1. Download desktop wallet for Windows, Linux or macOS here: https://github.com/Argo20/argo/releases
2. Make sure, to **create a backup of your wallet.dat!**
3. Close your wallet and replace **argo-qt.exe** with new/downloaded
4. Start new **argo-qt.exe**

## Updating ARGO daemon on VPS
1. Login to your VPS and stop your ARGO daemon using this command: 

   `argo-cli stop`
2. If you're not sure, where argo-cli is located on your VPS use this command to find the file:

   `cd /`\
   `find . -type f -name "argod"`
   
   Now use the ARGO folder location to stop your masternode:
   
   `./<YOUR-ARGO-FOLDER-LOCATION>/argo-cli stop`
   
3. Download and extract new release:\
It is important to replace **argod** and **argo-cli** in the folder where the files are located!

   `wget https://github.com/Argo20/argo/releases/download/v1.1.0.0/argocore-1.1.0-i686-pc-linux-gnu.tar.gz`\
   `tar -xzvf argocore-1.1.0-i686-pc-linux-gnu.tar.gz`\
   `cp argocore-1.1.0/bin/argod argocore-1.1.0/bin/argo-cli /<YOUR-ARGO-FOLDER-LOCATION>/`
