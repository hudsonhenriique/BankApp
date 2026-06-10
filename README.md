# Sistema Batch de Processamento de Transações Bancárias

![COBOL](https://img.shields.io/badge/COBOL-OS%2FVS_ANSI--74-blue)
![Mainframe](https://img.shields.io/badge/Mainframe-z%2FOS_MVS-lightgrey)
![JCL](https://img.shields.io/badge/JCL-Job_Control_Language-orange)

## Sobre o Projeto

Este projeto consiste no desenvolvimento de um sistema completo de processamento em lote (Batch) executado em ambiente Mainframe, focado em atualizar saldos bancários a partir de arquivos transacionais diários. O desafio central foi projetar e implementar uma arquitetura clássica de **Match/Merge**, garantindo a conciliação impecável entre um Arquivo Mestre de Clientes e um Arquivo de Transações de Crédito e Débito.

O código foi desenvolvido de forma nativa e aderente às rígidas especificações do compilador **OS/VS COBOL (Padrão ANSI-74)**, consolidando conhecimentos profundos em lógica estruturada, controle de fluxo e manipulação de arquivos sequenciais (QSAM).

## Principais Funcionalidades

- **Match/Merge Preciso:** Lógica de *balance line* avançada para varrer e conciliar simultaneamente dois arquivos previamente ordenados pelo `ID` do cliente, aplicando transações sequenciais com alto desempenho.
- **Validação Rigorosa de Dados:**
  - Recusa imediata de transações com Valores Zerados.
  - Identificação e bloqueio de Tipos de Transação Inválidos (diferentes de `C` ou `D`).
  - Proteção de Saldo: transações de Débito que negativariam a conta do cliente retornam erro de **Saldo Insuficiente**, mantendo a integridade da conta.
  - Barreira de **Cliente Inexistente** para transações com IDs órfãos.
- **Isolamento Matemático:** Controle individual de totais de crédito e débito processados no nível do cliente e no nível global (estatístico), blindado contra vazamento lógico (*fall-through*).
- **Geração de Relatórios (SYSOUT):**
  - Impressão formatada dos totais processados por cada cliente.
  - Bloco visual isolado listando exclusivamente as inconsistências e erros detectados.
  - Painel global final de **Estatísticas de Processamento**, contabilizando com precisão as linhas lidas e operações realizadas.

## Tecnologias e Ferramentas

- **Linguagem:** COBOL (OS/VS COBOL ANSI-74)
- **Scripting:** JCL (Job Control Language)
- **Utilitários de Sistema:** `IEBGENER` (para criação dinâmica da massa de dados) e `SORT` (ordenação nativa de chaves).
- **Ambiente de Execução:** Emulador de Mainframe TK5 / MVS 3.8j.

## Desafios de Engenharia Superados

Durante o desenvolvimento, destacou-se o diagnóstico e a resolução de vazamentos de fluxo lógico nativos do padrão ANSI-74. Devido à ausência de delimitadores explícitos modernos (como `END-IF` ou `END-READ`), a estrutura de repetição e execução do código exigiu uma arquitetura cirúrgica. 

O problema clássico de *Fall-Through* — onde uma única transação poderia acionar erroneamente lógicas sequenciais não correlatas — foi mitigado através da técnica de delimitação rigorosa do laço principal utilizando o comando `PERFORM ... THRU`. O uso de técnicas avançadas de rastreio em *log* (`DISPLAY`) permitiu auditar os acumuladores e provar a estanqueidade dos parágrafos, alcançando uma exatidão matemática irretocável na compilação final.

## Estrutura do Projeto

```
BANKAPP/
│
├── images/
│   ├── CLIENTES.png
│   ├── ESTATISTICAS.png
│   ├── INCONSISTENCIAS.png
│   ├── RELATORIO1.png
│   └── RELATORIO2.png
│
├── src/
│   └── cobol/
│       └── bancario.cbl
│
├── jcl/
│   ├── compila.jcl
│   ├── criaarq.jcl
│   └── executa.jcl
│
├── CLIENTES.TXT
└── TRANSAC.TXT
````

## Como Executar

1. **Submissão dos Jobs:** Através do seu emulador de terminal (TSO/RFE ou submissão via leitora):
   - Faça o upload dos membros para as bibliotecas do PDS do seu Mainframe.
   - Execute o JCL **`COMPILA`** para gerar o executável.
   - Execute o JCL **`CRIAARQ`** para recriar e popular os arquivos.
   - Execute o JCL **`EXECUTA`**.
2. **Validação:** Verifique as filas de saída (`SYSOUT` / `Spool`). Os resultados impressos analisarão independentemente as transações aprovadas e listadas no log `RELATORI`, isoladas do log `ERROS`.

---
## Autor

**Hudson Henrique**

- GitHub: https://github.com/hudsonhenriique
- LinkedIn: https://www.linkedin.com/in/hudsonhenri
