echo ### compile ED.COM
tasm /t /ml /m2 /zi ED.ASM 
tasm /t /ml /m2 /zi STACK.ASM 
tasm /t /ml /m2 /zi FILELOW.ASM 
tasm /t /ml /m2 /zi FILE.ASM 
tasm /t /ml /m2 /zi LINE.ASM 
tasm /t /ml /m2 /zi ENVIRO.ASM 
tasm /t /ml /m2 /zi EDIT.ASM 
tasm /t /ml /m2 /zi EDITFUNC.ASM 
tasm /t /ml /m2 /zi MESSAGE.ASM 
tasm /t /ml /m2 /zi MOUSE.ASM 
tasm /t /ml /m2 /zi BLOCK.ASM 
tasm /t /ml /m2 /zi FIND.ASM 
tasm /t /ml /m2 /zi PICK.ASM
tasm /t /ml /m2 /zi CHOOSEF.ASM
tasm /t /ml /m2 /zi ASMLIB0.ASM
tasm /t /ml /m2 /zi ASMLIB1.ASM
tasm /t /ml /m2 /zi ASMLIB2.ASM
rem tlink /x /t ED STACK FILELOW FILE LINE ENVIRO EDIT EDITFUNC MESSAGE MOUSE BLOCK FIND PICK CHOOSEF, ED, , \ASM\ASMLIB\ASMLIB
echo ### link ED.COM
tlink /x /t ED STACK FILELOW FILE LINE ENVIRO EDIT EDITFUNC MESSAGE MOUSE BLOCK FIND PICK CHOOSEF ASMLIB0 ASMLIB1 ASMLIB2, ED, ,

echo ### compile EDSETUP.COM
tasm /t /ml /m2 /zi edsetup.asm
rem tasm /t /ml /m2 /zi asmlib0.asm
echo ### link EDSETUP.COM
tlink /x /t edsetup asmlib0, edsetup
