
// For backfilling historical trades

system"sleep 1";
.bfh.symscount:0^.bfh.syms#.conn.sync[`hdb1;`.hdb.getsymcounts`];

// Get 1000 historical trades at id of symscount then update global variable
.bfh.backfilltrades:{[symbol]
  f:{[symbol;id].bfh.api.historicaltrades[symbol;id;1000]}[symbol];
  resp:raze f peach .bfh.symscount[symbol] + 1000 * til .bfh.numslaves;
  .conn.async[`histtp;(`upd;`binancetrades;value flip resp)];
  .bfh.symscount[symbol]+:1000 * .bfh.numslaves;
 };

.bfh.backfillaggtrades:{[symbol]
  f:{[symbol;id].bfh.api.historicalaggtrades[symbol;id;1000]}[symbol];
  resp:raze f peach .bfh.symscount[symbol] + 1000 * til .bfh.numslaves;
  .conn.async[`histtp;(`upd;`binanceaggtrades;value flip resp)];
  .bfh.symscount[symbol]+:1000 * .bfh.numslaves;
 };

// Add timer to backfill
{[sym]
  .timer.add[0D00:00:01;`.bfh.backfillaggtrades;enlist sym;
    "Backfill agg trades for ",string sym]
  } each .bfh.syms;
