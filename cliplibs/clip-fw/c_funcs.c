#include <clip.h>

#define HIWORD(l)   ((short) (((long) (l) >> 16) & 0xFFFF))
#define LOWORD(l)   ((short) (l))
#define LOBYTE(w)   ((unsigned char) (w))
#define HIBYTE(w)   ((unsigned char) (((short) (w) >> 8) & 0xFF))
#define MAKELONG(a, b)  ((long) (((short) (a)) | ((long) ((short) (b))) << 16))

int
_clip_NLOWORD( ClipMachine * mp)
{
   _clip_retni( mp, LOWORD( _clip_parnl( mp, 1 ) ) );
   return 0;
}

int
_clip_NHIWORD( ClipMachine * mp )
{
   _clip_retni( mp, HIWORD( _clip_parnl( mp, 1 ) ) );
   return 0;
}

int
_clip_NLOBYTE( ClipMachine * mp )
{
   _clip_retni( mp, _clip_parni( mp, 1 ) & 0x00FF );
   return 0;
}

int
_clip_NHIBYTE( ClipMachine * mp )
{
   _clip_retni( mp, ( _clip_parni( mp, 1 ) >> 8 ) & 0x00FF );
   return 0;
}

int
_clip_NMAKELONG( ClipMachine * mp )
{
   _clip_retnl( mp, MAKELONG( ( short int ) _clip_parni( mp, 1 ), ( short int ) _clip_parni( mp, 2 ) ) );
   return 0;
}

