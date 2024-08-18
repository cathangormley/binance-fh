
// -- Globals ------------------------------------------------------------------

.env.BASEPORT:"J"$getenv`BASEPORT;
.env.APPDIR:getenv`APPDIR;
.env.HDBDIR:getenv`HDBDIR;
.env.WDBDIR:getenv`WDBDIR;
.env.LOGDIR:getenv`LOGDIR;

// Process specific info
.proc.opt:.Q.opt .z.x;

.proc.procname:`$first .proc.opt[`procname];
.proc.proctypes:`$.proc.opt[`proctypes];

// -- Logging ------------------------------------------------------------------

// Redirect output and errors
system"1 ",.env.LOGDIR,string[.proc.procname],"_out.log"
system"2 ",.env.LOGDIR,string[.proc.procname],"_err.log"

// Print memory stats and message to redirect handle
.log.log:{[redirect;msg]
  memstats:{"[",x,"]"}"|" sv -4$'string "j"$(value 4#.Q.w[])%2 xexp 20;
  neg[redirect] " " sv (string .z.p;memstats;msg);
 };

.log.out:.log.log[1];
.log.err:.log.log[2];

// -- Loading ------------------------------------------------------------------

// Need to define how to load files and directories to bootstrap the system
.proc.loadfile:{[file]
  .log.out["Loading file: ",file];
  if[()~key hsym `$file;.log.out["Could not find directory"];:(::)];
  system"l ",file;
 };

.proc.loaddir:{[dir]
  .log.out["Loading directory: ",dir];
  files:string key hsym`$dir:dir,"/";
  if[()~files;.log.out["Could not find directory"];:(::)];
  if[(o:"order.txt") in files;
    order:read0 `$dir,o;
    files:order,files except order;
   ];
  files:files where files like "*.q";
  .proc.loadfile each dir,/:files; 
 };

.proc.configfile:{[file]
  .env.APPDIR,"settings/",file
 };

.proc.loaddir .env.APPDIR,"code/common";
{.proc.loadfile .env.APPDIR,"settings/proc/",x,".q"}'[string .proc.proctypes];
{.proc.loaddir .env.APPDIR,"code/proc/",x} each string[.proc.proctypes];

-1 -2@\: "\n" sv read0 `$.proc.configfile "banner.txt";