#ifndef _HTML_COMMANDS

#include "Clr_html.ch"

#define _HTML_SPACE  chr(38)+"nbsp;"

#xTranslate HTMLSpace( <n> )     => replicate( "&nbsp;", <n> )

/* commands for HTML-documents */
#command DEFINE HTML			;
          [FILE <file>]			;
          [TITLE <title>]		;
          OF <oHtml>          =>	;
          <oHtml> := htmlNew( [<file>], [<title>])

#Command NEW LINE IN <oHtml> =>		;
        <oHtml>:newLine()

#Command HTML NEW LINE IN <oHtml> =>	;
        <oHtml>:newLine(.t.)

#Command HTML SET CENTER ON IN <oHtml> =>	;
        <oHtml>:setCenter(.t.)

#Command HTML SET CENTER OFF IN <oHtml> =>	;
        <oHtml>:setCenter(.f.)

#Command HTML SET FONT <font> IN <oHtml> =>	;
        <oHtml>:setFontType(<font>)

#Command HTML CLOSE FONT <font> IN <oHtml> =>	;
        <oHtml>:setFontType(<font>,.f.)

#Command HTML PUT <text> to <oHtml> =>	;
        <oHtml>:addData(<text>)

#command HTML TEXT <ctext>     ;
          [WIDTH <width>]      ;
          [<lwrap:WRAP>]       ;
          OF <oHtm>	       ;
          =>                   ;
          <oHtm>:text( [<ctext>], [<width>], [<.lwrap.>])

#command MULTICOL <ctext>      ;
          [COLS <cols>]        ;
          [GUTTER <gutter>]    ;
          [WIDTH <width>]      ;
          OF <oHtm>	       ;
          =>                   ;
          <oHtm>:multiCol( <ctext>, <cols>, <gutter>, <width>)

#command HTML HEAD <size>      ;
          TEXT <ctext>         ;
          [ALIGN <align>]      ;
          [<lc:CENTER>]        ;
          OF <oHtm>	       ;
          =>                   ;
          <oHtm>:putHeading( <ctext>, <size>, <align>, [<.lc.>])

#command HTML LINE             ;
          [SIZE <size>]        ;
          [WIDTH <width>]      ;
          OF <oHtm>	       ;
          =>                   ;
          <oHtm>:HLine( <size>, <width>)

#command START PARAGRAPH       ;
          [ALIGN <align>]      ;
          [STYLE <style>]      ;
          OF <oHtm>	       ;
          =>                   ;
          <oHtm>:paragraph( .t., <align>, <style>)


#command END PARAGRAPH        ;
          OF <oHtm>	       ;
          =>                   ;
          <oHtm>:paragraph( .f.)

#command START LIST            ;
          [OTHER <other>]      ;
          [<lcomp:COMPACT>]    ;
          [<lord:ORDERING>]    ;
          [TYPE <type>]        ;
          OF <oHtm>	       ;
          =>                   ;
          <oHtm>:startList(<.lord.>, <other>, <.lcomp.>, <type>)

#command  LIST ITEM <text>     ;
          [OTHER <other>]      ;
          [TYPE <type>]        ;
          [VALUE <value>]      ;
          OF <oHtm>	       ;
          =>                   ;
          <oHtm>:listItem(<text>, <other>, <type>, <value>)

#command END LIST        ;
          OF <oHtm>	       ;
          =>                   ;
          <oHtm>:endList()

#Command HTML SET FONT [<cFont>]    ;
          [SIZE <s>]           ;
          [COLOR <c>]          ;
          [<bold:BOLD>]        ;
          [<itl:ITALIC>]       ;
          [<uln:UNDERLINE>]    ;
          OF <oHtm>	       ;
          =>                   ;
          <oHtm>:startFont( [<(cFont)>], [<s>], [<c>], [<.bold.>], ;
                          [<.itl.>], [<.uln.>]  )

#Command HTML CLOSE ALL FONT IN <oHtml> =>	;
        <oHtml>:endFontAll()


#Command START FONT [<cFont>] ;
          [SIZE <s>]           ;
          [COLOR <c>]          ;
          [<bold:BOLD>]        ;
          [<itl:ITALIC>]       ;
          [<uln:UNDERLINE>]    ;
          [OF <oHtm>]          ;
          =>                   ;
          <oHtm>:StartFont( [<(cFont)>], [<s>], [<c>], ;
                          [<.bold.>], [<.itl.>], [<.uln.>] )


#Command END FONT [<cFont>]   ;
          [OF <oHtm>]          ;
          =>                   ;
          <oHtm>:EndFont()

#command SAY <str>              ;
          [FONT <fnt> ]          ;
          [TYPE <type>]          ;
          [SIZE <size>]          ;
          [COLOR <clr>]          ;
          <of:OF,IN> <oHtm>      ;
          =>                     ;
          <oHtm>:Say( <str>, <fnt>, <size>, <type>, <clr> )

#Command IMAGE <image>             ;
          [BORDER <border>]         ;
          [HEIGHT <height>]         ;
          [SIZE <height>]           ;
          [NAME <name>]             ;
          [TARGET <target>]         ;
          [ALT <alt>]               ;
          [OTHER <other>]           ;
          OF <oHtm>                 ;
          =>                        ;
          <oHtm>:putImage( <image>, <alt>, <border>, <height>,;
                           <name>, <target>, <other> )

#Command IMAGE <image>             ;
          URL <url>                 ;
          [BORDER <border>]         ;
          [HEIGHT <height>]         ;
          [NAME <name>]             ;
          [TARGET <target>]         ;
          [ALT <alt>]               ;
          [OTHER <other>]           ;
          OF <oHtm>                 ;
          =>                        ;
          <oHtm>:ImageURL( <url>, <target>, <image>, <alt>, <border>,;
                              <height>, <name>, <other> )

#Command LINK <url>                 ;
          [TEXT <text>]             ;
          [TARGET <target>]         ;
          [OTHER <other>]           ;
          OF <oHtm>                 ;
          =>                        ;
          <oHtm>:URL( <text>, <url>, <target>, <other> )

#command START MARQUEE                       ;
          [FONT <cFont>]                     ;
          [OTHER <other>]                    ;
          [ALIGN <align>]                    ;
          [BEHAVIOR <bh>]                    ;
          [BGCOLOR <bgcolor>]                ;
          [DIRECT <dir>]                     ;
          [HEIGHT <Height>]                  ;
          [HSPACE <hspace>]                  ;
          [LOOP <loop>]                      ;
          [SCROLLAMT <nScrollAmt>]           ;
          [SCROLLDELAY <nScrollDel>]         ;
          [VSPACE <vspace>]                  ;
          [WIDTH <nWidth>]                   ;
          OF <oHtm>                          ;
          =>                                 ;
          <oHtm>:StartMarquee( <other>, <align>, <bh>, <bgcolor>, <dir>,;
                               <Height>, <hspace>, <loop>, <nScrollAmt>,;
                               <nScrollDel>, <vspace>, <nWidth>)

#Command END MARQUEE OF <oHtm>  => <oHtm>:endMarquee()

#Command START TABLE               ;
          [ALIGN <align>]            ;
          [BORDER <border>]          ;
          [BGCOLOR <clrbg>]          ;
          [BACKGROUND <background>]  ;
          [BORDERCOLOR <brdClr>]     ;
          [COLORDARK <clrDrk>]       ;
          [COLORLIGHT <clrLt>]       ;
          [CELLPADDING <cellPd>]     ;
          [CELLSPACING <cellSp>]     ;
          [FRAME <frame>]            ;
          [HSPACE <hspace>]          ;
          [RULES <rules>]            ;
          [VSPACE <vspace>]          ;
          [WIDTH <width>]            ;
          [OTHER <other>]	     ;
          OF <oHtm>                  ;
          =>                         ;
          <oHtm>:startTable( <other>, <align>, <border>, <background>,;
          		      <clrbg>, <brdClr>, [<clrDrk>], [<clrLt>],;
                              [<cellPd>], [<cellSp>], [<frame>],;
                              [<hspace>], [<rules>], [<vspace>], [<width>])

#Command END TABLE OF <oHtml> =>     ;
	  <oHtml>:endTable()

#Command START TABLE ROW             ;
          [OTHER <other>]	     ;
          [ALIGN <align>]            ;
          [BORDER <border>]          ;
          [BGCOLOR <clrbg>]          ;
          [BACKGROUND <background>]  ;
          [BORDERCOLOR <brdClr>]     ;
          [COLORDARK <clrDrk>]       ;
          [COLORLIGHT <clrLt>]       ;
          [VALIGN <valign>]          ;
          [WIDTH <width>]            ;
          OF <oHtm>                  ;
          =>                         ;
          <oHtm>:startTrow( <other>, <align>, <border>, <background>,;
          		      <clrbg>, <brdClr>, [<clrDrk>], [<clrLt>],;
                              [<valign>], [<width>])

#Command END TABLE ROW OF <oHtml> =>     ;
	  <oHtml>:endTrow()

#Command  TABLE HEADER CELL          ;
          [TEXT <cHead>]             ;
          [OTHER <other>]            ;
          [ALIGN <align>]            ;
          [BACKGROUND <backgnd>]     ;
          [BGCOLOR <clrbg>]          ;
          [BORDERCOLOR <brdClr>]     ;
          [COLORDARK <clrDrk>]       ;
          [COLORLIGHT <clrLt>]       ;
          [ROWSPAN <rspan>]          ;
          [COLSPAN <cspan>]          ;
          [<nowrap:NOWRAP>]          ;
          [VALIGN <valign>]          ;
          [WIDTH <width>]            ;
          OF <oHtm>                  ;
          =>                         ;
          <oHtm>:THcell( <cHead>, <other>, [<align>], <backgnd>, <clrbg>,;
                         <brdClr>, [<clrDrk>], [<clrLt>],;
                         <cspan>, <rspan>, <.nowrap.>, <valign>, <width>)

#Command START TABLE CELL            ;
          [OTHER <other>]            ;
          [ALIGN <align>]            ;
          [BACKGROUND <backgnd>]     ;
          [BGCOLOR <clrbg>]          ;
          [BORDERCOLOR <brdClr>]     ;
          [COLORDARK <clrDrk>]       ;
          [COLORLIGHT <clrLt>]       ;
          [COLSPAN <cspan>]          ;
          [ROWSPAN <rspan>]          ;
          [<nowrap:NOWRAP>]          ;
          [VALIGN <valign>]          ;
          [WIDTH <width>]            ;
          OF <oHtm>                  ;
          =>                         ;
          <oHtm>:startTcell(<other>, [<align>], <backgnd>, <clrbg>,;
                         <brdClr>, [<clrDrk>], [<clrLt>],;
                         <cspan>, <rspan>, <.nowrap.>, <valign>, <width>)

#Command END TABLE CELL OF <oHtml> =>     ;
	  <oHtml>:endTcell()

#command START FORM  <url>     ;
          [OTHER <other>]      ;
          [ENCTYPE <enc>]      ;
          [METHOD <method>]    ;
          [TARGET <target>]    ;
          OF <oHtm>	       ;
          =>                   ;
          <oHtm>:startForm( <other>, <url>, <enc>, <method>, <target>)

#command END FORM              ;
          OF <oHtm>	       ;
          =>                   ;
          <oHtm>:endForm()

#Command INPUT IMAGE <image>        ;
          NAME <name>               ;
          [ALIGN <align>]           ;
          [OTHER <other>]           ;
          OF <oHtm>                 ;
          =>                        ;
          <oHtm>:inputImage( <image>, <other>, <align>, <name>)

#Command HTML INPUT  TYPE <type>    ;
          NAME <name>               ;
          VALUE <value>             ;
          [SIZE <size>]             ;
          [MAXLEN <maxlen>]         ;
          [OTHER <other>]           ;
          OF <oHtm>                 ;
          =>                        ;
          <oHtm>:formGet( <type>, <name>, <value>, <size>,;
          		 <maxlen>, <other>)

#Command HTML INPUT  CHECKBOX <name>;
          VALUE <value>             ;
          [<check:CHECKED>]         ;
          [OTHER <other>]           ;
          OF <oHtm>                 ;
          =>                        ;
          <oHtm>:checkBox(<name>, <value>, <.check.>, <other>)

#Command HTML INPUT  RADIOBOX <name>;
          VALUE <value>             ;
          [<check:CHECKED>]         ;
          [OTHER <other>]           ;
          OF <oHtm>                 ;
          =>                        ;
          <oHtm>:radioBox(<name>, <value>, <.check.>, <other>)

#Command HTML INPUT FILE <name>     ;
          VALUE <value>             ;
          [SIZE <size>]             ;
          [MAXLEN <maxlen>]         ;
          [OTHER <other>]           ;
          OF <oHtm>                 ;
          =>                        ;
          <oHtm>:formFile( <name>, <value>, <size>, <maxlen>, <other>)

#Command HTML INPUT HIDDEN <name>     ;
          VALUE <value>             ;
          [SIZE <size>]             ;
          [MAXLEN <maxlen>]         ;
          [OTHER <other>]           ;
          OF <oHtm>                 ;
          =>                        ;
          <oHtm>:formFile( <name>, <value>, <size>, <maxlen>, <other>)

#Command HTML INPUT PASSWORD <name>     ;
          VALUE <value>             ;
          [SIZE <size>]             ;
          [MAXLEN <maxlen>]         ;
          [OTHER <other>]           ;
          OF <oHtm>                 ;
          =>                        ;
          <oHtm>:formFile( <name>, <value>, <size>, <maxlen>, <other>)

#Command HTML INPUT <text> SUBMIT <name>     ;
          [OTHER <other>]           ;
          OF <oHtm>                 ;
          =>                        ;
          <oHtm>:formSubmit( <text>, <name>, <other>)

#Command HTML INPUT <text> RESET <name>     ;
          [OTHER <other>]           ;
          OF <oHtm>                 ;
          =>                        ;
          <oHtm>:formReset( <text>, <name>, <other>)

#command START SELECT  <name>  ;
          [OTHER <other>]      ;
          [SIZE <size>]        ;
          [MULTIPLE <multi>]   ;
          OF <oHtm>	       ;
          =>                   ;
          <oHtm>:startSelect(<name>, <other>, <size>, <multi>)

#Command HTML INPUT  OPTION <text>  ;
          VALUE <value>             ;
          [<s:SELECTED>]         ;
          [OTHER <other>]           ;
          OF <oHtm>                 ;
          =>                        ;
          <oHtm>:addOption(<value>, <text>, <other>, <.s.>)

#command END SELECT            ;
          OF <oHtm>	       ;
          =>                   ;
          <oHtm>:endSelect()

#Command HTML <oHtm> SAVE to <file> ;
          =>                        ;
          <oHtm>:writeToFile( <file> )

#Command HTML <oHtm> SAVE ;
          =>                        ;
          <oHtm>:writeToFile( )

#Command HTML <oHtm> SAVE TO CGI;
          =>                        ;
          <oHtm>:writeToHttp( )

#Command START FRAMESET         ;
          [ROWS <rows>]         ;
          [COLS <cols>]         ;
          [OTHER <other>]       ;
          [BORDER <border>]     ;
          [BORDERCOLOR <bgClr>] ;
          [FRAMEBORDER <bgFr>]  ;
          [FRAMESPACING <sFr>]  ;
          OF <oFrm>             ;
          =>                    ;
          <oFrm>:StartFrameSet(<other>, <cols>, <rows>, <border>,;
                            <bgClr>, <bgFr>, <sFr>)

#Command END FRAMESET <oFrm>        => <oFrm>:EndFrameSet()

#Command ADD FRAME  <name>      ;
          URL <url>             ;
          [OTHER <other>]       ;
          [BORDERCOLOR <bgClr>] ;
          [FRAMEBORDER <bgFr>]  ;
          [MARGINHEIGHT <mh>]   ;
          [MARGINWIDTH <mw>]    ;
          [<res:NORESIZE>]      ;
          [SCROLLING <scrl>]    ;
          OF <oFrm>             ;
          =>                    ;
          <oFrm>:frame( <name>, <url>, <other>, <bgClr>, <bgFr>,;
                        <mw>, <mh>, <.res.>, <scrl>)

#define _HTML_COMMANDS
#endif
