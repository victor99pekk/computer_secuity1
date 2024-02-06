
#!/bin/bash

#   run : 
#   s file.sh
#   ./file.sh

#b: -ext
#c: 4 types of extensions

# victor pekkari (vi8011pe-s) / jack henrikson (ja2180he-s) / sebastian alders (se7024al-s) / gustaf franzen (gu8323fr-s)
# keytool -list -keystore clientkeystore -v

#-subj "/C=SE/ST=SKANE/L=LUND/O=LU/OU=LU/CN=CA/emailAddress=<MAIL>"

#create private key:
openssl genpkey -algorithm RSA -out ca.key

#create self signed certificate
openssl req -new -x509 -key ca.key -out ca.crt -subj "/C=SE/ST=SKANE/L=LUND/O=LU/OU=LU/CN=CA/emailAddress=victor.pekkari@gmail.com"

#display information about the certificate
openssl x509 -text -noout -in -CAcreateserial ca.crt

#create a truststore
keytool -import -file ca.crt -alias ca -keystore clienttruststore -storepass password -noprompt

#3
#create end-user key pair
keytool -genkeypair -keystore clientkeystore -alias clientkeystore -keyalg RSA
#keytool -genkeypair -keystore clienttruststore -alias serverkeystore -keyalg RSA

#request signing of certificate
keytool -keystore clientkeystore -certreq -alias clientkeystore -keyalg RSA -file client.csr
#keytool -keystore clienttruststore -certreq -alias serverkeystore -keyalg RSA -file client.csr


#sign the document
openssl x509 -req -days 360 -in client.csr -CA ca.crt -CAkey ca.key -out signed.crt
#openssl x509 -req -days 360 -in client.csr -CA ca.crt -CAkey ca.key -out signed.crt



#import the CA certificate chain
keytool -importcert -alias ca_import -file ca.crt -keystore clientkeystore
keytool -importcert -alias ca_signed_import -file signed.crt -keystore clientkeystore 
#keytool -importcert -trustcacerts -alias chain -file ca.crt -keystore clientkeystore