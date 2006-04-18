/*
  File selection dialog.
  Módulo de selección de archivo.
*/

#define DIALOG_NAME "open_file_selection"

static dialog:= nil, selfic := ""

function cSelec_fic( lGuardar )
// Retunr : the selected filename.
// Retorno : el nombre del archivo seleccionado.


        local xml

        xml := glade_xml_new( xmlfic(), DIALOG_NAME )

        if( xml == 0 )
return( "" ); endif

        if( dialog == nil )

                dialog := glade_xml_get_widget( xml, DIALOG_NAME )

                /*
                  Automatic signals connection.
                  Conexión automática de señales.
                */
                glade_xml_signal_autoconnect( xml )


                /*
                  This signal is not defined in xmlfile, then
                manual connection.
                  Esta señal no está definida en el archivo xml,
                entonces conexión manual.
                */
                gtk_signalConnect( dialog, "delete-event",;
                  {|w,e| on_open_filesel_delete_event(w,e)} )

        endif

        gtk_widgetShow( dialog )

        /*
           Waiting for close dialog.
           Se espera a que termine el diálogo.
        */
        gtk_main()

return(selfic)


function on_open_filesel_delete_event(wid,event)
        selfic := ""
        ? "Delete_event"
        gtk_widgetDestroy(dialog)
        gtk_quit()
        dialog= nil
return( .f. )


procedure on_open_filesel_cancel_button_clicked(wid)
        selfic := ""
        gtk_widgetHide(dialog)
        gtk_quit()
return


procedure on_open_filesel_ok_button_clicked( wid )
        selfic := gtk_FileSelectionGetFileName(dialog)
        gtk_widgetHide(dialog)
        gtk_quit()
return

