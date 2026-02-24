Comandos Básicos de Docker Compose
Asegúrate de ejecutar estos comandos dentro de la carpeta TERRARIA-DOCK (donde se encuentra el archivo docker-compose.yml).

Iniciar el servidor
Si los contenedores ya están creados y solo quieres encenderlos para jugar:

Bash
docker compose start
(Alternativa: docker compose up -d)

Apagar el servidor y guardar el mundo
Este es el método seguro. Envía la señal para que tModLoader guarde el mundo adriangei.wld y luego apaga tanto el servidor como el túnel de Playit:

Bash
docker compose stop
Reconstruir el servidor (Solo si cambias scripts o Dockerfile)
Si agregas nuevos mods al install.txt o modificas el entrypoint.sh, necesitas reconstruir la imagen:

Bash
docker compose up -d --build
🔍 Monitoreo y Logs
Para ver qué está haciendo el servidor en tiempo real (útil para saber cuándo terminó de cargar Calamity):

Bash
docker logs -f calamity-server
(Para salir de esta vista, presiona Ctrl + C).

Para revisar el estado de la conexión de Playit.gg:

Bash
docker logs playit-tunnel
🛠️ Consola del Juego y Comandos de Administrador
Puedes interactuar directamente con la consola de Terraria para cambiar la hora, ver jugadores o enviar mensajes.

1. Entrar a la consola
Bash
docker attach calamity-server
2. Comandos útiles dentro del juego
Una vez dentro, escribe cualquiera de estos comandos y presiona Enter:

playing : Muestra la lista de jugadores conectados.

say <mensaje> : Envía un mensaje amarillo a todos los jugadores.

dawn : Cambia la hora al amanecer (4:30 AM).

dusk : Cambia la hora al atardecer (7:30 PM).

exit : Guarda el mundo y apaga el contenedor del servidor.

3. Salir de la consola (¡MUY IMPORTANTE!)
⚠️ NO presiones Ctrl + C mientras estás en la consola con attach, ya que matarás el servidor sin guardar.
Para salir de la consola y dejar el servidor corriendo en segundo plano, usa esta secuencia de teclas:
👉 Presiona Ctrl + P, suelta, y luego presiona Ctrl + Q.

📶 Ver el Ping (Dentro del juego)
Para que cualquier jugador pueda ver su latencia (Ping) en tiempo real, simplemente deben presionar la tecla F8 mientras están dentro de la partida. Esto abrirá la pantalla de depuración de red de Terraria.