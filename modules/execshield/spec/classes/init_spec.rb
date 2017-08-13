require 'spec_helper'
describe 'execshield' do

  context 'with defaults for all parameters' do
    it { should contain_class('execshield') }
  end
end
