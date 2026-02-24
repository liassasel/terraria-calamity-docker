#!/bin/bash

FOLDER="/home/tml/.local/share/Terraria/tModLoader"
CONFIG_FILE="$FOLDER/serverconfig.txt"

echo "world=$WORLD" > "$CONFIG_FILE"
echo "password=$PASSWORD" >> "$CONFIG_FILE"
echo "motd=$MOTD" >> "$CONFIG_FILE"
echo "autocreate=0" >> "$CONFIG_FILE"

if [ -f "$FOLDER/Mods/install.txt" ]; then
    echo "Buscando e instalando mods de la Steam Workshop..."
    cd /home/tml
    ./manage-tModLoaderServer.sh install-mods -f "$FOLDER"
fi

ln -sf "$FOLDER/steamapps" "/home/tml/server/steamapps"

echo "¡Arrancando el servidor de tModLoader!"
cd /home/tml/server
chmod +x start-tModLoaderServer.sh

./start-tModLoaderServer.sh -config "$CONFIG_FILE" -nosteam -tmlsavedirectory "$FOLDER"