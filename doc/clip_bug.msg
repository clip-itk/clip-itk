
#This is a sample bugreport message,
#please fill it  out and send to bugzilla@itk.ru
# or use clip_bug utilite
# or submit bug online
#
# The mail message MUST have subject 'Bug Report'

#All lines above first @field will be skipped

#required @product
#@product = Clip

#required @component
# possible values
#	:description (not required at all)

#@component = clip preprocessor
#	: clip compiler preprocessor
#@component = clip database drivers
#	: database drivers for clip
#@component = clip compiler
#	: clip compiler
#@component = clip low-level runtime
#	: low level runtime support functions
#@component = clip high-level runtime
#	: written in Clip library functions and classes
#@component = clip prg
#	: Utilities, written in Clip
#@component = cliplibs gtk
#	: gtk binding
#@component = cliplibs gtkextra
#	: gtkextra binding
#@component = cliplibs fw
#	: FiveWin library realisation
#@component = cliplibs cti
#	: Clip text interface
#@component = cliplibs bzip2
#	: bzip2 library binding
#@component = cliplibs com
#	: Seriall port access
#@component = cliplibs crypto
#	: openssl crypto functions
#@component = cliplibs fcgi
#	: FastCgi library for clip
#@component = cliplibs gd
#	: Plot graphic library
#@component = cliplibs gzip
#	: gzip library binding
#@component = cliplibs interbase
#	: Interbase access library
#@component = cliplibs mysql
#	: mysql access library
#@component = cliplibs oasis
#	: netto and nanfor libraries
#@component = cliplibs odbc
#	: odbc access library
#@component = cliplibs oracle
#	: oracle access library
#@component = cliplibs postgres
#	: postgres access library
#@component = cliplibs rtf
#	: rtf generating library
#@component = cliplibs txtprn
#	: text printer library


#required @version
#@version = 0.99

#required @short_descr
#@short_desc = one-line bug description

#optional @rep_platform
# hardware platform
#possible values:
# 
#	All
#	DEC
#	HP
#	Macintosh
#	PC
#	SGI
#	Sun
#	Other
# default value = All

#optional @priority
#
# bug priority level, from highest to lowest
#	P1
#	P2
#	P3
#	P4
#	P5
# default value = P2

#optional @bug_severity
#
#	blocker
#	critical
#	major
#	normal
#	minor
#	trivial
#	enhancement
#
# default value = normal


#optional @op_sys
# operating system
# 
#	All
#	Windows 3.1
#	Windows 95
#	Windows 98
#	Windows ME
#	Windows 2000
#	Windows NT
#	Mac System 7
#	Mac System 7.5
#	Mac System 7.6.1
#	Mac System 8.0
#	Mac System 8.5
#	Mac System 8.6
#	Mac System 9.0
#	Linux
#	BSDI
#	FreeBSD
#	NetBSD
#	OpenBSD
#	AIX
#	BeOS
#	HP-UX
#	IRIX
#	Neutrino
#	OpenVMS
#	OS/2
#	OSF/1
#	Solaris
#	SunOS
#	other
# default value = Linux

#All lines above first @field will be skipped

@product = Clip
@component = clip compiler
@version = 0.99
@short_desc = one-line bug description
@rep_platform = PC
@priority = P2
@bug_severity = normal
@op_sys = Linux


All lines below and this line will be a bug description

