# removing UF, dashbuilder and KIE artifacts from local maven repo (basically all possible SNAPSHOTs)
if [ -d $MAVEN_REPO_LOCAL ]; then
    rm -rf $MAVEN_REPO_LOCAL/org/jboss/dashboard-builder/
    rm -rf $MAVEN_REPO_LOCAL/org/kie/
    rm -rf $MAVEN_REPO_LOCAL/org/drools/
    rm -rf $MAVEN_REPO_LOCAL/org/jbpm/
    rm -rf $MAVEN_REPO_LOCAL/org/optaplanner/
    rm -rf $MAVEN_REPO_LOCAL/org/guvnor/
    
fi

# removes all created /tmp/ files by the user
find /tmp -maxdepth 1 -user `whoami` -exec rm -rf {} \;

# clone the build-bootstrap that contains the other build scripts

#git clone git@github.com:droolsjbpm/droolsjbpm-build-bootstrap.git --branch $RELEASE_BRANCH
# this is a temporarily change and has to be removed when script gets copied into droolsjbpm-build-bootstrap.
# the previous line should enabled
git clone git@github.com:michibk/droolsjbpm-build-bootstrap.git --branch $RELEASE_BRANCH   
# clone rest of the repos and checkout to this branch
./droolsjbpm-build-bootstrap/script/git-clone-others.sh --branch $RELEASE_BRANCH --depth 100 

# fetch the <version.org.kie> from kie-parent-metadata pom.xml and set it on parameter KIE_VERSION
cd droolsjbpm-build-bootstrap
KIE_VERSION=$(sed -e 's/^[ \t]*//' -e 's/[ \t]*$//' -n -e 's/<version.org.kie>\(.*\)<\/version.org.kie>/\1/p' pom.xml)
cd ..

# build release branches

DEPLOY_DIR=$WORKSPACE/Deploy_dir

# (1) do a full build, but deploy only into local dir
# we will deploy into remote staging repo only once the whole build passed (to save time and bandwith)   
./droolsjbpm-build-bootstrap/script/mvn-all.sh -B -e -U clean deploy -Dfull -Drelease -T1C -DaltDeploymentRepository=local::default::file://$DEPLOY_DIR -Dmaven.test.failure.ignore=true -Dgwt.memory.settings="-Xmx2g -Xms1g -XX:MaxPermSize=256m -XX:PermSize=128m -Xss1M" -Dgwt.compiler.localWorkers=2
