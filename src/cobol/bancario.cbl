       IDENTIFICATION                   DIVISION.       
       PROGRAM-ID. BANCARIO.                            
       AUTHOR. HUDSON HENRIQUE.                         
       ENVIRONMENT                      DIVISION.       
       CONFIGURATION                    SECTION.                               
       INPUT-OUTPUT                     SECTION.        
       FILE-CONTROL.                                    
       SELECT ARQ-CLIENTES ASSIGN TO UT-S-CLIENTES. 
       SELECT ARQ-MOVI     ASSIGN TO UT-S-MOVI.     
       SELECT ARQ-CLIATUAL ASSIGN TO UT-S-CLIATUAL. 
       SELECT ARQ-RELATORI ASSIGN TO UT-S-RELATORI. 
       SELECT ARQ-ERROS    ASSIGN TO UT-S-ERROS.    
      *-------------------------------------------------
       DATA                             DIVISION.       
       FILE                             SECTION.        
       FD  ARQ-CLIENTES                                 
       LABEL RECORDS ARE STANDARD                   
       BLOCK CONTAINS 0 RECORDS                     
       RECORD CONTAINS 44 CHARACTERS.               
       01  REG-CLIENTE-IN.                              
           05 CLI-ID-IN        PIC 9(05).               
           05 CLI-NOME-IN      PIC X(30).                 
           05 CLI-SALDO-IN     PIC 9(09).                 
      *-------------------------------------------------  
       FD  ARQ-MOVI                                       
       LABEL RECORDS ARE STANDARD                     
       BLOCK CONTAINS 0 RECORDS                       
       RECORD CONTAINS 20 CHARACTERS.                 
       01  REG-TRANSC-IN.                                 
           05 TRX-CLI-ID-IN    PIC 9(05).                 
           05 TRX-ID-IN        PIC 9(05).                 
           05 TRX-TIPO-IN      PIC X(01).                 
           05 TRX-VALOR-IN     PIC 9(09).                 
      *---------------------------------------------------
       FD  ARQ-CLIATUAL                                   
       LABEL RECORDS ARE STANDARD                     
       BLOCK CONTAINS 0 RECORDS                       
       RECORD CONTAINS 44 CHARACTERS.                 
       01  REG-CLIENTE-OUT.                               
           05 CLI-ID-OUT       PIC 9(05).                 
           05 CLI-NOME-OUT     PIC X(30).                 
           05 CLI-SALDO-OUT    PIC 9(09).                 
      *---------------------------------------------------
       FD  ARQ-RELATORI                                   
       LABEL RECORDS ARE OMITTED                           
       RECORD CONTAINS 80 CHARACTERS.                      
       01  REG-RELATORI        PIC X(80).                      
      *---------------------------------------------------     
       FD  ARQ-ERROS                                           
       LABEL RECORDS ARE OMITTED                           
       RECORD CONTAINS 80 CHARACTERS.                      
       01  REG-ERROS           PIC X(80).                      
      *------------------------------------------------------- 
       WORKING-STORAGE SECTION.                                
       01  WS-EOF-FLAGS.                                       
           05 WS-FIM-CLIENTES  PIC X(01) VALUE 'N'.            
           05 WS-FIM-TRANSAC   PIC X(01) VALUE 'N'.            
      *                                                        
       01  WS-CLIENTE-ATUAL.                                   
           05 WS-CLI-ID        PIC X(05) VALUE SPACES.         
           05 WS-CLI-NOME      PIC X(30) VALUE SPACES.         
           05 WS-CLI-SALDO     PIC 9(09) VALUE ZEROS.          
      *                                                        
       01  WS-TRANSAC-ATUAL.                                   
           05 WS-TRX-CLI-ID    PIC X(05) VALUE SPACES.         
           05 WS-TRX-ID        PIC X(05) VALUE SPACES.         
           05 WS-TRX-TIPO      PIC X(01) VALUE SPACES.         
           05 WS-TRX-VALOR     PIC 9(09) VALUE ZEROS.              
      *                                                            
       01  WS-TOTAIS.                                              
           05 WS-TOT-CLI-GERAL      PIC 9(06) VALUE ZEROS.         
           05 WS-TOT-TRX-GERAL      PIC 9(06) VALUE ZEROS.         
           05 WS-TOT-CRED-GERAL     PIC 9(06) VALUE ZEROS.         
           05 WS-TOT-DEB-GERAL      PIC 9(06) VALUE ZEROS.         
           05 WS-TOT-ERROS-GERAL    PIC 9(06) VALUE ZEROS.         
           05 WS-TOT-CRED-CLI       PIC 9(09) VALUE ZEROS.         
           05 WS-TOT-DEB-CLI        PIC 9(09) VALUE ZEROS.         
      *                                                            
       01  WS-LINHA-RELAT.                                         
           05 FILLER           PIC X(09) VALUE 'CLIENTE: '.        
           05 WS-REL-CLI-ID    PIC X(05).                          
           05 FILLER           PIC X(66) VALUE SPACES.             
      *                                                            
       01  WS-LINHA-CRED.                                          
           05 FILLER           PIC X(16) VALUE 'TOTAL CREDITOS: '. 
           05 WS-REL-CRED      PIC 9(09).                          
           05 FILLER           PIC X(55) VALUE SPACES.             
      *                                                            
       01  WS-LINHA-DEB.                                           
           05 FILLER           PIC X(15) VALUE 'TOTAL DEBITOS: '.  
           05 WS-REL-DEB       PIC 9(09).                             
           05 FILLER           PIC X(56) VALUE SPACES.                
      *                                                               
       01  WS-LINHA-ERRO.                                             
           05 FILLER           PIC X(06) VALUE 'ERRO: '.              
           05 WS-MSG-ERRO      PIC X(30) VALUE SPACES.                
           05 FILLER           PIC X(06) VALUE ' - ID '.              
           05 WS-ERRO-ID       PIC X(05) VALUE SPACES.                
           05 FILLER           PIC X(33) VALUE SPACES.                
      *                                                               
       01  WS-LINHA-SEPARADOR.                                        
           05 FILLER           PIC X(80) VALUE ALL '-'.               
      *                                                               
       01  WS-ESTAT-CABECALHO.                                        
           05 FILLER PIC X(20) VALUE '********************'.          
           05 FILLER PIC X(20) VALUE '********************'.          
           05 FILLER PIC X(40) VALUE SPACES.                          
      *                                                               
       01  WS-ESTAT-TITULO.                                           
           05 FILLER PIC X(29) VALUE 'ESTATISTICAS DE PROCESSAMENTO'. 
           05 FILLER PIC X(51) VALUE SPACES.                          
      *                                                               
       01  WS-ERRO-TITULO.                                            
           05 FILLER PIC X(28) VALUE 'RELATORIO DE INCONSISTENCIAS'.
           05 FILLER PIC X(52) VALUE SPACES.                        
      *                                                             
       01  WS-ESTAT-CLI.                                            
           05 FILLER PIC X(25) VALUE 'CLIENTES PROCESSADOS.....'.   
           05 FILLER PIC X(02) VALUE ': '.                          
           05 WS-EST-CLI-QTD PIC 9(06).                             
           05 FILLER PIC X(47) VALUE SPACES.                        
      *                                                             
       01  WS-ESTAT-TRX.                                            
           05 FILLER PIC X(25) VALUE 'TRANSACOES PROCESSADAS...'.   
           05 FILLER PIC X(02) VALUE ': '.                          
           05 WS-EST-TRX-QTD PIC 9(06).                             
           05 FILLER PIC X(47) VALUE SPACES.                        
      *                                                             
       01  WS-ESTAT-CRED.                                           
           05 FILLER PIC X(25) VALUE 'CREDITOS PROCESSADOS.....'.   
           05 FILLER PIC X(02) VALUE ': '.                          
           05 WS-EST-CRED-QTD PIC 9(06).                            
           05 FILLER PIC X(47) VALUE SPACES.                        
      *                                                             
       01  WS-ESTAT-DEB.                                            
           05 FILLER PIC X(25) VALUE 'DEBITOS PROCESSADOS......'.   
           05 FILLER PIC X(02) VALUE ': '.                            
           05 WS-EST-DEB-QTD PIC 9(06).                               
           05 FILLER PIC X(47) VALUE SPACES.                          
      *                                                               
       01  WS-ESTAT-ERROS.                                            
           05 FILLER PIC X(25) VALUE 'ERROS ENCONTRADOS........'.     
           05 FILLER PIC X(02) VALUE ': '.                            
           05 WS-EST-ERRO-QTD PIC 9(06).                              
           05 FILLER PIC X(47) VALUE SPACES.                          
      *                                                               
       01  WS-ESTAT-FIM.                                              
           05 FILLER PIC X(20) VALUE 'FIM DO PROCESSAMENTO'.          
           05 FILLER PIC X(60) VALUE SPACES.                          
      *-------------------------------------------------------------  
       PROCEDURE                        DIVISION.                     
       0000-PRINCIPAL.                                                
           PERFORM 1000-INICIALIZAR.                                  
           PERFORM 2000-PROCESSAR THRU 2000-FIM UNTIL                 
               WS-CLI-ID = HIGH-VALUES AND                            
               WS-TRX-CLI-ID = HIGH-VALUES.                           
           PERFORM 3000-FINALIZAR.                                    
           STOP RUN.                                                  
      *---------------------------------------------------------------
       1000-INICIALIZAR.                                               
           OPEN INPUT  ARQ-CLIENTES ARQ-MOVI                           
                OUTPUT ARQ-CLIATUAL ARQ-RELATORI ARQ-ERROS.            
           WRITE REG-ERROS FROM WS-ESTAT-CABECALHO.                    
           WRITE REG-ERROS FROM WS-ERRO-TITULO.                        
           WRITE REG-ERROS FROM WS-ESTAT-CABECALHO.                    
           PERFORM 1100-LER-CLIENTE.                                   
           PERFORM 1200-LER-TRANSAC.                                   
      *-------------------------------------------------------------   
       1100-LER-CLIENTE.                                               
           READ ARQ-CLIENTES INTO WS-CLIENTE-ATUAL                     
               AT END MOVE 'S' TO WS-FIM-CLIENTES.                     
           IF WS-FIM-CLIENTES = 'S'                                    
               MOVE HIGH-VALUES TO WS-CLI-ID                           
           ELSE                                                        
               MOVE ZEROS TO WS-TOT-CRED-CLI                           
               MOVE ZEROS TO WS-TOT-DEB-CLI.                           
      *-------------------------------------------------------------   
       1200-LER-TRANSAC.                                               
           READ ARQ-MOVI INTO WS-TRANSAC-ATUAL                     
               AT END MOVE 'S' TO WS-FIM-TRANSAC.                  
           IF WS-FIM-TRANSAC = 'S'                                 
               MOVE HIGH-VALUES TO WS-TRX-CLI-ID.                  
      *------------------------------------------------------------   
       2000-PROCESSAR.                                                
           IF WS-CLI-ID < WS-TRX-CLI-ID                               
            PERFORM 2100-FINALIZA-CLIENTE                          
            GO TO 2000-FIM.                                        
           IF WS-CLI-ID = WS-TRX-CLI-ID                               
            PERFORM 2200-TRATA-TRANSACAO                           
            GO TO 2000-FIM.                                        
           PERFORM 2300-ERRO-CLIENTE-INEXIST.                         
       2000-FIM.                                                      
           EXIT.                                                      
      *---------------------------------------------------------------
       2100-FINALIZA-CLIENTE.                                         
           MOVE WS-CLI-ID    TO CLI-ID-OUT.                           
           MOVE WS-CLI-NOME  TO CLI-NOME-OUT.                         
           MOVE WS-CLI-SALDO TO CLI-SALDO-OUT.                        
           WRITE REG-CLIENTE-OUT.                                     
      *                                                               
           MOVE WS-CLI-ID       TO WS-REL-CLI-ID.                     
           WRITE REG-RELATORI FROM WS-LINHA-RELAT.                    
           MOVE WS-TOT-CRED-CLI TO WS-REL-CRED.                       
           WRITE REG-RELATORI FROM WS-LINHA-CRED.                     
           MOVE WS-TOT-DEB-CLI  TO WS-REL-DEB.                        
           WRITE REG-RELATORI FROM WS-LINHA-DEB.                    
           WRITE REG-RELATORI FROM WS-LINHA-SEPARADOR.              
      *                                                             
           ADD 1 TO WS-TOT-CLI-GERAL.                               
           PERFORM 1100-LER-CLIENTE.                                
      *---------------------------------------------------------    
       2200-TRATA-TRANSACAO.                                        
           ADD 1 TO WS-TOT-TRX-GERAL.                               
      *                                                             
           IF WS-TRX-TIPO NOT = 'C' AND WS-TRX-TIPO NOT = 'D'       
               PERFORM 2240-ERRO-TIPO-INVALIDO                      
           ELSE                                                     
               IF WS-TRX-VALOR = ZEROS                              
                   PERFORM 2210-ERRO-VALOR-ZERADO                   
               ELSE                                                 
                   IF WS-TRX-TIPO = 'C'                             
                       PERFORM 2220-PROCESSA-CREDITO                
                   ELSE                                             
                       PERFORM 2230-PROCESSA-DEBITO.                
           PERFORM 1200-LER-TRANSAC.                                
      *----------------------------------------------------------   
       2210-ERRO-VALOR-ZERADO.                                      
           MOVE 'VALOR DE TRANSACAO INVALIDO' TO WS-MSG-ERRO.       
           MOVE WS-TRX-CLI-ID TO WS-ERRO-ID.                              
           WRITE REG-ERROS FROM WS-LINHA-ERRO.                            
           ADD 1 TO WS-TOT-ERROS-GERAL.                                   
      *---------------------------------------------------------------    
       2220-PROCESSA-CREDITO.                                             
           ADD WS-TRX-VALOR TO WS-CLI-SALDO.                              
           ADD WS-TRX-VALOR TO WS-TOT-CRED-CLI.                           
           ADD 1 TO WS-TOT-CRED-GERAL.                                    
      *----------------------------------------------------------------   
       2230-PROCESSA-DEBITO.                                              
           IF WS-CLI-SALDO < WS-TRX-VALOR                                 
               MOVE 'SALDO INSUFICIENTE' TO WS-MSG-ERRO                   
               MOVE WS-TRX-CLI-ID TO WS-ERRO-ID                           
               WRITE REG-ERROS FROM WS-LINHA-ERRO                         
               ADD 1 TO WS-TOT-ERROS-GERAL                                
           ELSE                                                           
               SUBTRACT WS-TRX-VALOR FROM WS-CLI-SALDO                    
               ADD WS-TRX-VALOR TO WS-TOT-DEB-CLI                         
               ADD 1 TO WS-TOT-DEB-GERAL.                                 
      *------------------------------------------------------------------ 
       2240-ERRO-TIPO-INVALIDO.                                           
           MOVE 'TIPO DE TRANSACAO INVALIDO' TO WS-MSG-ERRO.              
           MOVE WS-TRX-CLI-ID TO WS-ERRO-ID.                              
           WRITE REG-ERROS FROM WS-LINHA-ERRO.                        
           ADD 1 TO WS-TOT-ERROS-GERAL.                               
      *---------------------------------------------------------------
       2300-ERRO-CLIENTE-INEXIST.                                     
           ADD 1 TO WS-TOT-TRX-GERAL.                                 
           MOVE 'CLIENTE NAO ENCONTRADO' TO WS-MSG-ERRO.              
           MOVE WS-TRX-CLI-ID TO WS-ERRO-ID.                          
           WRITE REG-ERROS FROM WS-LINHA-ERRO.                        
           ADD 1 TO WS-TOT-ERROS-GERAL.                               
           PERFORM 1200-LER-TRANSAC.                                  
      *-----------------------------------------------------------    
       3000-FINALIZAR.                                                
           MOVE WS-TOT-CLI-GERAL   TO WS-EST-CLI-QTD.                 
           MOVE WS-TOT-TRX-GERAL   TO WS-EST-TRX-QTD.                 
           MOVE WS-TOT-CRED-GERAL  TO WS-EST-CRED-QTD.                
           MOVE WS-TOT-DEB-GERAL   TO WS-EST-DEB-QTD.                 
           MOVE WS-TOT-ERROS-GERAL TO WS-EST-ERRO-QTD.                
      *                                                               
           WRITE REG-RELATORI FROM WS-ESTAT-CABECALHO.                
           WRITE REG-RELATORI FROM WS-ESTAT-TITULO.                   
           WRITE REG-RELATORI FROM WS-ESTAT-CABECALHO.                
           WRITE REG-RELATORI FROM WS-ESTAT-CLI.                      
           WRITE REG-RELATORI FROM WS-ESTAT-TRX.                      
           WRITE REG-RELATORI FROM WS-ESTAT-CRED.               
           WRITE REG-RELATORI FROM WS-ESTAT-DEB.                
           WRITE REG-RELATORI FROM WS-ESTAT-ERROS.              
           WRITE REG-RELATORI FROM WS-ESTAT-FIM.                
      *                                                         
           CLOSE ARQ-CLIENTES ARQ-MOVI ARQ-CLIATUAL ARQ-RELATORI
                 ARQ-ERROS.                                         