
.bfh.stamp:{update fhtime:.z.p from x};

// Binance specific API calls

.bfh.api.time:{[]
  .util.fromunix .curl.hget["time";()][`body][`serverTime]
 };

.bfh.api.symbols:{[]
  .curl.hget["exchangeInfo";()][`body][`symbols]
 };

.bfh.api.ratelimits:{[]
  .curl.hget["exchangeInfo";()][`body][`rateLimits]
 };

// Returns historical trades of symbol with id = id + til limit
.bfh.api.historicaltrades:{[symbol;id;limit]
  dict:`symbol`fromId`limit!(symbol;id;limit);
  resp:.curl.hget["historicalTrades";dict][`body];
  .bfh.stamp select sym:symbol,"j"$id,"F"$price,"F"$qty,
    tradetime:.util.fromunix time,buyermaker:isBuyerMaker from resp
 };

// Returns 'limit' number of recent trades of symbol
.bfh.api.recenttrades:{[symbol;limit]
  resp:.curl.hget["trades";`symbol`limit!(symbol;limit)][`body];
  .bfh.stamp select sym:symbol,"j"$id,"F"$price,"F"$qty,
    tradetime:.util.fromunix time,buyermaker:isBuyerMaker from resp
 };

// Returns historical agg trades of symbol with aggid = id + til limit
.bfh.api.historicalaggtrades:{[symbol;id;limit]
  resp:.curl.hget["aggTrades";`symbol`fromId`limit!(symbol;id;limit)][`body];
  .bfh.stamp .bfh.stamp select sym:symbol,aggid:"j"$a,price:"F"$p,qty:"F"$q,
    tradetime:.util.fromunix T,buyermaker:m from resp
 };