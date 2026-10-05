

nouvelle_vague_ROM
	;ld		hl,TBL_DEPLACEMENT_HorizVertiBasDroite
	;ld		(Pointeur_TblHorizVertiBasDroite),hl
	;ld		hl,TBL_DEPLACEMENT_HorizVertiBasGauche
	;ld		(Pointeur_TblHorizVertiBasGauche),hl
														ld		a,0
													ld		(flag_arme_secrete),a
	ld		hl,(Pointeur_TblNombreDeSoucoupes)		; on recupère le pointeur en debut de ligne
	inc		hl:inc hl				; on incremente pour tester le poid fort
	inc		hl:inc hl
	ld		bc,event_enemis
	exx
	ld		de,(Pointeur_TblTypeDeSoucoupe)
	exx
		boucle_test_vague
		; on test si on est en fin de ligne
			inc		hl
			ld		a,(hl)				; poid fort dans A
			cp		a,0					; est il à 0 ?
			jp		z,maj_du_pointeur	; alors on est en fin de ligne et on met a jour le pointeur
		; on créer l'evenement		
			ld		a,_CALL		; call
			ld		(bc),a
			dec		hl			; on pointe sur le poid faible à recupérer
			inc		bc			; on cible l'octet juste après le CALL
			ld		a,(hl)		; poid faible dans A

			exx					; on stock le poid faible 
			ld		l,a			; de l'adresse de la routine soucoupe
			exx

			ld		(bc),a
			inc		bc
			inc		hl
			ld		a,(hl)
		; ICI ON RECUPERE LES DONNEES A ENVOTER DANS LES TABLEAU DES SPRITES ENNEMIS	
			push	af
			exx					; on stock le poid fort de 
			ld		h,a			; l'adresse de la routine soucoupe
								; HL contient l'adresse de la routine soucoupe_1
			ld		bc,8		; 8octets plus loin
			add		hl,bc		; HL contient l'adresse vers laquelle on pointe
								; et qui contient l'adresse de TblConfigsoucoupe1+7 
			ld		c,(hl)		; on lit cette adresse et on la stock dans BC
			inc		hl
			ld		b,(hl)		; BC contient l'adresse ou il faut ecrire
		; ON A RECUPERE L'ADRESSE DU TABLEAU DE CONFIG DU SPRITE EN COURS	
	
		; sauvegarde de l'adresse Destiantion dans le tableau des psrite
			push	bc
			; ---------------------------------------------------------------------------------------------
			; ---------------------- LECTURE DU TYPE DE SOUCOUPE DANS LE TABLEAU --------------------------
			; ---------------------------------------------------------------------------------------------
			; on recupère le poid faible de l'adresse à lire dans le tableau	
				ld		a,(de)
				ld		l,a
			; on recupère le poid fort de l'adresse à lire dans le tableau	
				inc		de
				ld		a,(de)
			; HL contient l'adresse TypeSoucoupeVerte
				ld		h,a
			; on décale de pointeur pour lire la prochaine adresse du tableau et on la sauvegarde	
				inc		de
				ld		(Pointeur_TblTypeDeSoucoupe),de
			; on sauvegarde le type de soucoupe ciblé
				push	hl
				
				; ---------------------------------------------------------------------------------------------
				; ----------------- LECTURE DE L'ADRESSE DU SPRH DU TYPE DE SOUCOUPE --------------------------
				; ---------------------------------------------------------------------------------------------	
				; on recupère de poid faible de l'adresse du sprite hard
					ld		a,(hl)		
				; on l'écrit dans le tableau
					ld		(bc),a
					inc		bc
					inc		hl
				; on recupère de poid fort de l'adresse du sprite hard
					ld		a,(hl)
				; on l'écrit dans le tableau
					ld		(bc),a
		
					; ---------------------------------------------------------------------------------------------
					; ----------------- LECTURE DU NBR DE PTS DE VIE DU TYPE DE SOUCOUPE --------------------------
					; ---------------------------------------------------------------------------------------------	
						pop		de			; adresse de TypeSoucoupeVerte
						pop		bc			; Destination précédante du Tableau
						ld		hl,20		; 20 octets plus loin
						add		hl,bc
					; nouvelle destination tableau dans BC	
						ld		c,l
						ld		b,h
					; on pointe sur PV	
						inc		de
						inc 	de
					; on recupère la valeur des poitn de vie	
						ld		a,(de)
					; on les ecrit dans le tableau
						ld		(bc),a
			
			
						; ---------------------------------------------------------------------------------------------
						; ----------------- LECTURE DU TYPE DE DEPLACEMENT DU TYPE DE SOUCOUPE ------------------------
						; ---------------------------------------------------------------------------------------------		
						; on pointe sur le poids faible du type de déplacement	
							inc 	de
						; on pointe sur l'octet suivant donc la où on ecrira l'adresse du type de déplacement	
							inc		bc
						; on recupère de poid faible du type de déplcament	
							ld		a,(de)
							ld		(bc),a
						; on pointe sur le poids fort du type de déplacement	
							inc 	de				
							inc 	bc
							ld		a,(de)
							ld		(bc),a
			
							; ---------------------------------------------------------------------------------------------
							; ----------------- LECTURE DES COORDONNEES DE DEPART DU TYPE DE SOUCOUPE ------------------------
							; ---------------------------------------------------------------------------------------------		
								
							; on pointe sur la position X
								inc		de
							; on pointe sur l'endroit du tableau ou l'on va ecrire la coordonnées	
								ld		hl,-26		
								add		hl,bc
							; BC contient la destination
								ld		c,l
								ld		b,h
							; on recupère l'ctet de poid faible X à lire et on ecrit			
								ld		a,(de)		
								ld		(bc),a		
								inc		de
								inc		bc
							; on recupère l'ctet de poid fort X à lire et on ecrit
								ld		a,(de)		
								ld		(bc),a		
							; on pointe on recupère l'ctet de poid faible Y à lire et on ecrit				
								inc		de
								inc		bc
								ld		a,(de)		
								ld		(bc),a
							; on pointe on recupère l'ctet de poid fort Y à lire et on ecrit		
								inc		de
								inc		bc
								ld		a,(de)		
								ld		(bc),a		
			
								; ---------------------------------------------------------------------------------------------
								; ----------------- LECTURE DES POINTEURS DE TABLEAU DU TYPE DE SOUCOUPE ---------------------
								; ---------------------------------------------------------------------------------------------	
								; configuration du pointeur pour ceertain type de déplacement
								; on se déplace au bon endroit dans le TblConfig
									ld		hl,24		
									add		hl,bc
									
								; BC contient l'adresse de la variable contenant ll'adresse du tableau
									ld		c,(hl)
									inc 	hl
									ld		b,(hl)
									push	hl			; on sauvagarde le pointeur de lecture en cours
											
								; on se place sur l'adresse à lire dans le Type De soucoupe	
									inc		de
								; on recupère le poid faible	
									ld		a,(de)		
									ld		(bc),a
									ld		l,a
								; on recupère le poid fort
									inc		de
									inc		bc
									ld		a,(de)		
									ld		(bc),a
								; HL contient l'adresse du Tableau	
									ld		h,a			
									
								; stockage de l'adresse qui contient la valeur de deplacement
									ld		a,(hl)		
											; BC contient l'adresse de la variable contenant la valeur de déplacement
									pop     hl		
									inc		hl
									ld		c,(hl)
									inc		hl
									ld		b,(hl)
									ld		(bc),a
								
									; on met le pointeur à jour
									ld		de,(Pointeur_TblTypeDeSoucoupe)
									exx					; 
									pop		af
								
								
								
								
									ld		(bc),a		; poid fort
									inc		bc
									inc		hl
									jp		boucle_test_vague

										; on arrive ici a chaque fin de ligne quand on rencontre le "0"
										; on test egalement voir si on est en fin de vague ave la valeur #FFFF
										maj_du_pointeur
											inc		hl
											ld		(pointeur_vague_fin),hl
											ld		a,(hl)
											ld		e,a
											inc		hl
											ld		a,(hl)
											ld		d,a
											ld		hl,#FFFF
											sbc		hl,de
											jr		z,reinit_counter_vagues
											ret

												reinit_counter_vagues
													call	fin_de_la_vague_ROM
													;call	fin_de_la_vague				; la routine inclu une mise à jour du pointeur de vague
																						; on va devoir en définir une autre
													; on recupère le pointeur du TBL_VAGUES_LEVEL_X en cours										
													ld		hl,(pointeur_tbl_level)
													; on prends l'adrese suivante
													inc hl : inc hl
													ld		(pointeur_tbl_level),hl
													; on lit l'adresse contenu à l'adresse du pointeur
													ld		e,(hl)							
													inc		hl
													ld		d,(hl)
													; on test voir si c'est un boss de fin
													or		a
													ld		hl,#FFFE
													sbc		hl,de
													; jp		z,boss_de_fin_ROM
													jp		z,boss_de_fin
													; on test voir si goldorak est détruit, alors fin du niveau
													or		a
													ld		hl,#FFFF
													sbc		hl,de
													jp		z,fin_du_level
													ld		(Pointeur_TblNombreDeSoucoupes),de
													; on réinitialise le compteur de vague, à zero pour repartir sur une vague 1
													ld		a,#00
													ld		(counter_poid_faible),a
													ld		a,#04
													ld		(counter_poid_fort),a
													; si on arrive ici c'est qu'une deuxième vagues arrive

													ret
													
												



; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////

fin_de_la_vague_ROM
; on efface la vague precedente
; ----> BUG : avec bc=18 on effaçait les 6 évènements des soucoupes plus UN seul octet de
;       event_tir_ennemis_1, et rien de event_tir_ennemis_4 ni de event_tir_ennemis_6.
;       1) le tir de la soucoupe 4 restait donc actif après la vague, et pendant le boss : 50 frames
;          plus tard il repartait depuis le sprite hard 9 (un morceau du golgoth) en se servant du
;          sprite hard 12, qui est lui aussi une pièce ou un missile du golgoth -> un bout du boss
;          se transformait en tir de soucoupe puis disparaissait.
;       2) de event_tir_ennemis_1 il ne restait que l'adresse du CALL, exécutée comme du code.
;          Avec l'adresse actuelle de tir_ennemis_1 ça donne deux instructions sans effet, mais il
;          suffit que la routine change de place dans la RAM pour que ça devienne un saut n'importe où.
; ----> CORRECTION : on efface en entier les 6 évènements des soucoupes et les 3 évènements de tir
;       (27 octets, on s'arrête juste avant event_golgoth)
	xor		a
	ld		hl,event_enemis
	ld		(hl),a
	ld		de,event_enemis+1
	ld		bc,event_golgoth+-event_enemis+-1
	ldir
	ld		hl,(pointeur_vague_fin)
	ld		(Pointeur_TblNombreDeSoucoupes),hl
	xor		a
	ld		(compteur_etape_orientation_soucoupe_tg),a
	ld		(compteur_cycle_orientation_soucoupe_tg),a
	ld		(compteur_etape_orientation_soucoupe_td),a
	ld		(compteur_cycle_orientation_soucoupe_td),a
	ld		(etp_soucoupe1),a
	ld		(etp_soucoupe2),a
	ld		(etp_soucoupe3),a
	ld		(etp_soucoupe4),a
	ld		(etp_soucoupe5),a
	ld		(etp_soucoupe6),a
	ld		(EtpTirEnnemis_4),a
	ld		(EtpTirEnnemis_1),a
	ld		(flag_1up),a
	RST		ASIC_CONNEXION
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
	ld		de,Tbl_timer_depart_soucoupes
	ld		hl,Tbl_VALEUR_TIMER_soucoupes
	ld		bc,6
	LDIR
; ----> AJOUT : mini boss. Si la vague suivante est celle qui porte le label MINIBOSS_LEVEL_1 dans
;       waves.asm, le mini boss arrive d'abord (pour le déplacer il suffit de déplacer le label).
	ld		hl,(Pointeur_TblNombreDeSoucoupes)
	ld		de,MINIBOSS_LEVEL_1
	or		a
	sbc		hl,de
	ret		nz
mini_boss_arrive
	xor		a
	ld		(EtpMissileG1_1),a : ld (flag_updateMissileG1_1),a
	ld		(EtpMissileG1_2),a : ld (flag_updateMissileG1_2),a
	ld		(EtpMissileG1_3),a : ld (flag_updateMissileG1_3),a
	ld		(EtpMissileG1_4),a : ld (flag_updateMissileG1_4),a
	ld		(EtpGolgoth),a
	ld		(VitesseAnimGolgoth),a
	ld		(Etp_Anim_Golgoth),a
	ld		(flag_MortGolgoth),a
	ld		(Etp_ExploseGolgoth),a
	ld		(Compteur_DistanceGolgoth_1),a
	inc		a
	ld		(flag_boss),a
	ld		(flag_miniboss),a
; ses évènements dans la boucle : les mêmes que le golgoth 1, sauf ses sprites qui sont en bank 11
	ld		hl,Tbl_events_miniboss
	ld		de,event_golgoth
	ld		bc,30
	LDIR
	ld		a,7
	ld		(id_soucoupe),a
	ld		a,MINIBOSS_PV
	ld		(point_vie_golgoth),a
	ld		hl,MINIBOSS_SPRH_ADR_ROM
	ld		(GolgothAdrRom),hl
	ld		(Tbl_Golgoth_anim+2),hl
	ld		hl,MINIBOSS_SPRH_ADR_ROM_ANIM2
	ld		(Tbl_Golgoth_anim),hl
	ld		hl,SPRH6_ADR
	ld		(GolgothSprh),hl
	ld		hl,#400
	ld		(GolgothLongeur),hl
	ld		hl,Tbl_MiniBoss
	ld		(Pointeur_TblGolgoth_1),hl
	ld		hl,Update_MiniBoss
	ld		(PointeurUpdateGolgoth),hl
	ld		hl,0
	ld		(posX_Golgoth),hl
	ld		hl,MINIBOSS_POSY
	ld		(posY_Golgoth),hl
	ld		a,zoom_mode0_1
	ld		(SPRH6_ZOOM),a : ld	 (valeur_zoom_sprh6),a
	ld		(SPRH7_ZOOM),a : ld	 (valeur_zoom_sprh7),a
	ld		(SPRH8_ZOOM),a : ld	 (valeur_zoom_sprh8),a
	ld		(SPRH9_ZOOM),a : ld	 (valeur_zoom_sprh9),a
	ret
Tbl_events_miniboss
	db	_CALL : dw golgoth_1
	db	_CALL : dw Update_Golgoth_6
	db	_CALL : dw missileG1_1
	db	_CALL : dw Update_missileG1_1
	db	_CALL : dw missileG1_2
	db	_CALL : dw Update_missileG1_2
	db	_CALL : dw missileG1_3
	db	_CALL : dw Update_missileG1_3
	db	_CALL : dw missileG1_4
	db	_CALL : dw Update_missileG1_4
	ret 

