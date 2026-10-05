; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////                GOLGOTH 1          /////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////

golgoth_2_ROM
golgoth_1_ROM
; ----> AJOUT : mini boss. Il se sert de la routine du golgoth 1. Tant qu'il est là (explosion comprise)
;       on retire à chaque tour ce que compteur_evenements vient d'ajouter au compteur des vagues :
;       le compteur n'avance plus, la vague suivante ne partira qu'après sa mort.
	ld		a,(flag_miniboss)
	or		a
	jr		z,golgoth_1_ROM_suite
	ld		hl,counter_poid_faible
	dec		(hl)
golgoth_1_ROM_suite
	ld		a,(EtpGolgoth)
	cp		a,0
	jp		z,Anim_Golgoth
	cp		a,1
	jp		z,Explose_Golgoth
		Anim_Golgoth
			ld		a,(VitesseAnimGolgoth)
			inc		a
			ld		(VitesseAnimGolgoth),a
			cp		a,VITESSE_ANIM_GOLGOTH
			jp		nz,Deplacement_Golgoth
			xor		a
			ld		(VitesseAnimGolgoth),a
			call	Deplacement_Golgoth
			ld		a,(Etp_Anim_Golgoth)
			cp		a,0
			jr		z,.Anim_0_Golgoth
			cp		a,1
			jr		z,.Anim_1_Golgoth
			ret
				.Anim_0_Golgoth
					inc		a
					ld		(Etp_Anim_Golgoth),a
					ld		hl,(Tbl_Golgoth_anim)
					ld		(GolgothAdrRom),hl
					ld		hl,SPRH6_ADR
					ld		(GolgothSprh),hl
					ld		hl,#400
					ld		(GolgothLongeur),hl
					ret
				.Anim_1_Golgoth
					dec		a
					ld		(Etp_Anim_Golgoth),a
					ld		hl,(Tbl_Golgoth_anim+2)
					ld		(GolgothAdrRom),hl
					ld		hl,SPRH6_ADR
					ld		(GolgothSprh),hl
					ld		hl,#400
					ld		(GolgothLongeur),hl
					ret
						Deplacement_Golgoth
						
						; modification de la direction X du Golgoth
							ld		hl,(Pointeur_TblGolgoth_1)
							ld		c,(hl)
							inc		hl
							ld		b,(hl)					; décalage dans BC
							ex		de,hl
							ld		hl,(posX_Golgoth)
							add		hl,bc
							ld		(posX_Golgoth),hl		; resultat
						; modification de la direction Y du Golgoth
							ex		hl,de					; Pointeur dans HL
							inc		hl
							ld		c,(hl)
							inc		hl
							ld		b,(hl)
							ex		de,hl					; pointeur dans DE
							ld		hl,(posY_Golgoth)
							add		hl,bc
							ld		(posY_Golgoth),hl
						; test si la distance est déjà parcourue
							inc		de						; pointeur incrementé sur la valeur de distance
							ld		hl,Compteur_DistanceGolgoth_1		; adresse de la variable
							inc		(hl)								; on incrémente son contenue
							ld		b,(hl)								; et on recupère son contenu dans B
							ex		hl,de								; on repasse le pointeur dans HL
							ld		a,(hl)
							sub		a,b	
							call	z,Update_PointeurGolgoth_1
							inc		hl
							
							ld		iy,(PointeurUpdateGolgoth)
							call	$+3			; equivalent à push PC met l'adresse courante (PC) dans la pile
							jp		(iy)
						;	la routine pointé par jp(iy) modifie la valeur de retour de la pile de 2 octets 
								
							call 	test_collisions_avec_les_Golgoths_G
							call 	test_collisions_avec_les_Golgoths_D
							call	test_collisions_tir_gauche_golgoth
							call	test_collisions_tir_droite_golgoth
							ret
								Update_PointeurGolgoth_1
									inc		hl
									inc		hl
									ld		(Pointeur_TblGolgoth_1),hl
									xor		a
									ld		(Compteur_DistanceGolgoth_1),a
									ld		c,(hl)
									inc		hl
									ld		b,(hl)
									ex		de,hl			; pointeur dans DE
									ld		l,c
									ld		h,b
									or		a
									ld		bc,#FFFF
									sbc		hl,bc
									ex		hl,de			; pointeur dans HL
									jr		z,Reinit_PointeurGolgoth_1
									ret
										Reinit_PointeurGolgoth_1
											ld		hl,Tbl_Gologoth1
; ----> AJOUT : mini boss, il reboucle sur son tableau à lui
	ld		a,(flag_miniboss)
	or		a
	jr		z,Reinit_PointeurGolgoth_suite
	ld		hl,Tbl_MiniBoss
Reinit_PointeurGolgoth_suite
											ld		(Pointeur_TblGolgoth_1),hl
											ret
; ///////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ////////////////////////////  MINI BOSS  /////////////////////////
; //////////////////////////////////////////////////////////////////
; ----> AJOUT : mini boss de 4 sprites hard (2 x 2) qui passe entre 2 vagues de soucoupes. Il arrive
;       par mini_boss_arrive (fin de vague), se déplace et tire avec les routines du golgoth 1.
; son déplacement : dw vitesse X, vitesse Y, nombre de pas  (très vite de gauche à droite)
Tbl_MiniBoss
	dw		MINIBOSS_VITESSE,0,MINIBOSS_NBR_PAS
	dw		-MINIBOSS_VITESSE,0,MINIBOSS_NBR_PAS
	dw		#FFFF
; ses 4 sprites : 6 et 7 en haut, 8 et 9 en dessous
Update_MiniBoss
	pop		de
	inc		de
	inc		de
	push	de
	rst		ASIC_CONNEXION
	ld		hl,(posX_Golgoth)
	ld		(SPRH6_X),hl
	ld		(SPRH8_X),hl
	ld		de,32
	add		hl,de
	ld		(SPRH7_X),hl
	ld		(SPRH9_X),hl
	ld		hl,(posY_Golgoth)
	ld		(SPRH6_Y),hl
	ld		(SPRH7_Y),hl
	ld		de,16
	add		hl,de
	ld		(SPRH8_Y),hl
	ld		(SPRH9_Y),hl
	ret
; sa mort : on éteint tout, on efface ses évènements et les vagues reprennent
MiniBoss_Est_Mort
	xor		a
	ld		(flag_miniboss),a
	ld		(flag_boss),a
	ld		(EtpGolgoth),a
	ld		(VitesseAnimGolgoth),a
	ld		(Etp_Anim_Golgoth),a
	ld		(flag_MortGolgoth),a
	ld		(Etp_ExploseGolgoth),a
	ld		(Compteur_DistanceGolgoth_1),a
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
	ld		hl,event_golgoth
	ld		b,31
MiniBoss_efface_events
	ld		(hl),a
	inc		hl
	djnz	MiniBoss_efface_events
; l'explosion s'est servie des registres secondaires, qui contiennent le score pendant le jeu :
; on les recharge comme au début d'un level (on est encore dans le jeu secondaire ici)
	ld		a,(Counter_score+4)
	ld		c,a
	ld		a,(Counter_score+3)
	ld		d,a
	ld		a,(Counter_score+2)
	ld		e,a
	ld		a,(Counter_score+1)
	ld		h,a
	ld		a,(Counter_score)
	ld		l,a
	exx
	ret
Update_Golgoth
	pop		de
	inc		de
	inc		de
	push	de
		Update_Golgoth_after
			rst		ASIC_CONNEXION
			ld		hl,(posX_Golgoth)
			ld		(SPRH8_X),hl
			ld		de,32
			add		hl,de
			ld		(SPRH6_X),hl
			ld		(SPRH7_X),hl
			ld		de,32
			add		hl,de
			ld		(SPRH9_X),hl
			ld		hl,(posY_Golgoth)
			ld		(SPRH6_Y),hl
			ld		de,16
			add		hl,de
			ld		(SPRH8_Y),hl
			ld		(SPRH9_Y),hl
			ld		de,16
			add		hl,de
			ld		(SPRH7_Y),hl
			ret
; ///////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////	
Explose_Golgoth
;ret
; on indique par un flag que le goLOGOTH EST MORT
	rst		ASIC_CONNEXION
	ld		a,(Compteur_ExploseGolgoth)
	inc		a
	ld		(Compteur_ExploseGolgoth),a
	cp		a,VITESSE_EXPLOSE_GOLGOTH
	RET		NZ
	xor		a
	ld		(Compteur_ExploseGolgoth),a
	ld		a,1
	ld		(flag_MortGolgoth),a
	exx
	ld		a,(Etp_ExploseGolgoth)
	cp		a,0
	jr		z,.InitExplosion
	cp		a,1
	jr		z,.EtpExplosion1
		.InitExplosion
			inc		a
			ld		(Etp_ExploseGolgoth),a
			ld		hl,BOOM_SPRH_ROM_ADR
			ld		(GolgothBoomAdrRom),hl
			ld		de,SPRH6_ADR
			ld		(GolgothSprh),de
			ld		iy,#100
			ld		(GolgothLongeur),iy
			ld		bc,SPRH6_ZOOM
			exx
			ret
		.EtpExplosion1
			inc		h
			ld		(GolgothBoomAdrRom),hl
			ld		a,h
			cp		a,#C5
			jp		z,.EtpExplosionFin
			exx
			ret
				.EtpExplosionFin
					xor		a
					ld		(Etp_ExploseGolgoth),a
					ld		(bc),a
					inc		d
					ld		(GolgothSprh),de
					ld		a,d
					cp		a,#4A
					jp		z,GolgothMort
					ld		a,(Etp_ExploseGolgoth)
					inc		a
					ld		(Etp_ExploseGolgoth),a
					ld		hl,BOOM_SPRH_ROM_ADR
					ld		(GolgothBoomAdrRom),hl
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					exx
					ld 		a,SFX_BOOM_GOLGOTH	;Sound effect number (>=1)
					ld 		c,SFX_CHANNEL_EXPLODE_GOLGOTH 					;channel (0-2)
					ld 		b,SFX_VOLUME 					;Inverted volume (0-16)
					call 	PLY_AKG_PlaySoundEffect
					jp		ASIC_DECONNEXION
							
						GolgothMort
; ----> AJOUT : la mort du mini boss ne termine pas le level, on retourne aux vagues
	ld		a,(flag_miniboss)
	or		a
	jp		nz,MiniBoss_Est_Mort
							call Un_Golgoth_Est_Mort
						
							ret
	
Tbl_Gologoth1
; X, Y, nbr_frame
; direction bas droite
	dw	4,4,10
	dw	4,2,10
	dw	4,1,10
	dw	4,1,10
	dw	4,0,10
	dw	4,0,10
	dw	4,-1,10
	dw	4,-1,10
	dw	4,-2,10
	dw	4,-4,10

; X, Y, nbr_frame
; direction haut droite
	dw	-4,4,10
	dw	-4,2,10
	dw	-4,1,10
	dw	-4,1,10
	dw	-4,0,10
	dw	-4,0,10
	dw	-4,-1,10
	dw	-4,-1,10
	dw	-4,-2,10
	dw	-4,-4,10

; X, Y, nbr_frame
; direction droite
	dw	4,0,70	

; X, Y, nbr_frame
; courbe jusqu'en bas de l'écran
	dw	4,1,10
	dw	2,2,10
	dw	0,2,10
	dw -2,3,10
	dw -2,2,10
	dw -2,1,10
	dw -8,1,15
	dw -4,1,10
	dw -2,1,10
	dw -2,2,10
	dw -4,3,10
	dw -4,0,10


; direction haut en legere
	dw	0,-4,20
	dw  2,-4,10
	dw  4,-4,10
	dw  4,-1,10
	dw  4,0,10
	dw  4, 1, 10
	dw  2, 2, 10
	dw  0, 2, 10
	dw -2,2,10
	dw -4,-2,10
	dw -4,-1,10
	dw -2,-1,5
	dw -2, -2, 10
	dw -2, -2, 10
	dw -4,-2,10

; dernière boucle
	dw 4,4,10
	dw 4,2,10
	dw 4,2,10
	dw 2,2,10
	dw 2,3,15
	dw 4,4,10
	dw 4,2,10
	dw 4,0,10
	dw 4,-1,10
	dw 2,-2,10
	dw 0,-2,15
	dw -2,-2,10
	dw -6,-2,15
	dw -4,-1,10
	dw -4,0,10
	dw	-4,-1,10
	dw	-4,-1,10
	dw	-4,-2,10
	dw	-5,-4,10

	dw	#FFFF




; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////                GOLGOTH 2          /////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
Update_Golgoth2
	pop		de
	inc		de
	inc		de
	push	de
		Update_Golgoth2_after	
			rst		ASIC_CONNEXION
			ld		hl,(posX_Golgoth)
			ld		(SPRH6_X),hl
			ld		(SPRH8_X),hl
			ld		de,64
			add		hl,de
			ld		(SPRH7_X),hl
			ld		(SPRH9_X),hl
		
			ld		hl,(posY_Golgoth)
			ld		(SPRH6_Y),hl
			ld		(SPRH7_Y),hl
			ld		de,16
			add		hl,de
			ld		(SPRH8_Y),hl
			ld		(SPRH9_Y),hl
			ret
	
Tbl_Gologoth2
; direction X + direction Y + nombre de frame
	dw	2,-2,10
	dw 4,-2,10
	dw 8,-1,10
	dw 8,0,10
	dw 8,1,10
	dw 4,2,10
	dw 2,2,10
	dw 2,2,10
	dw 0,2,10
	dw -2,4,10
	dw -2,2,10
	dw -4,2,10
	dw -4,1,10
	dw -8,0,10
	dw -8,-1,10
	dw -4,-1,10
	dw -4,-2,10
	dw -2,-2,10
	dw 0,-2,10
	dw 2,-2,10
	dw 4,-2,10
	dw 8,-2,10
	dw 8,0,10
	dw 8,2,10
	dw 2,2,10
	dw 0,2,10
	dw -2,4,10
	dw -4,-2,10
	dw -4,-1,10
	dw -8,0,10
	dw -4,-1,10
	dw -4,-2,10
	dw -2,-2,10
	dw 0,-2,10
	dw 4,-2,10
	dw 8,-1,10
	dw 4,0,10
	dw 4,2,10
	dw 2,2,10
	dw 2,-1,10
	dw -4,-1,10
	dw -4,0,10
	dw -4,-1,10
	dw -8,0,10
	dw -4,-4,10
	dw	#FFFF



; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////                GOLGOTH 3          /////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
golgoth_3_ROM
	ld		a,(EtpGolgoth)
	cp		a,1
	jp		z,Anim_Golgoth3
	cp		a,2
	jp		z,Explose_Golgoth3
		Anim_Golgoth3
			ld		a,(VitesseAnimGolgoth)
			inc		a
			ld		(VitesseAnimGolgoth),a
			cp		a,VITESSE_ANIM_GOLGOTH
			jp		nz,Deplacement_Golgoth3
			xor		a
			ld		(VitesseAnimGolgoth),a
			call	Deplacement_Golgoth3
			ld		a,(Etp_Anim_Golgoth)
			cp		a,0
			jr		z,.Anim_0_Golgoth
			cp		a,1
			jr		z,.Anim_1_Golgoth
			cp		a,2
			jr		z,.Anim_2_Golgoth
			cp		a,3
			jr		z,.Anim_1_Golgoth
			cp		a,4
			jr		z,.Anim_Fin
				.Anim_0_Golgoth
					inc		a
					ld		(Etp_Anim_Golgoth),a
					ld		hl,(Tbl_Golgoth3_anim)
					ld		(Golgoth_Tete_AdrRom),hl
					ld		hl,SPRH10_ADR
					ld		(Golgoth_Tete_Sprh),hl
					ld		hl,(Tbl_Golgoth3_anim+2)
					ld		(Golgoth_Queue_AdrRom),hl
					ld		hl,SPRH12_ADR
					ld		(Golgoth_Queue_Sprh),hl
					ret
				.Anim_1_Golgoth
					inc		a
					ld		(Etp_Anim_Golgoth),a
					ld		hl,(Tbl_Golgoth3_anim+4)
					ld		(Golgoth_Tete_AdrRom),hl
					ld		hl,SPRH10_ADR
					ld		(Golgoth_Tete_Sprh),hl
					ld		hl,(Tbl_Golgoth3_anim+6)
					ld		(Golgoth_Queue_AdrRom),hl
					ld		hl,SPRH12_ADR
					ld		(Golgoth_Queue_Sprh),hl
					ret
				.Anim_2_Golgoth
					inc		a
					ld		(Etp_Anim_Golgoth),a
					ld		hl,(Tbl_Golgoth3_anim+8)
					ld		(Golgoth_Tete_AdrRom),hl
					ld		hl,SPRH10_ADR
					ld		(Golgoth_Tete_Sprh),hl
					ld		hl,(Tbl_Golgoth3_anim+10)
					ld		(Golgoth_Queue_AdrRom),hl
					ld		hl,SPRH12_ADR
					ld		(Golgoth_Queue_Sprh),hl
					ret
				.Anim_Fin
					xor		a
					ld		(Etp_Anim_Golgoth),a
					ret
									
						Deplacement_Golgoth3
						; modification de la direction X du Golgoth
							ld		hl,(Pointeur_TblGolgoth_1)
							ld		c,(hl)
							inc		hl
							ld		b,(hl)					; décalage dans BC
							ex		de,hl
							ld		hl,(posX_Golgoth)
							add		hl,bc
							ld		(posX_Golgoth),hl		; resultat
						; modification de la direction Y du Golgoth
							ex		hl,de					; Pointeur dans HL
							inc		hl
							ld		c,(hl)
							inc		hl
							ld		b,(hl)
							ex		de,hl					; pointeur dans DE
							ld		hl,(posY_Golgoth)
							add		hl,bc
							ld		(posY_Golgoth),hl
						; test si la distance est déjà parcourue
							inc		de						; pointeur incrementé sur la valeur de distance
							ld		hl,Compteur_DistanceGolgoth_3		; adresse de la variable
							inc		(hl)								; on incrémente son contenue
							ld		b,(hl)								; et on recupère son contenu dans B
							ex		hl,de								; on repasse le pointeur dans HL
							ld		a,(hl)
							sub		a,b	
							call	z,Update_PointeurGolgoth_3
							inc		hl
							ld		iy,(PointeurUpdateGolgoth)
							call	$+3			; equivalent à push PC met l'adresse courante (PC) dans la pile
							jp		(iy)
						;	la routine pointé par jp(iy) modifie la valeur de retour de la pile de 2 octets 
								
							call 	test_collisions_avec_les_Golgoths_G
							call 	test_collisions_avec_les_Golgoths_D
							call	test_collisions_tir_gauche_golgoth
							call	test_collisions_tir_droite_golgoth
							ret
								Update_PointeurGolgoth_3
									inc		hl
									inc		hl
									ld		(Pointeur_TblGolgoth_1),hl
									xor		a
									ld		(Compteur_DistanceGolgoth_3),a
									ld		c,(hl)
									inc		hl
									ld		b,(hl)
									ex		de,hl			; pointeur dans DE
									ld		l,c
									ld		h,b
									or		a
									ld		bc,#FFFF
									sbc		hl,bc
									ex		hl,de			; pointeur dans HL
									jr		z,Reinit_PointeurGolgoth_3
									ret
										Reinit_PointeurGolgoth_3
											ld		hl,Tbl_Gologoth3
											ld		(Pointeur_TblGolgoth_1),hl
											ret
; ///////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
Explose_Golgoth3
;ret
; on indique par un flag que le goLOGOTH EST MORT
	rst		ASIC_CONNEXION
	ld		a,(Compteur_ExploseGolgoth)
	inc		a
	ld		(Compteur_ExploseGolgoth),a
	cp		a,VITESSE_EXPLOSE_GOLGOTH
	RET		NZ
	xor		a
	ld		(Compteur_ExploseGolgoth),a
	ld		a,1
	ld		(flag_MortGolgoth),a
	exx
	ld		a,(Etp_ExploseGolgoth)
	cp		a,0
	jr		z,.InitExplosion
	cp		a,1
	jr		z,.EtpExplosion1
		.InitExplosion
			inc		a
			ld		(Etp_ExploseGolgoth),a
			ld		hl,BOOM_SPRH_ROM_ADR
			ld		(GolgothBoomAdrRom),hl
			ld		de,SPRH6_ADR
			ld		(GolgothSprh),de
			ld		iy,#100
			ld		(GolgothLongeur),iy
			ld		bc,SPRH6_ZOOM
			exx
			ret
		.EtpExplosion1
			inc		h
			ld		(GolgothBoomAdrRom),hl
			ld		a,h
			cp		a,#C5
			jp		z,.EtpExplosionFin
			exx
			ret
				.EtpExplosionFin
					xor		a
					ld		(Etp_ExploseGolgoth),a
					ld		(bc),a
					inc		d
					ld		(GolgothSprh),de
					ld		a,d
					cp		a,#4A
					jp		z,GolgothMort3
					ld		a,(Etp_ExploseGolgoth)
					inc		a
					ld		(Etp_ExploseGolgoth),a
					ld		hl,BOOM_SPRH_ROM_ADR
					ld		(GolgothBoomAdrRom),hl
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					exx
					ld 		a,SFX_BOOM_GOLGOTH	;Sound effect number (>=1)
					ld 		c,SFX_CHANNEL_EXPLODE_GOLGOTH 					;channel (0-2)
					ld 		b,SFX_VOLUME 					;Inverted volume (0-16)
					call 	PLY_AKG_PlaySoundEffect
					jp		ASIC_DECONNEXION
							
						GolgothMort3
							call Un_Golgoth_Est_Mort
							ret


Update_Golgoth3
	pop		de
	inc		de
	inc		de
	push	de
		Update_Golgoth3_after	
			rst		ASIC_CONNEXION
			ld		hl,(posX_Golgoth)
			ld		(SPRH6_X),hl
			ld		(SPRH8_X),hl
			ld		(SPRH10_X),hl
			ld		de,64
			add		hl,de
			ld		(SPRH7_X),hl
			ld		(SPRH9_X),hl
			ld		(SPRH11_X),hl
			ld		de,-32
			add		hl,de
			ld		(SPRH12_X),hl
			ld		hl,(posY_Golgoth)
			ld		(SPRH6_Y),hl
			ld		(SPRH7_Y),hl
			ld		de,16
			add		hl,de
			ld		(SPRH8_Y),hl
			ld		(SPRH9_Y),hl
			ld		de,16
			add		hl,de
			ld		(SPRH10_Y),hl
			ld		(SPRH11_Y),hl
			ld		de,-32+-16
			add		hl,de
			ld		(SPRH12_Y),hl
			ret


	
Tbl_Gologoth3
dw 8,1,10
dw 4,1,10
dw 4,2,10
dw 2,2,10
dw 0,2,10
dw 4,1,10
dw 4,0,10
dw 8,1,10
dw 4,2,10
dw 0,2,10
dw -4,2,10
dw -4,-2,10
dw -2,-2,10
dw -2,-2,10
dw -2,0,10

dw -2,2,10
dw -2,2,10
dw -4,2,10
dw -4,0,10
dw -4,-2,10
dw 0,-2,10
dw 4,-2,10
dw 8,-1,10
dw 4,-1,10
dw 0,-2,10
dw 2,-2,10
dw 4,-2,10
dw 4,-1,10
dw 8,-1,10

dw -4,0,100

dw #FFFF
	


; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////                GOLGOTH 4          /////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
golgoth_4_ROM
	ld		a,(EtpGolgoth)
	cp		a,1
	jp		z,.Anim_Golgoth
	cp		a,2
	jp		z,Explose_Golgoth4
		.Anim_Golgoth
			ld		a,(VitesseAnimGolgoth)
			inc		a
			ld		(VitesseAnimGolgoth),a
			cp		a,VITESSE_ANIM_GOLGOTH4
			jp		nz,Deplacement_Golgoth4
			xor		a
			ld		(VitesseAnimGolgoth),a
			call	Deplacement_Golgoth4
			ld		a,(Etp_Anim_Golgoth)
			cp		a,0
			jr		z,.Anim_0_Golgoth
			cp		a,1
			jr		z,.Anim_1_Golgoth
			cp		a,2
			jr		z,.Anim_2_Golgoth
			cp		a,3
			jr		z,.Anim_1_Golgoth
			cp		a,4
			jp		z,.Anim_Fin
				.Anim_0_Golgoth
					inc		a
					ld		(Etp_Anim_Golgoth),a
					ld		hl,GOLGOTH4_SPRH_ADR_ROM_ANIM1
					ld		(GolgothAdrRom),hl
					ld		hl,SPRH6_ADR
					ld		(GolgothSprh),hl
					ld		hl,#800
					ld		(GolgothLongeur),hl
					ld		a,(FlagAnimGolgoth4_marche)
					cp		a,1
					RET		NZ
					ld		hl,#400
					ld		(GolgothLongeur),hl
					ld		hl,GOLGOTH4_SPRH_ADR_ROM_MARCHE			; +#200
					ld		(GolgothAdrRom_MarcheG),hl
					ld		hl,GOLGOTH4_SPRH_ADR_ROM_ANIM1+#500		; +#200
					ld		(GolgothAdrRom_MarcheD),hl
					ret
				.Anim_1_Golgoth
					inc		a
					ld		(Etp_Anim_Golgoth),a
					ld		hl,GOLGOTH4_SPRH_ADR_ROM_ANIM2
					ld		(GolgothAdrRom),hl
					ld		hl,SPRH6_ADR
					ld		(GolgothSprh),hl	
					ld		hl,#800
					ld		(GolgothLongeur),hl
					ld		a,(FlagAnimGolgoth4_marche)
					cp		a,1
					RET		NZ
					ld		hl,#400
					ld		(GolgothLongeur),hl
					ld		hl,GOLGOTH4_SPRH_ADR_ROM_ANIM2+#400			; +#200
					ld		(GolgothAdrRom_MarcheG),hl
					ld		hl,GOLGOTH4_SPRH_ADR_ROM_ANIM2+#500		; +#200
					ld		(GolgothAdrRom_MarcheD),hl
					ret
				.Anim_2_Golgoth
					inc		a
					ld		(Etp_Anim_Golgoth),a
					ld		hl,GOLGOTH4_SPRH_ADR_ROM_ANIM3
					ld		(GolgothAdrRom),hl
					ld		hl,SPRH6_ADR
					ld		(GolgothSprh),hl
					ld		hl,#800
					ld		(GolgothLongeur),hl
					ld		a,(FlagAnimGolgoth4_marche)
					cp		a,1
					RET		NZ
					ld		hl,#400
					ld		(GolgothLongeur),hl
					ld		hl,GOLGOTH4_SPRH_ADR_ROM_MARCHE+#100			; +#200
					ld		(GolgothAdrRom_MarcheD),hl
					ld		hl,GOLGOTH4_SPRH_ADR_ROM_ANIM3+#400		; +#200
					ld		(GolgothAdrRom_MarcheG),hl
					ret
				.Anim_Fin
					xor		a
					ld		(Etp_Anim_Golgoth),a
					ret
									
						Deplacement_Golgoth4
						; modification de la direction X du Golgoth
							ld		hl,(Pointeur_TblGolgoth_1)
							ld		c,(hl)
							inc		hl
							ld		b,(hl)					; décalage dans BC
							ex		de,hl
							ld		hl,(posX_Golgoth)
							add		hl,bc
							ld		(posX_Golgoth),hl		; resultat
						; modification de la direction Y du Golgoth
							ex		hl,de					; Pointeur dans HL
							inc		hl
							ld		c,(hl)
							inc		hl
							ld		b,(hl)
							ex		de,hl					; pointeur dans DE
							ld		hl,(posY_Golgoth)
							add		hl,bc
							ld		(posY_Golgoth),hl
						; test si la distance est déjà parcourue
							inc		de						; pointeur incrementé sur la valeur de distance
							ld		hl,Compteur_DistanceGolgoth_4		; adresse de la variable
							inc		(hl)								; on incrémente son contenue
							ld		b,(hl)								; et on recupère son contenu dans B
							ex		hl,de								; on repasse le pointeur dans HL
							ld		a,(hl)
							sub		a,b	
							call	z,Update_PointeurGolgoth_4
							inc		hl
							ld		iy,(PointeurUpdateGolgoth)
							call	$+3			; equivalent à push PC met l'adresse courante (PC) dans la pile
							jp		(iy)
						;	la routine pointé par jp(iy) modifie la valeur de retour de la pile de 2 octets 
								
							call 	test_collisions_avec_les_Golgoths_G
							call 	test_collisions_avec_les_Golgoths_D
							call 	test_collisions_supplementaire_avec_les_Golgoths_G
							call 	test_collisions_supplementaire_avec_les_Golgoths_D

							
							call	test_collisions_tir_gauche_golgoth
							call	test_collisions_tir_droite_golgoth
							ret
								Update_PointeurGolgoth_4
									inc		hl
									inc		hl
									ld		(Pointeur_TblGolgoth_1),hl
									xor		a
									ld		(Compteur_DistanceGolgoth_4),a
									ld		c,(hl)
									inc		hl
									ld		b,(hl)
									ex		de,hl			; pointeur dans DE
									ld		l,c
									ld		h,b
									ld		ix,bc
									or		a
									ld		bc,#FFFF
									sbc		hl,bc
									ex		hl,de			; pointeur dans HL
									jr		z,Change_PointeurGolgoth_4
									or		a
									push	ix
									ld		bc,#FFFE
									ex		hl,de			; pointeur dans DE
									pop		hl
									sbc		hl,bc
									ex		hl,de			; pointeur dans HL
									jr		z,Reinit_PointeurGolgoth_4
									ret
										Change_PointeurGolgoth_4
											ld		hl,Tbl_Gologoth4_bis
											ld		(Pointeur_TblGolgoth_1),hl
											ld		a,1
											ld		(FlagAnimGolgoth4_marche),a
											ret
												Reinit_PointeurGolgoth_4
													ld		hl,Tbl_Gologoth4
													ld		(Pointeur_TblGolgoth_1),hl
													ld		a,0
													ld		(FlagAnimGolgoth4_marche),a
													ret
; ///////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
Explose_Golgoth4
;ret
; on indique par un flag que le goLOGOTH EST MORT
	rst		ASIC_CONNEXION
	ld		a,(Compteur_ExploseGolgoth)
	inc		a
	ld		(Compteur_ExploseGolgoth),a
	cp		a,VITESSE_EXPLOSE_GOLGOTH
	RET		NZ
	xor		a
	ld		(Compteur_ExploseGolgoth),a
	ld		a,1
	ld		(flag_MortGolgoth),a
	exx
	ld		a,(Etp_ExploseGolgoth)
	cp		a,0
	jr		z,.InitExplosion
	cp		a,1
	jr		z,.EtpExplosion1
		.InitExplosion
			inc		a
			ld		(Etp_ExploseGolgoth),a
			ld		hl,BOOM_SPRH_ROM_ADR
			ld		(GolgothBoomAdrRom),hl
			ld		de,SPRH6_ADR
			ld		(GolgothSprh),de
			ld		iy,#100
			ld		(GolgothLongeur),iy
			ld		bc,SPRH6_ZOOM
			exx
			ret
		.EtpExplosion1
			inc		h
			ld		(GolgothBoomAdrRom),hl
			ld		a,h
			cp		a,#C5
			jp		z,.EtpExplosionFin
			exx
			ret
				.EtpExplosionFin
					xor		a
					ld		(Etp_ExploseGolgoth),a
					ld		(bc),a
					inc		d
					ld		(GolgothSprh),de
					ld		a,d
					cp		a,#4A
					jp		z,GolgothMort4
					ld		a,(Etp_ExploseGolgoth)
					inc		a
					ld		(Etp_ExploseGolgoth),a
					ld		hl,BOOM_SPRH_ROM_ADR
					ld		(GolgothBoomAdrRom),hl
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					exx
					ld 		a,SFX_BOOM_GOLGOTH	;Sound effect number (>=1)
					ld 		c,SFX_CHANNEL_EXPLODE_GOLGOTH					;channel (0-2)
					ld 		b,SFX_VOLUME 					;Inverted volume (0-16)
					call 	PLY_AKG_PlaySoundEffect
					jp		ASIC_DECONNEXION
							
						GolgothMort4
							call Un_Golgoth_Est_Mort
														; on précise que cette fin de level fait appel à un level 'big boss'
							ld		a,1
							ld		(flag_bigboss),a
							ld  hl,BIGBOSS1_SPRH_ADR_ROM
							ld (adrBigbossSpriteROM),hl
							ret


Update_Golgoth4
	pop		de
	inc		de
	inc		de
	push	de
		Update_Golgoth4_after	
			rst		ASIC_CONNEXION
			ld		hl,(posX_Golgoth)
			ld		(SPRH6_X),hl
			ld		(SPRH8_X),hl
			ld		(SPRH10_X),hl
			ld		(SPRH12_X),hl
			ld		de,64
			add		hl,de
			ld		(SPRH7_X),hl
			ld		(SPRH9_X),hl
			ld		(SPRH11_X),hl
			ld		(SPRH13_X),hl

			ld		hl,(posY_Golgoth)
			ld		(SPRH6_Y),hl
			ld		(SPRH7_Y),hl
			ld		de,16
			add		hl,de
			ld		(SPRH8_Y),hl
			ld		(SPRH9_Y),hl
			ld		de,16
			add		hl,de
			ld		(SPRH10_Y),hl
			ld		(SPRH11_Y),hl
			ld		de,16
			add		hl,de
			ld		(SPRH12_Y),hl
			ld		(SPRH13_Y),hl
			ret


	
	Tbl_Gologoth4
	; direction X + direction Y + nombre de frame
		dw	0,0,100
		dw	#FFFF
	Tbl_Gologoth4_bis
		dw	0,2,40
		dw	0,-2,40
		dw	0,0,10
		dw	8,2,50
		dw	0,-4,25
		dw	-8,2,50
		dw	0,0,5
		dw	0,-4,25
		dw	-8,-2,25
		dw	-4,1,50
		dw 8,2,25
		dw 4,-1,50
		dw	#FFFE
	
	
		
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////                GOLGOTH 5          /////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
golgoth_5_ROM
	ld		a,(EtpGolgoth)
	cp		a,1
	jp		z,.Anim_Golgoth
	cp		a,2
	jp		z,Explose_Golgoth5
		.Anim_Golgoth
			ld		a,(FlagGolgoth_Ferme)
			cp		a,ouvert
			ret		z
		
		
		
			ld		a,(VitesseAnimGolgoth)
			inc		a
			ld		(VitesseAnimGolgoth),a
			cp		a,VITESSE_ANIM_GOLGOTH5
			jp		nz,Deplacement_Golgoth5
			xor		a
			ld		(VitesseAnimGolgoth),a
			call	Deplacement_Golgoth5
			ld		a,(Etp_Anim_Golgoth)
			cp		a,0
			jr		z,.Anim_0_Golgoth
			cp		a,1
			jr		z,.Anim_1_Golgoth
			cp		a,2
			jp		z,.Anim_Fin
				.Anim_0_Golgoth
					inc		a
					ld		(Etp_Anim_Golgoth),a
					ld		hl,GOLGOTH5_SPRH_ADR_ROM_ANIM_IN1
					ld		(GolgothAdrRom),hl
					ld		hl,SPRH6_ADR
					ld		(GolgothSprh),hl
					ld		hl,#600
					ld		(GolgothLongeur),hl
					ret
				.Anim_1_Golgoth
					inc		a
					ld		(Etp_Anim_Golgoth),a
					ld		hl,GOLGOTH5_SPRH_ADR_ROM_ANIM_IN2
					ld		(GolgothAdrRom),hl
					ld		hl,SPRH6_ADR
					ld		(GolgothSprh),hl	
					ld		hl,GOLGOTH5_SPRH_ADR_ROM_ANIM_IN2+#100
					ld		(GolgothAdrRom2),hl
					ld		hl,SPRH8_ADR
					ld		(GolgothSprh2),hl	
					ld		hl,#100
					ld		(GolgothLongeur),hl
					ret
				.Anim_Fin
					xor		a
					ld		(Etp_Anim_Golgoth),a
					ret
									
						Deplacement_Golgoth5

							call 	test_collisions_avec_les_Golgoths_G
							call 	test_collisions_avec_les_Golgoths_D

						; modification de la direction X du Golgoth
							ld		hl,(Pointeur_TblGolgoth_1)
							ld		c,(hl)
							inc		hl
							ld		b,(hl)					; décalage dans BC
							ex		de,hl
							ld		hl,(posX_Golgoth)
							add		hl,bc
							ld		(posX_Golgoth),hl		; resultat
						; modification de la direction Y du Golgoth
							ex		hl,de					; Pointeur dans HL
							inc		hl
							ld		c,(hl)
							inc		hl
							ld		b,(hl)
							ex		de,hl					; pointeur dans DE
							ld		hl,(posY_Golgoth)
							add		hl,bc
							ld		(posY_Golgoth),hl
						; test si la distance est déjà parcourue
							inc		de						; pointeur incrementé sur la valeur de distance
							ld		hl,Compteur_DistanceGolgoth_5		; adresse de la variable
							inc		(hl)								; on incrémente son contenue
							ld		b,(hl)								; et on recupère son contenu dans B
							ex		hl,de								; on repasse le pointeur dans HL
							ld		a,(hl)
							sub		a,b	
							call	z,Update_PointeurGolgoth_5
							inc		hl
							ld		iy,(PointeurUpdateGolgoth)
							call	$+3			; equivalent à push PC met l'adresse courante (PC) dans la pile
							jp		(iy)
						;	la routine pointé par jp(iy) modifie la valeur de retour de la pile de 2 octets 
								

							ld		a,(FlagGolgoth_Ferme)
							cp		a,ferme
							ret		z
								
							call	test_collisions_tir_gauche_golgoth
							call	test_collisions_tir_droite_golgoth
							ret
								Update_PointeurGolgoth_5
									inc		hl
									inc		hl
									ld		(Pointeur_TblGolgoth_1),hl
									xor		a
									ld		(Compteur_DistanceGolgoth_5),a
									ld		c,(hl)
									inc		hl
									ld		b,(hl)
									ex		de,hl			; pointeur dans DE
									ld		l,c
									ld		h,b
									ld		ix,bc

									or		a
									ld		bc,#FBFB
									sbc		hl,bc
									ex		hl,de			; pointeur dans HL
									jr		z,Change_PointeurGolgoth_5
									
									or		a
									push	ix
									pop		hl
									ld		bc,#FCFC
									sbc		hl,bc
									ex		hl,de			; pointeur dans HL
									jr		z,Change_PointeurGolgoth_5bis
									
									or		a
									push	ix
									pop		hl
									ld		bc,#FAFB
									sbc		hl,bc
									ex		hl,de			; pointeur dans HL
									jr		z,Change_PointeurGolgoth_5bisbis
									
									or		a
									push	ix
									pop		hl
									ld		bc,#FBFA
									sbc		hl,bc
									ex		hl,de			; pointeur dans HL
									jr		z,Change_PointeurGolgoth_5bisbisbis

									or		a
									push	ix
									ld		bc,#FAFA
									ex		hl,de			; pointeur dans DE
									pop		hl
									sbc		hl,bc
									ex		hl,de			; pointeur dans HL
									jr		z,Reinit_PointeurGolgoth_5bis


									or		a
									push	ix
									ld		bc,#FDFD
									ex		hl,de			; pointeur dans DE
									pop		hl
									sbc		hl,bc
									ex		hl,de			; pointeur dans HL
									jr		z,Reinit_PointeurGolgoth_5bisbis


									or		a
									push	ix
									ld		bc,#FCFD
									ex		hl,de			; pointeur dans DE
									pop		hl
									sbc		hl,bc
									ex		hl,de			; pointeur dans HL
									jr		z,Reinit_PointeurGolgoth_5bisbisbis

									or		a
									push	ix
									ld		bc,#FDFC
									ex		hl,de			; pointeur dans DE
									pop		hl
									sbc		hl,bc
									ex		hl,de			; pointeur dans HL
									jr		z,Reinit_PointeurGolgoth_5




									ret
										Change_PointeurGolgoth_5
											ld		hl,Tbl_first_stop_golgoth5
										jr	change_pointeurG5
										Change_PointeurGolgoth_5bis
											ld		hl,Tbl_second_stop_golgoth5
											jr	change_pointeurG5
										Change_PointeurGolgoth_5bisbis
											ld		hl,Tbl_third_stop_golgoth5
											jr	change_pointeurG5
										Change_PointeurGolgoth_5bisbisbis
											ld		hl,Tbl_fourth_stop_golgoth5
											jr	change_pointeurG5
											change_pointeurG5
											ld		(Pointeur_TblGolgoth_1),hl
											ld		a,ouvert
											ld		(FlagGolgoth_Ferme),a
											
											ret


												Reinit_PointeurGolgoth_5													
													ld		hl,Tbl_Gologoth5
													ld		(Pointeur_TblGolgoth_1),hl
													ld		a,ferme
													ld		(FlagGolgoth_Ferme),a
													xor		a
													ld		(Etp_Anim_Golgoth_Ouvert),a
													jp		on_reaffiche_les_missiles
													
												Reinit_PointeurGolgoth_5bis													
													ld		hl,Tbl_Gologoth5_bis
													ld		(Pointeur_TblGolgoth_1),hl
													ld		a,ferme
													ld		(FlagGolgoth_Ferme),a
													xor		a
													ld		(Etp_Anim_Golgoth_Ouvert),a
													jp		on_reaffiche_les_missiles
												Reinit_PointeurGolgoth_5bisbis													
													ld		hl,Tbl_Gologoth5_bisbis
													ld		(Pointeur_TblGolgoth_1),hl
													ld		a,ferme
													ld		(FlagGolgoth_Ferme),a
													xor		a
													ld		(Etp_Anim_Golgoth_Ouvert),a
													jp		on_reaffiche_les_missiles
												Reinit_PointeurGolgoth_5bisbisbis													
													ld		hl,Tbl_Gologoth5_bisbisbis
													ld		(Pointeur_TblGolgoth_1),hl
													ld		a,ferme
													ld		(FlagGolgoth_Ferme),a
													xor		a
													ld		(Etp_Anim_Golgoth_Ouvert),a
													jp		on_reaffiche_les_missiles


													on_reaffiche_les_missiles
													; call ASIC_CONNEXION
													; xor a
													; ld (SPRH13_ZOOM),a : ld (valeur_zoom_sprh13), a
													; ld (SPRH14_ZOOM),a : ld (valeur_zoom_sprh14), a
													; ld (SPRH15_ZOOM),a : ld (valeur_zoom_sprh15), a
													ret
; ///////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
Explose_Golgoth5
;ret
; on indique par un flag que le goLOGOTH EST MORT
	rst		ASIC_CONNEXION
	ld		a,(Compteur_ExploseGolgoth)
	inc		a
	ld		(Compteur_ExploseGolgoth),a
	cp		a,VITESSE_EXPLOSE_GOLGOTH
	RET		NZ
	xor		a
	ld		(Compteur_ExploseGolgoth),a
	ld		a,1
	ld		(flag_MortGolgoth),a
	exx
	ld		a,(Etp_ExploseGolgoth)
	cp		a,0
	jr		z,.InitExplosion
	cp		a,1
	jr		z,.EtpExplosion1
		.InitExplosion
			inc		a
			ld		(Etp_ExploseGolgoth),a
			ld		hl,BOOM_SPRH_ROM_ADR
			ld		(GolgothBoomAdrRom),hl
			ld		de,SPRH6_ADR
			ld		(GolgothSprh),de
			ld		iy,#100
			ld		(GolgothLongeur),iy
			ld		bc,SPRH6_ZOOM
			exx
			ret
		.EtpExplosion1
			inc		h
			ld		(GolgothBoomAdrRom),hl
			ld		a,h
			cp		a,#C5
			jp		z,.EtpExplosionFin
			exx
			ret
				.EtpExplosionFin
					xor		a
					ld		(Etp_ExploseGolgoth),a
					ld		(bc),a
					inc		d
					ld		(GolgothSprh),de
					ld		a,d
					cp		a,#4A
					jp		z,GolgothMort5
					ld		a,(Etp_ExploseGolgoth)
					inc		a
					ld		(Etp_ExploseGolgoth),a
					ld		hl,BOOM_SPRH_ROM_ADR
					ld		(GolgothBoomAdrRom),hl
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					exx
					ld 		a,SFX_BOOM_GOLGOTH	;Sound effect number (>=1)
					ld 		c,SFX_CHANNEL_EXPLODE_GOLGOTH 					;channel (0-2)
					ld 		b,SFX_VOLUME 					;Inverted volume (0-16)
					call 	PLY_AKG_PlaySoundEffect
					jp		ASIC_DECONNEXION
							
						GolgothMort5
							call Un_Golgoth_Est_Mort
							ret


Update_Golgoth5
	pop		de
	inc		de
	inc		de
	push	de
		Update_Golgoth5_after	
			rst		ASIC_CONNEXION
			ld		hl,(posX_Golgoth)
			ld		(SPRH6_X),hl
			ld		(SPRH8_X),hl
			ld		(SPRH10_X),hl
			ld		de,64
			add		hl,de
			ld		(SPRH7_X),hl
			ld		(SPRH9_X),hl
			ld		(SPRH11_X),hl
			
			ld		hl,(posY_Golgoth)
			ld		(SPRH6_Y),hl
			ld		(SPRH7_Y),hl
			ld		de,16
			add		hl,de
			ld		(SPRH8_Y),hl
			ld		(SPRH9_Y),hl
			ld		de,16
			add		hl,de
			ld		(SPRH10_Y),hl
			ld		(SPRH11_Y),hl
			ret


	
Tbl_Gologoth5
; direction X + direction Y + nombre de frame
	
	dw	2,2,10
	dw	4,1,10
	dw	4,0,10
	dw  4,-1,10
	dw	2,-2,10
	dw	-2,-2,10
	dw  -4,-1,10
	dw	-4,0,10
	dw	-4,1,10
	dw	-2,2,10

	dw 8,2,10

	dw	2,2,10
	dw	4,1,10
	dw	4,0,10
	dw  4,-1,10
	dw	2,-2,10
	dw	-2,-2,10
	dw  -4,-1,10
	dw	-4,0,10
	dw	-4,1,10
	dw	-2,2,10

	dw 8,2,10

	dw	2,2,10
	dw	4,1,10
	dw	4,0,10
	dw  4,-1,10
	dw	2,-2,10
	dw	-2,-2,10
	dw  -4,-1,10
	dw	-4,0,10
	dw	-4,1,10
	dw	-2,2,10
	
	dw 8,2,10

	dw	2,2,10
	dw	4,1,10
	dw	4,0,10
	dw  4,-1,10
	dw	2,-2,10
	dw	-2,-2,10
	dw  -4,-1,10
	dw	-4,0,10
	dw	-4,1,10
	dw	-2,2,10

	dw	-2,2,10
	dw	-4,1,10
	dw	-4,0,10
	dw  -4,-1,10
	dw	-2,-2,10
	dw	2,-2,10
	dw  4,-1,10
	dw	4,0,10
	dw	4,1,10
	dw	2,2,10
	dw -8,-4,10
	
	dw	-2,2,10
	dw	-4,1,10
	dw	-4,0,10
	dw  -4,-1,10
	dw	-2,-2,10
	dw	2,-2,10
	dw  4,-1,10
	dw	4,0,10
	dw	4,1,10
	dw	2,2,10

	dw -8,4,10
	
	dw	2,-2,10
	dw  -4,-1,10
	dw	4,0,10
	dw	4,-1,10
	dw	2,-2,10
	dw	-2,-2,10
	dw	-4,-1,10
	dw	-4,0,10
	dw  -4,1,10
	dw	-2,2,10

	dw	#FBFB

Tbl_Gologoth5_bis
; direction X + direction Y + nombre de frame
	
	dw	2,2,10
	dw	4,1,10
	dw	4,0,10
	dw  4,-1,10
	dw	2,-2,10
	dw	-2,-2,10
	dw  -4,-1,10
	dw	-4,0,10
	dw	-4,1,10
	dw	-2,2,10

	dw 8,4,10

	dw	2,4,15
	dw	4,2,15
	dw	4,0,15
	dw  4,-1,15
	dw	2,-2,15
	dw	-2,-2,10
	dw  -4,-1,10
	dw	-4,0,10
	dw	-4,1,10
	dw	-2,-2,10

	dw -4,2,10
	dw #FCFC

Tbl_Gologoth5_bisbis
; direction X + direction Y + nombre de frame
	
	dw	2,4,15
	dw	4,2,15
	dw	4,0,15
	dw  4,-2,15
	dw	2,-4,15
	dw	-2,-4,10
	dw  -4,-1,10
	dw	-4,0,10
	dw	-4,1,10
	dw	-2,4,10
	dw -8,2,20
	dw #FAFB



Tbl_Gologoth5_bisbisbis
; direction X + direction Y + nombre de frame
	
	dw	2,2,20
	dw	4,1,20
	dw	4,0,20
	dw  4,-1,20
	dw	2,-2,20
	dw	-2,-2,20
	dw  -4,-1,20
	dw	-4,0,20
	dw	-4,1,20
	dw	-2,2,20

	dw 8,4,20

	dw	2,2,20
	dw	4,1,20
	dw	4,0,20
	dw  4,-1,20
	dw	2,-2,20
	dw	-2,-2,20
	dw  -8,-1,20
	dw	-4,0,15
	dw	-8,-1,15
	dw	-4,-4,20

	dw -8,-4,10
	dw  4,2,5
	
	dw #FBFA

Tbl_first_stop_golgoth5
	dw	0,0,100
	dw	#FAFA
Tbl_second_stop_golgoth5
	dw	0,0,100
	dw	#FDFD
Tbl_third_stop_golgoth5
	dw	0,0,100
	dw	#FCFD
	
Tbl_fourth_stop_golgoth5
	dw	0,0,100
	dw	#FDFC
	
	
		
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////                GOLGOTH 6          /////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
golgoth_6_ROM
	ld		a,(EtpGolgoth)
	cp		a,1
	jp		z,Anim_Golgoth6
	cp		a,2
	jp		z,Explose_Golgoth6
		Anim_Golgoth6
			ld		a,(VitesseAnimGolgoth)
			inc		a
			ld		(VitesseAnimGolgoth),a
			cp		a,VITESSE_ANIM_GOLGOTH
			jp		nz,Deplacement_Golgoth6
			xor		a
			ld		(VitesseAnimGolgoth),a
			call	Deplacement_Golgoth6
			ld		a,(Etp_Anim_Golgoth)
			cp		a,0
			jr		z,.Anim_0_Golgoth
			cp		a,1
			jr		z,.Anim_1_Golgoth
			cp		a,2
			jr		z,.Anim_2_Golgoth
			cp		a,3
			jr		z,.Anim_1_Golgoth
			cp		a,4
			jr		z,.Anim_Fin
				.Anim_0_Golgoth
					inc		a
					ld		(Etp_Anim_Golgoth),a
					ld		hl,GOLGOTH6_SPRH_ADR_ROM_ANIM1
					ld		(GolgothAdrRom),hl
					ret
				.Anim_1_Golgoth
					inc		a
					ld		(Etp_Anim_Golgoth),a
					ld		hl,GOLGOTH6_SPRH_ADR_ROM_ANIM2
					ld		(GolgothAdrRom),hl
					ret
				.Anim_2_Golgoth
					inc		a
					ld		(Etp_Anim_Golgoth),a
					ld		hl,GOLGOTH6_SPRH_ADR_ROM_ANIM3
					ld		(GolgothAdrRom),hl
					ret
				.Anim_Fin
					xor		a
					ld		(Etp_Anim_Golgoth),a
					ret
									
						Deplacement_Golgoth6
						; modification de la direction X du Golgoth
							ld		hl,(Pointeur_TblGolgoth_1)
							ld		c,(hl)
							inc		hl
							ld		b,(hl)					; décalage dans BC
							ex		de,hl
							ld		hl,(posX_Golgoth)
							add		hl,bc
							ld		(posX_Golgoth),hl		; resultat
						; modification de la direction Y du Golgoth
							ex		hl,de					; Pointeur dans HL
							inc		hl
							ld		c,(hl)
							inc		hl
							ld		b,(hl)
							ex		de,hl					; pointeur dans DE
							ld		hl,(posY_Golgoth)
							add		hl,bc
							ld		(posY_Golgoth),hl
						; test si la distance est déjà parcourue
							inc		de						; pointeur incrementé sur la valeur de distance
							ld		hl,Compteur_DistanceGolgoth_6		; adresse de la variable
							inc		(hl)								; on incrémente son contenue
							ld		b,(hl)								; et on recupère son contenu dans B
							ex		hl,de								; on repasse le pointeur dans HL
							ld		a,(hl)
							sub		a,b	
							call	z,Update_PointeurGolgoth_6
							inc		hl
							ld		iy,(PointeurUpdateGolgoth)
							call	$+3			; equivalent à push PC met l'adresse courante (PC) dans la pile
							jp		(iy)
						;	la routine pointé par jp(iy) modifie la valeur de retour de la pile de 2 octets 
								
							call 	test_collisions_avec_les_Golgoths_G
							call 	test_collisions_avec_les_Golgoths_D
							call	test_collisions_tir_gauche_golgoth
							call	test_collisions_tir_droite_golgoth
							ret
								Update_PointeurGolgoth_6
									inc		hl
									inc		hl
									ld		(Pointeur_TblGolgoth_1),hl
									xor		a
									ld		(Compteur_DistanceGolgoth_6),a
									ld		c,(hl)
									inc		hl
									ld		b,(hl)
									ex		de,hl			; pointeur dans DE
									ld		l,c
									ld		h,b
									or		a
									ld		bc,#FFFF
									sbc		hl,bc
									ex		hl,de			; pointeur dans HL
									jr		z,Reinit_PointeurGolgoth_6
									ret
										Reinit_PointeurGolgoth_6
											ld		hl,Tbl_Gologoth6
											ld		(Pointeur_TblGolgoth_1),hl
											ret
; ///////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
Explose_Golgoth6
;ret
; on indique par un flag que le goLOGOTH EST MORT
	rst		ASIC_CONNEXION
	ld		a,(Compteur_ExploseGolgoth)
	inc		a
	ld		(Compteur_ExploseGolgoth),a
	cp		a,VITESSE_EXPLOSE_GOLGOTH
	RET		NZ
	xor		a
	ld		(Compteur_ExploseGolgoth),a
	ld		a,1
	ld		(flag_MortGolgoth),a
	exx
	ld		a,(Etp_ExploseGolgoth)
	cp		a,0
	jr		z,.InitExplosion
	cp		a,1
	jr		z,.EtpExplosion1
		.InitExplosion
			inc		a
			ld		(Etp_ExploseGolgoth),a
			ld		hl,BOOM_SPRH_ROM_ADR
			ld		(GolgothBoomAdrRom),hl
			ld		de,SPRH6_ADR
			ld		(GolgothSprh),de
			ld		iy,#100
			ld		(GolgothLongeur),iy
			ld		bc,SPRH6_ZOOM
			exx
			ret
		.EtpExplosion1
			inc		h
			ld		(GolgothBoomAdrRom),hl
			ld		a,h
			cp		a,#C5
			jp		z,.EtpExplosionFin
			exx
			ret
				.EtpExplosionFin
					xor		a
					ld		(Etp_ExploseGolgoth),a
					ld		(bc),a
					inc		d
					ld		(GolgothSprh),de
					ld		a,d
					cp		a,#4A
					jp		z,GolgothMort6
					ld		a,(Etp_ExploseGolgoth)
					inc		a
					ld		(Etp_ExploseGolgoth),a
					ld		hl,BOOM_SPRH_ROM_ADR
					ld		(GolgothBoomAdrRom),hl
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					exx
					ld 		a,SFX_BOOM_GOLGOTH	;Sound effect number (>=1)
					ld 		c,SFX_CHANNEL_EXPLODE_GOLGOTH 					;channel (0-2)
					ld 		b,SFX_VOLUME 					;Inverted volume (0-16)
					call 	PLY_AKG_PlaySoundEffect
					jp		ASIC_DECONNEXION
							
						GolgothMort6
							call 	Un_Golgoth_Est_Mort
							ret


Update_Golgoth6
	pop		de
	inc		de
	inc		de
	push	de
		Update_Golgoth6_after	
			rst		ASIC_CONNEXION
			ld		hl,(posX_Golgoth)
			ld		(SPRH6_X),hl
			ld		(SPRH8_X),hl
			ld		de,64
			add		hl,de
			ld		(SPRH7_X),hl
			ld		(SPRH9_X),hl
			ld		de,-32
			add		hl,de
			ld		(SPRH10_X),hl
			ld		hl,(posY_Golgoth)
			ld		(SPRH6_Y),hl
			ld		(SPRH7_Y),hl
			ld		de,16
			add		hl,de
			ld		(SPRH8_Y),hl
			ld		(SPRH9_Y),hl
			ld		de,16
			add		hl,de
			ld		(SPRH10_Y),hl
			ret
	
Tbl_Gologoth6
; direction X + direction Y + nombre de frame
	dw	4,0,100
	dw	-4,0,100
	dw	4,0,100
	dw	-4,0,100	
	dw	4,6,50
	dw	4,-6,50
	dw	-4,0,100
	
	dw	4,0,50
	dw	-4,0,50
	dw	8,0,50
	dw	-4,0,50	
	dw	-4,6,50
	dw	0,-6,50

	
	dw	#FFFF		

; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////                GOLGOTH 7          /////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
golgoth_7_ROM
	ld		a,(EtpGolgoth)
	cp		a,1
	jp		z,Anim_Golgoth7
	cp		a,2
	jp		z,Explose_Golgoth7
		Anim_Golgoth7
			ld		a,(VitesseAnimGolgoth)
			inc		a
			ld		(VitesseAnimGolgoth),a
			cp		a,VITESSE_ANIM_GOLGOTH
			jp		nz,Deplacement_Golgoth7
			xor		a
			ld		(VitesseAnimGolgoth),a
			call	Deplacement_Golgoth7
			ld		a,(Etp_Anim_Golgoth)
			cp		a,0
			jr		z,.Anim_0_Golgoth
			cp		a,1
			jr		z,.Anim_1_Golgoth
			cp		a,2
			jr		z,.Anim_Fin
				.Anim_0_Golgoth
					inc		a
					ld		(Etp_Anim_Golgoth),a
					ld		hl,GOLGOTH7_SPRH_ADR_ROM_ANIM1
					ld		(GolgothAdrRom),hl
					ret
				.Anim_1_Golgoth
					inc		a
					ld		(Etp_Anim_Golgoth),a
					ld		hl,GOLGOTH7_SPRH_ADR_ROM_ANIM2
					ld		(GolgothAdrRom),hl
					ret
				.Anim_Fin
					xor		a
					ld		(Etp_Anim_Golgoth),a
					ret
									
						Deplacement_Golgoth7
						; modification de la direction X du Golgoth
							ld		hl,(Pointeur_TblGolgoth_1)
							ld		c,(hl)
							inc		hl
							ld		b,(hl)					; décalage dans BC
							ex		de,hl
							ld		hl,(posX_Golgoth)
							add		hl,bc
							ld		(posX_Golgoth),hl		; resultat
						; modification de la direction Y du Golgoth
							ex		hl,de					; Pointeur dans HL
							inc		hl
							ld		c,(hl)
							inc		hl
							ld		b,(hl)
							ex		de,hl					; pointeur dans DE
							ld		hl,(posY_Golgoth)
							add		hl,bc
							ld		(posY_Golgoth),hl
						; test si la distance est déjà parcourue
							inc		de						; pointeur incrementé sur la valeur de distance
							ld		hl,Compteur_DistanceGolgoth_7		; adresse de la variable
							inc		(hl)								; on incrémente son contenue
							ld		b,(hl)								; et on recupère son contenu dans B
							ex		hl,de								; on repasse le pointeur dans HL
							ld		a,(hl)
							sub		a,b	
							call	z,Update_PointeurGolgoth_7
							inc		hl
							ld		iy,(PointeurUpdateGolgoth)
							call	$+3			; equivalent à push PC met l'adresse courante (PC) dans la pile
							jp		(iy)
						;	la routine pointé par jp(iy) modifie la valeur de retour de la pile de 2 octets 
								
							call 	test_collisions_avec_les_Golgoths_G
							call 	test_collisions_avec_les_Golgoths_D
							call	test_collisions_tir_gauche_golgoth
							call	test_collisions_tir_droite_golgoth
							ret
								Update_PointeurGolgoth_7
									inc		hl
									inc		hl
									ld		(Pointeur_TblGolgoth_1),hl
									xor		a
									ld		(Compteur_DistanceGolgoth_7),a
									ld		c,(hl)
									inc		hl
									ld		b,(hl)
									ex		de,hl			; pointeur dans DE
									ld		l,c
									ld		h,b
									or		a
									ld		bc,#FFFF
									sbc		hl,bc
									ex		hl,de			; pointeur dans HL
									jr		z,Reinit_PointeurGolgoth_7
									ret
										Reinit_PointeurGolgoth_7
											ld		hl,Tbl_Gologoth7
											ld		(Pointeur_TblGolgoth_1),hl

											ld		a,(compteur_presence_golgoth7)
											inc		a
											ld		(compteur_presence_golgoth7),a
											cp		a,1
											call	z,change_xy_golgoth7
											ret
									change_xy_golgoth7
										xor		a
										ld		(compteur_presence_golgoth7),a
										; on vérifie si on arrive au bout du tableau
										ld	hl,(pointeur_Tbl_Localisation_Golgoth7)
										ld	e,(hl)
										inc hl
										ld  d,(hl)										
										ex	hl,de
										or a
										ld	bc,#FAFA
										sbc	hl,bc
										call	z,reinit_pointeur_gologoth7
							; ld	hl,(pointeur_Tbl_Localisation_Golgoth7)
							; inc hl			
							; ld (pointeur_Tbl_Localisation_Golgoth7),hl
							; modification de la direction X du Golgoth
							ld		hl,(pointeur_Tbl_Localisation_Golgoth7)
							ld		c,(hl)
							inc		hl
							ld		b,(hl)					; décalage dans BC
							ex		de,hl
							ld		hl,(posX_Golgoth)
							add		hl,bc
							ld		(posX_Golgoth),hl		; resultat
						; modification de la direction Y du Golgoth
							ex		hl,de					; Pointeur dans HL
							inc		hl
							ld		c,(hl)
							inc		hl
							ld		b,(hl)
							ex		de,hl					; pointeur dans DE
							ld		hl,(posY_Golgoth)
							add		hl,bc
							ld		(posY_Golgoth),hl
							inc 	de
							ld 		(pointeur_Tbl_Localisation_Golgoth7),de
							ret
													

reinit_pointeur_gologoth7
ld	hl,Tbl_Golgoth7_localisation
ld (pointeur_Tbl_Localisation_Golgoth7),hl
ret

Tbl_Gologoth7
; direction X + direction Y + nombre de frame
	dw	2,1,10
	dw	-2,1,10
	dw	-2,-1,10
	dw	2,-1,10
	dw	#FFFF		

Tbl_Golgoth7_localisation
	dw	150,100
	dw	100,50
	dw	20,-100
	dw	-200,25
	dw	50,-50
	dw  -120,-25

	dw  300,75
	dw	-46,-12
	dw  -100, 56
	dw 46,-75
	dw 100,  12
	dw  -300,-56

	dw  300, 175
	dw  -78, -56
	dw  100, 53
	dw  -89, -45


	dw 78,-175
	dw -100, 45
	dw -300, -53
	dw 89, 56

	dw	#FAFA		
; ///////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
Explose_Golgoth7
;ret
; on indique par un flag que le goLOGOTH EST MORT
	rst		ASIC_CONNEXION
	ld		a,(Compteur_ExploseGolgoth)
	inc		a
	ld		(Compteur_ExploseGolgoth),a
	cp		a,VITESSE_EXPLOSE_GOLGOTH
	RET		NZ
	xor		a
	ld		(Compteur_ExploseGolgoth),a
	ld		a,1
	ld		(flag_MortGolgoth),a
	exx
	ld		a,(Etp_ExploseGolgoth)
	cp		a,0
	jr		z,.InitExplosion
	cp		a,1
	jr		z,.EtpExplosion1
		.InitExplosion
			inc		a
			ld		(Etp_ExploseGolgoth),a
			ld		hl,BOOM_SPRH_ROM_ADR
			ld		(GolgothBoomAdrRom),hl
			ld		de,SPRH6_ADR
			ld		(GolgothSprh),de
			ld		iy,#100
			ld		(GolgothLongeur),iy
			ld		bc,SPRH6_ZOOM
			exx
			ret
		.EtpExplosion1
			inc		h
			ld		(GolgothBoomAdrRom),hl
			ld		a,h
			cp		a,#C5
			jp		z,.EtpExplosionFin
			exx
			ret
				.EtpExplosionFin
					xor		a
					ld		(Etp_ExploseGolgoth),a
					ld		(bc),a
					inc		d
					ld		(GolgothSprh),de
					ld		a,d
					cp		a,#4A
					jp		z,GolgothMort7
					ld		a,(Etp_ExploseGolgoth)
					inc		a
					ld		(Etp_ExploseGolgoth),a
					ld		hl,BOOM_SPRH_ROM_ADR
					ld		(GolgothBoomAdrRom),hl
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					exx
					ld 		a,SFX_BOOM_GOLGOTH	;Sound effect number (>=1)
					ld 		c,SFX_CHANNEL_EXPLODE_GOLGOTH 					;channel (0-2)
					ld 		b,SFX_VOLUME 					;Inverted volume (0-16)
					call 	PLY_AKG_PlaySoundEffect
					jp		ASIC_DECONNEXION
							
						GolgothMort7
							call	Un_Golgoth_Est_Mort
							ret


Update_Golgoth7
	pop		de
	inc		de
	inc		de
	push	de
		Update_Golgoth7_after	
			rst		ASIC_CONNEXION
			ld		hl,(posX_Golgoth)
			ld		(SPRH6_X),hl
			ld		(SPRH8_X),hl
			ld		(SPRH10_X),hl
			ld		de,64
			add		hl,de
			ld		(SPRH7_X),hl
			ld		(SPRH9_X),hl
			ld		(SPRH11_X),hl
			
			ld		hl,(posY_Golgoth)
			ld		(SPRH6_Y),hl
			ld		(SPRH7_Y),hl
			ld		de,16
			add		hl,de
			ld		(SPRH8_Y),hl
			ld		(SPRH9_Y),hl
			ld		de,16
			add		hl,de
			ld		(SPRH10_Y),hl
			ld		(SPRH11_Y),hl
			ret
	



; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////                GOLGOTH 8          /////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
golgoth_8_ROM
	ld		a,(EtpGolgoth)
	cp		a,1
	jp		z,Anim_Golgoth8
	cp		a,2
	jp		z,Explose_Golgoth8
		Anim_Golgoth8
			ld		a,(VitesseAnimGolgoth)
			inc		a
			ld		(VitesseAnimGolgoth),a
			cp		a,VITESSE_ANIM_GOLGOTH8
			jp		nz,Deplacement_Golgoth8
			xor		a
			ld		(VitesseAnimGolgoth),a
			call	Deplacement_Golgoth8
			ld		a,(Etp_Anim_Golgoth)
			cp		a,0
			jr		z,.Anim_0_Golgoth
			cp		a,1
			jr		z,.Anim_1_Golgoth
			cp		a,2
			jr		z,.Anim_2_Golgoth
			cp		a,3
			jr		z,.Anim_3_Golgoth
			cp		a,4			
			jr		z,.Anim_Fin
				.Anim_0_Golgoth
					inc		a
					ld		(Etp_Anim_Golgoth),a
					ld		hl,GOLGOTH8_SPRH_ADR_ROM_ANIM1_CORP
					ld		(Golgoth_Corp_AdrRom),hl
					ld		hl,GOLGOTH8_SPRH_ADR_ROM_ANIM1_TETES
					ld		(Golgoth_Tete_AdrRom),hl
					ret
				.Anim_1_Golgoth
					inc		a
					ld		(Etp_Anim_Golgoth),a
					ld		hl,GOLGOTH8_SPRH_ADR_ROM_ANIM2_CORP
					ld		(Golgoth_Corp_AdrRom),hl
					ld		hl,GOLGOTH8_SPRH_ADR_ROM_ANIM2_TETES
					ld		(Golgoth_Tete_AdrRom),hl
					ret
				.Anim_2_Golgoth
					inc		a
					ld		(Etp_Anim_Golgoth),a
					ld		hl,GOLGOTH8_SPRH_ADR_ROM_ANIM3_CORP
					ld		(Golgoth_Corp_AdrRom),hl
					ld		hl,GOLGOTH8_SPRH_ADR_ROM_ANIM3_TETES
					ld		(Golgoth_Tete_AdrRom),hl
					ret
				.Anim_3_Golgoth
					inc		a
					ld		(Etp_Anim_Golgoth),a
					ld		hl,GOLGOTH8_SPRH_ADR_ROM_ANIM4_CORP
					ld		(Golgoth_Corp_AdrRom),hl
					ld		hl,GOLGOTH8_SPRH_ADR_ROM_ANIM4_TETES
					ld		(Golgoth_Tete_AdrRom),hl
					ret
				.Anim_Fin
					xor		a
					ld		(Etp_Anim_Golgoth),a
					ld		hl,GOLGOTH8_SPRH_ADR_ROM_ANIM3_CORP
					ld		(Golgoth_Corp_AdrRom),hl
					ld		hl,GOLGOTH8_SPRH_ADR_ROM_ANIM3_TETES
					ld		(Golgoth_Tete_AdrRom),hl
					
					ret
									
						Deplacement_Golgoth8
						; modification de la direction X du Golgoth
							ld		hl,(Pointeur_TblGolgoth_1)
							ld		c,(hl)
							inc		hl
							ld		b,(hl)					; décalage dans BC
							ex		de,hl
							ld		hl,(posX_Golgoth)
							add		hl,bc
							ld		(posX_Golgoth),hl		; resultat
						; modification de la direction Y du Golgoth
							ex		hl,de					; Pointeur dans HL
							inc		hl
							ld		c,(hl)
							inc		hl
							ld		b,(hl)
							ex		de,hl					; pointeur dans DE
							ld		hl,(posY_Golgoth)
							add		hl,bc
							ld		(posY_Golgoth),hl
						; test si la distance est déjà parcourue
							inc		de						; pointeur incrementé sur la valeur de distance
							ld		hl,Compteur_DistanceGolgoth_8		; adresse de la variable
							inc		(hl)								; on incrémente son contenue
							ld		b,(hl)								; et on recupère son contenu dans B
							ex		hl,de								; on repasse le pointeur dans HL
							ld		a,(hl)
							sub		a,b	
							call	z,Update_PointeurGolgoth_8
							inc		hl
							ld		iy,(PointeurUpdateGolgoth)
							call	$+3			; equivalent à push PC met l'adresse courante (PC) dans la pile
							jp		(iy)
						;	la routine pointé par jp(iy) modifie la valeur de retour de la pile de 2 octets 
								
							call 	test_collisions_avec_les_Golgoths_G
							call 	test_collisions_avec_les_Golgoths_D
							call	test_collisions_tir_gauche_golgoth
							call	test_collisions_tir_droite_golgoth
							ret
								Update_PointeurGolgoth_8
									inc		hl
									inc		hl
									ld		(Pointeur_TblGolgoth_1),hl
									xor		a
									ld		(Compteur_DistanceGolgoth_8),a
									ld		c,(hl)
									inc		hl
									ld		b,(hl)
									ex		de,hl			; pointeur dans DE
									ld		l,c
									ld		h,b
									or		a
									ld		bc,#FFFF
									sbc		hl,bc
									ex		hl,de			; pointeur dans HL
									jr		z,Reinit_PointeurGolgoth_8
									ret
										Reinit_PointeurGolgoth_8
											ld		hl,Tbl_Gologoth8
											ld		(Pointeur_TblGolgoth_1),hl
											ret

; ///////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////
Explose_Golgoth8
;ret
; on indique par un flag que le goLOGOTH EST MORT
	rst		ASIC_CONNEXION
	ld		a,(Compteur_ExploseGolgoth)
	inc		a
	ld		(Compteur_ExploseGolgoth),a
	cp		a,VITESSE_EXPLOSE_GOLGOTH
	RET		NZ
	xor		a
	ld		(Compteur_ExploseGolgoth),a
	ld		a,1
	ld		(flag_MortGolgoth),a
	exx
	ld		a,(Etp_ExploseGolgoth)
	cp		a,0
	jr		z,.InitExplosion
	cp		a,1
	jr		z,.EtpExplosion1
		.InitExplosion
			inc		a
			ld		(Etp_ExploseGolgoth),a
			ld		hl,BOOM_SPRH_ROM_ADR
			ld		(GolgothBoomAdrRom),hl
			ld		de,SPRH6_ADR
			ld		(GolgothSprh),de
			ld		iy,#100
			ld		(GolgothLongeur),iy
			ld		bc,SPRH6_ZOOM
			exx
			ret
		.EtpExplosion1
			inc		h
			ld		(GolgothBoomAdrRom),hl
			ld		a,h
			cp		a,#C5
			jp		z,.EtpExplosionFin
			exx
			ret
				.EtpExplosionFin
					xor		a
					ld		(Etp_ExploseGolgoth),a
					ld		(bc),a
					inc		d
					ld		(GolgothSprh),de
					ld		a,d
					cp		a,#4A
					jp		z,GolgothMort8
					ld		a,(Etp_ExploseGolgoth)
					inc		a
					ld		(Etp_ExploseGolgoth),a
					ld		hl,BOOM_SPRH_ROM_ADR
					ld		(GolgothBoomAdrRom),hl
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					inc		c
					exx
					ld 		a,SFX_BOOM_GOLGOTH	;Sound effect number (>=1)
					ld 		c,SFX_CHANNEL_EXPLODE_GOLGOTH 					;channel (0-2)
					ld 		b,SFX_VOLUME 					;Inverted volume (0-16)
					call 	PLY_AKG_PlaySoundEffect
					jp		ASIC_DECONNEXION
							
						GolgothMort8
							call	Un_Golgoth_Est_Mort
							
							; on précise que cette fin de level fait appel à un level 'big boss'
							ld		a,2
							ld		(flag_bigboss),a
							ld 		 hl,BIGBOSS2_SPRH_ADR_ROM
							ld 		(adrBigbossSpriteROM),hl
							ret


Update_Golgoth8
	pop		de
	inc		de
	inc		de
	push	de
		Update_Golgoth8_after	
			rst		ASIC_CONNEXION
			ld		hl,(posX_Golgoth)
			ld		(SPRH6_X),hl
			ld		(SPRH8_X),hl
			ld		(SPRH10_X),hl
			ld		(SPRH12_X),hl
			ld		de,64
			add		hl,de
			ld		(SPRH7_X),hl
			ld		(SPRH9_X),hl
			ld		(SPRH11_X),hl
			ld		(SPRH13_X),hl
			
			ld		hl,(posY_Golgoth)
			ld		(SPRH6_Y),hl
			ld		(SPRH7_Y),hl
			ld		de,16
			add		hl,de
			ld		(SPRH8_Y),hl
			ld		(SPRH9_Y),hl
			ld		de,16
			add		hl,de
			ld		(SPRH10_Y),hl
			ld		(SPRH11_Y),hl
			ld		de,16
			add		hl,de
			ld		(SPRH12_Y),hl
			ld		(SPRH13_Y),hl
			ret
	
Tbl_Gologoth8
; direction X + direction Y + nombre de frame
	dw	4,0,100
	dw	-4,0,100
	dw	4,0,100
	dw	-4,0,100	
	dw	4,6,50
	dw	4,-6,50
	dw	-4,0,100
	
	dw	4,0,50
	dw	-4,0,50
	dw	8,0,50
	dw	-4,0,50	
	dw	-4,6,50
	dw	0,-6,50

	
	dw	#FFFF		

Un_Golgoth_Est_Mort
	xor		a
	ld		(flag_boss),a
	ld		(valeur_zoom_sprh4),a
	ld		(valeur_zoom_sprh5),a
	ld		(valeur_zoom_sprh6),a
	ld		(valeur_zoom_sprh7),a
	ld		(valeur_zoom_sprh8),a
	ld		(valeur_zoom_sprh9),a
	ld		(valeur_zoom_sprh10),a
	ld		(valeur_zoom_sprh11),a
	ld		(valeur_zoom_sprh12),a
	ld		(valeur_zoom_sprh13),a
	ld		(valeur_zoom_sprh14),a
	ld		(valeur_zoom_sprh15),a
	exx
	ld		(event_golgoth),a
	ld		(event_golgoth+1),a
	ld		(event_golgoth+2),a
	ld		(event_golgoth+3),a
	ld		(event_golgoth+4),a
	ld		(event_golgoth+5),a
						
	; suppression du test de touche de goldorak
	ld		(event_test_de_goldorak),a
	ld		(event_test_de_goldorak+1),a
	ld		(event_test_de_goldorak+2),a
							
	ld		a,_CALL						; call
	ld		(event_fade_out),a
	ld		hl,fondu_de_sortie
	ld		(event_fade_out+1),hl

	ld		a,_JP						; JP
	ld		(event_fade_out+3),a
	ld		hl,boucle_principale
	ld		(event_fade_out+4),hl

ld	a,(flag_on_joue_avec_alcorak)
	cp a, 1
	jr  z,on_zap_puzzle
	ld		a,_CALL						; call
	ld		(event_alcorak),a
	ld		hl,alcorak_puzzle
	ld		(event_alcorak+1),hl
on_zap_puzzle
	 call	music_off

	call	scrolling_on

		ld		a,MUCIS_LVL_END	
		ld 		hl,Music
		call 	PLY_AKG_Init
		call	music_on
	ret