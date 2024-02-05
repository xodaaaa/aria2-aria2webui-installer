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
sleep 10

# Instalar paquetes necesarios
echo "Instalando paquetes necesarios: git, curl, nodejs, htop, aria2..."
apt install -y git curl nodejs htop aria2
echo "Paquetes instalados."
sleep 10

# Clonar el repositorio webui-aria2 desde GitHub
echo "Clonando el repositorio webui-aria2 desde GitHub..."
git clone https://github.com/ziahamza/webui-aria2.git
echo "Repositorio clonado."
sleep 10

# Crear directorios necesarios
echo "Creando directorios necesarios: /etc/aria2, /Disk..."
mkdir /etc/aria2 -p
mkdir /Disk
echo "Directorios creados."
sleep 10

# Editar el archivo aria2.conf
echo "Editando el archivo aria2.conf..."
echo "dir=/root/Disk
enable-rpc=true
rpc-allow-origin-all=true
rpc-listen-all=true
rpc-listen-port=6800
rpc-secret=SomethingSecure" > /etc/aria2/aria2.conf
echo "Configuración de aria2 actualizada."
sleep 10

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
sleep 10

# Editar el archivo webui-aria2.service
echo "Editando el archivo webui-aria2.service..."
echo "[Unit]
Description=WebUI Aria2 Service
After=network.target

[Service]
ExecStart=/usr/bin/node /root/webui-aria2/node-server.js
WorkingDirectory=/root/webui-aria2
Restart=always
User=root

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/webui-aria2.service
echo "Archivo de servicio WebUI Aria2 actualizado."
sleep 10

# Recargar systemd para aplicar los cambios
echo "Recargando systemd para aplicar los cambios..."
systemctl daemon-reload
echo "Systemd recargado."
sleep 10

# Verificar si los servicios están en uso
echo "Verificando si los servicios están en uso..."
if systemctl is-active --quiet aria2 || systemctl is-active --quiet webui-aria2; then
    # Reiniciar los servicios si están en uso
    echo "Reiniciando los servicios Aria2 y WebUI Aria2..."
    systemctl restart aria2
    systemctl restart webui-aria2
    echo "Servicios reiniciados."
    sleep 10
fi

# Habilitar y empezar los servicios
echo "Habilitando y empezando los servicios..."
systemctl enable aria2
systemctl start aria2
systemctl enable webui-aria2
systemctl start webui-aria2

echo "Instalación completada: git, curl, nodejs, htop, aria2 instalados, repositorio clonado, directorios /etc/aria2 y /Disk creados, configuración de aria2 y servicios systemd actualizados. Servicios Aria2 y WebUI Aria2 habilitados y comenzados."

# Mensaje final
echo "Para acceder al Web UI de Aria2, abre tu navegador y visita tu IP en el puerto 8888. También, recuerda incluir el RPC si no has configurado tu el rpc secreto prederminadamente es SomethingSecure recuerda que es donde dice Enter the secret token (optional)"
