# Modo standalone
java -jar wiremock-jre8-standalone-2.34.0.jar --port 9000 

# Grabar mapping
# java -jar wiremock-jre8-standalone-2.34.0.jar --port 8080 --proxy-all http://localhost:9000 --record mappings
# y pegarle a localhost:8080/ desde Insomnia