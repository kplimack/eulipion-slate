include_attribute 'apache2'
include_attribute 'nginx'
include_attribute 'passenger_apache2'

# Fork the repo and set this to your fork.
default[:slate][:repo] = 'https://github.com/kplimack/slate.git'
default[:slate][:rev] = 'HEAD'
default[:slate][:deploy_key_method] = nil
default[:slate][:deploy_key_path] = 'keys/slate'

default[:slate][:deploy_path] = '/data/www/slate'

# Server Values: 'middleman'

default[:slate][:server] = {
  server: 'apache', # Server Values: nil, 'middleman', 'apache', 'nginx'
  name: "slate.#{chef_environment.gsub('_', '')}.#{domain}",
  aliases: %w( )
}

default[:slate][:deps] = {
  cookbooks: %w( git build-essential ),
  packages: %w( )
}
