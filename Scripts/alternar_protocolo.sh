#!/bin/bash

echo "=== ALTERNADOR DE PROTOCOLOS BIRD ==="
echo "Hostname: $(hostname)"
echo ""

if [ "$1" == "ospf" ]; then
    echo "Configurando OSPF..."
    sudo cp /etc/bird/bird_ospf.conf /etc/bird/bird.conf
    echo "Configuracao OSPF aplicada"
    
elif [ "$1" == "rip" ]; then
    echo "Configurando RIP..."
    sudo cp /etc/bird/bird_rip.conf /etc/bird/bird.conf
    echo "Configuracao RIP aplicada"
    
elif [ "$1" == "status" ]; then
    echo "Status atual:"
    sudo birdc show protocols 2>/dev/null | grep -E "(OSPF|RIP)" || echo "BIRD nao esta rodando"
    exit 0
    
else
    echo "Uso: alternar_protocolo.sh [ospf|rip|status]"
    echo "  ospf   - Configurar protocolo OSPF"
    echo "  rip    - Configurar protocolo RIP" 
    echo "  status - Ver protocolo atual"
    exit 1
fi

echo "Reiniciando BIRD..."
sudo systemctl restart bird

sleep 3

echo "Verificando status..."
sudo systemctl status bird --no-pager -l

echo "Protocolo $1 configurado com sucesso!"
echo "Para ver detalhes: sudo birdc show protocols"

