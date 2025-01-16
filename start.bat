chcp 65001
set "JBOSS_JAVA_SIZING=-Xms512M -Xmx1024M -XX:MetaspaceSize=96M -XX:MaxMetaspaceSize=256m"
start S:\wildfly-26.1.3.Final\bin\standalone.bat -c=standalone.xml --debug
