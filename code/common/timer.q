// Script for handling timer functions

.timer.id:0
.timer.getnewid:{:.timer.id+:1;}

.timer.timer:([]
  id:"j"$();
  period:"n"$();
  func:"s"$();
  params:();
  nextrun:"p"$();
  active:"b"$();
  description:());

// Add a repeating timer
.timer.add:{[period;func;params;description]
  id:.timer.getnewid[];
  .timer.timer,:(id;period;func;params;.z.p;1b;description);
 };

// Turn on timer
.timer.enableid:{update active:1b from `.timer.timer where id=x};
// Turn off timer
.timer.disableid:{update active:0b from `.timer.timer where id=x};


// Run each scheduled timer
.timer.run:{[ts]
  torun:select from .timer.timer where active,nextrun<ts;
  .timer.runandreschedule each torun;
 };

// Run job and update nextrun
.timer.runandreschedule:{[job]
  job[`func] . job[`params];
  update nextrun:.z.p+job[`period] from `.timer.timer where id=job[`id];
 };


.z.ts:{.timer.run[x]};

system"t 100"