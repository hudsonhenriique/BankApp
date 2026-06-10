//CRIAARQ  JOB (PROG2),'CRIA ARQUIVOS',CLASS=A,MSGCLASS=X,     
//             MSGLEVEL=(1,1),NOTIFY=HERC01                    
//*---------------------------------------------------------   
//CLEANUP  EXEC PGM=IEFBR14                                    
//DD1      DD DSN=HERC01.CLIENTES.TXT,DISP=(MOD,DELETE,DELETE),
//            UNIT=SYSDA,SPACE=(TRK,(0,0))                     
//DD2      DD DSN=HERC01.TRANSAC.TXT,DISP=(MOD,DELETE,DELETE), 
//            UNIT=SYSDA,SPACE=(TRK,(0,0))                     
//*---------------------------------------------------------   
//STEP01   EXEC PGM=IEBGENER                                   
//SYSPRINT DD SYSOUT=*                                         
//SYSUT2   DD DSN=HERC01.CLIENTES.TXT,DISP=(NEW,CATLG,DELETE), 
//            SPACE=(TRK,(1,1)),UNIT=SYSDA,                    
//            DCB=(LRECL=44,BLKSIZE=440,RECFM=FB)              
//SYSUT1   DD *                                                
00123JOAO SILVA                    000010000                   
00456MARIA SOUZA                   000025000                   
00789CARLOS PEREIRA                000005000                   
/*                                                             
//SYSIN    DD *                                                
  GENERATE MAXFLDS=1                                           
  RECORD FIELD=(44,1,,1)                                       
/*                                                             
//*---------------------------------------------------------   
//STEP02   EXEC PGM=IEBGENER                                 
//SYSPRINT DD SYSOUT=*                                       
//SYSUT2   DD DSN=HERC01.TRANSAC.TXT,DISP=(NEW,CATLG,DELETE),
//            SPACE=(TRK,(1,1)),UNIT=SYSDA,                  
//            DCB=(LRECL=20,BLKSIZE=200,RECFM=FB)            
//SYSUT1   DD *                                              
0012300010C000000500                                         
0012300020D000000200                                         
0012300030C000001000                                         
0012300040X000000500                                         
0012300050C000000000                                         
0045600060C000005000                                         
0045600070D000001000                                         
0078900080C000002000                                         
0078900090D000000500                                         
0078900100D000008000                                         
9999900110C000000500                                         
/*                                                           
//SYSIN    DD *                                              
  GENERATE MAXFLDS=1                                         
  RECORD FIELD=(20,1,,1)                                     
/*                                                           
//                                                           