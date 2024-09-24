# Setup Openvpn on LibreElec

```bash
# Kodi Leia 18+
# Download below to install from Repository and install from zip
curl -fsSLo repository.zomboided.plugins-1.0.0.zip https://github.com/Zomboided/repository.zomboided.plugins/releases/download/1.0.0/repository.zomboided.plugins-1.0.0.zip

# Kodi Leia 18+
# Download the vpn manager directly and install from zip
curl -fsSLo service.vpn.manager-6.4.2.zip https://github.com/Zomboided/service.vpn.manager/releases/download/6.4.2/service.vpn.manager-6.4.2.zip

# Kodi Matrix 19+
# Download the vpn manager directly and install from zip
curl -fsSLo service.vpn.manager-6.9.3.zip https://github.com/Zomboided/service.vpn.manager/releases/download/6.9.3/service.vpn.manager-6.9.3.zip
```

Install the downloaded repository and install the vpn manager `service` from the zomboided repository.  If you installed the vpn manager directly or from repository the service will auto-launch after for the first time.

On first launch:
1. Select `[Wizard]` and select `autostart service on bootup`
2. Select your VPN Provider from the list.
    - The rest of the instructions have been tested using `ExpressVPN`
    - When the vpn service launches for the first time you need:
        - [ExpressVPN](https://www.expressvpn.com/support/vpn-setup/manual-config-for-linux-ubuntu-with-openvpn/): (Expressvpn setup instructions for [openvpn](https://www.expressvpn.com/setup#manual))
            - Username: \<encrypted username>
            - Password: \<encrypted password>
            - Download Clent Zip file to get your:
                - client.crt
                - client.key
            - Download VPN Site .ovpn file for each vpn server you wish to connect to 
3. Once you select your vpn provider from the list you will be prompted for your user credentials:
    - Username: \<encrypted username>
    - Password: \<encrypted password>
4. Select you vpn location on the next screen:
    - Once you select your first VPN location, you will be prompted for the client.key and client.crt file downloaded from you vpn provider site:
        - client.crt
        - client.key
        - The certificate and key will be used to verify your identity for each location selected.
5. This it...<br/>
You can select additional vpn location as a backup incase you first selection is down. It is recommended to select 3 locations as backups. This can be done in the addon settings under the VPN Connection tab.
