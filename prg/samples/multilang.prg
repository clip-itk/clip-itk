#define s1 [Hello world]
#define s2 [Good bye world]

local file

? " !!! This is demonstration of multilanguage/multimessages application !!!"
?
? "Locale module name is:",__CLIP_MODULE__
? "Default string1 is:",s1
? "Default string2 is:",s2
?

file:="./locale.mo/lang1/"+__CLIP_MODULE__+".mo"
? "Install external data from file:",file," "
  ?? loadModuleMsg(__CLIP_MODULE__,file)
? "String1 for lang1 is:",s1
? "String2 for lang1 is:",s2
?

file:="./locale.mo/lang2/"+__CLIP_MODULE__+".mo"
? "Install external data from file:",file," "
  ?? loadModuleMsg(__CLIP_MODULE__,file)
? "String1 for lang2 is:",s1
? "String2 for lang2 is:",s2

?
return

