
.hdb.rack:{[dt;dur;tab;tcol]
  q:select from tab where date=dt;
  syms:exec sym from select distinct sym from tab;
  rack:(`sym;tcol)!/:syms cross dt+dur*1+til ceiling 1D % dur;
  // update racktime:tcol from rack
  rack:![rack;();0b;enlist[`racktime]!enlist[tcol]];
  aj0[(`sym;tcol);rack;q]
 };

\
.hdb.rack[2017.12.12;0D00:00:01;`binancetrades;`tradetime]