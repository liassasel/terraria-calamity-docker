#  Terraria Calamity Server - Docker Control

Guía de administración para el servidor de tModLoader (Calamity Mod) gestionado con Docker y Playit.gg.

---

##  Gestión del Servidor

Nota: Ejecuta siempre estos comandos dentro del directorio TERRARIA-DOCK | (Tu directorio).

###  Iniciar el servidor
Si los contenedores ya existen, usa esto para encenderlo:

docker compose start

Si es la primera vez:

docker compose up -d

### Apagado Seguro (Guardado de mundo)
Detiene los servicios y asegura que el mundo adriangei.wld se guarde correctamente:

docker compose stop

### Actualizar Mods o Configuración

Si editaste el Dockerfile, entrypoint.sh o el archivo install.txt:

docker compose up -d --build

---

## Monitoreo y Logs

Ver carga de Calamity:

docker logs -f calamity-server

Ver estado de Playit:

docker logs playit-tunnel

(Presiona Ctrl + C para dejar de ver los logs).

---

## Consola de Administrador

Acceso directo a la terminal de comandos del juego.

### 1. Entrar a la consola

docker attach calamity-server

### 2. Comandos útiles (Escribir dentro)

playing : Lista de jugadores conectados.

say <mensaje> : Enviar anuncio global.

dawn / dusk : Cambiar la hora del día.

exit : Guardar mundo y cerrar contenedor.

### 3. Cómo Salir sin apagar el servidor

¡IMPORTANTE! NO uses Ctrl + C.

Para salir de la consola y dejar el servidor encendido usa la secuencia:

Presiona Ctrl + P, suelta, y luego presiona Ctrl + Q.

---

fin :)

---