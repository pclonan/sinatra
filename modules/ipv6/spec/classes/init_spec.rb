require 'spec_helper'
describe 'ipv6' do

  context 'with defaults for all parameters' do
    it { should contain_class('ipv6') }
  end
end
