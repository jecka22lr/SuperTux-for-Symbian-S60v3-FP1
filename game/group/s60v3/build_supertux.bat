@echo off
rem Rebuilds SuperTux and its .sis. Full output goes to build_log.txt next to this file.
title Building SuperTux
subst S: C:\Symbian\9.2\S60_3rd_FP1 >nul 2>&1
set EPOCROOT=\
set PATH=C:\Perl\bin;S:\epoc32\gcc\bin;S:\epoc32\tools;C:\Program Files (x86)\CSL Arm Toolchain\bin;%PATH%
cd /d S:\supertux_symbian_src\group\s60v3
echo ==== build started %date% %time% > build_log.txt

echo [1/4] Preparing build files...
call bldmake bldfiles >> build_log.txt 2>&1

echo [2/4] Compiling SuperTux (this takes a while)...
call abld build gcce urel >> build_log.txt 2>&1

echo [3/4] Making the .sis package...
if exist supertux_s60v3.sis del supertux_s60v3.sis
call makesis supertux_s60v3.pkg >> build_log.txt 2>&1

echo [4/4] Checking results...
echo ==== results >> build_log.txt
dir S:\epoc32\release\gcce\urel\supertux.exe supertux_s60v3.sis >> build_log.txt 2>&1
echo ==== build finished %date% %time% >> build_log.txt
echo.
findstr /i /c:"error:" /c:"] Error" build_log.txt > nul
if %errorlevel%==0 (
  echo *** THE BUILD HAD ERRORS. The game was NOT updated. ***
  echo These lines mention errors:
  findstr /i /c:"error:" /c:"] Error" build_log.txt
) else (
  echo Build OK.
)
echo.
echo Game exe and package (check the times):
dir S:\epoc32\release\gcce\urel\supertux.exe supertux_s60v3.sis | findstr /i "supertux"
echo.
echo Full log: S:\supertux_symbian_src\group\s60v3\build_log.txt
pause
