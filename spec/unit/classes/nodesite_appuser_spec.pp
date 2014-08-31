require 'spec_helper'

describe 'nodesite::appuser', :type => :class do 

  context 'default params' do 
    let(:params) {{ :"nodesite::user" => 'darth' }}
    # it {should contain_class('nodesite::appuser')}
    it {should contain_user('darth')}
  end

  
end