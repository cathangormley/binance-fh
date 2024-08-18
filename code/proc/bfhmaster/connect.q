.bfh.slavehandles:.conn.connect'[exec procname from .conn.processes
  where string[proctypes] like "*bfhslave*"];

.bfh.numslaves:count .bfh.slavehandles;

.z.pd:`u#.bfh.slavehandles;