
// For backfilling historical trades

system"sleep 1";
.bfh.symcounts:0^.bfh.syms#.conn.sync[`hdb1;`.hdb.getsymcounts`];

// Get 1000 historical trades at id of symcounts then update global variable
.bfh.backfilltrades:{[symbol]
  f:{[symbol;id].bfh.api.historicaltrades[symbol;id;1000]}[symbol];
  resp:raze f peach .bfh.symcounts[symbol] + 1000 * til .bfh.numslaves;
  .conn.async[`histtp;(`upd;`binancetrades;value flip resp)];
  .bfh.symcounts[symbol]+:1000 * .bfh.numslaves;
 };

.bfh.backfillaggtrades:{[symbol]
  f:{[symbol;id].bfh.api.historicalaggtrades[symbol;id;1000]}[symbol];
  resp:raze f peach .bfh.symcounts[symbol] + 1000 * til .bfh.numslaves;
  .conn.async[`histtp;(`upd;`binanceaggtrades;value flip resp)];
  .bfh.symcounts[symbol]+:1000 * .bfh.numslaves;
 };

// For now set start times to 2017.08.01D0
.bfh.klinesymtimes:{x!count[x]#2017.08.01D0}[.bfh.syms]

// Back fill for binancekline1m
.bfh.backfillkline1m:{[symbol]
  f:{[symbol;st].bfh.api.kline[symbol;st;`1m;1000]}[symbol];
  resp:raze f peach .bfh.klinesymtimes[symbol] +
    0D00:01 * 1000 * til .bfh.numslaves;
  .conn.async[`histtp;(`upd;`binancekline1m;value flip resp)];
  .bfh.klinesymtimes[symbol]+:0D00:01 * 1000 * .bfh.numslaves;
 };

// Back fill for binancekline1s
.bfh.backfillkline1s:{[symbol]
  f:{[symbol;st].bfh.api.kline[symbol;st;`1s;1000]}[symbol];
  resp:raze f peach .bfh.klinesymtimes[symbol] +
    0D00:00:01 * 1000 * til .bfh.numslaves;
  .conn.async[`histtp;(`upd;`binancekline1s;value flip resp)];
  .bfh.klinesymtimes[symbol]+:0D00:00:01 * 1000 * .bfh.numslaves;
 };

// Add timer to backfill
{[sym]
  .timer.add[0D00:00:01;`.bfh.backfillkline1s;enlist sym;
    "Backfill kline 1m for ",string sym]
  } each .bfh.syms;
