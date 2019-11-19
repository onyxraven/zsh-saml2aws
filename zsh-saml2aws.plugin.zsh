#--------------------------------------------------------------------#
# Variables                                                          #
#--------------------------------------------------------------------#
SAML2AWS_PL_DEFAULT_PROFILE=${SAML2AWS_PL_DEFAULT_PROFILE:-default}
SAML2AWS_PL_BROWSER=${SAML2AWS_PL_BROWSER:-''}
SAML2AWS_SESSION_DURATION=${SAML2AWS_SESSION_DURATION:-43200}

#--------------------------------------------------------------------#
# Aliases                                                            #
#--------------------------------------------------------------------#
alias sa='saml2aws'
alias sal="saml2aws login --skip-prompt"
alias sar="saml2aws list-roles --skip-prompt"

function sae() {
  old_profile=$SAML2AWS_EXEC_PROFILE_ACTIVE
  export SAML2AWS_EXEC_PROFILE_ACTIVE=$1
  shift
  saml2aws exec --exec-profile "$SAML2AWS_EXEC_PROFILE_ACTIVE" -- "$@"
  export SAML2AWS_EXEC_PROFILE_ACTIVE=$old_profile
}

function sash() {
  sae "$1" "$SHELL"
}

function said() {
  saml2aws exec --exec-profile "$1" -- aws sts get-caller-identity
}
