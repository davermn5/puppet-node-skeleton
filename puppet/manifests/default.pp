# Vars:
$home = "/home/vagrant"
$executes_as_vagrant = "sudo -u vagrant -H bash -l -c"

$database = "mongodb"

# Set default binary paths:
Exec {
  path => [ "/usr/bin", "/usr/local/bin" ]
}

# Prepare system before main stage:
stage { "init": }

class update_apt {
  exec { "apt-get -y update": }
}

class { "update_apt":
  stage => init,
}

Stage[ "init" ] -> Stage[ "main" ]

# Main packages:
package { "vim":
  ensure => "present",
}

package { "git":
  ensure => "present",
}

package { "build-essential":
  ensure => "present",
}

package { "curl":
  ensure => "present"
}

package { "memcached":
  ensure => "present"
}

package { "python-software-properties":
  ensure => "present"
}

#Install database
case $database {
	"mongodb" : {
		class { "::mongodb::server":
			auth => true,
		}
		mongodb::db { "app":
			user => "root",
			password => "root",
			require => Class[ "::mongodb::server" ],
		}
	}
}

# Install Node.js and additional package dependencies:
class { "nodejs":
  version => "stable",
}
