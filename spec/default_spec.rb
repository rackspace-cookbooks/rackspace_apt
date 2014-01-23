require 'spec_helper'

describe 'rackspace_apt::default' do
  context 'update-success-stamp exists' do
    before do
      stub_command('test -f /var/lib/apt/periodic/update-success-stamp').and_return(true)
    end
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['rackspace_apt']['apt_installed'] = true
      end.converge(described_recipe)
    end

    it 'installs update-notifier-common' do
      expect(chef_run).to install_package('update-notifier-common')
    end

    it 'apt-get updates if update-success-stamp exists' do
      expect(chef_run).to_not run_execute('apt-get-update')
    end

    it 'creates preseeding directory' do
      expect(chef_run).to create_directory('/var/cache/local')
      expect(chef_run).to create_directory('/var/cache/local/preseeding')
    end
  end

  context 'update-success-stamp DOES NOT exist' do
    before do
      stub_command('test -f /var/lib/apt/periodic/update-success-stamp').and_return(false)
    end
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['rackspace_apt']['apt_installed'] = true
      end.converge(described_recipe)
    end
    it 'apt-get updates if update-success-stamp DOES NOT exist' do
      expect(chef_run).to run_execute('apt-get-update')
    end
  end

end
