require 'serverspec'
require 'docker'

# BEGIN: config
$app_binary = '/usr/bin/node'
$app_name = 'loop-and-crash'
$app_version = '1.3.2'
$app_port = '2774'
$dockerfile = './'
# END: config
