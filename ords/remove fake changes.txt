alias details prj_rm_ords
prj_rm_ords
-----------

set define off
prompt Removing fake changes in ORDS schema...
!bash -c "cd $(git rev-parse --show-toplevel) && git restore  --worktree --staged -- dist/releases/ords "