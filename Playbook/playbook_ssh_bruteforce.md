# Playbook SOC - Tentativas de bruteforce por ssh

## Descrição
Este Playbook define o protocolo de identificação e resposta a tentativas de bruteforce na autenticação ssh

## Detecção (detect_ssh_bruteforce.sh)
- Log monitorado: /var/log/auth.log
- Eventos observados
    - Failed password
    - Connection closed by authenticating user
- Critério de alerta
    - Mais de 3 tentativas
    - Mesmo ip
    - Intervalo menor que 2min

## Análise (soc_dashboard.sh)
- Verificar IP de origem
    - Interno ou externo (NAT/LAB)
    - Intervalo de tempo
- Verificar usuários tentados
- Confirmar recorrência

## Resposta inicial
- Classificar como tentativa de bruteforce
- Registrar incidente no dashboard

## Contenção
- Bloquear IP via fail2ban
- Validar bloqueio

## Erradicação
- Aplicar hardening no SSH:
    - Desabilitar login root
    - Reduzir tentativas

## Mapeamento Mitre Attack
- T1110 Bruteforce