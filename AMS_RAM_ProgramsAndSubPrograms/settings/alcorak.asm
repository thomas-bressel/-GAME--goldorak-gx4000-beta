
; ///////////////////////////////////////////////////////////////////
; ////////////////////LES ADRESSES DE L'ALCORAK  ////////////////////
; ///////////////////////////////////////////////////////////////////

ALCORAK_HAUTBAS_SPRH_ROM_ADR			equ	#DC00		; de #c000 à #C4000
ALCORAK_GAUCHE_SPRH_ROM_ADR				equ #E000
ALCORAK_DROITE_SPRH_ROM_ADR				equ	#E400

; puzzle de piece de l'alcorak
ALCORAK_PUZZLE_START          equ #F800
ALCORAK_PUZZLE_1        equ ALCORAK_PUZZLE_START
ALCORAK_PUZZLE_2        equ ALCORAK_PUZZLE_START + #100
ALCORAK_PUZZLE_3        equ ALCORAK_PUZZLE_START + #200
ALCORAK_PUZZLE_4        equ ALCORAK_PUZZLE_START + #300
ALCORAK_PUZZLE_5        equ ALCORAK_PUZZLE_START + #400
ALCORAK_PUZZLE_6        equ ALCORAK_PUZZLE_START + #500
ALCORAK_PUZZLE_7        equ ALCORAK_PUZZLE_START + #600
ALCORAK_PUZZLE_8        equ ALCORAK_PUZZLE_START + #700

; flag "le jeu est fini, on rejoue avec l'alcorak" logé dans la RAM étendue du 6128 plus (#7FC4)
; c'est une signature de 4 octets : la RAM en vrac de l'allumage ne peut pas lui ressembler
FLAG_ALCORAK_ADR            equ #4000
FLAG_ALCORAK_SIGNATURE_1    equ #41     ; "A"
FLAG_ALCORAK_SIGNATURE_2    equ #4C     ; "L"
FLAG_ALCORAK_SIGNATURE_3    equ #43     ; "C"
FLAG_ALCORAK_SIGNATURE_4    equ #4F     ; "O"


