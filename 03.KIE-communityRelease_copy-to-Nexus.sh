#deletes kie.properties if it exists
file="kie.properties"
if [ -f "$file" ]; then
   echo "$file found."
   rm $file
fi

#fetch automatically version of kie-release
cd $HOME/.jenkins/workspace/02.build-deploy-6.4.x/droolsjbpm-build-bootstrap
KIE_VERSION=$(sed -e 's/^[ \t]*//' -e 's/[ \t]*$//' -n -e 's/<version.org.kie>\(.*\)<\/version.org.kie>/\1/p' pom.xml) 

# copy Deploy_dir
cd $WORKSPACE
cp -r $HOME/.jenkins/workspace/02.build-deploy-6.4.x/Deploy_dir .

DEPLOY_DIR=Deploy_dir

cd $HOME/.jenkins/workspace/02.build-deploy-6.4.x

#creates a properties file to pass variables
echo KIE_VERSION=$KIE_VERSION > kie.properties
echo TARGET=community >> kie.properties

# cd $DEPLOY_DIR

# (2) upload the content to remote staging repo
mvn -B -e org.sonatype.plugins:nexus-staging-maven-plugin:1.6.5:deploy-staged-repository -DnexusUrl=https://repository.jboss.org/nexus -DserverId=jboss-releases-repository -DrepositoryDirectory=$DEPLOY_DIR -DstagingProfileId=15c58a1abc895b -DstagingDescription="kie-$KIE_VERSION" -DstagingProgressTimeoutMinutes=30
