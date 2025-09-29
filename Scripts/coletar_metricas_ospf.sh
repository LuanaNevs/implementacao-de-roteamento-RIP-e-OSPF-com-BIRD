#!/bin/bash
ARQUIVO="Resultado - $(hostname) - ospf - $(date +%Y%m%d_%H%M%S).txt"

{
echo "=== METRICAS COMPLETAS OSPF ==="
date
echo "Roteador: $(hostname)"
echo ""

echo "1. STATUS DO BIRD:"
sudo birdc show status
echo ""

echo "2. PROTOCOLOS ATIVOS:"
sudo birdc show protocols all
echo ""

echo "3. VIZINHOS OSPF:"
sudo birdc show ospf neighbors
echo ""

echo "4. ESTADO OSPF:"
sudo birdc show ospf state
echo ""

echo "5. TOPOLOGIA OSPF:"
sudo birdc show ospf topology | head -20
echo ""

echo "6. INTERFACES OSPF:"
sudo birdc show ospf interfaces
echo ""

echo "7. ROTAS OSPF:"
sudo birdc show route protocol ospf1
echo ""

echo "8. TABELA DE ROTAS COMPLETA:"
sudo birdc show route count
sudo birdc show route | head -15
echo ""

echo "9. ESTATISTICAS DE REDE:"
ip -s link show | head -25
echo ""

echo "10. INFORMACOES DAS INTERFACES:"
ip addr show | grep -E "(eth|enp|emp)" | head -10
echo ""

echo "=== METRICAS CONCLUIDAS ==="
} | tee "$ARQUIVO"

echo "Arquivo salvo: $ARQUIVO"