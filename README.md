# zsh-saml2aws

oh-my-zsh plugin for [saml2aws](https://github.com/Versent/saml2aws)

## Installation

### [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)

This plugin is intended to be used with oh-my-zsh

1. `$ cd ~/.oh-my-zsh/custom/plugins` (you may have to create the folder)
2. `$ git clone git@github.com:onyxraven/zsh-saml2aws.git`
3. In your .zshrc, add `zsh-saml2aws` to your oh-my-zsh plugins:

```bash
plugins=(
  git
  ruby
  zsh-saml2aws
)
```

### [zgen](https://github.com/tarjoilija/zgen)

1. add `zgen load onyxraven/zsh-saml2aws` to your '!saved/save' block
1. `zgen update`

### [zinit](https://github.com/zdharma-continuum/zinit)

Use it like other oh-my-zsh plugins.

```bash
zinit snippet https://github.com/onyxraven/zsh-saml2aws/blob/master/zsh-saml2aws.plugin.zsh
```

## Aliases

In any case `<exec-profile>` is available in a shortcut alias below, it is positional, but optional. If you do not specify a profile, it will use the 'base' role you have assumed. For these commands, any extra parameters are passed to `saml2aws`, so use `--` to separate your flags from a command.

| Alias | parameters                 | description                                                                   |
| ----- | -------------------------- | ----------------------------------------------------------------------------- |
| sa    |                            | saml2aws command shortcut alias                                               |
| sal   |                            | login to IDP (skips prompts by default, and uses the session duration var)    |
| sae   | \<exec-profile> \<command> | execute a command as the profile, with the session duration var               |
| sash  | \<exec-profile>            | open a shell as the profile, with the session duration var                    |
| sas   | \<exec-profile>            | print shell export script for profile, with the session duration var          |
| sase  | \<exec-profile>            | print env file format for profile, with the session duration var              |
| salr  |                            | list roles available to login as                                              |
| sac   | \<exec-profile>            | Open a browser to the logged in AWS console                                   |
| said  |                            | output of `aws sts get-caller-identity` for assumed role (\$profile optional) |

## saml2aws configuration

| ENV var                         | example | information                                                                                                   |
| ------------------------------- | ------- | ------------------------------------------------------------------------------------------------------------- |
| SAML2AWS_LOGIN_SESSION_DURATION | 43200   | Length of time (seconds) the "root" federation session is available. This can be up to 12 hours (in seconds). |
| SAML2AWS_SESSION_DURATION       | 3600    | Length of time (seconds) the role assume session is available. This can be up to 1 hour (in seconds).         |

## Examples

Assume the `staging` profile and run an aws command

```sh
sae staging -- aws sts get-caller-identity
```

Assume the login role and start a shell (same as you are using) with that context

```sh
sash
```

## Thanks

- Inspired by [zsh-aws-vault](https://github.com/blimmer/zsh-aws-vault)
