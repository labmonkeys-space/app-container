#!/usr/bin/env bash

OPENNMS_OVERLAY="/opt/opennms-overlay"
OPENNMS_CONFIG="/opt/opennms/etc"
OPENNMS_CONFIG_PRISTINE="/opt/opennms/share/etc-pristine"
TIMESCALEDB_ENABLED="false"
INIT_CFG_DEBUG="false"

KARAF_FILES=( \
"config.properties" \
"startup.properties" \
"custom.properties" \
"jre.properties" \
"profile.cfg" \
"jmx.acl.*" \
"org.apache.felix.*" \
"org.apache.karaf.*" \
"org.ops4j.pax.url.mvn.cfg" \
)

# Error codes
E_INIT_CONFIG=127

initOnmsEtc() {
  if [ ! "$(ls --ignore .git --ignore .gitignore -A "${OPENNMS_HOME}"/etc)"  ]; then
    echo "Initialize opennms configuration directory from etc-pristine in ${OPENNMS_HOME}/etc."
    cp -r "${OPENNMS_CONFIG_PRISTINE}/*" "${OPENNMS_CONFIG}" || exit "${E_INIT_CONFIG}"
  else
    echo "Skip initialize OpenNMS configuration directory. Use config files in ${OPENNMS_CONFIG}."
  fi
}

applyConfdTemplates() {
  echo "Apply container configuration using confd"
  confd -onetime
}

applyOverlayConfig() {
  if [ -d "${OPENNMS_OVERLAY}" ] && [ -n "$(ls -A ${OPENNMS_OVERLAY})" ]; then
    echo "Apply custom configuration from ${OPENNMS_OVERLAY}."
    # Use rsync so that we can overlay files into directories that are symlinked
    rsync -K -rl "${OPENNMS_OVERLAY}/*" "${OPENNMS_HOME}/" || exit "${E_INIT_CONFIG}"
  else
    echo "Skip sync file overlay. No files found in ${OPENNMS_OVERLAY}."
  fi
}

initConfigWithDatabase() {
  if [[ -f "${OPENNMS_CONFIG}/configured" ]]; then
    echo "Skip schema initialisation, system is already configured."
    echo "If you want to enforce the initialisation just remove the guard file ${OPENNMS_CONFIG}/configured."
  else
    echo "Karaf configuration update."
    for file in "${KARAF_FILES[@]}"; do
      echo "Update file: ${file}"
      # shellcheck disable=SC2086
      cp --force "${OPENNMS_CONFIG_PRISTINE}"/${file} "${OPENNMS_CONFIG}"/
    done

    echo "Autodetect Java environment and set JVM in ${OPENNMS_HOME}/etc/java.conf."
    "${OPENNMS_HOME}/bin/runjava" -s

    if [[ "${TIMESCALEDB_ENABLED}" == "true" ]]; then
      echo "Installing TimescaleDB extensions."
      INSTALL_ARGS="dst"
    else
      echo "Skip installing TimescaleDB extensions."
      INSTALL_ARGS="ds"
    fi

    echo "Initialize or upgrade PostgreSQL database schema and configurations."
    "${JAVA_HOME}/bin/java" -Dopennms.home="${OPENNMS_HOME}" -Dlog4j.configurationFile="${OPENNMS_CONFIG}/log4j2-tools.xml" -cp "${OPENNMS_HOME}/lib/opennms_bootstrap.jar" org.opennms.bootstrap.InstallerBootstrap ${INSTALL_ARGS} || exit "${E_INIT_CONFIG}"

    # If Newts is used initialize the keyspace with a given REPLICATION_FACTOR which defaults to 1 if unset
    if [[ "${OPENNMS_TIMESERIES_STRATEGY}" == "newts" ]]; then
      echo "Initialize Newts keyspace in Cassandra with replication factor ${REPLICATION_FACTOR-1}."
      "${JAVA_HOME}/bin/java" -Dopennms.manager.class="org.opennms.netmgt.newts.cli.Newts" -Dopennms.home="${OPENNMS_HOME}" -Dlog4j.configurationFile="${OPENNMS_CONFIG}/log4j2-tools.xml" -jar "${OPENNMS_HOME}/lib/opennms_bootstrap.jar" init -r "${REPLICATION_FACTOR-1}" || exit "${E_INIT_CONFIG}"
    else
      echo "The time series strategy ${OPENNMS_TIMESERIES_STRATEGY} is selected, skip Newts keyspace initialisation."
    fi
  fi
}

ensureFilePermissions() {
  echo "Set permissions for opennms user with UID/GID 10001"
  chown -R 10001:10001 /opt/opennms
}

testConfigs() {
  echo "Validate configuration."
  "${JAVA_HOME}/bin/java" -Dopennms.manager.class="org.opennms.netmgt.config.tester.ConfigTester" -Dopennms.home="${OPENNMS_HOME}" -Dlog4j.configurationFile="${OPENNMS_CONFIG}/log4j2-tools.xml" -jar "${OPENNMS_HOME}/lib/opennms_bootstrap.jar" -a || exit "${E_INIT_CONFIG}"
}

echo "### Start initializing or update OpenNMS configuration"
initOnmsEtc
applyConfdTemplates
applyOverlayConfig
ensureFilePermissions
if [[ "${INIT_CFG_DEBUG}" == "true" ]]; then
  echo "Debug config diff after applying the custom configuration"
  "${OPENNMS_HOME}/bin/config-diff.sh" -r "${OPENNMS_CONFIG}" -p "${OPENNMS_CONFIG_PRISTINE}"
fi
echo "### Finished initializing or update OpenNMS configuration"
