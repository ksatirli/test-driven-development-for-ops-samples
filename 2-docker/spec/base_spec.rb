require 'spec_helper'

describe "#{$app_name} (built from \"#{$dockerfile}\")" do

  ### set up tests #############################################################
  before(:all) do
    @image = Docker::Image.build_from_dir($dockerfile)

    set :backend, :docker
    set :docker_image, @image.id

    @docker_inspect = @image.json
    @docker_config = @docker_inspect['ContainerConfig']

    @container = Docker::Container.create(
      'Image' => @image.id,
    )

    @container.start
  end
  ##############################################################################


  ### Docker-specific tests: ###################################################
  describe 'Docker Image' do
    it 'should include required environment variable(s)' do
      expect(@docker_config['Env']).to include("APP_NAME=#{$app_name}")
      expect(@docker_config['Env']).to include("APP_VERSION=#{$app_version}")
      expect(@docker_config['Env']).to include("APP_PORT=#{$app_port}")
    end

    describe user($app_name) do
      it { should exist }
    end

    describe command('whoami') do
      its(:stdout) { should eq "#{$app_name}\n" }
    end
  end
  ##############################################################################


  ### app-specific tests: ######################################################
  describe 'Application' do
    describe file("/tmp/loop-and-crash") do
      it { should exist }
      it { should_not be_file }
      it { should be_directory }
      it { should_not be_symlink }
      it { should be_readable }
    end
  end
  ##############################################################################


  ### after-action clean-up! ###################################################
  after(:all) do
    @container.stop
    @container.kill
    @container.delete(:force => true)

    # @image.delete(:force => true)
  end
  ##############################################################################

end
