/*
  About dialog.
  Diálogo de autor.
*/

#define TL_WINDOW_NAME "about_dialog"

procedure about()

        local xml, dialog

        xml := glade_xml_new( xmlfic(), TL_WINDOW_NAME )

        if( xml == 0 )
return; endif


        dialog := glade_xml_get_widget( xml, TL_WINDOW_NAME )

        /*
          Manual connection signal to send a extra parameter.
          Conexión manual de la señal para pasarle un parámetro extra.
        */
        glade_xml_signal_connect( xml, "on_about_ok_clicked",;
           {|w| on_about_ok_clicked( w, dialog )})

        gtk_signalConnect( dialog, "delete-event",;
                  {|w,e| on_about_delete_event(w,e, dialog)} )

        /*
          This dialog have property 'visible=True', then
        gtk_widgetShow() is not called.
          Como la propiedad 'visible'=True
        no es necesario ejecutar la siguiente línea.
        */
//      gtk_widgetShow(dialog)

return


function on_about_delete_event(wid, event, dlg)
        gtk_widgetDestroy(dlg)
return( .f. )


function on_about_ok_clicked( btn, dlg )
        gtk_widgetDestroy( dlg )
return( .t. )

