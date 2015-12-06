#
# Author:: anthony ryan <anthony@tentric.com>
# Cookbook Name:: ioncube
#
# Copyright 2014, Anthony Ryan
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# set info
case node[:platform]
when 'redhat','centos','fedora','amazon'
  default['ioncube']['webuser'] = "www-data"
  default['ioncube']['webgroup'] = "www-data"
  default['ioncube']['apachepid'] = "httpd"
  default['ioncube']['apachedir'] = "/etc/httpd"
  default['ioncube']['phpdir'] = "/etc/php"
  default['ioncube']['nginxdir'] = "/etc/nginx"
when 'gentoo'
  default['ioncube']['webuser'] = "apache"
  default['ioncube']['webgroup'] = "apache"
  default['ioncube']['apachepid'] = "apache2"
  default['ioncube']['apachedir'] = "/etc/apache2"
  default['ioncube']['phpdir'] = "/etc/php"
  default['ioncube']['nginxdir'] = "/etc/nginx"
when 'debian','ubuntu'
  default['ioncube']['webuser'] = "www-data"
  default['ioncube']['webgroup'] = "www-data"
  default['ioncube']['apachepid'] = "apache2"
  default['ioncube']['apachedir'] = "/etc/apache2"
  default['ioncube']['phpdir'] = "/etc/php5"
  default['ioncube']['nginxdir'] = "/etc/nginx"
else
  raise 'Bailing out, unknown platform.'
end

# set ioncube info
default['ioncube']['ioncubesrc_url'] = "http://downloads3.ioncube.com/loader_downloads"
default['ioncube']['ioncubefile'] = "ioncube_loaders_lin_x86-64.tar.gz"
default['ioncube']['ioncubeversion'] = "lin_5.5"
default['ioncube']['ioncubedir'] = "/usr/local/ioncube"

include_attribute 'ioncube::customize'
