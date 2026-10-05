big_boss_fin_level_4
big_boss_fin_level_8
	xor 	a
	ld 		(etape_config_bigboss),a
	ld		(flagDirectionBigboss),a	
	ld		(framecounter_bigboss),a
	ld 		(switch_anim_bigboss),a
	ld		(Etp_ExploseGolgoth),a
	ld 		hl,0
	ld		(bigboss_X),hl
	ld		(bigboss_Y),hl	
	ld		a,PV_BIGBISS
	ld		(point_vie_bigboss1),a

	call 	scrolling_off 
	ld		c,BANK_ROM_18
	RST		UPPER_ROM_CONNEXION
	RST		ASIC_CONNEXION
	call	big_boss_fin_level_4_ROM
	call	affiche_fond
; ----> BUG / CORRECTION : même chose que dans initialisation_du_jeu, la ligne de tiles affichée
;       d'avance faisait sauter le décor de 9 lignes au premier pas du scroll : on ne l'affiche plus ici.
	;call	nouvelle_ligne		; 5 nops
	call 	scrolling_on
	call	rom_off

	jp		boucle_principale



compteur_de_fin_fadein 	ds 		1,0
fadein_counter			ds		1,0
etape_config_bigboss		ds			1,0




fondu_des_couleurs2
	ld		c,BANK_ROM_18
	RST		UPPER_ROM_CONNEXION
	call	fondu_des_couleurs2_ROM
	ret
display_bigboss1
			ld a,(etape_config_bigboss)
			cp 	0
			jr	z,send_sprites_into_asic
			cp	1
			jr	z,place_sprites
			cp	2
			jr	z,display_sprites
			cp	3
			jp	z,animation_bigboss
			cp	4
			jp	z,explosion_bigboss
			cp	5
			jp  z,fin_bigboss
		
		send_sprites_into_asic	
			inc	a
			ld	(etape_config_bigboss),a
			call	updateBigboss_SPRH
			ret
		
		place_sprites
			inc	a
			ld	(etape_config_bigboss),a
			RST	ASIC_CONNEXION
			ld	hl,0
			ld	de,0
			call updateBigboss_XY			
			ret
		
		display_sprites
			inc	a
			ld	(etape_config_bigboss),a
			ld	a,zoom_mode0_1
			ld	(SPRH6_ZOOM),a
			ld	(valeur_zoom_sprh6),a
			ld	(SPRH7_ZOOM),a
			ld	(valeur_zoom_sprh7),a
			ld	(SPRH8_ZOOM),a
			ld	(valeur_zoom_sprh8),a
			ld	(SPRH9_ZOOM),a
			ld	(valeur_zoom_sprh9),a
			ld	(SPRH10_ZOOM),a
			ld	(valeur_zoom_sprh10),a
			ld	(SPRH11_ZOOM),a
			ld	(valeur_zoom_sprh11),a
			ld	(SPRH12_ZOOM),a
			ld	(valeur_zoom_sprh12),a
			ld	(SPRH13_ZOOM),a
			ld	(valeur_zoom_sprh13),a
			ld	(SPRH14_ZOOM),a
			ld	(valeur_zoom_sprh14),a
			ret

	flagDirectionBigboss	ds	1,0

; variable global des coordonnées
	bigboss_X				ds  2,0
	bigboss_Y				ds  2,0

	framecounter_bigboss 	ds 	1,0


; ////////////////////////////////////////////////////
; ////////////////////////////////////////////////////
; ///////////   ANIMATIONS ET DEPLACEMENTS   /////////
; ////////////////////////////////////////////////////
; ////////////////////////////////////////////////////

animation_bigboss
	ld		a,15
	ld		(id_soucoupe),a
	RST		ASIC_CONNEXION
	ld		c,BANK_ROM_2
	call	UPPER_ROM_CONNEXION
	call	animation_bigboss_ROM
	

	; on met à jour tous les sprites hard de la soucoupe
	call 	updateBigboss_XY

	; gestion de la vitesse de rotation de la soucoupe
	ld		a,(framecounter_bigboss)
	inc		a
	ld		(framecounter_bigboss),a
	cp		a,BIGBOSS1_VITESSE_ANIMATION
	call 	z,updateBigboss_SPRH		; mise à jours des sprites hard


	ld		hl,(SPRH7_X)
	ld		(bigboss_colX),hl
	ld		hl,(SPRH7_Y)
	ld		(bigboss_colY),hl
	call 	test_collisions_avec_les_Bigboss


	ld		hl,(SPRH10_X)
	ld		(bigboss_colX),hl
	ld		hl,(SPRH10_Y)
	ld		(bigboss_colY),hl
	call 	test_collisions_avec_les_Bigboss


	ld		hl,(SPRH13_X)
	ld		(bigboss_colX),hl
	ld		hl,(SPRH13_Y)
	ld		(bigboss_colY),hl
	call 	test_collisions_avec_les_Bigboss


	ld		hl,(SPRH9_X)
	ld		(bigboss_colX),hl
	ld		hl,(SPRH9_Y)
	ld		(bigboss_colY),hl
	call 	test_collisions_avec_les_Bigboss


	ld		hl,(SPRH11_X)
	ld		(bigboss_colX),hl
	ld		hl,(SPRH11_Y)
	ld		(bigboss_colY),hl
	call 	test_collisions_avec_les_Bigboss


	ld		hl,(SPRH4_X)
	ld		(sprh_adr_tirX),hl
	ld		hl,(SPRH4_Y)
	ld		(sprh_adr_tirY),hl
	call	test_collisions_tir_bigboss


	ld		hl,(SPRH5_X)
	ld		(sprh_adr_tirX),hl
	ld		hl,(SPRH5_Y)
	ld		(sprh_adr_tirY),hl
	call	test_collisions_tir_bigboss
	ret





explosion_bigboss
	ld		a,(framecounter_bigboss)
	inc		a
	ld		(framecounter_bigboss),a
	cp		5
	ret		nz
	xor 	a
	ld		(framecounter_bigboss),a
	call 	scrolling_off 
	ld		c,BANK16_BOOM_SPRH
	rst		UPPER_ROM_CONNEXION
	rst		ASIC_CONNEXION

	ld		a,(Etp_ExploseGolgoth)
	cp		0
	jr		z,InitExplosion
	cp		1
	jr		z,EtpExplosion1
	cp		2
	jr		z,EtpExplosion2
	cp		3
	jp		z,EtpExplosion3
	cp		4
	jp		z,EtpExplosion4
	cp		5
	jp		z,EtpExplosion5
	cp		6
	jp		z,EtpExplosion6
	cp		7
	jp		z,EtpExplosion7
	cp		8
	jp		z,EtpExplosion8
	cp		9
	jp		z,EtpExplosion9
	cp		10
	jp		z,EtpExplosion10
	cp		11
	jp		z,EtpExplosion11
	cp		12
	jp		z,EtpExplosion12
	cp		13
	jp		z,EtpExplosion13



InitExplosion
			inc		a
			ld		(Etp_ExploseGolgoth),a

			ret
EtpExplosion1
			inc		a
			ld		(Etp_ExploseGolgoth),a
						ld	a,(flag_bigboss)
			cp 		a,2
			jp 		z,updateBigboss_replace_XY
			ld		hl,BIG_BOOM_SPRH_ROM_ADR

			ld		de,SPRH6_ADR
			ld		bc,#200
			LDIR
			ld		hl,BIG_BOOM_SPRH_ROM_ADR+#200
			ld		de,SPRH9_ADR
			ld		bc,#200
			LDIR
			ld		hl,BIG_BOOM_SPRH_ROM_ADR+#400
			ld		de,SPRH12_ADR
			ld		bc,#200
			LDIR
			ret
EtpExplosion2
			inc		a
			ld		(Etp_ExploseGolgoth),a
			ld	hl,BIG_BOOM_SPRH_ROM_ADR+#600
			ld	de,SPRH6_ADR
			ld	bc,#200
			LDIR
			ld	hl,BIG_BOOM_SPRH_ROM_ADR+#800
			ld	de,SPRH9_ADR
			ld	bc,#200
			LDIR
			ld	hl,BIG_BOOM_SPRH_ROM_ADR+#A00
			ld	de,SPRH12_ADR
			ld	bc,#200
			LDIR
			ret
EtpExplosion3
			inc		a
			ld		(Etp_ExploseGolgoth),a
			ld	hl,BOOM_SPRH_ROM_ADR
			ld	de,SPRH8_ADR
			ld	bc,#100
			LDIR			
			ret

EtpExplosion4
			inc		a
			ld		(Etp_ExploseGolgoth),a
			ld	hl,BIG_BOOM_SPRH_ROM_ADR+#C00
			ld	de,SPRH6_ADR
			ld	bc,#200
			LDIR
			ld	hl,BIG_BOOM_SPRH_ROM_ADR+#E00
			ld	de,SPRH9_ADR
			ld	bc,#200
			LDIR
			ld	hl,BIG_BOOM_SPRH_ROM_ADR+#1000
			ld	de,SPRH12_ADR
			ld	bc,#200
			LDIR
			ld	hl,BOOM_SPRH_ROM_ADR+#100
			ld	de,SPRH8_ADR
			ld	bc,#100
			LDIR			
			ret
EtpExplosion5
			inc		a
			ld		(Etp_ExploseGolgoth),a
			ld	hl,BIG_BOOM_SPRH_ROM_ADR+#1200
			ld	de,SPRH6_ADR
			ld	bc,#200
			LDIR
			ld	hl,BIG_BOOM_SPRH_ROM_ADR+#1400
			ld	de,SPRH9_ADR
			ld	bc,#200
			LDIR
			ld	hl,BIG_BOOM_SPRH_ROM_ADR+#1600
			ld	de,SPRH12_ADR
			ld	bc,#200
			LDIR
			ld	hl,BOOM_SPRH_ROM_ADR+#200
			ld	de,SPRH8_ADR
			ld	bc,#100
			LDIR			
			ld	hl,BOOM_SPRH_ROM_ADR
			ld	de,SPRH11_ADR
			ld	bc,#100
			LDIR			
			ret
EtpExplosion6
			inc		a
			ld		(Etp_ExploseGolgoth),a
			ld	hl,BIG_BOOM_SPRH_ROM_ADR+#1800
			ld	de,SPRH6_ADR
			ld	bc,#200
			LDIR
			ld	hl,BIG_BOOM_SPRH_ROM_ADR+#1A00
			ld	de,SPRH9_ADR
			ld	bc,#200
			LDIR
			ld	hl,BIG_BOOM_SPRH_ROM_ADR+#1C00
			ld	de,SPRH12_ADR
			ld	bc,#200
			LDIR
			ld	hl,BOOM_SPRH_ROM_ADR+#300
			ld	de,SPRH8_ADR
			ld	bc,#100
			LDIR			
			 ld	hl,BOOM_SPRH_ROM_ADR+#100
			 ld	de,SPRH11_ADR
			 ld	bc,#100
			 LDIR			
			ret
EtpExplosion7
			inc		a
			ld		(Etp_ExploseGolgoth),a
			ld	hl,BIG_BOOM_SPRH_ROM_ADR+#1E00
			ld	de,SPRH6_ADR
			ld	bc,#200
			LDIR
			ld	hl,BIG_BOOM_SPRH_ROM_ADR+#2000
			ld	de,SPRH9_ADR
			ld	bc,#200
			LDIR
			ld	hl,BIG_BOOM_SPRH_ROM_ADR+#2200
			ld	de,SPRH12_ADR
			ld	bc,#200
			LDIR
			ld	hl,BOOM_SPRH_ROM_ADR+#400
			ld	de,SPRH8_ADR
			ld	bc,#100
			LDIR			
			 ld	hl,BOOM_SPRH_ROM_ADR+#200
			 ld	de,SPRH11_ADR
			 ld	bc,#100
			 LDIR			
			ret
EtpExplosion8
			inc		a
			ld		(Etp_ExploseGolgoth),a
			ld	hl,BIG_BOOM_SPRH_ROM_ADR+#2400
			ld	de,SPRH6_ADR
			ld	bc,#200
			LDIR
			ld	hl,BIG_BOOM_SPRH_ROM_ADR+#2600
			ld	de,SPRH9_ADR
			ld	bc,#200
			LDIR
			xor a
			ld	(SPRH12_ZOOM),a
			ld	(valeur_zoom_sprh12),a
			ld	(SPRH13_ZOOM),a
			ld	(valeur_zoom_sprh13),a

			ld	hl,BOOM_SPRH_ROM_ADR+#300
			ld	de,SPRH11_ADR
			ld	bc,#100
			LDIR	
			ld	hl,BOOM_SPRH_ROM_ADR
			ld	de,SPRH14_ADR
			ld	bc,#100
			LDIR	
			xor a
			ld	(SPRH8_ZOOM),a
			ld	(valeur_zoom_sprh8),a
			ret

EtpExplosion9
			inc		a
			ld		(Etp_ExploseGolgoth),a

			ld	hl,BOOM_SPRH_ROM_ADR+#400
			ld	de,SPRH11_ADR
			ld	bc,#100
			LDIR	

			ld	hl,BOOM_SPRH_ROM_ADR+#100
			ld	de,SPRH14_ADR
			ld	bc,#100
			LDIR
			xor	a	
			ld	(SPRH6_ZOOM),a
			ld	(valeur_zoom_sprh6),a

			ld	(SPRH9_ZOOM),a
			ld	(valeur_zoom_sprh9),a

			ret

EtpExplosion10
			inc		a
			ld		(Etp_ExploseGolgoth),a
			ld	hl,BOOM_SPRH_ROM_ADR+#200
			ld	de,SPRH14_ADR
			ld	bc,#100
			LDIR			
			xor	a
		
			ld	(SPRH7_ZOOM),a
			ld	(valeur_zoom_sprh7),a
			ld	(SPRH10_ZOOM),a
			ld	(valeur_zoom_sprH10),a	
			ld	(SPRH11_ZOOM),a
			ld	(valeur_zoom_sprh11),a
			ret
EtpExplosion11
			inc		a
			ld		(Etp_ExploseGolgoth),a
			ld	hl,BOOM_SPRH_ROM_ADR+#300
			ld	de,SPRH14_ADR
			ld	bc,#100
			LDIR			
			ret
EtpExplosion12
			inc		a
			ld		(Etp_ExploseGolgoth),a
			ld	hl,BOOM_SPRH_ROM_ADR+#400
			ld	de,SPRH14_ADR
			ld	bc,#100
			LDIR			
			ret
EtpExplosion13
			ld	a,(etape_config_bigboss)
			inc	a
			ld	(etape_config_bigboss),a
			xor a
			ld	(SPRH14_ZOOM),a
			ld	(valeur_zoom_sprh14),a		
			ret

fin_bigboss
; ----> BUG : on arrive ici avec A = 5 (le cp 5 de display_bigboss1). Les évènements n'étaient donc
;       pas effacés mais remplis de #05, soit trois "dec b" : ça ne tenait que parce que rien ne
;       se sert de B à cet endroit de la boucle.
; ----> CORRECTION : on efface vraiment avec des zéros
	xor	a
	ld	(event_golgoth),a
	ld	(event_golgoth+1),a
	ld	(event_golgoth+2),a
	
	; suppression du test de touche de goldorak
	ld		(event_test_de_goldorak),a
	ld		(event_test_de_goldorak+1),a
	ld		(event_test_de_goldorak+2),a
	


	ld		a,(flag_bigboss)
	cp		a,1
	jr		z,fin_bigboss_1
	cp		a,2
	jr		z,fin_bigboss_2
fin_bigboss_1
	xor		a
	ld		(flag_bigboss),a
	ld		a,_CALL						; call
	ld		(event_fade_out),a
	ld		hl,fondu_de_sortie
	ld		(event_fade_out+1),hl
	ld		a,_JP						; JP
	ld		(event_fade_out+3),a
	ld		hl,boucle_principale
	ld		(event_fade_out+4),hl
	call	music_off
	call	scrolling_on	

	ret
fin_bigboss_2
	

	ld		a,_CALL						; call
	ld		(event_alcorak),a
	ld		hl,alcorak
	ld		(event_alcorak+1),hl

	ld		a,_JP						; JP
	ld		(event_fade_out+3),a
	ld		hl,boucle_principale
	ld		(event_fade_out+4),hl
	call	music_off
	call	scrolling_on	

	ret
	


; utilise hl pour Y
; utilise de pour X

updateBigboss_final__XY
ld      c,BANK_ROM_2
call    UPPER_ROM_CONNEXION
call    updateBigboss_final__XY_ROM
call    rom_off
ret



updateBigboss_replace_XY
	ld	de,(bigboss_X)
	ld	hl,(bigboss_Y)
	jr	updateBigboss_replace_XY2


updateBigboss_XY
	ld		a,(flag_bigboss)
	cp 		a,2
	jp 		z,updateBigboss_final__XY
	
updateBigboss_replace_XY2
ld      c,BANK_ROM_2
call    UPPER_ROM_CONNEXION
call    updateBigboss_replace_XY2_ROM
call    rom_off
ret



switch_anim_bigboss ds 1,0


updateBigboss_SPRH
	ld		a,(flag_bigboss)
	cp 		a,2
	jr 		z,updateBigboss_final__SPRH
	xor		a
	ld		(framecounter_bigboss),a
	ld		a,(switch_anim_bigboss)
	or a
	jr		z,bigboss_anim1
	jr		bigboss_anim2
bigboss_anim1
	inc	a	
	ld	(switch_anim_bigboss),a
	ld	hl,(adrBigbossSpriteROM)
	jr	bigboss_anim1_copy
bigboss_anim2
	dec	a	
	ld	(switch_anim_bigboss),a
	ld	hl,(adrBigbossSpriteROM)
	ld	bc,#900
	add hl,bc
bigboss_anim1_copy
	ld		c,BANK13_GOLGOTH_SPRH
	rst		UPPER_ROM_CONNEXION
	ld		de,SPRH6_ADR
	ld		bc,#900
	LDIR
	call	rom_off
	ret

updateBigboss_final__SPRH
	ld		c,BANK13_GOLGOTH_SPRH
	rst		UPPER_ROM_CONNEXION
	xor	a
	ld	(framecounter_bigboss),a
	ld	a,(switch_anim_bigboss)
	cp	a,0
	jr	z,bigboss2_anim1
	cp	a,1
	jr	z,bigboss2_anim2
	cp	a,2
	jr	z,bigboss2_anim3
bigboss2_anim1
	inc	a	
	ld	(switch_anim_bigboss),a
	ld	hl,BIGBOSS2_SPRH_ADR_ROM
	ld		de,SPRH6_ADR
	ld		bc,#500
	LDIR
	ld	hl,BIGBOSS2_SPRH_ADR_ROM_ANIM1
	ld		de,SPRH11_ADR
	ld		bc,#400
	LDIR
	call	rom_off
	ret

bigboss2_anim2
	inc	a	
	ld	(switch_anim_bigboss),a
	ld	hl,BIGBOSS2_SPRH_ADR_ROM_ANIM2
	ld		de,SPRH11_ADR
	ld		bc,#400
	LDIR
	call	rom_off
	ret
bigboss2_anim3
	xor a	
	ld	(switch_anim_bigboss),a
	ld	hl,BIGBOSS2_SPRH_ADR_ROM_ANIM3
	ld		de,SPRH11_ADR
	ld		bc,#400
	LDIR
	call	rom_off
	ret