#!/usr/bin/env python3
# Convertit une planche de sprites (PNG) en sprites hard 16x16 et les écrit dans une bank .spr
#
#   la planche : fond uni, chaque sprite dans un cadre blanc de 36x18 (intérieur 32x16, pixels
#   doublés en largeur comme en mode 0). Les cadres vides sont ignorés.
#
#   voir ce que le script a trouvé, sans rien écrire :
#       python3 Tools/sprites_vers_bank.py planche.png
#   écrire dans une bank (une adresse par sprite, dans l'ordre affiché) :
#       python3 Tools/sprites_vers_bank.py planche.png CPR_ASSETS/sprites_hard/golgoth1.spr F600 F700 ...
#   --force : autorise à écraser une case qui n'est pas vide
#
# Les couleurs sont ramenées à l'encre la plus proche de PALETTE_SPRITE_HARD, lue dans goldoGX.cpr
# (il faut donc avoir assemblé la cartouche). Le fond de la planche devient l'encre 0 (transparente).
import os, struct, sys
from PIL import Image

ICI = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BLANC = (255, 255, 255)

def palette():
    sym = {}
    for l in open(os.path.join(ICI, 'goldoGX.sym'), encoding='latin-1'):
        p = l.split()
        if len(p) >= 2 and p[1].startswith('#'): sym[p[0]] = int(p[1][1:], 16)
    d = open(os.path.join(ICI, 'goldoGX.cpr'), 'rb').read(); i = 12; bank8 = None
    while i < len(d):
        sz = struct.unpack('<I', d[i + 4:i + 8])[0]
        if d[i:i + 4] == b'cb08': bank8 = d[i + 8:i + 8 + sz]
        i += 8 + sz + (sz & 1)
    o = sym['PALETTE_SPRITE_HARD'] - 0xC000
    return [((bank8[o + 2 * k] >> 4) * 17, (bank8[o + 2 * k + 1] & 15) * 17, (bank8[o + 2 * k] & 15) * 17) for k in range(15)]

def cadres(px, w, h):
    """coin haut-gauche de chaque cadre blanc de 36x18"""
    def trait(x, y): return all(px[x + k, y] == BLANC for k in range(36)) and (x == 0 or px[x - 1, y] != BLANC) and (x + 36 >= w or px[x + 36, y] != BLANC)
    out = []
    for y in range(h - 17):
        for x in range(w - 35):
            if trait(x, y) and trait(x, y + 17) and all(px[x, y + k] == BLANC and px[x + 35, y + k] == BLANC for k in range(18)):
                out.append((x, y))
    return out

def main():
    args = [a for a in sys.argv[1:] if a != '--force']; force = '--force' in sys.argv
    if not args: sys.exit(__doc__ or 'usage : sprites_vers_bank.py planche.png [bank.spr adresse...]')
    im = Image.open(args[0]).convert('RGB'); px = im.load(); w, h = im.size
    fond = px[0, 0]; pal = palette(); choisies = {}; sprites = []
    for x0, y0 in cadres(px, w, h):
        octets = bytearray()
        for j in range(16):
            for i in range(16):
                c = px[x0 + 2 + 2 * i, y0 + 1 + j]
                if c == fond: octets.append(0); continue
                k = min(range(15), key=lambda n: sum((a - b) ** 2 for a, b in zip(pal[n], c)))
                choisies[c] = k + 1; octets.append(k + 1)
        if sum(1 for b in octets if b) >= 8: sprites.append(((x0, y0), bytes(octets)))      # un cadre avec moins de 8 pixels est ignoré
    print('%d sprites trouvés dans %s (cadres vides ignorés) :' % (len(sprites), args[0]))
    for n, ((x0, y0), o) in enumerate(sprites):
        print('  sprite %2d : cadre en x=%d y=%d, %d pixels' % (n + 1, x0, y0, sum(1 for b in o if b)))
    print('couleurs de la planche -> encre de PALETTE_SPRITE_HARD :')
    vues = {}
    for c, k in sorted(choisies.items()):
        exact = all(abs(a - b) <= 8 for a, b in zip(pal[k - 1], c))
        print('  %02X%02X%02X -> encre %2d (%X%X%X)%s' % (c + (k,) + tuple(v // 17 for v in pal[k - 1]) + ('' if exact else '   <- couleur approchée',)))
        vues.setdefault(k, []).append(c)
    for k, cs in vues.items():
        if len(cs) > 1: print('  ATTENTION : %d couleurs de la planche tombent sur la même encre %d' % (len(cs), k))
    if len(args) < 2: return
    bank = args[1]; adrs = [int(a.lstrip('#'), 16) for a in args[2:]]
    if len(adrs) != len(sprites): sys.exit('il faut %d adresses, %d données : rien n\'est écrit' % (len(sprites), len(adrs)))
    d = bytearray(open(bank, 'rb').read())
    for a in adrs:
        if a < 0xC000 or a & 0xFF or a - 0xC000 + 256 > len(d): sys.exit('adresse #%04X hors de la bank ou pas sur une case : rien n\'est écrit' % a)
        if any(b & 15 for b in d[a - 0xC000:a - 0xC000 + 256]) and not force: sys.exit('la case #%04X n\'est pas vide (--force pour l\'écraser) : rien n\'est écrit' % a)
    open(bank + '.bak', 'wb').write(d)
    for a, (_, o) in zip(adrs, sprites): d[a - 0xC000:a - 0xC000 + 256] = o
    open(bank, 'wb').write(d)
    print('écrit dans %s (sauvegarde : %s.bak) : %s' % (bank, bank, ' '.join('sprite %d en #%04X' % (n + 1, a) for n, a in enumerate(adrs))))

if __name__ == '__main__':
    main()
