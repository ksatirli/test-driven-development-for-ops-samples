require 'spec_helper'

describe iam_user('tdd-for-ops') do
  it { should be_allowed_action('cloudtrail:DescribeTrails') }
  it { should be_allowed_action('trustedadvisor:*') }
  it { should have_iam_policy('SystemAdministrator') }
  it { should have_no_inline_policy('AllowS3BucketAccess') }
end
