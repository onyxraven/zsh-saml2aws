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

## Features

This plugin is pretty simple - it provides:

- aliases

### Aliases

| Alias | Expression                                            |
| ----- | ----------------------------------------------------- |
| sa    | saml2aws                                              |
| sal   | saml2aws login to IDP                                 |
| sae   | saml2aws exec $profile $command                       |
| sash  | saml2aws exec $profile $shell                         |
| sar   | list available direct role ARNs                       |

## TODO

- [ ] list roles available
- [ ] login url to open web console (requires json create/parse)

## Thanks

- Inspired by [zsh-aws-vault](https://github.com/blimmer/zsh-aws-vault)
