require 'spec_helper'

describe 'From container core-02 to exposed port 81 of core-01 is reachable' do
  subject { command('curl 172.17.8.101:81') }
  its(:exit_status) { should eq 0 }
end

describe 'From container b1 to exposed port 82 is *NOT* reachable' do
  subject { command('curl 172.17.8.101:82 --connect-timeout=1') }
  its(:exit_status) { should_not eq 0 }
end
