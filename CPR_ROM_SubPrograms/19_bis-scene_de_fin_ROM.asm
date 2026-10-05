displaySceneSprites_ROM

; placement du portrait d'actarus
    ld hl,8
    ld (SPRH8_X),hl
    ld (SPRH10_X),hl
    ld de,4
    ld (SPRH8_Y),de
    ld (SPRH9_Y),de
    ld bc,32
    add hl,bc
    ld (SPRH9_X),hl
    ld (SPRH11_X),hl
    ld bc,16
    ex hl,de
    add hl,bc
    ld (SPRH10_Y),hl
    ld (SPRH11_Y),hl
    ex de,hl

; placement du portrait d'actarus
    ld hl,440
    ld (SPRH12_X),hl
    ld (SPRH14_X),hl
    ld de,4
    ld (SPRH12_Y),de
    ld (SPRH13_Y),de
    ld bc,32
    add hl,bc
    ld (SPRH13_X),hl
    ld (SPRH15_X),hl
    ld bc,16
    ex hl,de
    add hl,bc
    ld (SPRH14_Y),hl
    ld (SPRH15_Y),hl
    ex de,hl

; placement de l'Alcorak
    ld hl,200
    ld (alocorak_posX),hl
    ld de,220
    ld (alocorak_posY),de

    call alcorakMovesUpdate

; affichage des srpites
    ld a,zoom_mode0_1
    ld (SPRH4_ZOOM),a : ld	(valeur_zoom+4),a
    ld (SPRH5_ZOOM),a : ld	(valeur_zoom+5),a
    ld (SPRH6_ZOOM),a : ld	(valeur_zoom+6),a
    ld (SPRH7_ZOOM),a : ld	(valeur_zoom+7),a

    ld a,zoom_mode1_1

    ld (SPRH8_ZOOM),a    : ld	(valeur_zoom+8),a
    ld (SPRH9_ZOOM),a       : ld	(valeur_zoom+9),a
    ld (SPRH10_ZOOM),a  : ld	(valeur_zoom+10),a
    ld (SPRH11_ZOOM),a  : ld	(valeur_zoom+11),a
    ld (SPRH12_ZOOM),a  : ld	(valeur_zoom+12),a
    ld (SPRH13_ZOOM),a  : ld	(valeur_zoom+13),a
    ld (SPRH14_ZOOM),a  : ld	(valeur_zoom+14),a
    ld (SPRH15_ZOOM),a  : ld	(valeur_zoom+15),a



ret


alcorakMoves_ROM
; on décremente la position Y de l'alcorak 
    ld de,(alocorak_posY)
    dec de
    ld (alocorak_posY),de

; on calcule pour savoir de quel coté on va déplacer l'Alcorak en fonction du placement de Goldorak à l'écran
    ld bc,(posx_goldorak)
    ld hl,220               ; coordonnée qui correspond au milieu X de l'écran
    sbc hl,bc
    jr nc,alcorakTurnLeft   ; si 220 - pox_goldorak n'est pas négatif alors l'alcorak va à gauche
    jr alcorakTurnRight

return_alcorakTurn
; on met à jour les coordonnées des sprites hard avec la position calculée
    call alcorakMovesUpdate

; on continu de bouger jusqu'à ce que Y de l'alcorak soit supérieur a Y de Goldorak
    ld de,(posy_goldorak)
    ld hl,(alocorak_posY)
    sbc hl,de
    ret nc

; Si Y de l'alcorak est supérieur a Y de Goldorak on passe à l'étape suivante
    ld a,(endingSceneSpritesStep)
    inc a
    ld (endingSceneSpritesStep),a
    ret


alcorakTurnLeft
    ld hl,(alocorak_posX)
    dec hl
    ld (alocorak_posX),hl
    jr return_alcorakTurn

alcorakTurnRight
    ld hl,(alocorak_posX)
    inc hl
    ld (alocorak_posX),hl
    jr return_alcorakTurn




; placement de l'Alcorak
alcorakMovesUpdate
        CALL ASIC_CONNEXION

    ld (SPRH4_X),hl
    ld (SPRH6_X),hl
 
    ld (SPRH4_Y),de
    ld (SPRH5_Y),de
    ld bc,64
    add hl,bc
    ld (SPRH5_X),hl
    ld (SPRH7_X),hl
    ld bc,16
    ex hl,de
    add hl,bc
    ld (SPRH6_Y),hl
    ld (SPRH7_Y),hl
    ex de,hl
ret




isAlcorakTouchGoldorak_ROM
; on calcule pour savoir qui les soucoupe ne se chevauchent pas
    ld hl,(SPRH0_X) ; position X de l'ail gauche de goldorak     
    ld de,(SPRH5_X) ; position X de l'ail droite de l'alcorak
    
    ld bc,64        ; on va chercher la coordonnée 64 pixel plus loin à droite
    ex de,hl
    add hl,bc
    ex hl,de

    sbc hl,de        
    jr c,alcorakMovesLeft

    ; si les soucoupes ne se chavauche pas on passe à l'étape suivante
    ld a,(endingSceneSpritesStep)
    inc a
    ld (endingSceneSpritesStep),a
    ret

return_alcorakMoves
; on met à jour les coordonnées des sprites hard avec la position calculée
    ld  hl,(alocorak_posX)
    ld  de,(alocorak_posY)

    call alcorakMovesUpdate
    ret

alcorakMovesLeft
    ld hl,(alocorak_posX)
    dec hl : dec hl
    ld (alocorak_posX),hl
    jr return_alcorakMoves

alcorakMovesRight
    ld hl,(alocorak_posX)
    inc hl : inc hl
    ld (alocorak_posX),hl
    jr return_alcorakMoves



goAheadBoth_ROM
    ld a,(switchtheend)
    cp a,0
    call z,theEndOfThisGame


; ----> BUG : les deux vaisseaux continuaient de monter pendant tout le fondu de sortie (4 secondes).
;       Dans l'ASIC la position Y d'un sprite hard n'est codée que sur 9 bits : arrivé à -256 on
;       repasse à +255. Sur la vraie machine goldorak et l'alcorak ressortaient donc par le bas de
;       l'écran et le retraversaient plusieurs fois pendant le fondu.
; ----> CORRECTION : une fois sorti de l'écran (Y en dessous de -64) un vaisseau ne bouge plus

; on fait partir l'alcorak vers le haut
    ld a,(alocorak_posY+1)
    cp a,#FF
    jr nz,.alcorak_s_en_va          ; Y positif : il est encore à l'écran
    ld a,(alocorak_posY)
    cp a,-64
    jr c,.alcorak_est_parti
.alcorak_s_en_va
    ld hl,(alocorak_posX)
    dec hl : dec hl
    dec hl : dec hl
    ld (alocorak_posX),hl

    ld de,(alocorak_posY)
    dec de : dec de
    dec de : dec de
    dec de : dec de
    ld (alocorak_posY),de
    call alcorakMovesUpdate
.alcorak_est_parti

; on fait partir goldorak
    ld a,(posy_goldorak+1)
    cp a,#FF
    jr nz,.goldorak_s_en_va
    ld a,(posy_goldorak)
    cp a,-64
    ret c
.goldorak_s_en_va
    ld hl,(posx_goldorak)
    inc hl : inc hl
    inc hl : inc hl
    ld (posx_goldorak),hl

      ld hl,(posy_goldorak)
    dec hl : dec hl
    dec hl : dec hl
    dec hl : dec hl
    ld (posy_goldorak),hl
    call goldorakMovesUpdate
    ret

theEndOfThisGame
    inc a
    ld (switchtheend),a
    ld a,1
    ld (fini),a
    xor a
    ld (flag_bigboss),a
    ld a,_CALL						
	ld (event_fade_out),a
	ld hl,fondu_de_sortie
	ld (event_fade_out+1),hl
    ret
