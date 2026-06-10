//HERC01EX JOB (COBOL),'EXECUTA BANCARIO',CLASS=A,MSGCLASS=H,         
//             MSGLEVEL=(1,1),NOTIFY=HERC01                           
//* EXECUTA O PROGRAMA BANCARIO USANDO OS ARQUIVOS CRIADOS
//SORTCLI  EXEC PGM=SORT                                              
//SORTLIB  DD DSN=SYS1.SORTLIB,DISP=SHR                               
//SYSOUT   DD SYSOUT=*                                                
//SORTIN   DD DSN=HERC01.CLIENTES.TXT,DISP=SHR                        
//SORTOUT  DD DSN=&&CLISORT,DISP=(NEW,PASS),UNIT=SYSDA,               
//            SPACE=(TRK,(1,1)),DCB=(LRECL=44,BLKSIZE=440,RECFM=FB)   
//SYSIN    DD *                                                       
  SORT FIELDS=(1,5,CH,A)                                              
/*                                                                    
//*  ORDENA TRANSACOES                                       
//SORTTRX  EXEC PGM=SORT                                              
//SORTLIB  DD DSN=SYS1.SORTLIB,DISP=SHR                               
//SYSOUT   DD SYSOUT=*                                                
//SORTIN   DD DSN=HERC01.TRANSAC.TXT,DISP=SHR                         
//SORTOUT  DD DSN=&&TRXSORT,DISP=(NEW,PASS),UNIT=SYSDA,               
//            SPACE=(TRK,(1,1)),DCB=(LRECL=20,BLKSIZE=200,RECFM=FB)   
//SYSIN    DD *                                                       
  SORT FIELDS=(1,5,CH,A)                                              
/*                                                                    
//* EXECUTAR O PROGRAMA                            
//GO       EXEC PGM=BANCARIO                                          
//STEPLIB  DD DSN=HERC01.PRIVLIB.LOAD,DISP=SHR                        
//CLIENTES DD DSN=&&CLISORT,DISP=(OLD,DELETE)                         
//MOVI     DD DSN=&&TRXSORT,DISP=(OLD,DELETE)                         
//CLIATUAL DD SYSOUT=*                                                
//RELATORI DD SYSOUT=*                                                
//ERROS    DD SYSOUT=*                                                
//SYSOUT   DD SYSOUT=*                                                
//SYSUDUMP DD SYSOUT=*                                                