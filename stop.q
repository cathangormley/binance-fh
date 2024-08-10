// Run this script to stop omni

options:.Q.opt[.z.x]

if[not `baseport in key options;1"Missing required flag: baseport";exit 1];
baseport:"J"$first options[`baseport];

pids:system"pgrep -f 'q omni.q -baseport ",string[baseport],"'";
{system "kill ",x} each -1_pids;

pids:system"pgrep -f 'q omni.q -baseport ",string[baseport],"'";
{system "kill -9 ",x} each -1_pids;

exit 0;