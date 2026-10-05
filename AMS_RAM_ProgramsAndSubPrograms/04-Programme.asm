org #8000
di
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ////////////////        INIT CONNEXION ROM      //////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
	ld		c,BANK_ROM_0					; sélection de la ROM n°0
	ld		a,#80
	add		a,c							; on ajoute #80 au numéros de la ROM
	ld		c,a							; le reg C contient la valeur de sélection de la ROM
	ld		b,#DF
	ld		(rom_sectionnee),bc
	out		(c),c						; on execute la sélèction de la ROM
	ld		bc,#7F00+%10001100			; ROM inf déconnectée, ROM sup déconnectée, MODE 0
	ld		(etat_de_la_rom),bc
	out		(c),c						; on exécute la connexion de la ROM sélectionnée.
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ////////////////        INIT INTERRUPTIONS      //////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
	ld		a,#C3					; on met un JP
	ld		(#38),a					; en #38
	ld		hl,interruption_ligne_190		; puis l'adresse de l'interruption
	ld		(#39),hl
	
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////    CONFIGURATION BANK, POINTEURS, VIES, NRJ    ////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
ld		c,BANK_ROM_18
call	rom_on_EI
call	rstCreationPrograms_ROM
ld		c,BANK_ROM_2
call	rom_on_EI
automodif_bank_tileset
		ld		hl,BANK_TILESET_1
		ld		(bank_tileset),hl
automodif_bank_level
		ld		hl,BANK_LEVEL_1
		ld		(bank_level),hl
automodif_screen_level
		ld		hl,SCREEN_LEVEL_1
		ld		(adr_screen_level),hl
automodif_depart_level
		ld		hl,SCREEN_DEPART_LEVEL_1+(-16*13)		; je pointe sur la première tile de la ligne à afficher
		ld		(pointeur_de_tile),hl	
		
	LD		hl,PALETTE_DECORS_LEVEL1
	ld		(pallette_level),hl
	call	ROUTE_LEVEL
; la je met toutes les encres à zéro
Asic ON
	xor		a
	ld		hl,PALETTE_ASIC
	ld		(hl),a
	ld		de,PALETTE_ASIC+1
	ld		bc,#20
	LDIR

	ld 		a,SFX_GAMMA_LVL1	 ;Sound effect number (>=1))
	ld		(sfx_arme),a

	ld		hl,#000
	ld		(PALETTE_BORDER),hl
Asic OFF

test_64k_5
; test si le jeu est fini et si on rejoue avec goldorak ou alcorak
; ----> BUG : on relisait ici le #4000 de la RAM étendue. Sur 464 plus / GX4000 (pas de RAM étendue)
;       c'est un octet de l'écran du HUD qui était lu.
; ----> CORRECTION : flag_on_joue_avec_alcorak est déjà renseigné par la cartouche juste après
;       la copie du programme en RAM (voir preparation_du_jeu), il n'y a plus qu'à le lire.
	ld		a,(flag_on_joue_avec_alcorak)
	or		a
	jr		nz,on_flag_alcorak

on_flag_goldorak
	call	affiche_hud
	jr		NOUVEAU_LEVEL
on_flag_alcorak
	call	affiche_hud_alcorak


NOUVEAU_LEVEL
	ld		hl,#c000
	ld		(valeur_offset),hl
	ld		a,SCROLL_SLOW_RETARD_VIDEO
	ld		(vitesse_scroll),a
	call	affiche_fond
	call	Affiche_sprite_hard
	call	initialisation_du_jeu
	
	; on allume et selectionne par défaut le 1er boutton et la 1ere amre

ld a,(flag_on_joue_avec_alcorak)
cp 	a,1
jr z,pas_de_bouton
	ld		hl,HUD_BOUTON_ON_ADR
	ld		de,HUD_BOUTON1_ADR
	ld		b,HUD_HAUTEUR_BOUTTON
	call	bcl_affiche_bouton

pas_de_bouton
	ld		a,(id_arme)
	inc		a
	ld		(id_arme),a
	ld		hl,arme_missiles_gamma
	ld		(adr_type_arme),hl
	ld		a,FORCE_MISSILES_GAMMA
	ld		(points_attaque),a
	
	ei

; permet de re injecter dans les registre secondaire les bonnes valeur du score actuel
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
	call	afficher_le_score

	ld		a,(nbr_de_vie)
	ld		hl,HUD_VIEJ1_ECRAN_ADR
	ld		(HUD_VIEJ1_ECRAN_ADR_SCR),hl
	call	quand_on_perd_une_vie
	
	
	call	RAM_SAMPLES
; /////////////////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////   BOUCLE PRINCIPALE DU JEU   ///////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////
boucle_principale
; ----> BUG : plusieurs routines appelées par un CALL depuis cette boucle en ressortent par un JP
;       (fin_du_level, big_boss_fin_level_4, les init des armes...). A chaque fois 2 ou 4 octets
;       restent sur la pile, qui descend petit à petit et finit par écraser les routines et les
;       variables logées en fin de programme (#BFxx) : plantage au hasard, longtemps après la cause.
;       En mode alcorak la boutique ne remet jamais SP en place, ça se cumulait de level en level.
; ----> CORRECTION : cette boucle est la racine du jeu, rien n'est censé rester sur la pile quand
;       on y revient. On la recale donc à chaque frame.
	ld		sp,#BFFE
	ld    b,#f5    			;adresse du port B du PPI
.vbl
	in    a,(c)     		;On récupère l'octet contenu sur le port dans A
	rra              		;On fait une rotation afin de récupérer le bit 0 dans le flag carry
	jr    nc,.vbl
	ld    b,#f5    			;adresse du port B du PPI





event_bloquer_la_boucle		ds		3,0

	
	call	compteur_evenements
event_playsample		ds		6,0
	;call		Sample
	;jp			boucle_principale
event_alcorak			ds		6,0
	;call		alcorak
	;call		alcorak_puzzle
	;jp			boucle_principale
event_fade_out			ds	    6,0
	;call		fade_out
event_arrimage			ds		6,0
	;call		Arrimage
	;jp			boucle_principale
event_powerup
	call		powerup
event_retournement		ds		3,0
	;call		GoldroakRetournement
event_enemis	
event_ennemis1			ds		3,0
	;call		soucoupe_1
event_ennemis2			ds		3,0
	;call		soucoupe_2
event_ennemis3			ds		3,0
	;call		soucoupe_3
event_ennemis4			ds		3,0
	;call		soucoupe_4
event_ennemis5			ds		3,0
	;call		soucoupe_5
event_ennemis6			ds		3,0
	;call		soucoupe_6	
event_tir_ennemis_1		ds		3,0
event_tir_ennemis_4		ds		3,0
event_tir_ennemis_6		ds		3,0	
	
	
event_golgoth			ds		3,0
	;call		golgoth
	
	
event_autre				ds		28,0
	
event_arme_fireA			ds		3,0	
retour_event_arme_fireA

event_normal_goldorak_boom
event_goldorak_boom


jp	test_du_CPC_plus
retour_test_de_CPC_plus


event_test_de_goldorak		
jp		test_de_goldorak
retour_test_de_goldorak




event_arme_fireB			ds		3,0



; event_boucle_2_joueurs		ds		3,0			; JP boucle_principale


	ld		hl,#000
	ld		(PALETTE_BORDER),hl

event_sprite_a_charger
	call	sprh_a_charger_ou_pas
	call	sprh_animations_arme
	

	jp		boucle_principale
; /////////////////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////


; //////////////////  test du clavier du CPCplus ///////////////////
test_du_CPC_plus
	call  	test_du_clavier_toutes_les_lignes
	
	bit		5,a
	jp		z,music_on_off
	bit		2,a
	jp		z,arme_secrete
	bit		3,a
	jp		z,game_paused	
	
	jp		retour_test_de_CPC_plus
	
			; //////////////////  goldorak  /////////////////
			test_de_goldorak
					test_des_tirs
						call 	test_du_clavier
						bit		4,a
						jp		z,fireA
						bit		5,a
						jp		z,fireB
					
					retour_test_des_tirs

						test_des_directions
							call 	test_du_clavier
							bit		0,a
							jp		z,haut
							bit		1,a
							jp		z,bas
						retour_test_des_directions
								test_des_directions2
									call 	test_du_clavier
									bit		3,a
									jp		z,goldo_droite
									bit		2,a
									jp		z,goldo_gauche
								retour_test_des_directions2
									jp		retour_test_de_goldorak
										

; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ////////////////////       SOUS-ROUTINE  /////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
test_du_clavier
	di
	ld		bc,#F40E:OUT (C),c
	ld		bc,#F6C0:OUT (C),C
	ld		c,#00:OUT (C),C
	ld		c,#49:OUT (C),C
	ld		bc,#F792:OUT (C),C				; on place le port A en sortie (#92)
	ld		b,#F4:IN A,(C)
	ld		bc,#F782:OUT (C),C				; on place le port A en entrée (#82)
	ld		bc,#F600:OUT (C),C
	ei	
	ld		(resultat_test_de_touche),a
	ret
		
						test_du_clavier_toutes_les_lignes
							di
							LD   BC,#F40E : OUT  (C),C   ; Valeur 14 sur le port A         
							LD   BC,#F6C0 : OUT  (C),C   ; C'est un registre         
						    LD   BC,#F600 : OUT  (C),C   ; Validation         
						    LD   BC,#F792 : OUT  (C),C   ; Port A en entrée         
						    LD   A,3             ; A=ligne clavier         
						    OR   %01000000        
						    LD   B,#F6   : OUT   (C),A         
						    LD   B,#F4           ; Lecture du port A         
						    IN   A,(C)           ; A=Reg 14 du PSG         
						    LD   BC,#F782 :  OUT  (C),C   ; Port A en sortie         
						    LD   BC,#F600  : OUT  (C),C       ; Validation  Et A contient la ligne	   
							ei
							ld		(resultat_test_de_touche_cpcplus),a
							ret
				
	
	
	
reinit_poid_faible
; on incremente le compteur du poind fort et raz des unitées
	xor		a
	ld		(counter_poid_faible),a
	ld		a,(counter_poid_fort)
	inc		a
	ld		(counter_poid_fort),a
	ret
	


game_paused
call    music_off
; ----> BUG : en sortant de la pause on relançait toujours le scrolling. Pendant un boss le décor
;       est arrêté exprès : une pause le faisait repartir et il défilait au delà de la map
;       (tiles en vrac derrière le golgoth).
; ----> CORRECTION : on mémorise dans la pile si le scrolling était déjà arrêté avant la pause
;       (0 = il défile, sinon c'est le JP pas_de_scroll_hard qui est en place)
	ld		a,(event_stop_scroll)
	push	af
call	scrolling_off
game_paused_boucle
	ld    b,#f5    			;adresse du port B du PPI
.vbl
	in    a,(c)     		;On récupère l'octet contenu sur le port dans A
	rra              		;On fait une rotation afin de récupérer le bit 0 dans le flag carry
	jr    nc,.vbl
	ld    b,#f5    			;adresse du port B du PPI
	call 	test_du_clavier
						bit		4,a
						jp		z,on_sort_de_pause


jp	game_paused_boucle

on_sort_de_pause
call	music_on
	pop		af						; on récupère l'état du scrolling d'avant la pause
	or		a						; 0 = le décor défilait
call z,scrolling_on
jp retour_test_des_tirs

; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ////////////////////  COMPTEUR D'EVENEMENT ///////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
compteur_evenements
; on incremente le compteur des unitées
	ld		a,(counter_poid_faible)
	inc		a
	ld		(counter_poid_faible),a
	cp		a,255
	call	z,reinit_poid_faible
; on recupère le compteur 16 bits	
	ld		a,(counter_poid_faible)
	ld		c,a
	ld		a,(counter_poid_fort)
	ld		b,a
; on recupère les donnée de la vague
	push 	bc
	ld 		c,BANK_ROM_2
	RST		UPPER_ROM_CONNEXION
	ld		de,(Pointeur_TblNombreDeSoucoupes)
	
	pop	bc
	ld		a,(de)
	ld		l,a
	inc		de
	ld		a,(de)
	ld		h,a
	or  	a
	sbc		hl,bc
	jp		z,nouvelle_vague
	inc 	de
	ld		a,(de)
	ld		l,a
	inc		de
	ld		a,(de)
	ld		h,a
	or  	a
	sbc		hl,bc
	jp		z,fin_de_la_vague
	ret

game_over
	ld		a,#30
	ld		bc,#bc00+12: out (c),c
	ld		bc,#bd00 : ld c,a : out (c),c
	ld		a,#00
	ld		bc,#bc00+13: out (c),c
	ld		bc,#bd00 : ld c,a : out (c),c
	LD 		BC,#DF00+16+#80:OUT (C),C			; on choisit DE LIRE la ROM 11
	LD		BC,#7F00+%10000000:OUT (C),C 		; connexion Upper ROM et Lower ROM (et écran en mode 0.)
	LD 		BC,#7FC0:OUT (c),c					; Mode C0 : on choisit D'ECRIRE  dans la RAM centrale
	JP		perdu
		jeu_termine
			ld		a,#30
			ld		bc,#bc00+12: out (c),c
			ld		bc,#bd00 : ld c,a : out (c),c
			ld		a,#00
			ld		bc,#bc00+13: out (c),c
			ld		bc,#bd00 : ld c,a : out (c),c
			LD 		BC,#DF00+16+#80:OUT (C),C			; on choisit DE LIRE la ROM 11
			LD		BC,#7F00+%10000000:OUT (C),C 		; connexion Upper ROM et Lower ROM (et écran en mode 0.)
			LD 		BC,#7FC0:OUT (c),c					; Mode C0 : on choisit D'ECRIRE  dans la RAM centrale
			jp		Fin

				; fin du level à partir du moment où goldorak est détruit
				fin_du_level
					call	rom_off
; ----> BUG : on recopiait ici la palette de l'ASIC (#6400) vers PALETTE_DECORS_RAM avant le fondu.
;       1) l'ASIC contient la palette du décor OU celle du HUD selon l'endroit où se trouve le
;          balayage : si goldorak explosait en fin de frame le décor prenait les couleurs du HUD.
;       2) sur la vraie machine les 4 bits de poids fort de l'octet du vert ne sont pas câblés,
;          on ne relit pas forcément ce que l'on a écrit.
; ----> CORRECTION : PALETTE_DECORS_RAM contient déjà la bonne palette (c'est elle que l'interruption
;       envoie à l'ASIC à chaque frame), on ne relit plus rien dans l'ASIC.
					RST		ASIC_DECONNEXION
					ld		a,_CALL						; call
					ld		(event_fade_out),a
					ld		hl,fondu_de_sortie
					ld		(event_fade_out+1),hl
					ld		a,_JP						; JP
					ld		(event_fade_out+3),a
					ld		hl,boucle_principale
					ld		(event_fade_out+4),hl
					call	music_off
					xor		a
					ld 		(flag_bigboss),a
					ld		(event_golgoth),a
					ld		(event_golgoth+1),a
					ld		(event_golgoth+2),a
					jp		boucle_principale
Sample
      	call 	PlaySampleSet
		xor		a
		ld		(event_playsample),a
		ld		(event_playsample+1),a
		ld		(event_playsample+2),a
		call	COPIE_RAM_ZIK
		ret
RAM_SAMPLES
	ld		c,31
	RST 	UPPER_ROM_CONNEXION
	ld		hl,#C000
	ld		de,#0100			
	ld		bc,#1d40						 
	ldir
	call	rom_off
	ret
RAM_COPY_SAMPLES_FIN
	ld		c,28
	RST 	UPPER_ROM_CONNEXION
	ld		hl,#e3cb		; adresse du début du sample en ROM
	ld		de,#0100		; adresse de copy en RAM
	ld		bc,#1c30		; longueur du sample à copier (il commence en #FFFF - #e3cb)
	ldir
	call	rom_off
	ret
COPIE_RAM_ZIK
	ld		c,3
	RST 	UPPER_ROM_CONNEXION
	ld		hl,#C000
	ld		de,PLAYER_ADR_RAM				; adresse de départ du player en RAM 
	ld		bc,LONGUEUR_PLAYER+LONGUEUR_MUSIC						 
	ldir
	call	rom_off
	ret 
reinit_music
		ld 		hl,SoundEffects         		; adresse des sfx
		call 	PLY_AKG_InitSoundEffects		
		ld 		hl,Music         				; Initialisation
automodif_music
		ld		a,MUSIC_LVL_1	
		call 	PLY_AKG_Init
		call	music_on
		ret
powerup
	RST		ASIC_DECONNEXION
	ld		c,BANK_ROM_2
	RST		UPPER_ROM_CONNEXION
	call	powerup_ROM
	call	rom_off
	RET	
	

affiche_ecrans_de_fin	
	call	rom_off
	di	
	Asic ON		
	xor		a
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
	
	Asic OFF
		; mise à zéros de la bank #C000-#FFFF
			xor		a
			ld		hl,#C000
			ld		e,l
			ld		d,h
			inc		de
			ld		(hl),a
			ld		bc,#3fff
			LDIR
		; mise à zéros de la bank #4000-#BFFF
			xor		a
			ld		hl,#4000
			ld		e,l
			ld		d,h
			inc		de
			ld		(hl),a
			ld		bc,#3fff
			LDIR	
			Asic ON
			LD 		BC,BANK_GOLDORAK_SPRH:OUT (C),C				; on choisit DE LIRE la ROM 14
			LD		BC,#7F00+%10000000:OUT (C),C 		; connexion de la ROM supérieure et de la ROM inférieure et écran en mode 0.
			LD		hl,#EC00
			ld		de,SPRH15_ADR
			ld		bc,#100
			LDIR
			Asic OFF
			LD 		BC,#DF00+0+#80:OUT (C),C			; on choisit DE LIRE la ROM 11
			LD		BC,#7F00+%10000000:OUT (C),C 		; connexion Upper ROM et Lower ROM (et écran en mode 0.)
			LD 		BC,#7FC0:OUT (c),c					; Mode C0 : on choisit D'ECRIRE  dans la RAM centrale
			ld		a,(GoldorakMort)
			cp		a,1		
			jp		z,game_over
			jp		shop
			



; ----> RAM : change_musique (et reinit_no_musique) n'est appelée nulle part dans le source : aucun CALL,
;       aucun JP, et le code juste au dessus se termine par un JP. Mise en commentaire pour libérer
;       37 octets dans le programme en RAM, qui est plein.
;change_musique
;	di
;	call	PLY_AKG_Stop
;	call	music_off
;	ld 		hl,Music
;	ld		a,(no_de_la_musique)
;	inc		a
;	ld		(no_de_la_musique),a
;	cp		a,MUCIS_NO_MUSIC
;	call	z,reinit_no_musique
;	call 	PLY_AKG_Init
;	call	music_on
;	ei
;	jp	retour_test_de_CPC_plus
;			reinit_no_musique
;			xor 	a
;			ld	(no_de_la_musique),a
;			ret





			
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ////////////////////       FICHIERS      /////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
include"05-Init_affichage.asm"
include"06-Init_de_jeu.asm"
include"07-arrimage.asm"
include"08-deplacements.asm"
include"09-armes_fireA.asm"
include"10-armes_fireB.asm"
include"11-vagues_ennemis.asm"
include"12-soucoupes.asm"
include"13-collisions_ennemis.asm"
include"14-tirs_soucoupes.asm"
include"15-gestion_du_hud.asm"
include"16-alcorak_puzzle.asm"
include"17-big_boss_fin.asm"
include"18-mouvements_soucoupes.asm"
include"19-scene_de_fin.asm"
include"A-interruptions.asm"
include"B-interrupteurs.asm"
include"./music_sfx_samples/player_PSG.asm"
include"./settings/constantes.asm"
include"./datas/variables.asm"


Init_fin
	LD		BC,#7F00+%10001100
	OUT 	(C),C
	ld 		hl,Music         				; Initialisation
	ld		a,MUSIC_LVL_WIN
	call 	PLY_AKG_Init
	jr 		Boucle_Game_Over

Init_Game_Over
	LD		BC,#7F00+%10001100
	OUT 	(C),C
	ld 		hl,Music         				; Initialisation
	ld		a,MUSIC_GAME_OVER
	call 	PLY_AKG_Init
Boucle_Game_Over
 	ld    	b,#f5    			;adresse du port B du PPI
 .vbl
 	in    	a,(c)     		;On récupère l'octet contenu sur le port dans A
 	rra              		;On fait une rotation afin de récupérer le bit 0 dans le flag carry
 	jr    	nc,.vbl
 	ld    	b,#f5    			;adresse du port B du PPI
	call	PLY_AKG_Play
	or 		a
	call 	test_clavier_sans_interruption
	bit		4,a
	jr		z,relancer_le_jeu
	jr 		Boucle_Game_Over


relancer_le_jeu
	call	PLY_AKG_Stop
	LD		BC,#7F00+%10000000
	OUT 	(C),C
	jp  	0

test_clavier_sans_interruption
	ld		bc,#F40E:OUT (C),c
	ld		bc,#F6C0:OUT (C),C
	ld		c,#00:OUT (C),C
	ld		c,#49:OUT (C),C
	ld		bc,#F792:OUT (C),C				; on place le port A en sortie (#92)
	ld		b,#F4:IN A,(C)
	ld		bc,#F782:OUT (C),C				; on place le port A en entrée (#82)
	ld		bc,#F600:OUT (C),C
	ret


init_musique_boutique
	LD		BC,#7F00+%10001100
	OUT 	(C),C
	ld 		hl,Music         				; Initialisation
	ld		a,MUSIC_CREDITS
	call 	PLY_AKG_Init
	LD		BC,#7F00+%10000000
	OUT 	(C),C
	ret

stop_musique_boutique
	LD		BC,#7F00+%10001100
	OUT 	(C),C
	call	PLY_AKG_Stop
	LD		BC,#7F00+%10000000
	OUT 	(C),C
	ret
ret

musique_boutique
	LD		BC,#7F00+%10001100
	OUT 	(C),C
	call	PLY_AKG_Play
	LD		BC,#7F00+%10000000
	OUT 	(C),C
	ret

; /////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////
bank 3
	ORG PLAYER_ADR_RAM
		include"./music_sfx_samples/Goldorak_musiques2024_playerconfig.asm"
		; include"Goldorak_musiques_playerconfig.asm"
		include"./music_sfx_samples/PlayerAkg.asm"						; #0d54 de longueur
 ; La configuration n'est pas obligatoire, mais elle permet
        ; de réduire la taille du binaire produit (ici 1.6K au lieu de 1.8K)
	;ORG #cc60
	ORG MUSIC_ADR_RAM
		Music
			; include"Goldorak_musiques.asm"
			include"./music_sfx_samples/Goldorak_musiques2024.asm"
		SoundEffects
			; include"Goldorak_soundeffects.asm"
			include "./music_sfx_samples/Goldorak_SoundFX.asm"

