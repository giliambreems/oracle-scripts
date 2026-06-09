select aap.aap_aae_ean
,      aap_begindatum -- aap.aap_begindatum
,      aap_einddatum  -- aap.aap_einddatum
,      aap.aap_ber_uuid
,      aap.aap_aab_id
,      aap.aap_aaa_id
,      aap.aap_amp_id
,      aap.aap_ame_id
,      aap.aap_asj_id
, aap.*
from   FP_DATA.aap_aansluiting_periode aap
where aap.aap_begindatum >= date '2024-09-01'
order by aap.aap_aae_ean, aap.aap_aangemaakt_datum
/

-- SELECT statement controleren!!
select aap.aap_aae_ean
,      date '2024-09-01' as aap_begindatum -- aap.aap_begindatum
,      aap.aap_begindatum as aap_einddatum  -- aap.aap_einddatum
,      aap.aap_ber_uuid
,      aap.aap_aab_id
,      aap.aap_aaa_id
,      aap.aap_amp_id
,      aap.aap_ame_id
,      aap.aap_asj_id
from   FP_DATA.aap_aansluiting_periode aap
where aap.aap_begindatum > date '2024-09-01'
and not exists
( select 2
  from   FP_DATA.aap_aansluiting_periode aap2
  where aap2.aap_begindatum = date '2024-09-01'
  and   aap2.aap_aae_ean = aap.aap_aae_Ean
)
/

-- INSERT uitvoeren
insert into FP_DATA.aap_aansluiting_periode aap
  ( aap.aap_aae_ean, aap.aap_begindatum, aap_einddatum, aap.aap_ber_uuid, aap.aap_aab_id, aap.aap_aaa_id, aap.aap_amp_id, aap.aap_ame_id, aap.aap_asj_id )
select aap.aap_aae_ean
,      date '2024-09-01' as aap_begindatum -- aap.aap_begindatum
,      aap.aap_begindatum as aap_einddatum  -- aap.aap_einddatum
,      aap.aap_ber_uuid
,      aap.aap_aab_id
,      aap.aap_aaa_id
,      aap.aap_amp_id
,      aap.aap_ame_id
,      aap.aap_asj_id
from   FP_DATA.aap_aansluiting_periode aap
where aap.aap_begindatum > date '2024-09-01'
and not exists
( select 2
  from   FP_DATA.aap_aansluiting_periode aap2
  where aap2.aap_begindatum = date '2024-09-01'
  and   aap2.aap_aae_ean = aap.aap_aae_Ean
)
/

commit
/


select * from ber_bericht
order by ber_id desc;

select * from ber_bericht ber
where ber_uuid = '5bfe1658-12db-46fb-9874-0d4353cee8b3' or ber_uuid = '08690128-fd6f-477d-b90c-5c62245578f1'
/

select * from fp_Data.coa_contract_Aansluiting
/

select * from aaa_aansluiting_adres;
select * from aab_aansluiting_basis;
select * from aae_aansluiting_ean;
select * from aap_aansluiting_periode;
select * from ame_aansluiting_meter;
select * from amp_aansluiting_marktpartij;
select * from asj_aansluiting_sji_sja;

select * from con_contract;
select * from coa_contract_aansluiting;



-- !! Reeds uitgevoerd voor aap_id = 1 !!
insert into FP_DATA.aap_aansluiting_periode aap
  ( aap.aap_aae_ean, aap.aap_begindatum, aap_einddatum, aap.aap_ber_uuid, aap.aap_aab_id, aap.aap_aaa_id, aap.aap_amp_id, aap.aap_ame_id, aap.aap_asj_id )
select aap.aap_aae_ean
,      date '2024-09-01' as aap_begindatum -- aap.aap_begindatum
,      date '2024-09-03' as aap_einddatum  -- aap.aap_einddatum
,      aap.aap_ber_uuid
,      aap.aap_aab_id
,      aap.aap_aaa_id
,      aap.aap_amp_id
,      aap.aap_ame_id
,      aap.aap_asj_id
from   FP_DATA.aap_aansluiting_periode aap
where  aap.aap_id = 1
/


select substr( 'International Solar Projects X B.V.', 1, 24)
from dual