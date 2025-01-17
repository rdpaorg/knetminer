# Used in RRes resources, to CI-deploy test containers
# from DockerHub, after they've beeen updated.
#
set -e # Stop upon the first problem

dataset_dir=/opt/data/knetminer-datasets/wheat-ci
host_port=9100
jmx_port=9010
rmi_port=9011
debug_port=5005

# Used below with JMX options. Our security policies require password-protected JMX
# This file is available on our test servers. In other environments, this will make the JVM to exit immediately, together with
# the Docker container (unless, of course, you create a similar file)
#
# TODO: maybe, at some point we will try a safer environment-injected credentials, which would
# require a custom authenticator: https://stackoverflow.com/a/21166202/529286
# 
jmx_user_path=/opt/config/jmx.user

cd "$(dirname $0)"
my_dir=$(pwd)

cd ../docker

echo -e "\n\n\tPreparing the environment\n"

# Don't work with regular users.
#wall -n <<EOT
#*** WARNING: Continuous Integration is going to update Docker images ***
#
#In few minutes, existing unused images will be DELETED.
#The container named wheat-ci will be restarted.
#EOT

echo -e "--- Stopping, cleaning and updating Docker\n"
docker stop wheat-ci || true
docker rm wheat-ci || true
docker system prune --all --force
docker volume prune --force
docker pull knetminer/knetminer

echo -e "--- Cleaning Knetminer dataset directory\n"
./cleanup-volume.sh --all "$dataset_dir"


# Options to setup JMX and use jvisualvm. this makes jvisualvm accessible on 9010 (RMI on 9011), you can start jvisualvm from the
# host and connect these ports (or you can use tricks like SSH tunnelling). Clearly, every new container needs its own ports.
#

export JAVA_TOOL_OPTIONS="-Dcom.sun.management.jmxremote.ssl=false
	-Dcom.sun.management.jmxremote.authenticate=true
	-Dcom.sun.management.jmxremote.password.file=$jmx_user_path
 	-Dcom.sun.management.jmxremote.port=$jmx_port
 	-Dcom.sun.management.jmxremote.rmi.port=$rmi_port
 	-Djava.rmi.server.hostname=localhost
 	-Dcom.sun.management.jmxremote.local.only=false"
# and these can be used for debugging
export JAVA_TOOL_OPTIONS="$JAVA_TOOL_OPTIONS -Xdebug -Xnoagent
	-Djava.compiler=NONE
  -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=*:$debug_port"

# If you set the JAVA_TOOL_OPTIONS var, you DO NEED some memory option too, in order to avoid
# limited defaults
export JAVA_TOOL_OPTIONS="$JAVA_TOOL_OPTIONS -XX:MaxRAMPercentage=90.0 -XX:+UseContainerSupport -XX:-UseCompressedOops"
export DOCKER_OPTS="-it"
for port in $jmx_port $rmi_port $debug_port
do
	 DOCKER_OPTS="$DOCKER_OPTS -p $port:$port"
done
DOCKER_OPTS="$DOCKER_OPTS --volume $jmx_user_path:$jmx_user_path"

memory='70G'
# else the same $memory amount is used for swap and that doesn't play very well with our servers.
mem_swap='90G'

# Let's use the two Docker servers for two different test instances
#
if [[ "$(hostname)" =~ 'babvs72' ]]; then
	echo -e "\n\n\t(Re)launching Docker, Cypher-based traverser\n"

	dataset_id="wheat-directed"
	docker_run_opts="--with-neo4j --neo4j-url bolt://babvs65.rothamsted.ac.uk:7688 
		--neo4j-user rouser --neo4j-pwd rouser"
	# Enables the Cypher Debugger, to profile Cypher queries
	# WARNING: this is a SERIOUS security hole and we keep it on ONLY for this internal instance 
	export MAVEN_ARGS="-Dknetminer.backend.cypherDebugger.enabled=true"
	
  memory='80G'
	mem_swap='100G'
	
else
		echo -e "\n\n\t(Re)launching Docker, state machine-based traverser\n"
		dataset_id="wheat-beta"
fi

./docker-run.sh \
  --dataset-id "$dataset_id" --container-name wheat-ci \
  --dataset-dir "$dataset_dir" --host-port $host_port \
  --container-memory $memory --container-memory-swap $mem_swap \
  $docker_run_opts \
  --detach

# TODO: as a minimum, check it's up via wget, later run scripts that check sensible results are returned
echo -e "\n\n\The End\n"
