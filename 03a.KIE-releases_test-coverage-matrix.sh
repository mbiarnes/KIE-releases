# temporary disabled
#KIE_VERSION=$(sed -n -e '/KIE_VERSION/ s/.*\= *//p' kie.properties)
#TARGET=$(sed -n -e '/TARGET/ s/.*\= *//p' kie.properties)

KIE_VERSION=6.4.1.20160720-042100
TARGET=productized

if [ "$TARGET" == "community" ]; then 
   STAGING_REP=kie-group
else
   STAGING_REP=kie-internal-group
fi

echo "KIE version: $KIE_VERSION"
echo "TARGET : $TARGET"

# wget the tar.gz sources
wget -q https://repository.jboss.org/nexus/content/groups/$STAGING_REP/org/jbpm/jbpm/$KIE_VERSION/jbpm-$KIE_VERSION-project-sources.tar.gz -O sources.tar.gz

tar xzf sources.tar.gz
mv jbpm-$KIE_VERSION/* .
rm -rf jbpm-$KIE_VERSION
rm -rf sources.tar.gz

# execute tests
mvn clean verify -e -B -Dmaven.test.failure.ignore=true -Dintegration-tests
