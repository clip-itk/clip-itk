#include <stdio.h>
#include <ctype.h>

int strcasecmp( char _FAR *__s1, char _FAR *__s2 )
{
   while( *__s1 && *__s2 )
      if( toupper(*__s1) != toupper(*__s2) )
         return ( toupper(*__s1) - toupper(*__s2) );
   return ( *__s1 - *__s2 );
}

int strncasecmp( char _FAR *__s1, char _FAR *__s2, int n )
{
   int i;
   for( i=0;i<n;i++,__s1++,__s2++ )
      if( toupper(*__s1) != toupper(*__s2) )
         return ( toupper(*__s1) - toupper(*__s2) );
   return 0;
}
