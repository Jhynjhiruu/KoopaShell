if(_root.KSInstalled != true)
{
   _root.KSInstalled = true;
   _root.verbose = true;
   _root.allowedKeys = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_:/.\\\'%;*+";
   _root.cmdDisplay = "";
   _root.cmd = "";
   _root.runString = true;
   _root.outputMethod = "builtin";
   _root.inputMode = "cmd";
   _root.lastStringPos = 0;
   _root.KoopaShell = _root.createEmptyMovieClip("KoopaShell",_root.getNextHighestDepth());
   _root.KoopaShell.createTextField("output",2,599,0,200,200);
   _root.KoopaShell.output.border = true;
   _root.KoopaShell.output.wordWrap = true;
   _root.KoopaShell.output._visible = true;
   _root.KoopaShell.createTextField("input",1,0,0,100,50);
   _root.KoopaShell.input.type = "input";
   _root.KoopaShell.input.autosize = true;
   _root.KoopaShell.input.border = true;
   _root.KoopaShell.input.variable = "_root.cmdDisplay";
   _root.KoopaShell.textinput = "test";
   _root.KoopaShell.input.wordWrap = true;
   _root.KoopaShell.input._visible = true;
   _root.traceOutput = function(a)
   {
      if(_root.outputMethod == "builtin")
      {
         _root.KoopaShell.output.text = _root.KoopaShell.output.text + a + "\n";
         _root.KoopaShell.output.scroll++;
      }
      else
      {
         trace(a);
      }
   };
   _root.resetInputLayer = function()
   {
      _root.KoopaShell.swapDepths(_root.getNextHighestDepth());
   };
   setInterval(_root.resetInputLayer,250);
   _root.KoopaShell.inputMouse = new Object();
   _root.KoopaShell.inputMouse.onMouseDown = function()
   {
      if(_xmouse > _root.KoopaShell.input._x && _xmouse < _root.KoopaShell.input._x + 100 && _ymouse > _root.KoopaShell.input._y && _ymouse < _root.KoopaShell.input._y + 50)
      {
         _root.KoopaShell.inputMouse = "input";
      }
      if(_xmouse > _root.KoopaShell.output._x && _xmouse < _root.KoopaShell.output._x + 200 && _ymouse > _root.KoopaShell.output._y && _ymouse < _root.KoopaShell.output._y + 200)
      {
         _root.KoopaShell.inputMouse = "output";
      }
   };
   _root.KoopaShell.inputMouse.onMouseUp = function()
   {
      _root.KoopaShell.inputMouse = false;
   };
   _root.KoopaShell.inputMouse.onMouseMove = function()
   {
      if(_root.KoopaShell.inputMouse == "input")
      {
         _root.KoopaShell.input._x = _xmouse + _root.inputxdiff;
         _root.KoopaShell.input._y = _ymouse + _root.inputydiff;
      }
      if(_root.KoopaShell.inputMouse == "output")
      {
         _root.KoopaShell.output._x = _xmouse + _root.outputxdiff;
         _root.KoopaShell.output._y = _ymouse + _root.outputydiff;
      }
      _root.inputxdiff = _root.KoopaShell.input._x - _xmouse;
      _root.inputydiff = _root.KoopaShell.input._y - _ymouse;
      _root.outputxdiff = _root.KoopaShell.output._x - _xmouse;
      _root.outputydiff = _root.KoopaShell.output._y - _ymouse;
   };
   Mouse.addListener(_root.KoopaShell.inputMouse);
   _root.KoopaShell.inputMouse = false;
   var keyListener = new Object();
   keyListener.onKeyDown = function()
   {
      switch(Key.getAscii())
      {
         case 127:
            _root.cmdDisplay = _root.cmdDisplay.substring(0,_root.cmdDisplay.length - 1);
            break;
         case 13:
            _root.cmd = _root.cmdDisplay;
            if(_root.inputMode == "cmd")
            {
               i = 0;
               switchCmd = -1;
               while(i < _root.cmd.length)
               {
                  if(_root.cmd.charAt(i) == " ")
                  {
                     if(switchCmd == -1)
                     {
                        _root.cmd = _root.cmd.slice(0,i) + "," + _root.cmd.slice(i + 1);
                     }
                  }
                  if(_root.cmd.charAt(i) == "\"")
                  {
                     switchCmd = switchCmd * -1;
                     _root.cmd = _root.cmd.slice(0,i) + _root.cmd.slice(i + 1);
                  }
                  i++;
               }
               if(Boolean(_root.verbose))
               {
                  _root.traceOutput(_root.cmd.split(","));
               }
               _root.eval(_root.cmd.split(","));
            }
            else
            {
               _root.userInput = _root.cmd;
               _root.inputMode = "cmd";
               _root.runString = true;
            }
            _root.cmd = "";
            _root.KoopaShell.input.text = "";
            break;
         case 27:
            _root.KoopaShell.input.text = "";
            _root.cmd = "";
            _root.resumeMain();
      }
   };
   Key.addListener(keyListener);
   _root.loadScript = function(code)
   {
      var _loc2_ = new LoadVars();
      _loc2_.onData = function(content)
      {
         if(content == undefined)
         {
            if(Boolean(_root.verbose))
            {
               _root.traceOutput("Script " + code[1] + ".kss not found, halting load...");
            }
            return undefined;
         }
         _root.loadedContent = content.split("\n");
         i = 0;
         while(i < _root.loadedContent.length)
         {
            if(Boolean(_root.verbose))
            {
               _root.traceOutput("Executing command " + i + ": " + _root.loadedContent[i] + "...");
            }
            _root.eval(_root.loadedContent[i].split(" "));
            i++;
         }
      };
      _root.traceOutput("Loading script " + code[1] + ".kss...");
      _loc2_.load(code[1] + ".kss");
   };
   _root.loadSWF = function(code)
   {
      _root.extSWF = _root.createEmptyMovieClip("ext_loader",_root.getNextHighestDepth());
      _root.extSWF.onLoad = function()
      {
         _root.extSWF.removeMovieClip("ext_loader");
      };
      _root.extSWF.loadMovie(code[1],this,"GET");
   };
   _root.setVariable = function(code)
   {
      set(code[1],code[2]);
      if(Boolean(_root.verbose))
      {
         _root.traceOutput(code[1] + " set to " + code[2]);
      }
   };
   _root.lockVar = function(code)
   {
      if(Boolean(code[3]))
      {
         _root["lock" + code[1]] = function(funVarName, funSetTo)
         {
            set(funVarName,funSetTo);
         };
         _root["lockid" + code[1]] = setInterval(_root["lock" + code[1]],31.25,code[1],code[2]);
         if(Boolean(_root.verbose))
         {
            _root.traceOutput(code[1] + " locked to " + code[2]);
         }
      }
      else
      {
         clearInterval(_root["lockid" + code[1]]);
         if(Boolean(_root.verbose))
         {
            _root.traceOutput(code[1] + " unlocked");
         }
      }
   };
   _root.createBreakpoint = function(code)
   {
      _root["permtr" + code[1]] = function(funVarName, funOnUpdate)
      {
         if(_root[funVarName] != _root["brkp" + funVarName])
         {
            if(Boolean(_root.verbose))
            {
               _root.traceOutput(funVarName + " changed to \"" + _root[funVarName] + "\"");
            }
            _root["brkp" + funVarName] = _root[funVarName];
         }
      };
      setInterval(_root["permtr" + code[1]],31.25,code[1],code[2]);
   };
   _root.logicalTest = function(code)
   {
      _root.statement1 = code[1];
      _root.statement2 = code[3];
      _root.logicPass = false;
      switch(code[2])
      {
         case "is":
            if(_root.statement1 == _root.statement2)
            {
               _root.logicPass = true;
            }
            break;
         case "not":
            if(_root.statement1 != _root.statement2)
            {
               _root.logicPass = true;
            }
            break;
         case "greater":
            if(_root.statement1 > _root.statement2)
            {
               _root.logicPass = true;
            }
            break;
         case "smaller":
            if(_root.statement1 < _root.statement2)
            {
               _root.logicPass = true;
            }
            break;
         default:
            if(Boolean(_root.verbose))
            {
               _root.traceOutput("Logical test " + code[2] + " isn\'t currently implemented. Leave an issue on KS\'s GitHub repo.");
               break;
            }
      }
      if(_root.logicPass)
      {
         _root.eval(code.slice(4,code.length));
      }
   };
   _root.callFunction = function(code)
   {
      _root.callOutput = _root[code[1]].apply(_root,code.slice(2,code.length));
      if(Boolean(_root.verbose))
      {
         _root.traceOutput("Called function " + code[1] + " with parameters " + code.slice(2,code.length) + ", returned " + _root.callOutput);
      }
   };
   _root.evalstring = function(code)
   {
      _root.commands = code[1].split(";");
      i = _root.lastStringPos;
      while(i < _root.commands.length)
      {
         if(_root.runString)
         {
            _root.eval(_root.commands[i].split(" "));
            if(_root.commands[i].split(" ")[0] == "brk")
            {
               if(Boolean(_root.verbose))
               {
                  _root.traceOutput("Break command entered, stopping loop execution...");
               }
               break;
            }
            i++;
            continue;
         }
         _root.lastStringPos = i;
         break;
      }
      if(i >= _root.commands.length)
      {
         _root.lastStringPos = 0;
      }
   };
   _root.ath = function(code)
   {
      switch(code[3])
      {
         case "+":
            _root.eval(["set",code[1],parseFloat(code[2]) + parseFloat(code[4])]);
            break;
         case "-":
            _root.eval(["set",code[1],parseFloat(code[2]) - parseFloat(code[4])]);
            break;
         case "*":
            _root.eval(["set",code[1],parseFloat(code[2]) * parseFloat(code[4])]);
            break;
         case "/":
            _root.eval(["set",code[1],parseFloat(code[2]) / parseFloat(code[4])]);
            break;
         case "%%":
            _root.eval(["set",code[1],parseFloat(code[2]) % parseFloat(code[4])]);
            break;
         default:
            if(Boolean(_root.verbose))
            {
               _root.traceOutput("That arithmetic operation hasn\'t been implemented yet. Please submit an issue at the KoopaShell GitHub page.");
               break;
            }
      }
   };
   _root.defineFunction = function(code)
   {
      _root[code[1] + "data"] = code.slice(3).join(" ");
      _root[code[1]] = function()
      {
         if(_root.runString == true)
         {
            _root.currentFuncInt = _root[code[1] + "int"];
            _root.eval(["string",_root[code[1] + "data"]]);
         }
      };
      if(code[2] != "" && code[2] != "0")
      {
         _root[code[1] + "int"] = setInterval(_root[code[1]],1000 / code[2]);
      }
   };
   _root.array = function(code)
   {
      if(Boolean(code[1]))
      {
         if(_root[code[2]] == undefined)
         {
            _root[code[2]] = [];
         }
         i = _root[code[2]].length;
         while(i < code[3])
         {
            _root[code[2]].push(null);
            i++;
         }
         _root[code[2]].splice(code[3],1,code[4]);
         _root.traceOutput(_root[code[2]]);
         if(Boolean(_root.verbose))
         {
            _root.traceOutput("Array " + code[2] + " index " + code[3] + " set to " + code[4]);
         }
      }
      else
      {
         _root[code[4]] = _root[code[2]][code[3]];
         if(Boolean(_root.verbose))
         {
            _root.traceOutput("Array " + code[2] + " index " + code[3] + " stored in " + code[4]);
         }
      }
   };
   _root.takeInput = function(code)
   {
      _root.userInput = "";
      _root.cmdDisplay = code.slice(1).join(" ");
      _root.inputMode = "inp";
      _root.runString = false;
   };
   _root.eval = function(code)
   {
      d = 0;
      while(d < code.length)
      {
         switch(code[d].slice(0,2))
         {
            case "%f":
               code[d] = this[code[d].slice(2)].call(this);
               break;
            case "%v":
               code[d] = _root[code[d].slice(2)];
               break;
            case "%b":
               code[d] = Boolean(code[d]);
         }
         if(code[d].slice(0,1) == "\\")
         {
            code[d] = code[d].slice(1);
         }
         d++;
      }
      switch(code[0])
      {
         case "set":
            _root.setVariable(code);
            break;
         case "trace":
            _root.createBreakpoint(code);
            break;
         case "lock":
            _root.lockVar(code);
            break;
         case "load":
            _root.loadSWF(code);
            break;
         case "ldsr":
            _root.loadScript(code);
            break;
         case "print":
            _root.traceOutput(code[1]);
            break;
         case "if":
            _root.logicalTest(code);
            break;
         case "call":
            _root.callFunction(code);
            break;
         case "string":
            _root.evalstring(code);
            break;
         case "setath":
            _root.ath(code);
            break;
         case "def":
            _root.defineFunction(code);
            break;
         case "brk":
            clearInterval(_root.currentFuncInt);
            break;
         case "arr":
            _root.array(code);
            break;
         case "inp":
            _root.takeInput(code);
            break;
         default:
            if(Boolean(_root.verbose))
            {
               _root.traceOutput(code[0] + " isn\'t a usable command! Attempting to execute it will do nothing!");
               break;
            }
      }
      if(Boolean(_root.verbose))
      {
         _root.traceOutput("Command executed: \"" + code + "\"");
      }
   };
   traceOutput("KS_Main_0.9.0 installed");
   _root.eval(["ldsr","ksscripts/init"]);
}
