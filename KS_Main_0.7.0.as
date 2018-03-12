if(_root.KSInstalled != true)
{
   _root.KSInstalled = true;
   _root.verbose = false;
   trace("KS_Main_0.7.0 installed");
   _root.inputMode = "cmd";
   _root.swapModes = function()
   {
      if(_root.inputMode == "cmd")
      {
         _root.inputMode = "txt";
      }
      else
      {
         _root.inputMode = "cmd";
      }
      if(Boolean(_root.verbose))
      {
         trace(_root.inputMode);
      }
   };
   _root.allowedKeys = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_:/.\\\'%;*+";
   _root.cmdDisplay = "";
   _root.cmd = "";
   var keyListener = new Object();
   keyListener.onKeyDown = function()
   {
      if(Boolean(_root.verbose))
      {
         trace(Key.getCode() + ", " + chr(Key.getCode()) + ", " + Key.getAscii() + ", " + chr(Key.getAscii()) + ", " + _root.allowedKeys.indexOf(chr(Key.getAscii())) + ", " + _root.cmdDisplay.length);
         if(_root.allowedKeys.indexOf(chr(Key.getAscii())) != -1)
         {
            _root.cmdDisplay = _root.cmdDisplay + chr(Key.getAscii());
            _root.cmd = _root.cmd + chr(Key.getAscii());
         }
         else
         {
            switch(Key.getAscii())
            {
               case 127:
                  if(_root.cmdDisplay.charAt(_root.cmdDisplay.length) == "\"")
                  {
                     _root.swapModes();
                     _root.cmd = _root.cmd + "t";
                  }
                  _root.cmdDisplay = _root.cmdDisplay.substring(0,_root.cmdDisplay.length - 1);
                  _root.cmd = _root.cmd.substring(0,_root.cmd.length - 1);
                  break;
               case 13:
                  if(Boolean(_root.verbose))
                  {
                     trace(_root.cmd.split(","));
                  }
                  _root.eval(_root.cmd.split(","));
                  _root.cmdDisplay = "";
                  _root.cmd = "";
                  if(_root.inputMode == "txt")
                  {
                     _root.inputMode = "cmd";
                  }
                  break;
               case 27:
                  _root.cmdDisplay = "";
                  _root.cmd = "";
                  _root.resumeMain();
                  break;
               case 34:
                  _root.swapModes();
                  _root.cmdDisplay = _root.cmdDisplay + "\"";
                  break;
               case 32:
                  _root.cmdDisplay = _root.cmdDisplay + " ";
                  if(_root.inputMode == "cmd")
                  {
                     _root.cmd = _root.cmd + ",";
                     break;
                  }
                  _root.cmd = _root.cmd + " ";
                  break;
               case 126:
                  _root.cmdDisplay = "";
                  _root.cmd = "";
                  if(_root.inputMode == "txt")
                  {
                     _root.inputMode = "cmd";
                     break;
                  }
            }
         }
      }
   };
   Key.addListener(keyListener);
   _root.loadScript = function(code)
   {
      var _loc1_ = new LoadVars();
      i = 0;
      _loc1_.onData = function(content)
      {
         if(content == undefined)
         {
            if(Boolean(_root.verbose))
            {
               trace("Script " + code[1] + ".kss not found, halting load...");
            }
            return undefined;
         }
         if(Boolean(_root.verbose))
         {
            trace("Executing command " + i + ": " + content + "...");
            i++;
         }
         _root.eval(content.split(" "));
      };
      trace("Loading script " + code[1] + ".kss...");
      _loc1_.load(code[1] + ".kss");
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
         trace(code[1] + " set to " + code[2]);
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
            trace(code[1] + " locked to " + code[2]);
         }
      }
      else
      {
         clearInterval(_root["lockid" + code[1]]);
         if(Boolean(_root.verbose))
         {
            trace(code[1] + " unlocked");
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
               trace(funVarName + " changed to \"" + _root[funVarName] + "\"");
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
               trace("Logical test " + code[2] + " isn\'t currently implemented. Leave an issue on KS\'s GitHub repo.");
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
         trace("Called function " + code[1] + " with parameters " + code.slice(2,code.length) + ", returned " + _root.callOutput);
      }
   };
   _root.evalstring = function(code)
   {
      _root.commands = code[1].split(";");
      i = 0;
      while(i < _root.commands.length)
      {
         _root.eval(_root.commands[i].split(" "));
         i++;
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
               trace("That arithmetic operation hasn\'t been implemented yet. Please submit an issue at the KoopaShell GitHub page.");
               break;
            }
      }
   };
   _root.defineFunction = function(code)
   {
      _root[code[1] + "data"] = code.slice(3).join(" ");
      _root[code[1]] = function()
      {
         _root.eval(["string",_root[code[1] + "data"]]);
      };
      if(code[2] != "" && code[2] != "0")
      {
         setInterval(_root[code[1]],1000 / code[2]);
      }
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
            trace(code[1]);
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
         default:
            if(Boolean(_root.verbose))
            {
               trace(code[0] + " isn\'t a usable command! Attempting to execute it will do nothing!");
               break;
            }
      }
      if(Boolean(_root.verbose))
      {
         trace("Command executed: \"" + code + "\"");
      }
   };
   _root.eval(["ldsr","ksscripts/init"]);
}
