soucoupe_1
	ld		a,(etp_soucoupe1)
	cp		a,0
	jr		nz,saute_soucoupe1
; !!!!!!! ICI ON EST A SOUCOUPE_1+8 et SOUCOUPE_1+11 !!!!!!!!!!
; j'ai pas trouvé d'autre moyen d'indiquer les 2 adresse suivante qui sont normalement utile lors 
; de la création du'une nouvelle Vague
	ld		hl,TblConfigSoucoupe1+7
	ld		e,(hl)
	inc		hl
	ld		d,(hl)
	ld		(adr_soucoupe_tourne_tg1),de
	ld		hl,TblConfigSoucoupe1+27
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; on recupère l'adresse de la routine 'soucoupe 1' et on l'écrit dans le tableau de config de la soucoupe
	pop		de								
	dec		de
	dec 	de
	dec 	de			
	ld		hl,TblConfigSoucoupe1+1			
	ld		(hl),e
	inc		hl
	ld		(hl),d
; on retablie la valeur de départ dans la pile
	inc		de
	inc 	de 
	inc 	de
	push	de
		TestTirSoucoupe_1
			ld		a,_CALL
			ld		(event_tir_ennemis_1),a
			ld		hl,tir_ennemis_1
			ld		(event_tir_ennemis_1+1),hl


				saute_soucoupe1	
					RST		ASIC_CONNEXION
				; on recupère l'identité du joueur qui et lié à cette soucoupe
					ld		hl,TblConfigSoucoupe1+26
					ld		a,(hl)
					ld		(no_id_joueur),a
				; on recupère l'adresse du scoring lié à l'identité du joueur
					ld		hl,TblConfigSoucoupe1+25
					ld		(adr_tbl_points_soucoupe),hl
				; on transfert le tableau de cette soucoupe dans les variables globales	
					ld		hl,TblConfigSoucoupe1
					ld		de,TBL_CONFIG_DES_SOUCOUPES
					ld		bc,SOUCOUPES_NBR_VARIABLE_TBL
					LDIR



					ld		hl,TBL_CONFIG_DES_SOUCOUPES+28
					ld		e,(hl)
					inc		hl
					ld		d,(hl)		; dans DE j'obtient l'adresse du label de destination de la direction
					ex		hl,de
					ld		a,(etp_soucoupe1)
					jp		suite_test_soucoupes





					
soucoupe_2
	ld		a,(etp_soucoupe2)
	cp		a,0
	jr		nz,saute_soucoupe2
; !!!!!!! ICI ON EST A SOUCOUPE_1+7 et SOUCOUPE_1+8 !!!!!!!!!!
; j'ai pas trouvé d'autre moyen d'indiquer les 2 adresse suivante qui sont normalement utile lors 
; de la création du'une nouvelle cague
	ld		hl,TblConfigSoucoupe2+7
	ld		e,(hl)
	inc		hl
	ld		d,(hl)
	ld		(adr_soucoupe_tourne_tg2),de
	ld		hl,TblConfigSoucoupe2+27
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	pop		de
	dec		de : dec de : dec de
	ld		hl,TblConfigSoucoupe2+1
	ld		(hl),e
	inc		hl
	ld		(hl),d
	inc		de : inc de : inc de
	push	de
		saute_soucoupe2
			RST		ASIC_CONNEXION
			ld		hl,TblConfigSoucoupe2+26
			ld		a,(hl)
			ld		(no_id_joueur),a
			ld		hl,TblConfigSoucoupe2+25
			ld		(adr_tbl_points_soucoupe),hl
			ld		de,TBL_CONFIG_DES_SOUCOUPES
			ld		hl,TblConfigSoucoupe2
			ld		bc,SOUCOUPES_NBR_VARIABLE_TBL
			LDIR
			ld		hl,TBL_CONFIG_DES_SOUCOUPES+28
			ld		e,(hl)
			inc		hl
			ld		d,(hl)		; dans DE j'obtient l'adresse du label de destination de la direction
			ex		hl,de
			ld		a,(etp_soucoupe2)
			jp		suite_test_soucoupes



soucoupe_3
ld		a,(etp_soucoupe3)
	cp		a,0
	jr		nz,saute_soucoupe3
	; !!!!!!! ICI ON EST A SOUCOUPE_1+7 et SOUCOUPE_1+8 !!!!!!!!!!
; j'ai pas trouvé d'autre moyen d'indiquer les 2 adresse suivante qui sont normalement utile lors 
; de la création du'une nouvelle cague
	ld		hl,TblConfigSoucoupe3+7
		ld		e,(hl)
	inc		hl
	ld		d,(hl)
	ld		(adr_soucoupe_tourne_tg3),de
	ld		hl,TblConfigSoucoupe3+27
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	pop		de
	dec		de : dec de : dec de
	ld		hl,TblConfigSoucoupe3+1
	ld		(hl),e
	inc		hl
	ld		(hl),d
	inc		de : inc de : inc de
	push	de
		saute_soucoupe3
			RST		ASIC_CONNEXION
			ld		hl,TblConfigSoucoupe3+26
			ld		a,(hl)
			ld		(no_id_joueur),a
			ld		hl,TblConfigSoucoupe3+25
			ld		(adr_tbl_points_soucoupe),hl
			ld		de,TBL_CONFIG_DES_SOUCOUPES
			ld		hl,TblConfigSoucoupe3
			ld		bc,SOUCOUPES_NBR_VARIABLE_TBL
			LDIR
			ld		hl,TBL_CONFIG_DES_SOUCOUPES+28
			ld		e,(hl)
			inc		hl
			ld		d,(hl)		; dans DE j'obtient l'adresse du label de destination de la direction
			ex		hl,de
			ld		a,(etp_soucoupe3)
			jp		suite_test_soucoupes
soucoupe_4
	ld		a,(etp_soucoupe4)
	cp		a,0
	jr		nz,saute_soucoupe4
	; !!!!!!! ICI ON EST A SOUCOUPE_1+7 et SOUCOUPE_1+8 !!!!!!!!!!
; j'ai pas trouvé d'autre moyen d'indiquer les 2 adresse suivante qui sont normalement utile lors 
; de la création du'une nouvelle cague
	ld		hl,TblConfigSoucoupe4+7
			ld		e,(hl)
	inc		hl
	ld		d,(hl)
	ld		(adr_soucoupe_tourne_td4),de
	ld		hl,TblConfigSoucoupe4+27
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	pop		de
	dec		de : dec de : dec de
	ld		hl,TblConfigSoucoupe4+1
	ld		(hl),e
	inc		hl
	ld		(hl),d
	inc		de : inc de : inc de
	push	de
		TestTirSoucoupe_4
			ld		a,_CALL
			ld		(event_tir_ennemis_4),a
			ld		hl,tir_ennemis_4
			ld		(event_tir_ennemis_4+1),hl

			
				saute_soucoupe4
					RST		ASIC_CONNEXION
					ld		hl,TblConfigSoucoupe4+26
					ld		a,(hl)
					ld		(no_id_joueur),a
					ld		hl,TblConfigSoucoupe4+25
					ld		(adr_tbl_points_soucoupe),hl
					ld		de,TBL_CONFIG_DES_SOUCOUPES
					ld		hl,TblConfigSoucoupe4
					ld		bc,SOUCOUPES_NBR_VARIABLE_TBL
					LDIR
					ld		hl,TBL_CONFIG_DES_SOUCOUPES+28
					ld		e,(hl)
					inc		hl
					ld		d,(hl)		; dans DE j'obtient l'adresse du label de destination de la direction
					ex		hl,de
					ld		a,(etp_soucoupe4)
					jp		suite_test_soucoupes
soucoupe_5
	ld		a,(etp_soucoupe5)
	cp		a,0
	jr		nz,saute_soucoupe5
	; !!!!!!! ICI ON EST A SOUCOUPE_1+7 et SOUCOUPE_1+8 !!!!!!!!!!
; j'ai pas trouvé d'autre moyen d'indiquer les 2 adresse suivante qui sont normalement utile lors 
; de la création du'une nouvelle cague
	ld		hl,TblConfigSoucoupe5+7
	ld		e,(hl)
	inc		hl
	ld		d,(hl)
	ld		(adr_soucoupe_tourne_td5),de
	ld		hl,TblConfigSoucoupe5+27
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	pop		de
	dec		de : dec de : dec de
	ld		hl,TblConfigSoucoupe5+1
	ld		(hl),e
	inc		hl
	ld		(hl),d
	inc		de : inc de : inc de
	push	de
		saute_soucoupe5
			RST		ASIC_CONNEXION
			ld		hl,TblConfigSoucoupe5+26
			ld		a,(hl)
			ld		(no_id_joueur),a
			ld		hl,TblConfigSoucoupe5+25
			ld		(adr_tbl_points_soucoupe),hl
			ld		de,TBL_CONFIG_DES_SOUCOUPES
			ld		hl,TblConfigSoucoupe5
			ld		bc,SOUCOUPES_NBR_VARIABLE_TBL
			LDIR
			ld		hl,TBL_CONFIG_DES_SOUCOUPES+28
			ld		e,(hl)
			inc		hl
			ld		d,(hl)		; dans DE j'obtient l'adresse du label de destination de la direction
			ex		hl,de
			ld		a,(etp_soucoupe5)
			jp		suite_test_soucoupes
soucoupe_6
	ld		a,(etp_soucoupe6)
	cp		a,0
	jr		nz,saute_soucoupe6
	; !!!!!!! ICI ON EST A SOUCOUPE_1+7 et SOUCOUPE_1+8 !!!!!!!!!!
; j'ai pas trouvé d'autre moyen d'indiquer les 2 adresse suivante qui sont normalement utile lors 
; de la création du'une nouvelle cague
	ld		hl,TblConfigSoucoupe6+7
			ld		e,(hl)
	inc		hl
	ld		d,(hl)
	ld		(adr_soucoupe_tourne_td6),de
	ld		hl,TblConfigSoucoupe6+27
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	pop		de
	dec		de : dec de : dec de
	ld		hl,TblConfigSoucoupe6+1
	ld		(hl),e
	inc		hl
	ld		(hl),d
	inc		de : inc de : inc de
	push	de
		saute_soucoupe6
			RST		ASIC_CONNEXION
			ld		hl,TblConfigSoucoupe6+26
			ld		a,(hl)
			ld		(no_id_joueur),a
			ld		hl,TblConfigSoucoupe6+25
			ld		(adr_tbl_points_soucoupe),hl
			ld		de,TBL_CONFIG_DES_SOUCOUPES
			ld		hl,TblConfigSoucoupe6
			ld		bc,SOUCOUPES_NBR_VARIABLE_TBL
			LDIR
			ld		hl,TBL_CONFIG_DES_SOUCOUPES+28
			ld		e,(hl)
			inc		hl
			ld		d,(hl)		; dans DE j'obtient l'adresse du label de destination de la direction
			ex		hl,de
			ld		a,(etp_soucoupe6)
			jp		suite_test_soucoupes
				suite_test_soucoupes

					;or		a
					cp		a,0
					jp		z,init_soucoupe
					;dec		a
					cp		a,1
					jp		z,deplace_soucoupe
					;dec		a
					cp		a,2
					jp		z,explose_soucoupe
					;dec		a.
					cp		a,3
					jp		z,soucoupe_init_item
					;dec		a
					cp		a,4
					jp		z,soucoupe_attends_item
					;dec		a
					cp		a,5
					jp		z,soucoupe_disparait
					ret
						init_soucoupe
						; on incremente le compteur pour la proichaine étape
							inc		a
							ld		hl,(etp_soucoupe)
							ld		(hl),a
						; on reocpie le sprite de la ROM vers l'ASIC
							ld		c,BANK11_SOUCOUPES_SPRH
							RST 	UPPER_ROM_CONNEXION
							ld		hl,(adr_soucoupe)
							ld		de,(SPRH_ADR)
							ld		bc,#100
							LDIR
							ld		c,BANK_ROM_18
							; ld		c,BANK_ROM_2
							RST 	UPPER_ROM_CONNEXION
							call	init_soucoupe_ROM
							call	rom_off
							ret
								deplace_soucoupe
								
									jp		(hl)
										explose_soucoupe
										; elle se déplace quand même
											ld		hl,(SPRH_Y)		; on recupère l'adresse du sprite hard
											dec		(hl)			; on décrementente l'interieur pour donner un effert de recul
											ld		hl,(SPRH_Y)
											ld		e,(hl)
											inc		hl
											ld		d,(hl)
											ld		(posy_soucoupe),de
											ld		hl,(SPRH_X)	
											ld		e,(hl)
											inc		hl
											ld		d,(hl)
											ld		(posx_soucoupe),de
										; on utilise un compteur pour gérer la vitesse d'enchainement les sprite booom
											ld		hl,(adr_timer_BOOM_soucoupe)
											ld		a,(hl)
											inc		a
											ld		(hl),a
											cp		a,6
											ret		nz
											xor		a
											ld		(hl),a
											ld		c,BANK16_BOOM_SPRH
											RST 	UPPER_ROM_CONNEXION
											RST		ASIC_CONNEXION
											ld		hl,(BoomSprhRomAdr)
											push	hl
											ld		de,(SPRH_ADR)
											ld		bc,#100
											LDIR
											pop		hl
											inc		h
											ld		a,h
											cp		a,#c5
											jr		z,soucoupe_detruite
											ld		(BoomSprhRomAdr),hl
											call	rom_off
											ret
												soucoupe_detruite
												
													ld		hl,(etp_soucoupe)
													ld		a,(hl)
													inc		a
													ld		(hl),a
													call	rom_off
														rst		ASIC_CONNEXION
														;ld		hl,COULEUR_BOOM_ENNEMI		; ----> flash du border retiré, il ne sert plus
														;ld		(PALETTE_BORDER),hl
														rst		ASIC_DECONNEXION
												
												; /////////// TENTATIVE DE MISE EN PLACE DES BOMBES /////////////////
													;ld		a,(flag_bomb)
													;cp		a,0
													;jr		nz,on_zap_les_points
												; /////////////////////////////////////////////////////////////////////
													ld		hl,val_points
													ld		(points_a_ajouter),hl
													call	score_BOOM
													ret
													

														soucoupe_init_item
															inc		a
														; on incremente le compteur pour la proichaine étape
															ld		hl,(etp_soucoupe)
															ld		(hl),a				; on sait d'ou on vient et ou l'on va 
															ld		hl,(SPRH_Y)
															ld		e,(hl)
															inc		hl
															ld		d,(hl)
															ld		(posy_soucoupe),de
															ld		hl,(SPRH_X)	
															ld		e,(hl)
															inc		hl
															ld		d,(hl)
															ld		(posx_soucoupe),de
															; ld		c,BANK11_ITEMS_SPRH
															; RST 	UPPER_ROM_CONNEXION
															; RST		ASIC_CONNEXION
															
															ld		c,BANK_ROM_18
															; ld		c,BANK_ROM_2
															RST 	UPPER_ROM_CONNEXION
															RST		ASIC_CONNEXION
														; à partir d'ici on determine le type d'item à afficher ET aussi la valeur des poinbts de cet items	
															ld		hl,(pointeur_tbl_point)
															inc		hl
															ld		a,(hl)
															cp		a,#FF		; arrive t-on à la fin du tableau ?
															jr		nz,on_zap_reinit_pointeur_points	; non : on zap le réinit
																	reinit_pointeur_tbl_points
																		ld		hl,tbl_distribution_points
																	on_zap_reinit_pointeur_points
																		ld		(pointeur_tbl_point),hl
																		ld		a,(hl)
																		ld		(nbr_de_points),a
																		ld		hl,(adr_tbl_points_soucoupe)
																		ld		(hl),a

																		push	af
																		ld		c,BANK11_ITEMS_SPRH
																		RST 	UPPER_ROM_CONNEXION
																		RST		ASIC_CONNEXION
																		pop		af
																		cp		a,ITEM_AJOUTE_1VIE
																		jr		z,item_1UP
																		cp		a,ITEM_FULL_NRJ
																		jr		z,item_NRJ
																		cp		a,ITEM_10_PTS
																		jr		z,item_10pts
																		cp		a,ITEM_50_PTS
																		jr		z,item_50pts
																		cp		a,ITEM_100_PTS
																		jr		z,item_100pts
																		cp		a,ITEM_20_PTS
																		jr		z,item_20pts
																		cp		a,ITEM_500_PTS
																		jr		z,item_500pts
																		cp		a,ITEM_POWERUP
																		jr		z,item_power
																		ret
																			item_boum
																				ld		hl,#f800
																				jr		affiche_item_ASIC
																					item_power
																						ld		hl,#f700
																						jr		affiche_item_ASIC
																						item_NRJ
																							ld		hl,#F600
																							jr		affiche_item_ASIC
																							item_1UP
																								ld		hl,#f500
																								jr		affiche_item_ASIC
																								item_10pts	
																									ld		hl,#f000
																									jr		affiche_item_ASIC
																									item_20pts
																										ld		hl,#f100
																										jr		affiche_item_ASIC
																										item_50pts
																											ld		hl,#f200
																											jr		affiche_item_ASIC
																											item_100pts
																												ld		hl,#f300
																												jr		affiche_item_ASIC
																												item_500pts
																													ld		hl,#f400
																													affiche_item_ASIC
																														ld		de,(SPRH_ADR)
																														ld		bc,#100
																														LDIR
																														jp		ASIC_DECONNEXION
																														
soucoupe_attends_item
; l'item bouge
	ld		hl,(SPRH_Y)
	ld		e,(hl)
	inc		hl
	ld		d,(hl)
	ld		(posy_soucoupe),de
	ld		hl,(SPRH_X)	
	ld		e,(hl)
	inc		hl
	ld		d,(hl)
	ld		(posx_soucoupe),de
	call	test_collisions_goldorak_item
	call	test_collisions_goldorak_item2
	; ld		a,(flag_mode_2_joueur)
	; cp		a,1
	; ret		nz
	ret
		soucoupe_disparait
			ld		c,BANK_ROM_18
			; ld		c,BANK_ROM_2
			rst		UPPER_ROM_CONNEXION
			call	soucoupe_disparait_ROM
			call	rom_off
			ret
				reinit_poid_fort
					ld		hl,(SPRH_Y)
					xor		a
					inc		hl
					ld		(hl),a
					ret
