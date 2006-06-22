/*
 * File......: FT_ACH2T.CH
 * Author....: Steve Kolterman
 * CIS ID....: 76320,37
 * Date......: $Date$
 * Revision..: $Revision$
 * Log file..: $Logfile:   C:/nanfor/src/ft_ach2t.chv  $
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
 * Revision 1.1  2003/04/26 09:29:33  clip
 * uri: add
 *
 * 
 *    Rev 1.3   07 Oct 1992 23:29:14   GLENN
 * Latest Kolterman updates.
 * 
 *    Rev 1.2   15 Aug 1991 23:19:32   GLENN
 * Last minute changes sent in by Steve Kolterman
 * 
 *    Rev 1.1   15 Aug 1991 23:08:50   GLENN
 * Forest Belt proofread/edited/cleaned up doc
 * 
 *    Rev 1.0   14 Jun 1991 04:14:28   GLENN
 * Initial revision.
 *
 */


/*  $DOC$
 *  $FUNCNAME$
 *     A_CHOICE()
 *  $ONELINER$
 *     Psuedo function to simplify FT_ACH2TB()
 *  $CATEGORY$
 *     Menus/Prompts
 *  $SYNTAX$
 *     See FT_ACH2TB()
 *  $ARGUMENTS$
 *     See FT_ACH2TB()
 *
 *  $RETURNS$
 *     See FT_ACH2TB()
 *
 *  $DESCRIPTION$
 *     The A_CHOICE() UDC in FT_ACH2T.CH makes using FT_ACH2TB() a breeze.
 *     The myriad of parameters can be written in any order.  Only <nToprow>,
 *     <nTopcol>, and <aArrey> are required.  See the example below.
 *
 *     Be sure to check the documentation for ft_ach2tb() for more
 *     details.
 *
 *
 *  $EXAMPLES$
 *  nOpt := A_CHOICE( 7,9,, ARRAY:t_arrey USERFUNC:{|a,b| UserFunc(a,b,any1)};
 *          BOXTYPE:B_SINGLE  BOXTITLE:title  SHADOW:"R" TAGCHAR:chr(17);
 *          REST_SCREEN:.F. AUTOEXEC:.F. MES_COLOR:MSG_COLOR ELEVBAR:"±" ;
 *          NOSELCOLOR:"bg/n")
 *
 *  Check only the RETURNed element:
 *  IF Was_Tagged(chr(17),t_arrey,nOpt); MoreProcessing(); END
 *
 *  Check entire 't_arrey':
 *  Aeval( t_arrey,{|e,n| IF( Was_Tagged(chr(17),t_arrey,n ), ;
 *                            MoreProcessing(t_arrey),NIL ) } )
 *
 *
 *  $SEEALSO$
 *     FT_ACH2TB()
 *  $END$
 */


#xtrans A_CHOICE(                                                    ;
        <t>,<l>,[<b>],[<r>]                                          ;
        ARRAY:<arr>                                                  ;
        [USERFUNC:<func>]                                            ;
        [BOXTYPE:<bx>]                                               ;
        [BOXCOLOR:<bxc>]                                             ;
        [BOXTITLE:<bxt>]                                             ;
        [TITLEPOS:<bxp>]                                             ;
        [USELCOLOR:<uselc>]                                          ;
        [TITLECOLOR:<ttlc>]                                          ;
        [BAR_COLOR:<barc>]                                           ;
        [HOTKEYCOLOR:<hkcolor>]                                      ;
        [SHADOW:<sh>]                                                ;
        [AUTOEXEC:<aex>]                                             ;
        [MES_ROW:<mrow>]                                             ;
        [MES_COL:<mcol>]                                             ;
        [MES_COLOR:<mcolor>]                                         ;
        [ELEVBAR:<ebar>]                                             ;
        [ELEVBAR_COLOR:<ebarc>]                                      ;
        [ELEVBAR_SIDE:<ebars>]                                       ;
        [NOSELCOLOR:<nscolor>]                                       ;
        [TAGCHAR:<tagch>]                                            ;
        [START_ELEM:<start>]                                         ;
        [REST_SCREEN:<rscrn>]                                        ;
        [TIME_OUT:<timeout>]                                         ;
        [TIME_OUT VALUE:<toval>] )                                   ;
        =>                                                           ;
        FT_Ach2tb(                                                   ;
                   <t>,<l>,[<b>],[<r>],<arr>, [<bx>],                ;
                   [<bxc>], [<bxt>], [<bxp>], [<uselc>], [<ttlc>],   ;
                   [<barc>], [<hkcolor>], [<sh>], [<aex>], [<mrow>], ;
                   [<mcol>], [<mcolor>], [<ebar>], [<ebarc>],        ;
                   [<ebars>], [<nscolor>], [<tagch>], [<start>],     ;
                   [<rscrn>],[<timeout>],[<toval>],[<func>]          ;
                 )

#translate WAS_TAGGED(<tchar>,<arr>,<val>)   =>                         ;
           ( <tchar> $ <arr>\[<val>]\[1] ) 

#translate ONE_TAGGED(<tchar>,<arr>)         =>                         ;
           (Ascan(<arr>,{|e| <tchar> $ e\[1]})) > 0

#translate ALL_TAGGED(<tchar>,<arr>)         =>                         ;
           (Ascan(<arr>,{|e| !(<tchar> $ e\[1]})) ) == 0
