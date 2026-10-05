#!/usr/bin/env bash
# Assemble la cartouche Goldorak avec RASM puis la lance dans ACE-DL.
#
#   ./launcher.sh          -> assemble + ACE-DL en 6128 plus (128 ko)
#   ./launcher.sh 64       -> assemble + ACE-DL en 464 plus / GX4000 (64 ko)
#   ./launcher.sh build    -> assemble seulement, sans lancer l'émulateur
#
# on peut choisir un autre ACE-DL sans toucher au script :
#   ACE_DIR=/chemin/vers/le/dossier/AceDL ./launcher.sh

# on arrête tout à la première erreur (sinon ACE se lance avec l'ancienne cartouche)
set -e

# çà force le path courant à se mettre dans le path du script
cd "$(dirname "$0")"

# RASM : on prend celui du projet (v2.2.3). C'est un binaire Linux malgrè son nom en .exe
# ATTENTION : RASM 3.3 refuse d'assembler PlayerAkg.asm ("an alias name must precede the EQU")
RASM=./rasm.exe

# ACE-DL se trouve là (il a besoin de ses dossiers private/ et media/ à côté de lui)
ACE_DIR=${ACE_DIR:-$HOME/Documents/Developpement/amstrad/Z80/tools/AceTariga}

# le contenu de ma cartouche se trouve là :
SRC=CPR_ROM_Programs/01-CPR_initialisation.asm

# nom de sortie : goldoGX.cpr + goldoGX.sym + goldoGX.rasm (les symboles pour ACE-DL)
NOM=goldoGX

# le binaire du dépôt n'a pas forcément le droit d'exécution
[ -x "$RASM" ] || chmod +x "$RASM"

# les maptiles des routes : chaque .asm devient un .prg qui sera incbin dans la cartouche
for MAP in goldo1 goldo2 goldo3 goldo4 goldo5 goldo6 goldo7 goldo8 goldospace
do
	"$RASM" "CPR_ASSETS/maptiles/$MAP.asm" -ob "CPR_ASSETS/maptiles/$MAP.prg"
done

# la cartouche
#   -sw -sq : export des labels et des EQU (format WinAPE)  -> goldoGX.sym
#   -rasm   : export des super symboles pour ACE-DL          -> goldoGX.rasm
#   -ec     : on garde la casse d'origine des labels
"$RASM" "$SRC" -sw -sq -o "./$NOM" -rasm -ec

echo "Cartouche assemblee : $NOM.cpr"

# la quantité de RAM de la machine émulée
RAM=128
case "$1" in
	build)	exit 0 ;;
	64)		RAM=64 ;;
esac

if [ ! -x "$ACE_DIR/AceDL" ]
then
	echo "ACE-DL introuvable dans : $ACE_DIR"
	echo "relance avec : ACE_DIR=/chemin/vers/AceDL ./launcher.sh"
	exit 1
fi

# ACE-DL cherche ses fichiers dans le dossier courant : on se place chez lui
# et on lui donne la cartouche et les symboles en chemin absolu
PROJET=$(pwd)
cd "$ACE_DIR"

# -crtc 3 : c'est l'ASIC des CPC plus et de la GX4000
./AceDL -crtc 3 -ram "$RAM" "$PROJET/$NOM.cpr" "$PROJET/$NOM.rasm"
