/* Módulo de selección de archivo. */

#define TL_WINDOW_NAME "save_file_selection"

static dialog:= nil, selfic := ""

function csaveSelec_fic( lGuardar )
// Return : the selected filename.
// Retorno : el nombre de un archivo seleccionado.


        local xml

        xml := glade_xml_new( xmlfic(), TL_WINDOW_NAME )

        if( xml == 0 )
return( "" ); endif

        if( dialog == nil )

                dialog := glade_xml_get_widget( xml, TL_WINDOW_NAME )


                /*
                  Full manual signal connect sample.
                  Conexión automática de seńales.
                */

                gtk_signalConnect( dialog, "delete-event",;
                  {|w,e| on_save_filesel_delete_event(w,e)} )

                glade_xml_signal_connect( xml, "on_save_filesel_cancel_button_clicked",;
                   {|w| on_save_filesel_cancel_button_clicked(w)} )

                glade_xml_signal_connect( xml, "on_save_filesel_ok_button_clicked",;
                   {|w| on_save_filesel_ok_button_clicked( w )} )

        endif

        gtk_widgetShow( dialog )

        /*
           Waiting for close dialog.
           Se espera a que termine el diálogo.
        */
        gtk_main()

return(selfic)


function on_save_filesel_delete_event(wid,event)
        selfic := ""
        ? "Delete_event"
        gtk_widgetDestroy(dialog)
        gtk_quit()
        dialog= nil
return( .f. )


procedure on_save_filesel_cancel_button_clicked(wid)
        selfic := ""
        gtk_widgetHide(dialog)
        gtk_quit()
return


procedure on_save_filesel_ok_button_clicked( wid )
        selfic := gtk_FileSelectionGetFileName(dialog)
        gtk_widgetHide(dialog)
        gtk_quit()
return

