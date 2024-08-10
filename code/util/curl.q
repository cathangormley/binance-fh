
// Do GET requests through curl system command

.curl.handleresponse:{[resp]
  // Header is separated from body by empty line
  d:count'[resp]?0;
  `header`body!(d#resp;.j.k raze(d+1)_resp)
 };

.curl.handleparameters:{[params]
  if[0=count params;:""];
  s:?[10h=type each params;params;string params];
  "?","&" sv string[key s],'"=",'value s
 };

.curl.getweight:{[header]
  str:"x-mbx-used-weight: ";
  w:where header like str,"*";
  if[0=count w;:0N];
  "J"$ssr[first header[w];str;""]
 };

.curl.getrespcode:{[header]
  "J"$ssr[header[0];"HTTP/2 ";""]
 };

.curl.hget:{[endpoint;params]
  req:.env.BINANCEADDRESS,endpoint,.curl.handleparameters params;
  resp:system"curl -i -s -X GET '",req,"'";
  .curl.handleresponse resp
 };
.curl.hget:.log.andlog[.curl.hget]

\
.curl.hget["time"]
