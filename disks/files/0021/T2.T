351� � 
         	      P   P  P  FQ � �   � L                               A       I       P       K       J       B       �     @ c E | P � ` � ��                                                                                            L
NEXT I
*
40 STOP
50 ESEG 0
60 END

                                                                                                                                                                                                                  NE LETTRES DE A a J, CHIFFRES DE 0 a 9",TABV(2)
*
FOR I=65 TO 74
L=GENER(80,A)
PRINT=2: L
NEXT I
*
FOR I=48 TO 57
L=GENER(80,A)
PRINT=2:L
NEXT I
*
PRINT=2:TABV(2),"TEST SURIMPRESSION :",TABV(1)
40 P=GENER(70,"O")
PRINT=2:P
P=GENER(70,"*")
PRINT=2:TAB(1),P,TABV(1)
*
I=15
50 PRINT=2:TABV(1),"PASSAGE EN COMPRESSE : ", A ,TABV(1)
FOR J=1 TO 10
FOR I=32 TO 127
PRINT=2 : A
NEXT I
*
60 PRINT=2:TABV(1)
NEXT J
*
I=0
B=GENER(256,A)
PRINT=2:"IMPRESSION BUFFER PLUS DE 2K",TABV(1),"DEBUT=",TABV(1)
FOR J=1 TO 8
PRINT=2: J , B
NEXT J
PRINT=2:TABV(1),"FIN DE BUFFER."
*
I=18
70 PRINT=2: TABV(2), A ,"FIN DU TEST IMPRIMANTE",PAGE
*
A="O"
100 ASK=1:CLEAR,"RECOMMENCER ? O/N "=A
IF A = "O" GOTO 10
STOP
*
ESEG 0
*
END
NDG 0 "O" GOTO 10ECOMMENCER ? O/N "=A                                                                                                                                                                                                                          
              O/N): "=(A),P
IF P="O" GOTO 15
IF P="N" GOTO 15
GOTO 13
*
15 ASK=1:CLEAR,"MODE ESCLAVE ? (O/N):"=(A),A
IF A="O" GOTO 16
IF A="N" GOTO 10
GOTO 15
*
16 C1= C1 + 32 ; AJOUTE OPTION RAU=ESCLAV
GOTO 10
*
20 B1=SPACE(256) ; CLEARBUFFERS
   B2=SPACE(256)
*
30 REMOTE=2:32,E   ; DECONNECTION ET RAZ
GOTO 35
*
32 IF E<> 83 GOTO 8000 ; DEJA DECONNECTE
*
*
*
35 IF A = "N" GOTO 36
*
PRINT=1:CLEAR,"***REPONSE-AUTO.ATTENDRE L'APPEL"
GOTO 40
*
36 PRINT=1:CLEAR,BELL,"***ETABLIR LA CONNECTION...'TD'",E  ; VISUERR
*
40 REMOTE=C1:42,E ; CONNECTION SELON MODE
GOTO 45
*
42 IF E=97 GOTO 36 ; MODEM NON PRET
44 IF E <> 84 GOTO 8000 ; NON CONNECTE
45 PRINT=1:CLEAR,"*** CONNEXION ETABLIE ***"
*
46 IF M="R" GOTO 100 ; RECEPTION
.
50 PRINT=N:TABV(1),"DEBUT EMISSION"
*
J=0
IF L=2 GOTO 52
N1=S1 ; RECUPERE EOD
FOR I=1 TO N1
B1=S2(I) ;  LECTURE ENREG DE 80
GOTO 55
*
52 N1=T1
FOR I= 1 TO N1
B1= T3(I) ; LECTURE ENR 128
*
55 REMOTE=129:7000,E,B1,L1 ; EMISSION BLOC COURANT
*
J=J+1
IF P="N" GOTO 60
L3=LEFT(B1,48)
PRINT=N:TABV(1),L3
60 PRINT=1:"EMISSION EN COURS..",I
NEXT I
*
PRINT=N:TABV(2),"--FIN FICHIER--NBRE EMIS : ",J
*
70 REMOTE=16:8000,E ; ENVOI ETX,EOT,DISC
*
PRINT=N:TABV(1),"--FIN TRANSMISSION--"
IF M <> "T" GOTO 10
*
80 PRINT=N:TABV(1),"BASCULEMENT EN RECEPTION"
.
100 B3=SPACE(256)
    B4=SPACE(256) ; RAZ BUFF RECEPTION
J=0
         PRINT=N:TABV(2),"DEBUT RECEPTION"
*
120 REMOTE=65:7000,E,L2,512 ;  RECEPTION SUR 510 MAX
PRINT=1:"...RECEPTION EN COURS",J
J=J+1
   1(���� ��TEST IMPRIMANTE�(�������TEST IMPRIMANTE EPSON�(�������TEST SURIMPRESSION : ����#�F�0(����(�����������(�������PASSAGE EN COMPRESSE : ������ (����*��� �!# �P(��� �*��� (����������              7700,7800,7900
GOTO 8000 ; AUTRES
*
7100 L3="TIME-OUT"
GOTO 120
7200 L3="RECU DISCONNECT"
GOTO  8100
7300 L3="RECU FIN FICHIER"
GOTO 120
7400 L3="RECU FIN TRANSM"
GOTO 8100
7500 L3="RECU RVI"
GOTO 80
7600  L3="MODEM NON PRET"
GOTO 8100
7700 L3="AUCUNE REPONSE"
GOTO 8100
7800 L3="BLOC REFUSE"
GOTO 8100
7900 L3="RECEP INCORRECT"
GOTO 8100
*
*
*
   8000   PRINT=N:TABV(1),BELL,"### ERR.TELECOM NO :",E
8100 PRINT=N:TABV(1),BELL,"### ERREUR ",L3," ENREG",J
REMOTE = 2:10,E ; DISCONNECT ET IGNORER ERR
          GOTO 10
*****
9000 PRINT=N:TABV(1),BELL,"### ERREUR SYSTEME NO",E
RESUME
*
9999 STOP
**********
ESEG 0
          END
         ENDG 0=9000:TABV(1),"DONNEES "=T(J) EMISSION TEL."NSMISSION"                                    