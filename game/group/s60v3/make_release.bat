@echo off
rem Builds the signed release package SuperTux_0.1.3-s60v3-r1.sisx
rem Run build_supertux.bat first. The signing key lives in S:\supertux_signing and must NEVER go on GitHub.
title SuperTux release package
subst S: C:\Symbian\9.2\S60_3rd_FP1 >nul 2>&1
set EPOCROOT=\
set PATH=C:\Perl\bin;S:\epoc32\gcc\bin;S:\epoc32\tools;C:\Program Files (x86)\CSL Arm Toolchain\bin;%PATH%
set KEYDIR=S:\supertux_signing
set PASS=supertux-s60
set OUTDIR=S:\supertux_release
set NAME=SuperTux_0.1.3-s60v3-r1
cd /d S:\supertux_symbian_src\group\s60v3
if not exist %OUTDIR% mkdir %OUTDIR%

if not exist %KEYDIR%\jecka.cer (
  echo [1/3] Creating your signing key, one time only...
  echo       If it asks you to move the mouse or press keys, do so until it finishes.
  if not exist %KEYDIR% mkdir %KEYDIR%
  makekeys -cert -password %PASS% -len 2048 -dname "CN=Jecka OU=SuperTux S60v3 port CO=PT" %KEYDIR%\jecka.key %KEYDIR%\jecka.cer
) else (
  echo [1/3] Signing key found.
)

echo [2/3] Packing the .sis (with Open C runtimes inside)...
if exist %OUTDIR%\%NAME%.sis del %OUTDIR%\%NAME%.sis
makesis supertux_s60v3.pkg %OUTDIR%\%NAME%.sis

echo [3/3] Signing...
if exist %OUTDIR%\%NAME%.sisx del %OUTDIR%\%NAME%.sisx
signsis %OUTDIR%\%NAME%.sis %OUTDIR%\%NAME%.sisx %KEYDIR%\jecka.cer %KEYDIR%\jecka.key %PASS%
if exist %OUTDIR%\%NAME%.sis del %OUTDIR%\%NAME%.sis

echo.
if exist %OUTDIR%\%NAME%.sisx (
  echo Done. Release file:
  dir %OUTDIR%\%NAME%.sisx | findstr /i "sisx"
  echo It is in %OUTDIR%
) else (
  echo *** Something failed, no .sisx was made. Scroll up for the error. ***
)
pause
