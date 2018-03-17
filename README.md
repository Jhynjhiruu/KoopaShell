<img src="https://media.discordapp.net/attachments/383022336510525442/424569343591055370/KoopaShell_full.png">
A shell written in ActionScript 2.0

### Supported commands:
##### set:
`set varName setTo`

Sets the variable `varName` to the value specified in `setTo`.

##### trace:
`trace varName`

Traces `varName` whenever it updates.

##### lock:
`lock varName lockTo Boolean`

Locks the variable `varName` to `lockTo`. `Boolean` should be true (not blank) if you want to lock the variable, and false (blank) if you want to unlock it. When unlocking, `lockTo` is still required, but can be left blank.

##### load:
`load url`

Loads a .swf file from the location specified in `url`.

##### ldsr:
`ldsr path/to/script`

Loads and runs the script file (with the extension .kss) specified in `path/to/script`. NOTE: Using this requires downloading a release from the [releases page](https://github.com/Jhynjhiruu/KoopaShell/releases/) and running that, trying to load a script using a hosted file will fail.

##### print:
`print data`

Traces `data`.

##### if:
`if myVar is yourVar print data`

If `myVar` is equal to `yourVar` (==), run the command starting at index 4 (`print data` in this case). 3 other logical tests also exist - `not` (!=), `greater` (>) and `smaller` (<).

##### call:
`call myFunction arg1 arg2`

Calles the function `_root.myFunction` with arguments `arg1`, `arg2` etc. 

##### setath:
`setath myVariable %vaNumber - 4`

Sets the variable with the name `myVariable` to the 2nd argument subtract the 4th argument. +, * and / are also supported.

##### def:
`def myFunction 0 print test`

Defines a function with the name `myFunction` evals starting from index 3 when called. Replacing 0 (or blank) with a number will automatically call the function that many times per second.

##### brk:
`brk`
Breaks the currently executing loop. Pretty much random when run manually, but it should always break a function it's put into. This is basically how to make loops in KoopaScript.

##### arr:
`arr true myArr 0 %vmyVar`
Reads/writes to and from arrays. `true` determines whether to write to the array (if `true`) or read from it (if `false`). `myArr` is an example array name, next is the index to be used, and finally the data to be written. When reading, this is used as the variable that data should be written to.

### Important keys (by ID):
127 ('delete' key) - backspace

13 ('enter' or 'return' key) - run currently entered command

27 ('escape' key) - delete currently entered command and call `_root.resumeMain()`. Define `_root.resumeMain()` with the code required to unpause/resume/whatever the program this is attached to
