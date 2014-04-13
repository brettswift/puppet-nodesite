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

  package{'gcc-c++':
		ensure => latest,
	}

}