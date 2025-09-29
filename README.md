# Projeto de Roteamento com BIRD: OSPF e RIP

## Descrição

Este projeto implementa e analisa o desempenho de dois protocolos de roteamento, OSPF e RIP, utilizando a plataforma BIRD no Ubuntu. A rede foi configurada em máquinas virtuais (VMs) no VirtualBox, e métricas de desempenho, como a quantidade de pacotes, rotas e tráfego, foram coletadas e analisadas. O objetivo é estudar a performance de ambos os protocolos em uma rede virtualizada.

## Requisitos

- **Sistema Operacional**: Ubuntu
- **Plataforma de Roteamento**: BIRD
- **Protocolos de Roteamento**: OSPF e RIP
- **Máquinas Virtuais**: VirtualBox
- **Dependências**: 
  - BIRD
  - Netplan (para configuração de rede)
  - Scripts de coleta de métricas (OSPF e RIP)

## Estrutura do Projeto

O projeto está organizado nas seguintes pastas:

- **Script**: Contém scripts auxiliares para coletar métricas de desempenho dos protocolos OSPF e RIP.
  - `coletar_metricas_ospf.sh`: Script para coletar métricas do protocolo OSPF.
  - `coletar_metricas_rip.sh`: Script para coletar métricas do protocolo RIP.
  - `alternar_protocolo.sh`: Script para alternar entre os protocolos OSPF e RIP no BIRD.
  
- **Config**: Contém arquivos de configuração para a rede e protocolos de roteamento.
  - `netplan`: Arquivo de configuração para as interfaces de rede.
  - `ospf`: Arquivo de configuração do protocolo OSPF no BIRD.
  - `rip`: Arquivo de configuração do protocolo RIP no BIRD.

## Passo a Passo

### Passo 1: Instalar o BIRD

1. Atualize os repositórios e instale o BIRD em todas as VMs:
   ```bash
   sudo apt update
   sudo apt install bird
   ```

### Passo 2: Configurar as Interfaces de Rede

1. **Configuração do Netplan**:
   - O arquivo `netplan` deve ser configurado para cada VM. Exemplo de configuração em `/etc/netplan/01-netcfg.yaml`:
     ```yaml
     network:
       version: 2
       renderer: networkd
       ethernets:
         enp0s3:
           dhcp4: false
           addresses:
             - 192.168.12.1/24
     ```
   - Após editar o arquivo, aplique as alterações com:
     ```bash
     sudo netplan apply
     ```

### Passo 3: Habilitar o Roteamento no Ubuntu

1. Para habilitar o roteamento de pacotes IP entre interfaces, execute o comando abaixo:
   ```bash
   echo 'net.ipv4.ip_forward=1' | sudo tee -a /etc/sysctl.conf
   ```

2. Após adicionar a configuração, aplique as mudanças imediatamente com:
   ```bash
   sudo sysctl -p
   ```

### Passo 4: Configuração do Protocolo OSPF

1. **Configuração no BIRD**:
   - O arquivo `ospf` contém a configuração para o protocolo OSPF.
   - Exemplo de configuração:
     ```bash
     router id 192.168.12.1;

     protocol ospf {
         network 192.168.12.0/24;
         area 0.0.0.0;
         hello 10;
         dead 40;
     }
     ```
   
2. **Reinicie o BIRD**:
   ```bash
   sudo systemctl restart bird
   ```

3. **Verifique o Status do OSPF**:
   ```bash
   birdc show ospf
   ```

4. **Testes de Conectividade**:
   - Teste a conectividade entre os roteadores utilizando `ping` ou `traceroute`:
     ```bash
     traceroute 192.168.23.1
     ```

### Passo 5: Configuração do Protocolo RIP

1. **Configuração no BIRD**:
   - O arquivo `rip` contém a configuração para o protocolo RIP.
   - Exemplo de configuração:
     ```bash
     protocol rip {
         version 2;
         network 192.168.12.0/24;
         network 192.168.23.0/24;
     }
     ```

2. **Reinicie o BIRD novamente**:
   ```bash
   sudo systemctl restart bird
   ```

3. **Verifique o Status do RIP**:
   ```bash
   birdc show rip
   ```

4. **Testes de Conectividade**:
   - Teste a conectividade entre os roteadores, assim como foi feito no OSPF:
     ```bash
     traceroute 192.168.23.1
     ```

### Passo 6: Coletar Métricas

1. **Scripts para Coleta de Métricas**:
   - Utilize os scripts `coletar_metricas_ospf.sh` e `coletar_metricas_rip.sh` para coletar métricas de desempenho, como pacotes enviados, recebidos, e rejeitados.
   - Exemplos de como rodar os scripts:
     ```bash
     ./coletar_metricas_ospf.sh
     ./coletar_metricas_rip.sh
     ```

### Passo 7: Alternar Protocolos com `alternar_protocolo.sh`

O script `alternar_protocolo.sh` permite alternar facilmente entre os protocolos OSPF e RIP no **BIRD**. 

#### Como utilizar:
- **Para configurar o protocolo OSPF**:
  ```bash
  ./alternar_protocolo.sh ospf
  ```

- **Para configurar o protocolo RIP**:
  ```bash
  ./alternar_protocolo.sh rip
  ```

- **Para verificar o status atual do protocolo em uso**:
  ```bash
  ./alternar_protocolo.sh status
  ```

Este script faz a cópia da configuração do protocolo desejado (OSPF ou RIP) para o arquivo principal de configuração do **BIRD** (`/etc/bird/bird.conf`), reinicia o serviço **BIRD** e exibe o status do serviço.

### Passo 8: Análise e Resultados

- Os resultados coletados pelos scripts podem ser analisados para comparar o desempenho dos protocolos OSPF e RIP, incluindo métricas como:
  - Pacotes enviados/recebidos
  - Vizinhanças estabelecidas
  - Tempo de transmissão

## Links de Acesso
- [Apresentação no Canva](https://www.canva.com/design/DAG0SYnyoZ8/BE3eoIOqBFimoGAPLzdjWg/view?utm_content=DAG0SYnyoZ8&utm_campaign=designshare&utm_medium=link2&utm_source=uniquelinks&utlId=h181874910c)
- [Video Simulação](https://drive.google.com/drive/folders/1GdOK8ik1i9xf2bh808aHjiZX8QxrpfpE?usp=drive_link)
- [Resultados e Métricas](https://drive.google.com/drive/folders/1_GjNphvkBFNCWCebZhgsAJ2kV-DymHrc?usp=drive_link)

