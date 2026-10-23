/* libmikmod config for Symbian S60 3rd Edition (Open C), hand written */
#define HAVE_UNISTD_H 1
#define HAVE_FCNTL_H 1
#define HAVE_STRINGS_H 1
#define HAVE_STRCASECMP 1
#define HAVE_STRDUP 1
#define HAVE_STRSTR 1
#define HAVE_SNPRINTF 1
/* no HAVE_PTHREAD: SDL_mixer drives MikMod from one thread */
/* no MIKMOD_DYNAMIC, no sound drivers: only drv_nos is used, SDL_mixer does the output */
#define PACKAGE "libmikmod"
#define VERSION "3.1.12"
