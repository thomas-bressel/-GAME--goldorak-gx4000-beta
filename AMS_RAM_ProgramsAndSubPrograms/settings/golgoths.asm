
; //////////////////////////////////////////////////////////////////
; /////////////////////////  LES GOLGOTH  ////////////////////////
; //////////////////////////////////////////////////////////////////

GOLGOTH1_SPRH_ADR_ROM			equ		#C000
TIR_GOLGOTH1_SPRH_ADR_ROM		equ		#FA00

GOLGOTH2_SPRH_ADR_ROM			equ		#C800
TIR_GOLGOTH2_SPRH_ADR_ROM		equ		#FB00

GOLGOTH3_SPRH_ADR_ROM			equ		#E900			; 4 sprites du corps sans animation
GOLGOTH3_SPRH_ADR_ROM_TETE_C	equ		#F000			; 2 sprites
GOLGOTH3_SPRH_ADR_ROM_QUEUE_C	equ		#EE00			; 1 sprite
GOLGOTH3_SPRH_ADR_ROM_TETE_G	equ		#F200
GOLGOTH3_SPRH_ADR_ROM_QUEUE_G	equ		#ED00
GOLGOTH3_SPRH_ADR_ROM_TETE_D	equ		#F400
GOLGOTH3_SPRH_ADR_ROM_QUEUE_D	equ		#EF00
TIR_GOLGOTH3_SPRH_ADR_ROM		equ		#F800


GOLGOTH4_SPRH_ADR_ROM			equ		#d800
GOLGOTH4_SPRH_ADR_ROM_ANIM1		equ		#D800
GOLGOTH4_SPRH_ADR_ROM_ANIM2		equ		#E000
GOLGOTH4_SPRH_ADR_ROM_ANIM3		equ		#E800
GOLGOTH4_SPRH_ADR_ROM_MARCHE	equ		#F000



GOLGOTH5_SPRH_ADR_ROM				equ		#EC00
GOLGOTH5_SPRH_ADR_ROM_ANIM_OUT1		equ		#EC00
GOLGOTH5_SPRH_ADR_ROM_ANIM_OUT2		equ		#F200
GOLGOTH5_SPRH_ADR_ROM_ANIM_IN1		equ		#F800
GOLGOTH5_SPRH_ADR_ROM_ANIM_IN2		equ		#FE00
ouvert  = 1
ferme	= 0


GOLGOTH6_SPRH_ADR_ROM			equ		#E000
GOLGOTH6_SPRH_ADR_ROM_ANIM1		equ		#E000
GOLGOTH6_SPRH_ADR_ROM_ANIM2		equ		#E500
GOLGOTH6_SPRH_ADR_ROM_ANIM3		equ		#EA00


GOLGOTH7_SPRH_ADR_ROM			equ		#D000
GOLGOTH7_SPRH_ADR_ROM_ANIM1		equ		#D000
GOLGOTH7_SPRH_ADR_ROM_ANIM2		equ		#D600


GOLGOTH8_SPRH_ADR_ROM					equ		#C000
GOLGOTH8_SPRH_ADR_ROM_ANIM1_CORP		equ		#C000
GOLGOTH8_SPRH_ADR_ROM_ANIM1_TETES		equ		#C400
GOLGOTH8_SPRH_ADR_ROM_ANIM2_CORP		equ		#c800
GOLGOTH8_SPRH_ADR_ROM_ANIM2_TETES		equ		#D000
GOLGOTH8_SPRH_ADR_ROM_ANIM3_CORP		equ		#c000
GOLGOTH8_SPRH_ADR_ROM_ANIM3_TETES		equ		#D400
GOLGOTH8_SPRH_ADR_ROM_ANIM4_CORP		equ		#C800
GOLGOTH8_SPRH_ADR_ROM_ANIM4_TETES		equ		#CC00



VITESSE_EXPLOSE_GOLGOTH			equ		6

VITESSE_ANIM_GOLGOTH			equ		8
VITESSE_ANIM_GOLGOTH4			equ		4
VITESSE_ANIM_GOLGOTH5			equ		4
VITESSE_ANIM_GOLGOTH8			equ		3

CADANCE_TIR_1_GOLGOTH1			equ		32
CADANCE_TIR_2_GOLGOTH1			equ		16
CADANCE_TIR_3_GOLGOTH1			equ		8
CADANCE_TIR_4_GOLGOTH1			equ		4


CADANCE_TIR_1_GOLGOTH2			equ		32
CADANCE_TIR_2_GOLGOTH2			equ		16
CADANCE_TIR_3_GOLGOTH2			equ		8
CADANCE_TIR_4_GOLGOTH2			equ		4

CADANCE_TIR_1_GOLGOTH3			equ		32
CADANCE_TIR_2_GOLGOTH3			equ		16
CADANCE_TIR_3_GOLGOTH3			equ		8
CADANCE_TIR_4_GOLGOTH3			equ		4


; points de vies des golgoths


; le golgoth doit être touché 16 fois, avec une arme de niveau 1
; ----> AJOUT : mini boss (4 sprites hard en bank 11, écrits par Tools/sprites_vers_bank.py)
;       chaque image = 4 sprites (haut gauche, haut droite, bas gauche, bas droite) + 1 missile
MINIBOSS_SPRH_ADR_ROM			equ		#C000
MINIBOSS_SPRH_ADR_ROM_ANIM2		equ		#C500
MINIBOSS2_SPRH_ADR_ROM			equ		#CA00		; le monstre rouge (Sources/gfx/miniboss2.png)
MINIBOSS_POSY					equ		40
MINIBOSS_VITESSE				equ		12
MINIBOSS_NBR_PAS				equ		40
PV_GOLGOTH_1		equ		16                  

; le golgoth doit être touché 40 fois avec une arme de niveau 1 (missile gamma)
; ou 24 fois avec une arme de niveau 2 (planitron 1) 2000 pts dans la boutique
; ou 8 fois s'il  choisit une arme de niveau 3 (planitron 2) 2000 pts dans la boutique
PV_GOLGOTH_2		equ		24                  

; le golgoth doit être touché 36 fois avec une arme de niveau 1 (missile gamma)
; ou 18 fois avec une arme de niveau 2 (planitron 1) 2000 pts dans la boutique
; ou 12 fois s'il  choisit une arme de niveau 3 (planitron 2) 2000 pts dans la boutique
PV_GOLGOTH_3		equ		56

; le golgoth doit être touché 128 fois avec une arme de niveau 1 (missile gamma)
; ou 64 fois avec une arme de niveau 2 (planitron 1) 2000 pts dans la boutique
; ou 42 fois s'il  choisit une arme de niveau 3 (planitron 2) 2000 pts dans la boutique
; ou 25 fois s'il choisit une arme de niveau 5 (fulguropoing) 4000 pts dans la boutique
PV_GOLGOTH_4		equ		180


; le golgoth doit être touché 96 fois avec une arme de niveau 1 (missile gamma)
; ou 48 fois avec une arme de niveau 2 (planitron 1) 2000 pts dans la boutique
; ou 32 fois s'il  choisit une arme de niveau 3 (planitron 2) 2200 pts dans la boutique
; ou 24 fois s'il  choisit une arme de niveau 4 (clavycogyre) 5500 pts dans la boutique
; ou 19 fois s'il choisit une arme de niveau 5 (fulguropoing) 4000 pts dans la boutique
PV_GOLGOTH_5		equ		120



PV_GOLGOTH_6		equ		180

PV_GOLGOTH_7		equ		196

PV_GOLGOTH_8		equ		250