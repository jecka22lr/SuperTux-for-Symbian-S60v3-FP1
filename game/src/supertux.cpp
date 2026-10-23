//  $Id: supertux.cpp 997 2004-05-05 16:07:20Z rmcruz $
// 
//  SuperTux
//  Copyright (C) 2004 Tobias Glaesser <tobi.web@gmx.de>
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
// 
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
//  02111-1307, USA.

#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <ctype.h>

#include "defines.h"
#include "globals.h"
#include "setup.h"
#include "intro.h"
#include "title.h"
#include "gameloop.h"
#include "leveleditor.h"
#include "screen.h"
#include "worldmap.h"
#include "resources.h"
#include "texture.h"
#include "tile.h"

FILE* mystdout;
FILE* mystderr;

// Add this global variable back for setup.cpp
char KResourceDir[256];

#if defined(__SYMBIAN32__) && defined(ST_TRACE)
/* debug tracing: add MACRO ST_TRACE to supertux.mmp to enable */
static void TRACE(const char* msg)
{
	const char* paths[] = { "c:\\data\\supertux\\trace.txt", "c:\\data\\trace.txt", "e:\\trace.txt", "c:\\trace.txt", 0 };
	for (int i = 0; paths[i]; i++)
	{
		FILE* f = fopen(paths[i], "a");
		if (f) { fprintf(f, "%s\n", msg); fflush(f); fclose(f); }
	}
}
struct StartupTrace { StartupTrace() { TRACE("static init: exe loaded"); } };
static StartupTrace g_startup_trace;
#else
#define TRACE(x)
#endif

#ifdef __SYMBIAN32__
#include <e32std.h>
#include <eikstart.h>
#include <sdlepocapi.h>

class MSDLMainObs;
// Exported by sdlexe.dll; declared here because the SDK ships no header for it
class SDLEnv
{
public:
	IMPORT_C static TInt SetMain(const TMainFunc& aFunc, TInt aFlags, MSDLMainObs* aObs, TInt aEnvFlags);
};

// Our own entry point (replaces the one in sdlmain.lib). Compared with the
// default it does not ask for the "Enter parameters" dialog, the virtual
// mouse, or pausing the game thread when the window is not in front.
GLDEF_C TInt E32Main()
{
	TRACE("E32Main");
	return SDLEnv::SetMain(TMainFunc(SDL_main), CSDL::EAllowImageResize, NULL, 0);
}
#endif

int main(int argc, char * argv[])
{
	TRACE("main: start");
#ifdef UIQ3
	mystdout = fopen("c:\\shared\\supertux\\stdout.txt","wb");
	mystderr = fopen("c:\\shared\\supertux\\stderr.txt","wb");
#else
	mystdout = fopen("c:\\data\\supertux\\stdout.txt","wb");
	mystderr = fopen("c:\\data\\supertux\\stderr.txt","wb");
#endif
	*stdout = *mystdout;
	*stderr = *mystderr;
#ifdef __SYMBIAN32__
	{
		// Data is installed to <drive>:\resource\apps\supertux, find the drive
		const char drives[] = "cefdz";
		strcpy(KResourceDir, "c:\\resource\\apps\\supertux");
		for (int i = 0; drives[i]; i++)
		{
			char probe[256];
			sprintf(probe, "%c:\\resource\\apps\\supertux\\images", drives[i]);
			if (access(probe, F_OK) == 0)
			{
				sprintf(KResourceDir, "%c:\\resource\\apps\\supertux", drives[i]);
				break;
			}
		}
		setenv("HOME", "c:\\data", 1);
		printf("KResourceDir: %s\n", KResourceDir);
		TRACE(KResourceDir);
		fflush(stdout);
	}
#endif
  TRACE("before st_directory_setup");
  st_directory_setup();
  TRACE("after st_directory_setup");
  parseargs(argc, argv);
  TRACE("after parseargs");
  
  st_audio_setup();
  TRACE("after st_audio_setup");
  st_video_setup();
  TRACE("after st_video_setup");
  st_joystick_setup();
  TRACE("after st_joystick_setup");
  st_general_setup();
  TRACE("after st_general_setup");
  st_menu();
  TRACE("after st_menu");
  loadshared();
  TRACE("after loadshared");
#if !defined GP2X && !defined __SYMBIAN32__
  if (launch_leveleditor_mode && level_startup_file)
    {
    leveleditor(level_startup_file);
  } else 
#endif
  if (level_startup_file)
    {
      GameSession session(level_startup_file, 1, ST_GL_LOAD_LEVEL_FILE);
      session.run();
    }
  else
    {  
      TRACE("calling title");
      title();
      TRACE("title returned");
    }
  
  clearscreen(0, 0, 0);
  updatescreen();

  unloadshared();
  st_general_free();
  TileManager::destroy_instance();
#ifdef DEBUG
  Surface::debug_check();
#endif
  st_shutdown();
  
  return 0;
}