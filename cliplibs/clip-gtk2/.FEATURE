
-       in the functions gtk_signal_connect code block must return FALSE so that
        worked out the following (if any) blocks of code that handle this signal.
        In gtk1.2 this absent. There are processed automatically all the code
        blocks. :-( (/usr/share/gtk2/.../examples/helloworld signale_connect
        on window)

-       not present and will not present functions gtk_widgetsetposition() and
        gtk_widgetsetsize(); present just gtk_widgetsetUposition(), works only with
        containers. For any others inserted into the container should use one of:
         * gtk_ContainerAdd()
         * gtk_FixedPut()
         * gtk_LayoutPut()
         * etc

-       function gtk_window_set_default () sets the widget is active only for dialogs,
        but for windows doesn't work. In gtk1.2 worked and require call of 
        GTK_WIDGET_SET_FLAGS(widget, GTK_CAN_DEFAULT) for active widget.
