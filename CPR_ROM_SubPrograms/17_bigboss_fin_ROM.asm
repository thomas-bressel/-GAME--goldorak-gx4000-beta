big_boss_fin_level_4_ROM
	xor		a						; on va remplir de zero
	ld		(etape_config_bigboss),a
; ----> BUG : bloc_tile (la moitié de tile à afficher : 0 = celle du bas, 1 = celle du haut) n'était
;       pas remis à zéro comme au début d'un level. Si le scroll du level s'était arrêté au milieu
;       d'une rangée de tiles, la 1ère rangée de l'espace n'affichait que sa moitié haute, collée
;       au fond de départ (on ne le voit pas : l'écran est encore noir à ce moment là du fondu).
; ----> CORRECTION : on repart sur la moitié du bas, comme dans initialisation_du_jeu_ROM
	ld		(bloc_tile),a
	
; on désactive les évenements de la boucle	
	ld		hl,event_fade_out		; les evenements qui sont
	ld		(hl),a					; encore actif dans la boucle
	ld		de,event_fade_out+1
	ld		bc,40
	LDIR
	

       ; on indique la bank de la maptile du prochain level
	ld		hl,BANK_LEVEL_SPACE
	ld		(bank_level),hl
       ; on indique la bank de la tile set du level
	ld		hl,BANK_TILESET_SPACE
	ld		(bank_tileset),hl        
	ld		(automodif_Bank_tileset_scroll+1),hl
       ; on indique l'adresse à laquelle se situe la maptile (à corrige car celle ci ne démarre pas en #C000)
	ld		hl,SCREEN_LEVEL_SPACE
	ld		(adr_screen_level),hl
       ; on indique l'adresse du premier numéro de tile à afficher
	ld		hl,SCREEN_DEPART_LEVEL_SPACE+(-16*13)		; je pointe sur la première tile de la ligne à afficher
	ld		(pointeur_de_tile),hl


		ld		a,MUSIC_BIGBOSS1	
		ld 		hl,Music
		call 	PLY_AKG_Init
		call	music_on

	ld		a,#30
	ld		bc,#bc00+12: out (c),c
	ld		bc,#bd00 : out (c),a
	ld		a,0
	ld		bc,#bc00+13: out (c),c
	ld		bc,#bd00 :out (c),a

    ld		hl,#c000
	ld		(valeur_offset),hl
	; ld		a,SCROLL_SLOW_RETARD_VIDEO
	ld		a,SCROLL_VERY_FAST_RETARD_VIDEO
	ld		(vitesse_scroll),a
	ld 		bc,#bc00+12:out (c),c      			; R12 selectionne
	ld 		bc,#BD00+#30:out (c),c 				; Ecran en #c000
    
; ----> BUG : même défaut qu'au début d'un level (voir initialisation_du_jeu_ROM_suite) : CRTC en #3000
;       mais scroll initialisé en #33E0 / #C7C0 -> saut de 9 lignes au premier pas du CRTC.
;       En plus valeur_offset = #C7C0 servait de départ à affiche_fond : le fond de l'espace était
;       dessiné à partir de la dernière ligne de caractères de la mémoire écran, à cheval sur la fin
;       (#FFFF -> #C000), ce que ligne_inf_C000_type1 ne gère pas (elle retombe en #C800 au lieu de
;       #C000) : la 1ère ligne de l'écran n'était pas redessinée et tout le reste du fond était
;       décalé d'une ligne de pixels.
; ----> CORRECTION : même départ que pour un level, entrée #3000 du tableau et haut de l'écran en #C000.
	ld		hl,tbl_reg1213+2
	ld		(valeur_crtc),hl
	ld		hl,#c000
	ld		(valeur_offset),hl
	ld		(pointeur_ecran),hl

; ----> BUG : le retard vidéo #70 était écrit directement dans l'ASIC : il était effacé dès
;       l'interruption de la ligne 211, et valeur_retard gardait la valeur du level d'avant.
; ----> CORRECTION : on le range dans valeur_retard, c'est l'interruption du bas qui l'envoie à l'ASIC.
	ld		a,TEST_RETARD_VIDEO
	ld		(valeur_retard),a

	ld		hl,event_test_de_goldorak
	ld		a,_JP
	ld		(event_test_de_goldorak),a
	ld		hl,test_de_goldorak
	ld		(event_test_de_goldorak+1),hl

	ld		a,_CALL						; call
	ld		(event_fade_out),a
	ld		hl,fondu_des_couleurs2
	ld		(event_fade_out+1),hl
	
	ld		a,_JP						; JP
	ld		(event_fade_out+3),a
	ld		hl,boucle_principale
	ld		(event_fade_out+4),hl

	ld	a,16
	ld (compteur_de_fin_fadein),a

	ld a,(flag_bigboss)
	cp	a,1
	jr	z,pal_univer1
	jr	pal_univer2
pal_univer1
    ld		hl,PALETTE_DECORS_ESPACE
	ld		(pallette_level),hl
    ret
pal_univer2
	ld		hl,PALETTE_DECORS_ESPACE2
	ld		(pallette_level),hl
    ret

fondu_des_couleurs2_ROM
	
	ei
	ld		a,(fadein_counter)
	inc 	a
	ld		(fadein_counter),a
	cp		a,32
	call	z,fondu_entree	
	ret
fondu_entree	
			xor		a
			ld		(fadein_counter),a
			RST		ASIC_CONNEXION
			ld		hl,(pallette_level)		; emplacement RAM de la pallette ecran
			ld		de,PALETTE_DECORS_RAM						; emplacement ASIC de la pallette ecran NOIRE !
			ld 		b,16								; longueur de la pallette
		boucle_fadein2
				push bc
			fade_in_du_rouge2
				ld	a,(hl)								; on lit l'octet rouge/bleu
				ld	c,a
				AND %11110000
				cp	0									; est ce qu'il est à zéros ?
				jp	z,fade_in_du_bleu2					; si oui alors on s'occupe de la couleur verte
				or	c
				ld	b,#10								; sinon on va s'occuper du rouge
				sub	a,b									; on lui enlève 1
				ld	(hl),a								; et on la sauvegarde
				ld	a,(de)								; on recupère l'octet rouge/bleu de l'ASIC
				add	a,b									; on augmente le rouge seulement
				ld	(de),a								; et on stock le rouge
			fade_in_du_bleu2
				ld	a,(hl)								; on lit l'octet rouge/bleu
				ld	c,a
				AND %00001111
				cp	0									; est ce qu'il est à zéros ?
				jp	z,fade_in_du_vert2						; si oui alors on s'occupe de la couleur verte
				or	c
				dec	a								; sinon on va s'occuper du bleu on lui enlève 1
				ld	(hl),a								; et on la sauvegarde
				ld	a,(de)								; on recupère l'octet rouge/bleu de l'ASIC
				inc	a								; on augmente le rouge seulement
				ld	(de),a								; et on stock le bleu
			fade_in_du_vert2
				inc	hl
				inc	de
				ld	a,(hl)								; on lit l'octet vert
				cp	0									; est ce qu'il est à zéros ?
				jp	z,fade_in_encre_suivante2			; si oui alors on s'occupe de l'encre suivante
				dec	a								; sinon on va s'occuper du vert on lui enlève 1
				ld	(hl),a								; et on la sauvegarde
				ld	a,(de)								; on recupère l'octet vert de l'ASIC
				inc	a								; on augmente le rouge seulement
				ld	(de),a								; et on stock le vert
			fade_in_encre_suivante2
				inc	hl
				inc	de
				pop bc
				djnz boucle_fadein2

				ld a,(compteur_de_fin_fadein)
				dec a
				ld	(compteur_de_fin_fadein),a				
				call z,fin_arrive_espace
				ret


fin_arrive_espace
	xor		a						; on va remplir de zero
	ld		hl,event_fade_out		; les evenements qui sont
	ld		(hl),a					; encore actif dans la boucle
	ld		de,event_fade_out+1
	ld		bc,20
	LDIR

	ld		a,_CALL						; call
	ld		(event_golgoth),a
	ld		hl,display_bigboss1
	ld		(event_golgoth+1),hl

	ld		a,4					; la soucoupe se déplace en bas à droite
	ld		(flagDirectionBigboss), a

	call 	scrolling_off

	ret
