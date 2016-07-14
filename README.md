# KIE-releases
testing repository for KIE-releases and Jenkins DSL plugin

To test the script for DSL plugin please do the following:<br>

1. clone [Kie-releases](https://github.com/mbiarnes/KIE-releases): git clone git@github.com:mbiarnes/KIE-releases.git
2. create in JENKINS a *freestyle* job and copy the content of [01.community_DSL.txt](https://github.com/mbiarnes/KIE-releases/blob/master/01.community_DSL.txt) into Add Build step --> Process Job DSLs --> use the provided DSL script
 
When executed this created JENKINS job a new view will be created *community-Release* view with a nested view *KIE-community-6.4.x* with a job *01-push-release-branches-6.4.x*.<br>
The job is parametrized.<br>
What this job does is:<br>

    - cloning the branch were the scripts for DSL plugin are
    - clones all 6.4.x branches
    - updates the version in poms
    - adds the correct uberfire/dashbuilder/errai version to the kie-parent-metadata pom
    - pushes the release branches to community (right now only dryrun with -n)

 
