
// A list of tables and which handles are subscribed
.ps.subscribers:tables[]!();

// t is a table name (or ~ for all tables), w is handle
// Add w to subscribers for t
.ps.sub:{[t;w]
  if[t~`;:.ps.sub[;w]each tables[];];
  .ps.subscribers:@[.ps.subscribers;t;w union];
 };

// t is a table name (or ~ for all tables), w is handle
// Remove w to subscribers for t
.ps.unsub:{[t;w]
  if[t~`;:.ps.unsub[;w]each tables[];];
  .ps.subscribers:@[.ps.subscribers;t;except[;w]];
 };

// t is a table name, x is one or more records
.ps.upd:{[t;x]
  // Stamp tstime onto x
  x:enlist[count[x 0]#.z.p],x;
  // Publish x as a table; we won't assume the subscriber has the schema
  x:cols[value t]!x;
  x:$[1<count[first x];flip x;enlist x];
  .ps.pub[t;x];
 };

.ps.pub:{[t;x]
  // Async broadcast, only need to serialise once
  -25!(.ps.subscribers[t];(`upd;t;x));
 };

// Subscribers call this function
.ps.subscribe:{.ps.sub[x;.z.w]};

upd:.ps.upd;