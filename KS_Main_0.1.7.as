if(_root.KSInstalled != true)
{
   _root.KSInstalled = true;
   _root.verbose = false;
   trace("KS_Main_0.1.7 installed");
   _root.loadScript = function(code)
   {
      varReceiver = new LoadVars();
      varReceiver.onLoad = function()
      {
         if(Boolean(_root.verbose))
         {
            trace("Script " + code[1] + ".kss loaded!");
         }
         var _loc3_ = 0;
         while(this["cmd" + _loc3_] != undefined)
         {
            if(Boolean(_root.verbose))
            {
               trace("Executing cmd" + _loc3_ + ": " + this["cmd" + _loc3_] + "...");
            }
            if(this["cmd" + _loc3_] == "brk")
            {
               if(Boolean(_root.verbose))
               {
                  trace("Encountered \"brk\" command at cmd" + _loc3_ + ": Halting execution of " + code[1] + "...");
               }
               break;
            }
            _root.eval(this["cmd" + _loc3_].split(" "));
            _loc3_ = _loc3_ + 1;
         }
      };
      if(Boolean(_root.verbose))
      {
         trace("Loading script " + code[1] + ".kss...");
      }
      varReceiver.load(code[1] + ".kss");
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
      _root["perm" + code[1]] = function(funVarName, funSetTo)
      {
         set(funVarName,funSetTo);
         if(Boolean(_root.verbose))
         {
            trace(funVarName + " set to " + funSetTo);
         }
      };
      if(Boolean(code[3]))
      {
         setInterval(_root["perm" + code[1]],1000 / code[4],code[1],code[2]);
      }
      this["perm" + code[1]].call(this,code[1],code[2]);
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
            if(Boolean(funOnUpdate))
            {
               _root["brkp" + funVarName] = _root[funVarName];
            }
         }
      };
      setInterval(_root["permtr" + code[1]],31.25,code[1],code[2]);
   };
   _root.eval = function(code)
   {
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
   _root.eval(["ldsr","https://raw.githubusercontent.com/Jhynjhiruu/KoopaShell/master/ksscripts/init"]);
   _root.eval(["ldsr","ksscripts/init"]);
}
