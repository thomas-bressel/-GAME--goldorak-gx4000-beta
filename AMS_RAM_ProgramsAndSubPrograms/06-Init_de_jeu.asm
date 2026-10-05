initialisation_du_jeu
	ld		c,BANK_ROM_18
	call	rom_on_EI
	CALL	initialisation_du_jeu_ROM
	ld		c,BANK_ROM_2
	call	rom_on_EI
; ----> BUG : la ligne de tiles affichée ici d'avance en #C7C0 est justement celle que le premier pas
;       du scroll doit faire apparaitre. Le scroll en affichait une 2ème au dessus avant de bouger le
;       CRTC : les 2 arrivaient en même temps à l'écran (saut de 9 lignes au début de chaque level).
; ----> CORRECTION : on ne l'affiche plus d'avance, c'est le premier pas du scroll qui s'en charge
;       (voir initialisation_du_jeu_ROM_suite).
	;call	nouvelle_ligne


	ld		c,BANK_ROM_2
	call	rom_on_EI
	Asic ON
	ld		hl,(pallette_level)
	ld		de,PALETTE_DECORS_RAM
	ld		bc,#20
	LDIR




; Copie pallette fond
	LD 		BC,BANK8_PALETTES:OUT (C),C			; on choisit DE LIRE la ROM 11
	LD		BC,#7F00+%10000100:OUT (C),C 		; connexion Upper ROM et Lower ROM (et écran en mode 0.)

; Copie pallette sprites hard
	ld		hl,PALETTE_SPRITE_HARD
	ld		de,PALETTE_SPRH
	ld		bc,#1d
	LDIR
	Asic OFF
	ret



ROUTE_LEVEL
	ld		bc,#7F00+%10001100			; ROM inf déconnectée, ROM sup déconnectée, MODE 0
	out		(c),c				
	ld		a,#c0
	ld		(#c000),a
	ld 		hl,#C000
	ld		de,#c001
	LD 		BC,#3fff
	ldir
	ld		hl,largeur_route
	ld		(largeur_texte),hl
	LD 		BC,BANK20_ROUTE:OUT (C),C			; on choisit DE LIRE la ROM 11
	LD		BC,#7F00+%10000100:OUT (C),C 		; connexion Upper ROM et Lower ROM (et écran en mode 0.)
	ld		hl,adr_route_ROM
	ld		de,adr_route_SCR
	ld		b,hauteur_texte
	call	boucle_route_level
	ld		hl,(largeur_chiffre)
	ld		(largeur_texte),hl
	ld		hl,(adr_chiffre)
	ld		de,adr_chiffreroute_SCR
	ld		b,hauteur_texte
	call	boucle_route_level
	ld		hl,largeur_vignettes
	ld		(largeur_texte),hl
	ld		hl,adr_vignette1_ROM
	ld		de,adr_vignette_SCR
	ld		b,hauteur_vignettes
	call	boucle_route_level
	ld		hl,tbl_adr_vignettes
	inc		hl
	inc		hl
	ld		(pointeur_tbl_vignettes),hl
	exx
	ld		b,128
	exx
Asic ON
; Copie pallette fond
	LD 		BC,BANK8_PALETTES:OUT (C),C			; on choisit DE LIRE la ROM 11
	LD		BC,#7F00+%10000100:OUT (C),C 		; connexion Upper ROM et Lower ROM (et écran en mode 0.)
	ld		hl,PALETTE_INTERLEVEL
	ld		de,#6400
	ld		bc,#20
	LDIR
Asic OFF
	LD 		BC,BANK20_ROUTE:OUT (C),C			; on choisit DE LIRE la ROM 11
	LD		BC,#7F00+%10000100:OUT (C),C 		; connexion Upper ROM et Lower ROM (et écran en mode 0.)
	
boucle_pre_level
	ld    b,#f5    			;adresse du port B du PPI
.vbl
	in    a,(c)     		;On récupère l'octet contenu sur le port dans A
	rra              		;On fait une rotation afin de récupérer le bit 0 dans le flag carry
	jr    nc,.vbl

	exx
	dec		b
	exx
	jr		nz,boucle_pre_level
	exx
	ld		b,128
	exx
	
	ld		hl,(pointeur_tbl_vignettes)
	ld		a,(hl)
	cp		a,#FF
	call	z,reinit_tbl_vignettes
	ld		e,a
	inc		hl
	ld		a,(hl)
	ld		d,a
	inc		hl
	ld		(pointeur_tbl_vignettes),hl

	ld		hl,largeur_vignettes
	ld		(largeur_texte),hl
	ex		hl,de
	ld		de,adr_vignette_SCR
	ld		b,hauteur_vignettes
	call	boucle_route_level

	ld		bc,#F40E:OUT (C),c
	ld		bc,#F6C0:OUT (C),C
	ld		bc,#F600:OUT (C),C
	ld		bc,#F792:OUT (C),C				; on place le port A en sortie (#92)
	ld		bc,#F649:OUT (C),C				; test la ligne 9 avec #F6 + %0100 1001 (#49)
	ld		b,#F4:IN A,(C)
	ld		bc,#F782:OUT (C),C				; on place le port A en entrée (#82)
	ld		bc,#F600:OUT (C),C
	bit		4,a
	ret		z
	jp		boucle_pre_level	

reinit_tbl_vignettes
	ld		hl,tbl_adr_vignettes
	ld		(pointeur_tbl_vignettes),hl
	ld		a,(hl)
	ret
tbl_adr_vignettes
		dw		adr_vignette1_ROM,adr_vignette2_ROM,adr_vignette3_ROM,#FFFF
	
boucle_route_level
	push	bc
	push	hl
	push	de
	ld		bc,(largeur_texte)
	LDIR
	pop		de
	call	ligne_inf_C000_type1
	pop		hl
	call	ligne_inf_C000_type2
	pop		bc
	djnz	boucle_route_level
	ret
	
init_nouveau_level
	
	LD 		BC,BANK18_INIT:OUT (C),C				; on choisit DE LIRE la ROM 18
	LD		BC,#7F00+%10000000:OUT (C),C 			; connexion de la ROM supérieure et de la ROM inférieure et écran en mode 0.
	LD 		BC,#7FC0:OUT (c),c						; on choisit D'ECRIRE  dans la RAM centrale
	call	init_nouveau_level_ROM
	ld		bc,#7F00+%10001000				; ROM inf déconnectée, ROM sup déconnectée, MODE 0
	out		(c),c	
	
	call	PreparationEcran
	
	ld		a,(fini)
	cp		a,1 	
	jp		z,jeu_termine
	call	ROUTE_LEVEL
Asic ON
	xor		a
	ld		hl,PALETTE_ASIC
	ld		(hl),a
	ld		de,PALETTE_ASIC+1
	ld		bc,#20
	LDIR
Asic OFF

test_64k_6
	ld		a,(flag_on_joue_avec_alcorak)
	cp		a,1
	call	z,affiche_hud_alcorak
	ld		a,(flag_on_joue_avec_alcorak)
	or		a
	call	z,affiche_hud
	ld		a,_CALL
	ld		(event_powerup),a
	ld		hl,powerup
	ld		(event_powerup+1),hl

	
	jp		NOUVEAU_LEVEL
