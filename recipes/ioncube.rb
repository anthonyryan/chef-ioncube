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
#

# install ioncube from source
ioncube_src_url = "#{node['ioncube']['ioncubesrc_url']}/#{node['ioncube']['ioncubefile']}"

# download the file
remote_file "/tmp/#{node['ioncube']['ioncubefile']}" do
  source ioncube_src_url
  mode 0644
  action :create_if_missing
  ignore_failure true
  not_if "test -f /tmp/#{node['ioncube']['ioncubefile']}"
end

# untar it
execute "tar --no-same-owner -zxvf #{node['ioncube']['ioncubefile']}" do
  cwd "/tmp"
end

# create default ioncube directory
directory "#{node['ioncube']['ioncubedir']}" do
  mode 0755
  action :create
  not_if { ::Dir.exists?("#{node['ioncube']['ioncubedir']}") }
end

# move ioncube files to proper directory
execute "ioncube install" do
  environment({"PATH" => "/usr/local/bin:/usr/bin:/bin:$PATH"})
  command "mv ioncube_loader_*5*.so #{node['ioncube']['ioncubedir']}"
  cwd "/tmp/ioncube"
  ignore_failure true
end

# symlink ioncube version to php directory
if platform?('debian', 'ubuntu')
  link "/usr/lib/php5/20121212/ioncube_loader.so" do
    to "#{node['ioncube']['ioncubedir']}/ioncube_loader_#{node['ioncube']['ioncubeversion']}.so"
    ignore_failure true
    only_if { ::Dir.exists?("/usr/lib/php5") }
  end
end

# install ioncube module loader
if platform?('debian', 'ubuntu')
  template "#{node[:ioncube][:phpdir]}/mods-available/ioncube.ini" do
    source 'ioncube.ini.erb'
    ignore_failure true
    only_if { ::Dir.exists?("#{node[:ioncube][:phpdir]}") }
  end
#  link "#{node[:ioncube][:phpdir]}/apache2/conf.d/ioncube.ini" do
#    to "#{node[:ioncube][:phpdir]}/mods-available/ioncube.ini"
#    ignore_failure true
#    only_if { ::Dir.exists?("#{node[:ioncube][:phpdir]}") }
#  end
#  link "#{node[:ioncube][:phpdir]}/cli/conf.d/ioncube.ini" do
#    to "#{node[:ioncube][:phpdir]}/mods-available/ioncube.ini"
#    ignore_failure true
#    only_if { ::Dir.exists?("#{node[:ioncube][:phpdir]}") }
#  end
end

# enable ioncube php module
if platform?('debian', 'ubuntu')
  execute "ioncube php module enable" do
    environment({"PATH" => "/usr/local/bin:/usr/bin:/bin:/usr/sbin:$PATH"})
    command "/usr/sbin/php5enmod ioncube"
    ignore_failure true
    only_if { ::Dir.glob("#{node[:ioncube][:phpdir]}/apache2/conf.d/*ioncube.ini").any? }
    only_if { ::File.exists?("/usr/sbin/php5enmod") }
  end
end

# clean up install path
execute "ioncube cleanup" do
  environment({"PATH" => "/usr/local/bin:/usr/bin:/bin:$PATH"})
  command "rm -rf /tmp/ioncube"
  cwd "/tmp"
  ignore_failure true
end
