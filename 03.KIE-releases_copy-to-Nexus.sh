if [ "$TARGET" == "community" ]; then 
   STAGING_REP_ID=15c58a1abc895b
else
   STAGING_REP_ID=15c3321d12936e
fi

#deletes kie.properties if it exists
file="kie.properties"
if [ -f "$file" ]; then
   echo "$file found."
   rm $file
fi

#fetch automatically version of kie-release
cd $HOME/.jenkins/workspace/02.build-deploy-6.4.x/droolsjbpm-build-bootstrap
KIE_VERSION=$(sed -e 's/^[ \t]*//' -e 's/[ \t]*$//' -n -e 's/<version.org.kie>\(.*\)<\/version.org.kie>/\1/p' pom.xml) 

echo "KIE_VERSION="$KIE_VERSION

#copies here the deploy dir from 02.build-deploy-6.4.x
cp -r $HOME/.jenkins/workspace/02.build-deploy-6.4.x/Deploy_dir .

ls -al

DEPLOY_DIR=Deploy_dir

echo "DEPLOY_DIR"=$DEPLOY_DIR

#creates a properties file to pass variables
echo KIE_VERSION=$KIE_VERSION > kie.properties
echo TARGET=$TARGET >> kie.properties

# upload the content to remote staging repo
mvn -B -e org.sonatype.plugins:nexus-staging-maven-plugin:1.6.5:deploy-staged-repository -DnexusUrl=https://repository.jboss.org/nexus -DserverId=jboss-releases-repository -DrepositoryDirectory=$DEPLOY_DIR -DstagingProfileId=$STAGING_REP_ID -DstagingDescription="kie-$KIE_VERSION" -DstagingProgressTimeoutMinutes=30
