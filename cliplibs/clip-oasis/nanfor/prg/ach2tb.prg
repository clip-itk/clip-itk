/*
 * File......: ACH2TB.PRG
 * Author....: Steve Kolterman
 * CIS ID....: 76320,37
 * Date......: $Date$
 * Revision..: $Revision$
 * Log file..: $Logfile:   C:/nanfor/src/ach2tb.prv  $
 *
 * This is an original work by Steve Kolterman and is placed in the
 * public domain.
 *
 * Modification history:
 * ---------------------
 *
 * $Log$
 * Revision 1.1  2006/06/22 20:12:11  itk
 * uri: init sf.net
 *
 * Revision 1.2  2003/04/26 09:31:42  clip
 * uri: small fix
 *
 * Revision 1.1  2003/04/26 09:29:33  clip
 * uri: add
 *
 *
 *    Rev 1.4   17 Oct 1992 16:26:12   GLENN
 * Leo cleaned up the documentation block.
 *
 *    Rev 1.3   07 Oct 1992 23:31:10   GLENN
 * Latest Kolterman updates.
 *
 *    Rev 1.2   15 Aug 1991 23:17:48   GLENN
 * Last minute fix sent in by Steve Kolterman
 *
 *    Rev 1.1   15 Aug 1991 23:06:16   GLENN
 * Forest Belt proofread/edited/cleaned up doc
 *
 *    Rev 1.0   14 Jun 1991 04:14:14   GLENN
 * Initial revision.
 *
 */

/*  $DOC$
 *  $FUNCNAME$
 *     FT_Ach2tb()
 *  $CATEGORY$
 *     Menus/Prompts
 *  $ONELINER$
 *     Replace ACHOICE() with a Tbrowse object & multiple features.
 *  $SYNTAX$
 *     FT_Ach2tb( <nToprow>,<nTopcol>[,<nBotrow>][,<nBotcol>],<aArrey>,     ;
 *           [<cBoxtype>],[<cBoxcolor>],[<cBoxtitle>],[<nTitlePos>],        ;
 *           [<cUselcolor>],[<cTitlecolor>],[<cBarcolor>],[<cHkcolor>],     ;
 *           [<lShadow>],[<lExecute>],[<nMsgrow>],[<nMsgcol>],              ;
 *           [<cMsg.color>],[cElevbar],[cEbarcolor],[<cEbarside>],          ;
 *           [<cNoSelcolor>],[<cTagch>],[<nStartelem>],[<lRscreen>],        ;
 *           [<nTimeout>],[<nTimeoutval>],[<cUserfunc>] )
 *      --> nOption
 *
 *  $ARGUMENTS$
 *
 *  <nToprow>   is the top row of the box to be drawn.  Required.
 *
 *  <nTopcol>   is the top column of the box to be drawn.  Required.
 *
 *  <nBotrow>   is the bottom row of the box to be drawn.  The default is
 *     <nToprow>+Len(<aArrey>)+1 or maxrow()-2, whichever is less.
 *
 *  <nBotcol>   is the bottom column of the box to be drawn.  The default
 *     is <nTopcol>+width of the widest element in <aArrey> +2.
 *
 *     It's been pointed out that the number of commas required to default
 *     the <nBotrow> and <nBotcol> params. is at least slightly confusing.
 *     So, some documentation on the requirements:
 *     Default both:                           7,9,,   ARRAY:
 *     Default <nBotrow>, specify <nBotcol>:   7,9,,20 ARRAY:
 *     Default <nBotcol>, specify <nBotrow>:   7,9,15, ARRAY:
 *
 *  <aArrey>    is the arrey of options to present to the user.  Each
 *     element can hold as many as five subelements, or as few as one.
 *     Required.  Additional documentation below.
 *
 *  <cnBoxtype> is the type of box to draw.  Uses DispBox().  The
 *     default is a double-line box.
 *
 *  <cBoxcolor> is the color with which to draw the box.  The default is
 *     Setcolor().
 *
 *  <cBoxtitle> is title of the box drawn on <nToprow>.  The default is
 *     no title.
 *
 *  <nTitlepos>  is the starting column position (to the right of
 *     <nTopcol>) at which to draw <cBoxtitle>.  The default is 1.
 *
 *  <cUselcolor> is the color with which to draw unselected options.
 *     The default is Setcolor().
 *
 *  <cTitlecolor> is the color with which to draw the box title.  The
 *     default is yellow on red.
 *
 *  <cBarcolor>  is the color with which to draw the selection bar.
 *     The default is yellow on black.
 *
 *  <cHkcolor>  is the default color with which to draw the hotkeys for
 *     for each option.  This is used when no hotkey color is supplied
 *     in <aArrey>.  The default is hiwhite on the current background
 *     color.
 *
 *  <cShadow>   is a character string, either "L" or "R" (for left or
 *     right) to designate the side of the box where a shadow will appear.
 *     Leave this NIL to avoid drawing a shadow.  You might also leave
 *     this NIL if you choose to use a .C or .ASM shadow function, which
 *     is a good idea.  Shadoww(), included below, is flat-out SLOW.
 *
 *  <lExecute>  turn on/off execution of option when first letter is
 *     pressed.  Rule:  setting in element 5 of each <aArrey> subarray
 *     overrides <lexecute>.  If that element is left NIL, the <lexecute>
 *     setting is used.  If <lexecute> is not passed and element 5 is NIL,
 *     auto execution is turned ON.
 *
 *  <nMsgrow>  is the row on which to draw a message for each option.
 *     The default is two rows below the bottom of the box.
 *
 *  <nMsgcol>  is the column at which to draw a message for each option.
 *     The default is <nTopcol> +2.  To CENTER the message, pass "C".
 *
 *  <cMsgcolor>  is the default color with which to draw messages.  This
 *     color is used when element 4 of each <aArrey> subarray is left NIL.
 *     The default is Setcolor().
 *
 *  <cElevbar>  is the ASCII character to use as the elevator bar drawn
 *     on the box.  Leave this NIL to draw no elevator bar.
 *
 *  <cEbarcolor>  is the color with which to draw the elevator bar.
 *     This is ignored if <cElevbar> is NIL.
 *
 *  <cEbarside>  is a character string, either "L" or "R" (for left or
 *     right) to designate the side of the box on which to draw the
 *     elevator bar.  This is ignored if <cElevbar> is NIL.
 *
 *  <cNoselcolor>  is the color with which to draw unselectable options.
 *     The default is white on black.
 *
 *  <cTagchar> is the ASCII character to use to draw tags that would
 *     appear to the right of each option.  The default is *DIS*abled
 *     tagging.  The default tag is "û" (chr(251)).
 *
 *  <nStartelem>  is the number of the option where the selection bar
 *     will first be placed.  Leave this NIL to begin at option 1.
 *
 *  <lRestscrn>  is a logical to designate whether or not the screen
 *     coordinates occupied by the box and/or shadow should be restored
 *     before FT_Ach2tb() returns.  The default is .T.
 *
 *  <nTimeout>  is the number of seconds after which FT_ACH2TB() will
 *     timeout and return to the function/proced. which called it.  The
 *     default is 0.
 *
 *  <nTimeoutVal> is an optional alternative numeric value FT_ACH2TB() will
 *     RETURN when/if it times out.  The default is the current element
 *     number.
 *
 *  <bUserfunc>  is a code block containing a function call to be
 *     executed after each key press.  You need to write just two formal
 *     parameters to allow the run-time passing of the key pressed and the
 *     current element number, e.g.:
 *               { |key,num| Myfunc( key,num [,other params.] ) }
 *     Unlimited extra parameters may be passed.  Of course, make certain
 *     to also write 'receptors' for them in 'Myfunc()' itself...as in the
 *     above example.  The default is NO user function.
 *
 *  $RETURNS$
 *     the number of the selected option, or 0 if [Esc] is pressed.
 *
 *  $DESCRIPTION$
 *     FT_Ach2tb() is a greatly enhanced, fully featured, and now mouse-
 *     supported replacement for Achoice(), based on a Tbrowse object.
 *     Each element of <aArray> (the array you pass to it) is itself an
 *     array.  Each element can solely composed of "Option" (below), but
 *     may be composed as follows to take full advantage of the function's
 *     features:
 *
 *         Option   ,     Message      ,HotKeyPos,HotKeyColor,Selectable
 *     { "Utilities","System Utilities", 3       ,"+gr/b"    ,.T. }
 *
 *     All elements except for the first, the option itself, are optional.
 *     IF 'Message' is NIL, no message is displayed.  'HotKeyPos' is the
 *     position within 'Option' of the hotkey.  In the example above, the
 *     hotkey for 'Utilities' is the first 'i', i.e., at position 3.  The
 *     default is 1.  'HotKeyColor' is the color to use for the hotkey
 *     display.  The default is hiwhite  on the current background color.
 *     'Selectable' is a logical indicating whether or not that option can
 *     be selected.  The default is .T.
 *
 *     The A_CHOICE() UDC in FT_ACH2T.CH makes using FT_ACH2TB() a breeze.
 *     The myriad of parameters can be written in any order.  Only <nToprow>,
 *     <nTopcol>, and <aArrey> are required.  See the example below.
 *
 *     There may be some confusion over 'unselected' and 'unselectable'
 *     options.  The former refers to any option not currently covered
 *     by the selection bar.  The latter refers to options you have
 *     designated unselectable in subelement 5 of <aArray>, i.e., by
 *     writing .F.
 *
 *     To enable tagging, pass any ASCII character as <cTagchar>.  To
 *     tag/untag all options, press [SPACE].  To tag/untag individual
 *     options, press [+] and [-] respectively.  On press of [+], browse
 *     moves to the next element in the display.  To test for the tagged
 *     status of an option, use the WAS_TAGGED() UDC in FT_ACH2T.CH. To
 *     check the entire array for tags, use Aeval() in conjunction with
 *     Was_Tagged() as in the example below.  When tagging is enabled, the
 *     string "Tags" will be written across the bottom row of the box in
 *     hiwhite on the current background color.
 *
 *     Because FT_ACH2TB() takes over the [SPACE],[+], and [-] keys, it saves
 *     any SET KEY procedures you might have set them to, and restores same
 *     on returning.  Any other procedures you might have SET KEYs to will
 *     fly when FT_ACH2TB() is called...thanks to the Inkey() replacement,
 *     SKINkey().
 *
 *     The pi‚ce de resistance of FT_ACH2TB() is its ability to execute
 *     a user function designed entirely by you.  It is called after each
 *     keypress, and because it is completely open-ended, extends the
 *     the reach of FT_ACH2TB() to the limits of Clipper.  See the docu-
 *     mentation under <bUserfunc> above.
 *
 *
 *     Test compile:  CLIPPER ft_ach2t /n/w/m/dFT_TEST
 *     Test link   :  RTLINK FI ft_ach2t LIB nanfor /pll:base50
 *
 *
 *     Mouse support
 *     =============
 *     Mouse support is provided via the Nanforum Toolkit FT_M* functions.
 *     Most actions are tied to the left button.  The equivalent of pressing
 *     [Esc] comes via the right button.  These left button clicks will
 *     produce the designated actions:
 *
 *     Mouse cursor outside box                :  K_ENTER (select option)
 *     Mouse cursor at box top left corner     :  browse:goTop()
 *                         bottom left corner  :  browse:goBottom()
 *                         top right corner    :  browse:pageUp()
 *                         bottom right corner :  browse:pageDown()
 *
 *     Mouse cursor at option, tagging ENabled
 *     --------------------------------------------
 *     Selection bar moves to option, subsequent press to tag or untag.  Do
 *     this for as many options as you want to tag/untag, then move mouse
 *     cursor outside the box.  Press again to select.  Tagging overrides
 *     <lExecute>, so with tagging on and <lExecute> .F., subsequent presses
 *     while inside the box coordinates simply tag/untag.
 *
 *     Mouse cursor at option, tagging DISabled
 *     ---------------------------------------------
 *     IF <lExecute> is turned on, the option is immediately selected.  If
 *     turned off, selection bar moves to option.  Press again to select.
 *
 *     To Disable Mouse Support
 *     ------------------------
 *     Compile with /dNOMOUSE
 *
 *
 *  $EXAMPLES$
 *  nOpt := A_CHOICE( 7,9,, ARRAY:t_array )   // the minimum
 *
 *  nOpt := A_CHOICE( 7,9,, ;
 *            ARRAY:t_arrey ;
 *            USERFUNC:{|a,b| UserFunc(a,b,any1)};
 *            BOXTYPE:B_SINGLE  ;
 *            BOXTITLE:title  ;
 *            SHADOW:"FT" ;
 *            TAGCHAR:chr(17) ;
 *            REST_SCREEN:.F. ;
 *            AUTOEXEC:.F. ;
 *            MES_COLOR:MSG_COLOR ;
 *            ELEVBAR:"±" ;
 *            NOSELCOLOR:"bg/n" ;
 *            MES_COL:"C" )
 *
 *  Check only the RETURNed element for whether tagged:
 *  IF( Was_Tagged(chr(17),t_arrey,nOpt), MoreProcessing(), )
 *
 *  Check entire 't_arrey':
 *  Aeval( t_arrey,{|e,n| IF( Was_Tagged(chr(17),t_arrey,n ), ;
 *                            MoreProcessing(t_arrey),NIL ) } )
 *
 *
 *  $END$
 */

#include "inkey.ch"
#include "box.ch"
#include "setcurs.ch"
#include "ft_ach2t.ch"

#define KEY_ELEM         1
#define BLK_ELEM         2
#define AOPT             1
#define AMSG             2
#define AHOT             3
#define ACLR             4
#define ASEL             5
#define OUTTA_TIME       999
#define TIMED_OUT        (lkey==OUTTA_TIME)
#define HOTKEY_PRESS     (aelem > 0)
#define METHOD_PRESS     (meth_num > 0 .and. meth_num <= 10)
#define TAGS             (tagchar<>NIL)
#define TAG_PRESS        (TAGS .and. (meth_num > 11))
#define CONTINUING       (lkey <> K_ESC)
#define OUTTA_HERE       EXIT
#define ATTOP            (aindex==1)
#define ATBOTT           (aindex==Len(arrey))
#define USEL_COLOR       FG(Setcolor())+"/"+BG(Setcolor())
#define BARCOLOR         if(iscolor(),"+gr/n","n/w")
#define TITLECOLOR       if(iscolor(),"+gr/r","n/w")
#define DEMOCOLOR        if(iscolor(),"+gr/b","+w/n")
#define HK_COLOR         if(iscolor(),"w+/"+ BG(setcolor()),"w+/n")
#define SELECTABLE       (if(len(arrey[aindex])==5 .and. arrey[aindex][5]<> NIL,;
			 arrey[aindex][5],aexec))
#define NOSELECT         (len(arrey[aindex])==5 .and. !(arrey[aindex][5]))
#define DEFAULT_TAG      "û"
#define UP_ARROW_POS     t+2,col4bar
#define DN_ARROW_POS     b-2,col4bar
#define UP_ARROW         if(top_elem > 1,chr(24),chr(25))
#define DN_ARROW         if(bot_elem < num_elems,chr(25),chr(24))
#define GOING_UP         (meth_num==10 .or. Ltrim(str(meth_num)) $ "2468")
#define GOING_DOWN       (Ltrim(str(meth_num)) $ "13579")
#define MESG_LEN         aMsgdata[1]
#define MESG_COL         aMsgdata[2]

#xtranslate DISPMSG(<r>,<c>,<msg>[,<color>])           => ;
	    SetPos(<r>,<c>); DispOut(<msg>[,<color>])
#translate  Clear([<t>,<l>,<b>,<r>])                   => ;
	    SCROLL([<t>,<l>,<b>,<r>])
#command    DEFAULT <p> TO <val> [,<pn> TO <valn>]     => ;
	    IF( <p> == NIL, <p> := <val>, ) ;
	    [; IF( <pn> == NIL, <pn> := <valn>,) ]
#command    STABILIZE <o> => WHILE !<o>:stabilize() ; ENDDO

#ifndef K_SPACEBAR
#define K_SPACEBAR 32
#endif
#ifndef K_PLUS
#define K_PLUS  43
#define K_MINUS 45
#endif

STATIC aMsgData[2],aSaveArr:= {},oSaveobj

#ifdef FT_TEST

Function Main( passes )

//                 Item       Msg         HotKeyPos/HotkeyColor/Selectable
LOCAL t_arrey:= { {"Larry"   ,"larry"    ,   ,"w+/b"          },;
		  {"Dick"    ,"dick"     ,   ,"b/r"           },;
		  {"Harry"   ,           ,  3,       ,.F.     },;
		  {"Steve"   ,"steve"    ,  4,"g/bg"          },;
		  {"Michelle","michelle"                      },;
		  {"Barnabas",           ,  6,"gr+/w"         },;
		  {"Fred"    ,"fred"                          },;
		  {"Lisa"    ,"lisa"     ,  3,"n/r"           },;
		  {"Eleanor" ,"eleanor"  ,  4,"bg/r"          },;
		  {"Anthony" ,"anthony"  ,  3                 },;
		  {"Charles" ,"charles"  ,   ,       ,.F.     },;
		  {"Ollie"   ,"ollie"    ,  4,"r/w"           },;
		  {"George"  ,           ,  5                 },;
		  {"Paula"   ,"paula"                         },;
		  {"Jack"    ,"jack"     ,  4                 },;
		  {"Quinten" ,"quinten"                       },;
		  {"Nancy"   ,"nancy"    ,  5,"w/n"           },;
		  {"Warren"  ,"warren"   ,  1,"n/gr*"         } }
LOCAL t_arrey2:= {{"Warren"  ,"warren"   ,   ,"w+/b"          },;
		  {"Charles" ,"charles"                       },;
		  {"Ollie"   ,"ollie"    ,  4,"r/w"           },;
		  {"George"  ,           ,  5                 },;
		  {"Paula"   ,"paula"    ,  3,"gr+/bg"        },;
		  {"Harry"   ,           ,  3,       ,.F.     },;
		  {"Michelle","michelle" ,   ,"gr+/gr"        },;
		  {"Anthony" ,"anthony"  ,  2                 } }


LOCAL title:= " SK Test ",ret1,xx,o_color:= Setcolor( DEMOCOLOR ),o_blink
LOCAL any1:= "User function called!",ret2
LOCAL any2:= "User function2 called!"

DEFAULT passes to 3; passes:= IF(valtype(passes)=="C",val(passes),passes)

Clear()

o_blink:= SetBlink(.F.)
#ifndef NOMOUSE
 FT_MReset() ; FT_MCursor(.T.)
#endif

FOR xx:= 1 to passes
  ret1:= A_CHOICE( 7,9,, ARRAY:t_arrey TITLEPOS:2 START_ELEM:ret1 ;
	   USERFUNC:{|a,b| UserFunc(a,b,any1,.F.,1,.T.)} ;
	   BOXTYPE:B_SINGLE  BOXTITLE:title  SHADOW:"FT" TAGCHAR:chr(17);
	   REST_SCREEN:.F. AUTOEXEC:.F. MES_COLOR:"+w/b" ELEVBAR:"±" )
  @ 1,0 say "Returned element "+Ltrim(str(ret1))+" "
  IF ret1 > 0
     @ 2,0 say "That was "+IF( Was_Tagged(chr(17),t_arrey,ret1) ,;
	       "a Tagged","an UNtagged")+"  element  "
  ENDIF
  @ 3,0 say "Press, Please "; inkey(0)
  Clear()
  ret2:= A_CHOICE( 5,9,20,40 ARRAY:t_arrey2  BOXTYPE:B_DOUBLE ELEVBAR:"°" ;
	    BOXTITLE:" SK Test2 " AUTOEXEC:.T. ELEVBAR_COLOR:"+w/r" ;
	    MES_COLOR:"+w/gr" USERFUNC:{|a,b| UserFunc(a,b,any2,.T.,3,.F.,4)} ;
	    REST_SCREEN:.F. ELEVBAR_SIDE:"R" TIME_OUT:4 MES_COL:"C" ;
	    START_ELEM:3 SHADOW:"L" BAR_COLOR:"+r/gr*" TIME_OUT VALUE:-999 )

  @ 1,0 say "Returned element "+Ltrim(str(ret2))+" "
  IF ret2 > 0
    @ 2,0 say "That was "+IF( Was_Tagged(DEFAULT_TAG,t_arrey2,ret2) ,;
	       "a Tagged","an UNtagged")+"  element  "
  ENDIF
  @ 3,0 say "Press, Please "; inkey(0)
  Clear()

NEXT

SetBlink(o_blink)
QUIT
RETURN NIL

#endif

FUNCTION FT_Ach2tb( t,l,b,r,arrey,boxtp,boxcolor,boxttl,ttlpos,uselcolor,;
	 ttlcolor,barcolor,hkcolor,shad,aexec,msg_row,msg_col,msg_color,;
	 ebar,ebarcolor,ebarside,noselcolor,tagchar,start_elem,r_screen,;
	 timeout,timeout_val,u_func )

LOCAL o_curs,lkey:= 0,meth_num:= 0,num_elems:= Len(arrey),ach_scrn,;
      o_color,aelem:= 0,ex_req:= .F.,uf_cont:= .T.,top_elem,bot_elem,;
      dm_color,o_blink,first_entry:= .T.,col4bar,didtag:=.F.,aindex, ;
      a_chscrn,o_row:= Row(),o_col:= Col(),hotkeys[3],ab_methods,ab,;
      lDecr:= .F.,lCansel:= .T.,dir:= "D"

DEFAULT boxtp TO B_DOUBLE,       ttlcolor TO TITLECOLOR,;
	barcolor TO BARCOLOR,    r_screen TO .T. ,;
	msg_col TO l+2,          noselcolor TO "w/n" ,;
	msg_color TO USEL_COLOR, boxcolor TO Setcolor(),;
	uselcolor TO USEL_COLOR, aexec TO .T. ,;
	ebarcolor TO Setcolor(), ;
	ebarside TO "L",         start_elem TO 1 ,;
	timeout TO 0,            ttlpos TO 1

o_curs := SetCursor(SC_NONE)
SR_keys( "S",hotkeys )
IF b==NIL
   b:= IF( (t+Len(arrey)+1) >= maxrow()-2,maxrow()-2,(t+Len(arrey)+1) )
ENDIF
DEFAULT msg_row TO b+2
r:= PrepArray( arrey,l,r,TAGS,tagchar )
ach_scrn := SaveScreen( t,l-2,b+2,r+2 )

IF arrey==aSaveArr
   aindex:= oSaveobj:cargo[1]
   ab:= oSaveObj ; ab:inValidate()
ELSE
   aindex:= 1
   ab:= tbrowsenew( t+1,l+1,b-1,r-1 )
   ab:addcolumn(tbcolumnnew("",{|| arrey[aindex][AOPT]} ))
   ab:getcolumn(1):width   := (r-1 -l)
   ab:gotopblock           := {|| aindex := 1}
   ab:gobottomblock        := {|| aindex := num_elems}
   ab:skipblock            := {|n| ASkip( n,@aindex,arrey )}
   ab:colorspec            += ","+uselcolor+","+barcolor+","+noselcolor
   ab:getcolumn(1):colorblock:= { || ;
		   IF(NOSELECT,{8},{6}) ,;
		   ab:getcolumn(1):defcolor:= IF(NOSELECT,{8,8},{6,7}) }
   ab:cargo:= Array(1)
ENDIF

aSaveArr:= AClone(arrey)
lCanSel:= ( Ascan(arrey,{|e| Len(e)==ASEL .and. (e[ASEL]==NIL ;
			     .or. e[ASEL]) }) ) == 0
ab_methods:= Curs_Methods()
PaintBox( t,l,b,r,boxtp,boxcolor,boxttl,ttlcolor,ttlpos,shad,TAGS )
col4bar  := IF(upper(ebarside)=="L",l,r)
IF( ebar <> NIL,ElevBar( t+1,col4bar,b,ebar,ebarcolor,ebarside ), )

ab:autolite := .F.

WHILE CONTINUING

   DispBegin()
   STABILIZE ab

   IF lCanSel         // at least one option is selectable.
      WHILE NOSELECT
	 IF( dir=="U",IF(ATTOP,ab:goBottom(),ab:up()) ,;
		      IF(ATBOTT,ab:goTop(),ab:down() ) )
	 STABILIZE ab
      ENDDO
   ENDIF

   top_elem:= 1+aindex-ab:rowPos; bot_elem:= top_elem+ab:rowcount-1

   IF first_entry .and. start_elem > 1
      dir:= HotKeyPress( ab,arrey,start_elem,aindex,top_elem,bot_elem )
      aindex:= start_elem
      top_elem:= 1+aindex-ab:rowPos; bot_elem:= top_elem+ab:rowcount-1
   ENDIF

   HotKeyColor( t,l,top_elem,arrey,ab:rowcount,hkcolor )

   DispMsgg( msg_row,msg_col,arrey,aindex,msg_color )
   IF ebar <> NIL
      DispMsg( UP_ARROW_POS,UP_ARROW,ebarcolor )
      DispMsg( DN_ARROW_POS,DN_ARROW,ebarcolor )
   ENDIF

   ab:hilite()
   DispEnd()

   // idle mode...of sorts.
   IF valtype(u_func)=="B"
      uf_cont:= Eval( u_func,lkey,IF(didtag .and. lDecr,aindex-1,aindex) )
   ENDIF

   IF ex_req .or. !uf_cont; OUTTA_HERE; ELSE; lkey:= 0; ENDIF

   **************************************************************************
   lkey     := SKInkey( timeout,ab,arrey,aindex,t,l,b,r,TAGS,tagchar,aexec )
   **************************************************************************

   meth_num := Ascan( ab_methods, {|e| lkey == e})
   aelem    := Ascan( arrey,{|e| IF(Len(e) >= AHOT .and. e[AHOT]<>NIL,;
		      upper(chr(lkey)) == upper(subs(Ltrim(e[AOPT]),e[AHOT],1)) ,;
		      upper(chr(lkey)) == upper(left(Ltrim(e[AOPT]),1)) ) } )

   DO CASE
   CASE TIMED_OUT
      ex_req:= .T. ; timeout_val:= IF(timeout_val==NIL,aindex,timeout_val)
   CASE HOTKEY_PRESS
      dir   := HotKeyPress(ab,arrey,aelem,aindex,top_elem,bot_elem)
      ex_req:= SELECTABLE; aindex:= aelem
   CASE METHOD_PRESS .or. lkey==K_ENTER
      ExecKey( lKey,ab,ATTOP,ATBOTT )
      ex_req:= ((lkey==K_ENTER) .and. !NOSELECT)
   CASE TAG_PRESS
      didtag:= TagPress( ab,arrey,aindex,lkey,tagchar,@lDecr )
   ENDCASE

   dir   := IF(GOING_UP,"U",IF(GOING_DOWN,"D",dir) )
   ex_req:= IF( lkey==0,.T.,ex_req ) ; first_entry:= .F.

ENDDO

ab:cargo[1]:= aindex ; oSaveobj:= ab
Aeval( arrey,{|e| e[AOPT]:= Ltrim(e[AOPT]) } )
SetPos(o_row,o_col); SetCursor(o_curs)
IF( r_screen,RestScreen( t,l-2,b+2,r+2,ach_scrn ), )
SR_keys( "R",hotkeys ) ; aMsgData:= Array(2)
RETURN IF( lkey==K_ESC, 0, IF(TIMED_OUT,timeout_val,aindex) )
************************************************************************
STATIC FUNCTION Askip(num_elems, aindex, arrey)
LOCAL save_aindex := aindex
aindex:= IF( aindex+num_elems > Len(arrey), Len(arrey),;
	 IF( aindex+num_elems < 1, 1, aindex+num_elems ))
RETURN (aindex - save_aindex)
*************************************************************************
STATIC FUNCTION HotKeyPress( ab,arrey,elem,aindex,top_elem,bot_elem )
LOCAL cur_elem:= aindex,new_elem:= elem,dest,dir:= "D"

WHILE cur_elem < new_elem            // descending
   dest:= MIN( new_elem,bot_elem ) ; dir:= "D"
   WHILE cur_elem < dest; ab:down(); cur_elem++; ENDDO    // speeding
   STABILIZE ab
   WHILE cur_elem < new_elem
      ab:down() ; STABILIZE ab
      cur_elem++
   ENDDO
ENDDO
WHILE cur_elem > new_elem            // ascending
   dest:= MAX( new_elem,top_elem ) ; dir:= "U"
   WHILE cur_elem > dest; ab:up(); cur_elem--; ENDDO      // speeding
   STABILIZE ab
   WHILE cur_elem > new_elem
      ab:up() ; STABILIZE ab
      cur_elem--
   ENDDO
ENDDO

RETURN dir
*************************************************************************
STATIC FUNCTION DispMsgg( r,c,arrey,pos,msg_color )
LOCAL color2use
IF MESG_LEN==NIL ; MESG_LEN:= 0 ; MESG_COL:= 99; ENDIF
IF( MESG_LEN > 0,Clear( r,MESG_COL,r,MESG_COL+MESG_LEN -1 ), )
IF Len(arrey[pos]) >= AMSG .and. arrey[pos][AMSG] <> NIL  // if msg. to disp.
   color2use:= IF(Len(arrey[pos]) >= ACLR .and. arrey[pos][ACLR]<>NIL,;
	      arrey[pos][ACLR],msg_color)
   IF valtype(c)== "C" .and. c=="C"  // indicating Centering
      c:= Int( ((maxcol()+1)/2) - (Len(arrey[pos][AMSG])/2) )
   ENDIF
   DispMsg( r,c,arrey[pos][AMSG],color2use )
   MESG_LEN:= Len(arrey[pos][AMSG]) ; MESG_COL:= c
ENDIF
RETURN NIL
*************************************************************************
/*
this is here for test purposes.  the default is NO user func.
*/
#ifdef FT_TEST

FUNCTION UserFunc( key,elem_num,anything,aexec,st_elem,tag,tmout )
LOCAL ret_val:= .T.
DEFAULT tmout TO 0
@ 09,45 say "            LASTKEY: "+Ltrim(str(key))+"  "
@ 10,45 say "CURRENT ELEMENT NUM: "+Ltrim(str(elem_num))+"  "
@ 11,45 say "  AUTO-EXECUTION IS: "+if(aexec,"ON ","OFF")
@ 12,45 say "STARTING AT ELEMENT: "+ltrim(str(st_elem))
@ 13,45 say "         TAGGING IS: "+if(tag,"ENABLED ","DISABLED")
@ 14,45 say "            TIMEOUT: "+if(tmout >0,ltrim(str(tmout))+" secs.  ",;
				    "INACTIVE      ")
IF anything <> NIL; @ 16,45 say anything; ENDIF

/*
return .F. if you want to leave FT_ACH2TB() after whatever
processing you do here.
*/

RETURN (ret_val)
#endif

**************************************************************************
#define ELEM2USE    arrey[top_elem+i]
#define CANT_SELECT (len(ELEM2USE)==5 .and. !ELEM2USE[ASEL])

STATIC FUNCTION HotKeyColor( t,l,top_elem,arrey,rowcount,hkcolor )
LOCAL i:= 0,color2use,col2use,charpos,xx,nUpper:= MIN(Len(arrey),rowcount)
FOR xx:= 1 TO nUpper
    color2use:= IF( Len(ELEM2USE) >=ACLR .and. ELEM2USE[ACLR]<>NIL,;
		ELEM2USE[ACLR], IF(hkcolor<>NIL,hkcolor,HK_COLOR) )
    col2use:=   IF(len(ELEM2USE) >=AHOT .and. ELEM2USE[AHOT]<>NIL,;
		l+1+ELEM2USE[AHOT],l+2)
    charpos:=   IF(len(ELEM2USE) >=AHOT .and. ELEM2USE[AHOT]<>NIL,;
		ELEM2USE[AHOT],1 )
    IF !CANT_SELECT
       SetPos( t+xx,col2use )
       DispOut( SUBS(Ltrim(ELEM2USE[AOPT]),charpos,1),color2use )
    ENDIF
    i++
NEXT
RETURN NIL
****************************************************************************
STATIC FUNCTION Curs_Methods()
RETURN (  { ;
	  K_DOWN,     ;
	  K_UP,       ;
	  K_PGDN,     ;
	  K_PGUP,     ;
	  K_CTRL_PGDN,;
	  K_CTRL_PGUP,;
	  K_CTRL_END ,;
	  K_CTRL_HOME,;
	  K_END,      ;
	  K_HOME,     ;
	  K_ENTER,    ;
	  K_SPACEBAR, ;
	  K_PLUS,     ;
	  K_MINUS } )
****************************************************************************
STATIC FUNCTION ExecKey( lKey,ab,lTop,lBot )
DO CASE
   CASE lKey==K_DOWN       ; IF(lBot,ab:goTop(),ab:down())
   CASE lKey==K_UP         ; IF(lTop,ab:goBottom(),ab:up())
   CASE lKey==K_PGDN       ; IF(lBot,ab:goTop(),ab:pagedown())
   CASE lKey==K_PGUP       ; IF(lTop,ab:goBottom(),ab:pageup())
   CASE lKey==K_CTRL_PGDN .or. lKey==K_CTRL_END .or. lKey==K_END
			     IF(lBot,ab:goTop(),ab:gobottom())
   CASE lKey==K_CTRL_PGUP .or. lKey==K_CTRL_HOME .or. lKey==K_HOME
			     IF(lTop,ab:goBottom(),ab:goTop())
ENDCASE
RETURN NIL
****************************************************************************
STATIC FUNCTION ElevBar( t,col4bar,b,ebar,bcolor )
LOCAL c:= 0
Aeval( Array(b-t),{ |e,n| SetPos(t+c,col4bar),DispOut(ebar,bcolor),c++ })
RETURN NIL
****************************************************************************
#define TARGET   arrey[pos][AOPT]
#define TAGGED   (tagchar $TARGET)
#define AEV_TARG arrey[n][AOPT]
#define AEV_TAGD (tagchar $AEV_TARG)

STATIC FUNCTION TagPress( ab,arrey,pos,lkey,tagchar,lDecr )
LOCAL didtag:= .F.

IF (lkey==K_PLUS .and. !TAGGED) .or. (lkey==K_MINUS .and. TAGGED)
   TARGET:= IF( (lkey==K_PLUS .and. !TAGGED) ,;
		Left(TARGET,Len(TARGET)-1)+tagchar ,;
	    IF( (lkey==K_MINUS .and. TAGGED) ,;
		Strtran(TARGET,tagchar," ")  ,;
		TARGET ))
   ab:refreshcurrent(); didtag:= .T.
   IF lKey==K_PLUS .and. TAGGED
      ab:down() ; lDecr:= (pos < Len(arrey))
   ENDIF
ENDIF
IF lkey==K_SPACEBAR
   IF !(Ascan(arrey,{|e| tagchar $ e[AOPT] }) > 0)
      Aeval(arrey,{|e,n| AEV_TARG:= Left(AEV_TARG,Len(AEV_TARG)-1)+tagchar })
   ELSE
      Aeval(arrey,{|e,n| AEV_TARG:= Strtran(AEV_TARG,tagchar," ") })
   ENDIF
   ab:refreshall() ; didtag:= .T.
ENDIF
RETURN (didtag)
****************************************************************************
#translate CenterB( <b>,<l>,<r>,<msg>[,<color>] ) => ;
	   SetPos(<b>,(<l>+Int((<r>-<l> -Len(<msg>))/2) ) ) ;;
	   DispOut(<msg>[,<color>])

STATIC FUNCTION PaintBox( t,l,b,r,boxtp,boxcolor,boxttl,ttlcolor,ttlpos,shad,tags )
  shad := NIL
  IF shad <> NIL
    IF( shad=="FT",FT_Shadow( t,l+1,b,r ), )
    IF( shad $"LR",Shadoww( t,l,b,r,upper(shad) ), )
 ENDIF
 DispBox( t,l,b,r,boxtp,boxcolor )
 IF boxttl <> NIL; DispMsg( t,l+ttlpos,boxttl,ttlcolor ); ENDIF
 IF tags .and. (r-l) >= Len("tags")
    CenterB( b,l,r,"Tags","+w/"+BG(boxcolor) )
 ENDIF
RETURN NIL
****************************************************************************
STATIC FUNCTION PrepArray( arrey,l,r,tags,tagchar )
Aeval( arrey,{|e| e[AOPT]:= " " +AllTrim( ;
		  IF(tags,StrTran(e[AOPT],tagchar),e[AOPT]) ) } )
IF valtype(r)=="N"
   Aeval( arrey,{|e| e[AOPT]:= Padr(e[AOPT],r-l-1) })
ELSEIF (r==NIL); r:= 0
   Aeval( arrey,{|e| r:= MAX( r,Len(e[AOPT]) ) })
   r+= IF( !tags,(l+2),(l+3) )
   IF( tags,Aeval( arrey,{|e| e[AOPT]:= Padr(e[AOPT],r-l-1) }), )
ENDIF
RETURN (r)
*****************************************************************************
STATIC FUNCTION BG( color )
LOCAL startpos:= AT("/",color)+1
LOCAL endpos:= IF( "," $ color,AT(",",color),len(color)+1 )
RETURN upper(subs( color,startpos,(endpos-startpos) ))
*****************************************************************************
STATIC FUNCTION FG( color )
RETURN upper(subs( color,1,AT("/",color)-1 ))
*****************************************************************************
STATIC FUNCTION SKInkey( nSecs,ab,arrey,aindex,t,l,b,r,tags,tagchar,aexec )
LOCAL bBlock,nKey:= 0,lLooping:= .T.
WHILE lLooping
#ifndef NOMOUSE
    nKey:= Mouser( nSecs,ab,arrey,aindex,t,l,b,r,tags,tagchar,aexec )
    lLooping:= .F.
    IF nKey==0 .and. Nextkey() <> 0
       FT_MShowcrs()
#endif
       nKey:= Inkey( nSecs )
       IF ( bBlock := Setkey(nKey) ) <> NIL
	  Eval( bBlock, Procname(1), Procline(1), Readvar(),Getactive() )
       ELSE; lLooping:= .F.
       ENDIF
#ifndef NOMOUSE
    ENDIF
#endif

ENDDO
RETURN (nKey)
****************************************************************************
#ifndef NOMOUSE

STATIC FUNCTION Mouser( nSecs,ab,arrey,aindex,t,l,b,r,tags,tagchar,aexec )
LOCAL nR:= 0,nCurrow,nNumpos:= 0,nKey:= 0,cur_elem,pos,lLooping:= .T.,;
      lDown:= .F.,nTime:= Seconds()
   // while no button or key pressed.

   WHILE lLooping .and. Nextkey()==0
      FT_MShowcrs()

      IF nSecs > 0 .and. (Seconds() >= nTime+nSecs)
	 nKey:= OUTTA_TIME ; lLooping:= .F.
      ELSEIF FT_Mbutprs(1)==2               // right button == ESC
	 nKey:= K_ESC ; lLooping:= .F.
      ELSEIF FT_Mbutprs(0)==1           // left button pressed
	 DO CASE
	   CASE FT_Minregion( t,l,t,l ) .or. FT_Minregion( b,l,b,l )
		nKey:= IF( FT_Minregion( t,l,t,l ),K_CTRL_PGUP,;  // upper left
		       IF( FT_Minregion( b,l,b,l ),K_CTRL_PGDN,nKey) ) // lower left
		lLooping:= .F.
	   CASE FT_Minregion( t,r,t,r ) .or. FT_Minregion( b,r,b,r )
		nKey:= IF( FT_Minregion( t,r,t,r ),K_PGUP, ;      //upper right corner
		       IF( FT_Minregion( b,r,b,r ),K_PGDN,nKey )) //lower left corner
		lLooping:= .F.
	   CASE !(FT_Minregion(t,l,b,r))
		nKey:= K_ENTER ; lLooping:= .F.
	   OTHERWISE
		IF FT_MInregion(t+1,l+1,b-1,r-1)
		   // mouse row.
		   nR:= FT_MgetX()
		   // what row does current elem occupy?
		   nCurrow:= ab:nTop+ab:rowPos-1
		   // difference between this and nR is number of positions to move.
		   nNumpos:= IF( nR==nCurrow,0,ABS(nR-nCurrow))
		   cur_elem:= arrey[ aindex+ IF( nR > nCurrow,nNumpos,-nNumpos ) ]
		   IF nNumpos==0
		      nKey:= IF(tags, ;
			     IF(tagchar $ cur_elem[1],K_MINUS,K_PLUS),;
				K_ENTER)
		      lLooping:= .F.
		   ENDIF
		   IF nNumpos > 0
		      // if no hotkeys, we'll move ourselves and return -1.
		      // -1 indicating no handling in the main loop.
		      lDown:= (nR > nCurrow)
		      WHILE nR > nCurrow ; ab:down(); nCurrow++ ; ENDDO
		      WHILE nR < nCurrow ; ab:up()  ; nCurrow-- ; ENDDO
		      // if element is unselectable, move one above or below.
		      IF Len(cur_elem)==ASEL .and. cur_elem[ASEL]<>NIL .and. ;
			 !cur_elem[ASEL]
			 IF(lDown,ab:down(),ab:up())
		      ENDIF
		      nKey:= IF(tags .or. !aexec, -1, K_ENTER)
		      lLooping:= .F.
		   ENDIF
		ENDIF
	 ENDCASE
      ENDIF
   ENDDO
FT_MHidecrs()
RETURN (nKey)

#endif

****************************************************************************
STATIC FUNCTION SR_Keys( action,hotkeys )
IF action=="S"
   hotkeys[1] := Setkey(K_SPACEBAR) ; Setkey(K_SPACEBAR,NIL)
   hotkeys[2] := Setkey(K_PLUS)     ; Setkey(K_PLUS,NIL)
   hotkeys[3] := Setkey(K_MINUS)    ; Setkey(K_MINUS,NIL)
ELSEIF action=="R"
   Setkey(K_SPACEBAR,hotkeys[1])
   Setkey(K_PLUS,hotkeys[2])
   Setkey(K_MINUS,hotkeys[3])
ENDIF
RETURN NIL
****************************************************************************
STATIC FUNCTION Shadoww( t,l,b,r,side )
LOCAL bx
DEFAULT side TO "R"
l+= IF(side=="R",2,-2); r+= IF(side=="R",2,-2)
bx:= SaveScreen( ++t,l,++b,r )
RestScreen( t,l,b,r,Transf( bx,Replic("x"+chr(8),len(bx)/2) ) )
RETURN NIL
