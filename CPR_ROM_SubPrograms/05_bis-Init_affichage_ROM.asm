goldo_affiche_ROM	
	ld		hl,(posx_goldorak)
	ld		(SPRH0_X),hl			; sprite 0 X
	ld		(#6010),hl			; sprite 2 X
	ld		de,32+32
	add		hl,de
	ld		(#6008),hl			; sprite 1 X
	ld		(#6018),hl			; sprite 3 X
	ld		hl,(posy_goldorak)
	ld		(SPRH0_Y),hl			; sprite 0 Y
	ld		(#600A),hl			; sprite 1 Y
	ld		de,16
	add 	hl,de
	ld		(#6012),hl			; sprite 2 Y
	ld		(#601A),hl			; sprite 3 Y
	ret

	
	
fondu_de_sortie_ROM	
	ld	a,(timer_fade_out)
	inc	a
	ld	(timer_fade_out),a
	cp	a,VITESSE_FONDU_DE_SORTIE
	ret	nz
	xor		a
	ld	(timer_fade_out),a
	RST		ASIC_CONNEXION
	ld		hl,#000
	ld		(PALETTE_BORDER),hl

; ----> BUG : la fin du fondu était testée en relisant les 32 octets de la palette dans l'ASIC (#6400)
;       et en attendant qu'ils soient tous à zéro.
;       1) sur la vraie machine les 4 bits de poids fort de l'octet du vert ne sont pas câblés : rien
;          ne garantit qu'ils se relisent à zéro (les émulateurs, eux, renvoient toujours zéro).
;          Si un seul de ces bits traîne, le fondu ne se termine jamais : le level ne finit pas
;          après la mort du golgoth.
;       2) selon l'endroit du balayage l'ASIC contient la palette du décor ou celle du HUD.
; ----> CORRECTION : on teste la palette en RAM (PALETTE_DECORS_RAM), c'est elle que l'on fait
;       fondre et on y relit exactement ce que l'on a écrit. Le test est fait AVANT l'étape de
;       fondu : on sort donc une étape après le passage à zéro, le temps que l'interruption ait
;       envoyé le noir à l'ASIC (comme avant).
	ld		b,32
	ld		hl,PALETTE_DECORS_RAM
test_fin_du_fondu
	ld		a,(hl)
	or		a
	jr		nz,fondu_de_sortie_des_couleurs
	inc		hl
	djnz	test_fin_du_fondu
	jr		fin_du_fondu_de_sortie

fondu_de_sortie_des_couleurs
			ld	hl,PALETTE_DECORS_RAM						; emplacement RAM de la pallette ecran
			ld	de,PALETTE_ASIC						; emplacement ASIC de la pallette ecran NOIRE !
			ld 	b,16								; longueur de la pallette
		bcle_fadeout
				push bc
			fade_out_du_rouge
				ld	a,(hl)								; on lit l'octet rouge/bleu
				ld	c,a
				AND %11110000							; on ne garde que le quartet de gauche
				cp	0									; est ce qu'il est à zéros ?
				jp	z,fade_out_du_bleu					; si oui alors on s'occupe de la couleur verte
				or	c
				ld	b,#10								; sinon on va s'occuper du rouge
				sub	a,b									; on lui enlève 1
				ld	(hl),a								; et on la sauvegarde dans la palette RAM
			fade_out_du_bleu
				ld	a,(hl)								; on lit l'octet rouge/bleu
				ld	c,a
				AND %00001111
				cp	0									; est ce qu'il est à zéros ?
				jp	z,fade_out_du_vert						; si oui alors on s'occupe de la couleur verte
				or	c
				dec	a								; sinon on va s'occuper du bleu on lui enlève 1
				ld	(hl),a								; et on la sauvegarde
			fade_out_du_vert
				inc	hl
				ld	a,(hl)								; on lit l'octet vert
				cp	0									; est ce qu'il est à zéros ?
				jp	z,fade_out_encre_suivante			; si oui alors on s'occupe de l'encre suivante
				dec	a								; sinon on va s'occuper du vert on lui enlève 1
				ld	(hl),a								; et on la sauvegarde
			fade_out_encre_suivante
				inc	hl
				pop bc
				djnz bcle_fadeout
				ret

fin_du_fondu_de_sortie
		xor a
		ld (alcorakPuzzleStep),a
		ld (event_alcorak),a
		ld (event_alcorak+1),a
		ld (event_alcorak+2),a

		call	music_off

; tester si on est sur un level qui propose un BIG BOSS
		ld		a,(flag_bigboss)
		cp		a,1
; OUI -> on JUMP vers la gestion d'un level BIG BOSS
		jp		z,big_boss_fin_level_4
		cp		a,2
		jp		z,big_boss_fin_level_8
		; NON  -> on continue
		jp		affiche_ecrans_de_fin
		

				