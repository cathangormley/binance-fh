
// t = table name,
// p = column cast to date and used for basis of partition,
// s = column sorted within each date,
// k = key columns: uniquely identifies record
.tab.TABLES:`t xkey update `$"|"vs'k
  from ("sss*";1#",") 0: `$.proc.configfile["tables.csv"];
