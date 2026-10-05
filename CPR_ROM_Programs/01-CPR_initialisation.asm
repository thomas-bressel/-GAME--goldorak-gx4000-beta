; -------------> NOTES PERSO
; rasm creation_cartouche.asm  -sw
; -sw  exporte les label
; -sq exporte les equ
; -sa  exporte TOUT !

; Ce fichier sert simplement à créer un fichier CPR

; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////
	

ON  EQU 1
OFF EQU 0

macro Bankon
	ld		a,e
	ld 		bc,#DF80
	add		a,c
	ld		c,a	
	out (c),c						; sélèction de la ROM 28
	ld		a,l
	ld		bc,#7f00
	add		a,c
	ld		c,a	
	out (c),c											; on écrit dans la RAM C3 (de #C000 à #Ffff)
	ld		bc,#7f00+%10000000:out (c),c				; connexion ROM haute et basse
mend

macro Asic switch
	if {switch}
	ld 		bc,#7FB8
	out 	(c),c
	else
	ld 		bc,#7FA0
	out 	(c),c
	endif
mend


buildcpr    ; indique que l'on veut construire une cartouche
bank 0      ; initialisation commence toujours en BANK 0
org 0       ; le tout premier code commence toujours à l'adresse 0
di          ; on désactive les INT au cas ou on reset soft
Asic OFF    ; dans le cas où l'on reboot le soft avec l'Asic ON
jr rom_init ; saut par dessus les interruptions et certaines données

; séquence pour délocker l'ASIC
unlockdata defb #ff,#00,#ff,#77,#b3,#51,#a8,#d4,#62,#39,#9c,#46,#2b,#15,#8a,#cd,#ee
; valeurs pour tous les registres du CRTC (pour avoir un ecran standard avec border)
crtcdata   defb 63,40,46,#8e,38,0,25,30,00,07,00,00,#20,00,00,00

; au cas où nous aurions besoin d'une interruption à l'initialisation, on doit interrompre le vecteur à #38
org 	#38
jp	interruptions
;ei

;****************** ROM INIT ***************

rom_init

;********************* MANDATORY TO EXECUTE WITH A C4CPC ***************
	im 		1 					; don't know why but C4CPC corrupt interruption mode!
;***
	ld 		bc,#7FC0 			; default memory conf
	out 	(c),c
	ld 		sp,0     			; raz 64K with stack
	ld 		bc,4
	ld 		hl,0
	.raz
	repeat 	32
	push 	hl
	rend
	djnz .raz
	dec 	c
	jr 		nz,.raz
;**************************** END OF MANDATORY CODE ********************


;; unlock ASIC so we can access ASIC registers (Kevin Thacker)
AsicUnlock
	ld 		b,#bc
	ld 		hl,unlockdata
	ld 		e,17
	.loop
	inc 	b
	outi
	dec 	e
	jr 		nz,.loop

CrtcSettings
ld 			c,0
ld 			e,16
.loop
out 		(c),c
ld 			a,(hl)
inc 		hl
inc 		b
out 		(c),a
dec 		b
inc 		c
dec 		e
jr 			nz,.loop


; R12 selectionne et Ecran en #c000
LD BC,#BC0C:OUT (C),C
LD BC,#BD00+%00110000:OUT (C),C


Asic On

; all colors to black and sprites disabled (DO NOT USE LDIR with a real CPC except if you like the red color ;)
AsicRazParam
; ----> BUG : il y avait deux fois "ld hl" (#6000 puis #6400), le registre DE n'était jamais initialisé.
;       sur la vraie machine DE contient n'importe quoi à l'allumage : les sprites hard (#6000)
;       n'étaient donc jamais éteint et 128 zéros partaient au hasard dans la mémoire.
; ----> CORRECTION : DE cible bien les coordonnées et les zooms des sprites hard
	ld 		de,#6000
	ld 		hl,#6400
	ld 		b,128
	xor 	a
.loop
	ld 		(hl),a
	ld 		(de),a
	inc 	l
	inc 	e
	djnz 	.loop

; init du PPI

ld bc,#f782                     ; setup initial PPI port directions
out (c),c
ld bc,#f400                     ; set initial PPI port A (AY)
out (c),c
ld b,#f6                        ; set initial PPI port C (AY direction)
out (c),c
ld bc,#EF7F                     ; firmware printer init d0->d6=1
out (c),c

; initialisation de la pile !!!
 ld	sp,#BFFE

asic off
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ////////////////////         FIN INIT  CPR       /////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////

test_64k
; ----> BUG : ici on écrivait 0 dans le flag alcorak (#4000 de la RAM étendue) à CHAQUE démarrage.
;       Or quand le jeu est fini on relance avec un "jp 0" : on repassait donc par ici et le flag
;       était effacé juste avant d'être lu. On ne pouvait jamais rejouer avec l'alcorak.
;       Ce zéro avait été mis parce que sur la vraie machine la RAM étendue contient n'importe quoi
;       à l'allumage (les émulateurs la remplissent de zéros) et l'alcorak sortait dès la 1ère partie.
; ----> CORRECTION : on n'efface plus rien ici. Le flag n'est plus un simple octet à 1 mais une signature
;       de 4 octets ("ALCO") écrite à la fin du jeu : la RAM en vrac de l'allumage ne peut pas lui ressembler,
;       et elle survit au "jp 0" car la remise à zéro ci-dessus ne touche que les 64ko de la RAM centrale.
;       voir lecture_flag_alcorak (02a-CPR_creation.asm) et Fin (02f-CPR_fin.asm)



; l'initialisation terminé on appelle l'écran de départ
jp		ecran_de_depart




interruptions
di
; sauvegarde des registres
	push af : push hl : push de
	push bc	: push ix : push iy
; connexion ASIC
	ld		bc,#7F00+%10111000			 
	out 	(c),c
	
; envoie de la ligne dans le PRI
 	ld		a,250
	ld		(#6800),a
;call 	#83CE    ;PLY_AKG_PlayROM

; on rétablie les registres
	pop iy : pop ix : pop bc
	pop de : pop hl : pop af	
ei
ret








include "02a-CPR_creation.asm"
include "02b-CPR_screen.asm"
include "02bb-CPR_menu.asm"
include "02bbb-CPR_credits.asm"
include "02c-CPR_scenario.asm"
include "02d-CPR_gameover.asm"
include "02e-CPR_preparation_du_jeu.asm"
include	"02f-CPR_fin.asm"
include "02g-CPR_metamorphose.asm"
include "02h-CPR_shop.asm"
include "03-CPR_bank.asm"















