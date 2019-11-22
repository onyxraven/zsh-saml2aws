#--------------------------------------------------------------------#
# Variables                                                          #
#--------------------------------------------------------------------#

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
  saml2aws exec --exec-profile "$SAML2AWS_EXEC_PROFILE_ACTIVE" "$@"
  export SAML2AWS_EXEC_PROFILE_ACTIVE=$old_profile
}

function sash() {
  profile=$1
  shift
  sae "$profile" "$SHELL" "$@"
}

function said() {
  profile=$1
  shift
  saml2aws exec --exec-profile "$profile" -- aws sts get-caller-identity "$@"
}
