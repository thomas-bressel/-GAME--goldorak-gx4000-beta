fin_attente_fireB_ROM
	ld 		a,SFX_WEAPONS_CHANGE	;Sound effect number (>=1)
    ld 		c,1 					;channel (0-2)
    ld 		b,SFX_VOLUME 					;Inverted volume (0-16)
    call 	PLY_AKG_PlaySoundEffect

; ----> BUG : en changeant d'arme pendant qu'un tir était encore en vol, l'état des armes devenait
;       incohérent :
;       - retour sur les missiles gamma (affiche_boutton_1) : l'évènement du tir était effacé mais
;         ni flag_fireA ni l'étape de l'arme -> fire A ne répondait plus du tout, jusqu'à ce que
;         goldorak se fasse toucher. Avec les missiles gamma seuls (début du jeu) il suffisait de
;         tirer puis d'appuyer sur fire B.
;       - les autres boutons ne remettaient rien à zéro : le tir de l'ancienne arme continuait
;         avec la force et les collisions de la nouvelle (fin_armes se base sur id_arme).
; ----> CORRECTION : une seule arme à la fois. Changer d'arme annule proprement le tir en vol
;       (flag, étapes, évènement et sprites hard 4 et 5), quelle que soit l'arme choisie.
	call	raz_armes
; ----> BUG : l'animation des poings qui rentrent n'était lancée que si l'arme suivante était les
;       clavicogyres. Sans eux, goldorak gardait les poings sortis avec une autre arme.
; ----> CORRECTION : dès que l'on quitte le fulguropoing, quelle que soit l'arme suivante
	ld		a,(id_arme)
	cp		a,ID_FULGUROPOING
	call	z,on_quitte_le_fulguro_poing

	xor		a
	ld		(counter_fireB),a
	ld		a,(id_arme)
	inc		a
	ld		(id_arme),a
	cp		a,ID_MISSILES_GAMMA
	jp		z,affiche_boutton_1			; missile gamma
	cp		a,ID_PLANITRON_TYPE_1
	jp		z,affiche_boutton_2			; planitron
	cp		a,ID_PLANITRON_TYPE_2
	jp		z,affiche_boutton_3			; planitron
	cp		a,ID_CORNOFULGURE
	jp		z,affiche_boutton_4			; cornofulgure
	cp		a,ID_FULGUROPOING
	jp		z,affiche_boutton_5			; fulguro point
	cp		a,ID_CLAVICOGYRES
	jp		z,affiche_boutton_6			; clavycogire
	cp		a,ID_PULVONIUM
	jp		z,affiche_boutton_7			; pulvonium
	cp		a,8
	jp		z,affiche_boutton_8
	; cp		a,9
	; jp		z,affiche_boutton_fin
	affiche_boutton_1
		ld		a,(ArmesDisponible)
		bit		0,a
		jr		z,affiche_boutton_2
		ld		a,ID_MISSILES_GAMMA
		ld		(id_arme),a
		ld		hl,HUD_BOUTON_ON_ADR
		ld		de,HUD_BOUTON1_ADR
		ld		b,HUD_HAUTEUR_BOUTTON
		call	bcl_affiche_bouton
		ld		hl,arme_missiles_gamma
		ld		(adr_type_arme),hl
; ----> BUG : en revenant sur les missiles gamma on remettait toujours la force et le bruitage du
;       niveau 1, même avec un power up en cours : les missiles puissance 2 ou 3 ne faisaient plus
;       que 1 point de dégat.
; ----> CORRECTION : la force et le bruitage suivent le niveau de power up en cours
		ld		b,FORCE_MISSILES_GAMMA
		ld		c,SFX_GAMMA_LVL1
		ld		a,(flag_PowerUP)
		or		a
		jr		z,.force_gamma_ok
		ld		b,FORCE_MISSILES_GAMMA2
		ld		c,SFX_GAMMA_LVL2
		dec		a
		jr		z,.force_gamma_ok
		ld		b,FORCE_MISSILES_GAMMA3
		ld		c,SFX_GAMMA_LVL3
	.force_gamma_ok
		ld		a,b
		ld		(points_attaque),a
		ld 		a,c	 ;Sound effect number (>=1))
		ld		(sfx_arme),a
; (l'effacement de event_arme_fireA et des zoom qui était ici est maintenant fait par raz_armes
;  en haut de la routine, avec flag_fireA et les étapes qui avaient été oubliés)
		ret
		affiche_boutton_2
			ld		a,(ArmesDisponible)
			bit		1,a
			jr		z,affiche_boutton_3
			ld		a,ID_PLANITRON_TYPE_1
			ld		(id_arme),a
			ld		hl,HUD_BOUTON_ON_ADR
			ld		de,HUD_BOUTON2_ADR
			ld		b,HUD_HAUTEUR_BOUTTON
			call	bcl_affiche_bouton
			ld		hl,HUD_BOUTON_AFF_ADR
			ld		de,HUD_BOUTON1_ADR
			ld		b,HUD_HAUTEUR_BOUTTON
			call	bcl_affiche_bouton
			ld		hl,arme_planitron
			ld		(adr_type_arme),hl
			ld		a,FORCE_PLANITRON_1
			ld		(points_attaque),a
			ld 		a,SFX_PLANITRON	 ;Sound effect number (>=1))
			ld		(sfx_arme),a
			ret
			affiche_boutton_3
				ld		a,(ArmesDisponible)
				bit		2,a
				jr		z,affiche_boutton_4
				ld		a,ID_PLANITRON_TYPE_2
				ld		(id_arme),a
				ld		hl,HUD_BOUTON_ON_ADR
				ld		de,HUD_BOUTON3_ADR
				ld		b,HUD_HAUTEUR_BOUTTON
				call	bcl_affiche_bouton
				ld		hl,HUD_BOUTON_AFF_ADR
				ld		de,HUD_BOUTON2_ADR
				ld		b,HUD_HAUTEUR_BOUTTON
				call	bcl_affiche_bouton
				ld		hl,arme_planitron2
				ld		(adr_type_arme),hl
				ld		a,FORCE_PLANITRON_2
				ld		(points_attaque),a
				ld 		a,SFX_PLANITRON	 ;Sound effect number (>=1))
				ld		(sfx_arme),a
				ret		
				affiche_boutton_4
					ld		a,(ArmesDisponible)
					bit		4,a
					jr		z,affiche_boutton_5
					ld		a,ID_CORNOFULGURE
					ld		(id_arme),a
					ld		hl,HUD_BOUTON_ON_ADR
					ld		de,HUD_BOUTON4_ADR
					ld		b,HUD_HAUTEUR_BOUTTON
					call	bcl_affiche_bouton
					ld		hl,HUD_BOUTON_AFF_ADR
					ld		de,HUD_BOUTON3_ADR
					ld		b,HUD_HAUTEUR_BOUTTON
					call	bcl_affiche_bouton
					ld		hl,arme_cornofulgure
						; ld		hl,arme_cornofulgure2
  						; ld		hl,arme_cornofulgure3
					ld		(adr_type_arme),hl
					ld		a,FORCE_CORNOFULGURE_1
					ld		(points_attaque),a
					ld 		a,SFX_CORNOFULGURE	 ;Sound effect number (>=1))
					ld		(sfx_arme),a
					ret
					affiche_boutton_5	
						ld		a,(ArmesDisponible)
						bit		3,a
						jr		z,affiche_boutton_6
						ld		a,ID_FULGUROPOING
						ld		(id_arme),a
						ld		hl,HUD_BOUTON_ON_ADR
						ld		de,HUD_BOUTON5_ADR
						ld		b,HUD_HAUTEUR_BOUTTON
						call	bcl_affiche_bouton
						ld		hl,HUD_BOUTON_AFF_ADR
						ld		de,HUD_BOUTON4_ADR
						ld		b,HUD_HAUTEUR_BOUTTON
						call	bcl_affiche_bouton
						ld		hl,arme_fulguro_poing
							ld		(adr_type_arme),hl
							ld		a,_CALL
							ld		(event_arme_fireB),a
							ld		hl,pre_init_fulguro_poing
							ld		(event_arme_fireB+1),hl
							call	raz_anim_fulguro_poing		; ----> CORRECTION : l'animation repart de sa 1ère étape
							ld		a,FORCE_FULGURO_POINGS
							ld		(points_attaque),a
							ld 		a,SFX_FULGORO_POINT	 ;Sound effect number (>=1))
							ld		(sfx_arme),a
							ret
						affiche_boutton_6
							ld		a,(ArmesDisponible)
							bit		5,a
							jr		z,affiche_boutton_7
							ld		a,ID_CLAVICOGYRES
							ld		(id_arme),a
							ld		hl,HUD_BOUTON_ON_ADR
							ld		de,HUD_BOUTON6_ADR
							ld		b,HUD_HAUTEUR_BOUTTON
							call	bcl_affiche_bouton
							ld		hl,HUD_BOUTON_AFF_ADR
							ld		de,HUD_BOUTON5_ADR
							ld		b,HUD_HAUTEUR_BOUTTON
							call	bcl_affiche_bouton


; ----> BUG : l'animation des poings qui rentrent était lancée ici, donc aussi quand on arrivait
;       sur les clavicogyres sans avoir le fulguropoing (goldorak sortait les poings une frame).
; ----> CORRECTION : elle est lancée en haut de fin_attente_fireB_ROM, uniquement quand l'arme
;       que l'on quitte est le fulguropoing (voir on_quitte_le_fulguro_poing)

								ld		hl,arme_clavicogyres
								ld		(adr_type_arme),hl
								ld		a,FORCE_CLAVICOGYRES
								ld		(points_attaque),a
								ld 		a,SFX_CLAVICOGYRE	 ;Sound effect number (>=1))
								ld		(sfx_arme),a
								ret
							affiche_boutton_7
								ld		a,(ArmesDisponible)
								bit		6,a
								jp		z,affiche_boutton_8
								ld		a,ID_PULVONIUM
								ld		(id_arme),a
								ld		hl,HUD_BOUTON_ON_ADR
								ld		de,HUD_BOUTON7_ADR
								ld		b,HUD_HAUTEUR_BOUTTON
								call	bcl_affiche_bouton
								ld		hl,HUD_BOUTON_AFF_ADR
								ld		de,HUD_BOUTON6_ADR
								ld		b,HUD_HAUTEUR_BOUTTON
								call	bcl_affiche_bouton
								ld		hl,arme_pulvonium
								ld		(adr_type_arme),hl
								ld		a,FORCE_PULVONIUM
								ld		(points_attaque),a
								ld 		a,SFX_PULVONIUM	 ;Sound effect number (>=1))
								ld		(sfx_arme),a
								ret		
								affiche_boutton_8
									ld		a,(ArmesDisponible)
									bit		7,a
									jp		z,affiche_boutton_1
									ld		a,8
									ld		(id_arme),a
									ld		hl,HUD_BOUTON_ON_ADR
									ld		de,HUD_BOUTON8_ADR
									ld		b,HUD_HAUTEUR_BOUTTON
									call	bcl_affiche_bouton
									ld		hl,HUD_BOUTON_AFF_ADR
									ld		de,HUD_BOUTON7_ADR
									ld		b,HUD_HAUTEUR_BOUTTON
									call	bcl_affiche_bouton
									; xor 	a
									; ld		(event_arme_fireA),a
									; ld		(event_arme_fireA+1),a
									; ld		(event_arme_fireA+2),a
									; ld		(SPRH4_ZOOM),a
									; ld		(SPRH5_ZOOM),a

									; ld		(valeur_zoom_sprh4),a
									; ld		(valeur_zoom_sprh5),a


									

									ret
									; affiche_boutton_fin

									; 	ld		hl,HUD_BOUTON_AFF_ADR
									; 	ld		de,HUD_BOUTON8_ADR
									; 	ld		b,HUD_HAUTEUR_BOUTTON
									; 	call	bcl_affiche_bouton
									; 	ld		hl,HUD_BOUTON_ON_ADR
									; 	ld		de,HUD_BOUTON1_ADR
									; 	ld		b,HUD_HAUTEUR_BOUTTON
									; 	call	bcl_affiche_bouton
									; 	jp		affiche_boutton_1
	
	
	
pre_anim_fulguro_poing_ROM		
			ld		a,1
			ld		(flag_fulguro),a
			ld		hl,Tbl_sprh_direction
			ld		de,GOLDORAK_HAUTBAS_ANIMPOINT1_SPRH_ROM_ADR
			ld		(hl),e : inc hl
			ld		(hl),d : inc hl
			ld		de,GOLDORAK_GAUCHE_ANIMPOINT1_SPRH_ROM_ADR
			ld		(hl),e : inc hl
			ld		(hl),d : inc hl
			ld		de,GOLDORAK_DROITE_ANIMPOINT1_SPRH_ROM_ADR
			ld		(hl),e : inc hl
			ld		(hl),d : inc hl
			ld		hl,(Tbl_sprh_direction)
			ld		(sprh_goldorak),hl	
			RST		ASIC_CONNEXION
		
			xor		a:ld (SPRH4_ZOOM),a:ld	(SPRH5_ZOOM),a
			ld		(valeur_zoom_sprh4),a : ld (valeur_zoom_sprh5),a 
			jp		ASIC_DECONNEXION
			
				pre_anim_fulguro_poing_2_ROM
					ld		hl,Tbl_sprh_direction
					ld		de,GOLDORAK_HAUTBAS_ANIMPOINT2_SPRH_ROM_ADR
					ld		(hl),e : inc hl
					ld		(hl),d : inc hl
					ld		de,GOLDORAK_GAUCHE_ANIMPOINT2_SPRH_ROM_ADR
					ld		(hl),e : inc hl
					ld		(hl),d : inc hl
					ld		de,GOLDORAK_DROITE_ANIMPOINT2_SPRH_ROM_ADR
					ld		(hl),e : inc hl
					ld		(hl),d : inc hl
					ld		hl,(Tbl_sprh_direction)
					ld		(sprh_goldorak),hl

					RST		ASIC_CONNEXION
					ld		hl,(SPRH0_X)
					ld		de,22:add hl,de:ld	(SPRH4_X),hl 			; on calcule l'emplacement de l'arme en fonctione des coordonnée de Goldorak
					ld		de,20:add hl,de:ld (SPRH5_X),hl								; on calcule le 2eme sprite par rapport au 1er
					ld		hl,(SPRH0_Y):ld	de,-14:add hl,de
					ld		(SPRH4_Y),hl:ld	(SPRH5_Y),hl
					ld		a,zoom_mode0_1:ld (SPRH4_ZOOM),a:ld	(SPRH5_ZOOM),a
					ld		(valeur_zoom_sprh4),a : ld (valeur_zoom_sprh5),a 
					ret

pre_init_fulguro_poing_retour_ROM
		ld		a,(counter_pre_poing)
		inc		a
		ld		(counter_pre_poing),a
		cp		a,1
		ret		nz
		xor		a
		ld		(counter_pre_poing),a
		ld		a,(etp_pre_poing)
		cp		a,0
		jp		z,pre_anim_fulguro_poing
		cp		a,2
		jp		z,pre_anim_fulguro_poing_3
		cp		a,4
		jp		z,pre_anim_fulguro_poing_fin3
		inc		a
		ld		(etp_pre_poing),a
		ret
			pre_anim_fulguro_poing_3
				inc		a: ld	(etp_pre_poing),a
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
				ld		hl,(Tbl_sprh_direction)
				ld		(sprh_goldorak),hl
				ret
					pre_anim_fulguro_poing_fin3
						xor	a
						ld	(etp_pre_poing),a
						ld	(event_arme_fireB),a
						ld	(event_arme_fireB+1),a
						ld	(event_arme_fireB+2),a
						ld	(flag_fulguro),a
; ----> BUG : c'est ici que partaient les plantages des armes. A la fin de l'animation on forçait
;       adr_type_arme sur les clavicogyres. Or quand on faisait défiler les armes en gardant fire B
;       appuyé, cette animation se terminait jusqu'à 5 secondes plus tard (voir raz_anim_fulguro_poing) :
;       le joueur était déjà sur une autre arme. Au tir suivant l'évènement de tir recevait donc
;       l'adresse des clavicogyres avec le _CALL du cornofulgure ou du pulvonium -> la pile se
;       décalait de 2 octets à chaque frame -> plantage au bout de quelques tirs.
; ----> CORRECTION : on ne touche plus à adr_type_arme, affiche_boutton_6 l'a déjà renseigné.
;       (et les init des armes n'utilisent plus adr_type_arme, voir 09-armes_fireA.asm)

; ----> BUG : on cachait les sprites hard 4 et 5 même si un tir de la nouvelle arme était déjà parti
; ----> CORRECTION : seulement si aucun tir n'est en vol
						ld		a,(flag_fireA)
						or		a
						ret		nz
						RST		ASIC_CONNEXION
						ld		hl,SPRH_ARMES_GOLDORAK_CACHER
						ld		(SPRH4_X),hl
						ld		(SPRH4_Y),hl
						ld		(SPRH5_X),hl
						ld		(SPRH5_Y),hl
						ret

; //////////////////////////////////////////////////////////////////
; on arrive ici quand on quitte le fulguropoing pour une autre arme
on_quitte_le_fulguro_poing
	ld		a,_CALL
	ld		(event_arme_fireB),a
	ld		hl,pre_init_fulguro_poing_retour
	ld		(event_arme_fireB+1),hl

; ----> BUG : les deux animations des poings (ils sortent : 1 étape toutes les 4 frames, ils
;       rentrent : 1 étape par frame) se partagent counter_pre_poing et etp_pre_poing sans les
;       remettre à zéro. En changeant d'arme pendant que les poings sortaient, le compteur était
;       déjà au delà de 1 : l'animation de retour attendait qu'il refasse un tour complet
;       (255 frames, soit 5 secondes) avant de démarrer.
; ----> CORRECTION : chaque animation repart de zéro
raz_anim_fulguro_poing
	xor		a
	ld		(counter_pre_poing),a
	ld		(etp_pre_poing),a
	ret
			