
#3
#create end-user key pair
keytool -genkeypair -keystore serverkeystore -alias server -keyalg RSA

#request signing of certificate
keytool -keystore serverkeystore -certreq -alias server -keyalg RSA -file server.csr

#sign the document
openssl x509 -req -days 360 -in server.csr -CA ca.crt -CAkey ca.key -out server_signed.crt

#import the CA certificate chain
keytool -importcert -alias serverkeystore -file server_signed.crt -keystore serverkeystore 


#create a truststore
keytool -import -file ca.crt -alias ca_server -keystore servertruststore -storepass password -noprompt