#ifndef _STD_DEFINED
#define _STD_DEFINED

#include "config.ch"

#ifdef CLIPPER50_COMPATIBLE
	#include "std50.ch"
#else
	#ifdef FOXPRO_COMPATIBLE
        	// need to done fox.ch
		#include "std53.ch"
                #include "fox.ch"
                #include "foxsql.ch"
        #else
		#include "std53.ch"
        #endif
#endif

#include "clip.ch"
#include "func_ref.ch"
//#include "common.ch"

#endif

