#!groovy
 
import jenkins.model.*
import hudson.security.*
import jenkins.security.s2m.AdminWhitelistRule
 
def instance = Jenkins.getInstance()

def env = System.getenv()

def user = 'admin'
// This is just for demo
// you should override this script with bind mount where you can
// also configure more secrets like ssh key
// using env variables for passing secrets is not recemended
def pass = env.get('JENKINS_PASSWORD') ?: 'admin'
 
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount(user, pass)
instance.setSecurityRealm(hudsonRealm)
 
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)
instance.save()
 
Jenkins.instance.getInjector().getInstance(AdminWhitelistRule.class).setMasterKillSwitch(false)
