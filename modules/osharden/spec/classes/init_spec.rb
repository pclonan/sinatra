require 'spec_helper'
describe 'osharden' do

  context 'with defaults for all parameters' do
    it { should contain_class('osharden') }
  end
end
