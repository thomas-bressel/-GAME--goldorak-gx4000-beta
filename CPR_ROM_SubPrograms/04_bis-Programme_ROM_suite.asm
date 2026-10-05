org #c000

	include "./datas/items.asm"
	; include "./datas/items_test.asm"


	include		"05_bis-Init_affichage_ROM.asm"
    include		"06_bis-Init_de_jeu_ROM.asm"
	include		"07_bis-arrimage_ROM.asm"
	
	include 	"10_bis-armes_fireB_ROM.asm"

	include		"12_bis-soucoupes_ROM.asm"
	include		"15_bis-gestion_du_hud_ROM.asm"
	include		"17_bigboss_fin_ROM.asm"
	include		"18_bis-mouvements_soucoupes_ROM.asm"
	include		"19_bis-golgoths_ROM.asm"
	include		"19_bis-bis-missiles_ROM.asm"

; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////     ON COPIE DES ROUTINE EN DEBUT DE BANK      ////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
rstCreationPrograms_ROM
	ld		hl,rom_on			; alias RST #0
	ld		de,#0
	ld		bc,24
	LDIR
	ld		hl,asic_on			; alias RST #18
	ld		de,#18
	ld		bc,12
	LDIR
	ld		hl,asic_off			; alias RST #28
	ld		de,#28
	ld		bc,12
	LDIR
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ///////     ON CONFIGURE LES VARIABLES DU SCREEN ROUTE    ////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
	ld		hl,LARGEUR_CHIFFRE1
	ld		(largeur_chiffre),hl
	ld		hl,adr_chiffre1_ROM
	ld		(adr_chiffre),hl

; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ///////////     ON CONFIGURE LES PARAMETRE DU JEU    /////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
	; on allume et selectionne par défaut le 1er boutton et la 1ere amre
	ld		a,1
	ld		(flag_deja_affiche),a
	ld		a,VITESSE_RETOURNEMENT
	ld		(Compteur_Retournement),a


	ld		hl,tbl_distribution_points
	ld		(pointeur_tbl_point),hl
	ld		hl,Tbl_NRJ_bar+19
	ld		(pointeur_tbl_NRJ_bar),hl
	ld		hl,Tbl_NRJ_bar2+19
	ld		(pointeur_tbl_NRJ_bar2),hl
	ld		hl,TBL_NBR_SOUCOUPES
	ld		(Pointeur_TblNombreDeSoucoupes),hl
	ld		a,NBR_DE_VIE_DEPART
	ld		(nbr_de_vie),a
	ld		a,10
	ld		(points_sante),a

	ld		a,1
	ld		(level_en_cours),a

	ld		hl,TBL_VAGUES_LEVEL_1			; on lit l'adresse du tableau des vague de Level 1
	ld		(pointeur_tbl_level),hl			; on stock l'adresse du pointeur
	ld		e,(hl)							; on lit l'adresse contenu à l'adresse du pointeur
	inc		hl
	ld		d,(hl)
	ld		(Pointeur_TblNombreDeSoucoupes),de
	ld		hl,TBL_TYPE_DE_SOUCOUPE_1
	ld		(Pointeur_TblTypeDeSoucoupe),hl
	
; on lit la table des adresse a lire pour l'affichage du hud pour le retournement
	ld	hl,TBL_RETOURNEMENT_COUNT+19
	ld  (pointer_tbl_retournement),hl
	ld	a,(hl)
	ld	(display_tbl_retournement_top+1),a
	dec 	hl
	ld 	a,(hl)
	ld (display_tbl_retournement_top),a
	dec hl 
	ld	a,(hl)
	ld	(display_tbl_retournement_bot+1),a
	dec hl
	ld a,(hl)
	ld (display_tbl_retournement_bot),a
	ld  (pointer_tbl_retournement),hl
	ret



; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; /////////////////     INITIALISATION  DU JEU    //////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
initialisation_du_jeu_ROM

	; on déplace les adresse du compteur de point à l'écran dans le hud 2
	ld		hl,HUD_SCORE_UNITE_ADR
	ld		(val_HUD_SCORE_UNITE_ADR_hudJ1),hl
	ld		hl,HUD_SCORE_DIZAINNE_ADR
	ld		(val_HUD_SCORE_DIZAINNE_ADR_hudJ1),hl
	ld		hl,HUD_SCORE_CENTAINE_ADR
	ld		(val_HUD_SCORE_CENTAINE_ADR_hudJ1),hl
	ld		hl,HUD_SCORE_MILLIER_ADR
	ld		(val_HUD_SCORE_MILLIER_ADR_hudJ1),hl
	ld		hl,HUD_SCORE_DIZAINE_DE_MILLIER_ADR
	ld		(val_HUD_SCORE_DIZAINE_DE_MILLIER_ADR_hudJ1),hl
	ld		a,1
	ld		(id_joueur),a

	xor		a
	ld		(count_anim_soucoupe),a
	ld		(etp_arrimage),a
	ld		(vitesse_goldorak),a
	ld		(count_anim_goldorak),a
	ld		(bloc_tile),a
	ld		(counter_poid_fort),a
	ld		(counter_poid_faible),a
	ld		(etp_soucoupe1),a
	ld		(etp_soucoupe2),a
	ld		(etp_soucoupe3),a
	ld		(etp_soucoupe4),a
	ld		(etp_soucoupe5),a
	ld		(etp_soucoupe6),a
	ld		(flag_fireA),a
	ld		(id_arme),a


ld a,(flag_on_joue_avec_alcorak)
cp	a,1
jp	z,on_joue_avec_alcorak

; on remplit le tableau des adresse de sprite hard de goldorak
	ld		hl,Tbl_sprh_direction
	ld		de,GOLDORAK_HAUTBAS_SPRH_ROM_ADR
	ld		(hl),e : inc hl
	ld		(hl),d : inc hl
	ld		de,GOLDORAK_GAUCHE_SPRH_ROM_ADR
	ld		(hl),e : inc hl
	ld		(hl),d : inc hl
	ld		de,GOLDORAK_DROITE_SPRH_ROM_ADR
	ld		(hl),e : inc hl
	ld		(hl),d : inc hl
	ld		hl,Tbl_sprh_direction2
	ld		de,GOLDORAK_HAUTBAS_SPRH_ROM_ADR+#200
	ld		(hl),e : inc hl
	ld		(hl),d : inc hl
 	ld		de,GOLDORAK_GAUCHE_SPRH_ROM_ADR+#200
	ld		(hl),e : inc hl
	ld		(hl),d : inc hl
	ld		de,GOLDORAK_DROITE_SPRH_ROM_ADR+#200
	ld		(hl),e : inc hl
	ld		(hl),d : inc hl
	ld		hl,(Tbl_sprh_direction)
	ld		(sprh_goldorak),hl
	ld		hl,(Tbl_sprh_direction2)
	ld		(sprh_goldorak2),hl
	ld		a,BANK9_GOLDORAK_SPRH
	ld		(bank_goldo_ou_alco),a
	ld		hl,SPRH_MISSILES_GAMMA
	ld		(sprh_arme_de_base),hl
	ld		hl,SPRH_MISSILES_GAMMA2
	ld		(sprh_arme_de_base2),hl
	ld		hl,SPRH_MISSILES_GAMMA3
	ld		(sprh_arme_de_base3),hl

	jp 		initialisation_du_jeu_ROM_suite



	on_joue_avec_alcorak



; on remplit le tableau des adresse de sprite hard de goldorak
	ld		hl,Tbl_sprh_direction
	ld		de,ALCORAK_HAUTBAS_SPRH_ROM_ADR
	ld		(hl),e : inc hl
	ld		(hl),d : inc hl
	ld		de,ALCORAK_GAUCHE_SPRH_ROM_ADR
	ld		(hl),e : inc hl
	ld		(hl),d : inc hl
	ld		de,ALCORAK_DROITE_SPRH_ROM_ADR
	ld		(hl),e : inc hl
	ld		(hl),d : inc hl
	ld		hl,Tbl_sprh_direction2
	ld		de,ALCORAK_HAUTBAS_SPRH_ROM_ADR+#200
	ld		(hl),e : inc hl
	ld		(hl),d : inc hl
	ld		de,ALCORAK_GAUCHE_SPRH_ROM_ADR+#200
	ld		(hl),e : inc hl
	ld		(hl),d : inc hl
	ld		de,ALCORAK_DROITE_SPRH_ROM_ADR+#200
	ld		(hl),e : inc hl
	ld		(hl),d : inc hl
	ld		hl,(Tbl_sprh_direction)
	ld		(sprh_goldorak),hl
	ld		hl,(Tbl_sprh_direction2)
	ld		(sprh_goldorak2),hl
	ld		a,BANK15_PUZZLE
	ld		(bank_goldo_ou_alco),a


	ld		hl,SPRH_MISSILES_ALCORAK
	ld		(sprh_arme_de_base),hl
	ld		hl,SPRH_MISSILES_ALCORAK2
	ld		(sprh_arme_de_base2),hl
	ld		hl,SPRH_MISSILES_ALCORAK3
	ld		(sprh_arme_de_base3),hl


initialisation_du_jeu_ROM_suite

; on remplit le tableau des timer des soucoupes simple
	ld		de,Tbl_timer_depart_soucoupes
	ld		hl,Tbl_VALEUR_TIMER_soucoupes
	ld		bc,6
	LDIR
	ld		a,1
	ld		(sample_counter),a
	ld		(direction_goldorak),a
	ld		hl,#0100
	ld		(adr_sample),hl
	ld		hl,#1d40
	ld		(longueur_sample),hl
	ld		a,SCROLL_INIT_RETARD_VIDEO
	ld		(valeur_retard),a

; ----> BUG : le CRTC démarre en #3000 (décor affiché à partir de #C000) mais le scroll était initialisé
;       comme s'il était déjà en #33E0 (tbl_reg1213_fin, ligne de tiles en #C7C0). Au premier pas du
;       CRTC on passait donc de #3000 à #33C0 : 2 lignes de tiles d'un coup, le décor sautait de
;       9 lignes au lieu d'une, 8 trames après le début de chaque level.
; ----> CORRECTION : on démarre sur la vraie position du CRTC : l'entrée #3000 du tableau et le haut
;       de l'écran en #C000. Le premier pas passe par "reinit" (#33E0, nouvelle ligne en #C7C0) :
;       une seule ligne de tiles, comme tous les pas suivants.
	ld		hl,tbl_reg1213+2
	ld		(valeur_crtc),hl
	ld		hl,#c000
	ld		(valeur_offset),hl
	ld		(pointeur_ecran),hl

	ld		hl,aucune_arme
	ld		(adr_type_arme),hl
	ld		a,_CALL						; call
	ld		(event_arrimage),a
	ld		hl,Arrimage
	ld		(event_arrimage+1),hl
	ld		a,#C3						; JP
	ld		(event_arrimage+3),a
	ld		hl,boucle_principale
	ld		(event_arrimage+4),hl

	RET


	
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////	

boss_de_fin_ROM
; ----> BUG : quand un golgoth meurt, les évènements de ses missiles sont effacés en plein vol mais
;       leurs étapes restent sur "en vol". Les golgoths se partagent les mêmes routines de missiles
;       (levels 1, 6 et 7 pour missileG1, levels 3, 5 et 8 pour missileG3) : le golgoth suivant
;       démarrait avec un missile déjà en vol, à l'ancienne position et sans son zoom, donc un
;       missile invisible qui touchait goldorak. Seul le level 5 remettait ses étapes à zéro.
; ----> CORRECTION : tous les missiles repartent de zéro à l'arrivée de chaque golgoth
	xor		a
	ld		(EtpMissileG1_1),a : ld (flag_updateMissileG1_1),a
	ld		(EtpMissileG1_2),a : ld (flag_updateMissileG1_2),a
	ld		(EtpMissileG1_3),a : ld (flag_updateMissileG1_3),a
	ld		(EtpMissileG1_4),a : ld (flag_updateMissileG1_4),a
	ld		(EtpMissileG2_1),a : ld (flag_updateMissileG2_1),a
	ld		(EtpMissileG2_2),a : ld (flag_updateMissileG2_2),a
	ld		(EtpMissileG2_3),a : ld (flag_updateMissileG2_3),a
	ld		(EtpMissileG3_1),a : ld (flag_updateMissileG3_1),a
	ld		(EtpMissileG3_2),a : ld (flag_updateMissileG3_2),a
	ld		(EtpMissileG3_3),a : ld (flag_updateMissileG3_3),a

	ld		a,1
	ld		(flag_boss),a
	ld		a,(level_en_cours)
	cp		a,1
	jp		z,Golgoth_Level_1
	cp		a,2
	jp		z,Golgoth_Level_2
	cp		a,3
	jp		z,Golgoth_Level_3
	cp		a,4
	jp		z,Golgoth_Level_4
	cp		a,5
	jp		z,Golgoth_Level_5
	cp		a,6
	jp		z,Golgoth_Level_6
	cp		a,7
	jp		z,Golgoth_Level_7
	cp		a,8
	jp		z,Golgoth_Level_8
		Golgoth_Level_1
			ld		a,_JP							; JP pas_de_scroll_hard
			ld		(event_stop_scroll),a
			ld		hl,pas_de_scroll_hard
			ld		(event_stop_scroll+1),hl
			ld		a,_CALL
			ld		(event_golgoth),a
			ld		hl,golgoth_1
			ld		(event_golgoth+1),hl
			ld		a,_CALL
			ld		(event_golgoth+3),a
			ld		hl,Update_Golgoth_1
			ld		(event_golgoth+4),hl
			ld		a,_CALL
			ld		(event_golgoth+6),a
			ld		hl,missileG1_1
			ld		(event_golgoth+7),hl
			ld		a,_CALL
			ld		(event_golgoth+9),a
			ld		hl,Update_missileG1_1
			ld		(event_golgoth+10),hl
			ld		a,_CALL
			ld		(event_golgoth+12),a
			ld		hl,missileG1_2
			ld		(event_golgoth+13),hl
			ld		a,_CALL
			ld		(event_golgoth+15),a
			ld		hl,Update_missileG1_2
			ld		(event_golgoth+16),hl
			ld		a,_CALL
			ld		(event_golgoth+18),a
			ld		hl,missileG1_3
			ld		(event_golgoth+19),hl
			ld		a,_CALL
			ld		(event_golgoth+21),a
			ld		hl,Update_missileG1_3
			ld		(event_golgoth+22),hl	
			ld		a,_CALL
			ld		(event_golgoth+24),a
			ld		hl,missileG1_4
			ld		(event_golgoth+25),hl	
			ld		a,_CALL
			ld		(event_golgoth+27),a
			ld		hl,Update_missileG1_4
			ld		(event_golgoth+28),hl
		
			xor		a
			ld		(EtpGolgoth),a
			ld		a,7
			ld		(id_soucoupe),a
			ld		a,PV_GOLGOTH_1
			ld		(point_vie_golgoth),a
			ld		hl,GOLGOTH1_SPRH_ADR_ROM
			ld		(GolgothAdrRom),hl
			ld		hl,SPRH6_ADR
			ld		(GolgothSprh),hl
			ld		hl,#400
			ld		(GolgothLongeur),hl
			ld		hl,Tbl_Gologoth1
			ld		(Pointeur_TblGolgoth_1),hl
			ld		hl,0
			ld		(posX_Golgoth),hl
			ld		hl,0
			ld		(posY_Golgoth),hl
			call	Update_Golgoth_after
			ld		a,zoom_mode0_1
			ld		(SPRH6_ZOOM),a
			ld		(SPRH7_ZOOM),a
			ld		(SPRH8_ZOOM),a
			ld		(SPRH9_ZOOM),a
			ld		(valeur_zoom_sprh6),a
			ld		(valeur_zoom_sprh7),a
			ld		(valeur_zoom_sprh8),a
			ld		(valeur_zoom_sprh9),a
			ld		hl,Music
			ld		a,MUSIC_BOSS
			call	PLY_AKG_Init
			
			ld		hl,GOLGOTH1_SPRH_ADR_ROM+#400
			ld		(Tbl_Golgoth_anim),hl
			ld		hl,GOLGOTH1_SPRH_ADR_ROM
			ld		(Tbl_Golgoth_anim+2),hl
			ld		hl,Update_Golgoth
			ld		(PointeurUpdateGolgoth),hl
			
			
			
			ret
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////		
				Golgoth_Level_2	
					ld		a,_JP							; JP pas_de_scroll_hard
					ld		(event_stop_scroll),a
					ld		hl,pas_de_scroll_hard
					ld		(event_stop_scroll+1),hl
					ld		a,_CALL
					ld		(event_golgoth),a
					ld		hl,golgoth_2
					ld		(event_golgoth+1),hl
					ld		a,_CALL
					ld		(event_golgoth+3),a
					ld		hl,Update_Golgoth_2
					ld		(event_golgoth+4),hl
					ld		a,_CALL
					ld		(event_golgoth+6),a
					ld		hl,missileG2_1
					ld		(event_golgoth+7),hl
					ld		a,_CALL
					ld		(event_golgoth+9),a
					ld		hl,Update_missileG2_1
					ld		(event_golgoth+10),hl
					ld		a,_CALL
					ld		(event_golgoth+12),a
					ld		hl,missileG2_2
					ld		(event_golgoth+13),hl
					ld		a,_CALL
					ld		(event_golgoth+15),a
					ld		hl,Update_missileG2_2
					ld		(event_golgoth+16),hl
					ld		a,_CALL
					ld		(event_golgoth+18),a
					ld		hl,missileG2_3
					ld		(event_golgoth+19),hl
					ld		a,_CALL
					ld		(event_golgoth+21),a
					ld		hl,Update_missileG2_3
					ld		(event_golgoth+22),hl
					
					
					ld		a,8
					ld		(id_soucoupe),a
					ld		a,PV_GOLGOTH_2
					ld		(point_vie_golgoth),a
					xor		a
					ld		(EtpGolgoth),a
					ld		hl,GOLGOTH2_SPRH_ADR_ROM
					ld		(GolgothAdrRom),hl
					ld		hl,SPRH6_ADR
					ld		(GolgothSprh),hl
					ld		hl,#400
					ld		(GolgothLongeur),hl
					ld		hl,Tbl_Gologoth2
					ld		(Pointeur_TblGolgoth_1),hl
					ld		hl,0
					ld		(posX_Golgoth),hl
					ld		hl,38
					ld		(posY_Golgoth),hl
					call	Update_Golgoth2_after
					ld		a,zoom_mode0_1
					ld		(SPRH6_ZOOM),a
					ld		(SPRH7_ZOOM),a
					ld		(SPRH8_ZOOM),a
					ld		(SPRH9_ZOOM),a
					ld		(valeur_zoom_sprh6),a
					ld		(valeur_zoom_sprh7),a
					ld		(valeur_zoom_sprh8),a
					ld		(valeur_zoom_sprh9),a
					ld		hl,Music
					ld		a,MUSIC_BOSS
					call	PLY_AKG_Init			
					ld		hl,GOLGOTH2_SPRH_ADR_ROM+#400
					ld		(Tbl_Golgoth_anim),hl
					ld		hl,GOLGOTH2_SPRH_ADR_ROM
					ld		(Tbl_Golgoth_anim+2),hl
					ld		hl,Update_Golgoth2
					ld		(PointeurUpdateGolgoth),hl	
					ret
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////	
						Golgoth_Level_3	
							ld		a,_JP							; JP pas_de_scroll_hard
							ld		(event_stop_scroll),a
							ld		hl,pas_de_scroll_hard
							ld		(event_stop_scroll+1),hl
							ld		a,_CALL
							ld		(event_golgoth),a
							ld		hl,golgoth_3
							ld		(event_golgoth+1),hl
							ld		a,_CALL
							ld		(event_golgoth+3),a
							ld		hl,Update_Golgoth_3
							ld		(event_golgoth+4),hl
							ld		a,_CALL
							ld		(event_golgoth+6),a
							ld		hl,missileG3_1
							ld		(event_golgoth+7),hl
							ld		a,_CALL
							ld		(event_golgoth+9),a
							ld		hl,Update_missileG3_1
							ld		(event_golgoth+10),hl
							ld		a,_CALL
							ld		(event_golgoth+12),a
							ld		hl,missileG3_2
							ld		(event_golgoth+13),hl
							ld		a,_CALL
							ld		(event_golgoth+15),a
							ld		hl,Update_missileG3_2
							ld		(event_golgoth+16),hl
							ld		a,_CALL
							ld		(event_golgoth+18),a
							ld		hl,missileG3_3
							ld		(event_golgoth+19),hl
							ld		a,_CALL
							ld		(event_golgoth+21),a
							ld		hl,Update_missileG3_3
							ld		(event_golgoth+22),hl
							
							
							ld		a,9
							ld		(id_soucoupe),a
							ld		a,PV_GOLGOTH_3
							ld		(point_vie_golgoth),a
							xor		a
							ld		(EtpGolgoth),a

							ld		hl,Tbl_Gologoth3
							ld		(Pointeur_TblGolgoth_1),hl
							ld		hl,0
							ld		(posX_Golgoth),hl
							ld		hl,16
							ld		(posY_Golgoth),hl
							call	Update_Golgoth3_after
							rst		ASIC_CONNEXION
							ld		a,zoom_mode0_1
							ld		(SPRH6_ZOOM),a
							ld		(SPRH7_ZOOM),a
							ld		(SPRH8_ZOOM),a
							ld		(SPRH9_ZOOM),a
							ld		(SPRH10_ZOOM),a
							ld		(SPRH11_ZOOM),a
							ld		(SPRH12_ZOOM),a
							ld		(valeur_zoom_sprh6),a
							ld		(valeur_zoom_sprh7),a
							ld		(valeur_zoom_sprh8),a
							ld		(valeur_zoom_sprh9),a
							ld		(valeur_zoom_sprh10),a
							ld		(valeur_zoom_sprh11),a
							ld		(valeur_zoom_sprh12),a
							ld		hl,Music
							ld		a,MUSIC_BOSS
							call	PLY_AKG_Init
							ld		hl,Update_Golgoth3
							ld		(PointeurUpdateGolgoth),hl	
							jp		ASIC_DECONNEXION
							
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////	
								Golgoth_Level_4	
									ld		a,_JP							; JP pas_de_scroll_hard
									ld		(event_stop_scroll),a
									ld		hl,pas_de_scroll_hard
									ld		(event_stop_scroll+1),hl
									ld		a,_CALL
									ld		(event_golgoth),a
									ld		hl,golgoth_4
									ld		(event_golgoth+1),hl
									ld		a,_CALL
									ld		(event_golgoth+3),a
									ld		hl,Update_Golgoth_4
									ld		(event_golgoth+4),hl
									
									
									
									
								
									ld		a,10
									ld		(id_soucoupe),a
									ld		a,PV_GOLGOTH_4
									ld		(point_vie_golgoth),a
									xor		a
									ld		(EtpGolgoth),a
		
									ld		hl,GOLGOTH4_SPRH_ADR_ROM
									ld		(GolgothAdrRom),hl
									ld		hl,SPRH6_ADR
									ld		(GolgothSprh),hl
									ld		hl,#800
									ld		(GolgothLongeur),hl
		
		
									ld		hl,Tbl_Gologoth4
									ld		(Pointeur_TblGolgoth_1),hl
									ld		hl,0
									ld		(posX_Golgoth),hl
									ld		hl,16
									ld		(posY_Golgoth),hl
									call	Update_Golgoth4_after
									rst		ASIC_CONNEXION
									ld		a,zoom_mode0_1
									ld		(SPRH6_ZOOM),a
									ld		(SPRH7_ZOOM),a
									ld		(SPRH8_ZOOM),a
									ld		(SPRH9_ZOOM),a
									ld		(SPRH10_ZOOM),a
									ld		(SPRH11_ZOOM),a
									ld		(SPRH12_ZOOM),a
									ld		(SPRH13_ZOOM),a
									ld		(valeur_zoom_sprh6),a
									ld		(valeur_zoom_sprh7),a
									ld		(valeur_zoom_sprh8),a
									ld		(valeur_zoom_sprh9),a
									ld		(valeur_zoom_sprh10),a
									ld		(valeur_zoom_sprh11),a
									ld		(valeur_zoom_sprh12),a
									ld		(valeur_zoom_sprh13),a
									ld		hl,Music
									ld		a,MUSIC_BOSS
									call	PLY_AKG_Init
					ld		hl,GOLGOTH4_SPRH_ADR_ROM_MARCHE			; +#200
					ld		(GolgothAdrRom_MarcheG),hl
					ld		hl,GOLGOTH4_SPRH_ADR_ROM_ANIM1+#500		; +#200
					ld		(GolgothAdrRom_MarcheD),hl
									
									ld		hl,Update_Golgoth4
									ld		(PointeurUpdateGolgoth),hl	
									jp		ASIC_DECONNEXION
										
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////	
										Golgoth_Level_5	
											ld		a,_JP							; JP pas_de_scroll_hard
											ld		(event_stop_scroll),a
											ld		hl,pas_de_scroll_hard
											ld		(event_stop_scroll+1),hl
											ld		a,_CALL
											ld		(event_golgoth),a
											ld		hl,golgoth_5
											ld		(event_golgoth+1),hl
											ld		a,_CALL
											ld		(event_golgoth+3),a
											ld		hl,Update_Golgoth_5
											ld		(event_golgoth+4),hl
										
										
											ld		a,_CALL
											ld		(event_golgoth+6),a
											ld		hl,missileG3_1
											ld		(event_golgoth+7),hl
											ld		a,_CALL
											ld		(event_golgoth+9),a
											ld		hl,Update_missileG3_1
											ld		(event_golgoth+10),hl
											ld		a,_CALL
											ld		(event_golgoth+12),a
											ld		hl,missileG3_2
											ld		(event_golgoth+13),hl
											ld		a,_CALL
											ld		(event_golgoth+15),a
											ld		hl,Update_missileG3_2
											ld		(event_golgoth+16),hl
											ld		a,_CALL
											ld		(event_golgoth+18),a
											ld		hl,missileG3_3
											ld		(event_golgoth+19),hl
											ld		a,_CALL
											ld		(event_golgoth+21),a
											ld		hl,Update_missileG3_3
											ld		(event_golgoth+22),hl
							
										
										
											ld		a,11
											ld		(id_soucoupe),a
											ld		a,PV_GOLGOTH_5
											ld		(point_vie_golgoth),a
											xor		a
											ld		(EtpGolgoth),a
											ld		(Etp_ExploseGolgoth),a
											ld 		(EtpMissileG3_1),a
											ld 		(EtpMissileG3_2),a
											ld 		(EtpMissileG3_3),a

											ld		(CompteurMissileG3_1),a
											ld		(CompteurMissileG3_2),a
											ld		(CompteurMissileG3_3),a
				
											ld		hl,GOLGOTH5_SPRH_ADR_ROM
											ld		(GolgothAdrRom),hl
											ld		hl,SPRH6_ADR
											ld		(GolgothSprh),hl
											ld		hl,#600
											ld		(GolgothLongeur),hl
				
				
											ld		hl,Tbl_Gologoth5
											ld		(Pointeur_TblGolgoth_1),hl
											ld		hl,0
											ld		(posX_Golgoth),hl
											ld		hl,16
											ld		(posY_Golgoth),hl
											call	Update_Golgoth5_after
											rst		ASIC_CONNEXION
											ld		a,zoom_mode0_1
											ld		(SPRH6_ZOOM),a
											ld		(SPRH7_ZOOM),a
											ld		(SPRH8_ZOOM),a
											ld		(SPRH9_ZOOM),a
											ld		(SPRH10_ZOOM),a
											ld		(SPRH11_ZOOM),a
											; ld		(SPRH12_ZOOM),a
											; ld		(SPRH13_ZOOM),a
											ld		(valeur_zoom_sprh6),a
											ld		(valeur_zoom_sprh7),a
											ld		(valeur_zoom_sprh8),a
											ld		(valeur_zoom_sprh9),a
											ld		(valeur_zoom_sprh10),a
											ld		(valeur_zoom_sprh11),a
											; ld		(valeur_zoom_sprh12),a
											; ld		(valeur_zoom_sprh13),a
										
											ld		hl,Music
											ld		a,MUSIC_BOSS
											call	PLY_AKG_Init
											
											
											ld		hl,Update_Golgoth5
											ld		(PointeurUpdateGolgoth),hl	
											jp		ASIC_DECONNEXION
																									
											
											
; ////////////////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////////////////								
											
													Golgoth_Level_6
														ld		a,_JP							; JP pas_de_scroll_hard
														ld		(event_stop_scroll),a
														ld		hl,pas_de_scroll_hard
														ld		(event_stop_scroll+1),hl
														ld		a,_CALL
														ld		(event_golgoth),a
														ld		hl,golgoth_6
														ld		(event_golgoth+1),hl
														ld		a,_CALL
														ld		(event_golgoth+3),a
														ld		hl,Update_Golgoth_6
														ld		(event_golgoth+4),hl

														ld		a,_CALL
														ld		(event_golgoth+12),a
														ld		hl,missileG1_2
														ld		(event_golgoth+13),hl
														ld		a,_CALL
														ld		(event_golgoth+15),a
														ld		hl,Update_missileG1_2
														ld		(event_golgoth+16),hl
														ld		a,_CALL
														ld		(event_golgoth+18),a
														ld		hl,missileG1_3
														ld		(event_golgoth+19),hl
														ld		a,_CALL
														ld		(event_golgoth+21),a
														ld		hl,Update_missileG1_3
														ld		(event_golgoth+22),hl	
														ld		a,_CALL
														ld		(event_golgoth+24),a
														ld		hl,missileG1_4
														ld		(event_golgoth+25),hl	
														ld		a,_CALL
														ld		(event_golgoth+27),a
														ld		hl,Update_missileG1_4
														ld		(event_golgoth+28),hl
													
														xor		a
														ld		(EtpGolgoth),a
														ld		a,12
														ld		(id_soucoupe),a
														ld		a,PV_GOLGOTH_6
														ld		(point_vie_golgoth),a
														ld		hl,GOLGOTH6_SPRH_ADR_ROM
														ld		(GolgothAdrRom),hl
														ld		hl,SPRH6_ADR
														ld		(GolgothSprh),hl
														ld		hl,#500
														ld		(GolgothLongeur),hl
														ld		hl,Tbl_Gologoth6
														ld		(Pointeur_TblGolgoth_1),hl
														ld		hl,0
														ld		(posX_Golgoth),hl
														ld		hl,0
														ld		(posY_Golgoth),hl
														call	Update_Golgoth6_after
														ld		a,zoom_mode0_1
														ld		(SPRH6_ZOOM),a
														ld		(SPRH7_ZOOM),a
														ld		(SPRH8_ZOOM),a
														ld		(SPRH9_ZOOM),a
														ld		(SPRH10_ZOOM),a
														ld		(valeur_zoom_sprh6),a
														ld		(valeur_zoom_sprh7),a
														ld		(valeur_zoom_sprh8),a
														ld		(valeur_zoom_sprh9),a
														ld		(valeur_zoom_sprh10),a
														ld		hl,Music
														ld		a,MUSIC_BOSS
														call	PLY_AKG_Init
														
													
														ld		hl,Update_Golgoth6
														ld		(PointeurUpdateGolgoth),hl
														ret
														
; ////////////////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////////////////								
															Golgoth_Level_7
																ld		a,_JP							; JP pas_de_scroll_hard
																ld		(event_stop_scroll),a
																ld		hl,pas_de_scroll_hard
																ld		(event_stop_scroll+1),hl
																ld		a,_CALL
																ld		(event_golgoth),a
																ld		hl,golgoth_7
																ld		(event_golgoth+1),hl
																ld		a,_CALL
																ld		(event_golgoth+3),a
																ld		hl,Update_Golgoth_7
																ld		(event_golgoth+4),hl
																ld		a,_CALL
																ld		(event_golgoth+18),a
																ld		hl,missileG1_3
																ld		(event_golgoth+19),hl
																ld		a,_CALL
																ld		(event_golgoth+21),a
																ld		hl,Update_missileG1_3
																ld		(event_golgoth+22),hl	
																ld		a,_CALL
																ld		(event_golgoth+24),a
																ld		hl,missileG1_4
																ld		(event_golgoth+25),hl	
																ld		a,_CALL
																ld		(event_golgoth+27),a
																ld		hl,Update_missileG1_4
																ld		(event_golgoth+28),hl
															
																xor		a
																ld		(EtpGolgoth),a
																ld		a,13
																ld		(id_soucoupe),a
																ld		a,PV_GOLGOTH_7
																ld		(point_vie_golgoth),a
																ld		hl,GOLGOTH7_SPRH_ADR_ROM
																ld		(GolgothAdrRom),hl
																ld		hl,SPRH6_ADR
																ld		(GolgothSprh),hl
																ld		hl,#600
																ld		(GolgothLongeur),hl
																ld		hl,Tbl_Gologoth7
																ld		(Pointeur_TblGolgoth_1),hl
																ld		hl,0
																ld		(posX_Golgoth),hl
																ld		hl,0
																ld		(posY_Golgoth),hl
																call	Update_Golgoth7_after
																ld		a,zoom_mode0_1
																ld		(SPRH6_ZOOM),a
																ld		(SPRH7_ZOOM),a
																ld		(SPRH8_ZOOM),a
																ld		(SPRH9_ZOOM),a
																ld		(SPRH10_ZOOM),a
																ld		(SPRH11_ZOOM),a
																ld		(valeur_zoom_sprh6),a
																ld		(valeur_zoom_sprh7),a
																ld		(valeur_zoom_sprh8),a
																ld		(valeur_zoom_sprh9),a
																ld		(valeur_zoom_sprh10),a
																ld		(valeur_zoom_sprh11),a
																ld		hl,Music
																ld		a,MUSIC_BOSS
																call	PLY_AKG_Init
																ld		hl,Update_Golgoth7
																ld		(PointeurUpdateGolgoth),hl
																ret
																
																																										
; ////////////////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////////////////////////								
															Golgoth_Level_8
																ld		a,_JP							; JP pas_de_scroll_hard
																ld		(event_stop_scroll),a
																ld		hl,pas_de_scroll_hard
																ld		(event_stop_scroll+1),hl
																ld		a,_CALL
																ld		(event_golgoth),a
																ld		hl,golgoth_8
																ld		(event_golgoth+1),hl
																ld		a,_CALL
																ld		(event_golgoth+3),a
																ld		hl,Update_Golgoth_8
																ld		(event_golgoth+4),hl
																; ld		a,_CALL
																; ld		(event_golgoth+6),a
																; ld		hl,missileG1_1
																; ld		(event_golgoth+7),hl
																; ld		a,_CALL
																; ld		(event_golgoth+9),a
																; ld		hl,Update_missileG1_1
																; ld		(event_golgoth+10),hl
																; ld		a,_CALL
																; ld		(event_golgoth+12),a
																; ld		hl,missileG1_2
																; ld		(event_golgoth+13),hl
																; ld		a,_CALL
																; ld		(event_golgoth+15),a
																; ld		hl,Update_missileG1_2
																; ld		(event_golgoth+16),hl
																ld		a,_CALL
																ld		(event_golgoth+18),a
																ld		hl,missileG3_2
																ld		(event_golgoth+19),hl
																ld		a,_CALL
																ld		(event_golgoth+21),a
																ld		hl,Update_missileG3_2
																ld		(event_golgoth+22),hl	
																ld		a,_CALL
																ld		(event_golgoth+24),a
																ld		hl,missileG3_3
																ld		(event_golgoth+25),hl	
																ld		a,_CALL
																ld		(event_golgoth+27),a
																ld		hl,Update_missileG3_3
																ld		(event_golgoth+28),hl
															
																xor		a
																ld		(EtpGolgoth),a
																ld		a,14
																ld		(id_soucoupe),a
																ld		a,PV_GOLGOTH_8
																ld		(point_vie_golgoth),a
																ld		hl,GOLGOTH8_SPRH_ADR_ROM
																ld		(GolgothAdrRom),hl
																ld		hl,SPRH6_ADR
																ld		(GolgothSprh),hl
																ld		hl,#800
																ld		(GolgothLongeur),hl
																ld		hl,Tbl_Gologoth8
																ld		(Pointeur_TblGolgoth_1),hl
																ld		hl,0
																ld		(posX_Golgoth),hl
																ld		hl,0
																ld		(posY_Golgoth),hl
																call	Update_Golgoth8_after
																ld		a,zoom_mode0_1
																ld		(SPRH6_ZOOM),a
																ld		(SPRH7_ZOOM),a
																ld		(SPRH8_ZOOM),a
																ld		(SPRH9_ZOOM),a
																ld		(SPRH10_ZOOM),a
																ld		(SPRH11_ZOOM),a
																ld		(SPRH12_ZOOM),a
																ld		(SPRH13_ZOOM),a
																ld		(valeur_zoom_sprh6),a
																ld		(valeur_zoom_sprh7),a
																ld		(valeur_zoom_sprh8),a
																ld		(valeur_zoom_sprh9),a
																ld		(valeur_zoom_sprh10),a
																ld		(valeur_zoom_sprh11),a
																ld		(valeur_zoom_sprh12),a
																ld		(valeur_zoom_sprh13),a
																ld		hl,Music
																ld		a,MUSIC_BOSS
																call	PLY_AKG_Init
		
																ld		hl,GOLGOTH8_SPRH_ADR_ROM_ANIM1_CORP
																ld		(Golgoth_Corp_AdrRom),hl
																ld		hl,GOLGOTH8_SPRH_ADR_ROM_ANIM1_TETES
																ld		(Golgoth_Tete_AdrRom),hl
					
					

																ld		hl,Update_Golgoth8
																ld		(PointeurUpdateGolgoth),hl
																ret
																
																												

    


	