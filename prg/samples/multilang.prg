#define s1 [Hello world]
#define s2 [Good bye world]

? " !!! This is demonstration of multilanguage/multimessages application !!!"
?
? "Locale module name is:",__CLIP_MODULE__
? "Default string1 is:",s1
? "Default string2 is:",s2
?
? "Install external data from lang1/ml1.mo:"
  ?? loadModuleMsg(__CLIP_MODULE__,"./locale.mo/lang1/"+__CLIP_MODULE__+".mo")
? "String1 for lang1 is:",s1
? "String2 for lang1 is:",s2
?
? "Install external data from lang2/ml1.mo:"
  ?? loadModuleMsg(__CLIP_MODULE__,"./locale.mo/lang2/"+__CLIP_MODULE__+".mo")
? "String1 for lang2 is:",s1
? "String2 for lang2 is:",s2

?
return

