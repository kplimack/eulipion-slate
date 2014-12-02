require 'serverspec'
require 'spec_helper'
set :backend, :exec

describe file('/data/www/slate') do
  it { should be_directory }
end

describe file('/data/www/slate/current') do
  it { should be_symlink }
end

describe file('/data/www/slate/releases') do
  it { should be_directory }
end

describe file('/data/www/slate/current/build/index.html') do
  it { should be_file }
end
