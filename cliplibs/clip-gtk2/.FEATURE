
- 	в функциях gtk_signal_connect кодовый блок должен возвращать FALSE чтобы
	отработали следующие(если есть) блоки кода, повешанные на этот сигнал.
        В gtk1.2 такого нет. Там автоматически отрабатываются все кодовые блоки.
        Ж:-( (/usr/share/gtk2/.../examples/helloworld signale_connect на окно)


- 	нет и не будет функций gtk_widgetsetposition() & gtk_widgetsetsize()
	есть только gtk_widgetsetUposition() работает только с контейнерами.
        Для всех остальных, вставленных в контейнер, нужно использовать либо
        gtk_ContainerAdd() or gtk_FixedPut() or gtk_LayoutPut() и в том же
        духе

- 	функция gtk_window_set_default() устанавливает активный виджет
	только для диалогов. Для окон не работает. :( В gtk1.2 работала
        и требует вызова GTK_WIDGET_SET_FLAGS(widget, GTK_CAN_DEFAULT) для
        того widget, который д.б. активным

