; ////////////////////////////////////////////////
; ////////////////////////////////////////////////
; /////////////////    FIRE A    /////////////////
; ////////////////////////////////////////////////
; ////////////////////////////////////////////////
fireA

	ld		a,(flag_fireA)
	or		a
	jp		nz,retour_test_des_tirs


	call	test_du_clavier
	bit		5,a
	jp		z,Init_Retournement

; ----> BUG : on arrive ici par un JP (pas de valeur de retour dans la pile). Si l'étape de l'arme
;       choisie n'était pas à zéro (arme coupée en plein vol par le power up, un changement d'arme...)
;       la routine de l'arme partait directement sur une étape "en vol" :
;       - missiles gamma, cornofulgure, pulvonium : elles finissent par un RET -> le Z80 dépile une
;         adresse qui n'existe pas -> plantage direct.
;       - planitron, fulguropoing, clavicogyres : elles bouclaient sur elles même dans la même frame.
; ----> CORRECTION : flag_fireA à zéro = plus aucun tir en vol. On remet donc toutes les étapes
;       (etp_arme1 à etp_arme7 se suivent en mémoire) et l'évènement à zéro avant de tirer :
;       l'arme démarre toujours par son init.
	xor		a
	ld		hl,etp_arme1
	ld		b,7
.raz_etapes
	ld		(hl),a
	inc		hl
	djnz	.raz_etapes
	ld		hl,event_arme_fireA
	ld		(hl),a : inc hl
	ld		(hl),a : inc hl
	ld		(hl),a

	ld		a,(sfx_arme)
    ld 		c,1 ;channel (0-2)
    ld 		b,SFX_VOLUME ;Inverted volume (0-16)
    call 	PLY_AKG_PlaySoundEffect

	ld		a,(id_arme)
	cp		a,0
	jp		z,aucune_arme
	cp		a,ID_MISSILES_GAMMA
	jr		z,arme_missiles_gamma1
	cp		a,ID_PLANITRON_TYPE_1
	jp		z,arme_planitron
	cp		a,ID_PLANITRON_TYPE_2
	jp		z,arme_planitron2
	cp		a,ID_CORNOFULGURE
	jp		z,arme_cornofulgure
	cp		a,ID_FULGUROPOING
	jp		z,arme_fulguro_poing
	cp		a,ID_CLAVICOGYRES
	jp		z,arme_clavicogyres
	cp		a,ID_PULVONIUM
	jp		z,arme_pulvonium
	cp		a,8
	jp		z,aucune_arme


; /////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////
; //////////////       MISSILES GAMMA      ////////////////////
; /////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////
arme_missiles_gamma1
	ld	a,(flag_PowerUP)
	cp	a,0
	jr	z,arme_missiles_gamma
	cp	a,1
	jp	z,arme_missiles_gamma_pow2
	cp	a,2
	jp	z,arme_missiles_gamma_pow3
arme_missiles_gamma

	ld 		a,SFX_GAMMA_LVL1	 ;Sound effect number (>=1))
	ld		(sfx_arme),a

	RST		ASIC_CONNEXION
	ld		a,(etp_arme2)
	cp		a,0
	jp		z,init_missiles_gamma
	cp		a,1
	jr		z,missiles_gamma1
	cp		a,2
	jr		z,missiles_gamma2
init_missiles_gamma
	inc 	a:ld (etp_arme2),a										; on incrémente les étapes de l'arme
	ld		a,1:ld (flag_fireA),a									; on signale que le bouton fire 1 viens d'être appuyé
	ld		a,1:ld (flag_armes),a									; une arme est en cours de déclanchement
	ld		c,BANK9_GOLDORAK_SPRH
	RST 	UPPER_ROM_CONNEXION									; on se connection à la rom où se situes les sprites hard de cette arme
	ld		hl,(sprh_arme_de_base)
	ld		de,SPRH4_ADR
	ld		bc,#100
	LDIR
	ld		hl,(sprh_arme_de_base)
	ld		de,SPRH5_ADR
	ld		bc,#100
	LDIR																; on copie de puis la ROM vers l'ASIC
	call	rom_off
	ld		a,_CALL
	ld		(event_arme_fireA),a
	ld		hl,arme_missiles_gamma
	ld		(event_arme_fireA+1),hl													; on copie de puis la ROM vers l'ASIC
	RST		ASIC_DECONNEXION
	xor  	a
	ld		(anim_arme_a_charger),a
	jp 		retour_test_des_tirs
missiles_gamma1
	ld		c,BANK_ROM_2
	rst		UPPER_ROM_CONNEXION
	rst		ASIC_CONNEXION
	call	missiles_gamma1_ROM
	call	rom_off
	jp		ASIC_DECONNEXION
	
missiles_gamma2
	ld		c,BANK_ROM_2
	rst		UPPER_ROM_CONNEXION
	RST		ASIC_CONNEXION
	call	missiles_gamma2_ROM
	call	rom_off
	jp		ASIC_DECONNEXION
	
; /////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////
; //////////////       MISSILES GAMMA POWER UP 2     //////////
; /////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////
arme_missiles_gamma_pow2

	ld 		a,SFX_GAMMA_LVL2	 ;Sound effect number (>=1))
	ld		(sfx_arme),a
	RST		ASIC_CONNEXION
	ld		a,(etp_arme2)
	cp		a,0
	jp		z,init_missiles_gamma_pow2
	cp		a,1
	jp		z,missiles_gamma_pow21
	cp		a,2
	jp		z,missiles_gamma_pow22
init_missiles_gamma_pow2
	inc 	a:ld (etp_arme2),a										; on incrémente les étapes de l'arme
	ld		a,1:ld (flag_fireA),a									; on signale que le bouton fire 1 viens d'être appuyé
	ld		a,1:ld (flag_armes),a									; une arme est en cours de déclanchement
	ld		c,BANK9_GOLDORAK_SPRH: RST 0									; on se connection à la rom où se situes les sprites hard de cette arme
	ld		hl,(sprh_arme_de_base2)
	ld		de,SPRH4_ADR
	ld		bc,#100
	LDIR
	ld		hl,(sprh_arme_de_base2)
	ld		de,SPRH5_ADR
	ld		bc,#100
	LDIR																; on copie de puis la ROM vers l'ASIC
	call	rom_off
	ld		a,_CALL
	ld		(event_arme_fireA),a
	ld		hl,arme_missiles_gamma_pow2
	ld		(event_arme_fireA+1),hl													; on copie de puis la ROM vers l'ASIC
	RST		ASIC_DECONNEXION
	xor  a
	ld		(anim_arme_a_charger),a
	jp 		retour_test_des_tirs
missiles_gamma_pow21
	ld		c,BANK_ROM_2
	rst		UPPER_ROM_CONNEXION
	RST		ASIC_CONNEXION
	call	missiles_gamma_pow21_ROM
	call	rom_off
	jp		ASIC_DECONNEXION
	
missiles_gamma_pow22
	ld		c,BANK_ROM_2
	rst		UPPER_ROM_CONNEXION
	RST		ASIC_CONNEXION
	call	missiles_gamma_pow22_ROM
	call	rom_off
	jp		ASIC_DECONNEXION
	
; /////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////
; //////////////       MISSILES GAMMA POWER UP 3     //////////
; /////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////
arme_missiles_gamma_pow3
	ld 		a,SFX_GAMMA_LVL3	 ;Sound effect number (>=1))
	ld		(sfx_arme),a
	RST		ASIC_CONNEXION
	ld		a,(etp_arme2)
	cp		a,0
	jp		z,init_missiles_gamma_pow3
	cp		a,1
	jp		z,missiles_gamma_pow31
	cp		a,2
	jp		z,missiles_gamma_pow32
init_missiles_gamma_pow3
	inc 	a:ld (etp_arme2),a										; on incrémente les étapes de l'arme
	ld		a,1:ld (flag_fireA),a									; on signale que le bouton fire 1 viens d'être appuyé
	ld		a,1:ld (flag_armes),a									; une arme est en cours de déclanchement
	ld		c,BANK9_GOLDORAK_SPRH: RST 0									; on se connection à la rom où se situes les sprites hard de cette arme
	ld		hl,(sprh_arme_de_base3)
	ld		de,SPRH4_ADR
	ld		bc,#100
	LDIR
	ld		hl,(sprh_arme_de_base3)
	ld		de,SPRH5_ADR
	ld		bc,#100
	LDIR																; on copie de puis la ROM vers l'ASIC
	call	rom_off
	ld		a,_CALL
	ld		(event_arme_fireA),a
	ld		hl,arme_missiles_gamma_pow3
	ld		(event_arme_fireA+1),hl													; on copie de puis la ROM vers l'ASIC
	RST		ASIC_DECONNEXION
	xor  	a
	ld		(anim_arme_a_charger),a
	jp 		retour_test_des_tirs
missiles_gamma_pow31
	ld		c,BANK_ROM_2
	rst		UPPER_ROM_CONNEXION
	call	missiles_gamma_pow31_ROM
	call	rom_off
	jp		ASIC_DECONNEXION
	
missiles_gamma_pow32
	ld		c,BANK_ROM_2
	rst		UPPER_ROM_CONNEXION
	call	missiles_gamma_pow32_ROM
	call	rom_off
	jp		ASIC_DECONNEXION
	






; /////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////
; ///////////////////       PLANITRON   ///////////////////////
; /////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////
arme_planitron
	ld 		a,SFX_PLANITRON	 ;Sound effect number (>=1))
	ld		(sfx_arme),a

	RST		ASIC_CONNEXION
	ld		a,(etp_arme3)
	cp		a,0
	jr		z,init_planitron
	cp		a,1
	jr		z,planitron1
	cp		a,2
	jr		z,planitron2
init_planitron
	inc 	a:ld (etp_arme3),a										; on incrémente les étapes de l'arme
	ld		a,1:ld (flag_fireA),a									; on signale que le bouton fire 1 viens d'être appuyé
	ld		a,1:ld (flag_armes),a									; une arme est en cours de déclanchement
	ld		c,BANK9_GOLDORAK_SPRH: RST 0										; on se connection à la rom où se situes les sprites hard de cette arme
	ld		hl,sprh_planitron
	ld		(adr_anim_planitron),hl
	ld		de,SPRH4_ADR
	ld		bc,#100
	LDIR
	ld		hl,sprh_planitron
	ld		de,SPRH5_ADR
	ld		bc,#100
	LDIR																; on copie de puis la ROM vers l'ASIC
	call	rom_off
	; FIX START      / 11-04-2024 / _JP à la place de _CALL pour revenir dans la boucle sans problème de pile
	; 				 / replacer les ret par jp retour_event_arme_fireA
	ld		a,_JP
	; FIX END
	ld		(event_arme_fireA),a
; ----> BUG (le même dans les 6 init d'armes) : l'évènement était écrit avec ld hl,(adr_type_arme).
;       Si adr_type_arme ne correspondait pas à l'arme en cours d'init, on se retrouvait avec un JP
;       vers une routine qui finit par un RET, ou un CALL vers une routine qui finit par un JP :
;       la pile se décalait à chaque frame jusqu'au plantage.
;       Ca arrivait après être passé par le fulguropoing : son animation de retour remettait
;       adr_type_arme sur les clavicogyres plusieurs secondes après, quelle que soit l'arme choisie.
; ----> CORRECTION : chaque init écrit en dur l'adresse de SA routine, le _CALL ou le _JP posé
;       juste au dessus correspond donc toujours à la routine visée.
	ld		hl,arme_planitron
	ld		(event_arme_fireA+1),hl													; on copie de puis la ROM vers l'ASIC
	RST		ASIC_DECONNEXION
	ld		a,4
	ld		(etp_anim_planitron),a
	ld		a,1
	ld		(anim_arme_a_charger),a
	jp 		retour_test_des_tirs
planitron1
	inc		a:ld (etp_arme3),a
	ld		hl,(SPRH0_X)
	ld		de,-19
	add		hl,de
	ld		(SPRH4_X),hl 			; on calcule l'emplacement de l'arme en fonctione des coordonnée de Goldorak
	ld		de,64+32+3:add hl,de:ld (SPRH5_X),hl								; on calcule le 2eme sprite par rapport au 1er
	ld		hl,(SPRH0_Y):ld	de,6:add hl,de
	ld		(SPRH4_Y),hl:ld	(SPRH5_Y),hl
	ld		a,zoom_mode0_1:ld (SPRH4_ZOOM),a:ld	(SPRH5_ZOOM),a
	ld		(valeur_zoom_sprh4),a : ld (valeur_zoom_sprh5),a
	RST		ASIC_DECONNEXION
	jp		retour_event_arme_fireA
	;ret
planitron2
	ld		a,(resultat_test_de_touche)
	cp		a,#ef
	jr		z,retour_planitron_gauche
	cp		a,#ff
	jr		z,retour_planitron_gauche
	ld		a,(direction_goldorak)
	cp		a,4						; gauche
	jr		z,planitron_droite
	cp		a,3						; gauche
	jr		z,planitron_gauche
retour_planitron_droite
retour_planitron_gauche
	ld		hl,(SPRH4_Y)
	dec		l
	dec		l
	dec		l
	dec		l
	dec		l
	or 		a
	ld		a,l
	ld		b,-8
	add		a,b
	jr		nc,fin_planitron
	ld		(SPRH4_Y),hl
	ld		hl,(SPRH5_Y)
	dec		l
	dec		l
	dec		l
	dec		l
	dec		l
	ld		(SPRH5_Y),hl
	ld		a,(etp_anim_planitron)
	dec		a
	; MODIF cp		a,0
	jr		z,switch_anim_planitron
	ld		(etp_anim_planitron),a
	jp	retour_event_arme_fireA

switch_anim_planitron
	ld		a,4
	ld		(etp_anim_planitron),a
	ld		hl,(adr_anim_planitron)
	inc		h
	bit		2,h
	jr		nz,reinit_adr_anim_planitron
retour_reinit_adr_anim_planitron
	ld		(adr_anim_planitron),hl
	jp	retour_event_arme_fireA

reinit_adr_anim_planitron
	ld	h,#F0
	jr	retour_reinit_adr_anim_planitron
planitron_droite
	ld		hl,(SPRH4_X)
	inc		hl
	inc		hl
	inc		hl
	inc		hl
	inc		hl
	ld		(SPRH4_X),hl
	ld		hl,(SPRH5_X)
	inc		hl
	inc		hl
	inc		hl
	ld		(SPRH5_X),hl
	jr		retour_planitron_droite
planitron_gauche
	ld		hl,(SPRH4_X)
	dec		hl
	dec		hl
	dec		hl
	ld		(SPRH4_X),hl
	ld		hl,(SPRH5_X)
	dec		hl
	dec		hl
	dec		hl
	dec		hl
	dec		hl
	ld		(SPRH5_X),hl
	jr		retour_planitron_gauche
fin_planitron
	xor		a
	ld		(SPRH4_ZOOM),a
	ld		(SPRH5_ZOOM),a
	ld		(valeur_zoom_sprh4),a
	ld 		(valeur_zoom_sprh5),a
	ld		(flag_fireA),a
	ld		(etp_arme3),a
	ld		(event_arme_fireA),a
	ld		(event_arme_fireA+1),a
	ld		(event_arme_fireA+2),a
	ld		(anim_arme_a_charger),a
	ld		hl,SPRH_ARMES_GOLDORAK_CACHER
	ld		(SPRH4_X),hl
	ld		(SPRH4_Y),hl
	ld		(SPRH5_X),hl
	ld		(SPRH5_Y),hl
	RST		ASIC_DECONNEXION
	ld 		c,1   ;Channel (0-2)
	call 	PLY_AKG_StopSoundEffectFromChannel
	;ret
	jp	retour_event_arme_fireA
; /////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////
; ///////////////////       PLANITRON  2 //////////////////////
; /////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////
arme_planitron2

	ld 		a,SFX_PLANITRON	 ;Sound effect number (>=1))
	ld		(sfx_arme),a
	RST		ASIC_CONNEXION

	ld		a,(etp_arme4)
	cp		a,0
	jp		z,init_planitron2
	cp		a,1
	jp		z,planitron12
	cp		a,2
	jp		z,planitron22
init_planitron2
	inc 	a:ld (etp_arme4),a										; on incrémente les étapes de l'arme
	ld		a,1:ld (flag_fireA),a									; on signale que le bouton fire 1 viens d'être appuyé
	ld		a,1:ld (flag_armes),a									; une arme est en cours de déclanchement
	ld		c,BANK9_GOLDORAK_SPRH: RST 0									; on se connection à la rom où se situes les sprites hard de cette arme
	ld		hl,sprh_planitron2
	ld		(adr_anim_planitron2),hl
	ld		de,SPRH4_ADR
	ld		bc,#100
	LDIR
	ld		hl,sprh_planitron2
	ld		de,SPRH5_ADR
	ld		bc,#100
	LDIR																; on copie de puis la ROM vers l'ASIC
	call	rom_off
	; FIX START      / 29-04-2024 / _JP à la place de _CALL pour revenir dans la boucle sans problème de pile
	; 				 / replacer les ret par jp retour_event_arme_fireA
	ld		a,_JP
	; FIX END
	ld		(event_arme_fireA),a
	ld		hl,arme_planitron2			; ----> CORRECTION : adresse en dur (voir init_planitron)
	ld		(event_arme_fireA+1),hl													; on copie de puis la ROM vers l'ASIC
	RST		ASIC_DECONNEXION
	ld		a,4
	ld		(etp_anim_planitron2),a
	ld		a,2
	ld		(anim_arme_a_charger),a
	ld		hl,-8
	ld		(courbe_sprh4),hl
	ld		hl,8
	ld		(courbe_sprh5),hl
	jp 		retour_test_des_tirs
planitron12
	inc		a:ld (etp_arme4),a
	ld		hl,(SPRH0_X)
	ld		de,-19
	add		hl,de
	ld		(SPRH4_X),hl 			; on calcule l'emplacement de l'arme en fonctione des coordonnée de Goldorak
	ld		de,64+32+3:add hl,de:ld (SPRH5_X),hl								; on calcule le 2eme sprite par rapport au 1er
	ld		hl,(SPRH0_Y):ld	de,6:add hl,de
	ld		(SPRH4_Y),hl:ld	(SPRH5_Y),hl
	ld		a,zoom_mode0_1:ld (SPRH4_ZOOM),a:ld	(SPRH5_ZOOM),a
	ld		(valeur_zoom_sprh4),a : ld (valeur_zoom_sprh5),a
	RST		ASIC_DECONNEXION
	jp		retour_event_arme_fireA
	; ret
planitron22
	ld		hl,(SPRH4_Y)
	dec		l
	dec		l
	dec		l
	dec		l
	dec		l
	dec		l
	or 		a
	ld		a,l
	ld		b,-8
	add		a,b
	jr		nc,fin_planitron2
	ld		(SPRH4_Y),hl
	ld		hl,(SPRH5_Y)
	dec		l
	dec		l
	dec		l
	dec		l
	dec		l
	dec		l
	ld		(SPRH5_Y),hl
	ld		a,(timer_planitron2)
	inc		a
	cp		a,4
	ld		(timer_planitron2),a
	; FIX START      / 29-04-2024 /
	; Le plannitron 2 dévie de sa trajectoir et la routine "planitron_devier"
	;  					termine par un RET : "Adieux la pile (dixit cx1976)"
	jp		z,planitron_devier
	; FIX END
	ld		a,(etp_anim_planitron2)
	dec		a
	; MODIF cp		a,0
	jr		z,switch_anim_planitron2
	ld		(etp_anim_planitron2),a
	; ret
	jp		retour_event_arme_fireA
switch_anim_planitron2
	ld		a,4
	ld		(etp_anim_planitron2),a
	ld		hl,(adr_anim_planitron2)
	inc		h
	bit		0,h
	jr		nz,reinit_adr_anim_planitron2
retour_reinit_adr_anim_planitron2
	ld		(adr_anim_planitron2),hl
	; ret
	jp		retour_event_arme_fireA
reinit_adr_anim_planitron2
	ld		h,#F6
	jr	retour_reinit_adr_anim_planitron2
planitron_devier
	ld		hl,(SPRH4_X)
	ld		de,(courbe_sprh4)
	add		hl,de
	ld		(SPRH4_X),hl
	inc		de
	inc		de
	inc		de
	inc		de
	ld		(courbe_sprh4),de
	ld		hl,(SPRH5_X)
	ld		de,(courbe_sprh5)
	add		hl,de
	ld		(SPRH5_X),hl
	dec		de
	dec		de
	dec		de
	dec		de
	ld		(courbe_sprh5),de
	ld		a,2
	ld			(timer_planitron2),a
	jp		retour_event_arme_fireA
	; ret
fin_planitron2
	xor		a
	ld		(SPRH4_ZOOM),a
	ld		(SPRH5_ZOOM),a
	ld		(valeur_zoom_sprh4),a
	ld 		(valeur_zoom_sprh5),a
	ld		(flag_fireA),a
	ld		(etp_arme4),a
	ld		(event_arme_fireA),a
	ld		(event_arme_fireA+1),a
	ld		(event_arme_fireA+2),a
	ld		(anim_arme_a_charger),a
	ld		(timer_planitron2),a
	ld		hl,-32
	ld		(SPRH4_X),hl
	ld		(SPRH4_Y),hl
	ld		(SPRH5_X),hl
	ld		(SPRH5_Y),hl
	RST		ASIC_DECONNEXION
	ld 		c,1   ;Channel (0-2)
	call 	PLY_AKG_StopSoundEffectFromChannel
	; ret
	jp		retour_event_arme_fireA
; /////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////
; //////////////       CORNOFULGURE        ////////////////////
; /////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////
arme_cornofulgure
	ld	a,(flag_PowerUP)
	cp	a,0
	jr	z,arme_cornofulgure1
	cp	a,1
	jp	z,arme_cornofulgure2
	cp	a,2
	jp	z,arme_cornofulgure3

arme_cornofulgure1

	ld 		a,SFX_CORNOFULGURE	 ;Sound effect number (>=1))
	ld		(sfx_arme),a


	RST		ASIC_CONNEXION

	ld		a,(etp_arme1)
	cp		a,0
	jr		z,init_cornofulgure
	cp		a,2
	jr		z,cornofulgure1
	cp		a,4
	jr		z,cornofulgure2
	cp		a,6
	jp		z,cornofulgure3
	cp		a,8
	jp		z,cornofulgure2
	cp		a,10
	jp		z,cornofulgure1
	cp		a,12
	jp		z,cornofulgure_fin
	inc		a:ld (etp_arme1),a
	ret

init_cornofulgure
	inc 	a:ld (etp_arme1),a										; on incrémente les étapes de l'arme
	ld		a,1:ld (flag_fireA),a									; on signale que le bouton fire 1 viens d'être appuyé
	ld		a,1:ld (flag_armes),a									; une arme est en cours de déclanchement
	ld		c,BANK9_GOLDORAK_SPRH: RST 0										; on se connection à la rom où se situes les sprites hard de cette arme
	ld		hl,sprh_cornofulgure_bas
	ld		de,SPRH4_ADR
	ld		bc,#200
	LDIR															; on copie de puis la ROM vers l'ASIC
	call	rom_off
	ld		a,_CALL
	ld		(event_arme_fireA),a
	ld		hl,arme_cornofulgure		; ----> CORRECTION : adresse en dur (voir init_planitron)
	ld		(event_arme_fireA+1),hl													; on copie de puis la ROM vers l'ASIC
	RST		ASIC_DECONNEXION
	xor  a
	ld		(anim_arme_a_charger),a

	jp 	retour_test_des_tirs
cornofulgure1
	inc		a:ld (etp_arme1),a
	ld		hl,(SPRH0_X):ld	de,50:add hl,de:ld	(SPRH4_X),hl 			; on calcule l'emplacement de l'arme en fonctione des coordonnée de Goldorak
	ld		de,20:add hl,de:ld (SPRH5_X),hl								; on calcule le 2eme sprite par rapport au 1er
	ld		hl,(SPRH0_Y):ld	de,-14:add hl,de
	ld		(SPRH4_Y),hl:ld	(SPRH5_Y),hl
	ld		a,zoom_mode2_1:ld (SPRH4_ZOOM),a:ld	(SPRH5_ZOOM),a
	ld		(valeur_zoom_sprh4),a : ld (valeur_zoom_sprh5),a
	jp		ASIC_DECONNEXION
	
cornofulgure2
	inc		a:ld (etp_arme1),a
	ld		hl,(SPRH0_X):ld	de,50:add hl,de:ld	(SPRH4_X),hl 			; on calcule l'emplacement de l'arme en fonctione des coordonnée de Goldorak
	ld		de,20:add hl,de:ld (SPRH5_X),hl								; on calcule le 2eme sprite par rapport au 1er
	ld		hl,(SPRH0_Y):ld	de,-14+-16:add hl,de
	ld		(SPRH4_Y),hl:ld	(SPRH5_Y),hl
	ld		a,zoom_mode2_2:ld (SPRH4_ZOOM),a:ld	(SPRH5_ZOOM),a
	ld		(valeur_zoom_sprh4),a : ld (valeur_zoom_sprh5),a
	jp		ASIC_DECONNEXION
	
cornofulgure3
	inc		a:ld (etp_arme1),a
	ld		hl,(SPRH0_X):ld	de,50:add hl,de:ld	(SPRH4_X),hl 			; on calcule l'emplacement de l'arme en fonctione des coordonnée de Goldorak
	ld		de,20:add hl,de:ld (SPRH5_X),hl								; on calcule le 2eme sprite par rapport au 1er
	ld		hl,(SPRH0_Y):ld	de,-14+-16+-32:add hl,de
	ld		(SPRH4_Y),hl:ld	(SPRH5_Y),hl
	ld		a,zoom_mode2_3:ld (SPRH4_ZOOM),a:ld	(SPRH5_ZOOM),a
	ld		(valeur_zoom_sprh4),a : ld (valeur_zoom_sprh5),a
	jp		ASIC_DECONNEXION
	
cornofulgure_fin
	xor		a
	ld		(SPRH4_ZOOM),a
	ld		(SPRH5_ZOOM),a
	ld		(valeur_zoom_sprh4),a : ld (valeur_zoom_sprh5),a
	ld		(flag_fireA),a
	ld		(etp_arme1),a
	ld		(event_arme_fireA),a
	ld		(event_arme_fireA+1),a
	ld		(event_arme_fireA+2),a
	ld		hl,SPRH_ARMES_GOLDORAK_CACHER
	ld		(SPRH4_X),hl
	ld		(SPRH4_Y),hl
	ld		(SPRH5_X),hl
	ld		(SPRH5_Y),hl
	RST		ASIC_DECONNEXION
	ld 		c,1   ;Channel (0-2)
	call 	PLY_AKG_StopSoundEffectFromChannel
	ret



; //////////////       CORNOFULGURE (Puissance 2)       ////////////////////
arme_cornofulgure2

	ld 		a,SFX_CORNOFULGURE	 ;Sound effect number (>=1))
	ld		(sfx_arme),a
	RST		ASIC_CONNEXION

	ld		a,(etp_arme1)
	cp		a,0
	jp		z,init_cornofulgure
	cp		a,1
	jr		z,cornofulgure1b
	cp		a,2
	jr		z,cornofulgure2b
	cp		a,4
	jr		z,cornofulgure3b
	cp		a,6
	jr		z,cornofulgure2b
	cp		a,8
	jr		z,cornofulgure1b
	cp		a,10
	jp		z,cornofulgure_finb
	inc		a:ld (etp_arme1),a
	; jp 	retour_test_des_tirs
	ret
cornofulgure1b
	inc		a:ld (etp_arme1),a
	ld		hl,(SPRH0_X):ld	de,48:add hl,de:ld	(SPRH4_X),hl 			; on calcule l'emplacement de l'arme en fonctione des coordonnée de Goldorak
	ld		de,16:add hl,de:ld (SPRH5_X),hl								; on calcule le 2eme sprite par rapport au 1er
	ld		hl,(SPRH0_Y):ld	de,-14:add hl,de
	ld		(SPRH4_Y),hl:ld	(SPRH5_Y),hl
	ld		a,zoom_mode1_1:ld (SPRH4_ZOOM),a:ld	(SPRH5_ZOOM),a
	ld		(valeur_zoom_sprh4),a : ld (valeur_zoom_sprh5),a
	jp		ASIC_DECONNEXION
	
cornofulgure2b
	inc		a:ld (etp_arme1),a
	ld		hl,(SPRH0_X):ld	de,48:add hl,de:ld	(SPRH4_X),hl 			; on calcule l'emplacement de l'arme en fonctione des coordonnée de Goldorak
	ld		de,16:add hl,de:ld (SPRH5_X),hl								; on calcule le 2eme sprite par rapport au 1er
	ld		hl,(SPRH0_Y):ld	de,-14+-16:add hl,de
	ld		(SPRH4_Y),hl:ld	(SPRH5_Y),hl
	ld		a,zoom_mode1_2:ld (SPRH4_ZOOM),a:ld	(SPRH5_ZOOM),a
	ld		(valeur_zoom_sprh4),a : ld (valeur_zoom_sprh5),a
	jp		ASIC_DECONNEXION
	
cornofulgure3b
	inc		a:ld (etp_arme1),a
	ld		hl,(SPRH0_X):ld	de,48:add hl,de:ld	(SPRH4_X),hl 			; on calcule l'emplacement de l'arme en fonctione des coordonnée de Goldorak
	ld		de,16:add hl,de:ld (SPRH5_X),hl								; on calcule le 2eme sprite par rapport au 1er
	ld		hl,(SPRH0_Y):ld	de,-14+-16+-32:add hl,de
	ld		(SPRH4_Y),hl:ld	(SPRH5_Y),hl
	ld		a,zoom_mode1_3:ld (SPRH4_ZOOM),a:ld	(SPRH5_ZOOM),a
	ld		(valeur_zoom_sprh4),a : ld (valeur_zoom_sprh5),a
	jp		ASIC_DECONNEXION
	
cornofulgure_finb
	xor		a
	ld		(SPRH4_ZOOM),a
	ld		(SPRH5_ZOOM),a
	ld		(valeur_zoom_sprh4),a : ld (valeur_zoom_sprh5),a
	ld		(flag_fireA),a
	ld		(etp_arme1),a
	ld		(event_arme_fireA),a
	ld		(event_arme_fireA+1),a
	ld		(event_arme_fireA+2),a
	ld		hl,SPRH_ARMES_GOLDORAK_CACHER
	ld		(SPRH4_X),hl
	ld		(SPRH4_Y),hl
	ld		(SPRH5_X),hl
	ld		(SPRH5_Y),hl
	RST		ASIC_DECONNEXION
	ld 		c,1   ;Channel (0-2)
	call 	PLY_AKG_StopSoundEffectFromChannel
	ret


; //////////////       CORNOFULGURE (Puissance 3)       ////////////////////
arme_cornofulgure3

	ld 		a,SFX_CORNOFULGURE	 ;Sound effect number (>=1))
	ld		(sfx_arme),a
	RST		ASIC_CONNEXION

	ld		a,(etp_arme1)
	cp		a,0
	jp		z,init_cornofulgure
	cp		a,1
	jr		z,cornofulgure1c
	cp		a,2
	jr		z,cornofulgure2c
	cp		a,3
	jp		z,cornofulgure3c
	cp		a,4
	jp		z,cornofulgure4c
	cp		a,5
	jp		z,cornofulgure5c
	cp		a,6
	jp		z,cornofulgure6c
	cp		a,7
	jp		z,cornofulgure5c
	cp		a,8
	jp		z,cornofulgure4c
	cp		a,9
	jr		z,cornofulgure3c
	cp		a,10
	jr		z,cornofulgure2c
	cp		a,11
	jr		z,cornofulgure1c
	cp		a,12
	jp		z,cornofulgure_finc
	inc		a:ld (etp_arme1),a
	; jp 	retour_test_des_tirs
	ret
cornofulgure1c
	inc		a:ld (etp_arme1),a
	ld		hl,(SPRH0_X):ld	de,48:add hl,de:ld (SPRH4_X),hl 			; on calcule l'emplacement de l'arme en fonctione des coordonnée de Goldorak
	ld		hl,(SPRH0_Y):ld	de,-16:add hl,de:ld	(SPRH4_Y),hl
	ld		a,zoom_mode0_1:ld (SPRH4_ZOOM),a
	ld		(valeur_zoom_sprh4),a
	xor		a:ld (SPRH5_ZOOM),a
	ld (valeur_zoom_sprh5),a
	jp		ASIC_DECONNEXION
	
cornofulgure2c
	inc		a:ld (etp_arme1),a
	ld		hl,(SPRH0_X):ld	de,48:add hl,de:ld	(SPRH4_X),hl 			; on calcule l'emplacement de l'arme en fonctione des coordonnée de Goldorak
	ld		hl,(SPRH0_Y):ld	de,-16+-16:add hl,de:ld	(SPRH4_Y),hl
	ld		a,zoom_mode0_2:ld (SPRH4_ZOOM),a :ld (valeur_zoom_sprh4),a
	xor		a:ld (SPRH5_ZOOM),a
	ld (valeur_zoom_sprh5),a
	jp		ASIC_DECONNEXION
	
cornofulgure3c
	inc		a:ld (etp_arme1),a
	ld		hl,(SPRH0_X):ld	de,48:add hl,de:ld	(SPRH4_X),hl 			; on calcule l'emplacement de l'arme en fonctione des coordonnée de Goldorak
	ld		hl,(SPRH0_Y):ld	de,-16+-16+-32:add hl,de:ld	(SPRH4_Y),hl
	ld		a,zoom_mode0_3:ld (SPRH4_ZOOM),a : ld (valeur_zoom_sprh4),a
	xor		a:ld (SPRH5_ZOOM),a : ld (valeur_zoom_sprh5),a
	jp		ASIC_DECONNEXION
	
cornofulgure4c
	inc		a:ld (etp_arme1),a
	ld		hl,(SPRH0_X):ld	de,48:add hl,de:ld	(SPRH4_X),hl:ld (SPRH5_X),hl 			; on calcule l'emplacement de l'arme en fonctione des coordonnée de Goldorak
	ld		hl,(SPRH0_Y):ld	de,-16+-16+-32:add hl,de:ld	(SPRH4_Y),hl
	ld		de,-16:add hl,de:ld	(SPRH5_Y),hl
	ld		a,zoom_mode0_1:ld	(SPRH5_ZOOM),a : ld (valeur_zoom_sprh5),a
	jp		ASIC_DECONNEXION
	
cornofulgure5c
	inc		a:ld (etp_arme1),a
	ld		hl,(SPRH0_X):ld	de,48:add hl,de:ld	(SPRH4_X),hl:ld (SPRH5_X),hl 			; on calcule l'emplacement de l'arme en fonctione des coordonnée de Goldorak
	ld		hl,(SPRH0_Y):ld	de,-16+-16+-32:add hl,de:ld	(SPRH4_Y),hl
	ld		de,-16+-16:add hl,de:ld	(SPRH5_Y),hl
	ld		a,zoom_mode0_2:ld	(SPRH5_ZOOM),a :ld (valeur_zoom_sprh5),a
	jp		ASIC_DECONNEXION
	
cornofulgure6c
	inc		a:ld (etp_arme1),a
	ld		hl,(SPRH0_X):ld	de,48:add hl,de:ld	(SPRH4_X),hl:ld (SPRH5_X),hl 			; on calcule l'emplacement de l'arme en fonctione des coordonnée de Goldorak
	ld		hl,(SPRH0_Y):ld	de,-16+-16+-32:add hl,de:ld	(SPRH4_Y),hl
	ld		de,-16+-16+-32:add hl,de:ld	(SPRH5_Y),hl
	ld		a,zoom_mode0_3:ld	(SPRH5_ZOOM),a :ld (valeur_zoom_sprh5),a
	jp		ASIC_DECONNEXION
	
cornofulgure_finc
	xor		a
	ld		(SPRH4_ZOOM),a
	ld		(SPRH5_ZOOM),a
	ld 		(valeur_zoom_sprh4),a
	ld 		(valeur_zoom_sprh5),a
	ld		(flag_fireA),a
	ld		(etp_arme1),a
	ld		(event_arme_fireA),a
	ld		(event_arme_fireA+1),a
	ld		(event_arme_fireA+2),a
	ld		hl,SPRH_ARMES_GOLDORAK_CACHER
	ld		(SPRH4_X),hl
	ld		(SPRH4_Y),hl
	ld		(SPRH5_X),hl
	ld		(SPRH5_Y),hl
	RST		ASIC_DECONNEXION
	ld 		c,1   ;Channel (0-2)
	call 	PLY_AKG_StopSoundEffectFromChannel
	ret
aucune_arme
	RST		ASIC_CONNEXION
	xor		a
	ld		(SPRH4_ZOOM),a
	ld		(SPRH5_ZOOM),a
	ld 		(valeur_zoom_sprh4),a
	ld 		(valeur_zoom_sprh5),a
	ld		(flag_fireA),a
	ld		(etp_arme1),a
	ld		(event_arme_fireA),a
	ld		(event_arme_fireA+1),a
	ld		(event_arme_fireA+2),a
	ld		hl,SPRH_ARMES_GOLDORAK_CACHER
	ld		(SPRH4_X),hl
	ld		(SPRH4_Y),hl
	ld		(SPRH5_X),hl
	ld		(SPRH5_Y),hl
	RST		ASIC_DECONNEXION
	jp	retour_test_des_tirs
; /////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////
; //////////////       FULGURO POING        ////////////////////
; /////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////
arme_fulguro_poing

	ld 		a,SFX_FULGORO_POINT	 ;Sound effect number (>=1))
	ld		(sfx_arme),a

	RST		ASIC_CONNEXION

	ld		a,(etp_arme6)
	cp		a,0
	jr		z,init_fulguro_poing
	cp		a,2
	jr		z,init_fulguro_poing2
	cp		a,3
	jr		z,fulguro_poing_fin
	inc		a:ld (etp_arme6),a
; ----> BUG : on arrive ici par le JP de event_arme_fireA mais on repartait sur retour_test_des_tirs :
;       on sautait le test du clavier (pause...) et on rendait la main aux directions même quand les
;       commandes de goldorak étaient coupées (event_test_de_goldorak effacé).
; ----> CORRECTION : on reprend la boucle juste après l'évènement, comme les autres étapes
	jp 		retour_event_arme_fireA

init_fulguro_poing
	inc 	a:ld (etp_arme6),a										; on incrémente les étapes de l'arme
	ld		a,1:ld (flag_fireA),a									; on signale que le bouton fire 1 viens d'être appuyé
	ld		a,1:ld (flag_armes),a									; une arme est en cours de déclanchement

	; FIX START      / 29-04-2024 / _JP à la place de _CALL pour revenir dans la boucle sans problème de pile
	ld		a,_JP
	; FIX END

	ld		(event_arme_fireA),a
	ld		hl,arme_fulguro_poing		; ----> CORRECTION : adresse en dur (voir init_planitron)
	ld		(event_arme_fireA+1),hl
	ld		a,13
	ld		(SPRH4_ZOOM),a
	ld		(SPRH5_ZOOM),a
	ld 		(valeur_zoom_sprh4),a
	ld 		(valeur_zoom_sprh5),a
	jp 		retour_test_des_tirs

init_fulguro_poing2
	ld		hl,(SPRH4_Y)
	dec		l
	dec		l
	dec		l
	dec		l
	dec		l
	dec		l
	or 		a
	ld		a,l
	ld		b,-8
	add		a,b
	jr		nc,fulguro_poing_fin
	ld		(SPRH4_Y),hl
	ld		hl,(SPRH5_Y)
	dec		l
	dec		l
	dec		l
	dec		l
	dec		l
	dec		l
	ld		(SPRH5_Y),hl
	jp	retour_event_arme_fireA

fulguro_poing_fin
	RST		ASIC_CONNEXION
	ld		hl,(SPRH0_X)
	ld		de,22:add hl,de:ld	(SPRH4_X),hl 			; on calcule l'emplacement de l'arme en fonctione des coordonnée de Goldorak
	ld		de,20:add hl,de:ld (SPRH5_X),hl				; on calcule le 2eme sprite par rapport au 1er
	ld		hl,(SPRH0_Y):ld	de,-14:add hl,de
	ld		(SPRH4_Y),hl:ld	(SPRH5_Y),hl
	ld		a,13
	ld		(SPRH4_ZOOM),a
	ld		(SPRH5_ZOOM),a
	ld 		(valeur_zoom_sprh4),a
	ld 		(valeur_zoom_sprh5),a
	xor		a
	ld		(flag_fireA),a
	ld		(etp_arme6),a
	ld		(event_arme_fireA),a
	ld		(event_arme_fireA+1),a
	ld		(event_arme_fireA+2),a
	RST		ASIC_DECONNEXION
	ld 		c,1   ;Channel (0-2)
	call 	PLY_AKG_StopSoundEffectFromChannel
	jp	retour_event_arme_fireA

; /////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////
; //////////////       CLAVICOGYVRES       ////////////////////
; /////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////
arme_clavicogyres

	ld 		a,SFX_CLAVICOGYRE	 ;Sound effect number (>=1))
	ld		(sfx_arme),a


	RST		ASIC_CONNEXION
	ld		a,(etp_arme7)
	cp		a,0
	jr		z,init_clavicogyres
	cp		a,1
	jr		z,clavicogyres12
	cp		a,2
	jp		z,clavicogyres22
init_clavicogyres
	inc 	a:ld (etp_arme7),a										; on incrémente les étapes de l'arme
	ld		a,1:ld (flag_fireA),a									; on signale que le bouton fire 1 viens d'être appuyé
	ld		a,1:ld (flag_armes),a									; une arme est en cours de déclanchement
	ld		c,BANK9_GOLDORAK_SPRH: RST 0										; on se connection à la rom où se situes les sprites hard de cette arme
	ld		hl,sprh_clavicogyres
	ld		(adr_anim_clavicogyres),hl
	ld		de,SPRH4_ADR
	ld		bc,#100
	LDIR
	ld		hl,sprh_clavicogyres
	ld		de,SPRH5_ADR
	ld		bc,#100
	LDIR																; on copie de puis la ROM vers l'ASIC
	call	rom_off
	; FIX START      / 29-04-2024 /
	ld		a,_JP
	; FIX END
	ld		(event_arme_fireA),a
	ld		hl,arme_clavicogyres		; ----> CORRECTION : adresse en dur (voir init_planitron)
	ld		(event_arme_fireA+1),hl													; on copie de puis la ROM vers l'ASIC
	RST		ASIC_DECONNEXION
	ld		a,4
	ld		(etp_anim_clavicogyres),a
	ld		a,3
	ld		(anim_arme_a_charger),a
	ld		hl,-4
	ld		(courbe_sprh4),hl
	ld		hl,4
	ld		(courbe_sprh5),hl
	jp 	retour_test_des_tirs
clavicogyres12
	inc		a:ld (etp_arme7),a
	ld		hl,(SPRH0_X)
	ld		de,32
	add		hl,de
	ld		(SPRH4_X),hl 			; on calcule l'emplacement de l'arme en fonctione des coordonnée de Goldorak
	ld		de,30:add hl,de:ld (SPRH5_X),hl								; on calcule le 2eme sprite par rapport au 1er
	ld		hl,(SPRH0_Y):ld	de,6:add hl,de
	ld		(SPRH4_Y),hl:ld	(SPRH5_Y),hl
	ld		a,zoom_mode0_1:ld (SPRH4_ZOOM),a:ld	(SPRH5_ZOOM),a
	ld		(valeur_zoom_sprh4),a : ld (valeur_zoom_sprh5),a
	RST		ASIC_DECONNEXION
	; ret
	jp		retour_event_arme_fireA
clavicogyres22
	ld		hl,(SPRH4_Y)
	dec		l
	dec		l
	dec		l
	dec		l
	dec		l
	dec		l
	or 		a
	ld		a,l
	ld		b,-8
	add		a,b
	jr		nc,fin_clavicogyres
	ld		(SPRH4_Y),hl
	ld		hl,(SPRH5_Y)
	dec		l
	dec		l
	dec		l
	dec		l
	dec		l
	dec		l
	ld		(SPRH5_Y),hl
	ld		a,(timer_clavicogyres)
	inc		a
	cp		a,4
	ld		(timer_clavicogyres),a
	; FIX START      / 29-04-2024 /
							; Le plannitron 2 dévie de sa trajectoir et la routine "clavicogyres_devier"
							;  					termine par un RET : "Adieux la pile (dixit cx1976)"
	jp		z,clavicogyres_devier
	; FIX END
	ld		a,(etp_anim_clavicogyres)
	dec		a
	; MODIF cp		a,0
	jr		z,switch_anim_clavicogyres
	ld		(etp_anim_clavicogyres),a
	; ret
	jp		retour_event_arme_fireA

switch_anim_clavicogyres
	ld		a,4
	ld		(etp_anim_clavicogyres),a
	ld		hl,(adr_anim_clavicogyres)
	inc		h
	bit		7,h
	jr		z,reinit_adr_anim_clavicogyres
retour_reinit_adr_anim_clavicogyres
	ld		(adr_anim_clavicogyres),hl
	; ret
	jp		retour_event_arme_fireA
reinit_adr_anim_clavicogyres
	ld		h,#FA
	jr	retour_reinit_adr_anim_clavicogyres
clavicogyres_devier
	ld		hl,(SPRH4_X)
	ld		de,(courbe_sprh4)
	add		hl,de
	ld		(SPRH4_X),hl
	inc		de
	inc		de
	;inc		de
	inc		de
	ld		(courbe_sprh4),de
	ld		hl,(SPRH5_X)
	ld		de,(courbe_sprh5)
	add		hl,de
	ld		(SPRH5_X),hl
	dec		de
	dec		de
	;dec		de
	dec		de
	ld		(courbe_sprh5),de
	ld		a,2
	ld		(timer_clavicogyres),a
	; ret
	jp		retour_event_arme_fireA
fin_clavicogyres
	xor		a
	ld		(SPRH4_ZOOM),a
	ld		(SPRH5_ZOOM),a
	ld		(valeur_zoom_sprh4),a
	ld 		(valeur_zoom_sprh5),a
	ld		(flag_fireA),a
	ld		(etp_arme7),a
	ld		(event_arme_fireA),a
	ld		(event_arme_fireA+1),a
	ld		(event_arme_fireA+2),a
	ld		(anim_arme_a_charger),a
	ld		(timer_clavicogyres),a
	ld		hl,SPRH_ARMES_GOLDORAK_CACHER
	ld		(SPRH4_X),hl
	ld		(SPRH4_Y),hl
	ld		(SPRH5_X),hl
	ld		(SPRH5_Y),hl
	RST		ASIC_DECONNEXION
	ld 		c,1   ;Channel (0-2)
	call 	PLY_AKG_StopSoundEffectFromChannel
	; ret
	jp		retour_event_arme_fireA



; /////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////
; /////////////////       PULVONIUM       /////////////////////
; /////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////
arme_pulvonium

	ld 		a,SFX_PULVONIUM	 ;Sound effect number (>=1))
	ld		(sfx_arme),a

	RST		ASIC_CONNEXION

	ld		a,(etp_arme1)
	cp		a,0
	jr		z,init_pulvonium
	cp		a,1
	jr		z,pulvonium_display
	cp		a,2
	jr		z,pulvonium_animation



init_pulvonium
	inc 	a:ld (etp_arme1),a										; on incrémente les étapes de l'arme
	ld		a,1:ld (flag_fireA),a									; on signale que le bouton fire 1 viens d'être appuyé
	ld		a,1:ld (flag_armes),a									; une arme est en cours de déclanchement
	ld		c,BANK9_GOLDORAK_SPRH
	call	UPPER_ROM_CONNEXION							; on se connection à la rom où se situes les sprites hard de cette arme
	ld		hl,SPRH_PULVONIUM_ANIM1
	ld		de,SPRH4_ADR
	ld		bc,#200
	LDIR															; on copie de puis la ROM vers l'ASIC
	call	rom_off
	ld		a,_CALL
	ld		(event_arme_fireA),a
	ld		hl,arme_pulvonium			; ----> CORRECTION : adresse en dur (voir init_planitron)
	ld		(event_arme_fireA+1),hl													; on copie de puis la ROM vers l'ASIC
	RST		ASIC_DECONNEXION
	xor  a
	ld		(anim_arme_a_charger),a

	jp 	retour_test_des_tirs
pulvonium_display
	inc		a
	ld 		(etp_arme1),a
	call	update_pulvonium
	ld 		a,1
	ld		(etp_animation_pulvonium),a
	ret
pulvonium_animation

	ld 		a,SFX_PULVONIUM	;Sound effect number (>=1)
    ld 		c,0					;channel (0-2)
    ld 		b,SFX_VOLUME 					;Inverted volume (0-16)
    call 	PLY_AKG_PlaySoundEffect

	ld		a,(etp_animation_pulvonium)
	cp		a,1
	jr		z,.animation_1
	cp		a,2
	jr		z,.animation_2
.animation_1
	ld 		a,2
	ld		(etp_animation_pulvonium),a
	call	update_pulvonium
	ld		c,BANK9_GOLDORAK_SPRH
	call	UPPER_ROM_CONNEXION							; on se connection à la rom où se situes les sprites hard de cette arme
	ld		hl,SPRH_PULVONIUM_ANIM1
	ld		de,SPRH4_ADR
	ld		bc,#200
	LDIR															; on copie de puis la ROM vers l'ASIC
	call	rom_off

	ret

.animation_2
	ld 		a,1
	ld		(etp_animation_pulvonium),a
	call	update_pulvonium
	ld		c,BANK9_GOLDORAK_SPRH
	call	UPPER_ROM_CONNEXION							; on se connection à la rom où se situes les sprites hard de cette arme
	ld		hl,SPRH_PULVONIUM_ANIM2
	ld		de,SPRH4_ADR
	ld		bc,#200
	LDIR															; on copie de puis la ROM vers l'ASIC
	call	rom_off

	ret



update_pulvonium
	ld		hl,(SPRH0_X)
	ld		de,48 ; pour un zoom en mode 1 3
	;ld		de,27  ; pour un zoom en mode 0 3
	add 	hl,de
	ld		(SPRH4_X),hl 			; on calcule l'emplacement de l'arme en fonctione des coordonnée de Goldorak
	ld 		(SPRH5_X),hl								; on calcule le 2eme sprite par rapport au 1er
	ld		hl,(SPRH0_Y)
	ld		de,-64
	add 	hl,de
	ld		(SPRH4_Y),hl
	ld		de,-64
	add		hl,de
	ld		(SPRH5_Y),hl
	ld		a,zoom_mode1_3
	; ld		a,zoom_mode0_3☻
	ld 		(SPRH4_ZOOM),a
	ld		(SPRH5_ZOOM),a
	ld		(valeur_zoom_sprh4),a
	ld 		(valeur_zoom_sprh5),a
	ret



; /////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////
; /////////////////       ARME SECRETE       /////////////////////
; /////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////
flag_arme_secrete ds 1,0
arme_secrete
	ld		a,(flag_on_joue_avec_alcorak)
	or 		a
	jp		z,retour_test_de_CPC_plus

	ld		a,(flag_arme_secrete)
	or 		a
	jr		z,on_declanche_l_arme_secrete

	jp		retour_test_des_tirs






on_declanche_l_arme_secrete
	ld		a,1
	ld		(flag_arme_secrete),a

	ld 		a,SFX_BOOM_GOLGOTH	 ;Sound effect number (>=1))
   ld 		c,0					;channel (0-2)
    ld 		b,SFX_VOLUME 					;Inverted volume (0-16)
    call 	PLY_AKG_PlaySoundEffect
	ld 		a,2
	ld 		(etp_soucoupe1),a
	ld 		(etp_soucoupe2),a
	ld 		(etp_soucoupe3),a
	ld 		(etp_soucoupe4),a
	ld 		(etp_soucoupe5),a
	ld 		(etp_soucoupe6),a
	ld		hl,BOOM_SPRH_ROM_ADR
	ld		(BoomSprhRomAdr),hl
	jp 		retour_test_des_tirs








; /////////////////////////////////////////////////////////////
; ////////////////   GOLDORAK RETOURNEMENT     ////////////////
; /////////////////////////////////////////////////////////////

GoldroakRetournement
ld a,(flag_on_joue_avec_alcorak)
or a
jp nz,Fin_Retournement

	; on vérifie que l'on a encore des retournement disponible
	ld		a,(nbr_de_retournement)
	cp		a,NBR_RETOURNEMENT_MAX
	jp 		z,Fin_Retournement

	ld		hl,Compteur_Retournement
	dec		(hl)
	ret		nz

	ld		a,VITESSE_RETOURNEMENT
	ld		(Compteur_Retournement),a

	ld		a,(EtpRetournement)
	cp		a,0
	jp		z,Init_Retournement
	cp		a,1
	jp		z,Init_Retournement_0
	cp		a,2
	jp		z,Init_Retournement_0b
	cp		a,3
	jp		z,Init_Retournement_1
	cp		a,4
	jp		z,Init_Retournement_2
	cp		a,5
	jp		z,Init_Retournement_3
	cp		a,6
	jp		z,Init_Retournement_4
	cp		a,7
	jp		z,Init_Retournement_4b
	cp		a,8
	jp		z,Init_Retournement_4c
	cp		a,9
	jp		z,Init_Retournement_5
	cp		a,10
	jp		z,Init_Retournement_6
	cp		a,11
	jp		z,Init_Retournement_7
	cp		a,12
	jp		z,Fin_Retournement

Init_Retournement
; passage des étapes de l'animation
	ld		a,(EtpRetournement)
	inc		a
	ld		(EtpRetournement),a
; création de l'évenbement Retyournement dans la boucle
	ld		hl,GoldroakRetournement
	ld		a,_CALL
	ld		(event_retournement),a
	ld		(event_retournement+1),hl
; on efface le test de touche
	xor		a
	ld		(event_test_de_goldorak),a
	ld		(event_test_de_goldorak+1),a
	ld		(event_test_de_goldorak+2),a
; un retournement est en cours
	ld		a,1
	ld		(flag_retournement),a
; on cible les vitesse de retournement
	ld		hl,Tbl_Vitesse_Retournement
	ld		(Pointeur_Vitesse_Retournement),hl

	jp		retour_test_des_tirs


Init_Retournement_0
		inc		a
		ld		(EtpRetournement),a
		rst		ASIC_CONNEXION
		call	UpdateRetournement
		jp		ASIC_DECONNEXION
Init_Retournement_0b
		inc		a
		ld		(EtpRetournement),a
		rst		ASIC_CONNEXION
		call	UpdateRetournement
		jp		ASIC_DECONNEXION





Init_Retournement_1
		inc		a
		ld		(EtpRetournement),a
		ld		c,BANK15_GOLDORAK_RET_SPRH
		RST		UPPER_ROM_CONNEXION
		RST		ASIC_CONNEXION
		ld		hl,GOLDORAK_RET1_SPRH_ROM_ADR
		ld		de,SPRH0_ADR
		ld		bc,#400
		LDIR
		call	UpdateRetournement
		call	rom_off
		jp		ASIC_DECONNEXION

Init_Retournement_2
		inc		a
		ld		(EtpRetournement),a
		ld		c,BANK15_GOLDORAK_RET_SPRH
		RST		UPPER_ROM_CONNEXION
		RST		ASIC_CONNEXION
		ld		hl,GOLDORAK_RET2_SPRH_ROM_ADR
		ld		de,SPRH0_ADR
		ld		bc,#400
		LDIR
		call	UpdateRetournement
		call	rom_off
		jp		ASIC_DECONNEXION

Init_Retournement_3
		inc		a
		ld		(EtpRetournement),a
		ld		c,BANK15_GOLDORAK_RET_SPRH
		RST		UPPER_ROM_CONNEXION
		RST		ASIC_CONNEXION
		ld		hl,GOLDORAK_RET3_SPRH_ROM_ADR
		ld		de,SPRH0_ADR
		ld		bc,#400
		LDIR
		call	UpdateRetournement
		call	rom_off
		jp		ASIC_DECONNEXION

Init_Retournement_4
		inc		a
		ld		(EtpRetournement),a
		ld		c,BANK15_GOLDORAK_RET_SPRH
		RST		UPPER_ROM_CONNEXION
		RST		ASIC_CONNEXION
		ld		hl,GOLDORAK_RET4_SPRH_ROM_ADR
		ld		de,SPRH0_ADR
		ld		bc,#400
		LDIR
		call	UpdateRetournement
		call	rom_off
		jp		ASIC_DECONNEXION
Init_Retournement_4b
		inc		a
		ld		(EtpRetournement),a
		RST		ASIC_CONNEXION
		call	UpdateRetournement

		jp		ASIC_DECONNEXION
Init_Retournement_4c
		inc		a
		ld		(EtpRetournement),a
		RST		ASIC_CONNEXION
		call	UpdateRetournement

		jp		ASIC_DECONNEXION
Init_Retournement_5
		inc		a
		ld		(EtpRetournement),a
		ld		c,BANK15_GOLDORAK_RET_SPRH
		RST		UPPER_ROM_CONNEXION
		RST		ASIC_CONNEXION
		ld		hl,GOLDORAK_RET5_SPRH_ROM_ADR
		ld		de,SPRH0_ADR
		ld		bc,#400
		LDIR
		call	UpdateRetournement
		call	rom_off
		jp		ASIC_DECONNEXION
Init_Retournement_6
		inc		a
		ld		(EtpRetournement),a
		ld		c,BANK15_GOLDORAK_RET_SPRH
		RST		UPPER_ROM_CONNEXION
		RST		ASIC_CONNEXION
		ld		hl,GOLDORAK_RET6_SPRH_ROM_ADR
		ld		de,SPRH0_ADR
		ld		bc,#400
		LDIR
		call	UpdateRetournement
		call	rom_off
		jp		ASIC_DECONNEXION
Init_Retournement_7
		inc		a
		ld		(EtpRetournement),a
		ld		c,BANK15_GOLDORAK_RET_SPRH
		RST		UPPER_ROM_CONNEXION
		RST		ASIC_CONNEXION
		ld		hl,GOLDORAK_RET7_SPRH_ROM_ADR
		ld		de,SPRH0_ADR
		ld		bc,#400
		LDIR
		call	UpdateRetournement
		call	rom_off
		jp		ASIC_DECONNEXION
Fin_Retournement
		xor		a
		ld		(flag_retournement),a
		ld		(flag_deja_affiche),a

		ld		(event_retournement),a
		ld		(event_retournement+1),a
		ld		(event_retournement+2),a
		ld		(EtpRetournement),a

		ld		hl,event_test_de_goldorak
		ld		a,_JP
		ld		(event_test_de_goldorak),a
		ld		hl,test_de_goldorak
		ld		(event_test_de_goldorak+1),hl
		ld		a,VITESSE_RETOURNEMENT
		ld		(Compteur_Retournement),a

		ld a,(nbr_de_retournement)
		cp a,NBR_RETOURNEMENT_MAX
		call nz,uncount_retounment
		ret

uncount_retounment
	; on ajoute un retournement effectué
	ld a,(nbr_de_retournement)
	inc a
	ld (nbr_de_retournement),a

	; on ajoute un pixel en haut
	ld  hl,(display_tbl_retournement_top)
	ld (hl),#76

	; on ajoute un pixel en bas
	ld hl,(display_tbl_retournement_bot)
	ld (hl),#76
	ld (display_tbl_retournement_bot),hl

	ld hl,(pointer_tbl_retournement)
	dec hl

	call	update_pointer_tbl_retournement
	ret


update_pointer_tbl_retournement
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
	ret







UpdateRetournement
	ld		hl,(Pointeur_Vitesse_Retournement)
	ld		e,(hl)
	inc		hl
	ld		(Pointeur_Vitesse_Retournement),hl
	ld		d,0
	ld		hl,(SPRH0_Y)
	add		hl,de
	res		0,h
	ld		(SPRH0_Y),hl
	ld		(SPRH1_Y),hl
	ld 		(posy_goldorak),hl
	ld		hl,(SPRH2_Y)
	add		hl,de
	res		0,h
	ld		(SPRH2_Y),hl
	ld		(SPRH3_Y),hl
	ret






