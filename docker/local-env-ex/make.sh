# This is an example of how to use the *-helper.sh scripts to build the general webapp into 
# a tomcat installation, to build a dataset-specific app into given config/data directories, and
# eventually have something that can be run by our Docker container, passing the created directory
# as a volume.
# 
# See the comments below for details.
#
# WARNING: you should run me with 'source make.sh', in order to keep env vars I define. 
#

# Where our scripts find the Tomcat home
if [[ -z "$CATALINA_HOME" ]]; then
   echo -e "\n\n\tSet CATALINA_HOME to point to Tomcat, run me with 'source'\n"
   return 2 2>/dev/null
   exit 2
fi

mydir=`pwd`

cd ../../aratiny/aratiny-docker
settings_dir=`pwd`
cd "$mydir"


# Set these as you need.

# the dataset dir. This has standard subfolders like settings/ config/ data/  
# See https://github.com/Rothamsted/knetminer/wiki/8.-Docker for details
#
knet_dataset_dir=/tmp/knetminer-sample-dataset 

# docker is the profile to be used with our scripts, local-env-ex overrides it with specific 
# settings about the directories used in this example.
# 
# TODO: I never tested -Pneo4j in this example
#
export MAVEN_ARGS="-Pdocker,local-env-ex --settings "$settings_dir/maven-settings.xml""


# Let's create the expected subdirectories. Normally, you would prepare this dir yourself.
# 
for dir in settings config data
do
	mkdir --parents "$knet_dataset_dir/$dir" || return 1
done

# Gets the test OXL. Typically, you'll already have your own and this little mess won't be needed
#
cd ../../aratiny/aratiny-ws \
&& mvn generate-test-resources \
&& cp target/dependency/poaceae-sample.oxl "$knet_dataset_dir/data/knowledge-network.oxl" \
&& cd "$mydir" \
|| return 1


cat <<EOT

	
	Now you can do things like:

cd ..
./build-helper.sh '' 'tomcat'


	And, after the above:

./runtime-helper.sh aratiny "$knet_dataset_dir"

EOT


