371�|-         	      ! % ) - 1 5 9 = A E I M Q U Y ] a e i m v z ~ � � � � � � � � � � �       0	00 ! " # $ % & '  ( 0H 0x 
� 
� � � � � � �� �    �Q �Q �Q �Q �Q �Q �Q '@�Q    �Q�Q�Q�Q`H    MEM                             PAR     I       J       K       L       I1      J1      K1      M       N       O       P       Q       ERR     A       B       C       D       E       F       A1      B1      C1      MODE    CLA     ENT     R       R1      R2      R3      R4      R5      X       Y       Z       STA     STA1    STA2    STA3    STA4    G         �      �0 � � �P( � 		 
 y �  �  P n !� "� #� $� %0%fP%o &| '�P'?`'E )F 0iP0� 1?	1	$=2,R3$=2 ; RESULTATS PAR TEST
*
DCL X$=1  ;  OCTET EN ALPHA
FIELD=M,X
DCL Y#  ; MEME OCTET EN NUM
*
*
*
*
*	---------------
.
	SEGMENT 0
*
1	C=GENER(48,"=")
	PRINT=2:TABV(1),C,TABV(1),"*** PROGRAMME DE VERIFICATION SYSTEME PORTAL ***"
*
PAUSE "MONTER DKT 'MEM' "
ASSIGN=1,"MEM-O"  ; LECT PROG ASS
LOAD=1,MEM	;A L ADRESSE MEM
*=VPTR(I)
*=VPTR(PAR)
*RINT=2:TABV(1),"ZONE DATA ENTRE ",I,J,TABV(1)
*
PRINT=1:CLEAR,"CONTROLE MANUEL OU AUTOMATIQUE ?"
WAIT 5
OP 10
PRINT=1:CLEAR,"VERIF AUTOMATIQUE: PATIENTEZ"
WAIT 3
GOTO 100
*
10	PRINT=1:CLEAR,"MANUEL : CHOISISSEZ LE TEST ..."
WAIT 1
20 ASK=1,I=200:"(M)EM,(F)LO,(I)MP,(A)FF,(C)LA =" =A
  E="MFIAC....." ; REPONSES POSS
N=INDEX(E,A)
M=INSTR(E,A,N)
IF M=0 GOTO 20
*
ASK=1:CLEAR,"TEST EN CONTINU (O/N) ? " =A1
  F="1234567890"
X=TRAN(E,F,1,A) ; !!!
Q=CONV(X) ; EN NUM
*
30 OF Q GOSUB 1000,2000,3000,4000,5000 ; GOSUB TEST
OP 10 ;  PERMET INTERRUPTION
IF A1 = "O" THEN 30 ELSE 10
*
100 GOSUB 1000
    GOSUB 2000
    GOSUB 3000
    GOSUB 4000
    GOSUB 5000
*
200 ASK=1:CLEAR,BELL,"TAPER LE NUMERO DU PORTAL: " = (N3),B1
    ASK=1:CLEAR,     "TAPER VOTRE NOM : " =E
    ASK=1:CLEAR,     "ENTRER LA DATE (JJMMAA) : " =(N6),C1
*
250 PRINT=2:TABV(1),C,TABV(1),TAB(10),"MACHINE PORTAL Numero ",B1
PRINT=2:TABV(2),"RESULTATS : MEM=",R1," FLO=",R2," IMP=",R3
PRINT=2:TABV(2),TAB(10),"DATE: ",C1,"   PAR: ",E
PRINT=2:TABV(1),C,TABV(5)
ASK=1:CLEAR,"REEDITION DU RESULTAT (O/N) ?" =A
IF A = "O" GOTO 250
*
900 STOP
.    SOUS PROGR DE TESTS DES PERIFS
*
1000 PRINT=2:TABV(1),"TEST MEMOIRE EN COURS ..."
     PRINT=1:TABV(1),"TEST MEMOIRE EN COURS ..."
*
for i=0 to 255 step 17 ;00,11,22...ff
par=i
CALL PAR,MEM  ; exec sprog ass
IF PAR <>0 GOTO 1200
goto 1300
GOTO 1300
*
1200 PRINT=2:TABV(1),"### ERREUR CONTROLE MEMOIRE.CONTENU :",PAR
*
1300 PRINT=2: TAB(30)  ,      "TEST TERMINE"
RETURN
*
*
*
2000 WAIT 0
3000 WAIT 0
4000 WAIT 0
5000 WAIT 0
   GOTO 900
.
	ESEG 0
	END
Z
ENDG 0                                                                                                                                                                                                                                                         
                                                900 PRINT=2:TABV(1),TAB(15),"    ERREUR  NO : ",E1
ASK=1,I=8000:CLEAR,"RETOUR A COPIE (CR) FIN (ESC)"=B0
GOTO 5800
*
.
7000 ASK=1,I=8000:CLEAR,"AUTRE UTILITAIRE  ???? (O,N) : "=B0
IF B0="N" GOTO 8000
IF B0<>"O" GOTO 7000
PRINT=1:CLEAR
PAUSE "MONTE#�0�=(����������0*** PROGRAMME DE VERIFICATION SYSTEME PORTAL ***�&��MEM-O  ���<� ���F����F� ���:�(���� �� POUR CONTROLE MANUEL : <ESC> ...� �=� (���� ��VERIF AUTOMATIQUE: PATIENTEZ� ��A�(���� ��MANUEL : CHOISISSEZ LE TEST ...��#�0�=#�0�-(����������0*** PROGRAMME DE VERIFICATION SYSTEME PORTAL ***����&��MEM-O  ���<� ���F����F� ���:o(���� �� POUR CONTROLE MANUEL : <ESC> ...� �=� (���� ��VERIF AUTOMATIQUE: PATIENTEZ� ��A�(���� ��MANUEL : CHOISISSEZ LE TEST ...��M �'�� ��(M)EM,(D)IS,(I)MP,(A)FF,(C)LA =��
MDIACF....�  �F �'��� ��TEST EN CONTINU (O/N) ? �
�i�	�
��=� �O �� 
�i�	�
'��� ��TAPER LE NUMERO DU PORTAL: �'��� ��TAPER VOTRE NOM : �'��� ��ENTRER LA DATE (JJMMAA) : ����#�0�=�(���������
��MACHINE PORTAL Numero ��(�������RESULTATS : MEM=� FLO= � IMP=!� AFF="� CLA=#�(������
��DATE: �   PAR: �(����������*��,'��� ��-RELANCER LE TEST ? O/N :��O � �N�(�������TEST MEMOIRE EN COURS ...�(�������TEST MEMOIRE EN COURS ...��  � y*� ��Z�OK�(�������%### ERREUR CONTROLE MEMOIRE.CONTENU :��HS(�������TEST TERMINE�����A '��� ��  MONTER DISQUETTE A TESTER <CR> ���(�������TEST FLOPPY EN COURS ...�(�������TEST FLOPPY EN COURS ...�&��FL0  ����� � %��@��� (�������*** PISTES LUES :��*� �n �OK�&��FL0 ���� (�������*** TEST LECT/ECR. PHASE� SUR 6��P�@��%��@�� �*���%�� �|�� �*�-*���(���� ��*** TEST RELECTURE EN COURS...�� %��@���� *�/��=�*��fF'��� ��- INTERRUPTION O/N ? :��O F�(�������### ERR RELECTURE No:�	 SECTEUR:����f(�������### ERR LECTURE No:� PISTE:����'��� ��-CONTINUER ? (O/N) :�$$�O o �HSF��n(�������### ERR ECRITURE No:� PISTE:���� �HSF�!��A'*���(�������(NBR.ACCES   ERR.LECT   ERR.ECR   ERR.POS�(�������(���)���*�� �+����)� ?*� ?+�  E �HS�(�������TEST TERMINE����(�������TEST IMPRIMANTE EN COURS ...����(�������TEST IMPRIMANTE EN COURS ...�%�0#�0$(�������=�	*%�z��%�#�0$(����(��������,�$ *���(���$��,�# *��(���$��,�H *��5(���$�(�����1��$��1��#��1��H�����(�������01     22    333   4444  5555  666   77    8    9�=�	*�<�s�%�@(��������(���$�*��*�0��(�������&��%�@(�����$�=�	*�0��(��������.TEST IMP TERMINE����'��� ��IMPRESSION CORRECTE ? O/N :�!�OK�N 	�O?	�	!�HS�	'��� ��INTERRUPTION ? O/N :��O ?	�(���� ��!TEST AFFICHEUR INTERROMPRE PAR<A>��� �$�O�
$�*�
$�.�
$�=�
=
�	'��� ��AFFICHEURS CORRECTS ? O/N��N m
�O
"�OK(�������TEST AFFICHEUR ACCEPTE��
"�HS(�������TEST AFFICHEUR REFUSE ########��
#� $(������� �(�������(���� �� TEST CLAVIER : APPUYER SUR...���#�OK(������� TEST CLAVIER EN COURS ...��� ��'��� �� TAPER SUR LES TOUCHES '�' :� �#�OK'��� �� ERREUR ! RECOMMENCER (O/N) : ��O &�N �U#�HS�AZERT&#�HS 2�QSDFG&#�HS 2�WXCVB&#�HS 2�01234&#�HS 2�56789&#�HS 2(�������TEST CLAVIER TERMINE����n(�������ERREUR CLAVIER SUR TOUCHES �
 DEVIENT :����(�������ERREUR SYSTEME NO�	 PR R#�HS�AZERT R#�HS  X�QSDFG R#�HS  X�WXCVB R#�HS  X�01234 R#�HS  X�56789 R��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������