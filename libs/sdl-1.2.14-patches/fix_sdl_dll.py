"""Repairs an E32 DLL whose initialised data had its export table added onto it
(seen in sdl.dll built with the S60 3rd FP1 GCCE toolchain).
Usage: python fix_sdl_dll.py sdl.dll   -> writes sdl.dll in place, keeps sdl.dll.bak
Run it only once per freshly built DLL."""
import struct, sys, shutil

fn = sys.argv[1]
d = bytearray(open(fn, 'rb').read())
if d[16:20] != b'EPOC':
    sys.exit('not an E32 image')
h = struct.unpack_from('<25I', d, 0x14)
comp, datasz, expdir, expcount, dataoff = h[2], h[8], h[17], h[18], h[21]
if comp != 0:
    sys.exit('compressed image, not handled')
n = min(datasz // 4, expcount)
if n == 0:
    sys.exit('nothing to fix (no data or no exports)')
# sanity check: after the fix, SDL_CPUFeatures (data word 1) must be 0xFFFFFFFF
w1 = (struct.unpack_from('<I', d, dataoff + 4)[0] - struct.unpack_from('<I', d, expdir + 4)[0]) & 0xffffffff
if w1 != 0xffffffff:
    sys.exit('data does not look broken in the expected way (already fixed?), nothing changed')
shutil.copyfile(fn, fn + '.bak')
for i in range(n):
    v = struct.unpack_from('<I', d, dataoff + 4*i)[0]
    e = struct.unpack_from('<I', d, expdir + 4*i)[0]
    struct.pack_into('<I', d, dataoff + 4*i, (v - e) & 0xffffffff)
open(fn, 'wb').write(d)
print('fixed %d data words in %s' % (n, fn))
