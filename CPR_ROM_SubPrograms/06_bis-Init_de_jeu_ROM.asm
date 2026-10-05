init_nouveau_level_ROM	
	ld		a,(level_en_cours)
	cp		a,1
	jp		z,init_level_2
	cp		a,2
	jp		z,init_level_3
	cp		a,3
	jp		z,init_level_4
	cp		a,4
	jp		z,init_level_5
	cp		a,5
	jp		z,init_level_6
	cp		a,6
	jp		z,init_level_7
	cp		a,7
	jp		z,init_level_8
	cp		a,8
	jp		z,init_la_fin
	init_level_2
		ex		af,af'
		ld		a,MUSIC_LVL_2
		ld		(automodif_music+1),a
		ex		af,af'

		ld		hl,largeur_chiffre2
		ld		(largeur_chiffre),hl
		ld		hl,adr_chiffre2_ROM
		ld		(adr_chiffre),hl

		ld		hl,BANK_LEVEL_2
		ld		(bank_level),hl
		ld		hl,BANK_TILESET_2
		ld		(bank_tileset),hl
		ld		(automodif_Bank_tileset_scroll+1),hl
		ld		hl,SCREEN_LEVEL_2
		ld		(adr_screen_level),hl
		ld		hl,SCREEN_DEPART_LEVEL_2+(-16*13)		; je pointe sur la première tile de la ligne à afficher
		ld		(pointeur_de_tile),hl

		ld		hl,PALETTE_DECORS_LEVEL2
		ld		(pallette_level),hl

		ld		hl,TBL_VAGUES_LEVEL_2			; on lit l'adresse du tableau des vague de Level 1
		ld		(pointeur_tbl_level),hl			; on stock l'adresse du pointeur
		ld		e,(hl)							; on lit l'adresse contenu à l'adresse du pointeur
		inc		hl
		ld		d,(hl)
		ld		(Pointeur_TblNombreDeSoucoupes),de
		ld		hl,TBL_TYPE_DE_SOUCOUPE_2
		ld		(Pointeur_TblTypeDeSoucoupe),hl

		jp		suite_init_level

		init_level_3
			ex		af,af'
			ld		a,MUSIC_LVL_3
			ld		(automodif_music+1),a
			ex		af,af'

			ld		hl,largeur_chiffre3
			ld		(largeur_chiffre),hl
			ld		hl,adr_chiffre3_ROM
			ld		(adr_chiffre),hl

			ld		hl,BANK_LEVEL_3
			ld		(bank_level),hl
			ld		hl,BANK_TILESET_3
			ld		(bank_tileset),hl
			ld		(automodif_Bank_tileset_scroll+1),hl
			ld		hl,SCREEN_LEVEL_3
			ld		(adr_screen_level),hl
			ld		hl,SCREEN_DEPART_LEVEL_3+(-16*13)		; je pointe sur la première tile de la ligne à afficher
			ld		(pointeur_de_tile),hl

			ld		hl,PALETTE_DECORS_LEVEL3
			ld		(pallette_level),hl

			ld		hl,TBL_VAGUES_LEVEL_3			; on lit l'adresse du tableau des vague de Level 1
			ld		(pointeur_tbl_level),hl			; on stock l'adresse du pointeur

			ld		e,(hl)							; on lit l'adresse contenu à l'adresse du pointeur
			inc		hl
			ld		d,(hl)
			ld		(Pointeur_TblNombreDeSoucoupes),de
			ld		hl,TBL_TYPE_DE_SOUCOUPE_3
			ld		(Pointeur_TblTypeDeSoucoupe),hl
			jp		suite_init_level
			
			init_level_4
				ex		af,af'
				ld		a,MUSIC_LVL_4
				ld		(automodif_music+1),a
				ex		af,af'		

				ld		hl,largeur_chiffre4
				ld		(largeur_chiffre),hl
				ld		hl,adr_chiffre4_ROM
				ld		(adr_chiffre),hl
				ld		hl,BANK_LEVEL_4
				ld		(bank_level),hl
				ld		hl,BANK_TILESET_4
				ld		(bank_tileset),hl
				ld		(automodif_Bank_tileset_scroll+1),hl
				ld		hl,SCREEN_LEVEL_4

				ld		(adr_screen_level),hl
				ld		hl,SCREEN_DEPART_LEVEL_4+(-16*13)		; je pointe sur la première tile de la ligne à afficher
				ld		(pointeur_de_tile),hl

				ld		hl,PALETTE_DECORS_LEVEL4
				ld		(pallette_level),hl
				ld		hl,TBL_VAGUES_LEVEL_4			; on lit l'adresse du tableau des vague de Level 1
				ld		(pointeur_tbl_level),hl			; on stock l'adresse du pointeur
				ld		e,(hl)							; on lit l'adresse contenu à l'adresse du pointeur
				inc		hl
				ld		d,(hl)
				ld		(Pointeur_TblNombreDeSoucoupes),de
				ld		hl,TBL_TYPE_DE_SOUCOUPE_4
				ld		(Pointeur_TblTypeDeSoucoupe),hl

				; initialisation des coordonnées du bigboss 1

				jp		suite_init_level
				
				init_level_5
					ex		af,af'
					ld		a,MUSIC_LVL_5
					ld		(automodif_music+1),a
					ex		af,af'	
					ld		hl,largeur_chiffre5
					ld		(largeur_chiffre),hl
					ld		hl,adr_chiffre5_ROM
					ld		(adr_chiffre),hl	
					ld		hl,BANK_LEVEL_5
					ld		(bank_level),hl
					ld		hl,BANK_TILESET_5
					ld		(bank_tileset),hl
					ld		(automodif_Bank_tileset_scroll+1),hl
					ld		hl,SCREEN_LEVEL_5
					ld		(adr_screen_level),hl
					ld		hl,SCREEN_DEPART_LEVEL_5+(-16*13)		; je pointe sur la première tile de la ligne à afficher
					ld		(pointeur_de_tile),hl
					ld		hl,PALETTE_DECORS_LEVEL5
					ld		(pallette_level),hl
					ld		hl,TBL_VAGUES_LEVEL_5			; on lit l'adresse du tableau des vague de Level 1
					ld		(pointeur_tbl_level),hl			; on stock l'adresse du pointeur
					ld		e,(hl)							; on lit l'adresse contenu à l'adresse du pointeur
					inc		hl
					ld		d,(hl)
					ld	(Pointeur_TblNombreDeSoucoupes),de
					ld		hl,TBL_TYPE_DE_SOUCOUPE_5
					ld		(Pointeur_TblTypeDeSoucoupe),hl
					jp		suite_init_level
					init_level_6	
						ex		af,af'
						ld		a,MUSIC_LVL_6
						ld		(automodif_music+1),a
						ex		af,af'
						ld		hl,largeur_chiffre6
						ld		(largeur_chiffre),hl
						ld		hl,adr_chiffre6_ROM
						ld		(adr_chiffre),hl
						ld		hl,BANK_LEVEL_6
						ld		(bank_level),hl
						ld		hl,BANK_TILESET_6
						ld		(bank_tileset),hl
						ld		(automodif_Bank_tileset_scroll+1),hl
						ld		hl,SCREEN_LEVEL_6
						ld		(adr_screen_level),hl
						ld		hl,SCREEN_DEPART_LEVEL_6+(-16*13)		; je pointe sur la première tile de la ligne à afficher
						ld		(pointeur_de_tile),hl
						ld		hl,PALETTE_DECORS_LEVEL6
						ld		(pallette_level),hl
							ld		hl,TBL_VAGUES_LEVEL_6			; on lit l'adresse du tableau des vague de Level 1
	ld		(pointeur_tbl_level),hl			; on stock l'adresse du pointeur
	ld		e,(hl)							; on lit l'adresse contenu à l'adresse du pointeur
	inc		hl
	ld		d,(hl)
	ld	(Pointeur_TblNombreDeSoucoupes),de
		ld		hl,TBL_TYPE_DE_SOUCOUPE_6
	ld		(Pointeur_TblTypeDeSoucoupe),hl
						jp		suite_init_level
						init_level_7
							ex		af,af'
							ld		a,MUSIC_LVL_7
							ld		(automodif_music+1),a
							ex		af,af'	
							ld		hl,largeur_chiffre7
							ld		(largeur_chiffre),hl
							ld		hl,adr_chiffre7_ROM
							ld		(adr_chiffre),hl
							ld		hl,BANK_LEVEL_7
							ld		(bank_level),hl
							ld		hl,BANK_TILESET_7
							ld		(bank_tileset),hl
							ld		(automodif_Bank_tileset_scroll+1),hl
							ld		hl,SCREEN_LEVEL_7
							ld		(adr_screen_level),hl
							ld		hl,SCREEN_DEPART_LEVEL_7+(-16*13)		; je pointe sur la première tile de la ligne à afficher
							ld		(pointeur_de_tile),hl
							ld		hl,PALETTE_DECORS_LEVEL7
							ld		(pallette_level),hl
								ld		hl,TBL_VAGUES_LEVEL_7			; on lit l'adresse du tableau des vague de Level 1
	ld		(pointeur_tbl_level),hl			; on stock l'adresse du pointeur
	ld		e,(hl)							; on lit l'adresse contenu à l'adresse du pointeur
	inc		hl
	ld		d,(hl)
	ld	(Pointeur_TblNombreDeSoucoupes),de
		ld		hl,TBL_TYPE_DE_SOUCOUPE_7
	ld		(Pointeur_TblTypeDeSoucoupe),hl
							jp		suite_init_level
							init_level_8
								ex		af,af'
								ld		a,MUSIC_LVL_8
								ld		(automodif_music+1),a
								ex		af,af'	
; -----------------------------------------------------------------------------------------------
; ------------------------------------ A RAJOUTER UN CHIFFRE 8 ----------------------------------
; -----------------------------------------------------------------------------------------------
								ld		hl,largeur_chiffre8
								ld		(largeur_chiffre),hl
								ld		hl,adr_chiffre8_ROM
								ld		(adr_chiffre),hl
								ld		hl,BANK_LEVEL_8
								ld		(bank_level),hl
								ld		hl,BANK_TILESET_8
								ld		(bank_tileset),hl
								ld		(automodif_Bank_tileset_scroll+1),hl
								ld		hl,SCREEN_LEVEL_8
								ld		(adr_screen_level),hl
								ld		hl,SCREEN_DEPART_LEVEL_8+(-16*13)		; je pointe sur la première tile de la ligne à afficher
								ld		(pointeur_de_tile),hl
								ld		hl,PALETTE_DECORS_LEVEL8
								ld		(pallette_level),hl
									ld		hl,TBL_VAGUES_LEVEL_8			; on lit l'adresse du tableau des vague de Level 1
	ld		(pointeur_tbl_level),hl			; on stock l'adresse du pointeur
	ld		e,(hl)							; on lit l'adresse contenu à l'adresse du pointeur
	inc		hl
	ld		d,(hl)
	ld	(Pointeur_TblNombreDeSoucoupes),de
		ld		hl,TBL_TYPE_DE_SOUCOUPE_8
	ld		(Pointeur_TblTypeDeSoucoupe),hl
								jp		suite_init_level
								init_la_fin
									ld		a,1
									ld		(fini),a
									jp		suite_init_level
suite_init_level	
	inc		a						; on increment le level
	ld		(level_en_cours),a
	
	ld		a,10
	ld		(points_sante),a
	ld		hl,Tbl_NRJ_bar+19
	ld		(pointeur_tbl_NRJ_bar),hl
xor a
ld (nbr_de_retournement),a
; on lit la table des adresse a lire pour l'affichage du hud pour le retournement
ld	hl,TBL_RETOURNEMENT_COUNT+19
ld  (pointer_tbl_retournement),hl
	ld	a,(hl)
	ld	(display_tbl_retournement_top+1),a
	dec hl
	ld a,(hl)
	ld (display_tbl_retournement_top),a
	dec hl 
	ld	a,(hl)
	ld	(display_tbl_retournement_bot+1),a
	dec hl
	ld a,(hl)
	ld (display_tbl_retournement_bot),a
	ld  (pointer_tbl_retournement),hl

; ----> AJOUT : bouclage de la map (voir nouvelle_ligne). On lui donne les 2 adresses de la map du
;       nouveau level : sa 1ère rangée (là où elle boucle) et l'adresse qui suit sa dernière rangée
;       (là d'où elle repart). L'écran de départ fait 14 rangées de 16 tiles à partir de
;       adr_screen_level, la map se termine juste derrière.
	ld		hl,DEBUT_MAP_LEVEL
	ld		(automodif_debut_map+1),hl
	ld		hl,(adr_screen_level)
	ld		de,TILES_NBR_RANGEES*TILES_NBR_COLONNES
	add		hl,de
	ld		(automodif_fin_map+1),hl

; on désactive les évenements de la boucle	
	xor		a						; on va remplir de zero
	ld		hl,event_fade_out		; les evenements qui sont
	ld		(hl),a					; encore actif dans la boucle
	ld		de,event_fade_out+1
	ld		bc,40
	LDIR	
; on éteinds les sprites hard
	ld		(SPRH6_ZOOM),a : ld	 (valeur_zoom_sprh6),a
	ld		(SPRH7_ZOOM),a : ld	 (valeur_zoom_sprh7),a
	ld		(SPRH8_ZOOM),a : ld	 (valeur_zoom_sprh8),a
	ld		(SPRH9_ZOOM),a : ld	 (valeur_zoom_sprh9),a
	ld		(SPRH10_ZOOM),a : ld	 (valeur_zoom_sprh10),a
	ld		(SPRH11_ZOOM),a : ld	 (valeur_zoom_sprh11),a
	ld		(SPRH12_ZOOM),a : ld	 (valeur_zoom_sprh12),a
	ld		(SPRH13_ZOOM),a : ld	 (valeur_zoom_sprh13),a
	ld		(SPRH14_ZOOM),a : ld	 (valeur_zoom_sprh14),a
	ld		(SPRH15_ZOOM),a : ld	 (valeur_zoom_sprh15),a
; on place les sprites de goldorak
	ld		hl,190		
	ld		(SPRH4_X),hl			; sprite 0 X
	ld		(SPRH2_X),hl			; sprite 2 X
	ld		(SPRH0_X),hl
	ld		de,32+32
	add		hl,de
	ld		(SPRH1_X),hl
	ld		(SPRH5_X),hl			; sprite 1 X
	ld		(SPRH3_X),hl			; sprite 3 X
	ld		hl,230
	ld		(SPRH4_Y),hl			; sprite 0 Y
	ld		(SPRH0_y),hl
	ld		(SPRH1_y),hl
	ld		(SPRH5_Y),hl			; sprite 1 Y
	ld		de,16
	add 	hl,de
	ld		(SPRH2_Y),hl			; sprite 2 Y
	ld		(SPRH3_Y),hl			; sprite 3 Y
; on reinitialise le CRTC	
	ld		a,#30
	ld		bc,#bc00+12: out (c),c
	ld		bc,#bd00 : out (c),a
	xor		a
	ld		bc,#bc00+13: out (c),c
	ld		bc,#bd00 : out (c),a
	
	xor		a
	ld		(EtpGolgoth),a
	ld		(VitesseAnimGolgoth),a
	ld		(Etp_Anim_Golgoth),a
	ld		(flag_MortGolgoth),a
	
	ld		(etp_powerup),a
	ld		(etp_arme1),a
	ld		(etp_arme2),a
	ld		(etp_arme3),a
	ld		(etp_arme4),a
	ld		(etp_arme5),a
	ld		(etp_arme6),a
	ld		(etp_arme7),a

	ld		(Compteur_DistanceGolgoth_1),a
	ld		(event_arme_fireA),a
	ld		(event_arme_fireA+1),a
	ld		(event_arme_fireA+2),a
	ret
	
	
