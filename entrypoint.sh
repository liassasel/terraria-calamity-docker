#!/bin/bash

# La ruta de tu carpeta sincronizada
FOLDER="/home/tml/.local/share/Terraria/tModLoader"
CONFIG_FILE="$FOLDER/serverconfig.txt"

# 1. Crear la configuración exacta
echo "world=$WORLD" > "$CONFIG_FILE"
echo "password=$PASSWORD" >> "$CONFIG_FILE"
echo "motd=$MOTD" >> "$CONFIG_FILE"
echo "autocreate=0" >> "$CONFIG_FILE"

# 2. Descargar e instalar los mods (Calamity) si existe el install.txt
if [ -f "$FOLDER/Mods/install.txt" ]; then
    echo "Buscando e instalando mods de la Steam Workshop..."
    cd /home/tml
    ./manage-tModLoaderServer.sh install-mods -f "$FOLDER"
fi

# 3. Enlazar la carpeta de descargas de Steam para que el juego lea los mods
ln -sf "$FOLDER/steamapps" "/home/tml/server/steamapps"

# 4. Encender el servidor directamente, saltándonos al intermediario
echo "¡Arrancando el servidor de tModLoader!"
cd /home/tml/server
chmod +x start-tModLoaderServer.sh

./start-tModLoaderServer.sh -config "$CONFIG_FILE" -nosteam -tmlsavedirectory "$FOLDER"