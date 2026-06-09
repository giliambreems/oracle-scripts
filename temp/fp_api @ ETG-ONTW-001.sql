select *
from   user_ords_clients
/

-- 'SnNhaldFN3BWQ1c4WWd3Um5ZYy1HUS4uOjZYZTI1RTZxdmtCWE1IVzFUVG1JaWcuLg=='
select utl_raw.cast_to_varchar2(utl_encode.base64_decode(utl_raw.cast_to_raw('SnNhaldFN3BWQ1c4WWd3Um5ZYy1HUS4uOjZYZTI1RTZxdmtCWE1IVzFUVG1JaWcuLg=='))) from dual
/

select utl_raw.cast_to_varchar2(utl_encode.base64_decode(utl_raw.cast_to_raw('aFZWbGx5Sm5HaTNRRUpPQUJpUGZ0dy4uOkgtcndXVXp2LXdvZkEzeFZRLW5zVXcuLg=='))) from dual
/

set serveroutput on
declare
  cs_carriage_return constant char(1) := chr(13);  -- 0D in hexadecimal, 13 in decimal, Carriage Return (CR)
  cs_line_feed       constant char(1) := chr(10);  -- 0A in hexadecimal, 10 in decimal, Line Feed (LF)
 
 function base64_encode (
    pi_string varchar2,
    pi_crlf   char default 'Y'
  ) return varchar2
  ------------------------------------------------------------------------------------------------------------------------------------
  -- Purpose: This function converts a string to Base64 format.
  ------------------------------------------------------------------------------------------------------------------------------------
  --
  -- Changes:
  -- Version  Date       Author            PBI       Description
  -- ------  ----------  ----------------  --------  ---------------------------------------------------------------------------------
  -- 1.0     01-12-2025  Oscar Slee        210766    Copy from DGS, with modifications
  -- 1.1     19-02-2026  Oscar Slee        210766    Because UTL_ENCODE.BASE64_ENCODE automatically inserts line breaks (CR/LF),
  --                                                 usually every 64 or 76 characters, the authorization does not work correctly.
  --                                                 To prevent this, the (CR/LF) must be removed in hexadecimal.
  -- 1.2     11-03-2026  Giliam Breems     210766    Added option to keep or remove CR/LF characters in the encoded string.
  ------------------------------------------------------------------------------------------------------------------------------------
   is
    raw_encoded_string raw(32767);
  begin
    raw_encoded_string := utl_encode.base64_encode(utl_raw.cast_to_raw(pi_string));
    if pi_crlf = 'N' then
      raw_encoded_string := hextoraw(replace(
        replace(
          rawtohex(raw_encoded_string),
          rawtohex(utl_raw.cast_to_raw(cs_carriage_return))
        ),
        rawtohex(utl_raw.cast_to_raw(cs_line_feed))
      ));

    end if;

    return utl_raw.cast_to_varchar2(raw_encoded_string);
  end base64_encode;
begin
  dbms_output.put_line( 'base64: ' || base64_encode('hVVllyJnGi3QEJOABiPftw..' || ':' || 'H-rwWUzv-wofA3xVQ-nsUw..', 'N' ));
end;
/
