require 'spec_helper'

# SELinux tests
describe 'SELinux Policy' do
  describe selinux do
    it { should be_permissive }
  end
end

# YUM repo tests
describe 'YUM repository: EPEL' do
  describe yumrepo('epel') do
    it { should exist }
    it { should be_enabled }
  end
end


# YUM package tests
describe 'YUM packages' do
  for package in $packages
    describe package("#{package}") do
      it { should be_installed }
    end
  end
end

# PIP package tests
describe 'PIP packages' do
  describe package('awscli') do
    it { should be_installed.by('pip') }
  end
end
