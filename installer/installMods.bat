@echo off

copy "%~1" mods.gsc
Compiler.exe mods.gsc
del mods.gsc
move mods-compiled.gsc %LOCALAPPDATA%\Plutonium\storage\t6\scripts\zm\mods.gsc