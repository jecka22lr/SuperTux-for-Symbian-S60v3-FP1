# SuperTux 0.1.3 for Symbian S60v3 FP1
A port of SuperTux 0.1.3 for Symbian S60v3 FP1 and later devices. 240x320. Not my own work - only modified it so I could use the dependencies I could not match for the original port to build it. AI ASSISTED - Claude assisted some of the changes in this port to make it work.

# What changed?
Dependencies and libraries:

instead of PIPS 1.3, OpenC (a more modern implementation).

esdl.lib used in the original port was a older static-lib build of Markus Mertama's SDL port for Symbian and it had its own headers. Replaced with SDL 1.2.14 for Symbian, which works differently (sdl.dll+sdlexe.dll app shell)

stlport_s.lib is STLport, a static C++ standard lib. Not in the SDK so it was switched to OpenC++ (libstdcpp).

zlib.lib was a static zlib, now replaced by libz from Open C

sdl_mixer.lib, sdl_image.lib and lpng.lib had to be compiled against esdl’s headers. rebuilt against SDL 1.2.14. since the SDL_mixer I used did not have MOD support built in, libmikmod became another library

Some code - adjusted to the dependencies and libraries I could work with, but the game code itself barely needed changing.

# How to install?
As of release 1.01, you should be able to just install it without needing anything else, as this package is signed properly and OpenC is bundled. Make sure you have enough free space on your phone and/or card for the installer, game itself, and data (like save files).

If you have a Symbian 9.1 device (like the N93), aka S60v3 WITHOUT FeaturePack1 (FP1), you must install the split .sisx files to install the game; due to issues with the OS itself, packages that are too big (like the single .sisx installer) will not install properly on pre-FP1 S60v3. If you have a Symbian 9.2 device like the N82 or N95 (aka S60v3 FP1), you can use the single file installer properly. (Not yet tested on real FP1 device, only emulator and an N93)

# Requirements
I have not tested this on enough devices, but the target is the Nokia N82, N93 and N95 (128MB RAM 8GB), which all share the same important internals (332MHz Dual ARM11 CPU and 3d-accelerated GPU HW rendering.) On the N93, the game must be launched with the screen already set to Landscape mode.

# Issues
Nokia N93 - you MUST set the screen to Landscape mode or else it will display a 70% gray screen overlay and sort of bug out forcing you to restart.
