class nodesite::packages{
  package{"make":
    ensure => latest,
  }

  package{"git":
    ensure => latest,
  }

  package{"curl":
    ensure => latest,
  }

  service { "iptables":
      enable => false,
    ensure => stopped,
  }
}