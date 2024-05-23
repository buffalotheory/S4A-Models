#!/bin/bash
# Bryant Hansen

# Compare log files of 2 different runs
#   - View side-by-side
#   - Remove non-printable characters
#   - Use syntax highlighting on the shell level

# Conditions:
#  - Assumes both files are compressed via xz

# Initial 1-liner:
# diff --side-by-side -W200 <(xzcat logs/20240523_143406_run_overfit_convlstm.log.xz | tr -cd '[:print:]\n') <(xzcat logs/20240523_144005_run_multiset_convlstm.log.xz | tr -cd '[:print:]\n') | colordiff

log1="$1"
log2="$2"

diff --side-by-side -W200 \
	<(xzcat "$log1" | tr -cd '[:print:]\n') \
	<(xzcat "$log2" | tr -cd '[:print:]\n') \
| colordiff \
| less -R
