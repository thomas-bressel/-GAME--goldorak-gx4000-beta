include "musique.asm"
include "couleurs.asm"
include "connexions.asm"
include "asic.asm"
include "weapons.asm"
include "golgoths.asm"
include "littleships.asm"
include "alcorak.asm"
include "hud.asm"




MENU_SCREEN_ADR     equ     #C000
METAMORPHOSE_SCREEN_ADR     equ     #D220
SHOP_SCREEN_ADR         equ     #E540



; //////////////////////////////////////////////////////////////////
; ///////////        INTERRUPTION ET RUPTURE            ////////////
; //////////////////////////////////////////////////////////////////
LGN_INTERRUPTION_BAS			equ		254
LGN_INTERRUPTION_HUD			equ		211
; attente avant de remettre le retard vidéo à zéro dans l'interruption du HUD (voir interruption_ligne_190)
HUD_ATTENTE_RETARD				equ		7
LGN_RUPTURE_HUD					equ		214



ID_SOUCOUPE_1   equ     1
ID_SOUCOUPE_2   equ     2
ID_SOUCOUPE_3   equ     3
ID_SOUCOUPE_4   equ     4
ID_SOUCOUPE_5   equ     5
ID_SOUCOUPE_6   equ     6

ID_GOLGOTH_1    equ     7
ID_GOLGOTH_2    equ     8
ID_GOLGOTH_3    equ     9
ID_GOLGOTH_4    equ     10
ID_GOLGOTH_5    equ     11
ID_GOLGOTH_6    equ     12
ID_GOLGOTH_7    equ     13
ID_GOLGOTH_8    equ     14

ID_BIGBOSS_1    equ     15

; //////////////////////////////////////////////////////////////////
; /////////////////////        SHOP        //////////////////////
; //////////////////////////////////////////////////////////////////
CASE_CORNOFULGURE_ECRAN = #FA15
CASE_PULVONIUM_ECRAN = #FA23
CASE_CLAVICOGYRE_ECRAN = #FBF5
CASE_PLANITRON2_ECRAN = #FC03
CASE_PLANITRON_ECRAN = #FDD5
CASE_FULGUROPOINT_ECRAN = #FDE3
CURSOR_ORIGIN_X = 440
CURSOR_ORIGIN_Y = 70
CASE_FERME_ROM = #F220
HAUTEUR_CASE	= 41



; //////////////////////////////////////////////////////////////////
; /////////////////////       SCROLLING       //////////////////////
; //////////////////////////////////////////////////////////////////


; scrolling hard du fond

SCROLL_SLOW_RETARD_VIDEO		equ	16
SCROLL_NORMAL_RETARD_VIDEO		equ	32
SCROLL_FAST_RETARD_VIDEO		equ	48
; ----> AJOUT : pendant un level la vitesse du scroll suit la hauteur de goldorak (voir
;       vitesse_scroll_selon_goldorak). Son Y va de 7 (tout en haut) à 195 (tout en bas) :
;       en dessous de SCROLL_POSY_NORMAL c'est SLOW, puis NORMAL, puis FAST, et au dessus de
;       SCROLL_POSY_VERY_FAST c'est VERY_FAST (4 vitesses).
;       goldorak avance de 4 lignes par pas : SLOW = tout en bas avec 3 pas de marge (Y 191 à 179),
;       NORMAL = les 6 pas juste au dessus (Y 175 à 155), FAST = les 6 pas suivants (Y 151 à 131),
;       VERY_FAST = tout le haut de l'écran (Y 127 à 7).
SCROLL_POSY_NORMAL				equ	166
SCROLL_POSY_FAST				equ	142
SCROLL_POSY_VERY_FAST			equ	108
; ----> BUG : avec 112 (#70) le retard vidéo ne prend que 2 valeurs, #70 puis #00 : le décor avance de
;       7 lignes, puis 1, puis 7, puis 1... (4 lignes par trame en moyenne mais ça tremble).
; ----> CORRECTION : 64 (#40) -> #70 puis #30 : 4 lignes à chaque trame. Même vitesse moyenne, même
;       nombre de lignes de tiles affichées par seconde, mais le défilement est régulier.
;       Les vitesses qui ne tombent pas juste restent irrégulières (48 = 3 lignes, 3, puis 2).
SCROLL_VERY_FAST_RETARD_VIDEO	equ	64
;VALEUR_TIMER			equ	255
SCROLL_INIT_RETARD_VIDEO		equ	#70

; //////////////////////////////////////////////////////////////////
; /////////////////////       MAPTILES       //////////////////////
; //////////////////////////////////////////////////////////////////
SCREEN_DEPART_LEVEL_1	equ		#df30
SCREEN_LEVEL_1			equ		#de60

SCREEN_DEPART_LEVEL_2	equ		#e570
SCREEN_LEVEL_2			equ		#e4a0

SCREEN_DEPART_LEVEL_3	equ		#ebb0
SCREEN_LEVEL_3			equ		#eae0

SCREEN_DEPART_LEVEL_4	equ		#f1f0
SCREEN_LEVEL_4			equ		#f120

SCREEN_DEPART_LEVEL_5	equ		#F830
SCREEN_LEVEL_5			equ		#F760

SCREEN_DEPART_LEVEL_6	equ		#fe70
SCREEN_LEVEL_6			equ		#fda0

SCREEN_DEPART_LEVEL_7	equ		#FE70
SCREEN_LEVEL_7			equ		#FDA0

SCREEN_DEPART_LEVEL_8	equ		#FE70
SCREEN_LEVEL_8			equ		#FDA0


SCREEN_DEPART_LEVEL_SPACE	equ		#FF8E
SCREEN_LEVEL_SPACE			equ		#FEBE

; ----> AJOUT : bouclage de la map (voir nouvelle_ligne). Adresse de la 1ère rangée de la map, c'est
;       à dire le bout du level : arrivé là le scroll repart de la dernière rangée (celle du départ).
;       Les maps des 8 levels sont rangées au début de leur bank. Celle de l'espace est rangée
;       derrière le sample go.spl : on la retrouve avec le nombre de rangées de goldospace.prg
;       (8784 octets / 16 tiles), à mettre à jour si la map de l'espace change de longueur.
DEBUT_MAP_LEVEL				equ		#C000
NBR_RANGEES_MAP_SPACE		equ		549
DEBUT_MAP_SPACE				equ		SCREEN_DEPART_LEVEL_SPACE+16+(-16*NBR_RANGEES_MAP_SPACE)

TILES_NBR_RANGEES		equ 14
TILES_NBR_COLONNES		equ	16
TILES_HAUTEUR			equ	16
TILES_LARGEUR			equ	4
GOLDORAK_INIT_POSX		equ	260
GOLDORAK_INIT_POSY		equ	165

;.zoom_mode0	equ	13
; //////////////////////////////////////////////////////////////////
; //////////////       ECRANS INTER LEVEL       ////////////////////
; //////////////////////////////////////////////////////////////////
adr_route_ROM			equ		#c391
adr_route_SCR			equ		#c108
largeur_route			equ		#c3b6+-#c391
hauteur_texte			equ		4*8+5

adr_chiffreroute_SCR	equ		adr_route_SCR+#28

hauteur_vignettes		equ		11*8
largeur_vignettes		equ		#21
adr_vignette_SCR		equ		#c2cc		; #c2d0

adr_vignette1_ROM		equ		#c000
adr_vignette2_ROM		equ		#c021
adr_vignette3_ROM		equ		#c370

adr_chiffre1_ROM		equ		#ECD1
adr_chiffre2_ROM		equ		#ECD6
adr_chiffre3_ROM		equ		#ECDD
adr_chiffre4_ROM		equ		#ECe4
adr_chiffre5_ROM		equ		#ECeb
adr_chiffre6_ROM		equ		#ECf2
adr_chiffre7_ROM		equ		#ECf9
adr_chiffre8_ROM		equ		#ECf9

adr_chiffre1_SCR		equ		#c3c0
LARGEUR_CHIFFRE1		equ		5

largeur_chiffre2		equ		7
largeur_chiffre3		equ		7
largeur_chiffre4		equ		7
largeur_chiffre5		equ		7
largeur_chiffre6		equ		7
largeur_chiffre7		equ		7
largeur_chiffre8		equ		7

val_points			equ		5

compteur_evenement_level1		equ		#00FF


; //////////////////////////////////////////////////////////////////
; ////////////////////LES ADRESSES DE ACTARUS  ////////////////////
; //////////////////////////////////////////////////////////////////
ACTARUS					equ			#E800
ACTARUS_ANIMATION_1		equ			ACTARUS+#100
ACTARUS_ANIMATION_2		equ			ACTARUS+#200
ACTARUS_ANIMATION_3		equ			ACTARUS+#300
ACTARUS_ANIMATION_4		equ			ACTARUS+#400
ACTARUS_ANIMATION_5		equ			ACTARUS+#500
ACTARUS_ANIMATION_6		equ			ACTARUS+#600

VITESSE_METAMORPHOSE	equ			64

; //////////////////////////////////////////////////////////////////
; ////////////////////LES ADRESSES DE GOLDORAK  ////////////////////
; //////////////////////////////////////////////////////////////////
; goldorak et sa navette
GOLDORAK_HAUTBAS_SPRH_ROM_ADR				equ	#C000		; de #c000 à #C4000
GOLDORAK_GAUCHE_SPRH_ROM_ADR				equ #D000
GOLDORAK_DROITE_SPRH_ROM_ADR				equ	#D400
GOLDORAK_HAUTBAS_ANIMPOINT1_SPRH_ROM_ADR	equ	#D800
GOLDORAK_HAUTBAS_ANIMPOINT2_SPRH_ROM_ADR	equ	#DA00
GOLDORAK_GAUCHE_ANIMPOINT1_SPRH_ROM_ADR		equ	#DC00
GOLDORAK_GAUCHE_ANIMPOINT2_SPRH_ROM_ADR		equ	#DE00
GOLDORAK_DROITE_ANIMPOINT1_SPRH_ROM_ADR		equ	#E000
GOLDORAK_DROITE_ANIMPOINT2_SPRH_ROM_ADR		equ	#E200

; goldorak retournement étapes des 

GOLDORAK_RET_SPRH				equ	#c000
GOLDORAK_RET1_SPRH_ROM_ADR		equ	GOLDORAK_RET_SPRH   ; %1100 0000
GOLDORAK_RET2_SPRH_ROM_ADR		equ	GOLDORAK_RET_SPRH+#400   ; %1100 0100	
GOLDORAK_RET3_SPRH_ROM_ADR		equ	GOLDORAK_RET_SPRH+#800	; %1100 1000
GOLDORAK_RET4_SPRH_ROM_ADR		equ	GOLDORAK_RET_SPRH+#C00	; %1100 1100
GOLDORAK_RET5_SPRH_ROM_ADR		equ	GOLDORAK_RET_SPRH+#1000	; %1101 0000
GOLDORAK_RET6_SPRH_ROM_ADR		equ	GOLDORAK_RET_SPRH+#1400	; %1101 0100
GOLDORAK_RET7_SPRH_ROM_ADR		equ	GOLDORAK_RET_SPRH+#1800	; %1101 1100



; collision de goldorak avec les bords de l'écran
collision_goldo_droite		equ	#0184
collision_goldo_gauche		equ	#ff
collision_goldo_bas			equ	#C3  ;#c5
collision_goldo_bas2		equ	#C5
collision_goldo_haut		equ	#07;#1B

; identification des directions
val_dir_haut			equ	1
val_dir_bas				equ	2
val_dir_gauche			equ	3
val_dir_droite			equ	4

VITESSE_RETOURNEMENT		=	3
DISTANCE_RETOURNEMENT_AVANCER	= 	-16
DISTANCE_RETOURNEMENT_RECULER	= 	16
DISTANCE_RETOURNEMENT_AVANCER_moins	= 	-8
DISTANCE_RETOURNEMENT_RECULER_moins	= 	8


	
BOOM_SPRH_ROM_ADR		equ	#c000
BOOM2_SPRH_ROM_ADR		equ	#c500
BIG_BOOM_SPRH_ROM_ADR	equ	#d000



nrj_damage_goldorak		equ	3




; //////////////////////////////////////////////////////////////////
; /////////////////////////  LES VAISSEAUX MERE  ////////////////////////
; //////////////////////////////////////////////////////////////////



BIGBOSS1_SPRH_ADR_ROM					equ		#c000


BIGBOSS2_SPRH_ADR_ROM					equ		#db00
BIGBOSS2_SPRH_ADR_ROM_ANIM1  			equ		#e000
BIGBOSS2_SPRH_ADR_ROM_ANIM2  			equ		#e400
BIGBOSS2_SPRH_ADR_ROM_ANIM3  			equ		#e800

BIGBOSS1_VITESSE_ANIMATION			equ		4
BIGBOSS2_VITESSE_ANIMATION			equ		8



; ///////////////////////////// OPCODE  //////////////////////////////


_CALL		equ		#cd
_JP			equ		#c3





NBR_RETOURNEMENT_MAX equ 5

TBL_RETOURNEMENT_COUNT
dw	RET1a, RET1b
dw	RET2a, RET2b
dw	RET3a, RET3b
dw	RET4a, RET4b
dw	RET5a, RET5b
TBL_RETOURNEMENT_COUNT_END

RET1a equ #68DA
RET1b equ #70DA
RET2a equ #50DD
RET2b equ #58DD
RET3a equ #60A0
RET3b equ #68A0
RET4a equ #50E3
RET4b equ #58E3
RET5a equ #68E6
RET5b equ #70E6



; ///////////////// SCENE DE FIN //////////////

PORTRAIT_ACTARUS_HAUT		EQU		#F000
PORTRAIT_ACTARUS_BAS		EQU		#F400

PORTRAIT_ALCOR_HAUT			EQU		#F200
PORTRAIT_ALCOR_BAS			EQU		#F600

