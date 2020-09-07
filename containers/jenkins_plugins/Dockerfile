FROM ir-jenkins_base

# Skip initial setup
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

USER root
COPY plugins.txt /usr/share/jenkins/plugins.txt
COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt
