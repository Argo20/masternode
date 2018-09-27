### **[Back to guide main site](readme.md)**

## VPS & masternode setup
First you need to create a VPS to go forward with this guide. I prefer to use [**Vultr**](https://www.vultr.com/?ref=7397596).

1. Create an account at [**Vultr**](https://www.vultr.com/?ref=7397596)

2. Create a VPS for your masternode
    
    After creating an account at [**Vultr**](https://www.vultr.com/?ref=7397596) you can start creating your 1st VPS. Hit the **+** to begin.
    
    <img src="https://node-support.network/coins/argo/mn-guide/vps/1.png">
    
    Choose a favorite **Server Location**
    
    <img src="https://node-support.network/coins/argo/mn-guide/vps/2.png">
    
    scroll a bit down to **Server Type** and choose **Ubuntu 16.04** to continue without any issues.
    
    <img src="https://node-support.network/coins/argo/mn-guide/vps/3.png">
    
    now goto **Server Size** and select a Server Type, I'm using the **25 GB SSD/5$ VPS** for my masternodes (If you choose smaller VPS, I can't guarantee that you won't get any issues with this guide)
    
    <img src="https://node-support.network/coins/argo/mn-guide/vps/4.png">
    
    now goto **Server Hostname & Label** and enter **Server Hostname** and **Server Label** (_e.g. ARGO-mn01_)
    
    <img src="https://node-support.network/coins/argo/mn-guide/vps/5.png">
    
    After creating this VPS you will see your VPS on your main page **Servers**. Hit the **Manage** link to get your VPS details
    
    <img src="https://node-support.network/coins/argo/mn-guide/vps/6.png">
    
    Now you see your VPS details like: **IP-Address, Username and Password (is hidden)**
    
    <img src="https://node-support.network/coins/argo/mn-guide/vps/7.png">
    
3. Connection to your VPS

    To connect to your VPS, [download and start PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html), enter your **IP-Address of your VPS** (see VPS details at Vultr) and hit the **Open** button
    
    <img src="https://node-support.network/coins/argo/mn-guide/vps/8.png">
    
    You will get an **PuTTY Security Alert** window, just hit the **Yes** button to continue
    
    <img src="https://node-support.network/coins/argo/mn-guide/vps/9.png">
    
    Now you're connected to the CLI on your VPS via SSH
    
    <img src="https://node-support.network/coins/argo/mn-guide/vps/10.png">
    
4. Masternode setup

    Now we start the ARGO masternode setup script, copy and paste this command and hit enter:
    
    `sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/Argo20/masternode/master/masternode-setup.sh)"`
       
    Script begins it's work and you will be asked if SWAP file is allowed. If you followd my instructions and you created a VPS at [**Vultr**](https://www.vultr.com/?ref=7397596) then type **y** and hit enter.
    
    Next questions you will be asked is to enter a **masternode genkey**. You have 2 options:
    
    **A.** Create a masternode genkey via your local deskop wallet\
    **B.** Hit enter and script creates a masternode genkey for you which you have to use for your local wallet masternode.conf (we'll get to that in next guide page)
