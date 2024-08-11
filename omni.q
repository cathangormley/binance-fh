
// Globals

.env.APPDIR:"/" sv -1 _ "/" vs first -3#value[{}]
.proc.opt:.Q.opt .z.x

// Need to define how to load files and directories to bootstrap the system
.proc.loadfile:{[file]
  system"l ",file;
 };

.proc.loaddir:{[dir]
  files:string key hsym`$dir:.env.APPDIR,"/",dir,"/";
  if[(o:"order.txt") in files;
    order:read0 `$dir,o;
    files:order,files except order;
   ];
  files:files where files like "*.q";
  .proc.loadfile each dir,/:files; 
 };

.proc.configfile:{[file]
  .env.APPDIR,"/settings/",file
 };

.proc.procname:`$first .proc.opt[`procname];
.proc.proctypes:`$.proc.opt[`proctypes];
.proc.baseport:"J"$first .proc.opt[`baseport];

.proc.loaddir "code/common";
{.proc.loaddir "code/proc/",x} each string[.proc.proctypes];
{.proc.loadfile "settings/proc/",x,".q"} each string[.proc.proctypes];
