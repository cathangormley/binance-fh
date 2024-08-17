// Run this script to start omni

options:.Q.opt[.z.x]

if[not `baseport in key options;1"Missing required flag: baseport";exit 1];
baseport:"J"$first options[`baseport];

processes:("**j*";1#",")0:`:settings/process.csv
processes:update "|"vs' proctypes,port:string baseport+portoffset from processes

startprocess:{[proc]
  cmd:"q omni.q -baseport ",string[baseport],
    " -proctypes ",(" "sv proc[`proctypes]),
    " -procname ",proc[`procname],
    " -p ",proc[`port],
    " ",proc[`options];
  system cmd;
 };

startprocess each processes;

exit 0;