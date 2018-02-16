# KoopaShell
A mini interpreter/shell thing for AS2 programs

### Supported commands:
##### set:
`set varName setTo Boolean`

Sets the variable `varName` to the value specified in `setTo`. If `Boolean` contains any data, it will repeat this every frame, but if it does not contain any data, it will only be set once.

##### trace:
`trace varName onUpdate`

Traces `varName` every frame, or, if `onUpdate` isn't blank, when it changes.

##### lock:
`lock varName lockTo Boolean`

Locks the variable `varName` to `lockTo`. `Boolean` should be true (not blank) if you want to lock the variable, and false (blank) if you want to unlock it. When unlocking, `lockTo` is still required, but can be left blank.

##### load:
`load url`

Loads a .swf file from the location specified in `url`.

##### ldsr:
`ldsr path/to/script`

Loads and runs the script file (with the extension .kss) specified in `path/to/script`. NOTE: Currently broken, doesn't do anything.

##### print:
`print data`

Traces `data`.

### Important keys (by ID):
35 - backspace

13 - run currently entered command

27 - delete currently entered command and call `_root.resumeMain()`. Define `_root.resumeMain()` with the code required to unpause/resume/whatever the program this is attached to

126 - delete currently entered command, but don't call `_root.resumeMain()`
