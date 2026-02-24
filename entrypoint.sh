#!/bin/bash

CONFIG_FILE="/home/tml/.local/share/Terraria/tModLoader/serverconfig.txt"
echo "world=$WORLD" > $CONFIG_FILE
echo "password=$PASSWORD" >> $CONFIG_FILE
echo "motd=$MOTD" >> $CONFIG_FILE

cd /home/tml
echo "Iniciando tModLoader Server..."
./manage-tModLoaderServer.sh start