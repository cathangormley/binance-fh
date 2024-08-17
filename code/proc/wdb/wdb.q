system"sleep 1";

.conn.async[`histtp;(`.ps.subscribe;`binancetrades)];

upd:insert;


.wdb.en:.Q.en[hsym `$.env.HDBDIR];

.wdb.tables:("sss*";1#",") 0: `$.proc.configfile["tables.csv"];
.wdb.tables:`t xkey update `$"|"vs'k from .wdb.tables;

// Upsert all tables
.wdb.upsertall:{[]
  .log.out["Upserting all tables"];
  .wdb.upserttodisk each tables[];
 };

// n = table name
.wdb.upserttodisk:{[n]
  .log.out["Upserting ",string[n]," to disk"];
  t:.wdb.en value n;
  pcol:.wdb.tables[n][`p];
  // t:update date:`date$pcol from t
  t:![t;();0b;enlist[`date]!enlist[($;1#`date;pcol)]];
  t:`date xasc t;
  .wdb.upserttodiskdate[n;t;] each exec distinct date from t;
  n set 0#value n;
 };

// n = table name, t = table, d = date
.wdb.upserttodiskdate:{[n;t;d]
  t:delete date from select from t where date=d;
  // Directory for this date's data for t
  dir:hsym `$.env.WDBDIR,string[n],"/",string[d],"/";
  .log.out["Upserting ",string[count t]," records to ",string dir];
  // dir might not be empty
  t0:$[count key dir;?[dir;();0b;()];0#t];
  t,:t0;
  // t:0!select by kcols from t
  kcols:.wdb.tables[n][`k];
  t:0!?[t;();{x!x}kcols;()];
  // t:update `p#scol from scol xasc t
  scol:.wdb.tables[n][`s];
  t:scol xasc t;
  t:![t;();0b;enlist[scol]!enlist[(#;1#`p;scol)]];
  dir set t;
 };

// Set a timer for every x minutes
.timer.add[0D00:01;`.wdb.upsertall;enlist`;"Upsert all tables"];
