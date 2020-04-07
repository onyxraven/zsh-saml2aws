#--------------------------------------------------------------------#
# Variables                                                          #
#--------------------------------------------------------------------#

#--------------------------------------------------------------------#
# Aliases                                                            #
#--------------------------------------------------------------------#
alias sa='saml2aws'
alias salr="saml2aws list-roles --skip-prompt"

function sal() {
  saml2aws login --skip-prompt --session-duration=$SAML2AWS_LOGIN_SESSION_DURATION "$@"
}

function sae() {
  old_profile=$SAML2AWS_EXEC_PROFILE_ACTIVE
  export SAML2AWS_EXEC_PROFILE_ACTIVE=$1
  shift
  saml2aws exec --session-duration=$SAML2AWS_SESSION_DURATION --exec-profile "$SAML2AWS_EXEC_PROFILE_ACTIVE" "$@"
  export SAML2AWS_EXEC_PROFILE_ACTIVE=$old_profile
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
  local login_url
  login_url="$(_saml2aws_getSigninTokenUrl)"

  profile=${1:-$SAML2AWS_PROFILE}
  profile=${profile:-saml}

  if [ $? -ne 0 ]; then
    echo "Could not login" >&2
    return 1
  fi

  if _saml2aws_using_osx ; then
    local browser="$(_saml2aws_find_browser)"

    case $browser in
      org.mozilla.firefox)
        # Ensure a profile is created (can run idempotently) and launch it as a disowned process
        /Applications/Firefox.app/Contents/MacOS/firefox --CreateProfile $1 2>/dev/null && \
        /Applications/Firefox.app/Contents/MacOS/firefox --no-remote -P $1 "${login_url}" 2>/dev/null &!
        ;;
      com.google.chrome)
        echo "${login_url}" | xargs -t nohup /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome %U --no-first-run --new-window --disk-cache-dir=$(mktemp -d /tmp/chrome.XXXXXX) --user-data-dir=$(mktemp -d /tmp/chrome.XXXXXX) > /dev/null 2>&1 &!
        ;;
      *)
        open -a Safari "${login_url}"
        ;;
    esac

  else
    # NOTE this is untested - PRs welcome to improve it.
    echo "${login_url}" | xargs xdg-open
  fi
}

#--------------------------------------------------------------------#
# Utility Functions                                                  #
#--------------------------------------------------------------------#

function _saml2aws_urlencode() {
  echo $1 | python -c 'import urllib, sys; sys.stdout.writelines(urllib.quote_plus(l, safe="/\n") for l in sys.stdin)'
}

function _saml2aws_getSigninTokenUrl() {
  session=$( (eval $(saml2aws script); sh -c 'echo "{\"sessionId\": \"$AWS_ACCESS_KEY_ID\",\"sessionKey\":\"$AWS_SECRET_ACCESS_KEY\",\"sessionToken\":\"$AWS_SECURITY_TOKEN\"}"') )
  signinToken=$(curl -s -G https://signin.aws.amazon.com/federation --data-urlencode "Action=getSigninToken" --data-urlencode "SessionDuration=43200" --data-urlencode "Session=$session" | python -c "import json,sys; print json.load(sys.stdin)['SigninToken']")

  if [[ -z "$signinToken" ]]; then
    echo "Could not sign in with current profile." >&2
    exit 1
  fi

  consoleUrl=$(_saml2aws_urlencode "https://console.aws.amazon.com/console/home?region=$AWS_DEFAULT_REGION")

  echo "https://signin.aws.amazon.com/federation?Action=login&Issuer=$(_saml2aws_urlencode $SAML2AWS_URL)&Destination=$consoleUrl&SigninToken=$signinToken"
}


function _saml2aws_using_osx() {
  [[ $(uname) == "Darwin" ]]
}

function _saml2aws_find_browser() {
  if [ -n "$SAML2AWS_PL_BROWSER" ]; then
    # use the browser bundle specified
    echo "$SAML2AWS_PL_BROWSER"
  elif _saml2aws_using_osx ; then
    # Detect the browser in launchservices
    # https://stackoverflow.com/a/32465364/808678
    local prefs=~/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist
    plutil -convert xml1 $prefs -o - \
      | grep 'https' -b3 $prefs | awk 'NR==2 {split($2, arr, "[><]"); print arr[3]}';
  else
    # TODO - other platforms
  fi
}
