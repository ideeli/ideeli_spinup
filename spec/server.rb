require 'fog'
require 'ideeli_spinup'

describe IdeeliSpinup::Server do
  before do
    Fog.mock!
    options = { :region         => 'us-east-1',
                :image          => 'lucid64', 
                :security_group => 'default' }
 
    config = { :accounts => { 'account' => 
               { :aws_access_key_id     =>"ABCDEFG",
                 :aws_secret_access_key =>"ABCDEFG" } },
              :images    => { "us-east-1" => {"lucid64"=>"ami-1234abcd"} },
              :keys      => { 'us-east-1' => 'mykeypair' } 
             } 
    @env = IdeeliSpinup::Environment.new(config, options)
    
  end

  describe '#calc_az_from_hostname' do
    context 'has number in hostname' do
      let(:server) { IdeeliSpinup::Server.new('foo12.bar.com', @env) }

      it 'should be in us-east-1b' do
        server.calc_az_from_hostname.should == 'us-east-1b'
      end
    end

    context 'no number in hostname' do
      let(:server) { IdeeliSpinup::Server.new('foo.bar.com', @env) }

      it 'should be in us-east-1a' do
        server.calc_az_from_hostname.should == 'us-east-1a'
      end
    end
    
  end
end
