#!/bin/bash

# Verificar si se está ejecutando como root
if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ejecutarse como root."
    exit 1
fi

echo "Iniciando la instalación..."

# Actualizar el sistema
echo "Actualizando el sistema..."
apt update
echo "Sistema actualizado."
sleep 5

# Instalar paquetes necesarios
echo "Instalando paquetes necesarios: git, curl, nodejs, htop, aria2..."
apt install -y git curl nodejs htop aria2
echo "Paquetes instalados."
sleep 5

# Clonar el repositorio webui-aria2 desde GitHub en /home
echo "Clonando el repositorio webui-aria2 desde GitHub..."
git clone https://github.com/ziahamza/webui-aria2.git /home/webui-aria2
echo "Repositorio clonado en /home/webui-aria2."
sleep 5

# Crear directorios necesarios
echo "Creando directorios necesarios: /etc/aria2, /home/Disk..."
mkdir /etc/aria2 -p
mkdir /home/Disk -p
mkdir /home/a-wa-a/local -p
mkdir /home/a-wa-a/Torrent -p

echo "Directorios creados."
sleep 5

# Crear la carpeta Incompletas en /home
echo "Creando la carpeta /home/Incompletas..."
mkdir -p /home/Incompletas
echo "Carpeta /home/Incompletas creada."
sleep 5

# Crear un archivo de texto vacío session.txt en /home/Incompletas
echo "Creando el archivo /home/Incompletas/session.txt..."
touch /home/Incompletas/session.txt
echo "Archivo /home/Incompletas/session.txt creado."
sleep 5


# Editar el archivo aria2.conf
echo "Editando el archivo aria2.conf..."
echo "dir=/home/Disk
enable-rpc=true
rpc-allow-origin-all=true
rpc-listen-all=true
rpc-listen-port=6800
rpc-secret=SomethingSecure
save-session=/home/Incompletas/session.txt
continue=true
input-file=/home/Incompletas/session.txt
seed-ratio=1.0
--max-download-result=300" > /etc/aria2/aria2.conf
echo "Configuración de aria2 actualizada."
sleep 5


# Editar el archivo aria2.service
echo "Editando el archivo aria2.service..."
echo "[Unit]
Description=Aria2c
Requires=network.target
After=dhcpcd.service

[Service]
ExecStart=/usr/bin/aria2c --conf-path=/etc/aria2/aria2.conf

[Install]
WantedBy=default.target" > /etc/systemd/system/aria2.service
echo "Archivo de servicio Aria2 actualizado."
sleep 5

# Editar el archivo webui-aria2.service
echo "Editando el archivo webui-aria2.service..."
echo "[Unit]
Description=WebUI Aria2 Service
After=network.target

[Service]
ExecStart=/usr/bin/node /home/webui-aria2/node-server.js
WorkingDirectory=/home/webui-aria2
Restart=always
User=root

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/webui-aria2.service
echo "Archivo de servicio WebUI Aria2 actualizado."
sleep 5

# Recargar systemd para aplicar los cambios
echo "Recargando systemd para aplicar los cambios..."
systemctl daemon-reload
echo "Systemd recargado."
sleep 5

# Verificar si los servicios están en uso
echo "Verificando si los servicios están en uso..."
if systemctl is-active --quiet aria2 || systemctl is-active --quiet webui-aria2; then
    # Reiniciar los servicios si están en uso
    echo "Reiniciando los servicios Aria2 y WebUI Aria2..."
    systemctl restart aria2
    systemctl restart webui-aria2
    echo "Servicios reiniciados."
    sleep 5
fi

# Habilitar y empezar los servicios
echo "Habilitando y empezando los servicios..."
systemctl enable aria2
systemctl start aria2
systemctl enable webui-aria2
systemctl start webui-aria2

echo "Instalación completada: git, curl, nodejs, htop, aria2 instalados, repositorio clonado, directorios /etc/aria2 y /home/Disk creados, configuración de aria2 y servicios systemd actualizados. Servicios Aria2 y WebUI Aria2 habilitados y comenzados."

# Mensaje final
echo "Para acceder al Web UI de Aria2, abre tu navegador y visita tu IP en el puerto 8888. También, recuerda incluir el RPC si no has configurado tu el rpc secreto prederminadamente es SomethingSecure recuerda que es donde dice Enter the secret token (optional)"
