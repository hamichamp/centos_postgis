#
# Cookbook Name:: centos_postgis
# Recipe:: default
#
# All rights reserved - Do Not Redistribute
#

elgis_filename = 'elgis-release-6-6_0.noarch.rpm'
elgis_url = "http://elgis.argeo.org/repos/6/#{elgis_filename}"
epel_filename = 'epel-release-6-8.noarch.rpm'
epel_url = "http://download.fedoraproject.org/pub/epel/6/x86_64/#{epel_filename}"

remote_file "#{Chef::Config[:file_cache_path]}/#{elgis_filename}" do
  action :create_if_missing
  source elgis_url
  mode '0644'
  backup 1
  not_if "rpm -qa | grep -qx '#{elgis_filename[0..-5]}'"
end

package elgis_filename[0..-5] do
  provider Chef::Provider::Package::Rpm
  source "#{Chef::Config[:file_cache_path]}/#{elgis_filename}"
  action :install
  not_if "rpm -qa | grep -qx '#{elgis_filename[0..-5]}'"
end

remote_file "#{Chef::Config[:file_cache_path]}/#{epel_filename}" do
  action :create_if_missing
  source epel_url
  mode '0644'
  backup 1
  not_if "rpm -qa | grep -qx '#{epel_filename[0..-5]}'"
end

package epel_filename[0..-5] do
  provider Chef::Provider::Package::Rpm
  source "#{Chef::Config[:file_cache_path]}/#{epel_filename}"
  action :install
  not_if "rpm -qa | grep -qx '#{epel_filename[0..-5]}'"
end

yum_package 'libspatialite' do
  action :install
  arch 'x86_64'
end

yum_package 'postgis2_92' do
  action :install
end
