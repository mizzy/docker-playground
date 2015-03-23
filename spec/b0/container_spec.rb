require 'spec_helper_docker'

describe service('httpd') do
  it { should be_running }
end

describe 'From container b0 to exposed port 81 is *NOT* reachable' do
  subject { command('curl 172.17.8.101:81 --connect-timeout=1') }
  its(:exit_status) { should_not eq 0 }
end

describe 'From container b0 to exposed port 82 is *NOT* reachable' do
  subject { command('curl curl 172.17.8.101:82 --connect-timeout=1') }
  its(:exit_status) { should_not eq 0 }
end
