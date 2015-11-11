require 'spec_helper_acceptance'

describe 'nodesite class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'nodesite':
          passwd         => 'dummy password',
          git_uri        => 'test/uri',
          node_version   = '0.10.0',
          $user           = 'nodeuser',
        }
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

  end
end
