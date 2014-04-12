# http://www.websequencediagrams.com/?lz=UHVwcGV0IFZpcnR1YWwgVHlwZXMgdy8gSGllcmEKCnNpdGUucHAgLT4gY2xhc3NEZWZpbml0aW9uOiBoaWVyYSgAEgU6OnYAOwYAIAUsICBkZWZhdWx0cywgACEGADgGIGFycmF5KQoAPA8ASRVjcmVhdGVfcmVzb3VyY2VzKABbBy50eXBlLACBCAZPYmplY3QocykgaGFzaCwAbQkAPCZyZWFsaXplIChDAIE-BQCBfAdbAIFSBV8AgSUFXSkKIgCBUg4iIC0-IAAEEDpkAIINCQ&s=modern-blue

# TODO: move defaults to nodesite.params, and load defaults
class nodesite (
    $git_uri 			  = {},
    $git_branch 		= 'module_default',
    $node_version 	= {},
    $file_to_run 		= 'module_default',
    $user           = {},
    $npm_proxy      = {},
    $repo_dir       = 'module_default',
){

	include nodesite::packages
  include nodesite::project

	# TODO: include plain class, and pull variables instead of pushing.  use module_data / hiera? 
	# class {'nodesite::project':
	# 		git_uri 			=> $git_uri,
	# 		git_branch 	=> $git_branch,
	# 		file_to_run 	=> $file_to_run,
	# 		node_version	=> $node_version,
 #      user        => $user,
	# }
	
  # Class['nvm'] -> 
  Class['nodesite::packages'] ->
  Class['nodesite::project']

}