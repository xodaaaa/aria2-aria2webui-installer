#!/bin/bash

# Actualizar el sistema
echo "Actualizando el sistema..."
apt-get update
apt-get upgrade -y

# Instalar qbittorrent
echo "Instalando qBittorrent..."
apt-get install -y qbittorrent

# Instalar qbittorrent-nox
echo "Instalando qBittorrent-nox..."
apt-get install -y qbittorrent-nox

# Ejecutar qbittorrent-nox para aceptar los términos y condiciones
echo "Ejecutando qBittorrent-nox para aceptar los términos y condiciones..."
qbittorrent-nox
echo "Presiona cualquier tecla para continuar una vez que hayas aceptado los términos y condiciones y presionado Ctrl+C..."
read -n 1 -s

# Crear el grupo y el usuario para qbittorrent-nox
echo "Creando grupo y usuario para qBittorrent-nox..."
export PATH="$PATH:/sbin:/usr/sbin:usr/local/sbin"
addgroup --system qbittorrent-nox
adduser --system --no-create-home --ingroup qbittorrent-nox qbittorrent-nox

# Agregar usuario al grupo qbittorrent-nox
echo "Agregando usuario al grupo qbittorrent-nox..."
adduser a-wa-a qbittorrent-nox

# Crear el servicio
echo "Creando el servicio..."
cat <<EOF > /etc/systemd/system/qbittorrent-nox.service
[Unit]
Description=qBittorrent Command Line Client
After=network.target

[Service]
Type=forking
User=root
Group=qbittorrent-nox
UMask=007
ExecStart=/usr/bin/qbittorrent-nox -d --webui-port=8080
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Recargar daemon de systemd
echo "Recargando daemon de systemd..."
systemctl daemon-reload

# Iniciar el servicio
echo "Iniciando el servicio..."
systemctl start qbittorrent-nox

# Habilitar el servicio para que se inicie en el arranque
echo "Habilitando el servicio para iniciar en el arranque..."
systemctl enable qbittorrent-nox

# Comprobar si el servicio se está ejecutando correctamente
echo "Comprobando el estado del servicio..."
if systemctl is-active --quiet qbittorrent-nox; then
    echo "El servicio está en ejecución."
else
    echo "El servicio no se está ejecutando correctamente."
fi
