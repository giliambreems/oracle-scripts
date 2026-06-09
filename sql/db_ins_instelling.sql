select *
from   fg_data.ins_instelling ins
where  ins.ins_omgeving in ('ACC','PREP','PRD')
order by ins_code, decode( ins_omgeving, 'ONTW', 10, 'TST', 30, 'ACC', 40, 'PREP', 50, 'PRD', 60, 99)
/

--pivot

