#--------------------------------------------------------------------#
# Variables                                                          #
#--------------------------------------------------------------------#

#--------------------------------------------------------------------#
# Aliases                                                            #
#--------------------------------------------------------------------#
alias sa='saml2aws'
alias salr="saml2aws list-roles --skip-prompt"

function sal() {
  saml2aws login --skip-prompt --session-duration="$SAML2AWS_LOGIN_SESSION_DURATION" "$@"
}

function sae() {
  profile=$1
  if [[ ! -z "$profile" && ! "$profile" =~ ^-- ]]; then
    old_profile="$SAML2AWS_EXEC_PROFILE_ACTIVE"
    export SAML2AWS_EXEC_PROFILE_ACTIVE="$profile"
    shift
    saml2aws exec --session-duration="$SAML2AWS_SESSION_DURATION" --exec-profile="$SAML2AWS_EXEC_PROFILE_ACTIVE" "$@"
    export SAML2AWS_EXEC_PROFILE_ACTIVE="$old_profile"
  else
    saml2aws exec --session-duration="$SAML2AWS_SESSION_DURATION" "$@"
  fi
}

function sash() {
  profile=$1
  shift
  sae "$profile" "$SHELL" "$@"
}

function said() {
  profile=$1
  if [[ ! -z "$profile" ]]; then shift; fi
  saml2aws exec --exec-profile "$profile" -- aws sts get-caller-identity "$@"
}

function sac() {
  profile=$1
  if [[ ! -z "$profile" ]]; then shift; fi
  saml2aws console --exec-profile "$profile" "$@"
}

function sas() {
  sase "$@" | sed -e 's/^/export /'
}

function sase() {
  profile=$1
  if [[ ! -z "$profile" && ! "$profile" =~ ^-- ]]; then
    shift;
    sae "$profile" env "$@" | grep '^AWS_\(SESSION_TOKEN\|ACCESS_KEY_ID\|SECRET_ACCESS_KEY\|CREDENTIAL_EXPIRATION\)'
  else
    saml2aws script --shell=env "$@"
  fi
}
