class nodesite::packages{

  ensure_resource('package', 'rubygems', {'ensure' => 'present' })
  ensure_resource('package', 'make', {'ensure' => 'present' })
  ensure_resource('package', 'git', {'ensure' => 'present' })
  ensure_resource('package', 'curl', {'ensure' => 'present' })
  ensure_resource('package', 'gcc-c++', {'ensure' => 'present' })
}
