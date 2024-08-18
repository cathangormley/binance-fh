
// Pivot table t with key k, pivot p on v
.piv.piv:{[t;k;p;v]
  f:{[v;P]`$raze each string raze P[;0],'/:v,/:\:P[;1]};
  v:(),v;k:(),k;p:(),p;t:0!t;
  G:group flip k!(t:.Q.v t)k;
  F:group flip p!t p;
  P:flip value flip key F;
  key[G]!flip f[v;P]!raze
    {[i;j;k;x;y]
      a:count[x]#x 0N;
      a[y]:x y;
      b:count[x]#0b;
      b[y]:1b;
      c:a i;
      c[k]:first'[a[j]@'where'[b j]];
      c
     }[I[;0];I J;J:where 1<>count'[I:value G]]/:\:[t v;value F]};

\
t:select cnt:count i by date,sym from binanceaggtrades;
.piv.piv[t;`date;`sym;`cnt]