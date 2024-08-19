
binancetrades:([]
  tptime:"p"$();
  sym:`$();
  id:"j"$();
  price:"f"$();
  qty:"f"$();
  tradetime:"p"$();
  buyermaker:"b"$();
  fhtime:"p"$()
 );

binanceaggtrades:([]
  tptime:"p"$();
  sym:`$();
  aggid:"j"$();
  price:"f"$();
  qty:"f"$();
  tradetime:"p"$();
  buyermaker:"b"$();
  fhtime:"p"$()  
 );

binancekline1s:([]
  tptime:"p"$();
  sym:`$();
  starttime:"p"$();
  open:"f"$();
  high:"f"$();
  low:"f"$();
  close:"f"$();
  volume:"f"$();
  trades:"j"$();
  fhtime:"p"$()
 );

binancekline1m:binancekline1s;
