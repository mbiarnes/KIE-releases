cp $HOME/.jenkins/workspace/03.copy-to-Nexus-6.4.x/kie.properties .

KIE_VERSION=$(sed -n -e '/KIE_VERSION/ s/.*\= *//p' kie.properties)
TARGET=$(sed -n -e '/TARGET/ s/.*\= *//p' kie.properties)

if [ "$TARGET" == "community" ]; then 
   STAGING_REP=kie-group
else
   STAGING_REP=kie-internal-group
fi

echo "KIE version: $KIE_VERSION"
echo "TARGET : $TARGET"
echo "TRIGGER THE JOB WORKS"

# wget the tar.gz sources
wget -q https://repository.jboss.org/nexus/content/groups/$STAGING_REP/org/jbpm/jbpm/$KIE_VERSION/jbpm-$KIE_VERSION-project-sources.tar.gz -O sources.tar.gz

tar xzf sources.tar.gz
mv jbpm-$KIE_VERSION/* .
rmdir jbpm-$KIE_VERSION
