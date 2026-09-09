#!/bin/bash

# Enlazar la ruta oficial de tModLoader al volumen de DaemonOS
ln -sfn /data /home/tml/.local/share/Terraria/tModLoader
FOLDER="/data"
CONFIG_FILE="$FOLDER/serverconfig.txt"

echo "[DaemonOS] Inicializando servidor tModLoader..."

# Si se especifica una versión, instalar esa versión
if [ -n "$TMOD_VERSION" ]; then
    echo "[DaemonOS] Versión solicitada: $TMOD_VERSION"
    cd /home/tml
    ./manage-tModLoaderServer.sh install-tml --github --tml-version "$TMOD_VERSION" -f "$FOLDER"
else
    echo "[DaemonOS] Usando versión pre-instalada en la imagen"
fi

echo "maxplayers=${TMOD_MAXPLAYERS:-8}" > "$CONFIG_FILE"
echo "port=${TMOD_PORT:-7777}" >> "$CONFIG_FILE"
echo "password=${TMOD_PASS:-}" >> "$CONFIG_FILE"
echo "motd=\"${TMOD_MOTD:-Servidor alojado en DaemonOS}\"" >> "$CONFIG_FILE"
echo "worldpath=$FOLDER/Worlds/" >> "$CONFIG_FILE"
echo "world=$FOLDER/Worlds/${TMOD_WORLDNAME:-DaemonOSWorld}.wld" >> "$CONFIG_FILE"
echo "autocreate=1" >> "$CONFIG_FILE"
echo "worldname=${TMOD_WORLDNAME:-DaemonOSWorld}" >> "$CONFIG_FILE"
echo "difficulty=${TMOD_DIFFICULTY:-1}" >> "$CONFIG_FILE"

# Crear install.txt desde TMOD_AUTODOWNLOAD si existe
if [ -n "$TMOD_AUTODOWNLOAD" ]; then
    echo "[DaemonOS] TMOD_AUTODOWNLOAD detectado: $TMOD_AUTODOWNLOAD"
    mkdir -p "$FOLDER/Mods"
    echo "$TMOD_AUTODOWNLOAD" | tr ',' '\n' > "$FOLDER/Mods/install.txt"
    echo "[DaemonOS] install.txt creado con $(wc -l < "$FOLDER/Mods/install.txt") mods"
fi

if [ -f "$FOLDER/Mods/install.txt" ]; then
    echo "[DaemonOS] Descargando mods de Workshop..."
    cd /home/tml
    ./manage-tModLoaderServer.sh install-mods -f "$FOLDER"
else
    echo "[DaemonOS] No hay mods para descargar."
fi

WORKSHOP_DIR="$FOLDER/steamapps/workshop/content/1281930"
if [ -d "$WORKSHOP_DIR" ]; then
    echo "[DaemonOS] Copiando archivos .tmod del Workshop a Mods/..."
    find "$WORKSHOP_DIR" -name "*.tmod" -exec cp -f {} "$FOLDER/Mods/" \;
    echo "[DaemonOS] .tmod copiados: $(ls "$FOLDER/Mods/"*.tmod 2>/dev/null | wc -l) archivos"
fi

# Generar enabled.json con los nombres internos de cada .tmod
# tModLoader hace un doble scan: si enabled.json no existe, crea [] y en el
# segundo scan no carga nada. Debemos generar el archivo correctamente.
MODS_COUNT=0
MODS_JSON="["
FIRST=true
for TMOD_FILE in "$FOLDER/Mods/"*.tmod; do
    [ -f "$TMOD_FILE" ] || continue
    MOD_NAME=$(basename "$TMOD_FILE" .tmod)
    if [ "$FIRST" = true ]; then
        FIRST=false
    else
        MODS_JSON="${MODS_JSON},"
    fi
    MODS_JSON="${MODS_JSON}\"${MOD_NAME}\""
    MODS_COUNT=$((MODS_COUNT + 1))
done
MODS_JSON="${MODS_JSON}]"

if [ "$MODS_COUNT" -gt 0 ]; then
    echo "$MODS_JSON" > "$FOLDER/Mods/enabled.json"
    echo "[DaemonOS] enabled.json generado con $MODS_COUNT mods: $(ls "$FOLDER/Mods/"*.tmod 2>/dev/null | xargs -I{} basename {} .tmod | tr '\n' ', ')"
else
    echo "[]" > "$FOLDER/Mods/enabled.json"
    echo "[DaemonOS] No se encontraron .tmod — enabled.json vacío"
fi

# 3. Arranque
echo "[DaemonOS] ¡Arrancando el motor de tModLoader!"
cd /home/tml/server
chmod +x start-tModLoaderServer.sh

if [ -n "$RAM_LIMIT" ]; then
    MEM_ARG="-Xmx${RAM_LIMIT}M"
else
    MEM_ARG=""
fi

./start-tModLoaderServer.sh -config "$CONFIG_FILE" -nosteam -tmlsavedirectory "$FOLDER" $MEM_ARG