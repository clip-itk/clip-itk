/*
  Selection font dialog.
  Diálogo de selección de fuentes.
*/

#define TL_WINDOW_NAME "font_selection"

static dialog:= nil, selfont := ""

function cSelec_font()
// Return : the font name selected or ""
// Retorno : el nombre del font seleccionado o ""


        local xml

        xml := glade_xml_new( xmlfic(), TL_WINDOW_NAME )

        if( xml == 0 )
return( "" ); endif

        if( dialog == nil )

                dialog := glade_xml_get_widget( xml, TL_WINDOW_NAME )

                /*
                  Automatic signal connection.
                  Conexión automática de seńales.
                */
                glade_xml_signal_autoconnect( xml )

                gtk_signalConnect( dialog, "delete-event",;
                  {|w,e| on_fontsel_delete_event(w,e)} )

        endif

        gtk_widgetShow( dialog )

        /*
           Waiting for close dialog.
           Se espera a que termine el diálogo.
        */
        gtk_main()

return(selfont)


function on_fontsel_delete_event(wid,event)
        selfont := ""
        gtk_widgetDestroy(dialog)
        gtk_quit()
        dialog= nil
return( .f. )


procedure on_fontsel_cancel_button_clicked(wid)
        selfont := ""
        gtk_widgetHide(dialog)
        gtk_quit()
return


procedure on_fontsel_apply_button_clicked(wid)
        selfont := gtk_fontSelectionDialogGetFontName(dialog)
        ? "Apply font: " + selfont
return


procedure on_fontsel_ok_button_clicked( wid )
        selfont := gtk_fontSelectionDialogGetFontName(dialog)
        gtk_widgetHide(dialog)
        gtk_quit()
return

