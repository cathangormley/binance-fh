system"sleep 1";

.conn.async[`histtp;(`.ps.subscribe;`binancetrades)];

upd:insert;


.wdb.en:.Q.en[hsym `$.env.HDBDIR];

.wdb.tables:("sss*";1#",") 0: `$.proc.configfile["tables.csv"];
.wdb.tables:`t xkey update `$"|"vs'k from .wdb.tables;

// n = table name, t = table, d = handle
// Saves a table t to directory (or file) d
// If f already exists, join on key colums as given by .wdb.tables
.wdb.savetable:{[n;t;d]
  t0:$[count key d;?[d;();0b;()];0#t];
  t,:t0;
  r:.wdb.tables[n];
  // t:0!select by kcols from t
  t:0!?[t;();{x!x}r`k;()];
  // t:update `p#scol from (scol;pcol) xasc t
  t:r[`s`p] xasc t;
  t:![t;();0b;enlist[r`s]!enlist[(#;1#`p;r`s)]];
  d set t;
 };


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
  .wdb.upsertdateodisk[n;t;] each exec distinct date from t;
  n set 0#value n;
 };

// n = table name, t = table, d = date
.wdb.upsertdateodisk:{[n;t;d]
  t:delete date from select from t where date=d;
  // Directory for this date's data for t
  dir:hsym `$.env.WDBDIR,string[n],"/",string[d],"/";
  .log.out["Upserting ",string[count t]," records to ",string dir];
  .wdb.savetable[n;t;dir];
 };

// Set a timer for every x minutes
.timer.add[0D00:01;`.wdb.upsertall;enlist`;"Upsert all tables to disk"];


// End of period
.wdb.saveall:{[]
  .log.out["Saving all tables to hdb"];
  .wdb.savetohdb each tables[];
 };

// n = table name
.wdb.savetohdb:{[n]
  .log.out["Saving ",string[n]," to hdb"];
  dir:hsym `$.env.WDBDIR,string[n];
  .wdb.savedatetohdb[n;] each key dir;
 };

// n = table name, d = date
.wdb.savedatetohdb:{[n;d]
  dir:.Q.dd[hsym `$.env.WDBDIR,string[n];d];
  t:select from dir;
  dest:hsym[`$.env.HDBDIR].Q.dd/(d;n;`);
  .wdb.savetable[n;t;dest];
  system"rm -r ",1_string dir;
 };

.timer.add[0D00:30;`.wdb.saveall;enlist`;"Save all tables to hdb"];
