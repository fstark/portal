          PROGRAM "BSCPORT"
          FIELD=M
          DCL C1#,N1%,I%,E#,E1$=1,J%,Z$=1,N2%
          DCL L1%,B1$=256,B2$=256,L2%,B3$=256,B4$=256
          DCL N#,P$=1,M$=1,A$=1,R$=10
     DCL L3$=48
*
          FIELD=2,1 ; FICHIER DATA
          DCL T$=256(72)
          FIELD=3,1  ; FICHIER RETOUR
          DCL Q$=128(100)
       FIELD=4  ; FICHIER SAISIE
        DCL S1%,F0$=126,F1$=128(100)  ; ****FIC DE 128***
*
*
	SEGMENT 0
*
**** DEBUT DU PROGRAMME ***
*
        ASSIGN=3,"FL0.RETOUR",WR
ASSIGN=2,"FL0.DATA",WR
      ASSIGN=4,"FL0.SAISIE"
*******************
PAUSE "***PROG TELECOM PORTAL V1***"
PAUSE "-MONTEZ DISQUETTE A TRANSMETTRE!"
1 N=2
L3=GENER (48,"-")
PRINT=N:TABV(2),L3
PRINT=N:TABV(1),TAB(10),"TEST PROCEDURE BSC-3740"
*
C1=6  ;MOT DE FONCTION:CONNECT+NON TRSP
P="N" ;OPTION IMP DES ENREG
M="E" ; MODE EMISSION
A="N" ;OPTION NON REP-
L1=128; LONG ENREG EMIS FORCE A 128***
N1= 999 ;NB MAX ENREG
R="ERTP      " ;ZONE CTRL REPONSE
*
10 ASK=1,I=9000:CLEAR,TABV(1),"-EMISS,RECEP,TELES,PARAM ? : "=(A),M
J=INDEX (R,M)
E=INSTR(R,M,J) ;INSPECTE REPONSE
IF E=0 GOTO 10
IF M<>"P" GOTO 20
*
12 ASK=1:CLEAR,"IMP DES ENREG ? (O/N): "=(A),P
IF P="O" GOTO 15
IF P="N" GOTO 15
GOTO 12
*
15 ASK=1:CLEAR,"REP.AUTO ? (O/N):"=(A),A
IF A="O" GOTO 10
IF A="N" GOTO 10
GOTO 15
GOTO 10
20 B1=SPACE(256)
   B2=SPACE(256)
*
30 REMOTE=2:32,E   ; DECONNECTION ET RAZ
*
GOTO 34
32 IF E<> /53 GOTO 8500 ; DEJA DECONNECTE
34 IF M <> "T" GOTO 35
C1 = C1+128
*
35 IF A = "N" GOTO 36
C1=C1 + 32 ;AJOUTE OPTION RAU
PRINT=1:CLEAR,"***REPONSE-AUTO.ATTENDRE L'APPEL"
GOTO 40
*
36 PRINT=1:CLEAR,"*** ETABLIR LA CONNEXION...'TD'"
*
40 REMOTE=C1:42,E ; CONNECTION SELON MODE
GOTO 45
42 IF E=97 GOTO 40 ; MODEM NON PRET
44 IF E <> 84 GOTO 8500 ; NON CONNECTE
45 PRINT=1:CLEAR,"*** CONNEXION ETABLIE ***"
*
46 IF M="R" GOTO 100 ; RECEPTION
*
50 PRINT=N:TABV(1),"DEBUT EMISSION"
*
J=0
FOR I=1 TO 100 ; 100 ENREGS ***
B1 = F1(I) ; LECTURE FICHIER
***********
55 REMOTE=129:8500,E,B1,L1 ; EMISSION BLOC COURANT
*
J=J+1
IF P="N" GOTO 60
L3=LEFT(B1,48)
PRINT=N:TABV(1),L3
60 PRINT=1:"EMISSION EN COURS.."
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
100 B3=SPACE(256)
J=0
         PRINT=N:TABV(2),"DEBUT RECEPTION"
   120    J=J+1
REMOTE=65:7000,E,L2,512
PRINT=1:"...RECEPTION EN COURS"
   125   IF P="N" GOTO 130
L3 = LEFT (B3,48)
PRINT=N:TABV(1),L3
130 Q(J) = LEFT(B3,128)
GOTO 120
*
*
7000 IF E <> 94 GOTO 7001 ; RECU UN EOT
          PRINT=N:TABV(1),"FIN RECEPTION--NB ENR.RECUS: ",J
       REMOTE=2:8500,E ; DISCONNECT
          GOTO 10
7001 IF E <> 93 GOTO 8500 ; RECU UN ETX
          PRINT=N:TABV(1),"FIN FICHIER"
          GOTO 120
   7500   PRINT=N:TABV(1),"ACQT PAR RVI"
          REMOTE=81:7000,E,B3,L2
          GOTO 130
   8000   GOTO 8500
* M= TRAN(A,B,X,E)
* N=CONV (M) ;   FUTUR..
* PRINT=2: T1(M)
   8500   PRINT=N:TABV(1),BELL,"### ERR.TELECOM NO :",E
REMOTE = 2:10,E ; DISCONNECT SANS ERR
          GOTO 10
*****
  8700   PRINT=N:TABV(1),"FICHIER ERREUR: ",E
   9000   STOP
**********
ESEG 0
END
          PRINT=N:TABV(1),"ENRG NMR : ",(NNZ),I
          ASK=1,I=9000:TABV(1),"DATA : "=Q(J)
          J=J+1
          ASK=1,I=9000:TABV(1),"DATA : "=Q(J)
          J=J+1
          NEXT I
          GOTO 30
  9999   PRINT=N:TABV(1),"PARAMETRAGE FICHIER EMISSION TEL."
         J=1
         FOR I=1 TO 36 STEP 1
         ASK=1,I=9000:TABV(1),"DONNEES "=T(J)
         J=J+1
         ASK=1,I=9000:TABV(1),"DONNEES "=T(J)
         J=J+1
         NEXT I
         GOTO 30
          ESEG 0
          END
