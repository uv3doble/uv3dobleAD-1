#!/usr/bin/env bash

# Colores para salida de terminal
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}====================================================${NC}"
echo -e "${GREEN}   Active Directory Audit Lab - Script de Despliegue${NC}"
echo -e "${BLUE}====================================================${NC}"

# 1. Comprobación de prerrequisitos
echo -e "\n${YELLOW}[*] Comprobando requisitos en el sistema...${NC}"

# Comprobar VirtualBox
if ! command -v VBoxManage &> /dev/null; then
    echo -e "${RED}[-] Error: VirtualBox no está instalado.${NC}"
    exit 1
else
    echo -e "${GREEN}[+] VirtualBox instalado: $(VBoxManage --version)${NC}"
fi

# Comprobar Vagrant
if ! command -v vagrant &> /dev/null; then
    echo -e "${RED}[-] Error: Vagrant no está instalado.${NC}"
    exit 1
else
    echo -e "${GREEN}[+] Vagrant instalado: $(vagrant --version)${NC}"
fi

# Comprobar Ansible
if ! command -v ansible &> /dev/null; then
    echo -e "${RED}[-] Error: Ansible no está instalado.${NC}"
    exit 1
else
    echo -e "${GREEN}[+] Ansible instalado: $(ansible --version | head -n 1)${NC}"
fi

# 2. Desplegar Máquinas Virtuales con Vagrant
echo -e "\n${YELLOW}[*] Iniciando el despliegue de máquinas virtuales con Vagrant...${NC}"
echo -e "${BLUE}[i] Nota: Esto puede tardar varios minutos la primera vez mientras se descargan las imágenes.${NC}"

vagrant up
if [ $? -ne 0 ]; then
    echo -e "${RED}[-] Error en vagrant up. Abortando.${NC}"
    exit 1
fi
echo -e "${GREEN}[+] Máquinas virtuales creadas e iniciadas con éxito.${NC}"

# 3. Comprobar conexiones WinRM
echo -e "\n${YELLOW}[*] Probando conexiones WinRM con Ansible...${NC}"
ansible -i hosts.ini all -m win_ping
if [ $? -ne 0 ]; then
    echo -e "${RED}[-] Error al conectar con las VMs mediante WinRM. Revisa el estado de red.${NC}"
    exit 1
fi
echo -e "${GREEN}[+] Conectividad WinRM verificada.${NC}"

# 4. Ejecutar el Aprovisionamiento de Ansible
echo -e "\n${YELLOW}[*] Ejecutando el playbook de Ansible para configurar Active Directory y vulnerabilidades...${NC}"
ansible-playbook -i hosts.ini site.yml
if [ $? -ne 0 ]; then
    echo -e "${RED}[-] Error durante el aprovisionamiento de Ansible.${NC}"
    exit 1
fi

echo -e "\n${GREEN}====================================================${NC}"
echo -e "${GREEN}   ¡Despliegue Completado de forma Exitosa!${NC}"
echo -e "${BLUE}====================================================${NC}"
echo -e "${YELLOW}Detalles del Laboratorio:${NC}"
echo -e " - dc01-prod: 10.10.10.10 (corp.local)"
echo -e " - dc02-dev-tree: 10.10.10.11 / 10.10.20.11 (dev-internal.local)"
echo -e " - ws01-prod: 10.10.10.20 (Miembro de corp.local)"
echo -e " - srv01-apps: 10.10.20.30 (Miembro de corp.local)"
echo -e "\nPara conectar gráficamente, abre VirtualBox y haz doble clic en la máquina deseada."
echo -e "Lee el archivo README.md para más información sobre las vulnerabilidades."
