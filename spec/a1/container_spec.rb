require 'spec_helper_docker'

describe 'From contaienr a1 To http://a0:80/ is reachable' do
  subject { command("curl #{$a0_ip}") }
  its(:exit_status) { should eq 0 }
end

describe 'From contaienr a1 To http://b0:80/ is *NOT* reachable' do
  subject { command("curl #{$b0_ip} --connect-timeout 1") }
  its(:exit_status) { should_not eq 0 }
end

describe 'From contaienr a1 To http://b1:80/ is *NOT* reachable' do
  subject { command("curl #{$b1_ip} --connect-timeout 1") }
  its(:exit_status) { should_not eq 0 }
end

describe 'From container a1 to exposed port 81 is *NOT* reachable' do
  subject { command('curl 172.17.8.101:81 --connect-timeout=1') }
  its(:exit_status) { should_not eq 0 }
end

describe 'From container a1 to exposed port 82 is *NOT* reachable' do
  subject { command('curl curl 172.17.8.101:82 --connect-timeout=1') }
  its(:exit_status) { should_not eq 0 }
end
