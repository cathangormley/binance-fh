
// Run this script to build deploy.sh
.env.APPDIR:"/" sv -1 _ "/" vs first -3#value[{}]

// Dynamically replace all instances of @VAR@ with .env.VAR for all variables in .env
build:{[file]
  s:read0 file;
  s:s{ssr[;"@",string[y],"@";.env y]each x}/key 1_.env;
  file 0: s;
 };

build `:bin/deploy.sh;

exit 0;