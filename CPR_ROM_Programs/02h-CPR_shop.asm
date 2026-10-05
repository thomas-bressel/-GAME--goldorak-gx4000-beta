shop
; on reinitialise le crtc
CALL	reinit_crtc_et_retard_video
ld	a,(fini)
cp	a,1
jp	z,PreparationLevelSuivant

ld	a,(flag_on_joue_avec_alcorak)
cp	a,1
jp	z,PreparationLevelSuivant

; /////////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////// POSITIONNEMENT de L'ECRAN ///////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////
Asic ON
	xor		a
	ld 		(#6801),a					; ligne de 2eme split
	ld		a,#10:ld (#6802),a					; registre 12
	LD 		BC,#BC01:OUT (C),C			; rognage du bord droit de 16 caracteres (32 octets)
	LD 		BC,#BD00+40:OUT (C),C
	LD 		BC,#BC02:OUT (C),C			; on pousse l'ecran vers la droite pour le recentrer
	LD 		BC,#BD00+46:OUT (C),C
	LD 		BC,#BC07:OUT (C),C			; on decale l'ecran vers le haut
	LD 		BC,#BD00+30:OUT (C),C
	LD 		BC,#BC06:OUT (C),C			; on agrandit l'ecran vers le bas
	LD 		BC,#BD00+25:OUT (C),C
Asic OFF	
	LD 		BC,BANK4_MENU:OUT (C),C				; on choisit DE LIRE la ROM 15
	LD		BC,#7F00+%10000000:OUT (C),C 			; connexion de la ROM supérieure et de la ROM inférieure et écran en mode 0.
	LD 		BC,#7FC0:OUT (c),c						; on choisit D'ECRIRE  dans la RAM centrale
	ld		hl,SHOP_SCREEN_ADR							; lecture dans la bank ROM
	ld		de,#4000							; ecriture dans le bank RAM #4000
	call	DepkZX0								; on décompresse
	ld		hl,#4000
	ld		de,#c000
	ld		bc,#4000							; longueur
	LDIR

; /////////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////// AFFICHAGE DU STOCK DE LA BOUTIQUE //////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////
; test pour savoir quel armes nous avons en notre possession et auquel cas quelle case afficher ou non
	ld		a,(ArmesDisponible)
	bit		1,a
	call	nz,CaseClose_Planitron1
	bit		2,a
	call	nz,CaseClose_Planitron2
	bit		6,a
	call	nz,CaseClose_Pulvonium
	bit		4,a
	call	nz,CaseClose_Cornofulgure
	bit		3,a
	call	nz,CaseClose_Fulguropoint
	bit		5,a
	call	nz,CaseClose_Clavicogyre
	jp		Test_SoldeDisponible
	CaseClose_Planitron1
		ld		hl,CASE_PLANITRON_ECRAN
		ld		(Adr_CaseEcran),hl
		call	On_Ferme_Le_Volet
		or		a
		ld		a,(ArmesDisponible)
		
		ret
		CaseClose_Planitron2
			ld		hl,CASE_PLANITRON2_ECRAN
			ld		(Adr_CaseEcran),hl
			call	On_Ferme_Le_Volet
			or		a
			ld		a,(ArmesDisponible)
			ret
			CaseClose_Pulvonium
				ld		hl,CASE_PULVONIUM_ECRAN
				ld		(Adr_CaseEcran),hl
				call	On_Ferme_Le_Volet
				or		a
				ld		a,(ArmesDisponible)
				ret
				CaseClose_Cornofulgure
					ld		hl,CASE_CORNOFULGURE_ECRAN
					ld		(Adr_CaseEcran),hl
					call	On_Ferme_Le_Volet
					or		a
					ld		a,(ArmesDisponible)
					ret
					CaseClose_Fulguropoint
						ld		hl,CASE_FULGUROPOINT_ECRAN
						ld		(Adr_CaseEcran),hl
						call	On_Ferme_Le_Volet
						or		a
						ld		a,(ArmesDisponible)
						ret
						CaseClose_Clavicogyre
							ld		hl,CASE_CLAVICOGYRE_ECRAN
							ld		(Adr_CaseEcran),hl
							call	On_Ferme_Le_Volet
							or		a
							ld		a,(ArmesDisponible)
							ret
On_Ferme_Le_Volet
	ld 		bc,BANK8_PALETTES:OUT (C),C				; on choisit DE LIRE la ROM 14
	ld		bc,#7F00+%10000000:OUT (C),C 		; connexion de la ROM supérieure et de la ROM inférieure et écran en mode 0.
	ld 		bc,#7FC0:OUT (c),c					; on choisit D'ECRIRE  dans la RAM centrale
	ld		hl,CASE_FERME_ROM
	ld		de,(Adr_CaseEcran)
	ld		bc,HAUTEUR_CASE
	ld		b,c
		.boucle
			push	bc
			ld		bc,12
			push	de
			ldir
			pop		de
			call 	ligneinf_c000
			pop		bc
			djnz	.boucle
			ret

Test_SoldeDisponible
	LD 		BC,BANK2_INIT:OUT (C),C				; on choisit DE LIRE la ROM 14
	LD		BC,#7F00+%10000000:OUT (C),C 		; connexion de la ROM supérieure et de la ROM inférieure et écran en mode 0.
	; on place les adresse du compteur de point à l'écran
	ld		hl,HUD_SCORE_SHOP_UNITE_ADR
	ld		(HUD_SCORE_UNITE_ADR_hud),hl
	ld		hl,HUD_SCORE_SHOP_DIZAINNE_ADR
	ld		(HUD_SCORE_DIZAINNE_ADR_hud),hl
	ld		hl,HUD_SCORE_SHOP_CENTAINE_ADR
	ld		(HUD_SCORE_CENTAINE_ADR_hud),hl
	ld		hl,HUD_SCORE_SHOP_MILLIER_ADR
	ld		(HUD_SCORE_MILLIER_ADR_hud),hl
	ld		hl,HUD_SCORE_SHOP_DIZAINE_DE_MILLIER_ADR
	ld		(HUD_SCORE_DIZAINE_DE_MILLIER_ADR_hud),hl
	
	call	Affiche_ScoreTotal



Affichage_Palette
; copie de la palette CPC+ (logé en bank 19) specialement pour le screen
	Asic ON
	LD 		BC,BANK8_PALETTES:OUT (C),C				; on choisit DE LIRE la ROM 14
	LD		BC,#7F00+%10000000:OUT (C),C 		; connexion de la ROM supérieure et de la ROM inférieure et écran en mode 0.
	LD 		BC,#7FC0:OUT (c),c					; on choisit D'ECRIRE  dans la RAM centrale
	ld		hl,PALETTE_SHOP						; lecture
	ld		de,#6400							; ecriture
	ld		bc,#20								; longueur
	LDIR
	ld		hl,PALETTE_SHOP							; lecture
	ld		de,Adresse_pallette_screen							; ecriture
	ld		bc,#20								; longueur
	LDIR
	Asic OFF
	ld		bc,#7F00+%10001000				; ROM inf déconnectée, ROM sup déconnectée, MODE 0
	out		(c),c			
; ////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////    BOUCLE PRINCIPALE      ////////////////////////////////
; /////////////////////////           de              ////////////////////////////////
; /////////////////////////       la boutique    	    //////////////////////////////
; ////////////////////////////////////////////////////////////////////////////////////
	ld	sp,#BFFE
	Asic ON
; placement du curseur par défaut
	ld	hl,CASE_CORNOFULGURE_ECRAN
	ld	(Adr_CaseEcran),hl
	ld	hl,Case_Cornofulgure
	ld	a,%00010000
	ld	(ChoixNouvelleArme),a
	ld	(Selection_ArmeCurseur),hl
	ld	hl,CURSOR_ORIGIN_X
	ld	de,CURSOR_ORIGIN_Y
	ld	(SPRH15_X),hl
	ld	(SPRH15_Y),de

	ld	a,zoom_mode0_1
	ld	(SPRH15_ZOOM),a
	ld	(valeur_zoom_sprh15),a

	ld	hl,Tableau_position_curseur+10
	ld	(pointeur_TblPosCurseur),hl


	;call	init_musique_boutique



boucle_shop
	ld      b,#F5
		.VBL_shop
			in      a,(c)
			rra
			jr 		nc,.VBL_shop

 ;call	musique_boutique
	call	lecture_clavier
		bit		0,a
		jp		z,Curseur_Haut
			bit		1,a
			jp		z,Curseur_Bas
				bit		2,a
				jp		z,Curseur_Gauche
					bit		3,a
					jp		z,Curseur_Droite
						bit		4,a
						jp		z,Curseur_Validation
							bit		5,a
							jp		z,PreparationLevelSuivant
	jp boucle_shop

Curseur_Bas
	xor		a
	ld		(flag_SoldeOk),a
	ld		hl,SPRH15_Y
	ld		(Sprh_Cursor),hl
	ld		b,16+16+16
	ld		c,1
	ld		de,8
	call	Deplace_Curseur
	ld		hl,(Selection_ArmeCurseur)
	jp		(hl)
		Curseur_Haut
			xor		a
			ld		(flag_SoldeOk),a
			ld		hl,SPRH15_Y
			ld		(Sprh_Cursor),hl
			ld		b,3*16
			ld		c,-1
			ld		de,-8
			call	Deplace_Curseur
			ld		hl,(Selection_ArmeCurseur)
			jp		(hl)
				Curseur_Gauche
					xor		a
					ld		(flag_SoldeOk),a
					ld		hl,SPRH15_X
					ld		(Sprh_Cursor),hl
					ld		a,#FF
					ld		(retenue_poidfort),a
					ld		b,32+32+32+16
					ld		c,-1
					ld		de,-2
					call	Deplace_Curseur
					ld		hl,(Selection_ArmeCurseur)
					jp		(hl)
						Curseur_Droite
							xor		a
							ld		(flag_SoldeOk),a
							ld		hl,SPRH15_X
							ld		(Sprh_Cursor),hl
							ld		a,0
							ld		(retenue_poidfort),a
							ld		b,32+32+32+16
							ld		c,1
							ld		de,2
							call	Deplace_Curseur
							ld		hl,(Selection_ArmeCurseur)
							jp		(hl)

								Deplace_Curseur
									ld		hl,(pointeur_TblPosCurseur)
									add		hl,de
									ld		a,(hl)
									cp		a,#FF
									jr		z,reinit_flag
									ld		(pointeur_TblPosCurseur),hl
									ld		e,(hl)
									inc		hl
									ld		d,(hl)
									ld		(Selection_ArmeCurseur),de
										.boucle_curseur
											push 	bc
											ld		hl,(Sprh_Cursor)			; on récupère l'adresse ASIC de X ou Y sur Sprite Hard
											ld		e,(hl)						; on récupère le contenu du poids faible
											inc		hl							; on pointe sur le poid fort
											ld		d,(hl)						; on récupère le contenu du poid fort
											ex		hl,de						; echange le contenu avec HL pour le calcule. DE contient l'adresse ASIC (poid fort)
											ld		a,(retenue_poidfort)
											ld		b,a
											add		hl,bc
											ex		de,hl
											ld		(hl),d
											dec		hl
											ld		(hl),e
											ld      b,#F5
												.VBL_curseur
													in      a,(c)
													rra
													jr 		nc,.VBL_curseur
											pop 	bc
											dec 	b
											jr		nz,.boucle_curseur
											ret
												reinit_flag
													xor	a
													or  a
													ret


Curseur_Validation
	ld		a,(flag_SoldeOk)
	cp		a,0
	jp		z,boucle_shop
; on ferme le volet
	ld 		bc,BANK8_PALETTES:OUT (C),C				; on choisit DE LIRE la ROM 14
	ld		bc,#7F00+%10000000:OUT (C),C 		; connexion de la ROM supérieure et de la ROM inférieure et écran en mode 0.
	ld 		bc,#7FC0:OUT (c),c					; on choisit D'ECRIRE  dans la RAM centrale
	ld		hl,CASE_FERME_ROM
	ld		de,(Adr_CaseEcran)
	ld		bc,HAUTEUR_CASE
	ld		b,c
		.boucle
			push	bc
			ld		bc,12
			push	de
			ldir
			pop		de
			call 	ligneinf_c000
			pop		bc
			djnz	.boucle

	ld	hl,Counter_score2
	ld	de,Counter_score
	ldi : ldi
	ldi : ldi
	ldi
	xor		a
	ld		(flag_SoldeOk),a

; configure la nouvelle arme
	ld		a,(ArmesDisponible)
	ld		b,a
	ld		a,(ChoixNouvelleArme)
	or		b
	ld		(ArmesDisponible),a

	call	Affiche_ScoreTotal
	Asic ON
	xor		a
	ld		(SPRH15_ZOOM),a
	ld	(valeur_zoom_sprh15),a

	jp		boucle_shop


Case_Cornofulgure
	ld		a,(ArmesDisponible)
	bit		4,a
	jp		nz,boucle_shop
	exx
	ld		a,(Cout_Cornofulgure)
	ld		l,a
	ld		a,(Cout_Cornofulgure+1)
	ld		h,a
	ld		a,(Cout_Cornofulgure+2)
	ld		e,a
	ld		a,(Cout_Cornofulgure+3)
	ld		d,a
	ld		a,(Cout_Cornofulgure+4)
	ld		c,a
	call	Decompte_PointsCouts
	ld		hl,CASE_CORNOFULGURE_ECRAN
	ld		(Adr_CaseEcran),hl
	ld		a,%00010000			; bit 4
	ld		(ChoixNouvelleArme),a
	jp		boucle_shop

		Case_Pulvonium
				ld		a,(ArmesDisponible)
				bit		6,a
				jp		nz,boucle_shop
				exx
				ld		a,(Cout_Pulvonium)
				ld		l,a
				ld		a,(Cout_Pulvonium+1)
				ld		h,a
				ld		a,(Cout_Pulvonium+2)
				ld		e,a
				ld		a,(Cout_Pulvonium+3)
				ld		d,a
				ld		a,(Cout_Pulvonium+4)
				ld		c,a
				call	Decompte_PointsCouts
				ld		hl,CASE_PULVONIUM_ECRAN
				ld		(Adr_CaseEcran),hl
				ld		a,%01000000 ; bit 6
				ld		(ChoixNouvelleArme),a
				jp		boucle_shop
					
					Case_Clavicogyre
							ld		a,(ArmesDisponible)
							bit		5,a
							jp		nz,boucle_shop
							exx
							ld		a,(Cout_Clavicogyre)
							ld		l,a
							ld		a,(Cout_Clavicogyre+1)
							ld		h,a
							ld		a,(Cout_Clavicogyre+2)
							ld		e,a
							ld		a,(Cout_Clavicogyre+3)
							ld		d,a
							ld		a,(Cout_Clavicogyre+4)
							ld		c,a
							call	Decompte_PointsCouts
							ld		hl,CASE_CLAVICOGYRE_ECRAN
							ld		(Adr_CaseEcran),hl
							ld		a,%00100000 ; bit 5
							ld		(ChoixNouvelleArme),a
							jp		boucle_shop
							
									Case_Planitron1
											ld		a,(ArmesDisponible)
											bit		1,a
											jp		nz,boucle_shop
											exx
											ld		a,(Cout_Planitron1)
											ld		l,a
											ld		a,(Cout_Planitron1+1)
											ld		h,a
											ld		a,(Cout_Planitron1+2)
											ld		e,a
											ld		a,(Cout_Planitron1+3)
											ld		d,a
											ld		a,(Cout_Planitron1+4)
											ld		c,a
											call	Decompte_PointsCouts
											ld		hl,CASE_PLANITRON_ECRAN
											ld		(Adr_CaseEcran),hl
											ld		a,%00000010 ; bit 1
											ld		(ChoixNouvelleArme),a
											jp		boucle_shop

													Case_Planitron2
															ld		a,(ArmesDisponible)
															bit		2,a
															jp		nz,boucle_shop
															exx
															ld		a,(Cout_Planitron2)
															ld		l,a
															ld		a,(Cout_Planitron2+1)
															ld		h,a
															ld		a,(Cout_Planitron2+2)
															ld		e,a
															ld		a,(Cout_Planitron2+3)
															ld		d,a
															ld		a,(Cout_Planitron2+4)
															ld		c,a
															call	Decompte_PointsCouts
															ld		hl,CASE_PLANITRON2_ECRAN
															ld		(Adr_CaseEcran),hl
															ld		a,%00000100 ; bit 2
															ld		(ChoixNouvelleArme),a
															jp		boucle_shop
					
																		Case_Fulguropoint
																				ld		a,(ArmesDisponible)
																				bit		3,a
																				jp		nz,boucle_shop
																				exx
																				ld		a,(Cout_Fulguropoint)
																				ld		l,a
																				ld		a,(Cout_Fulguropoint+1)
																				ld		h,a
																				ld		a,(Cout_Fulguropoint+2)
																				ld		e,a
																				ld		a,(Cout_Fulguropoint+3)
																				ld		d,a
																				ld		a,(Cout_Fulguropoint+4)
																				ld		c,a
																				call	Decompte_PointsCouts
																				ld		hl,CASE_FULGUROPOINT_ECRAN
																				ld		(Adr_CaseEcran),hl
																				ld		a,%00001000 ; bit 3
																				ld		(ChoixNouvelleArme),a
																				jp		boucle_shop



Decompte_PointsCouts		
	; chiffre des unitée
	ld		a,(Counter_score+4)		; Solde disponible en registre A
	sub		a,c						; Solde - Cout
	call	c,debordement_unitees
	ld		(Counter_score2+4),a		; on écrit en RAM les unitées
		; chiffre des dizaines
		ld		a,(Counter_score+3)		; Solde disponible en registre A
		sub		a,d						; Solde - Cout
		call	c,debordement_dizaines
		ld		(Counter_score2+3),a		; on écrit en RAM les dizaines
			; chiffre des centaines
			ld		a,(Counter_score+2)		; Solde disponible en registre A
			sub		a,e						; Solde - Cout
			call	c,debordement_centaines
			ld		(Counter_score2+2),a		; on écrit en RAM les centaines
				; chiffre des milliers
				ld		a,(Counter_score+1)		; Solde disponible en registre A
				sub		a,h						; Solde - Cout
				call	c,debordement_milliers
				ld		(Counter_score2+1),a		; on écrit en RAM les milliers
					; chiffre des dizaine de milliers
					ld		a,(Counter_score)		; Solde disponible en registre A
					sub		a,l						; Solde - Cout
					jr		c,Pas_AssezDePoints
					ld		(Counter_score2),a		; on écrit en RAM les milliers
					exx
					ld		a,1
					ld		(flag_SoldeOk),a
					ret

debordement_unitees
	add	a,c			; on retablie A avant debordement
	add	a,10		; on ajoute 10 pour soustraire sans débordement
	inc	d			; on incremente les dizaines pour la retenue
	sub a,c
	ret
debordement_dizaines
	add	a,d			; on retablie A avant debordement
	add	a,10		; on ajoute 10 pour soustraire sans débordement
	inc	e			; on incremente les centaines pour la retenue
	sub a,d
	ret
debordement_centaines
	add	a,e			; on retablie A avant debordement
	add	a,10		; on ajoute 10 pour soustraire sans débordement
	inc	h			; on incremente les milliers pour la retenue
	sub a,e
	ret
debordement_milliers
	add	a,h			; on retablie A avant debordement
	add	a,10		; on ajoute 10 pour soustraire sans débordement
	inc	l			; on incremente les dizaines de milliers pour la retenue
	sub a,h
	ret
Pas_AssezDePoints
	pop	ix			; on recale la pile
	exx
	xor		A
	ld		(flag_SoldeOk),a
	jp		boucle_shop




Affiche_ScoreTotal
exx
			ld		a,(Counter_score+4)			; on recupère les unitées
			ld		c,a						; on tranfer dans c
			ld		a,(Counter_score+3)
			ld		d,a
			ld		a,(Counter_score+2)
			ld		E,a
			ld		a,(Counter_score+1)
			ld		h,a
			ld		a,(Counter_score)
			ld		l,a
	exx
	Asic Off
	LD 		BC,BANK8_PALETTES:OUT (C),C				; on choisit DE LIRE la ROM 14
	LD		BC,#7F00+%10000000:OUT (C),C 		; connexion de la ROM supérieure et de la ROM inférieure et écran en mode 0.
	ld		hl,(HUD_SCORE_DIZAINE_DE_MILLIER_ADR_hud)
	ld		(pointeur_chiffre_SCR),hl
	ld		b,5
	ld		de,SCORE_FONTE_OK+#100
	ld		(adr_hud_font),de
	CALL	boucle_affichage_du_score
	ret

Tableau_position_curseur
	dw	#FFFF,#FFFF,#FFFF,#FFFF
	dw 	#FFFF,Case_Cornofulgure,Case_Pulvonium,#FFFF
	dw	#FFFF,Case_Clavicogyre,Case_Planitron2,#FFFF
	dw	#FFFF,Case_Planitron1,Case_Fulguropoint,#FFFF
	dw	#FFFF,#FFFF,#FFFF,#FFFF


Cout_Cornofulgure
	;	l,h,e,d,c
	db	0,5,0,0,0		; Cornofulgure
Cout_Pulvonium	
	db	0,7,0,0,0		; Pulvonium
Cout_Clavicogyre
	db	0,6,0,0,0		; Clavicogyre
Cout_Planitron1
	db	0,2,0,0,0		; Planitron 1
Cout_Planitron2
	db	0,2,5,0,0		; Planitron 2
Cout_Fulguropoint
	db	0,3,5,0,0		; Fulguropoint


PreparationLevelSuivant
	;call stop_musique_boutique
	call	FADE_OUT
	Asic 	ON		
	ld		(#6004),a : ld (valeur_zoom_sprh0),a
	ld		(#600C),a : ld (valeur_zoom_sprh1),a
	ld		(#6014),a : ld (valeur_zoom_sprh2),a
	ld		(#601C),a : ld (valeur_zoom_sprh3),a
	ld		(#6024),a : ld (valeur_zoom_sprh4),a
	ld		(#602C),a : ld (valeur_zoom_sprh5),a
	ld		(#6034),a : ld (valeur_zoom_sprh6),a
	ld		(#603C),a : ld (valeur_zoom_sprh7),a
	ld		(#6044),a : ld (valeur_zoom_sprh8),a
	ld		(#604C),a : ld (valeur_zoom_sprh9),a
	ld		(#6054),a : ld (valeur_zoom_sprh10),a
	ld		(#605C),a : ld (valeur_zoom_sprh11),a
	ld		(#6064),a : ld (valeur_zoom_sprh12),a
	ld		(#606C),a : ld (valeur_zoom_sprh13),a
	ld		(#6074),a : ld (valeur_zoom_sprh14),a
	ld		(#607C),a : ld (valeur_zoom_sprh15),a
	Asic 	OFF
		; mise à zéros de la bank #4000-#BFFF
		xor		a
		ld		hl,#4000
		ld		e,l
		ld		d,h
		inc		de
		ld		(hl),a
		ld		bc,#3fff
		LDIR
		jp		init_nouveau_level

			PreparationEcran
			; /////////////////////////////////////////////////////////////////////////////////////////////////
			; /////////////////////////////////// POSITIONNEMENT de L'ECRAN ///////////////////////////////////
			; /////////////////////////////////////////////////////////////////////////////////////////////////
				LD 		BC,#BC01:OUT (C),C			; rognage du bord droit de 16 caracteres (32 octets)
				LD 		BC,#BD00+32:OUT (C),C
				LD 		BC,#BC02:OUT (C),C			; on pousse l'ecran vers la droite pour le recentrer
				LD 		BC,#BD00+42:OUT (C),C
				LD 		BC,#BC07:OUT (C),C			; on decale l'ecran vers le haut
				LD 		BC,#BD00+34:OUT (C),C		; 35
				LD 		BC,#BC06:OUT (C),C			; on agrandit l'ecran vers le bas
				LD 		BC,#BD00+32:OUT (C),C
			; //////////////////////////////////////////////////////////////////
			; //////////////////////////    RUPTURE     /////////////////////////
			; //////////////////////////////////////////////////////////////////
				ld 		bc,#bc00+12:out (c),c   			;R12 selectionne
				ld 		bc,#bd00+#10:out (c),c 				;Ecran en #4000
				Asic ON
				ld		a,LGN_RUPTURE_HUD:ld (#6801),a					; ligne de 2eme split
				ld		a,#10:ld (#6802),a					; registre 12
				ld 		bc,#bc00+12:out (c),c      			; R12 selectionne
				ld 		bc,#BD00+#30:out (c),c 				; Ecran en #c000
				Asic off
			; //////////////////////////////////////////////////////////////////
			; //////////////////////////////////////////////////////////////////
			; ////////////////////    COPIE des palettes       /////////////////
			; //////////////////////////////////////////////////////////////////
			; //////////////////////////////////////////////////////////////////
				LD 		BC,BANK8_PALETTES:OUT (C),C				; on choisit DE LIRE la ROM 01 (#01)
				LD		BC,#7F00+%10000000:OUT (C),C 		; connexion Upper ROM et Lower ROM (et écran en mode 0.)
				ld		hl,PALETTE_DECORS							; lecture  de la palette du décors
				ld		de,PALETTE_DECORS_RAM							; ecriture
				ld		bc,32							; longueur
				LDIR

test_64k_4
; ----> BUG : sur 464 plus / GX4000 le #4000 lu ici est un octet de l'écran (pas de RAM étendue)
; ----> CORRECTION : on lit la variable du programme, renseignée une fois pour toute par preparation_du_jeu
ld a,(flag_on_joue_avec_alcorak)
cp a,1
jr z,on_copie_palette_alcorak2

	ld		hl,PALETTE_HUD							; lecture de la palette du hud
	ld		de,PALETTE_HUD_RAM							; ecriture
	ld		bc,32							; longueur
	LDIR
	jr on_continu_la_suite
on_copie_palette_alcorak2
	ld		hl,PALETTE_HUD_ALCORAK							; lecture de la palette du hud
	ld		de,PALETTE_HUD_RAM							; ecriture
	ld		bc,32							; longueur
	LDIR
on_continu_la_suite
				ld		hl,event_test_de_goldorak
				ld		a,_JP
				ld		(event_test_de_goldorak),a
				ld		hl,test_de_goldorak
				ld		(event_test_de_goldorak+1),hl
				ret
