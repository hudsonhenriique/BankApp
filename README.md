# Sistema Batch de Processamento de Transações Bancárias

![COBOL](https://img.shields.io/badge/COBOL-OS%2FVS_ANSI--74-blue)
![Mainframe](https://img.shields.io/badge/Mainframe-z%2FOS_MVS-lightgrey)
![JCL](https://img.shields.io/badge/JCL-Job_Control_Language-orange)

## Sobre o Projeto

Este projeto foi desenvolvido com o objetivo de simular o processamento diário de transações bancárias em um ambiente Mainframe. A proposta consiste em ler um arquivo de clientes e um arquivo de transações, aplicando créditos e débitos aos respectivos clientes e gerando relatórios com os resultados do processamento.

Para isso, foi implementada uma lógica de Match/Merge, técnica bastante utilizada em processamento batch, que permite comparar e processar simultaneamente dois arquivos ordenados pela mesma chave. Dessa forma, foi possível localizar os clientes correspondentes às transações, atualizar seus saldos e tratar situações de inconsistência durante a execução.

O desenvolvimento foi realizado em OS/VS COBOL (ANSI-74), respeitando as limitações e características da linguagem da época. O projeto permitiu praticar conceitos importantes como processamento de arquivos sequenciais, controle de fluxo, validação de dados, tratamento de erros e geração de relatórios em ambiente Mainframe.

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

Durante o desenvolvimento do projeto, um dos principais desafios foi entender e corrigir problemas de fluxo de execução característicos do COBOL ANSI-74. Como essa versão da linguagem não possui recursos mais modernos, como `END-IF` e `END-READ`, foi necessário ter bastante cuidado com a organização dos parágrafos e com o controle da lógica do programa.

Em alguns testes, identifiquei um problema conhecido como *Fall-Through*, em que uma mesma transação acabava passando por rotinas que não deveriam ser executadas, gerando resultados incorretos. Após analisar os logs e acompanhar a execução passo a passo utilizando comandos `DISPLAY`, foi possível localizar a origem do problema e ajustar a estrutura do processamento utilizando `PERFORM ... THRU`.

Esse processo de investigação foi importante para garantir que cada transação fosse tratada corretamente, que os acumuladores fossem atualizados apenas quando necessário e que os relatórios finais apresentassem informações consistentes. Além de atender aos requisitos do projeto, a experiência proporcionou um aprendizado prático sobre depuração e controle de fluxo em ambientes Mainframe utilizando COBOL clássico.

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
