#!/usr/bin/env bash

echo "### Startup OpenNMS Horizon"
OPENNMS_JAVA_OPTS="--add-modules=java.base,java.compiler,java.datatransfer,java.desktop,java.instrument,java.logging,java.management,java.management.rmi,java.naming,java.prefs,java.rmi,java.scripting,java.security.jgss,java.security.sasl,java.sql,java.sql.rowset,java.xml,jdk.attach,jdk.httpserver,jdk.jdi,jdk.sctp,jdk.security.auth,jdk.xml.dom \
  -Dorg.apache.jasper.compiler.disablejsr199=true
  -Dopennms.home=${OPENNMS_HOME}
  -Dopennms.pidfile=${OPENNMS_HOME}/logs/opennms.pid
  -XX:+HeapDumpOnOutOfMemoryError
  -Dcom.sun.management.jmxremote.authenticate=true
  -Dcom.sun.management.jmxremote.login.config=opennms
  -Dcom.sun.management.jmxremote.access.file=${OPENNMS_HOME}/etc/jmxremote.access
  -DisThreadContextMapInheritable=true
  -Djdk.attach.allowAttachSelf=true
  -Dgroovy.use.classvalue=true
  -Djava.io.tmpdir=${OPENNMS_HOME}/data/tmp
  -Djava.locale.providers=CLDR,COMPAT
  -XX:+StartAttachListener"
  exec "${JAVA_HOME}/bin/java ${OPENNMS_JAVA_OPTS} ${JAVA_OPTS} -jar ${OPENNMS_HOME}/lib/opennms_bootstrap.jar start"
