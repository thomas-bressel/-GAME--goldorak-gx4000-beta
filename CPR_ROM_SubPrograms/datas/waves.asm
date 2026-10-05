
; ///////////////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////             LEVEL 1            ///////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////////////////////////

TBL_TYPE_DE_SOUCOUPE_1

	dw		TypeSoucoupeVerte2b
	dw		TypeSoucoupeVerte5hvb
	
	dw		TypeSoucoupeVerte1b,TypeSoucoupeVerte4dvb
	dw		TypeSoucoupeVerte3hvb,TypeSoucoupeVerte6zv
	dw		TypeSoucoupeVerte2zv,TypeSoucoupeVerte3b
	dw		TypeSoucoupeVerte1dvb,TypeSoucoupeVerte6zv
	dw		TypeSoucoupeVerte4b,TypeSoucoupeVerte5dvb
	
	dw		TypeSoucoupeVerte1zv,TypeSoucoupeVerte2dvb,TypeSoucoupeVerte3hvb
	dw		TypeSoucoupeVerte4dvb,TypeSoucoupeVerte5b,TypeSoucoupeVerte6zv
	dw		TypeSoucoupeVerte1zv,TypeSoucoupeVerte3hvb,TypeSoucoupeVerte5zv
	dw		TypeSoucoupeVerte2b,TypeSoucoupeVerte4dvb,TypeSoucoupeVerte6hvb
	dw		TypeSoucoupeVerte3hvb,TypeSoucoupeVerte4zv,TypeSoucoupeVerte5hvb

	dw		TypeSoucoupeVerte2zv,TypeSoucoupeVerte3b,TypeSoucoupeVerte4dvb,TypeSoucoupeVerte6b
	dw		TypeSoucoupeVerte1dvb,TypeSoucoupeVerte2hvb,TypeSoucoupeVerte5dvb,TypeSoucoupeVerte6hvb
	dw		TypeSoucoupeVerte1b,TypeSoucoupeVerte2dvb,TypeSoucoupeVerte3b,TypeSoucoupeVerte5dvb
	dw		TypeSoucoupeVerte2hvb,TypeSoucoupeVerte4dvb,TypeSoucoupeVerte5hvb,TypeSoucoupeVerte6dvb
	dw		TypeSoucoupeVerte1zv,TypeSoucoupeVerte3b,TypeSoucoupeVerte4dvb,TypeSoucoupeVerte5hvb

	dw		TypeSoucoupeVerte5dvb,TypeSoucoupeVerte6zv
	dw		TypeSoucoupeVerte1zv,TypeSoucoupeVerte2dvb

	dw		TypeSoucoupeVerte3b,TypeSoucoupeVerte5zv,TypeSoucoupeVerte6b
	dw		TypeSoucoupeVerte1hvb,TypeSoucoupeVerte2dvb,TypeSoucoupeVerte4hvb

; de soucoupe 1 à 6 ce sont les adresse des routines de ces 6 soucoupes qui sont mise en CALL
; à l'interieur de la boucle puit détruite en fin de vague pour par un tir.

TBL_NBR_SOUCOUPES

	dw		vague1s,vague1e,soucoupe_2,0
	dw		vague2s,vague2e,soucoupe_5,0

 	dw		vague3s,vague3e,soucoupe_1,soucoupe_4,0
; ----> le mini boss arrive juste avant cette vague (voir mini_boss_arrive)
MINIBOSS_LEVEL_1
 	dw		vague4s,vague4e,soucoupe_3,soucoupe_6,0
 	dw		vague5s,vague5e,soucoupe_2,soucoupe_3,0
 	dw		vague6s,vague6e,soucoupe_1,soucoupe_6,0
; ----> le 2ème mini boss (le monstre rouge) arrive juste avant cette vague
MINIBOSS2_LEVEL_1
 	dw		vague7s,vague7e,soucoupe_4,soucoupe_5,0

 	dw		vague8s,vague8e,soucoupe_1,soucoupe_2,soucoupe_3,0
 	dw		vague9s,vague9e,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague10s,vague10e,soucoupe_1,soucoupe_3,soucoupe_5,0
 	dw		vague11s,vague11e,soucoupe_2,soucoupe_4,soucoupe_6,0
 	dw		vague12s,vague12e,soucoupe_3,soucoupe_4,soucoupe_5,0

 	dw		vague13s,vague13e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_6,0
 	dw		vague14s,vague14e,soucoupe_1,soucoupe_2,soucoupe_5,soucoupe_6,0
 	dw		vague15s,vague15e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_5,0
 	dw		vague16s,vague16e,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague17s,vague17e,soucoupe_1,soucoupe_3,soucoupe_4,soucoupe_5,0

	dw		vague18s,vague18e,soucoupe_5,soucoupe_6,0
 	dw		vague19s,vague19e,soucoupe_1,soucoupe_2,0

 	dw		vague20s,vague20e,soucoupe_3,soucoupe_5,soucoupe_6,0
 	dw		vague21s,vague21e,soucoupe_1,soucoupe_2,soucoupe_4,0
 	dw		vague22s,vague22e,soucoupe_1,soucoupe_2,soucoupe_4,0

	dw		#FFFF

; ///////////////////////////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////////////////////////


; ///////////////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////             LEVEL 2            ///////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////////////////////////

TBL_TYPE_DE_SOUCOUPE_2
	dw		TypeSoucoupeVerte2zv,TypeSoucoupeVerte3b
	dw		TypeSoucoupeVerte1b,TypeSoucoupeVerte4hvb
	dw		TypeSoucoupeVerte5b,TypeSoucoupeVerte6zv

	dw		TypeSoucoupeVerte1b,TypeSoucoupeVerte3hvb,TypeSoucoupeOrange5hvb
	dw		TypeSoucoupeVerte3zv,TypeSoucoupeOrange4zv,TypeSoucoupeVerte5zv
	dw		TypeSoucoupeOrange2b,TypeSoucoupeVerte4dvb,TypeSoucoupeVerte6zv
	dw		TypeSoucoupeVerte1hvb,TypeSoucoupeOrange2hvb,TypeSoucoupeVerte5dvb
	dw		TypeSoucoupeVerte4zv,TypeSoucoupeVerte5zv,TypeSoucoupeOrange6zv
	dw		TypeSoucoupeVerte1b,TypeSoucoupeOrange2dvb,TypeSoucoupeVerte3dvb
	dw		TypeSoucoupeOrange2b,TypeSoucoupeVerte3hvb,TypeSoucoupeVerte4hvb
	

	dw		TypeSoucoupeVerte1b,TypeSoucoupeOrange3dvb,TypeSoucoupeVerte5zv,TypeSoucoupeVerte6hvb
	dw		TypeSoucoupeVerte2dvb,TypeSoucoupeVerte4b,TypeSoucoupeOrange5hvb,TypeSoucoupeVerte6zv
	dw		TypeSoucoupeVerte1zv,TypeSoucoupeVerte2hvb,TypeSoucoupeOrange3b,TypeSoucoupeOrange4dvb
	dw		TypeSoucoupeVerte2hvb,TypeSoucoupeOrange3zv,TypeSoucoupeVerte4dvb,TypeSoucoupeVerte5b
	dw		TypeSoucoupeOrange1zv,TypeSoucoupeVerte2hvb,TypeSoucoupeOrange4b,TypeSoucoupeVerte6dvb
	dw		TypeSoucoupeVerte3zv,TypeSoucoupeVerte4b,TypeSoucoupeOrange5hvb,TypeSoucoupeOrange6zv
	dw		TypeSoucoupeVerte1b,TypeSoucoupeOrange2zv,TypeSoucoupeVerte5dvb,TypeSoucoupeVerte6hvb

	dw		TypeSoucoupeVerte2zv,TypeSoucoupeVerte5b
	dw		TypeSoucoupeOrange3b,TypeSoucoupeOrange5zv,TypeSoucoupeOrange6zv
	dw		TypeSoucoupeVerte4zv,TypeSoucoupeVerte6b
	dw		TypeSoucoupeVerte2b,TypeSoucoupeOrange3zv,TypeSoucoupeOrange5zv
	dw		TypeSoucoupeOrange1zv,TypeSoucoupeOrange3b,TypeSoucoupeOrange5zv,TypeSoucoupeOrange6zv
	


TBL_NBR_SOUCOUPES2
	dw		vague1s,vague1e,soucoupe_2,soucoupe_3,0
	dw		vague2s,vague2e,soucoupe_1,soucoupe_4,0
	dw		vague3s,vague3e,soucoupe_5,soucoupe_6,0
	

 	dw		vague4s,vague4e,soucoupe_1,soucoupe_3,soucoupe_5,0
 	dw		vague5s,vague5e,soucoupe_3,soucoupe_4,soucoupe_5,0
 	dw		vague6s,vague6e,soucoupe_2,soucoupe_4,soucoupe_6,0
 	dw		vague7s,vague7e,soucoupe_1,soucoupe_2,soucoupe_5,0
 	dw		vague8s,vague8e,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague9s,vague9e,soucoupe_1,soucoupe_2,soucoupe_3,0
 	dw		vague10s,vague10e,soucoupe_2,soucoupe_3,soucoupe_4,0

 	dw		vague11s,vague11e,soucoupe_1,soucoupe_3,soucoupe_5,soucoupe_6,0
 	dw		vague12s,vague12e,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague13s,vague13e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,0
 	dw		vague14s,vague14e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,0
 	dw		vague15s,vague15e,soucoupe_1,soucoupe_2,soucoupe_4,soucoupe_6,0
 	dw		vague16s,vague16e,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague17s,vague17e,soucoupe_1,soucoupe_2,soucoupe_5,soucoupe_6,0

	dw		vague18s,vague18e,soucoupe_2,soucoupe_5,0
 	dw		vague19s,vague19e,soucoupe_3,soucoupe_5,soucoupe_6,0
	dw		vague20s,vague20e,soucoupe_4,soucoupe_6,0
 	dw		vague21s,vague21e,soucoupe_2,soucoupe_3,soucoupe_5,0
 	dw		vague22s,vague22e,soucoupe_1,soucoupe_3,soucoupe_5,soucoupe_6,0
 	dw		vague23s,vague23e,soucoupe_1,soucoupe_3,soucoupe_5,soucoupe_6,0

	dw		#FFFF

; ///////////////////////////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////////////////////////


; ///////////////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////             LEVEL 3            ///////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////////////////////////

TBL_TYPE_DE_SOUCOUPE_3
	dw		TypeSoucoupeOrange2b
	dw		TypeSoucoupeOrange5hvb
	
	dw		TypeSoucoupeOrange1b,TypeSoucoupeOrange4dvb
	dw		TypeSoucoupeOrange3hvb,TypeSoucoupeVerte6zv
	dw		TypeSoucoupeBleue2zv,TypeSoucoupeOrange3b
	dw		TypeSoucoupeOrange1dvb,TypeSoucoupeOrange6zv
	dw		TypeSoucoupeVerte4b,TypeSoucoupeOrange5dvb
	
	dw		TypeSoucoupeOrange1zv,TypeSoucoupeOrange2dvb,TypeSoucoupeOrange3hvb
	dw		TypeSoucoupeVerte4dvb,TypeSoucoupeOrange5b,TypeSoucoupeOrange6zv
	dw		TypeSoucoupeOrange1zv,TypeSoucoupeBleue3hvb,TypeSoucoupeVerte5zv
	dw		TypeSoucoupeOrange2b,TypeSoucoupeOrange4dvb,TypeSoucoupeOrange6hvb
	dw		TypeSoucoupeOrange3hvb,TypeSoucoupeVerte4zv,TypeSoucoupeOrange5hvb

	dw		TypeSoucoupeOrange2zv,TypeSoucoupeOrange3b,TypeSoucoupeOrange4dvb,TypeSoucoupeVerte6b
	dw		TypeSoucoupeOrange1dvb,TypeSoucoupeOrange2hvb,TypeSoucoupeOrange5dvb,TypeSoucoupeOrange6hvb
	dw		TypeSoucoupeOrange1b,TypeSoucoupeOrange2dvb,TypeSoucoupeBleue3b,TypeSoucoupeOrange5dvb
	dw		TypeSoucoupeOrange2hvb,TypeSoucoupeVerte4dvb,TypeSoucoupeOrange5hvb,TypeSoucoupeOrange6dvb
	dw		TypeSoucoupeOrange1zv,TypeSoucoupeOrange3b,TypeSoucoupeVerte4dvb,TypeSoucoupeOrange5hvb

	dw		TypeSoucoupeOrange5dvb,TypeSoucoupeOrange6zv
	dw		TypeSoucoupeOrange1zv,TypeSoucoupeVerte2dvb
	
	dw		TypeSoucoupeOrange1b,TypeSoucoupeOrange3dvb,TypeSoucoupeOrange5zv,TypeSoucoupeOrange6hvb
	dw		TypeSoucoupeVerte2dvb,TypeSoucoupeOrange4b,TypeSoucoupeOrange5hvb,TypeSoucoupeOrange6zv
	dw		TypeSoucoupeOrange1zv,TypeSoucoupeVerte2hvb,TypeSoucoupeOrange3b,TypeSoucoupeOrange4dvb
	dw		TypeSoucoupeBleue2hvb,TypeSoucoupeOrange3zv,TypeSoucoupeVerte4dvb,TypeSoucoupeOrange5b
	dw		TypeSoucoupeOrange1zv,TypeSoucoupeOrange2hvb,TypeSoucoupeOrange4b,TypeSoucoupeVerte6dvb
	dw		TypeSoucoupeOrange3zv,TypeSoucoupeOrange4b,TypeSoucoupeBleue5hvb,TypeSoucoupeOrange6zv
	dw		TypeSoucoupeOrange1b,TypeSoucoupeOrange2zv,TypeSoucoupeOrange5dvb,TypeSoucoupeOrange6hvb

	dw		TypeSoucoupeOrange3b,TypeSoucoupeOrange5zv,TypeSoucoupeOrange6b
	dw		TypeSoucoupeOrange1hvb,TypeSoucoupeOrange2dvb,TypeSoucoupeOrange4hvb


TBL_NBR_SOUCOUPES3
	dw		vague1s,vague1e,soucoupe_2,0
	dw		vague2s,vague2e,soucoupe_5,0

 	dw		vague3s,vague3e,soucoupe_1,soucoupe_4,0
 	dw		vague4s,vague4e,soucoupe_3,soucoupe_6,0
 	dw		vague5s,vague5e,soucoupe_2,soucoupe_3,0
 	dw		vague6s,vague6e,soucoupe_1,soucoupe_6,0
 	dw		vague7s,vague7e,soucoupe_4,soucoupe_5,0

 	dw		vague8s,vague8e,soucoupe_1,soucoupe_2,soucoupe_3,0
 	dw		vague9s,vague9e,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague10s,vague10e,soucoupe_1,soucoupe_3,soucoupe_5,0
 	dw		vague11s,vague11e,soucoupe_2,soucoupe_4,soucoupe_6,0
 	dw		vague12s,vague12e,soucoupe_3,soucoupe_4,soucoupe_5,0

 	dw		vague13s,vague13e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_6,0
 	dw		vague14s,vague14e,soucoupe_1,soucoupe_2,soucoupe_5,soucoupe_6,0
 	dw		vague15s,vague15e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_5,0
 	dw		vague16s,vague16e,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague17s,vague17e,soucoupe_1,soucoupe_3,soucoupe_4,soucoupe_5,0

	dw		vague18s,vague18e,soucoupe_5,soucoupe_6,0
 	dw		vague19s,vague19e,soucoupe_1,soucoupe_2,0
	
 	dw		vague20s,vague20e,soucoupe_1,soucoupe_3,soucoupe_5,soucoupe_6,0
 	dw		vague21s,vague21e,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague22s,vague22e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,0
 	dw		vague23s,vague23e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,0
 	dw		vague24s,vague24e,soucoupe_1,soucoupe_2,soucoupe_4,soucoupe_6,0
 	dw		vague25s,vague25e,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague26s,vague26e,soucoupe_1,soucoupe_2,soucoupe_5,soucoupe_6,0

 	dw		vague27s,vague27e,soucoupe_3,soucoupe_5,soucoupe_6,0
 	dw		vague28s,vague28e,soucoupe_1,soucoupe_2,soucoupe_4,0
 	dw		vague29s,vague29e,soucoupe_1,soucoupe_2,soucoupe_4,0
	dw		#FFFF


; ///////////////////////////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////////////////////////


; ///////////////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////             LEVEL 4            ///////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////////////////////////

 TBL_TYPE_DE_SOUCOUPE_4
	dw		TypeSoucoupeBleue1zv,TypeSoucoupeOrange2dvb,TypeSoucoupeOrange3hvb
	dw		TypeSoucoupeOrange4dvb,TypeSoucoupeBleue5b,TypeSoucoupeOrange6zv
	dw		TypeSoucoupeOrange1zv,TypeSoucoupeOrange3hvb,TypeSoucoupeBleue5zv
	dw		TypeSoucoupeOrange2b,TypeSoucoupeBleue4dvb,TypeSoucoupeOrange6hvb
	dw		TypeSoucoupeBleue3hvb,TypeSoucoupeOrange4zv,TypeSoucoupeOrange5hvb

	dw		TypeSoucoupeOrange1b,TypeSoucoupeBleue3dvb,TypeSoucoupeOrange5zv,TypeSoucoupeOrange6hvb
	dw		TypeSoucoupeVerte2dvb,TypeSoucoupeOrange4b,TypeSoucoupeBleue5hvb,TypeSoucoupeOrange6zv
	dw		TypeSoucoupeOrange1zv,TypeSoucoupeVerte2hvb,TypeSoucoupeOrange3b,TypeSoucoupeBleue4dvb
	dw		TypeSoucoupeOrange2hvb,TypeSoucoupeOrange3zv,TypeSoucoupeBleue4dvb,TypeSoucoupeOrange5b
	dw		TypeSoucoupeOrange1zv,TypeSoucoupeBleue2hvb,TypeSoucoupeOrange4b,TypeSoucoupeVerte6dvb
	dw		TypeSoucoupeBleue3zv,TypeSoucoupeOrange4b,TypeSoucoupeOrange5hvb,TypeSoucoupeOrange6zv
	dw		TypeSoucoupeOrange1b,TypeSoucoupeBleue2zv,TypeSoucoupeOrange5dvb,TypeSoucoupeOrange6hvb

	dw		TypeSoucoupeOrange1b,TypeSoucoupeOrange3hvb,TypeSoucoupeBleue5hvb
	dw		TypeSoucoupeOrange3zv,TypeSoucoupeBleue4zv,TypeSoucoupeOrange5zv
	dw		TypeSoucoupeBleue2b,TypeSoucoupeOrange4dvb,TypeSoucoupeOrange6zv
	dw		TypeSoucoupeOrange1hvb,TypeSoucoupeBleue2hvb,TypeSoucoupeOrange5dvb

	dw		TypeSoucoupeOrange4zv,TypeSoucoupeOrange5zv,TypeSoucoupeBleue6zv
	dw		TypeSoucoupeBleue1b,TypeSoucoupeBleue2dvb,TypeSoucoupeOrange3dvb
	dw		TypeSoucoupeBleue2b,TypeSoucoupeBleue3hvb,TypeSoucoupeBleue4hvb

	dw		TypeSoucoupeOrange2zv,TypeSoucoupeOrange3b,TypeSoucoupeOrange4dvb,TypeSoucoupeVerte6b
	dw		TypeSoucoupeOrange1dvb,TypeSoucoupeOrange2hvb,TypeSoucoupeOrange5dvb,TypeSoucoupeOrange6hvb
	dw		TypeSoucoupeOrange1b,TypeSoucoupeOrange2dvb,TypeSoucoupeBleue3b,TypeSoucoupeOrange5dvb
	dw		TypeSoucoupeOrange2hvb,TypeSoucoupeVerte4dvb,TypeSoucoupeOrange5hvb,TypeSoucoupeOrange6dvb
	dw		TypeSoucoupeOrange1zv,TypeSoucoupeOrange3b,TypeSoucoupeVerte4dvb,TypeSoucoupeOrange5hvb

	dw		TypeSoucoupeOrange5dvb,TypeSoucoupeOrange6zv
	dw		TypeSoucoupeOrange1zv,TypeSoucoupeVerte2dvb
	
	dw		TypeSoucoupeOrange1b,TypeSoucoupeOrange3dvb,TypeSoucoupeOrange5zv,TypeSoucoupeOrange6hvb
	dw		TypeSoucoupeVerte2dvb,TypeSoucoupeOrange4b,TypeSoucoupeOrange5hvb,TypeSoucoupeOrange6zv
	dw		TypeSoucoupeOrange1zv,TypeSoucoupeVerte2hvb,TypeSoucoupeOrange3b,TypeSoucoupeOrange4dvb
	dw		TypeSoucoupeBleue2hvb,TypeSoucoupeOrange3zv,TypeSoucoupeVerte4zv,TypeSoucoupeOrange5b
	dw		TypeSoucoupeOrange1zv,TypeSoucoupeOrange2zv,TypeSoucoupeOrange4b,TypeSoucoupeVerte6zv
	dw		TypeSoucoupeOrange3zv,TypeSoucoupeOrange4b,TypeSoucoupeBleue5zv,TypeSoucoupeOrange6zv
	dw		TypeSoucoupeOrange1b,TypeSoucoupeOrange3zv,TypeSoucoupeOrange5zv,TypeSoucoupeOrange6zv
	dw		TypeSoucoupeOrange1b,TypeSoucoupeOrange4zv,TypeSoucoupeOrange5zv,TypeSoucoupeOrange6zv
	dw		TypeSoucoupeOrange2b,TypeSoucoupeOrange4zv,TypeSoucoupeOrange5zv,TypeSoucoupeOrange6zv



 TBL_NBR_SOUCOUPES4

 	dw		vague1s,vague1e,soucoupe_1,soucoupe_2,soucoupe_3,0
 	dw		vague2s,vague2e,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague3s,vague3e,soucoupe_1,soucoupe_3,soucoupe_5,0
 	dw		vague4s,vague4e,soucoupe_2,soucoupe_4,soucoupe_6,0
 	dw		vague5s,vague5e,soucoupe_3,soucoupe_4,soucoupe_5,0

 	dw		vague6s,vague6e,soucoupe_1,soucoupe_3,soucoupe_5,soucoupe_6,0
 	dw		vague7s,vague7e,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague8s,vague8e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,0
 	dw		vague9s,vague9e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,0
 	dw		vague10s,vague10e,soucoupe_1,soucoupe_2,soucoupe_4,soucoupe_6,0
 	dw		vague11s,vague11e,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague12s,vague12e,soucoupe_1,soucoupe_2,soucoupe_5,soucoupe_6,0

	dw		vague13s,vague13e,soucoupe_1,soucoupe_3,soucoupe_5,0
 	dw		vague14s,vague14e,soucoupe_3,soucoupe_4,soucoupe_5,0
 	dw		vague15s,vague15e,soucoupe_2,soucoupe_4,soucoupe_6,0
 	dw		vague16s,vague16e,soucoupe_1,soucoupe_2,soucoupe_5,0

	dw		vague17s,vague17e,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague18s,vague18e,soucoupe_1,soucoupe_2,soucoupe_3,0
 	dw		vague19s,vague19e,soucoupe_2,soucoupe_3,soucoupe_4,0

 	dw		vague20s,vague20e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_6,0
 	dw		vague21s,vague21e,soucoupe_1,soucoupe_2,soucoupe_5,soucoupe_6,0
 	dw		vague22s,vague22e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_5,0
 	dw		vague23s,vague23e,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague24s,vague24e,soucoupe_1,soucoupe_3,soucoupe_4,soucoupe_5,0

	dw		vague25s,vague25e,soucoupe_5,soucoupe_6,0
 	dw		vague26s,vague26e,soucoupe_1,soucoupe_2,0
	
 	dw		vague27s,vague27e,soucoupe_1,soucoupe_3,soucoupe_5,soucoupe_6,0
 	dw		vague28s,vague28e,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague29s,vague29e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,0
 	dw		vague30s,vague30e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,0
 	dw		vague31s,vague31e,soucoupe_1,soucoupe_2,soucoupe_4,soucoupe_6,0
 	dw		vague32s,vague32e,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague33s,vague33e,soucoupe_1,soucoupe_3,soucoupe_5,soucoupe_6,0
 	dw		vague34s,vague34e,soucoupe_1,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague35s,vague35e,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague36s,vague36e,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	
	dw		#FFFF

; ///////////////////////////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////////////////////////


; ///////////////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////             LEVEL 5            ///////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////////////////////////

 TBL_TYPE_DE_SOUCOUPE_5
	dw		TypeSoucoupeBleue1zv,TypeSoucoupeOrange2zv,TypeSoucoupeOrange3hvb
	dw		TypeSoucoupeOrange4dvb,TypeSoucoupeBleue5zv,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeOrange3zv,TypeSoucoupeBleue5zv
	dw		TypeSoucoupeOrange2zv,TypeSoucoupeBleue4dvb,TypeSoucoupeOrange6hvb
	dw		TypeSoucoupeBleue3hvb,TypeSoucoupeOrange4zv,TypeSoucoupeOrange5hvb

	dw		TypeSoucoupeViolette1zv,TypeSoucoupeBleue3dvb,TypeSoucoupeOrange5zv,TypeSoucoupeOrange6hvb
	dw		TypeSoucoupeVerte2t,TypeSoucoupeOrange4zv,TypeSoucoupeBleue5hvb,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeVerte2t,TypeSoucoupeOrange3b,TypeSoucoupeBleue4dvb
	dw		TypeSoucoupeOrange2hvb,TypeSoucoupeOrange3zv,TypeSoucoupeBleue4dvb,TypeSoucoupeOrange5b
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeBleue2hvb,TypeSoucoupeOrange4zv,TypeSoucoupeVerte6t
	dw		TypeSoucoupeBleue3zv,TypeSoucoupeOrange4zv,TypeSoucoupeOrange5hvb,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeBleue2zv,TypeSoucoupeOrange5dvb,TypeSoucoupeOrange6hvb

	dw		TypeSoucoupeViolette1zv,TypeSoucoupeOrange3hvb,TypeSoucoupeBleue5hvb
	dw		TypeSoucoupeOrange3zv,TypeSoucoupeBleue4zv,TypeSoucoupeOrange5zv
	dw		TypeSoucoupeViolette2b,TypeSoucoupeOrange4dvb,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeOrange1hvb,TypeSoucoupeBleue2hvb,TypeSoucoupeOrange5dvb

	dw		TypeSoucoupeOrange4zv,TypeSoucoupeOrange5zv,TypeSoucoupeBleue6zv
	dw		TypeSoucoupeBleue1zv,TypeSoucoupeBleue2dvb,TypeSoucoupeOrange3dvb
	dw		TypeSoucoupeViolette2b,TypeSoucoupeBleue3hvb,TypeSoucoupeBleue4hvb

	dw		TypeSoucoupeOrange2zv,TypeSoucoupeOrange3b,TypeSoucoupeOrange4dvb,TypeSoucoupeVerte6t
	dw		TypeSoucoupeOrange1dvb,TypeSoucoupeOrange2hvb,TypeSoucoupeOrange5dvb,TypeSoucoupeOrange6hvb
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeOrange2dvb,TypeSoucoupeBleue3b,TypeSoucoupeOrange5dvb
	dw		TypeSoucoupeOrange2hvb,TypeSoucoupeVerte4t,TypeSoucoupeOrange5hvb,TypeSoucoupeOrange6dvb
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeOrange3b,TypeSoucoupeVerte4t,TypeSoucoupeOrange5hvb

	dw		TypeSoucoupeVerte1t, TypeSoucoupeVerte4t, TypeSoucoupeOrange5dvb,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeVerte2t,TypeSoucoupeVerte5t
	
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeOrange3dvb,TypeSoucoupeOrange5zv,TypeSoucoupeOrange6hvb
	dw		TypeSoucoupeVerte2t,TypeSoucoupeOrange4zv,TypeSoucoupeOrange5hvb,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeVerte2t,TypeSoucoupeOrange3b,TypeSoucoupeOrange4dvb
	dw		TypeSoucoupeBleue2hvb,TypeSoucoupeOrange3zv,TypeSoucoupeVerte4t,TypeSoucoupeOrange5b
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeOrange2zv,TypeSoucoupeOrange4zv,TypeSoucoupeVerte6t
	dw		TypeSoucoupeOrange3zv,TypeSoucoupeOrange4zv,TypeSoucoupeBleue5zv,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeOrange3zv,TypeSoucoupeOrange5zv,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeOrange4zv,TypeSoucoupeOrange5zv,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeOrange2b,TypeSoucoupeOrange4zv,TypeSoucoupeOrange5zv,TypeSoucoupeViolette6zv



 TBL_NBR_SOUCOUPES5
  	dw		vague1s,vague1e,soucoupe_1,soucoupe_2,soucoupe_3,0
 	dw		vague2s,vague2e,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague3s,vague3e,soucoupe_1,soucoupe_3,soucoupe_5,0
 	dw		vague4s,vague4e,soucoupe_2,soucoupe_4,soucoupe_6,0
 	dw		vague5s,vague5e,soucoupe_3,soucoupe_4,soucoupe_5,0

 	dw		vague6s,vague6e,soucoupe_1,soucoupe_3,soucoupe_5,soucoupe_6,0
 	dw		vague7s,vague7e,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague8s,vague8e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,0
 	dw		vague9s,vague9e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,0
 	dw		vague10s,vague10e,soucoupe_1,soucoupe_2,soucoupe_4,soucoupe_6,0
 	dw		vague11s,vague11e,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague12s,vague12e,soucoupe_1,soucoupe_2,soucoupe_5,soucoupe_6,0

	dw		vague13s,vague13e,soucoupe_1,soucoupe_3,soucoupe_5,0
 	dw		vague14s,vague14e,soucoupe_3,soucoupe_4,soucoupe_5,0
 	dw		vague15s,vague15e,soucoupe_2,soucoupe_4,soucoupe_6,0
 	dw		vague16s,vague16e,soucoupe_1,soucoupe_2,soucoupe_5,0

	dw		vague17s,vague17e,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague18s,vague18e,soucoupe_1,soucoupe_2,soucoupe_3,0
 	dw		vague19s,vague19e,soucoupe_2,soucoupe_3,soucoupe_4,0

 	dw		vague20s,vague20e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_6,0
 	dw		vague21s,vague21e,soucoupe_1,soucoupe_2,soucoupe_5,soucoupe_6,0
 	dw		vague22s,vague22e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_5,0
 	dw		vague23s,vague23e,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague24s,vague24e,soucoupe_1,soucoupe_3,soucoupe_4,soucoupe_5,0

	dw		vague25s,vague25e,soucoupe_1,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague26s,vague26e,soucoupe_1,soucoupe_2,soucoupe_5,0
	
 	dw		vague27s,vague27e,soucoupe_1,soucoupe_3,soucoupe_5,soucoupe_6,0
 	dw		vague28s,vague28e,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague29s,vague29e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,0
 	dw		vague30s,vague30e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,0
 	dw		vague31s,vague31e,soucoupe_1,soucoupe_2,soucoupe_4,soucoupe_6,0
 	dw		vague32s,vague32e,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague33s,vague33e,soucoupe_1,soucoupe_3,soucoupe_5,soucoupe_6,0
 	dw		vague34s,vague34e,soucoupe_1,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague35s,vague35e,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague36s,vague36e,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	
	dw		#FFFF

; ///////////////////////////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////////////////////////


; ///////////////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////             LEVEL 6            ///////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////////////////////////

 TBL_TYPE_DE_SOUCOUPE_6
	dw		TypeSoucoupeBleue1zv,TypeSoucoupeViolette2dvb,TypeSoucoupeBleue3dvb,TypeSoucoupeViolette5b
	dw		TypeSoucoupeVerte2t,TypeSoucoupeBleue4dvb,TypeSoucoupeBleue5b,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeBleue1zv,TypeSoucoupeViolette3hvb,TypeSoucoupeBleue5zv,TypeSoucoupeVerte6t
	dw		TypeSoucoupeBleue2b,TypeSoucoupeBleue4dvb,TypeSoucoupeBleue5zv,TypeSoucoupeVerte6t
	dw		TypeSoucoupeVerte2t,TypeSoucoupeBleue3hvb,TypeSoucoupeBleue4zv,TypeSoucoupeViolette5hvb

	dw		TypeSoucoupeViolette1b,TypeSoucoupeBleue3dvb,TypeSoucoupeViolette5zv,TypeSoucoupeOrange6hvb
	dw		TypeSoucoupeVerte2t,TypeSoucoupeVerte4t,TypeSoucoupeBleue5hvb,TypeSoucoupeOrange6zv
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeVerte2t,TypeSoucoupeOrange3b,TypeSoucoupeBleue4dvb
	dw		TypeSoucoupeOrange2hvb,TypeSoucoupeOrange3zv,TypeSoucoupeBleue4dvb,TypeSoucoupeViolette5b
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeBleue2hvb,TypeSoucoupeViolette4b,TypeSoucoupeVerte6t
	dw		TypeSoucoupeBleue3zv,TypeSoucoupeViolette4b,TypeSoucoupeViolette5hvb,TypeSoucoupeOrange6zv
	dw		TypeSoucoupeViolette1b,TypeSoucoupeBleue2zv,TypeSoucoupeViolette5dvb,TypeSoucoupeOrange6hvb

	dw		TypeSoucoupeViolette1b,TypeSoucoupeOrange3hvb,TypeSoucoupeBleue5hvb,TypeSoucoupeVerte6t
	dw		TypeSoucoupeOrange3zv,TypeSoucoupeBleue4zv,TypeSoucoupeViolette5zv
	dw		TypeSoucoupeVerte2t,TypeSoucoupeViolette4dvb,TypeSoucoupeVerte6t
	dw		TypeSoucoupeViolette1hvb,TypeSoucoupeBleue2hvb,TypeSoucoupeViolette5dvb

	dw		TypeSoucoupeViolette4zv,TypeSoucoupeViolette5zv,TypeSoucoupeBleue6zv
	dw		TypeSoucoupeBleue1b,TypeSoucoupeVerte2t,TypeSoucoupeOrange3dvb,TypeSoucoupeVerte5t
	dw		TypeSoucoupeBleue2b,TypeSoucoupeVerte3t,TypeSoucoupeBleue4hvb,TypeSoucoupeVerte6t

	dw		TypeSoucoupeOrange2zv,TypeSoucoupeOrange3b,TypeSoucoupeViolette4dvb,TypeSoucoupeVerte6t
	dw		TypeSoucoupeViolette1dvb,TypeSoucoupeOrange2hvb,TypeSoucoupeViolette5dvb,TypeSoucoupeOrange6hvb
	dw		TypeSoucoupeViolette1b,TypeSoucoupeOrange2dvb,TypeSoucoupeBleue3b,TypeSoucoupeViolette5dvb
	dw		TypeSoucoupeOrange2hvb,TypeSoucoupeVerte4t,TypeSoucoupeViolette5hvb,TypeSoucoupeOrange6dvb
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeOrange3b,TypeSoucoupeVerte4t,TypeSoucoupeViolette5hvb

	dw		TypeSoucoupeViolette5dvb,TypeSoucoupeOrange6zv
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeVerte2t
	
	dw		TypeSoucoupeViolette1b,TypeSoucoupeOrange3dvb,TypeSoucoupeViolette5zv,TypeSoucoupeOrange6hvb
	dw		TypeSoucoupeVerte2t,TypeSoucoupeViolette4b,TypeSoucoupeViolette5hvb,TypeSoucoupeOrange6zv
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeVerte2t,TypeSoucoupeOrange3b,TypeSoucoupeViolette4dvb,TypeSoucoupeVerte6t
	dw		TypeSoucoupeBleue2hvb,TypeSoucoupeOrange3zv,TypeSoucoupeVerte4t,TypeSoucoupeViolette5b,TypeSoucoupeVerte6t
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeOrange2zv,TypeSoucoupeVerte3t,TypeSoucoupeViolette4b,TypeSoucoupeVerte6t
	dw		TypeSoucoupeVerte2t,TypeSoucoupeOrange3zv,TypeSoucoupeViolette4b,TypeSoucoupeBleue5zv,TypeSoucoupeOrange6zv
	dw		TypeSoucoupeVerte1t,TypeSoucoupeOrange3zv,TypeSoucoupeViolette4b,TypeSoucoupeViolette5zv,TypeSoucoupeOrange6zv
	dw		TypeSoucoupeVerte1t,TypeSoucoupeOrange3zv,TypeSoucoupeViolette4hvb,TypeSoucoupeVerte5t,TypeSoucoupeOrange6zv
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeVerte2t,TypeSoucoupeViolette4zv,TypeSoucoupeVerte5t,TypeSoucoupeOrange6zv



 TBL_NBR_SOUCOUPES6
	dw		vague1s,vague1e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_5,0
 	dw		vague2s,vague2e,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague3s,vague3e,soucoupe_1,soucoupe_3,soucoupe_5,soucoupe_6,0
 	dw		vague4s,vague4e,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague5s,vague5e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,0

 	dw		vague6s,vague6e,soucoupe_1,soucoupe_3,soucoupe_5,soucoupe_6,0
 	dw		vague7s,vague7e,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague8s,vague8e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,0
 	dw		vague9s,vague9e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,0
 	dw		vague10s,vague10e,soucoupe_1,soucoupe_2,soucoupe_4,soucoupe_6,0
 	dw		vague11s,vague11e,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague12s,vague12e,soucoupe_1,soucoupe_2,soucoupe_5,soucoupe_6,0

	dw		vague13s,vague13e,soucoupe_1,soucoupe_3,soucoupe_5,soucoupe_6,0
 	dw		vague14s,vague14e,soucoupe_3,soucoupe_4,soucoupe_5,0
 	dw		vague15s,vague15e,soucoupe_2,soucoupe_4,soucoupe_6,0
 	dw		vague16s,vague16e,soucoupe_1,soucoupe_2,soucoupe_5,0

	dw		vague17s,vague17e,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague18s,vague18e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_5,0
 	dw		vague19s,vague19e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_6,0

 	dw		vague20s,vague20e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_6,0
 	dw		vague21s,vague21e,soucoupe_1,soucoupe_2,soucoupe_5,soucoupe_6,0
 	dw		vague22s,vague22e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_5,0
 	dw		vague23s,vague23e,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague24s,vague24e,soucoupe_1,soucoupe_3,soucoupe_4,soucoupe_5,0

	dw		vague25s,vague25e,soucoupe_5,soucoupe_6,0
 	dw		vague26s,vague26e,soucoupe_1,soucoupe_2,0
	
 	dw		vague27s,vague27e,soucoupe_1,soucoupe_3,soucoupe_5,soucoupe_6,0
 	dw		vague28s,vague28e,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague29s,vague29e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_6,0
 	dw		vague30s,vague30e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague31s,vague31e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_6,0
 	dw		vague32s,vague32e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague33s,vague33e,soucoupe_1,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague34s,vague34e,soucoupe_1,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague35s,vague35e,soucoupe_1,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague36s,vague36e,soucoupe_1,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	
	dw		#FFFF




; ///////////////////////////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////////////////////////


; ///////////////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////             LEVEL 7            ///////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////////////////////////


  TBL_TYPE_DE_SOUCOUPE_7
	dw		TypeSoucoupeBleue1zv,TypeSoucoupeViolette2dvb,TypeSoucoupeBleue3dvb,TypeSoucoupeViolette4b,TypeSoucoupeViolette5b
	dw		TypeSoucoupeVerte1t,TypeSoucoupeVerte2t,TypeSoucoupeBleue4dvb,TypeSoucoupeBleue5b,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeBleue1zv,TypeSoucoupeViolette3hvb,TypeSoucoupeViolette4b,TypeSoucoupeBleue5zv,TypeSoucoupeVerte6t
	dw		TypeSoucoupeBleue2b,TypeSoucoupeViolette3zv,TypeSoucoupeBleue4dvb,TypeSoucoupeBleue5zv,TypeSoucoupeVerte6t
	dw		TypeSoucoupeVerte2t,TypeSoucoupeBleue3hvb,TypeSoucoupeBleue4zv,TypeSoucoupeViolette5hvb

	dw		TypeSoucoupeViolette1b,TypeSoucoupeBleue3dvb,TypeSoucoupeViolette5zv,TypeSoucoupeViolette6hvb
	dw		TypeSoucoupeVerte2t,TypeSoucoupeVerte4t,TypeSoucoupeBleue5hvb,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeVerte2t,TypeSoucoupeViolette3b,TypeSoucoupeBleue4dvb
	dw		TypeSoucoupeViolette2hvb,TypeSoucoupeViolette3zv,TypeSoucoupeBleue4dvb,TypeSoucoupeViolette5b
	dw		TypeSoucoupeVerte1t,TypeSoucoupeBleue2hvb,TypeSoucoupeViolette4b,TypeSoucoupeVerte6t
	dw		TypeSoucoupeBleue3zv,TypeSoucoupeViolette4b,TypeSoucoupeViolette5hvb,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeVerte1t,TypeSoucoupeBleue2zv,TypeSoucoupeViolette5dvb,TypeSoucoupeViolette6hvb

	dw		TypeSoucoupeBleue2hvb,TypeSoucoupeViolette3zv,TypeSoucoupeVerte4t,TypeSoucoupeViolette5b,TypeSoucoupeViolette6dvb
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeViolette2zv,TypeSoucoupeVerte3t,TypeSoucoupeViolette4b,TypeSoucoupeVerte6t
	dw		TypeSoucoupeVerte2t,TypeSoucoupeViolette3zv,TypeSoucoupeViolette4b,TypeSoucoupeBleue5zv,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeVerte1t,TypeSoucoupeViolette3zv,TypeSoucoupeViolette4b,TypeSoucoupeViolette5zv,TypeSoucoupeViolette6zv

	dw		TypeSoucoupeVerte1t,TypeSoucoupeViolette3zv,TypeSoucoupeViolette4b,TypeSoucoupeViolette5zv,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeBleue1b,TypeSoucoupeVerte2t,TypeSoucoupeViolette3dvb,TypeSoucoupeVerte5t
	dw		TypeSoucoupeBleue2b,TypeSoucoupeVerte3t,TypeSoucoupeBleue4hvb,TypeSoucoupeVerte6t

	dw		TypeSoucoupeViolette2zv,TypeSoucoupeViolette3b,TypeSoucoupeViolette4dvb,TypeSoucoupeVerte6t
	dw		TypeSoucoupeViolette1dvb,TypeSoucoupeViolette2hvb,TypeSoucoupeViolette5dvb,TypeSoucoupeViolette6hvb
	dw		TypeSoucoupeViolette1b,TypeSoucoupeViolette2dvb,TypeSoucoupeBleue3b,TypeSoucoupeViolette5dvb
	dw		TypeSoucoupeViolette2hvb,TypeSoucoupeVerte4t,TypeSoucoupeViolette5hvb,TypeSoucoupeViolette6dvb
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeViolette3b,TypeSoucoupeVerte4t,TypeSoucoupeViolette5hvb

	dw		TypeSoucoupeViolette2hvb,TypeSoucoupeViolette3zv,TypeSoucoupeBleue4dvb,TypeSoucoupeViolette5b
	dw		TypeSoucoupeVerte1t,TypeSoucoupeBleue2hvb,TypeSoucoupeViolette4b,TypeSoucoupeVerte6t
	
	dw		TypeSoucoupeVerte1t,TypeSoucoupeViolette3dvb,TypeSoucoupeViolette5zv,TypeSoucoupeViolette6hvb
	dw		TypeSoucoupeVerte2t,TypeSoucoupeViolette4b,TypeSoucoupeViolette5hvb,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeVerte2t,TypeSoucoupeViolette3b,TypeSoucoupeViolette4dvb,TypeSoucoupeVerte6t
	dw		TypeSoucoupeBleue2hvb,TypeSoucoupeViolette3zv,TypeSoucoupeVerte4t,TypeSoucoupeViolette5b,TypeSoucoupeViolette6dvb
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeViolette2zv,TypeSoucoupeVerte3t,TypeSoucoupeViolette4b,TypeSoucoupeVerte6t
	dw		TypeSoucoupeVerte2t,TypeSoucoupeViolette3zv,TypeSoucoupeViolette4b,TypeSoucoupeBleue5zv,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeVerte1t,TypeSoucoupeViolette3zv,TypeSoucoupeViolette4b,TypeSoucoupeViolette5zv,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeVerte1t,TypeSoucoupeViolette3zv,TypeSoucoupeViolette4hvb,TypeSoucoupeVerte5t,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeVerte2t,TypeSoucoupeViolette4zv,TypeSoucoupeVerte5t,TypeSoucoupeViolette6zv





  TBL_NBR_SOUCOUPES7
	dw		vague1s,vague1e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,0
 	dw		vague2s,vague2e,soucoupe_1,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague3s,vague3e,soucoupe_1,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague4s,vague4e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague5s,vague5e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,0

 	dw		vague6s,vague6e,soucoupe_1,soucoupe_3,soucoupe_5,soucoupe_6,0
 	dw		vague7s,vague7e,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague8s,vague8e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,0
 	dw		vague9s,vague9e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,0
 	dw		vague10s,vague10e,soucoupe_1,soucoupe_2,soucoupe_4,soucoupe_6,0
 	dw		vague11s,vague11e,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague12s,vague12e,soucoupe_1,soucoupe_2,soucoupe_5,soucoupe_6,0

	dw		vague13s,vague13e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague14s,vague14e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_6,0
 	dw		vague15s,vague15e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague16s,vague16e,soucoupe_1,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0

	dw		vague17s,vague17e,soucoupe_1,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague18s,vague18e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_5,0
 	dw		vague19s,vague19e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_6,0

 	dw		vague20s,vague20e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_6,0
 	dw		vague21s,vague21e,soucoupe_1,soucoupe_2,soucoupe_5,soucoupe_6,0
 	dw		vague22s,vague22e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_5,0
 	dw		vague23s,vague23e,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague24s,vague24e,soucoupe_1,soucoupe_3,soucoupe_4,soucoupe_5,0

	dw		vague25s,vague25e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,0
 	dw		vague26s,vague26e,soucoupe_1,soucoupe_2,soucoupe_4,soucoupe_6,0
	
 	dw		vague27s,vague27e,soucoupe_1,soucoupe_3,soucoupe_5,soucoupe_6,0
 	dw		vague28s,vague28e,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague29s,vague29e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_6,0
 	dw		vague30s,vague30e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague31s,vague31e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_6,0
 	dw		vague32s,vague32e,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague33s,vague33e,soucoupe_1,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague34s,vague34e,soucoupe_1,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague35s,vague35e,soucoupe_1,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague36s,vague36e,soucoupe_1,soucoupe_2,soucoupe_4,soucoupe_5,soucoupe_6,0
 	
	dw		#FFFF



; ///////////////////////////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////////////////////////


; ///////////////////////////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////             LEVEL 8            ///////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////////////////////////

; TBL_TYPE_DE_SOUCOUPE_1

 TBL_TYPE_DE_SOUCOUPE_8
	dw		TypeSoucoupeBleue1zv,TypeSoucoupeViolette2dvb,TypeSoucoupeBleue3dvb,TypeSoucoupeViolette4b,TypeSoucoupeViolette5b,TypeSoucoupeVerte6t
	dw		TypeSoucoupeVerte1t,TypeSoucoupeBleue2b,TypeSoucoupeBleue3dvb,TypeSoucoupeBleue4dvb,TypeSoucoupeBleue5b,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeBleue1zv,TypeSoucoupeVerte2t,TypeSoucoupeViolette3hvb,TypeSoucoupeViolette4b,TypeSoucoupeBleue5zv,TypeSoucoupeVerte6t
	dw		TypeSoucoupeViolette1b,TypeSoucoupeBleue2b,TypeSoucoupeViolette3zv,TypeSoucoupeBleue4dvb,TypeSoucoupeBleue5zv,TypeSoucoupeVerte6t
	dw		TypeSoucoupeViolette1b,TypeSoucoupeVerte2t,TypeSoucoupeBleue3hvb,TypeSoucoupeBleue4zv,TypeSoucoupeViolette5hvb,TypeSoucoupeViolette6zv

	dw		TypeSoucoupeViolette1b,TypeSoucoupeVerte2t,TypeSoucoupeBleue3dvb,TypeSoucoupeVerte4t,TypeSoucoupeViolette5zv,TypeSoucoupeViolette6hvb
	dw		TypeSoucoupeViolette1hvb,TypeSoucoupeVerte2t,TypeSoucoupeBleue3dvb,TypeSoucoupeVerte4t,TypeSoucoupeBleue5hvb,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeVerte2t,TypeSoucoupeViolette3b,TypeSoucoupeBleue4dvb,TypeSoucoupeViolette5zv,TypeSoucoupeViolette6dvb
	dw		TypeSoucoupeVerte1t,TypeSoucoupeViolette2hvb,TypeSoucoupeViolette3zv,TypeSoucoupeBleue4dvb,TypeSoucoupeViolette5b,TypeSoucoupeViolette6dvb
	dw		TypeSoucoupeVerte1t,TypeSoucoupeBleue2hvb,TypeSoucoupeBleue3dvb,TypeSoucoupeViolette4b,TypeSoucoupeViolette5zv,TypeSoucoupeVerte6t
	dw		TypeSoucoupeViolette1hvb,TypeSoucoupeViolette2b,TypeSoucoupeBleue3zv,TypeSoucoupeViolette4b,TypeSoucoupeViolette5hvb,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeVerte1t,TypeSoucoupeBleue2zv,TypeSoucoupeBleue3dvb,TypeSoucoupeBleue4dvb,TypeSoucoupeViolette5dvb,TypeSoucoupeViolette6hvb

	dw		TypeSoucoupeVerte1t,TypeSoucoupeBleue2hvb,TypeSoucoupeViolette3zv,TypeSoucoupeVerte4t,TypeSoucoupeViolette5b,TypeSoucoupeViolette6dvb
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeViolette2zv,TypeSoucoupeVerte3t,TypeSoucoupeViolette4b,TypeSoucoupeViolette5zv,TypeSoucoupeVerte6t
	dw		TypeSoucoupeViolette1hvb,TypeSoucoupeVerte2t,TypeSoucoupeViolette3zv,TypeSoucoupeViolette4b,TypeSoucoupeBleue5zv,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeVerte1t,TypeSoucoupeViolette2b,TypeSoucoupeViolette3zv,TypeSoucoupeViolette4b,TypeSoucoupeViolette5zv,TypeSoucoupeViolette6zv

	dw		TypeSoucoupeVerte1t,TypeSoucoupeViolette2b,TypeSoucoupeViolette3zv,TypeSoucoupeViolette4b,TypeSoucoupeViolette5zv,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeBleue1b,TypeSoucoupeVerte2t,TypeSoucoupeViolette3dvb,TypeSoucoupeBleue4dvb,TypeSoucoupeVerte5t,TypeSoucoupeViolette6dvb
	dw		TypeSoucoupeViolette1hvb, TypeSoucoupeBleue2b,TypeSoucoupeVerte3t,TypeSoucoupeBleue4hvb,TypeSoucoupeViolette5zv,TypeSoucoupeVerte6t

	dw		TypeSoucoupeBleue1zv,TypeSoucoupeViolette2zv,TypeSoucoupeViolette3b,TypeSoucoupeViolette4dvb,TypeSoucoupeViolette5zv,TypeSoucoupeVerte6t
	dw		TypeSoucoupeViolette1dvb,TypeSoucoupeViolette2hvb,TypeSoucoupeBleue3dvb,TypeSoucoupeBleue4dvb,TypeSoucoupeViolette5dvb,TypeSoucoupeViolette6hvb
	dw		TypeSoucoupeViolette1b,TypeSoucoupeViolette2dvb,TypeSoucoupeBleue3b,TypeSoucoupeBleue4dvb,TypeSoucoupeViolette5dvb,TypeSoucoupeViolette6dvb
	dw		TypeSoucoupeViolette1hvb,TypeSoucoupeViolette2hvb,TypeSoucoupeBleue3dvb,TypeSoucoupeVerte4t,TypeSoucoupeViolette5hvb,TypeSoucoupeViolette6dvb
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeViolette2b,TypeSoucoupeViolette3b,TypeSoucoupeVerte4t,TypeSoucoupeViolette5hvb,TypeSoucoupeViolette6dvb

	dw		TypeSoucoupeBleue1zv,TypeSoucoupeViolette2hvb,TypeSoucoupeViolette3zv,TypeSoucoupeBleue4dvb,TypeSoucoupeViolette5b,TypeSoucoupeViolette6dvb
	dw		TypeSoucoupeVerte1t,TypeSoucoupeBleue2hvb,TypeSoucoupeBleue3dvb,TypeSoucoupeViolette4b,TypeSoucoupeViolette5zv,TypeSoucoupeVerte6t
	
	dw		TypeSoucoupeVerte1t,TypeSoucoupeViolette2b,TypeSoucoupeViolette3dvb,TypeSoucoupeBleue4dvb,TypeSoucoupeViolette5zv,TypeSoucoupeViolette6hvb
	dw		TypeSoucoupeBleue1zv,TypeSoucoupeVerte2t,TypeSoucoupeBleue3dvb,TypeSoucoupeViolette4b,TypeSoucoupeViolette5hvb,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeVerte2t,TypeSoucoupeViolette3b,TypeSoucoupeViolette4dvb,TypeSoucoupeViolette5zv,TypeSoucoupeVerte6t
	dw		TypeSoucoupeViolette1hvb,TypeSoucoupeBleue2hvb,TypeSoucoupeViolette3zv,TypeSoucoupeVerte4t,TypeSoucoupeViolette5b,TypeSoucoupeVerte6t
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeViolette2zv,TypeSoucoupeVerte3t,TypeSoucoupeViolette4b,TypeSoucoupeViolette5zv,TypeSoucoupeVerte6t
	dw		TypeSoucoupeViolette1hvb,TypeSoucoupeVerte2t,TypeSoucoupeViolette3zv,TypeSoucoupeViolette4b,TypeSoucoupeBleue5zv,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeVerte1t,TypeSoucoupeViolette2b,TypeSoucoupeViolette3zv,TypeSoucoupeViolette4b,TypeSoucoupeViolette5zv,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeVerte1t,TypeSoucoupeViolette2b,TypeSoucoupeViolette3zv,TypeSoucoupeViolette4hvb,TypeSoucoupeVerte5t,TypeSoucoupeViolette6zv
	dw		TypeSoucoupeViolette1zv,TypeSoucoupeVerte2t,TypeSoucoupeBleue3dvb,TypeSoucoupeViolette4zv,TypeSoucoupeVerte5t,TypeSoucoupeViolette6zv



; TBL_NBR_SOUCOUPES

 TBL_NBR_SOUCOUPES8
	dw		vague1s,vague1e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague2s,vague2e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague3s,vague3e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague4s,vague4e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague5s,vague5e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0

 	dw		vague6s,vague6e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague7s,vague7e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague8s,vague8e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague9s,vague9e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague10s,vague10e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague11s,vague11e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague12s,vague12e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0

	dw		vague13s,vague13e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague14s,vague14e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague15s,vague15e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague16s,vague16e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0

	dw		vague17s,vague17e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague18s,vague18e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague19s,vague19e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0

 	dw		vague20s,vague20e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague21s,vague21e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague22s,vague22e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague23s,vague23e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague24s,vague24e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0

	dw		vague25s,vague25e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague26s,vague26e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
	
 	dw		vague27s,vague27e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague28s,vague28e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague29s,vague29e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague30s,vague30e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague31s,vague31e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague32s,vague32e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague33s,vague33e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague34s,vague34e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague35s,vague35e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
 	dw		vague36s,vague36e,soucoupe_1,soucoupe_2,soucoupe_3,soucoupe_4,soucoupe_5,soucoupe_6,0
	dw		#FFFF

; ///////////////////////////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////////////////////////
