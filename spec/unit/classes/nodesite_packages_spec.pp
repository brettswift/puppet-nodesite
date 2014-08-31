require 'spec_helper'

describe 'nodesite::packages', :type => :class do 

  context 'default params' do 
    # let(:facts_default) {{ :kernel => 'Linux' }}
    # it {should contain_class('nodesite::appuser')}
    it { should contain_package('git').with_ensure('latest') }
  end

  
end