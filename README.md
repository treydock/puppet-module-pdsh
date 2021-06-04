# puppet-module-pdsh

[![Puppet Forge](http://img.shields.io/puppetforge/v/treydock/pdsh.svg)](https://forge.puppetlabs.com/treydock/pdsh)
[![CI Status](https://github.com/treydock/puppet-module-pdsh/workflows/CI/badge.svg?branch=master)](https://github.com/treydock/puppet-module-pdsh/actions?query=workflow%3ACI)

####Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with pdsh](#setup)
    * [What pdsh affects](#what-pdsh-affects)
    * [Setup requirements](#setup-requirements)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - Module reference](#reference)


## Setup

### What pdsh affects

The pdsh module will install and configure pdsh and optionally add groups.

### Setup Requirements

If genders support is enabled there is a soft dependency on [treydock/genders](https://forge.puppet.com/treydock/genders)

## Usage

Install and configure pdsh

```puppet
include pdsh
```

**Note** Groups are only supported on Red Hat based systems.

Define some groups with members an aliases using class (or Hiera)

```puppet
class { '::pdsh':
  groups => {
    'compute' => {
      'members'  => 'o0[001-824]',
      'aliases'  => ['all'],
    }
  }
}
```

Groups can be defined through `pdsh::group` defined type

```puppet
pdsh::group { 'compute':
  members => 'o0[001-824]',
  aliases => ['all'],
}
```

## Reference

[http://treydock.github.io/puppet-module-pdsh/](http://treydock.github.io/puppet-module-pdsh/)
