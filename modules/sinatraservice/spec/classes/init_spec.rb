require 'spec_helper'
describe 'sinatraservice' do

  context 'with defaults for all parameters' do
    it { should contain_class('sinatraservice') }
  end
end
