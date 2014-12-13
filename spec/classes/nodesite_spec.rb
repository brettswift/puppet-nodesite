require 'spec_helper'

describe 'nodesite' do
  describe 'regardless of operatingsystem' do
    #
    it { should contain_class('nodesite::appuser') }
    # it { should contain_class('nodesite::packages') }
    # it { should contain_class('nodesite::git') }
    # it { should contain_class('nodesite::project') }
    #
    # it do
    #   should contain_yumrepo('epel').with({
    #     'enabled'   => '1',
    #     'gpgcheck'  => '1',
    #   })
    # end

  end
end
