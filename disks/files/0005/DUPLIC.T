351� �          	      ! % ) - 1 5      �   �     	   �  	  B                               B1      B2      B3      I       P       E       S       S1      S2      R       Q       A       D         ~      �   PLIC **"
WAIT 2
5 PRINT=1:CLEAR
  PAUSE " PROTEGEZ L'ORIGINAL!! (CR)"
R=1
Q=1
FOR I=1 TO 4 ; 36 PISTES EN 4 FOIS
PRINT=1:CLEAR
PAUSE "MONTER LA DISQ. ORIGINAL..(CR)"
ASSIGN=1,"FL0" ;OPEN INPUT
* CTL DISQUETTE SALARIAL
B3=4
06 IO=1,/40,B3:300,E,B0,256
IF B2<>03 GOTO 07
PRINT=1:CLEAR,BELL
PAUSE "DISQ. SALARIAL COPIE INTERDITE"
GOTO 55
*
07 E=I-1
S1 = E * 144 ; 9X16 SECTEURS
S2 = S1 + 128 ; 000 A 128
P=1
IF S2<> 560 GOTO 10
S2 = 544 ; DERNIER SECT SUR 35 PISTE
10 P=1
*
FOR S= S1 TO S2 STEP 16
20 IO= 1,/40,S :100,E, D(1,P),4096; LECT UNE PISTE
PRINT=1:CLEAR," PHASE :",I," PISTES LUES :",Q
P=P+1
Q=Q+1
NEXT S
*
*
25 PRINT=1:CLEAR
PAUSE "MONTER LA DISQ. RESULTAT..(CR)"
ASSIGN=2, "FL0",WR ; OPEN OUTPUT
P=1
*
FOR S = S1 TO S2 STEP 16
30 IO= 2,/80, S :150,E, D (1,P),4096;ECRIT UNE PISTE
PRINT=1:CLEAR,"PHASE :",I," PISTES ECRITES :",R
P=P+1
R=R+1
NEXT S
*
NEXT I
*
40 PRINT=1:CLEAR
ASK=1:TAB(1),"AUTRE DISQ. A DUPLIQUER (O,N)?",TAB(31),(A)=A
IF A="O" GOTO 5; VERS AUTRE DUP
IF A<>"N" GOTO 40
50 PRINT=1:BELL,CLEAR,"** FIN DE DUPLICATION **"
WAIT 2
55 STOP
*
100 IF S >= 560 GOTO 50 ;FIN 35 PISTES
IF E=01 GOTO 200; GESTION ERR PERIPH
Q=Q-1; AFFICHAGE PHYS. NO PISTE
    PRINT=2:TABV(1),"##ERR LECTURE NO:",E," SECTEUR:",S," PISTE:",Q
GOTO 50
*
150 IF S>=560 GOTO 50; FIN 35 PISTES
IF E=01 GOTO 220; ERREUR PERIPH
IF E=05 GOTO 230; ERR DISQ PROTEGEE
R=R-1
PRINT=2:TABV(1),"##ERR ECRITURE NO:",E," SECTEUR:",S," PISTE:",R
GOTO 50
*
200 PRINT=1:CLEAR,BELL
PAUSE "PERIPHERIQUE NON PRET (CR)"
GOTO 20
*
220 PRINT=1:CLEAR,BELL
PAUSE "PERIPHERIQUE NON PRET (CR)"
GOTO 30
*
230 PRINT=1:CLEAR,BELL
PAUSE "DISQ. PROTEGEE EN ECRITURE (CR)"
GOTO 25
*
300 IF E<>01 GOTO 310
PRINT=1:CLEAR,BELL
PAUSE "PERIPHERIQUE NON PRET (CR)"
GOTO 06
*
310 PRINT=2:TABV(1),TAB(1),"## ERREUR NO :",E
GOTO 50
ESEG 0
END
NDG 05DISQ. PROTEGEE EN ECRITURE (CR)"" SECTEUR:",S," PISTE:",R                                                                                                                                                                                                
                                                                                                                                                                     ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������(���� ��** DEBUT PROGRAMME DUPLIC **� �(���� ��� PROTEGEZ L'ORIGINAL!! (CR)���(���� ���MONTER LA DISQ. ORIGINAL..(CR)&��FL0  ���	�	� �� ���0� � �
%��@
	�� (���� �� PHASE :� PISTES LUES :���*
�� (���� ���MONTER LA DISQ. RESULTAT..(CR)&��FL0 ����
%�� �
S	�� (���� ��PHASE :� PISTES ECRITES :���*
�A*��] (���� ��'������AUTRE DISQ. A DUPLIQUER (O,N)?������O * �N�(���� ��** FIN DE DUPLICATION **� �
�0�	� ��(�������##ERR LECTURE NO:	�	 SECTEUR:
� PISTE:��
�0�	� �	� ��(�������##ERR ECRITURE NO:	�	 SECTEUR:
� PISTE:��(���� ���PERIPHERIQUE NON PRET (CR)� (���� ���PERIPHERIQUE NON PRET (CR)A(���� ���DISQ. PROTEGEE EN ECRITURE (CR)	�[(���� ���PERIPHERIQUE NON PRET (CR)� (��������## ERREUR NO :	��R ECRITURE NO:	�	 SECTEUR:
� PISTE:�P (���� ���PERIPHERIQUE NON PRET (CR)  (���� ���PERIPHERIQUE NON PRET (CR)0 (���