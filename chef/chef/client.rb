log_level        :info
log_location     STDOUT
chef_zero.enabled true
Ohai::Config[:plugin_path] += [
'/opt/chef/embedded/lib/ruby/gems/*/gems/ohai-*/lib/ohai/plugins'
]
