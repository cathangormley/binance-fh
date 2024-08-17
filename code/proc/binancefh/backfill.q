// For backfilling historical trades

/
.binancefh.symscount:0^.binancefh.syms#exec sym!x from
  .conn.sync[`hdb1;"select count i by sym from binancetrades"]
\
// For now, set to zero
.binancefh.symscount:{x!count[x]#0}.binancefh.syms;

// Get 1000 historical trades at id of symscount then update global variable
.binancefh.backfilltrades:{[symbol]
  resp:.binanceapi.historicaltrades[symbol;.binancefh.symscount[symbol];1000];
  resp:select sym:symbol,id,price,qty,tradetime:time, buyermaker:isBuyerMaker,fhtime:.z.p from resp;
  .conn.async[`histtp;(`upd;`binancetrades;value flip resp)];
  .binancefh.symscount[symbol]+:1000;
 };

// Add timer to backfill
{.timer.add[0D00:00:02;`.binancefh.backfilltrades;enlist[x];"Backfill for ",string x]} each .binancefh.syms;
