
// Do GET requests through curl system command

\d .curl

handleresponse:{[resp]
  // Header is separated from body by empty line
  d:count'[resp]?0;
  `header`body!(d#resp;.j.k raze(d+1)_resp)
 };

hget:{[endpoint]
  req:.env.BINANCEADDRESS,endpoint;
  resp:system"curl -i -s -X GET ",req;
  handleresponse resp
 };

\
.curl.hget["time"]
