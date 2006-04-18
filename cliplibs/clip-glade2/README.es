
                Clip-Glade2 - (c) Sergio Zayas Toré, 2.005
                --------------------------------------------


Licencia
--------
        Clip-Glade2 se distribuye bajo la GNU General Public License (GPL),
como se describe en el archivo COPYING (inglés).


Descripción
-----------
       Clip-Glade2 es una librería para el compilador Clip
(http://www.itk.ru). Permite usar las facilidades ofrecidas por libGlade
dentro de una aplicación compilada con Clip.


Requisitos
----------
       Para compilar Clip-Glade2 se necesita tener instalado :
               1.- Compilador Clip con soporte para gtk2
               2.- libglade2 
               3.- libglade2-devel 

       Para compilar y ejecutar programas (.prg) que utilicen Clip-libGlade2
no es necesario tener instalado libglade2-devel.
   


Construcción de Clip-Glade2
---------------------------
       Para compilar Clip-Glade2 en el directorio fuente ejecutar:

               $ make

y si no ha habido problemas se habrá creado el archivo 'libclip_glade2.so'.


       Para instalar la librería

	       # make install


       Para compilar y ejecutar el ejemplo :
               $cd example
               $make
               $./eglade


Compilación de programas Clip
-----------------------------
       Para compilar programas Clip (.prg) que hagan uso de Clip-Glade2 
hay que añadir la librería en la línea de generación del
ejecutable.

       Ejemplo : 
   
    $ clip -e miaplicacion.prg -clip-gtk2 -lclip-glade2
   

       

Uso de Clip-Glade2 desde Clip
----------------------------
       Consultar el archivo 'REFERENCIA.txt' para información de uso de
las llamadas a clip-glade2.
       Mas información (en inglés) de libglade se encuentra aquí : 
       http://developer.gnome.org/doc/API/2.0/libglade/index.html 




Compatibilidad
--------------
       Clip-Glade2 está desarrollado usando la versión 2.4.2 de libglade-2.0
con versiones anteriores o posteriores no está probado.



Soporte
-------
       Cualquier duda, sugerencia o aportación será bien recibida en :
       
       <Segio Zayas> sergio_zayas@yahoo.com.ar 

