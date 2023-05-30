#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

# Prepare configuration files and adopt paths
cp web.config.properties.dist web.config.properties
cp settings_whitelist.json.dist settings_whitelist.json
sed -i '/-DWebBackend.SETTINGS_FILE=/c\-DWebBackend.SETTINGS_FILE=/opt/Ultimate/WebBackend/web.config.properties' WebBackend.ini
sed -i '/SETTINGS_WHITELIST=/c\SETTINGS_WHITELIST=/opt/Ultimate/WebBackend/settings_whitelist.json' web.config.properties
sed -i '/FRONTEND_PATH=/c\FRONTEND_PATH=/opt/Ultimate/WebsiteStatic' web.config.properties 
sed -i '/LOG_FILE_PATH=/c\LOG_FILE_PATH=/opt/Ultimate/log/logfile.log' web.config.properties