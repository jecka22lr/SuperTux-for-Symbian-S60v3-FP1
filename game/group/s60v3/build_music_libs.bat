@echo off
rem One-time build of libmikmod and SDL_mixer with MOD music, then SuperTux.
rem Full output goes to build_libs_log.txt next to this file.
title Building music libraries + SuperTux
subst S: C:\Symbian\9.2\S60_3rd_FP1 >nul 2>&1
set EPOCROOT=\
set PATH=C:\Perl\bin;S:\epoc32\gcc\bin;S:\epoc32\tools;C:\Program Files (x86)\CSL Arm Toolchain\bin;%PATH%
set LOG=S:\supertux_symbian_src\group\s60v3\build_libs_log.txt
echo ==== started %date% %time% > %LOG%

echo [1/3] Building libmikmod...
cd /d S:\official\libmikmod-3.1.12\symbian
echo ==== libmikmod >> %LOG%
call bldmake bldfiles >> %LOG% 2>&1
call abld export >> %LOG% 2>&1
call abld build gcce urel >> %LOG% 2>&1

echo [2/3] Rebuilding SDL_mixer with MOD music...
cd /d S:\official\SDL_mixer-release-1.2.12\symbian
echo ==== SDL_mixer >> %LOG%
call bldmake bldfiles >> %LOG% 2>&1
call abld reallyclean gcce urel >> %LOG% 2>&1
call abld build gcce urel >> %LOG% 2>&1

echo [3/3] Libraries done:
dir S:\epoc32\release\armv5\urel\mikmod.lib S:\epoc32\release\armv5\urel\sdl_mixer.lib | findstr /i ".lib"
dir S:\epoc32\release\armv5\urel\mikmod.lib S:\epoc32\release\armv5\urel\sdl_mixer.lib >> %LOG% 2>&1
echo ==== finished %date% %time% >> %LOG%
echo.
findstr /i /c:"error:" /c:"] Error" %LOG% > nul
if %errorlevel%==0 (
  echo *** THE LIBRARY BUILD HAD ERRORS. Do not build SuperTux yet. ***
  findstr /i /c:"error:" /c:"] Error" %LOG%
) else (
  echo Libraries OK. Now run build_supertux.bat
)
echo.
echo Full log: %LOG%
pause
