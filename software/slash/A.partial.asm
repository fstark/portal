TURE
;     12 - INCOHERENCE UPD
;     13 - PISTE 0 NON TROUVEE
;     14 - ERREUR DE CHECKSUM SUR IDENTIFIEURS
 
 
 
 
;    DEFINITION EN 'EQU' DES ERREURS :
;    --------------------------------
 
ENPT	EQU	1
ELEC	EQU	2
ERPP	EQU	3
DEBD	EQU	4
DSIN	EQU	4
PROT	EQU	5
ERRED	EQU	6
EFPIT	EQU	7
OVRUN	EQU	8
DNTAS	EQU	9
IDNT	EQU	10
ERLEC	EQU	11
INCH	EQU	12
ERPNT	EQU	13
ERCSID	EQU	14
*EJECT
;************************************************
;						*
;   PARAMETRES DE LA RESSOURCE			*
;						*
;************************************************
 
	COND	.NOT.TEST
NELC	EQU	10	;NB D'ESSAIS EN ECRITURE / LECTURE
NEPP	EQU	05	;NB D'ESSAIS EN POSITIONNEMENT
	CELSE
 
NELC	EQU	1	;1 SEUL ESSAI EN ECRITURE LECTURE SI TEST
NEPP	EQU	1	;1 SEUL ESSAIENTRE 2 CAR.
	JP	Z,DIR10		;NON * EN FIN
	LD	HL,DNF+2
	ADD	A,L
	LD	L,A
	LD	A,H
	ADC	A,0
	LD	H,A
	INC	HL
	LD	A,(HL)
	CP	20H
	LD	A,SFI
	JP	NZ,VISER	;* ENTRE 2 CAR.  ERREUR
DIR10	POP	AF
DIR11	LD	A,SFI
	JP	NZ,VISER	;ERREUR SI PAS DE NOM DE VOLUME
	LD	A,(ZONE)
	CP	CR
	JP	NZ,DIRF	; SAUT SI COMMANDE VIDE
	JP	DIRV0	; DIRECTORY VOLUME
*EJECT
 
;************************************************
;						*
;	VERIFICATION OPTION LIS=LO		*
;	--------------------------		*
;						*
;************************************************
;
;	ENTREE	HL = ADR. COMMANDE
;
;	SORTIE	Z=1 -> OPTION LIS=LO(CR OU ,) PRESENTE
;		       (IMPP) = 1
;		       HL POINTE SUR LE CR OU DERRIERE LA ,
;			A = SEPARATEUR (CR OU VIRG)
;		       DE SAUVEGARDES
;		Z=0 -> OPTION NON PRESENTE
;		       DE-HL SAUVEGARDES
;			A = 0FFH
;
;--------------------------------------------------
 
LISLO
 
	PUSH	DE
	PUSH	HL
	LD	DE,MLISLO	; MESSAGE
	LD	C,6	; LONGUEUR
 
LISLO1	LD	A,(DE)
	CP	(HL)
	JP	NZ,LISLO3	; INCORRECT
	INC	DE
	INC	HL
	DEC	C
	JP	NZ,LISLO1	;CONTINUER
 
	LD	A,(HL)		;SEPARATEUR
	CP	CR
	JP	Z,LISLO2	; = CR
	CP	','
	JP	NZ,LISLO3	;PAS TROUVE SI MAUVAIS SEPAR.
	INC	HL
 
LISLO2	LD	E,A		;E = SEPARATEUR
	LD	A,1
	LD	(IMPP),A	; OPTION PRESENTE
	XOR	A		;POSITIONNER FLAG Z
	LD	A,E		;A = SEPARATEUR
	POP	DE
	POP	DE
	RET
 
LISLO3	POP	HL
	POP	DE
	LD	A,0FFH
	RET
 
MLISLO	DEFM	'LIS=LO'
	DEFB	CR
*EJECT
 
;****************************************************************
;                                                               *
;	VERIFICATION  OPTION  GR  				*
;	-------------------------                               *
;                                                               *
;****************************************************************
;
;	ENTREE :	HL  = ADR COMMANDE
;
;       SORTIE :	Z=1 ==> OPTION  GR PRESENTE
;				HL POINTE SUR LE CR OU DERRIERE ,
;				A = SEPARATEUR (CR OU VIRG)
;				(FIM) = 1
;				DE PRESERVES
;			Z=0 ==> OPTION ABSENTE
;				DE , HL PRESERVES
;				A = 0FFH
;
;---------------------------------------------------------------
 
 
OPTIMP	PUSH	DE
	PUSH	HL
	LD	DE,MOPIM	;MESSAGE OPTION
	LD	C,2		;LONGUEUR
 
OPTIM1	LD	A,(DE)
	CP	(HL)
	JP	NZ,OPTIM3	;INCORRECT
	INC	DE
	INC	HL
	DEC	C
	JP	NZ,OPTIM1	;CONTINUER
 
	LD	A,(HL)		;SEPARATEUR
	CP	CR
	JP	Z,OPTIM2	; = CR
	CP	','
	JP	NZ,OPTIM3	;NOK SI MAUVAIS SEPARATEUR
	INC	HL
 
OPTIM2	LD	E,A		;E <--- SEPARATEUR
	LD	A,1
	LD	(FIM),A		;OPTION	PRESENTE
	XOR	A		;POSITIONNE FLAG Z
	LD	A,E		;A <--- SEPARATEUR
	POP	DE
	POP	DE
	RET
 
OPTIM3	POP	HL
	POP	DE
	LD	A,0FFH
	RET
 
MOPIM	DEFM	'GR'
	DEFB	CR
*EJECT
 
 
;****************************************************************
;								*
;	DIRECTORY D'UN VOLUME					*
;								*
;		ENTREE	IMPP = ECRAN OU IMPRIMANTE		*
;			DES EST INITIALISE EN LECTURE		*
;								*
;****************************************************************
 
 
DIRV0
 
;	LECTURE ET IMPRESSION DU NOM DU VOLUME
;	PUIS
;	LECTURE ET IMPRESSION DES CARACTERISTIQUES DU VOLUME
;
;--------------------------------------------------------------------
 
	CALL	EDCAR
	CALL	RCLF
	CALL	RCLF
	CALL	LTNF	;LECTURE TABLE DES NOMS FICHIERS
	; SORTIE : BC = NB FICHIERS
	JP	Z,IMPN30	;TABLE VIDE
 
	LD	A,(FIM)
	AND	A
	JP	NZ,EDOP		;OPTION  GR PRESENTE
 
	CALL	ALFTRI	;TRI ALPHABETIQUE DE LA TABLE
 
	JP	IMPN00	;EDITE NOMS FICHIER ET RETOUR
*EJECT
 
;-----------------------------------------------------
;
;	TRAITEMENTS DES SUPPORTS NON GERES PAR NGF
;
;		ENTREE: 'DES' INIT. AVEC NUM. RESS. / NUM. UNITE
;			LE STACK CONTIENT LE CODE SORTIE DE ANFC
;
;---------------------------------------------------------------------
 
DIRN00	EQU	$
	POP	AF
	JP	C,DIRN10
	LD	A,SFI
	JP	VISER	;ERREUR SYNTAXE
 
;	IMPRESSION TITRE
;	----------------
 
DIRN10	LD	HL,MSUP
	CALL	SMESG	;SUPPORT
	LD	B,NBDES
	LD	HL,TPER
DIRN20	INC	HL
	INC	HL
	INC	HL
	LD	C,(HL)
	LD	A,(DES)
	CP	C
	JP	Z,DIRN30
	DEC	B
	INC	HL
	INC	HL
	INC	HL
	JP	NZ,DIRN20
	LD	HL,MBLANC	;SUPPORT I