
// Returns aggid to begin back fill at
.hdb.getsymcounts:{[]
  symcounts:select cnt:count aggid,m:min aggid by date,sym from binanceaggtrades;
  symcounts:update cumcnt:0^prev sums cnt by sym from symcounts;  
  exec last[m] by sym from symcounts where m=cumcnt
 };