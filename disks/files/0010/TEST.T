 <                                                                                                                                                                    ~                                      v                                                                                                                                                                                                                                                                                                                              z                                                                                ��                      P  S � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � �@� � � � � � � � � � � � �                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 (���� ��&RACCORDEMENT PORTAL A TRANSPAC VIA PAD�(�������PARAMETRAGE DE LA CONNECTION�'������
VITESSE ? ��'������CODE ASCII OU EBCDIC����CODE ? �9� 	(��'������EMIS : ��P���
�����FIN 0 9�P 	(��  9� 	(�(�������DECONNECTION EFFECTUEE�(�������CODE RETOUR���(�'�Z ��FAIRE START�(PARAMETRAGE DE LA CONNECTION�'������
VITESSE ? ��'������CODE ASCII OU EBCDIC����CODE ? �9� 	(��'������EMIS : ��P���
�����FIN 0 9�P 	(��  9� 	(�(�������DECONNECTION EFFE NZ,ERMESM
           INC     HL
           JP      MESMC
FMESM      XOR     A
           RET
ERMESM     LD      A,1
           RET
;
;
*EJECT
;
;          ****************************************
;          *                                      *
;          *  GESTION ENVOI D'UN CARACTERE        *
;          *   C = CARACTERE A ENVOYER            *
;          *                                      *
;          *  TOUS REGISTRES PRESERVES SAUF AF     *
,          *   A = O : OK , A = 1 : ERREUR        *
;          *                                      *
;          ****************************************
;
;
EMIS?     PUSH     HL
          PUSH     DE
          PUSH     BC
;
          LD       A,(FONC)
          RRCA
          JP       C,ENVOI
;
;         INITIALISATION ENVOI D'UN MESSAGE
;
INIT      LD       A,1
          LD       (FONC),A
;
;
;         POSITIONNER DTR , ATTENDRE DSR
;
;
;         LD     A,04H
          OUT    (ACOMD),A
;
ATDSR     IN     (ACOMD),A
          AND    04
          JP     NZ,ATDSR
;
;         POSITIONNER RTS , ATTENDRE CTS
;
          LD     A,02H
          OUT    (ACOMD),A
;
ATCTS     IN     A,(ACOMD)
          AND    10
          JP     NZ,ATCTS
;
;
;         ENVOI D'UN CARACTERE
;         ATTENDRE FIN ENVOI (PRET EN SORTIE)
;
ENVOI     LD     A,C
          OUT    (CAR),A
;
ATFINC    IN     A,(ACOMD)
          AND    80
          JP     NZ,ATFINC
;
 
;         ATTENTE DU CARACTERE EN RETOUR DU PAD
;
ATCPAD   