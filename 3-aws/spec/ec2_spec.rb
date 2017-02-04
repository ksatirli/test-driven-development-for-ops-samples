require 'spec_helper'

describe ec2('tdd-for-ops') do
  it { should be_running }
  its(:instance_id) { should eq 'i-0ce81eb82cc8dcb3a' }
  it { should belong_to_vpc('vpc-e979868f') }
  it { should_not be_disabled_api_termination }
end
