<?xml version="1.0" encoding="koi8-r" ?>

<form type="template">
  
  <head>
    <!-- Common information. Required tags. -->
    <name>Contact list</name>
    <description>Print contacts form</description>
    <version>1.0</version>

    <!-- Author, license, contact data. Optional fields. -->
    <author>Andrey Cherepanov</author>
    <copyright>This form in released under the GNU/GPL License</copyright> 
    <component>contact</component>
    <link type="email">skull@eas.lrn.ru</link> 
    <link type="URL">http://eas.lrn.ru/components/contact/</link> 
    
	<!-- Default page settings -->
	<page>
		<format>A4</format> <!-- paper size -->
		<orientation>portrait</orientation> <!-- orientation -->
		<units>mm</units> <!-- units of size: mm -->
		<margins>20</margins> <!-- fields -->
	</page>
	
	<!-- Default style -->
	<style name="default">
		<font-family>Helvetica</font-family>
		<font-size>10</font-size>
	</style>
	
	<!-- Style for text header. "Inherited from "default" style -->
	<style name="title" inherits="default">
		<font-family>TahomaCyr</font-family>
		<font-weight>bold</font-weight>
		<font-size>16</font-size>
		<text-align>center</text-align>
		<padding-top>2</padding-top>
	</style>
	
	<!-- Style for date -->
	<style name="title2" inherits="title">
		<font-family>Helvetica</font-family>
		<font-weight>normal</font-weight>
		<font-size>12</font-size>
		<font-style>italic</font-style>
		<padding-bottom>5</padding-bottom>
	</style>
	
	<!-- Style for table rows -->
	<style name="tablerow" inherits="default">
		<height>20</height>
	</style>

	<!-- Alternative style for table rows -->
	<style name="tablerow_alt" inherits="tablerow">
		<background-color>#d0d0d0</background-color>
	</style>
	
	<!-- Style for table header -->
	<style name="tablehead" inherits="tablerow">
		<font-weight>bold</font-weight>
		<text-align>center</text-align>
		<height>7</height>
	</style>
	
	<!-- Sizes of table cells -->
	<style name="ch1" inherits="tablehead">
		<width>15</width>
		<border>0.75</border>
	</style>
	<style name="ch2" inherits="tablehead">
		<width>100</width>
		<border>0.75</border>
	</style>
	<style name="ch3" inherits="tablehead">
		<width>45</width>
		<border>0.75</border>
	</style>
	<style name="c1" inherits="tablerow">
		<width>15</width>
		<text-align>center</text-align>
		<border>0.75</border>
	</style>
	<style name="c2" inherits="tablerow">
		<width>100</width>
		<border>0.75</border>
	</style>
	<style name="c3" inherits="tablerow">
		<width>45</width>
		<border>0.75</border>
	</style>
    
  </head>
  
  <!-- Content -->
  <content>
	<section style="default">
	<!-- Report Title -->
	<section>
		<text style="title">Contacts</text>
		<text style="title2"><date /></text>
	</section>    
	
	<!-- Footer for any page -->
	<pageFooter>
		<text style="text-align:right;">
			<pageNum />	<!-- page number -->
			<text> of </text>
			<pageCount /> <!-- page count -->
		</text>
	</pageFooter>
	
	<!-- Variables -->
	<value name="num">1</value>
	<value name="set">
		<call>getView("contacts")</call>
	</value>
	
	<!-- Table datasource -->
	<!-- Table header -->
	<table name="Table1">
		
		<!-- Header -->
		<pageHeader>
			<row style="tablehead">
				<cell style="ch1">#</cell>
				<cell style="ch2">Contact Name</cell>
				<cell style="ch3">Phone</cell>
			</row>
		</pageHeader>
		
		<!-- Footer -->
		<pageFooter />
		
		<!-- Table header -->
		<!--header-->
			<row style="tablehead">
				<cell style="ch1">#</cell>
				<cell style="ch2">Contact Name</cell>
				<cell style="ch3">Phone</cell>
			</row>
		<!--/header-->
			
		<!-- table footer -->
		<!--footer /-->
		
		<!-- Table row -->
		<data repeat="set">
			<row name="TableRow" style="tablerow">
				<cell style="c1"><value name="num" /></cell>
				<cell style="c2"><value name="set:[1]" /></cell>
				<cell style="c3"><value name="set:[2]" /></cell>
			</row>
			<value name="num" function="inc"/>
			<!-- Alternate row colors -->
			<condition>
				<call><value name="num" />%2</call> <!-- Condition -->
				<option value="1"><call>setStyle("TableRow","tablerow_alt")</call></option>
			</condition>
		</data>
	</table>
	
	</section>
	
  </content>

</form>