
// For logging queries

\l curl.q

.log.queries:([logid:"j"$()]time:"p"$();endpoint:`$();params:();respcode:"j"$();weight:"j"$())

.log.logid:0

// Run func[endpoint;params] and log
.log.andlog:{[func;endpoint;params]
  t:.z.p;
  r:func[endpoint;params];
  respcode:.curl.getrespcode[r`header];
  weight:.curl.getweight[r`header];
  `.log.queries insert (.log.logid;t;`$endpoint;params;respcode;weight);
  .log.logid+:1;
  r 
 }

.curl.hget:.log.andlog[.curl.hget]
