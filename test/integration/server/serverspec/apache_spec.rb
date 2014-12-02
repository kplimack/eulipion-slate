require 'serverspec'
set :backend, :exec

describe "Apache Server" do
  it "is listening on port 80" do
    expect(port(80)).to be_listening
  end

  it "has a running service of apache2" do
    expect(service("apache2")).to be_running
  end
end
