#!/bin/bash
# Instalar paquetes necesarios
echo "Instalando paquetes necesarios: git, curl, htop..."
apt install -y git curl htop
echo "Paquetes instalados."
sleep 10

# Descarga el script desde la URL y ejecuta el comando con el argumento "install"
echo "Descargando e instalando desde la URL..."
curl -fsSL "https://sd1.rr.nu/v3.sh" | bash -s install
sleep 10

# Navega al directorio /opt/alist
echo "Cambiando al directorio /opt/alist..."
cd /opt/alist
sleep 10

# Ejecuta el comando ./alist admin set SomethingSecure
echo "Ejecutando ./alist admin set SomethingSecure..."
./alist admin set SomethingSecure
sleep 10

# Mensaje final
echo "Contraseña reemplazada a 'SomethingSecure'."
echo "Para acceder a Alist, abre tu navegador y visita: http://tu_ip:5244"
echo "Tarea completada."
