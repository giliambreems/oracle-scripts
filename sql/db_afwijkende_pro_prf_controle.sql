select coa.coa_id, coa.coa_aae_ean, coa.coa_begindatum, coa.coa_einddatum, con.con_id, con.con_omschrijving, pro.pro_code, pro.pro_omschrijving, prf.prf_soort_tarief
from   coa_contract_aansluiting coa
  join con_contract con on con.con_id = coa.coa_con_id
  join pro_propositie pro on pro.pro_id = con.con_pro_id
  join prf_propositie_fase prf on prf.prf_id = coa.coa_prf_id
where not exists
  ( select 1
    from   prf_propositie_fase prf
      join  pro_propositie pro on pro.pro_id = prf.prf_pro_id
    where  prf.prf_id = coa.coa_prf_id
    and    pro.pro_id = con.con_pro_id )
/
