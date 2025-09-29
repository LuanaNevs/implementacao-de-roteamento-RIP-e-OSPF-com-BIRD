#!/bin/bash
ARQUIVO="Resultado - $(hostname) - rip - $(date +%Y%m%d_%H%M%S).txt"

{
echo "=== METRICAS COMPLETAS RIP ==="
date
echo "Roteador: $(hostname)"
echo ""

echo "1. STATUS DO BIRD:"
sudo birdc show status
echo ""

echo "2. PROTOCOLOS ATIVOS:"
sudo birdc show protocols all
echo ""

echo "3. VIZINHOS RIP:"
sudo birdc show rip neighbors
echo ""

echo "4. ESTATISTICAS RIP:"
sudo birdc show protocols all rip1
echo ""

echo "5. ROTAS RIP:"
sudo birdc show route protocol rip1
echo ""

echo "6. TABELA DE ROTAS COMPLETA:"
sudo birdc show route count
sudo birdc show route | head -15
echo ""

echo "7. ESTATISTICAS DE REDE:"
ip -s link show | head -25
echo ""

echo "8. INFORMACOES DAS INTERFACES:"
ip addr show | grep -E "(eth|enp|emp)" | head -10
echo ""

echo "=== METRICAS RIP CONCLUIDAS ==="
} | tee "$ARQUIVO"

echo "Arquivo salvo: $ARQUIVO"