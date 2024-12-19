;
;
;          ************************************
;
;          *                                  *
;          *   TEST RACCORDEMEMT PORTAL       *
;          *   AU RESEAU TRANSPAC PAR PAD     *
;          *                                  *
;          *   MARS 1981                      *
;          *                                   *
;          ************************************
;
;
; 	&*** TABLE DES RELAIS MTZ ***&
;
HORL	EQU	164H ; HORLOGE
ABQT	EQU	173H ; ABANDON D'UN QUANTUM DE TEMPS
;          ***  RELAIS PROLOGUE  ***
;
INTR     EQU     0110H ; INTERPRETEUR COMMANDE
LO       EQU     014FH ; AFFICHAGE D'UN CARACTERE
CI       EQU     0149H ; ENTREE D'UN CARACTERE
MES      EQU     0140H ; AFFICHAGE MESSAGE D'ERREUR
;
;          ***  VARIABLES TRAVAIL ***
;
ETX      EQU       03H  ; ARRET ENVOI MESSAGE
;
CR	EQU	0DH ; TEST FIN MESSAGE DU PAD
LF	EQU	0AH ; TEST FIN MESSAGE EMIS PAR PAD
MAXN    EQU     04H ; NOMBRE DE NUL EN FIN DE MESSAGE PAD
TEC       EQU     02H  ; 2 S MAX NON TRANS. EN RECEPTION
           ORG     $
           LD      SP,STAK
LANC       JP      INIT
;
;          ***  VARIABLES PROCEDURE  ***
;
CONTRL     EQU     011H ; PORT E/S VOIE ASYNCHRONE
ACOMD      EQU      01H ; COMMANDE VOIE ASYNCHRONE
CAR        EQU      00H ; DATA     VOIE ASYNCHRONE
;
;
;          ***  VARIABLES WORK  ***
;
TRACE      DEFB     01H ;SI =1 TRACE MESSAGE SUR ECRAN
FONC       DEFB     00H ;SI = 1 PREMIER CARACTERE D'UN MESSAGE A ENVOYER
DHOR	DEFS	3 ; DELAI HORLOGE
DETECT  DEFS    1 ; DETECTION FIN MESSAGE PAD
ECHO    DEFB  00H ; SI = 1 EMISSION EN MODE ECHO
MAXMES  DEFB  76H ; LONGUEUR MAXIMUN TRACE (BUFFER RECEPTION)
        DEFS    100
STAK       EQU       $
;
;
;
;          ***  PROGRAMME RACCORDEMENT  **+
;
;
;          *** SELECTION VITESSE 300 BAUDS ***
INIT	IN	A,(CONTRL)
	AND	0F0H
	OR 	0DH
	OUT	(CONTRL),A
;
;          *** ENVOI MESSAGE OUVERTURE ***
;
	LD 	HL,MESH
	CALL	MESM?
	LD      HL,MESCR
	CALL    MESM?
           AND      A
           JP       NZ,ERFIN
ATTENT     LD       HL,MESREC
           CALL     RECEP?
	AND	A
	JP	NZ,ERFIN
	LD	HL,MESNMR
	LD	A,1
	LD	(ECHO),A
	CALL	MESM?
	AND 	A
	JP      NZ,ERFIN
        LD      HL,MESREC
        CALL    RECEP?
        AND     A
        JP      NZ,ERFIN
DIAL 	CALL	MESUT?
	AND	A
        JP      NZ,ERFIN
    	LD      HL,MESREC
        CALL    RECEP?
        AND     A
        JP      NZ,ERFIN
        JP      DIAL
        LD      HL,MESFIN
        CALL    TRACE?
        JP      INTR
;
ERFIN  LD       HL,MESER
       CALL     TRACE?
       JP       INTR
;
;
;
;
;          *********************************************
;          *                                           *
;          *  MODULE D'ENVOI D'UN MESSAGE              *
;          *  PORTAL ==> PAD                           *
;          *    SI TRACE = 1 TRACE SUR ECRAN           *
;          *    HL = @ MESSAGE A ENVOYER               *
;          *  TOUS REGISTRES PRESERVES SAUF AF         *
;          *  A = 0 : OK  , A = 1 ERREUR               *
;          *                                           *
;          *********************************************
;
MESM?      PUSH     HL
           PUSH     DE
           PUSH     BC
;
MESMC      LD       A,(HL)
          LD     C,A
           CP       ETX
           JP       Z,FMESM    ; ETX FIN MESSAGE
          CALL     DELAI
           CALL     EMIS?      ; EMISSION D'UN CARACTERE
           AND      A
           JP       NZ,ERMESM
           INC     HL
           JP      MESMC
FMESM      XOR     A
           JP     FMESS
ERMESM     LD      A,1
FMESS     POP     BC
          POP     DE
          POP     HL
  	CALL	TRACE?
          RET
;
;
;
;          ****************************************
;          *                                      *
;          * EMISSION D'UN MESSAGE UTILISATEUR    *
;          * PORTAL VERS PAD EN MODE ECHO         *
;          * ENTRE DU MESSAGE AU CLAVIER          *
;          * SI TRACE = 1 ECHO SUR L'IMPRIMANTE   *
;          * TOUS REGISTRES PRESERVES SAUF AF     *
;          * A = 0 : OK , A = 1 : ERREUR          *
;          *                                      *
;          ****************************************
;
;
MESUT?	PUSH	HL
        PUSH    DE
        PUSH    BC
;
MESUTC  CALL    CI
        RLCA
        JP      C,MESUTC
        RRCA
        CP      CR
        JP      Z,MESUTF
        LD      C,A
        CALL    EMIS?
        AND     A
        JP      NZ,MESUTE	; ERREUR
 	CALL	LOC?
        JP      MESUTC
MESUTF  LD      C,A
        CALL    EMIS?
        AND     A
        JP      NZ,MESUTE
        CALL    LOC?
        JP      MESUTR
MESUTE  LD      C,CR
        CALL    LOC?
        LD      A,1
        JP      MESUTZ
MESUTR  XOR     A
MESUTZ  POP     BC
        POP     DE
        POP     HL
        RET
;
;
;          ****************************************
;          *                                      *
;          *  GESTION ENVOI D'UN CARACTERE        *
;          *   C = CARACTERE A ENVOYER            *
;          *                                      *
;          *  TOUS REGISTRES PRESERVES SAUF AF     *
;          *   A = O : OK , A = 1 : ERREUR        *
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
          LD       A,1
          LD       (FONC),A
;
;
;         POSITIONNER DTR , ATTENDRE DSR
;
;
          LD     A,04H
          OUT    (ACOMD),A
;
ATDSR     IN     A,(ACOMD)
          AND    04H
          JP      Z,ATDSR
;
;         POSITIONNER RTS , ATTENDRE CTS
;
ENVOI     LD     A,06H
          OUT    (ACOMD),A
;
ATCTS     IN     A,(ACOMD)
          AND    10H
          JP      Z,ATCTS
;
;
;         ENVOI D'UN CARACTERE
;         ATTENDRE FIN ENVOI (PRET EN SORTIE)
;
          LD     A,C
          OUT    (CAR),A
;
ATFINC    IN     A,(ACOMD)
          AND    80H
          JP      Z,ATFINC
;
;	ATTENTE DU CARACTERE EN RETOUR DU PAD
;       SI ECHO = 1
;
	LD	A,(ECHO)
	RRCA
	JP	NC,RETOUR
;
ATCPAD 	IN	A,(ACOMD)
   	RRCA
 	JP      NC,ATCPAD
;
;	LECTURE DU CARACTERE RETOURNE ET TEST AVEC L'EMIS
;
	IN	A,(CAR)
          LD    B,A
    	XOR	C
	JP	NZ,ERTR?   ; ERREUR ?
        XOR     A
        JP      RETOUR
ERTR?	LD	A,B
	CP	CR
	JP	Z,RTMES
	LD      A,1
	JP	RETOUR
RTMES   LD	HL,MESREC
	LD	(HL),A
	INC	HL
	CALL	RECEP?
RETOUR  POP     BC
        POP     DE
        POP     HL
        RET
;
;
;
;
;          ****************************************
;          *                                      *
;          *  MODULE RECEPTION D'UN MESSAGE
;          *  PAD ==> PORTAL                      *
;          *   SI TRACE = 1 TRACE SUR ECRAN       *
;          *   HL = @ MESSAGE A RECEVOIR          *
;          *  TOUS REGISTRES PRESERVES SAUF AF    *
;          *                                      *
;          ****************************************
;
RECEP?     PUSH    HL
           PUSH    DE
           PUSH    BC
;
 	   XOR     A
          LD       (DETECT),A
;
ATPADB     IN      A,(ACOMD)
           RRCA
           JP      NC,ATPADB
	PUSH	HL
	JP	ATPF
;
ATPAD	LD      E,TEC
ATPADS  LD      HL,100
        LD      (DHOR+1),HL
        LD      HL,DHOR
        CALL    HORL
ATPADT  IN      A,(ACOMD)
        RRCA
        JP      C,ATPF
        LD      A,(DHOR)
        AND     A
        JP      M,ATPADT
        DEC     E
        JP      NZ,ATPADS
        LD      A,ETX
        POP     HL
        LD      (HL),A
        POP     BC
        POP     DE
        POP     HL
        CALL    TRACE?
        XOR     A
        RET
ATPF    IN      A,(CAR)
        POP     HL
        LD      (HL),A
        INC     HL
        PUSH    HL
        JP      ATPAD
;
;          LECTURE DU CARACTERE
;
           LD      B,A
           CP      LF
           JP      Z,FRECEP
RECEPN     LD      A,B
           LD      (HL),A
RECEPS     INC     HL
           JP      ATPAD
FRECEP     LD      A,(DETECT)
	   ADD     1
          LD     (DETECT),A
	LD      A,(ECHO)
          RRCA
          LD     A,(DETECT)
         JP  NC,RECEPO
              CP    3
             JP      NZ,RECEPN
          JP      RECSEQ
RECEPO    CP   2
          JP  NZ,RECEPN
RECSEQ	LD	A,B
	LD      (HL),A
        INC     HL
        LD      A,MAXN
        LD      C,A
;
ATPADF  IN      A,(ACOMD)
        RRCA
        JP      NC,ATPADF
        IN      A,(CAR)
        LD      (HL),A
        LD      A,C
        SUB     1
        LD      C,A
        INC     HL
        JP      NZ,ATPADF
   	LD	A,ETX
          LD     (HL),A
;
           POP     BC
           POP     DE
           POP     HL
     	CALL	TRACE?
          XOR   A
           RET
;
;
;          ****************************************
;          *                                      *
;          *  LISTE SUR LO D'UN MESSAGE EMIS OU   *
;          *  RECUS                               *
;          *  TOUS REGISTRES  PRESERVES           *
;          *  HL = @ MESSAGE A EDITER             *
;          *               ETX=FIN MESSAGE        *
;          ****************************************
;
TRACE?	PUSH	AF
	LD	A,(TRACE)
	RRCA
	JP	NC,FTRACE
;
	PUSH	DE
	PUSH    BC
        LD      A,(MAXMES)
        LD      E,A
TRACC   LD      A,(HL)
        CP      ETX
        JP      Z,FTRAC
        LD      C,A
        CALL    LO
        LD      A,E
        SUB     1
        JP      Z,FTRAC
        LD      E,A
        INC     HL
        JP      TRACC
FTRAC   POP     BC
        POP     DE
FTRACE  POP     AF
        RET
;
;
;          ******************************************
;          *  TRACE OU NON SUR L'IMPRIMANTE         *
;          *  D'UN CARACTERE EMIS PAR L'UTILISATEUR  *
;          ******************************************
;
LOC?	PUSH  	AF
        LD      A,(TRACE)
        RRCA
        JP      NC,LOC?N
        CALL    LO
LOC?N   POP     AF
        RET
;
;           ****************************************
;           *    DELAI D'UNE SECONDE               *
;           ****************************************
;
DELAI	PUSH	AF
        PUSH    HL
        LD      HL,100
        LD      (DHOR+1),HL
        LD      HL,DHOR
        CALL    HORL
ATTD    CALL    ABQT
        LD      A,(DHOR)
        AND     A
        JP      M,ATTD
          POP     HL
          POP     AF
        RET
;
;
;
;
;          ****      MESSAGES      ****
;
;          MESSAGE D'OUVERTURE
;
MESH       DEFB     48H
           DEFB     03H
;
MESCR      DEFB     0DH
           DEFB     03H
;
MESNMR     DEFM     '133010021'
           DEFB     0DH
           DEFB     03H
;          TAMPON MESSAGE RECU DU PAD
;
MESREC     DEFS     128
;
;           MESSAGES DISPLAY (ERREUR OU BON FONCTIONNEMENT)
MESER      DEFB     0AH
           DEFB     0DH
;
           DEFM     'CONNECTION TRANSPAC ABORTEE'
           DEFB     03H
MESFIN     DEFM     'CONNECTION TRANSPAC REALISEE'
           DEFB     03H
;
;
           END   0
