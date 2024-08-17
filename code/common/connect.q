
.conn.processes:`procname xkey ("ssj*";1#",")0:`$.proc.configfile "process.csv";
update port:.proc.baseport+portoffset,h:0Ni from `.conn.processes;

// Update .conn.processes with connection handle to proc
.conn.connect:{[proc]
  // hopen and update .conn.processes
  hproc:hopen .conn.processes[proc][`port];
  .[`.conn.processes;(proc;`h);:;hproc];
 };

// Disconnect from proc and update .conn.processes
.conn.disconnect:{[proc]
  // If handle already doesn't exist, exit early
  if[null hproc:.conn.processes[proc][`h]; :(::)];
  // hclose and update .conn.processes
  hclose hproc;
  .[`.conn.processes;(proc;`h);:;0Ni];
 };

// Returns handle to proc
.conn.gethandle:{[proc]
  .conn.processes[proc][`h]
 };

// Synchronous query to proc
.conn.sync:{[proc;query]
  // If handle doesn't exist, first open connection to proc
  if[null h:.conn.processes[proc][`h];
    .conn.connect[proc];
    h:.conn.processes[proc][`h];];
  h query
 };

// Asynchronous query to proc
.conn.async:{[proc;query]
  // If handle doesn't exist, first open connection to proc
  if[null h:.conn.processes[proc][`h];
    .conn.connect[proc];
    h:.conn.processes[proc][`h];];
  neg[h] query
 };