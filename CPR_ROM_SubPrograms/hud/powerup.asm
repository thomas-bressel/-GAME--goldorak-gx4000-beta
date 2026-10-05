
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////     GESTION POWERUP  //////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
powerup_ROM
	ld	a,(etp_powerup)
	cp	a,0
	jp	z,init_powerup
	cp	a,1
	jp	z,set_PowerUpBar
	cp	a,2
	jp	z,dec_PowerUpbar
	init_powerup
		inc		a
		ld		(etp_powerup),a
		ld		hl,HUD_DEPART_POWER_UP2+3
		ld		b,HUD_POWERUP_PIXEL_NOIR
		ld		e,7
		boucle_powerup_total
			ld		c,4
			push	hl
			.boucle_powerup
				ld		(hl),b
				ld		a,8
				add		a,h
				ld		h,a
				dec		c
				jr		nz,.boucle_powerup
				pop		hl
				dec		hl
				dec		e
				jr		nz,boucle_powerup_total
				ret
set_PowerUpBar
	ld		a,(flag_PowerUP)
	cp		a,0
	ret		Z
	cp		a,1
	jp		z,SetPowerUpBar_1
	cp		a,2
	jp		z,SetPowerUpBar_2
	SetPowerUpBar_1
		ld		a,(compteur_powerup_niv1)
		cp		a,0
		jr		nz,SetPowerUpBar_2

		ld		hl,HUD_DEPART_POWER_UP2
		ld		(PowerupBar_ECRAN),hl
		push	hl
		ld		de,Tbl_couleur_pixel
		ld		a,(de)
		ld		c,4
		boucle_SetPowerUpBar_1
			push	de

			ld		b,3
boucle_couleurs
		; couleur 1,2,3
			ld		(hl),a
			ld		a,8
			add		a,h
			ld		h,a
			inc		de
			ld		a,(de)
			dec 	b
			jr		nz,boucle_couleurs
		; couleur 4
			ld		(hl),a

		; on recupère l'adresse de départ de la table des couleur des pixels
			pop		de
		; on se place un 1 octet avant
			ld		hl,(PowerupBar_ECRAN)
			dec		hl
			ld		(PowerupBar_ECRAN),hl
			dec		c
			jr		nz,boucle_SetPowerUpBar_1
			pop		HL
			ld		(PowerupBar_ECRAN),hl
			ld		a,2
			ld		(etp_powerup),a


			call	fin_missiles_gamma2
; ----> BUG : la force et le bruitage des missiles gamma étaient écrits ici quelle que soit l'arme
;       choisie. Avec le planitron, le cornofulgure... en main, l'arme se retrouvait avec la force
;       des missiles gamma (1, 2 ou 4) jusqu'à ce qu'on la re sélectionne : les golgoths
;       devenaient interminables à détruire.
; ----> CORRECTION : seulement si ce sont bien les missiles gamma qui sont sélectionnés
;       (même correction aux 3 autres changements de niveau de power up plus bas)
			ld		b,FORCE_MISSILES_GAMMA2
			ld		c,SFX_GAMMA_LVL2
			call	maj_puissance_gamma

			xor 	a
			ld 		(etp_arme1),a
			ret

			SetPowerUpBar_2
				ld		hl,HUD_DEPART_POWER_UP1
				ld		(PowerupBar_ECRAN),hl
				push	hl
				ld		de,Tbl_couleur_pixel
				ld		a,(de)
				ld		c,7
				boucle_SetPowerUpBar_2
					push	de
					ld		b,3
				boucle_couleurs_2
				; couleur 1,2,3
					ld		(hl),a
					ld		a,8
					add		a,h
					ld		h,a
					inc		de
					ld		a,(de)
					dec 	b
					jr		nz,boucle_couleurs_2
				; couleur 4
					ld		(hl),a

				; on recupère l'adresse de départ de la table des couleur des pixels
					pop		de
				; on se place un 1 octet avant
					ld		hl,(PowerupBar_ECRAN)
					dec		hl
					ld		(PowerupBar_ECRAN),hl
					dec		c
					jr		nz,boucle_SetPowerUpBar_2
					pop		HL
					ld		(PowerupBar_ECRAN),hl
					ld		a,2
					ld		(etp_powerup),a
					call	fin_missiles_gamma2
					ld		b,FORCE_MISSILES_GAMMA3
					ld		c,SFX_GAMMA_LVL3
					call	maj_puissance_gamma
			xor 	a
			ld 		(etp_arme1),a
					ret




dec_PowerUpbar
; compteur de frame pour la vitesse à laquelle descends le power up
	ld		a,(CompteurFramePowerUp)
	inc		a
	ld		(CompteurFramePowerUp),a
	cp		a,VITESSE_PERTE_POWER_UP
	RET		NZ
	xor		a
	ld		(CompteurFramePowerUp),a
	ld		a,(flag_PowerUP)
	cp		a,1
	jr		z,DecrementePowerUp_Niv1
	cp		a,2
	jr		z,DecrementePowerUp_Niv2
DecrementePowerUp_Niv1
	ld		hl,(PowerupBar_ECRAN)
	ld		b,HUD_POWERUP_PIXEL_NOIR
	ld		c,4
.boucle_dec_powerup
	ld		(hl),b
	ld		a,8
	add		a,h
	ld		h,a
	dec		c
	jr		nz,.boucle_dec_powerup
	ld		hl,(PowerupBar_ECRAN)
	dec		hl
	ld		(PowerupBar_ECRAN),hl

	ld		a,(compteur_powerup_niv1)
	inc		a
	ld		(compteur_powerup_niv1),a
	cp		a,4
	jr		z,reinit_compteur_powerup_niv1
	ret
reinit_compteur_powerup_niv1
	xor		a
	ld		(compteur_powerup_niv1),a
	ld		(flag_PowerUP),a
	
	inc		a
	ld		(etp_powerup),a
	call	fin_missiles_gamma2
	ld		b,FORCE_MISSILES_GAMMA
	ld		c,SFX_GAMMA_LVL1
	call	maj_puissance_gamma
			xor 	a
			ld 		(etp_arme1),a
	ret





DecrementePowerUp_Niv2
	ld		hl,(PowerupBar_ECRAN)
	ld		b,HUD_POWERUP_PIXEL_NOIR
	ld		c,4
.boucle_dec_powerup2
	ld		(hl),b
	ld		a,8
	add		a,h
	ld		h,a
	dec		c
	jr		nz,.boucle_dec_powerup2
	ld		hl,(PowerupBar_ECRAN)
	dec		hl
	ld		(PowerupBar_ECRAN),hl
	ld		a,(compteur_powerup_niv2)
	inc		a
	ld		(compteur_powerup_niv2),a
	cp		a,3
	jr		z,reinit_compteur_powerup_niv2
	ret
reinit_compteur_powerup_niv2
	xor		a
	ld		(compteur_powerup_niv2),a
	ld		(compteur_powerup_niv1),a
	ld		hl,HUD_DEPART_POWER_UP2
	ld		(PowerupBar_ECRAN),hl
			xor 	a
			ld 		(etp_arme1),a

	call	fin_missiles_gamma2
	ld		a,1
	ld		(flag_PowerUP),a

; ----> BUG : en redescendant du power up 2 au power up 1 on gardait la force et le bruitage des
;       missiles gamma puissance 3 alors que ce sont les missiles puissance 2 qui sont tirés.
; ----> CORRECTION : force et bruitage de la puissance 2
	ld		b,FORCE_MISSILES_GAMMA2
	ld		c,SFX_GAMMA_LVL2
	call	maj_puissance_gamma
	ret


; en entrée : B = force des missiles gamma, C = leur bruitage
maj_puissance_gamma
	ld		a,(id_arme)
	cp		a,ID_MISSILES_GAMMA
	ret		nz
	ld		a,b
	ld		(points_attaque),a
	ld		a,c
	ld		(sfx_arme),a
	ret


fin_missiles_gamma2
; ----> BUG : cette routine coupe le tir en vol à chaque changement de niveau de power up, mais elle
;       ne remettait à zéro que l'étape des missiles gamma (etp_arme2). Si c'était un planitron, un
;       fulguropoing ou des clavicogyres qui étaient en vol, leur étape restait "en vol" avec
;       flag_fireA à zéro : au tir suivant l'arme repartait du milieu de sa course.
;       De plus avec le fulguropoing en main les poings disparaissaient de goldorak (zoom à zéro).
; ----> CORRECTION : remise à zéro complète de toutes les armes (raz_armes), et on rallume les
;       poings si c'est le fulguropoing qui est sélectionné.
	call	raz_armes
	ld		a,(id_arme)
	cp		a,ID_FULGUROPOING
	call	z,on_gere_fulguro_point
; ----> ATTENTION : PLY_AKG_StopSoundEffectFromChannel attend le numéro du canal dans A et pas dans C
;       (voir PlayerAkg_SoundEffects.asm : add a,a / add a,a / add a,a puis écriture de 2 zéros
;       à PLY_AKG_Channel1_SoundEffectData + A*8). Dans tout le jeu elle est appelée avec "ld c,n" :
;       ça ne tient que parce que A vaut 0 (après un xor a) ou #A0 (après un RST ASIC_DECONNEXION,
;       et #A0*8 fait 0 sur 8 bits) à chacun de ces appels : c'est donc toujours le canal 0 qui est coupé.
;       Avec A = 3 ou plus, les 2 zéros tombent dans le code de PLY_AKG_Init qui est logé juste après
;       les données des 3 canaux : plantage au changement de musique suivant (arrivée du golgoth).
; ----> on garde le comportement d'origine : A = 0
	xor		a
	call 	PLY_AKG_StopSoundEffectFromChannel
	ret
