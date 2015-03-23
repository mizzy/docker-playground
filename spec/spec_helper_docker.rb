require 'serverspec'
require 'docker'
require 'json'

container = ENV['TARGET_HOST']

docker_url = 'tcp://localhost:2375'

set :backend, :docker
set :docker_container, container
set :docker_url, docker_url

::Docker.url = docker_url

a0 = ::Docker::Container.get('a0')
a1 = ::Docker::Container.get('a1')
b0 = ::Docker::Container.get('b0')
b1 = ::Docker::Container.get('b1')

$a0_ip = a0.json['NetworkSettings']['IPAddress']
$a1_ip = a1.json['NetworkSettings']['IPAddress']
$b0_ip = b0.json['NetworkSettings']['IPAddress']
$b1_ip = b1.json['NetworkSettings']['IPAddress']


