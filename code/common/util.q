
.util.fromunix:{[unixtimes]1970.01.01D0 + 0D00:00:00.001 * "j"$unixtimes};

.util.tounix:{[times]"j"$(times - 1970.01.01D0) % 0D00:00:00.001};