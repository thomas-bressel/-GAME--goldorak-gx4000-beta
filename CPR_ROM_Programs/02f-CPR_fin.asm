
Fin


; ----> BUG : on écrivait un seul octet à 1. Sur la vraie machine la RAM étendue n'est pas vide à
;       l'allumage, impossible de distinguer "le jeu vient d'être fini" de "la machine vient de s'allumer".
; ----> CORRECTION : on écrit une signature de 4 octets, relue par lecture_flag_alcorak
;       On déconnecte d'abord l'ASIC : s'il est connecté c'est lui qui répond en #4000 et la
;       signature partirait dans le sprite hard 0 au lieu de la RAM étendue.
Asic OFF
ld bc,#7fc4
out (c),c
ld hl,FLAG_ALCORAK_ADR
ld (hl),FLAG_ALCORAK_SIGNATURE_1 : inc hl
ld (hl),FLAG_ALCORAK_SIGNATURE_2 : inc hl
ld (hl),FLAG_ALCORAK_SIGNATURE_3 : inc hl
ld (hl),FLAG_ALCORAK_SIGNATURE_4

ld bc,#7fc0
out (c),c





CALL	reinit_crtc_et_retard_video
	Asic on
	ld		a,167:ld (#6801),a					; ligne de 2eme split
	ld		a,#10:ld (#6802),a					; registre 12

; //////////////////////////////////////////////////////////////////
; /////////////////////////    GAME OVER     /////////////////////
; //////////////////////////////////////////////////////////////////
; on formatte l'écran  pour l'overscan
	LD 		BC,#BC01:OUT (C),C						; position du border
	LD 		BC,#BD00+#30:OUT (C),C
	LD 		BC,#BC02:OUT (C),C						; position de la HBL
	LD 		BC,#BD00+#32:OUT (C),C
	LD 		BC,#BC07:OUT (C),C						; position de la HBL
	LD 		BC,#BD00+#23:OUT (C),C
	LD 		BC,#BC06:OUT (C),C						; position verticale du border
	LD 		BC,#BD00+#21:OUT (C),C
ASIC off
; copie des fichiers GO1 et GO2 en  pour l'overscan
	LD 		BC,BANK19_FIN:OUT (C),C				; on choisit DE LIRE la ROM 15
	LD		BC,#7F00+%10000000:OUT (C),C 			; connexion de la ROM supérieure et de la ROM inférieure et écran en mode 0.
	LD 		BC,#7FC0:OUT (c),c						; on choisit D'ECRIRE  dans la RAM centrale

	ld		hl,#c000							; lecture dans la bank ROM
	ld		de,#4000							; ecriture dans le bank RAM #4000
	call	DepkZX0								; on décompresse

	ld		hl,#4000
	ld		de,#c000
	ld		bc,#4000							; longueur
	LDIR

	ld		hl,#E000							; lecture dans la bank ROM
	ld		de,#4000							; ecriture dans le bank RAM (oui c'est chelou elles ont la même adresse)
	call	DepkZX0

	LD 		BC,#BC0C:OUT (C),C      				;R12 selectionne
	LD 		BC,#BD10:OUT (C),C 						;Ecran en #4000

; rupture ligne 167 normalement mais avec iDRAW2 y'a une bannière a virer en bas de l'ecran
Asic ON

	LD 		BC,#BC0C:OUT (C),C      			; R12 selectionne
	LD 		BC,#BD30:OUT (C),C 					; Ecran en #c000

; copie de la palette CPC+ (logé en bank 19) specialement pour le screen
	LD 		BC,BANK8_PALETTES:OUT (C),C				; on choisit DE LIRE la ROM 14
	LD		BC,#7F00+%10000000:OUT (C),C 		; connexion de la ROM supérieure et de la ROM inférieure et écran en mode 0.
	LD 		BC,#7FC0:OUT (c),c					; on choisit D'ECRIRE  dans la RAM centrale
	ld		hl,PALETTE_FIN							; lecture
	ld		de,#6400							; ecriture
	ld		bc,#20								; longueur
	LDIR
Asic OFF

JP	Init_fin

