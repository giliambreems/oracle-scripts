select ipl.ipl_profiel
from   fg_data.ipl_import_profiel ipl
where  ipl_id = 1
/

-- Get csv profile from database and parse
select *
from table(
            apex_data_parser.get_columns
            (
                 ( select ipl.ipl_profiel
                   from   fg_data.ipl_import_profiel ipl
                   where  ipl_id = 1
                 )
            )
          )
/


select imp_col001 as SOORTKLANT
,      imp_col002 as BEDRIJFSNAAM
from   imp_import
/

select 'select ' || listagg( 'imp_col' || lpad(column_position, 3, 0) || ' as ' || column_name , ', ') || ' from imp_import'
from table(
            apex_data_parser.get_columns
            (
                 ( select ipl.ipl_profiel
                   from   fg_data.ipl_import_profiel ipl
                   where  ipl_id = 1
                 )
            )
          )
/

select imp_col001 as SOORTKLANT, imp_col002 as BEDRIJFSNAAM, imp_col003 as KLANTNUMMER, imp_col004 as OVEREENKOMSTID, imp_col005 as SUBOVID, imp_col006 as AFWIJKENDEAANSPREEKTITEL, imp_col007 as VOORLETTERS, imp_col008 as VOORNAAM, imp_col009 as TUSSENVOEGSEL, imp_col010 as ACHTERNAAM, imp_col011 as GESLACHT, imp_col012 as KVKNR, imp_col013 as IBAN, imp_col014 as NAAM_REKENINGHOUDER, imp_col015 as REFERENTIEBRON, imp_col016 as BIJZONDERHEDEN_KLANTGEGEVENS, imp_col017 as EFACTURATIE, imp_col018 as EMAIL, imp_col019 as TELEFOON, imp_col020 as GEBOORTEDATUM, imp_col021 as KENMERK, imp_col022 as SEGMENT, imp_col023 as FACTURATIEFREQUENTIE, imp_col024 as KLANTSTATUS, imp_col025 as NIEUWSBRIEF_DIGITAAL, imp_col026 as WILGEENNIEUWSBRIEF, imp_col027 as PRIVAAT_NETWERK, imp_col028 as EAN, imp_col029 as STRAAT, imp_col030 as HUISNUMMER, imp_col031 as TOEVOEGSEL, imp_col032 as POSTCODE, imp_col033 as PLAATS, imp_col034 as KALENDERJAAR, imp_col035 as AFREKENMAAND_GC, imp_col036 as WILCREDITNOTAONTVANGEN, imp_col037 as WILTERMIJNNOTAONTVANGEN, imp_col038 as FACTUURADRES_STRAAT, imp_col039 as FACTUURADRES_HUISNR, imp_col040 as FACTUURADRES_TOEVOEGSEL, imp_col041 as FACTUURADRES_POSTCODE, imp_col042 as FACTUURADRES_PLAATS, imp_col043 as FACTUURADRES_ADRESBUITENLAND, imp_col044 as VERKLARING_HERNIEUWBAREBRONNEN, imp_col045 as HERNIEUWBAREBRONNEN_BEGINDATUM, imp_col046 as HERNIEUWBAREBRONNEN_EINDDATUM, imp_col047 as HERNIEUWBAREBRONNEN_ONDERTEKENDOP, imp_col048 as HERNIEUWBAREBRONNEN_ONTVANGENOP, imp_col049 as HERNIEUWBAREBRONNEN_VERWERKTOP, imp_col050 as VERKLARING_SELFBILLING, imp_col051 as SELFBILLING_BEGINDATUM, imp_col052 as SELFBILLING_EINDDATUM, imp_col053 as SELFBILLING_ONDERTEKENDOP, imp_col054 as SELFBILLING_ONTVANGENOP, imp_col055 as SELFBILLING_VERWERKTOP, imp_col056 as REFERENTIE, imp_col057 as DATUM_INGANG_OVK, imp_col058 as DATUM_EIND_OVK, imp_col059 as PRODUCTID, imp_col060 as CONTRACT_ENKEL_TARIEF, imp_col061 as CONTRACT_HOOG_TARIEF, imp_col062 as CONTRACT_LAAG_TARIEF, imp_col063 as CONTRACT_ENKEL_TERUGLV, imp_col064 as CONTRACT_HOOG_TERUGLV, imp_col065 as CONTRACT_LAAG_TERUGLV, imp_col066 as TERUGLEVERVERGOEDING, imp_col067 as TERUGLEVERINGVOLUMEGRENSINKWH, imp_col068 as MARGE, imp_col069 as ISVARIABELTARIEF, imp_col070 as CONTRACT_VASTRECHT, imp_col071 as CONTRACT_VASTRECHT_PER_DAG, imp_col072 as OMZETTENVASTEPRIJS, imp_col073 as OMZETTENNAARPRODUCTCLUSTER, imp_col074 as MARKTSEGMENT, imp_col075 as MARKTSEGMENT_STAMGEGEVENS, imp_col076 as PROFIEL, imp_col077 as LEVERINGSRICHTING, imp_col078 as MEETMETHODE, imp_col079 as EDSN_SJV_NORMAAL, imp_col080 as EDSN_SJV_DAL, imp_col081 as EDSN_SJT_NORMAAL, imp_col082 as EDSN_SJT_DAL, imp_col083 as OPWEK_SOORT, imp_col084 as SCHAALGROOTTE, imp_col085 as PPA_EAN, imp_col086 as PPA_INDEX_PRICE, imp_col087 as PPA_MIN_CONTRACT_START, imp_col088 as PPA_MAX_CONTRACT_EIND, imp_col089 as PPA_TOTAAL_VOLUME, imp_col090 as EANHEEFTPPA, imp_col091 as SCHAALGROTTE_OPWEK, imp_col092 as PRODUCENT_TEAM, imp_col093 as COMMODITY_TYPE, imp_col094 as MIGRATIE_BATCH, imp_col095 as PRODUCER_NAME, imp_col096 as COMPANY_NAME, imp_col097 as ETRM_DEAL_ID, imp_col098 as NIEUWE_ENERGIELEVERANCIER, imp_col099 as PRODUCT_REFERENTIE_NAAM, imp_col100 as BTWNUMMER, imp_col101 as PV_EAN, imp_col102 as FLUX_CONTRACT_OMSCHRIJVING, imp_col103 as COA_BEGIN_DATUM, imp_col104 as COA_EIND_DATUM, imp_col105 as FLUX_PROPOSITIE, imp_col106 as FLUX_PROPOSITIE_FASE, imp_col107 as FLUX_OPWEK_TYPE from imp_import
/

-- todo 
begin

  cursor for  'select 1 from dual'
  
  
end;