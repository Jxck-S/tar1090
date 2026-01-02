#!/bin/bash
# Uninstallation Logic:
# 1. Accepts an instance name as an optional argument ($1).
# 2. If an instance name is provided:
#    - Removes the specific HTML directory for that instance.
#    - Stops and disables the systemd service for that instance.
# 3. If no instance is provided:
#    - Removes the entire base directory (/usr/local/share/tar1090) and all contents.
#    - Removes all lighttpd configuration files related to tar1090.
# 4. Removes the systemd service file and reloads the daemon.
# 5. Restarts lighttpd (note: this logic currently retains lighttpd references).
# 6. Leaves the configuration file (/etc/default/tar1090) for manual removal.

instance=tar1090
echo --------------
if [[ -n $1 ]]; then
	instance="tar1090-$1"
    rm -rf "/usr/local/share/tar1090/html-$1"
    echo "Removing tar1090, instance name $instance!"
else
    echo "Removing tar1090, all instances!"
	rm -rf /usr/local/share/tar1090
    rm -f /etc/lighttpd/conf-available/*tar1090*
    rm -f /etc/lighttpd/conf-enabled/*tar1090*
fi
echo --------------

systemctl stop "$instance"
systemctl disable "$instance"

#rm -f /etc/default/$instance
echo "Configuration is left to be removed manually, you can use this command:"
echo "sudo rm /etc/default/$instance"
rm -f "/lib/systemd/system/$instance.service"

rm -f "/etc/lighttpd/conf-available/88-$instance.conf"
rm -f "/etc/lighttpd/conf-enabled/88-$instance.conf"
rm -f "/etc/lighttpd/conf-available/99-$instance-webroot.conf"
rm -f "/etc/lighttpd/conf-enabled/99-$instance-webroot.conf"


systemctl daemon-reload
systemctl restart lighttpd



echo --------------
echo "tar1090 is now gone! Shoo shoo!"
