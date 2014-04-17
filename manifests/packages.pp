class nodesite::packages{

  if ! defined(Package['make']) {
    package { 'make':
        ensure => latest,
    }
  }
  
  if ! defined(Package['git']) {
    package { 'git':
        ensure => latest,
    }
  }
  
  if ! defined(Package['curl']) {
    package { 'curl':
        ensure => latest,
    }
  }
  
  if ! defined(Package['gcc-c++']) {
    package { 'gcc-c++':
        ensure => latest,
    }
  }
}