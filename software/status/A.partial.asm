********
;
;
DEBU	NOP		;LANCEMENT
	JP	PAR10
;
;	*** MESSAGES
;
M01
	DEFM	'    ERR '
	DEFB	ETX
M02
	DEFM	' EN '
	DEFB	ETX
M03
	DEFM	'ECR.'
	DEFB	ETX
M04
	DEFM	'LEC.'
	DEFB	ETX
M05
	DEFM	'    NO PISTE '
	DEFB	ETX
M06
	DEFM	' / NO SECT '
	DEFB	ETX
M07
	DEFWD	CRLF
	DEFB	LF
	DEFM	'SUPPORT '
	DEFB	ETX
M08
	DEFWD	CRLF
	DEFB	LF
	DEFM	'ECHANGES  ERR LEC.  ERR ECR.  ERR POSIT.'
	DEFM	'  SECT. INV.'
	DEFB	ETX
M88
	DEFWD	CRLF
	DEFM	'--------  --------  --------  '
	DEFM	'----------  ----------'
	DEFWD	CRLF
	DEFB	ETX
M09
	DEFWD	CRLF
	DEFM	'                    '
	DEFM	'--------------------'
	DEFWD	CRLF
	DEFB	ETX
M11
	DEFWD	CRLF
	DEFB	LF
	DEFM	'** LISTE PISTES/SECTEURS INVALIDES :'
	DEFWD	CRLF
	DEFB	LF
	DEFB	ETX
M12
	DEFB	'/'
	DEFB	ETX
M13
	DEFWD	CRLF
	DEFB	ETX
M14	DEFB	'.'
	DEFB	ETX
*EJECT
;****************************************************************
;                                                               *
;	SORTIE    TYPE=1 : VISU    TYPE=2 : IMPR.               *
;                                                               *
;****************************************************************
;
SORT	LD	A,(TYPE)
	AND	A
	JP	NZ,SOR10
	JP	MES
SOR10	PUSH	BC
SOR20	LD	C,(HL)
	CALL	LO
	INC	HL
	LD	A,(HL)
	CP	ETX	;FIN SI ETX
	JP	NZ,SOR20
	POP	BC
	RET
;
;****************************************************************
; 								*
;	LECTURE CARAC. D'ENTREE AVEC FILTRE DES BLANCS          *
;								*
;****************************************************************
FLTR	LD	A,(HL)
	CP	BLAN
	RET	NZ
	INC	HL
	JP	FLTR
;
;****************************************************************
;								*
;	CONVERSION B-->D AVEC CADRAGE ET SORTIE                 *
;                                                               *
;	ENTREE	(D,E)=VALEUR BINAIRE                            *
;			(H,L)=ADRESSE ZONE EN SORTIE          	*
;			A=NB CARACTERE DE LA SORTIE           	*
;                                                              	*
;	SORTIE	HL ET BC INCHANGES                    		*
;                                                              	*
;****************************************************************
;
CADR	PUSH	BC
	PUSH	HL
	LD	C,A
	LD	B,0
	ADD	HL,BC
	LD	A,ETX	;MISE EN PLACE ETX
	LD	(HL),A
	LD	A,C	;RECUPERER LA LONG.
	LD	B,H
	LD	C,L
	PUSH	AF
	LD	HL,Z5
	CALL	BNDC	;CONV DECIMALE DANS Z5
	LD	DE,Z5
CAD10	DEC	HL
	DEC	BC
	LD	A,(HL)
	LD	(BC),A	;TRANSFERT CARAC
	POP	AF
	DEC	A	;COMPTEUR
	PUSH	AF
	JP	Z,CA