# SuperTux 0.1.3 for Symbian S60 3rd Edition

An unofficial port of [SuperTux](https://www.supertux.org/) 0.1.3 to Symbian S60 3rd Edition (Feature Pack 1, Symbian OS 9.2), built from source with the S60 3rd FP1 SDK. Target hardware is the Nokia N82; it also runs in the EKA2L1 emulator.

This is a fan project. It is not made, endorsed or supported by the SuperTux team.

## Download and install

Grab `SuperTux_0.1.3-s60v3-r1.sisx` from the [Releases](../../releases) page and install it on the phone.

- The package is **self-signed**. On the phone, set *Application manager > Settings > Software installation* to **All** before installing.
- The Nokia Open C / C++ runtimes it needs (PIPS, Open C SSL/zlib, STDCPP 1.6) are embedded and install automatically if missing.
- Self-signed certificates made with the SDK's tools are valid for one year. If installation complains about the certificate, set the phone's date back or grab a re-signed release.
- Game data goes to the memory you choose at install; config and saves live in `C:\Data\SuperTux`.

## Status

Working: graphics (landscape, correct colours and aspect ratio), keypad controls, sound effects, and MOD/XM music through libmikmod.

Known issues:

- In EKA2L1, sound and music play slightly slow, low and choppy. Requesting 22050 Hz or 44100 Hz makes no difference, so it looks like emulator audio; real-hardware results pending.
- The level editor is not included (it needs a mouse).
- The package installs SDL as `sdl.dll` / `sdlexe.dll` in `\sys\bin`. Another app that ships its own `sdl.dll` may conflict with it.

## What was changed

Fixes on top of the earlier unofficial Symbian source of 0.1.3:

- Startup goes through SDL's own app shell (`sdlexe.dll`) with a custom `E32Main` that skips the parameter dialog and focus-stop mode.
- The data path is found at runtime on whichever drive the game was installed to.
- `tile.cpp`: the tile ID was read inside `assert()`, which release builds remove, so every tile got ID -1 and the game wrote out of bounds. Moved out of the assert.
- Screen opened at the phone's native colour depth (16-bit gave wrong colours), with SDL in its normal drawing mode.
- SDL's app shell asks for landscape orientation, so the 320x240 game fills the screen unstretched.
- A failed music load no longer aborts the game.
- Optional debug tracing (`MACRO ST_TRACE` in `supertux.mmp`) writes progress to `trace.txt`.

## Building

You need Windows with:

- S60 3rd Edition FP1 SDK (`C:\Symbian\9.2\S60_3rd_FP1`), mapped to drive `S:` with `subst S: C:\Symbian\9.2\S60_3rd_FP1` (the build tools expect `\epoc32` on the current drive).
- CSL ARM Toolchain (GCCE 3.4.3), ActivePerl 5.6.1.
- Open C/C++ plugin 1.6 for S60 3rd Edition.
- SDL 1.2.14 with its official Symbian build files, SDL_mixer 1.2.12, SDL_image 1.2.12, libpng 1.2.

Expected layout on `S:` (the build scripts use these paths):

```
S:\supertux_symbian_src        <- game\ from this repo
S:\official\SDL-1.2.14
S:\official\SDL_mixer-release-1.2.12   (+ symbian\ from libs\sdl_mixer-1.2.12-symbian)
S:\official\SDL_image-release-1.2.12   (+ symbian\ from libs\sdl_image-1.2.12-symbian)
S:\official\libpng-libpng12            (+ symbian\ from libs\libpng-1.2-symbian)
S:\official\libmikmod-3.1.12           <- libs\libmikmod-3.1.12 from this repo
```

Steps:

1. **SDL 1.2.14.** Apply the files in `libs\sdl-1.2.14-patches` (`sdlexe.cpp` to `src\main\symbian\EKA2`, `sdlU.DEF` to `EABI`, `SDL_config_symbian.h` to `include` and `\epoc32\include\esdl`), then build with `bldmake bldfiles` and `abld build gcce urel` in its `symbian` folder.
2. **Repair `sdl.dll`.** The SDK's `elf2e32` adds the export table onto the DLL's initialised data, which crashes SDL at video start. After every build of `sdl.dll`, run `python fix_sdl_dll.py S:\epoc32\release\gcce\urel\sdl.dll` once. It keeps a `.bak` and refuses to touch an already fixed file.
3. **libpng, SDL_image:** `bldmake bldfiles` and `abld build gcce urel` in each `symbian` folder.
4. **libmikmod and SDL_mixer:** run `game\group\s60v3\build_music_libs.bat`.
5. **The game:** run `game\group\s60v3\build_supertux.bat`. It reports `Build OK` or the errors, and writes `build_log.txt`.
6. **Release package:** `game\group\s60v3\make_release.bat` makes a key on first run (kept in `S:\supertux_signing`, never commit it) and writes the signed `.sisx` to `S:\supertux_release`.

## Licences and credits

- SuperTux 0.1.3: GPL v2 (see `game\COPYING`), by the SuperTux Development Team (see `game\AUTHORS`).
- Earlier unofficial Symbian port of 0.1.3, which this build starts from.
- SDL 1.2 Symbian port by Markus Mertama; SDL, SDL_mixer and SDL_image are LGPL.
- libmikmod 3.1.12: LGPL. libpng: libpng licence.
- Nokia Open C / C++ runtimes are redistributed inside the release package as provided by Nokia for application developers; they are not part of this repository.
- S60v3 port fixes: Jecka.
