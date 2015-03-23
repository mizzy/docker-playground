require 'spec_helper_docker'

describe 'From contaienr b1 To http://a0:80/ is NOT reachable' do
  subject { command("curl #{$a0_ip} --connect-timeout 1") }
  its(:exit_status) { should_not eq 0 }
end

describe 'From contaienr b1 To http://a1:80/ is NOT reachable' do
  subject { command("curl #{$a1_ip} --connect-timeout 1") }
  its(:exit_status) { should_not eq 0 }
end

describe 'From contaienr b1 To http://b0:80/ is reachable' do
  subject { command("curl #{$b0_ip}") }
  its(:exit_status) { should eq 0 }
end

describe 'From container b1 to exposed port 81 is *NOT* reachable' do
  subject { command('curl 172.17.8.101:81 --connect-timeout=1') }
  its(:exit_status) { should_not eq 0 }
end

describe 'From container b1 to exposed port 82 is *NOT* reachable' do
  subject { command('curl curl 172.17.8.101:82 --connect-timeout=1') }
  its(:exit_status) { should_not eq 0 }
end
