#!/usr/bin/env bash
################################################################
# Download the installer
curl -fsSLo /tmp/expressvpn_3.7.0.29-1_armhf.deb  https://www.expressvpn.works/clients/linux/expressvpn_3.7.0.29-1_armhf.deb
# Open Terminal. Run this command to install the app
dpkg -i /tmp/expressvpn_3.7.0.29-1_armhf.deb
# If you see the error message, “Cannot connect to expressvpn 
# daemon,” enter the following command to restart ExpressVPN
if [[ $? -ne 0 ]]; then 
    service expressvpn restart
fi
sleep 3
# In the Terminal window, run this command to activate the app
# You will be prompted for your activation code...which you can
# retrieve from your account setup page.
expressvpn activate
# If you want to opt out of sending diagnostics to ExpressVPN 
# in the future, run this command:
expressvpn preferences set send_diagnostics false
#
expressvpn connect
# To disconnect from a server location, run this command:
#expressvpn disconnect