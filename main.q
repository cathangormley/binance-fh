
// Globals

.env.BINANCEADDRESS:"https://api.binance.com/api/v3/"

.env.APPDIR:getenv`BINANCEFHAPPDIR;
.env.CODEDIR:getenv`BINANCEFHCODEDIR;
.env.CONFIGDIR:getenv`BINANCEFHCONFIGDIR;

// Need to define how to load files and directories to bootstrap the system
.proc.loadfile:{[file]
  -1@"Loading ",file;
  system"l ",file;
 };

.proc.loaddir:{[dir]
  files:string key hsym`$dir,:"/";
  if[(o:"order.txt") in files;
    order:read0 `$dir,o;
    files:order,files except order;
   ];
  files:files where files like "*.q";
  .proc.loadfile each dir,/:files; 
 };

.proc.loaddir "code/util"
