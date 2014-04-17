#Nodesite

State: experimental

A Puppet module to allow fast deployment to test nodejs applications.

Pass in your .git URI and the file used to run your app (if it's something other than app.js).
Pass your database configuration in via `node_params` (that will be passed to the command line) or optionally put configuration into a git branch of your source project, and tell nodesite which `git_branch` to run.

If the DB configuration is successful, you will have a running nodejs app.

Typically you will configure a database on the same host.  To see an example of this module in action,  see my [vagrant-nodeJsServer](https://github.com/brettswift/vagrant-nodeJsServer) project

###Git deploys
Enabled by default.  Nodesite will check for upstream changes on each puppet run.  If there are any it will run a `git pull`, `npm prune`, `npm install` and restart the service.


##Usage

###Basic
with all defaults
```
  class {'nodesite':
    git_uri       => "https://github.com/brettswift/uptime.git",
  }
```

###Extended
```
 class {'nodesite':
    node_version  => "v0.10.26",
    git_uri       => "https://github.com/brettswift/uptime.git",
    git_branch    => $featureBranch,
    file_to_run   => "app.js",
    user          => "${project}",
    node_params   => "NODE_CONFIG={\"mongodb\":{\"database\":\"${db_name}\", \"user\":\"${db_user}\", \"password\":\"${db_password}\"}}"
  }
```

###Parameters

* **node_version** - optional.
  * default: 'stable'
* **git_uri** - required
  * use link as shown above.
* **git_branch** - optional.
  * default: 'master'
  * note: should work with a git hash or tag as well. (currently not tested)
* **file_to_run** - optional.  This is the entry point for the app. Ie: `node app.js`
  * default: 'app.js'
* **user** - optional.  The user which the process should run under. (Will be created)
  * default: 'nodejs'
* **node_params** - optional.
  * command line parameters to pass to the process.  In the example above, `node config` options are passed in.
* **npm_proxy** - optional
* **repo_dir** - optional
  * default: `/usr/local/share/nodesite_repos`

## TODO (6)
1. git.pp:9  this code is duplicated.. fix it.
2. init.pp:1  unit tests!
3. project.pp:12  validate node version to: vX.X.X or latest or stable
4. project.pp:61  pull start scripts into separate files
5. init.conf.erb:19  set node_env variable, and other node variables
6. init.conf.erb:35  use `npm start`


##Known Bugs
upstart is configured for puppet 3.5 only, and is currently broken.  pre puppet 3.5 works with system V startup scripts.

##Contributing
Pull Requests

Feature Branches

