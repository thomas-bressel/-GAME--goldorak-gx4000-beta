; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ////////////////////        INTERRUPTIONS      ///////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
interruption_ligne_190
; sauvegarde des registres
	push af : push hl : push de
	push bc : push ix : push iy
exx
	push hl : push de
	push bc
exx
; connexion ASIC
	ld		bc,#7F00+%10111000			 
	out 	(c),c
	xor 	a
; le crtc ayant changé de zone écran il faut re calculer l'offset	
	ld		(SPRH0_ZOOM),a
	ld		(SPRH1_ZOOM),a
	ld		(SPRH2_ZOOM),a
	ld		(SPRH3_ZOOM),a
	ld		(SPRH4_ZOOM),a
	ld		(SPRH5_ZOOM),a
	ld		(SPRH6_ZOOM),a
	ld		(SPRH7_ZOOM),a
	ld		(SPRH8_ZOOM),a
	ld		(SPRH9_ZOOM),a
	ld		(SPRH10_ZOOM),a
	ld		(SPRH11_ZOOM),a
	ld		(SPRH12_ZOOM),a
	ld		(SPRH13_ZOOM),a
	ld		(SPRH14_ZOOM),a
	ld		(SPRH15_ZOOM),a
; envoie de la ligne dans le PRI
 	ld		a,LGN_INTERRUPTION_BAS
	ld		(#6800),a
	ld		hl,interruption_ligne_255
	ld		(#39),hl
; copie de la palette du hud
automodif_palette_hud
	ld		hl,PALETTE_HUD_RAM						; lecture de la palette du hud
	ld		de,PALETTE_ASIC						; ecriture
	ld		bc,32							; longueur
; ----> BUG : le retard vidéo était remis à zéro dès l'entrée de l'interruption (ligne 211) : les
;       lignes 212 et 213 du décor s'affichaient décalées, c'est le liseré au dessus du HUD.
; ----> CORRECTION : il est remis à zéro ici, après l'extinction des zooms : on est alors au début de
;       la ligne 213, la dernière du décor, et le changement ne vaut que pour le HUD (ligne 214).
;       La petite attente sert à tomber dans le bord droit de la ligne 213, hors de l'image :
;       HUD_ATTENTE_RETARD se règle à l'oeil (1 de plus = 4 microsecondes plus tard, 16 = 1 ligne).
	ld		b,HUD_ATTENTE_RETARD
attente_retard_hud
	djnz	attente_retard_hud
	xor 	a					; retard video remis à zero
	ld		(#6804),a
	LDIR						; #ED #B0
; remise en place de l'asic
	ld		a,(valeur_asic)
	ld		b,#7F
	out		(c),a
	event_play_music		ds	3,0
	;call	PLY_AKG_Play
; remise en place des connexions de bank ROM
	ld		bc,(rom_sectionnee)
	out 	(c),c
	ld		bc,(etat_de_la_rom)
	out 	(c),c
; récuperation des registres
	exx
	pop bc : pop de : pop hl
	exx
	pop iy : pop ix : pop bc
	pop de : pop hl : pop af
	ei
	ret	
	

	
interruption_ligne_255
; sauvegarde des registres
	push af : push hl : push de
	push bc : push ix : push iy
exx
	push hl : push de
	push bc 
exx


; connexion ASIC
	ld	bc,#7FB8:out (c),c
; envoie de la ligne dans le PRI
 	ld	a,LGN_INTERRUPTION_HUD
	ld	(#6800),a
	ld	hl,interruption_ligne_190
	ld	(#39),hl
	
; on rétablit la valeur des sprites hard zoom
	ld		de,SPRH0_ZOOM
	ld		hl,valeur_zoom
	ld		c,16
boucle_zoom
	ld		a,(hl)
	ld		(de),a
	inc		hl
	ld		a,e
	ld		b,#8
	add		a,b
	ld		e,a
	dec		c
	jr		nz,boucle_zoom

; envoie de la pallette
automodif_palette_jeu
	ld		hl,PALETTE_DECORS_RAM							; lecture  de la palette du décors
	ld		de,PALETTE_ASIC							; ecriture
	ld		bc,32							; longueur
	LDIR
	
	
	
	
	
; mise à jour registre 12 & 13
	;ld		hl,(valeur_crtc)
	;ld		a,(hl)	
	;ld		bc,#bc12
	;out 	(c),c
	;ld		bc,#bd00
	;out 	(c),a
	;inc		hl
	;ld		a,(hl)
	;ld		bc,#bc13
	;out 	(c),c
	;ld		bc,#bd00
	;out 	(c),a
	ld  hl,(valeur_crtc)   ; -> 5 nops
	ld bc,#bc12   ; -> 3 nops
	out (c),c    ;-> 4 nops
	inc b    ;-> 1 nops
	out (c),l   ; -> 4 nops
	dec b  ; -> 1 nops
	inc c   ; -> 1 nops
	out (c),c   ; -> 4 nops
	inc b   ; -> 1 nops
	out (c),h    ;-> 4 nops
	
	
; retard video
	ld		a,(valeur_retard)			; nouvelle valeur du retard video
	ld		(#6804),a

; ----> BUG : event_stop_scroll (le JP pas_de_scroll_hard posé pendant un boss ou la pause) était placé
;       AVANT l'écriture du retard vidéo. Scroll arrêté, plus personne ne réécrivait #6804 : il restait
;       à #00 (la remise à zéro faite ligne 211 pour le HUD). Le décor sautait donc de 1 à 8 lignes
;       d'un coup à chaque arrêt du scroll (arrivée du golgoth, pause), et dans l'autre sens au redémarrage.
; ----> CORRECTION : le retard vidéo est réécrit à chaque trame même scroll arrêté, c'est seulement
;       son avance (et le pas du CRTC) que le JP fait sauter. Le décor s'arrête et repart sans à-coup.
event_stop_scroll			ds		3,0

	ld		hl,vitesse_scroll
	sub		a,(hl)
	jr		c,reinit_scroll
retour_reinit_scroll
	ld		(valeur_retard),a


pas_de_scroll_hard
; remise en place de l'asic
	ld	a,(valeur_asic)
	ld	b,#7F
	out	(c),a
; remise en place des connexion de bank ROM
	ld	bc,(rom_sectionnee)
	out (c),c
	ld	bc,(etat_de_la_rom)
	out (c),c	
; récuperation des registres
	exx
	 pop bc : pop de : pop hl
	exx
	pop iy : pop ix : pop bc
	pop de : pop hl : pop af
	ei
	ret	
	
	
; le retard video arrive au max de la valeur on scroll avec le crtc
reinit_scroll
	ld		ix,(valeur_crtc)		; 6 nops
	ld		a,(ix+-2)				; 5 nops
	cp		a,#FF					; 2 nops
	jp		z,reinit				; 3 nops

	ld		hl,(valeur_offset)		; 5 nops
	ld		de,-64					; 3 nops   (#40 = 64)
	add		hl,de
	ld		(pointeur_ecran),hl		; 5 nops
	ld		(valeur_offset),hl		; 5 nops
	call	nouvelle_ligne		; 5 nops

	ld		a,(ix+-2)
	ld		bc,#bc00+12: out (c),c
	ld		bc,#bd00 : out (c),a
	ld		a,(ix+-1)
	ld		bc,#bc00+13: out (c),c
	ld		bc,#bd00 :out (c),a
	dec 	ix : dec ix
	ld		(valeur_crtc),ix



	;ld	a,SCROLL_INIT_RETARD_VIDEO
; ----> BUG : on écrivait ici le retard vidéo #70 tout de suite. Or nouvelle_ligne vient de prendre
;       6,7 ms : l'interruption partie ligne 254 arrive ici ligne 58 de la trame SUIVANTE, en plein
;       affichage du décor. Cette trame là doit être affichée en entier avec le retard #00 (R12/R13
;       écrits juste au dessus ne sont pris en compte par le CRTC qu'à la trame d'après) : avec le
;       #70 écrit ligne 58, tout le bas du décor remontait de 7 lignes pendant une trame, à chaque
;       nouvelle ligne de tiles (toutes les 8 trames en scroll lent).
; ----> CORRECTION : on ne touche plus à #6804 ici. On range seulement #70 dans valeur_retard :
;       c'est l'interruption du bas de la trame suivante qui l'écrira (ligne 262), pile pour la trame
;       où le nouveau R12/R13 entre en service.
	ld	a,TEST_RETARD_VIDEO
	jp	retour_reinit_scroll


	
; Quand on a fait le tour complet des 255 valeurs du CTRC on ré initialise comme au début

	
reinit								; avant 70 nops. apres 
	ld		hl,tbl_reg1213_fin		;3 nops     -1
	ld		(valeur_crtc),hl		;5 nops     -1
	ld		hl,#c7c0				;3 nops
	ld		(valeur_offset),hl		;5 nops
	ld		(pointeur_ecran),hl		;5 nops
	call	nouvelle_ligne			;5 nops
	ld		hl,(valeur_crtc)		;5 nops    +5
	
	ld		a,(hl)					;2 nops		-3
	ld		bc,#bc00+12: out (c),c  ; 3+4 nops
	ld		bc,#bd00	 ;3 nops
	out 	(c),a	; 4 nops
	
	
	inc		hl						; 2 nops	+2
	ld		a,(hl)					; 2 nops	-3
	ld		bc,#bc00+13: out (c),c ; 3+4 nops
	ld		bc,#bd00 :out (c),a		; 3+4 nops
	
	;ld	(valeur_crtc),hl						;-6

	;ld	a,SCROLL_INIT_RETARD_VIDEO
; ----> CORRECTION : même chose que dans reinit_scroll, on n'écrit plus #6804 en pleine image
	ld	a,TEST_RETARD_VIDEO
	jp	retour_reinit_scroll

TEST_RETARD_VIDEO = #70


	
	

; routine appelé non plus par un call mais par un RST #0
; copié collé en début de programme en #0000	
		
calcul_destile
	LD 		BC,(bank_level)
	OUT 	(C),c						; on execute la sélèction de la ROM
										; on execute la sélèction de la ROM
	LD		BC,#7F00+%10000100
	OUT 	(C),C
	ld 		h,(hl) ; -> 2 nops
	ld 		l,0 ; -> 2 nops
	srl 	h ; -> 2 nops
	rr 		l ; 	-> 2 nops
	srl 	h ;	 -> 2 nops
	rr 		l ; -> 2 nops
	LD 		BC,#c000    		;on met #A000 dans BC qui correspond a l'adresse de nos tiles ->dans la RAM<-
	ADD 	HL,BC        		;on additionne pour avoir l'adresse de la tile ->dans la RAM<-
	RET	
	
		


nouvelle_ligne
	ld		a,(bloc_tile)				; on recupère le bloc 0 ou 1 (haut ou bas)
	or		a
	jr		nz,bloc1					; si c'est le bloc du bas a=0
										; si c'est l'autre on continue
bloc2
	inc		a							; on incremente pour le porchain bloc
	ld		(bloc_tile),a
	ld		(automodif_bloc),a			; on profite c'est la même valeure : ld BC
	ld		a,#20				; 32
	ld		(automodif_bloc+1),a
	ld		a,#09				; 09
	ld		(automodif_bloc+3),a
	ld		hl,(pointeur_de_tile)
; ----> AJOUT : bouclage de la map. On est ici au début d'une nouvelle rangée de tiles, et
;       pointeur_de_tile pointe sur la dernière rangée affichée. Si c'est la 1ère rangée de la map
;       (le bout du level) il n'y a plus rien au dessus : avant on continuait à lire en dessous du
;       début de la map (pour un level : sous #C000, dans la RAM du programme) et le décor se
;       remplissait de tiles en vrac. Maintenant on repart juste derrière la dernière rangée de la
;       map : c'est elle (le bas de l'écran de départ) qui s'affiche au dessus de la 1ère, puis
;       toute la map défile à nouveau. Seul le JP posé dans event_stop_scroll (arrivée du boss,
;       pause) arrête le défilement.
;       Les 2 adresses ci-dessous sont celles du level 1, elles sont modifiées à chaque nouveau
;       level (voir suite_init_level) et pour l'espace (voir big_boss_fin_level_4_ROM).
automodif_debut_map
	ld		de,DEBUT_MAP_LEVEL				; adresse de la 1ère rangée de la map
	or		a
	sbc		hl,de
	add		hl,de							; on retrouve hl, le flag Z de la soustraction n'est pas touché
	jr		nz,pas_fin_de_map
automodif_fin_map
	ld		hl,SCREEN_DEPART_LEVEL_1+16		; adresse qui suit la dernière rangée de la map
pas_fin_de_map
	ld		bc,-16
	add		hl,bc
	ld		(pointeur_de_tile),hl
	jr		affiche_bloc
bloc1
	xor		a
	ld		(bloc_tile),a
	ld		(automodif_bloc),a
	ld		(automodif_bloc+1),a
	ld		(automodif_bloc+2),a
	ld		(automodif_bloc+3),a
	ld		hl,(pointeur_de_tile)
	ld		bc,-16
	add		hl,bc
	ld		(pointeur_de_tile),hl

affiche_bloc
	exx		
	ld		e,16							; compteur de tiles
	exx
boucle_nouvelle_ligne2	
	push	hl
	call	calcul_destile
	
automodif_bloc	ds	4,0
	; ld  bc,#20
	; add hl,bc
automodif_Bank_tileset_scroll	
	LD 		BC,BANK_TILESET_1
	OUT 	(C),C
	LD		BC,#7F00+%10000100
	OUT 	(C),C
	ld		de,(pointeur_ecran)
	push	de
	ld		b,8								; compteur de ligne
boucle_nouvelle_ligne
	push	de				
	ldi:ldi:ldi:ldi
	pop		de
	ld		a,d
	add		a,8
	ld		d,a
	or 		a
	jr		z,debordement_offset2
	retour_debordement_offset2
	or		a
	dec		b								; on decremente les lignes jusqu'a 0
	jr		nz,boucle_nouvelle_ligne
	
	pop		de
	inc		e:inc e:inc e:inc e
	ld		(pointeur_ecran),de
	pop		hl
	inc 	hl
	ld		(pointeur_de_tile),hl
	exx		
	dec		e								; on decremente le nombre de tiles
	exx
	jr		nz,boucle_nouvelle_ligne2
	
	ld		a,(bloc_tile)
	or		a
	RET		NZ
	ld		hl,(pointeur_de_tile)
	ld		bc,-16
	add		hl,bc
	ld		(pointeur_de_tile),hl
	ret
debordement_offset2
	ld	de,#c040
	jr	retour_debordement_offset2




; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; /////////////////////////   VALEUR CRTC  /////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////

tbl_reg1213

db	#ff,#ff

db	#30,#00,#30,#20,#30,#40,#30,#60,#30,#80,#30,#a0,#30,#c0,#30,#e0
db	#31,#00,#31,#20,#31,#40,#31,#60,#31,#80,#31,#a0,#31,#c0,#31,#e0
db	#32,#00,#32,#20,#32,#40,#32,#60,#32,#80,#32,#a0,#32,#c0,#32,#e0
db	#33,#00,#33,#20,#33,#40,#33,#60,#33,#80,#33,#a0,#33,#c0
tbl_reg1213_fin
db	#33,#e0

