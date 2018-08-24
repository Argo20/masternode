# How to update ARGO masternode

To update your local desktop wallet and your masternode, follow our instructions.

# Local desktop wallet update
1. Download desktop wallet for Windows, Linux or macOS here: https://github.com/Argo20/argo/releases
2. Make sure, to **create a backup of your wallet.dat!**
3. Replace your **argo-qt.exe** with new/downloaded

Login to your VPS and stop your ARGO daemon using this command: `argo-cli stop`
If you're not sure, where argo-cli is located on your VPS use this command to find the file: `find . -type f -name "argod"`
   
Download new release: `wget https://github.com/Argo20/argo/releases/download/v1.1.0.0/argocore-1.1.0-i686-pc-linux-gnu.tar.gz`
