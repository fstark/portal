;
;************************************************************
;
; CONTROLEUR IMPRIMANTE LIGNE ASYNCHRONE
;
; ASSURE LA GESTION DE L'IMPRIMANTE EXTERNE DU PORTAL
;
;*************************************************************
;
;
; RELAIS SYSTEME
;
;
ADSC	EQU	00H	; SORTIE IMPRIMANTE
PRIMP   EQU     01H     ; PRET IMPRIMANTE
ADREIM  EQU    150H     ; ADRESSE RELAIS IMPRIMANTE
ADIMP   EQU     99H     ; ADRESSE CHARGEMENT IMPLICITE
PROLOG  EQU    110H     ; LANCEMENT INTERPRETEUR DE COMMANDE
JMP     EQU    0C3H     ; INSTRUCTION JMP
CARIMP  EQU     84H     ; EMPLACEMENT CARACTERISTIQUES IMPRIMANTE
;
;
PC      EQU   	$
        ORG     CARIMP
        DEFB    66	; NOMBRE DE LIGNES PAR COLONNES
        DEFB    80      ; NOMBRE DE COLONNES PAR LIGNES
;
          ORG      PC
;
;
;
*EJECT
DEB    LD    SP,STAC
        LD  HL,STAC+3
	LD	(ADIMP),HL
        LD      HL,(ADREIM)
        LD      DE,LO?
        LD      A,JMP
        LD      (HL),A
        INC     HL
        LD      (HL),E
        INC     HL
        LD      (HL),D
        JP      PROLOG
;
;
;
*EJECT
;
; CONTROLEUR IMPRIMANTE
;
; ASSURE L'ECRITURE D'UN CARACTERE PLACE DANS REGISTRE C
;
; TOUS REGISTRES PRESERVES SAUF A
;
LO?     IN      A,(PRIMP)     ; TEST PRET IMPIMANTE
        RLCA
        JP      NC,LO?
        AND     40   ; CTS
        CP      40   ;
        JP     NZ,LO?
        LD      A,C
        OUT     (ADSC),A
        RET
;
;
        DEFS    20
STAC    EQU     $
        END     DEB
