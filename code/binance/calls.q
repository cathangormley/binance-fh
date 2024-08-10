// Binance specific API calls

.binanceapi.time:{[]
  .util.fromunix .curl.hget["time";()][`body][`serverTime]
 };

.binanceapi.symbols:{[]
  .curl.hget["exchangeInfo";()][`body][`symbols]
 };

.binanceapi.ratelimits:{[]
  .curl.hget["exchangeInfo";()][`body][`rateLimits]
 };

// Returns historical trades of symbol with id = id + til limit
.binanceapi.historicaltrades:{[symbol;id;limit]
  resp:.curl.hget["historicalTrades";`symbol`fromId`limit!(symbol;id;limit)][`body];
  update "j"$id,"F"$price,"F"$qty,"F"$quoteQty,.util.fromunix time from resp
 };

// Returns 'limit' number of recent trades of symbol
.binanceapi.recenttrades:{[symbol;limit]
  resp:.curl.hget["trades";`symbol`limit!(symbol;limit)][`body];
  update "j"$id,"F"$price,"F"$qty,"F"$quoteQty,.util.fromunix time from resp
 };

\
getmoretrades:{[sym]
  maxid:@[{exec max id from trades where symbol=x};sym;0];
  resp:.binanceapi.historicaltrades[sym;maxid+1;1000];
  `trades insert resp;
 };

.timer.add[0D00:00:03;`getmoretrades;enlist`BTCUSDT;"Get historical BTCUSDT trades"];