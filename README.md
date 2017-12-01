pulet
=====

Enhanced Puppet Control Repo and Tools.

[Upstream Projekt auf Github](https://github.com/pgassmann/pulet)

What
----
 * Combination of control_repo and masterless Puppet localsetup
 * One single repository with
   * hieradata
   * Puppetfile for librarian-puppet
   * Gemfile for tool installation with bundler
   * pulet script with various subcommands for setup, package and apply config
 * Can be used without Puppetmaster
 * Can be used as control repo on a Puppet master
 * Package useful Tools and Rake Tasks to manage and check your Puppet Environment
 * One-Command setup with all-in-one puppet-agent package from puppet collection repo.
 * Alternative: Install Puppet using bundler and Gemfile to a separate path from system gems


Why?
----
 * Small flexible system to puppetize servers for example in a home setup environment.
 * Test/Develop Puppet on ephemeral systems without having them to register on a Puppetmaster.
 * All the configuration and scripts in one git repository.


Bootstrap
---------

### Workspace Setup

To write and test the configuration on your laptop.

 * clone repository
 * configure pulet locally to use bundle as source for puppet
 * install puppet and modules

```
git clone <repourl>
cd pulet
echo "installmethod='bundle'" >> ./pulet.conf.local
./pulet install
```

### Bootstrap a Server

 * VM with Ubuntu 14.04+ or EL 7+ Server.
 * Git to clone the repo

Run the following commands to setup your server.

    yum install git -y
    git clone <repourl>
    cd pulet
    ./pulet setup


Customization
-------------

 * hieradata in `data/`
 * Puppet Modules in `Puppetfile`
 * profile manifests in `site/profiles`
 * hierarchy in `hiera.yaml`
 * pulet configuration and extensions in `pulet.conf`

How it works
------------

### First run:

#### installmethod=collection

 - Install puppet-agent package from puppet collection repo
 - Install bundler as gem using the ruby & gem from puppet-agent in /opt/puppetlabs/
 - Install necessary missing gems with bundler

#### installmethod=bundler
 - Install sytem packages ruby, ruby-dev and make
 - Install bundler as gem
 - Install puppet and dependencies with bundle to a local path

### populate environment and puppet apply
 - librarian-puppet installs the modules using the Puppetfile
 - puppet apply with hieradata and modules

Commands
-------
* `./pulet help`: show all commands
* `./pulet install`: install development environment with tools, without apply
* `./pulet apply`: apply the current configuation, can be used as long as there are no changes in external modules.
* `./pulet setup`: install & apply
* `./pulet facts`: dump facts using custom facts in modules
* `./pulet check`: validate and lint puppet code


Package and deploy configuration as rpm
---------------------------------------

The complete configuration incl. hieradata and modules can be packaged and deployed as rpm.

The configuration can then be directly applied without installing dependencies or modules on a node.

* ./pulet package: package modules and configuration to rpm in ./build/.
* Install pulet rpm and puppet-agent on a system
* /opt/pulet/pulet apply: Apply the configuration
