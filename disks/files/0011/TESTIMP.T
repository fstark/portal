351W K          	   P   P  P L                               A       I         2       �                                                                                                                                                                        I       E       E1      J       Z       N2      L1      B1      B2      L2      B3      B4      N       P       M       A       R       L3      L       L4      X       S1      S2      T1      T2      T3      Q1      Q2      Q3        &      � JCHEVAUCHEMT
DCL T1% ;   PTR TYPE "CNI"
DCL T2$=126 ; PADDING 1/2 SECT
DCL T3$= 128(500)  ;   500 ENREGS
*
FIELD=3 ;  FICHIER POUR RECEPTION
DCL Q1% ;  PTR LONG=128
DCL Q2$=126 ; PADDING
DCL Q3$= 128 (500) ;
*
*
*
	SEGMENT 0
*
**** DEBUT DU PROGRAMME ***
*
PAUSE "***UTIL TEST TELECOM PORTAL V2**"
PAUSE "-MONTEZ DISQUETTE A TRANSMETTRE!"
*
1 ON ERROR GOTO 9000,E
N=2 ; ULOGIQ IMP
L3=GENER (48,"-")
PRINT=N:TABV(2),L3
PRINT=N:TABV(1),TAB(10),"TEST PROCEDURE BSC-3740"
ASSIGN=3,"RETOUR",WR
*
C1=6  ;MOT DE FONCTION:CONNECT+NON TRSP
P="N" ;OPTION IMP DES ENREG
M="E" ; MODE EMISSION
A="N" ;OPTION NON REP-
L1=80 ; LONG ENREG EMIS DEFAUT=80
N1= 999 ;NB MAX ENREG
R="ERTP      " ;ZONE CTRL REPONSE
*
10 ASK=1,I=9999:CLEAR,TABV(1),"-EMISS,RECEP,TELES,PARAM ? : "=(A),M
J=INDEX (R,M)
E=INSTR(R,M,J) ;INSPECTE REPONSE
IF E=0 GOTO 10
IF M<>"P" GOTO 20
*
11 ASK=1:CLEAR,"LONG ENREG (1=80, 2=128) :" =(N),L
IF L > 2 GOTO 11
IF L=1 GOTO 12
L1= 128
12 ASSIGN=L,"SAISIE",WR;CHOIX DU FICHIER
*
13 ASK=1:CLEAR,"IMP DES ENREG ? (O/N): "=(A),P
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
17 ASK=1:CLEAR,"OPTION TRACE ? (O/N)"=(A),Z
IF Z <> "O" GOTO 18
C1 = C1+1  ; AJOUTE B1
*
18 ASK=1:CLEAR,"TRANSPARENT ? (O/N) "=(A),X
IF X <> "O" GOTO 19
C1 = C1-2  ;RETIRE BIT2
*
19 PRINT=N:"PARAMETRES : ",L,P,A,Z,X,C1
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
GOTO 53
52 N1=T1 ; AUTRE FIC
53 FOR I=1 TO N1; DEBUT BOUCLE
IF L=2 GOTO 54
B1=S2(I) ;  LECTURE ENREG DE 80
GOTO 55
*
54 B1=T3(I) ; LECTURE EN 128
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
PRINT=N:TABV(1),"--FIN T� (�������# �P(������ �=0 *�|�                                                                                                                                                                                                                 � ***UTIL TEST TELECOM PORTAL V2**� -MONTEZ DISQUETTE A TRANSMETTRE!:��#�0�-(������(�����
��TEST PROCEDURE BSC-3740�&��RETOUR ��� ��N�E�N�P���
ERTP      '�$�� ���-EMISS,RECEP,TELES,PARAM ? : �����  � �PP'��� ��LONG ENREG (1=80, 2=128) :������ J� �&�SAISIE ���'��� ��IMP DES ENREG ? (O/N): �����O ��N �Y'��� ��MODE ESCLAVE ? (O/N):�����O ��N ��  � '��� ��OPTION TRACE ? (O/N)����		�O  �'��� ��TRANSPARENT ? (O/N) �����O6  �(������PAR: 	 �� � � 9�� f�m�S��N �(���� �� ***REPONSE-AUTO.ATTENDRE L'APPEL��(���� ��***ETABLIR LA CONNECTION...'TD'�9 � ����a ��T�(���� ��*** CONNEXION 