@echo off
rem Assembles a clean GitHub repo folder at S:\supertux-s60v3 from the working folders.
rem Safe to run again: it refreshes the copies. Never copies signing keys or built packages.
title Assembling the GitHub repo folder
subst S: C:\Symbian\9.2\S60_3rd_FP1 >nul 2>&1
set R=S:\supertux-s60v3
if not exist %R% mkdir %R%

echo [1/4] Game source and data...
robocopy S:\supertux_symbian_src %R%\game /E /NFL /NDL /NJH /NJS /XD autom4te.cache TEMPMAKSYSDECOY33 .supertux /XF *.zip *.sis *.sisx *backup* *backup2 *backup3 build_log.txt build_libs_log.txt ABLD.BAT abld *.key *.cer supertux-log.gpe

echo [2/4] libmikmod with Symbian build files...
robocopy S:\official\libmikmod-3.1.12 %R%\libs\libmikmod-3.1.12 /E /NFL /NDL /NJH /NJS /XF ABLD.BAT

echo [3/4] Symbian build files for SDL_mixer, SDL_image, libpng...
robocopy S:\official\SDL_mixer-release-1.2.12\symbian %R%\libs\sdl_mixer-1.2.12-symbian bld.inf sdl_mixer.mmp /NFL /NDL /NJH /NJS
robocopy S:\official\SDL_image-release-1.2.12\symbian %R%\libs\sdl_image-1.2.12-symbian bld.inf sdl_image.mmp /NFL /NDL /NJH /NJS
robocopy S:\official\libpng-libpng12\symbian %R%\libs\libpng-1.2-symbian /E /NFL /NDL /NJH /NJS /XF ABLD.BAT

echo [4/4] SDL 1.2.14 patched files...
robocopy S:\official\SDL-1.2.14\src\main\symbian\EKA2 %R%\libs\sdl-1.2.14-patches sdlexe.cpp /NFL /NDL /NJH /NJS
robocopy S:\official\SDL-1.2.14\EABI %R%\libs\sdl-1.2.14-patches sdlU.DEF /NFL /NDL /NJH /NJS
robocopy S:\official\SDL-1.2.14\include %R%\libs\sdl-1.2.14-patches SDL_config_symbian.h /NFL /NDL /NJH /NJS
robocopy S:\official\SDL-1.2.14\symbian %R%\libs\sdl-1.2.14-patches fix_sdl_dll.py /NFL /NDL /NJH /NJS

echo.
echo Repo folder ready: %R%
echo Checking that no keys or packages slipped in:
dir /s /b %R%\*.key %R%\*.cer %R%\*.sis %R%\*.sisx 2>nul
echo (nothing listed above = good)
pause
