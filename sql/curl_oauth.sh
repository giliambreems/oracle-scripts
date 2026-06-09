curl --location 'https://gdx-acc.greenchoice.rotterdam/apex/gdx/holodeck/deliver' \
  --show-headers \
  --verbose \
  --header 'Content-Type: application/xml' \
  --header 'Authorization: Bearer xB7uXJDiuPSxwsDFCAum7A' \
  --header 'x-holodeckb2b-messageid: da314512-acd8-1a9e-c1e6-2b4933082e59@h-3fd90986e8e583ca.3fb71f9ed7935fe1' \
  --header 'x-holodeckb2b-custom: Test van Giliam' \
  --data '<xml></xml>'



curl --location 'https://gdx-acc.greenchoice.nl/holodeck/deliver' \
  --show-headers \
  --verbose \
  --header 'Content-Type: application/xml' \
  --header 'Authorization: Bearer xB7uXJDiuPSxwsDFCAum7A' \
  --header 'x-holodeckb2b-messageid: da314512-acd8-1a9e-c1e6-2b4933082e59@h-3fd90986e8e583ca.3fb71f9ed7935fe1' \
  --header 'x-holodeckb2b-custom: Test van Sander' \
  --data '<xml></xml>'



curl --location 'https://gdx-acc.greenchoice.rotterdam/apex/gdx/oauth/token' \
  --show-headers \
  --verbose \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --header 'Authorization: Basic SjNsRjRtakJOMExFREpLWXFMXzlldy4uOmZOZUJJY2lMelYxOHAxQ0ZDTFJLNncuLg==' \
  --data 'grant_type=client_credentials'



--data 'grant_type=client_credentials&client_id=J3lF4mjBN0LEDJKYqL_9ew..&client_secret=fNeBIciLzV18p1CFCLRK6w..'



curl --location 'https://gdx-acc.greenchoice.rotterdam/apex/gdx/oauth/token' \
  --verbose \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --header 'Authorization: Basic SjNsRjRtakJOMExFREpLWXFMXzlldy4uOmZOZUJJY2lMelYxOHAxQ0ZDTFJLNncuLg==' \
  --data 'grant_type=client_credentials'



curl --location 'https://gdx-acc.greenchoice.nl/oauth/token' \
  --verbose \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --header 'Authorization: Basic SjNsRjRtakJOMExFREpLWXFMXzlldy4uOmZOZUJJY2lMelYxOHAxQ0ZDTFJLNncuLg==' \
  --data 'grant_type=client_credentials'



curl --location 'https://gdx-acc.greenchoice.rotterdam/apex/gdx/holodeck/deliver' \
  --show-headers \
  --verbose \
  --header 'Content-Type: application/xml' \
  --header 'Authorization: Bearer Ml3RGIPTToEXnaSfnbSgwQ' \
  --header 'x-holodeckb2b-messageid: da314512-acd8-1a9e-c1e6-2b4933082e59@h-3fd90986e8e583ca.3fb71f9ed7935fe1' \
  --header 'x-holodeckb2b-custom: Test van Giliam' \
  --data '<xml></xml>'



curl --location 'http://www.nu.nl'



curl -i -H "Content-Type: application/xml" https://test.entsog:holodeck-b2b.com:8443/submit



select utl_raw.cast_to_varchar2(
         utl_encode.base64_encode(
           utl_raw.cast_to_raw( 'abc:def')
         )
       ) as encoded_string
from dual
/



curl --location 'https://test.entsog.holodeck-b2b.com:8443/submit' \
  --show-headers \
  --verbose \
  --header 'Content-Type: application/xml' \
  --header 'Authorization: Basic <base64_encode>' \
  --header 'X-HolodeckB2B-Pmodeid: entsog-greenchoice-edsn' \
  --data '<xml></xml>'



curl -X POST https://gdx.greenchoice.rotterdam/apex/gdx/oauth/token \
  --show-headers \
  --verbose \
  --header 'Authorization: Basic <base64 encode>'



curl -k -X POST https://gdx.greenchoice.rotterdam/apex/gdx/oauth/token \
  --show-headers \
  --verbose \
  -H 'content-type: application/x-www-form-urlencoded' \
  -d "client_id=.." \
  -d "client_secret=.." \
  -d "grant_type=client_credentials"



curl -i -k \
  --show-headers \
  --verbose \
  --user client_id:client_secret \
  --data "grant_type=client_credentials" \
  https://gdx.greenchoice.nl/oauth/token



curl -X POST \
  --show-headers \
  --verbose \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --header 'Authorization: Basic <base64 encode>' \
  --data 'grant_type=client_credentials' \
  --location 'https://gdx.greenchoice.rotterdam/apex/gdx/oauth/token'



curl -X POST \
  --show-headers \
  --verbose \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --header 'Authorization: Basic <base64_encode( client_id : client_secret )>' \
  --data 'grant_type=client_credentials' \
  --location 'https://gdx.greenchoice.rotterdam/apex/gdx/oauth/token'
