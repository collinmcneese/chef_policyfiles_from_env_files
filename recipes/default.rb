#
# Cookbook:: policyfiles_from_env_files
# Recipe:: default
#

log "#{node['some_default_attr']}"
log "#{node['some_default_attr']['some_default_attr_nested']}"
log "#{node['some_default_attr_flat']}"
