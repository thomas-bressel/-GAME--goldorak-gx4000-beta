; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ////////////////////   LECTURE DU CLAVIER  ///////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
lecture_clavier
	LD		BC,#F40E:OUT (C),c
	LD		BC,#F6C0:OUT (C),C
	LD		BC,#F600:OUT (C),C
	LD		BC,#F792:OUT (C),C
	LD		BC,#F649:OUT (C),C
	LD		B,#F4:IN A,(C)
	LD		BC,#F782:OUT (C),C
	LD		BC,#F600:OUT (C),C
	RET

; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ///////////////   AFFICHJAGE LIGNE INFERIEUR /////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
ligneinf_c000
	ld		a,d
	add		a,#8
	ld		d,a
	ret		nc
	ld		bc,#c050
	ex		de,hl
	add		hl,bc
	ex		hl,de
	ret
		ligneinf_4000
			ld 		a,h
			add 	a,#08
			ld 		h,a
			bit		7,a
			ret 	Z		; debordement
			ld 		bc,#C050
			add 	hl,bc
			ret

; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ////////////////////////   DECOMPACTAGE    ///////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; Decompactage
; HL = adresse source (compacte)
; DE = adresse destination
DepkZX0:
	ld	bc,#ffff			; preserve default offset 1
	push	bc
	inc	bc
	ld	a,#80
dzx0s_literals:
	call	dzx0s_elias		; obtain length
	ldir					; copy literals
	add	a,a					; copy from last offset or new offset?
	jr	c,dzx0s_new_offset
	call	dzx0s_elias		; obtain length
dzx0s_copy:
	ex	(sp),hl				; preserve source,restore offset
	push	hl				; preserve offset
	add	hl,de				; calculate destination - offset
	ldir					; copy from offset
	pop	hl					; restore offset
	ex	(sp),hl				; preserve offset,restore source
	add	a,a					; copy from literals or new offset?
	jr	nc,dzx0s_literals
dzx0s_new_offset:
	call	dzx0s_elias		; obtain offset MSB
	ld b,a
	pop	af					; discard last offset
	xor	a					; adjust for negative offset
	sub	c
	RET	Z		; Plus d'octets à traiter = fini

	ld	c,a
	ld	a,b
	ld	b,c
	ld	c,(hl)				; obtain offset LSB
	inc	hl
	rr	b					; last offset bit becomes first length bit
	rr	c
	push	bc				; preserve new offset
	ld	bc,1				; obtain length
	call	nc,dzx0s_elias_backtrack
	inc	bc
	jr	dzx0s_copy
dzx0s_elias:
	inc	c					; interlaced Elias gamma coding
dzx0s_elias_loop:
	add	a,a
	jr	nz,dzx0s_elias_skip
	ld	a,(hl)				; load another group of 8 bits
	inc	hl
	rla
dzx0s_elias_skip:
	ret 	c
dzx0s_elias_backtrack:
	add	a,a
	rl	c
	rl	b
	jr	dzx0s_elias_loop

; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; /////////////////////   FONDU DE SORTIE //////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
FADE_OUT
Asic ON
	ld		hl,#000
	ld		(PALETTE_BORDER),hl
ld		b,#10
boucle_fade_out
	push	bc
	ld      b,#F5
VBL_fadeout
	in      a,(c)
	rra
	jr 		nc,VBL_fadeout
	call	fondu_des_couleurs
	ld		hl,Adresse_pallette_screen
	ld		de,#6400
	ld		bc,#20
	LDIR
	pop		bc
	dec		b
	jp		nz,boucle_fade_out
	ret
fondu_des_couleurs
			ld	hl,Adresse_pallette_screen		; emplacement RAM de la pallette ecran
			ld	de,#6400						; emplacement ASIC de la pallette ecran NOIRE !
			ld b,16								; longueur de la pallette
		boucle_fadein
				push bc
			fade_in_du_rouge
				ld	a,(hl)								; on lit l'octet rouge/bleu
				ld	c,a
				AND %11110000
				cp	0									; est ce qu'il est à zéros ?
				jp	z,fade_in_du_bleu					; si oui alors on s'occupe de la couleur verte
				or	c
				ld	b,#10								; sinon on va s'occuper du rouge
				sub	a,b									; on lui enlève 1
				ld	(hl),a								; et on la sauvegarde
				ld	a,(de)								; on recupère l'octet rouge/bleu de l'ASIC
				add	a,b									; on augmente le rouge seulement
				ld	(de),a								; et on stock le rouge
			fade_in_du_bleu
				ld	a,(hl)								; on lit l'octet rouge/bleu
				ld	c,a
				AND %00001111
				cp	0									; est ce qu'il est à zéros ?
				jp	z,fade_in_du_vert						; si oui alors on s'occupe de la couleur verte
				or	c
				dec	a								; sinon on va s'occuper du bleu on lui enlève 1
				ld	(hl),a								; et on la sauvegarde
				ld	a,(de)								; on recupère l'octet rouge/bleu de l'ASIC
				inc	a								; on augmente le rouge seulement
				ld	(de),a								; et on stock le bleu
			fade_in_du_vert
				inc	hl
				inc	de
				ld	a,(hl)								; on lit l'octet vert
				cp	0									; est ce qu'il est à zéros ?
				jp	z,fade_in_encre_suivante			; si oui alors on s'occupe de l'encre suivante
				dec	a								; sinon on va s'occuper du vert on lui enlève 1
				ld	(hl),a								; et on la sauvegarde
				ld	a,(de)								; on recupère l'octet vert de l'ASIC
				inc	a								; on augmente le rouge seulement
				ld	(de),a								; et on stock le vert
				fade_in_encre_suivante
				inc	hl
				inc	de
				pop bc
				djnz boucle_fadein
				ret

; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ///////////////    LECTEUR DE SAMPLE PSG     /////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
play_sample:
		;ld		hl,adresse_du_sample			; adresse de début du sample
	    ;LD      de,taille_du_sample                  ; Récupère longueur échantillon
		
		
		
		LD      A,2						; registre 2 du PSG
        LD      C,0						; valeur à lui envoyer
        CALL    ecriturePSG				; PSG, Go !
        LD      A,3						; registre 3 du PSG
        LD      C,0						; valeur à lui envoyer
        CALL    ecriturePSG				; PSG, Go !
        LD      A,7						; registre 7 du PSG
        LD      C,#3D                   ; Activer seulement deuxième canal son
        CALL    ecriturePSG				; PSG, Go !
Play_Sample_Rout:
        CALL    Play_Sample_4Bits
        INC     HL
        DEC     DE
        LD      A,D
        OR      E
        JR      NZ,Play_Sample_Rout
        LD      C,D
        LD      A,9
        CALL    ecriturePSG
		ret
Play_Sample_4Bits:
        LD      A,(HL)
        RRC     A
        RRC     A
        RRC     A
        RRC     A
        AND     #0F
        LD      C,A
        LD      A,9
        CALL    ecriturePSG
        LD      B,4
Play_Sample_4Bits2:
        DJNZ    Play_Sample_4Bits2
        LD      A,(HL)
        AND     #0F
        LD      C,A
        RRC     A
        RRC     A
        RRC     A
        RRC     A
        LD      A,9
        CALL    ecriturePSG
        LD      B,4
Play_Sample_4Bits3:
        DJNZ    Play_Sample_4Bits3
	    RET
; Ecriture d'un registre du PSG
; A = numéro de registre
; C = valeur
ecriturePSG:
	    LD      B,#F4
        OUT     (C),A
        LD      B,#F6
        IN      A,(C)
        OR      #C0
        OUT     (C),A
        AND     #3F
        OUT     (C),A
        LD      B,#F4
        OUT     (C),C
        LD      B,#F6
        LD      C,A
        OR      #80
        OUT     (C),A
        OUT     (C),C
		RET



; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ///////////////////////   RAZ CRTC //////////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
reinit_crtc_et_retard_video
	Asic on
	xor	a
	ld	(#6804),a
	
	ld		a,#30
	ld		bc,#bc00+12: out (c),c
	ld		bc,#bd00 : out (c),a
	xor	a
	ld		bc,#bc00+13: out (c),c
	ld		bc,#bd00 :out (c),a
	Asic OFF
	ret


; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////   FLAG ALCORAK DANS LA RAM ETENDUE (128 ko)   /////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; en sortie : flag Z à 1 = le jeu a été fini, on rejoue avec l'alcorak
;
; sur un 464 plus ou une GX4000 il n'y a pas de RAM étendue : le #7FC4 ne fait rien et on lit
; la RAM centrale. Aux deux endroits où cette routine est appelée elle contient soit des 0
; (remise à zéro du démarrage) soit des #C0 (preparation_du_jeu), jamais la signature :
; on joue donc toujours avec goldorak sur ces machines.
lecture_flag_alcorak
	Asic OFF								; ASIC déconnecté, sinon c'est lui qui répond en #4000
	ld		bc,#7fc4:out (c),c				; on connecte la RAM étendue en #4000
	ld		hl,FLAG_ALCORAK_ADR
	ld		a,(hl):cp a,FLAG_ALCORAK_SIGNATURE_1:jr nz,.fin
	inc		hl
	ld		a,(hl):cp a,FLAG_ALCORAK_SIGNATURE_2:jr nz,.fin
	inc		hl
	ld		a,(hl):cp a,FLAG_ALCORAK_SIGNATURE_3:jr nz,.fin
	inc		hl
	ld		a,(hl):cp a,FLAG_ALCORAK_SIGNATURE_4
.fin
	ld		bc,#7fc0:out (c),c				; on revient sur la RAM centrale (ni ld ni out ne touchent au flag Z)
	ret


BufCurseurMenu				equ		#8110



