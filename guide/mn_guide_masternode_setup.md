### **[Back to guide main site](readme.md)**

## Masternode Setup

1. Start the script

    Now we start the ARGO masternode setup script, copy and paste this command and hit enter:
    
    `sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/Argo20/masternode/master/masternode-setup.sh)"`
       
    Script begins it's work and you will be asked if SWAP file is allowed. If you followd my instructions and you created a VPS at [**Vultr**](https://www.vultr.com/?ref=7397596) then type **y** and hit enter.
    
    Next question you will be asked is to enter a **masternode genkey**. You have 2 options:
    
    **A.** Create a masternode genkey via your local deskop wallet\
    **B.** Hit enter and script creates a masternode genkey for you which you have to use for your local wallet masternode.conf (we'll get to that in next guide page)
