# bo2-plutonium-gsc

A bunch of mods for black ops 2 zombies

## Install Pre-Compiled Mod

Download the mod binaries from the releases and drag and drop them into `%localappdata%\Plutonium\storage\t6\scripts\zm`, if this destination does not exist, then proceed to create it.

## Install with Compilation

1. You can write/download any GSC of your choice. If you are writing it from scratch/have the source code, note that you will need to compile it.

2. If you want to write from scratch you can use the code below and given on the ![plutonium forum website](https://plutonium.pw/docs/modding/loading-mods/#t6)

```
init() // entry point
{
    level thread onplayerconnect();
}

onplayerconnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onplayerspawned();
    }
}

onplayerspawned()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("spawned_player");
        self iprintlnbold("^2GSC from %LocalAppdata%\\Plutonium\\storage\\t6\\scripts\\zm\\test.gsc ^1(Compiled)");
    }
}
```

3. Using the GSC Compiler (from GSC Toolkit), simply drag and drop your raw GSC script ontop of Compiler.exe and it should spit out a compiled version.

![Compilation Process](images/OWtguHd.gif)

*Note: If you get an error, make sure your script isn't already precompiled (open it, and if it looks like gibberish, it is already compiled)*

![Error](images/JgwqeCy.png)

4. Grab the compiled binary, and drag and drop it into `%localappdata%\Plutonium\storage\t6\scripts\zm`, if this destination does not exist, then proceed to create it.

## Using

When launching your server or a custom game, you will know if all has gone well or not if the console prints Custom script 'scripts/mp/yourScriptName' loaded.

![Script Loaded](images/oVlCBnI.png)
