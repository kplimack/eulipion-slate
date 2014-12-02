#
# Cookbook Name:: eulipion-slate
# Recipe:: default
#
# Copyright (C) 2014 ShowMobile, LLC
#
# All rights reserved - Do Not Redistribute
#

node[:slate][:deps][:cookbooks].each { |cb| include_recipe cb }

case node[:slate][:server]
when 'apache'
  mUser = node[:apache][:user]
  mGroup = node[:apache][:group]
when 'nginx'
  mUser = node[:nginx][:user]
  mGroup = node[:nginx][:group]
end

directory node[:slate][:deploy_path] do
  owner mUser
  group mGroup
  recursive true
end

application "slate-#{node.chef_environment.gsub('_','')}" do
  repository node[:slate][:repo]
  revision node[:slate][:revision]
  packages node[:slate][:deps][:packages]
  path node[:slate][:deploy_path]
  owner mUser
  group mGroup
  action :force_deploy
  keep_releases 2
  migrate false
  create_dirs_before_symlink ['config']
  if Chef::Config[:solo]
    rollback_on_error false
  end

  rails do
    bundler true
  end
  case node[:slate][:server][:server]
  when 'middleman'
    before_migrate do
      template "#{node[:slate][:deploy_path]}/middleman" do
        source 'middleman.sh.erb'
        mode '0755'
        variables ({
                     :deploy_path => node[:slate][:deploy_path],
                     :app_path => "#{node[:slate][:deploy_path]}/current",
                     :ruby_bin_dir => node[:languages][:ruby][:bin_dir]
                   })
      end
    end
  when 'apache'
    before_migrate do
      web_app "slate-#{node.chef_environment.gsub('_','')}" do
        template "apache.static.conf.erb"
        server_name node[:slate][:server][:name]
        server_aliases node[:slate][:server][:aliases]
        docroot "#{node[:slate][:deploy_path]}/current/build"
      end

      template "#{node[:slate][:deploy_path]}/build.sh" do
        source 'build.sh.erb'
        variables ({
                     :deploy_path => node[:slate][:deploy_path],
                     :app_path => "#{node[:slate][:deploy_path]}/current",
                     :ruby_bin_dir => node[:languages][:ruby][:bin_dir]
                   })
        mode '0755'
      end
    end
    before_restart do
      execute 'slate-build-static' do
        path [node[:languages][:ruby][:bin_dir]]
        cwd node[:slate][:deploy_path]
        command "#{node[:slate][:deploy_path]}/build.sh"
        only_if "test -f #{node[:slate][:deploy_path]}/build.sh"
      end
    end
  when 'nginx'

  end
end
