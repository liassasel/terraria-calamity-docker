#!/bin/bash

# Enlazar la ruta oficial de tModLoader al volumen de DaemonOS
ln -sfn /data /home/tml/.local/share/Terraria/tModLoader
FOLDER="/data"
CONFIG_FILE="$FOLDER/serverconfig.txt"

echo "[DaemonOS] Inicializando servidor tModLoader..."

echo "maxplayers=${MAX_PLAYERS:-8}" > "$CONFIG_FILE"
echo "port=${PORT:-7777}" >> "$CONFIG_FILE"
echo "password=${PASSWORD:-}" >> "$CONFIG_FILE"
echo "motd=\"${MOTD:-Servidor alojado en DaemonOS}\"" >> "$CONFIG_FILE"
echo "worldpath=$FOLDER/Worlds/" >> "$CONFIG_FILE"
echo "world=$FOLDER/Worlds/${WORLD_NAME:-DaemonOSWorld}.wld" >> "$CONFIG_FILE"
echo "autocreate=${AUTO_CREATE:-1}" >> "$CONFIG_FILE"
echo "worldname=${WORLD_NAME:-DaemonOSWorld}" >> "$CONFIG_FILE"
echo "difficulty=${DIFFICULTY:-1}" >> "$CONFIG_FILE"

if [ -f "$FOLDER/Mods/install.txt" ]; then
    echo "[DaemonOS] Archivo install.txt detectado. Descargando mods de Workshop..."
    cd /home/tml
    ./manage-tModLoaderServer.sh install-mods -f "$FOLDER"
else
    echo "[DaemonOS] No se detectó install.txt. Saltando descarga de mods."
fi

mkdir -p /home/tml/server/steamapps
ln -sf "$FOLDER/steamapps" "/home/tml/server/steamapps"

echo "[DaemonOS] ¡Arrancando el motor de tModLoader!"
cd /home/tml/server
chmod +x start-tModLoaderServer.sh

if [ -n "$RAM_LIMIT" ]; then
    MEM_ARG="-Xmx${RAM_LIMIT}M"
else
    MEM_ARG=""
fi

./start-tModLoaderServer.sh -config "$CONFIG_FILE" -nosteam -tmlsavedirectory "$FOLDER" $MEM_ARG