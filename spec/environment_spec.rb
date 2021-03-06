require 'ideeli_spinup'
require 'fog'

describe IdeeliSpinup::Environment do
  before do
    Fog.mock!
    @base_options = { :region         => 'us-east-1',
                      :image          => 'lucid64',
                      :security_group => 'default' }
 
    @base_config = { :accounts => { 'account' => 
                     { :aws_access_key_id     =>"ABCDEFG",
                       :aws_secret_access_key =>"ABCDEFG" } },
                    :images    => { "us-east-1" => {"lucid64"=>"ami-1234abcd"} },
                    :keys      => { 'us-east-1' => 'mykeypair' } 
                   } 
  end

  describe "#default_account_name" do
    context "one account" do
      let(:env) { IdeeliSpinup::Environment.new(@base_config, @base_options) }

      it "should return 'account' as the default account name" do
        env.default_account_name.should == 'account'
      end
    end

    context "multiple accounts" do
      let(:env) do 
        config = @base_config
        config[:accounts].merge!('default' =>
                    { :aws_access_key_id     =>"ABCDEFG",
                      :aws_secret_access_key =>"ABCDEFG" })

        IdeeliSpinup::Environment.new(config, @base_options)
      end

      it "should return 'default' as the default account name" do
        env.default_account_name.should == 'default'
      end
    end
  end

  describe "#availability_zones" do
    let(:env) { IdeeliSpinup::Environment.new(@base_config, @base_options) }

    it "should return a non-empty array of AZs" do
      env.availability_zones.empty?.should be_false
    end
  end

  describe "#image_from_name" do
    let(:env) do 
      IdeeliSpinup::Environment.new(@base_config, @base_options) 
    end

    context "friendly name" do
      it "should return ami-1234abcd" do
        env.image_from_name('lucid64').should == 'ami-1234abcd'  
      end
    end

    context "ami name" do
      it "should return ami-1234abcd" do
        env.image_from_name('ami-1234abcd').should == 'ami-1234abcd'  
      end
    end
  end
  

   describe '#subnet_from_name' do
     let(:env) do
       config = @base_config
       config[:subnets] = { "public"=> {:region=>'us-east-1', :id => 'subnet-1234abcd'} }
       IdeeliSpinup::Environment.new(config, @base_options) 
     end
 
     context "friendly name" do
       it "should return 'subnet-1234abcd'" do
         env.subnet_from_name('public').should == 'subnet-1234abcd'
       end
     end

     context "subnet name" do
       it "should return 'subnet-1234abcd'" do
         env.subnet_from_name('subnet-1234abcd').should == 'subnet-1234abcd'
       end

       it "should raise an error when a subnet not present in the config is specified" do
         lambda { env.subnet_from_name('pants') }.should raise_error 
       end
     end
   end
     
   describe '#regional_subnets' do
     let(:config) do
       config = @base_config
       config[:subnets] = { "subnet_east" => {:region => 'us-east-1', :id => 'subnet-1234abcd' },
                            "subnet_west" => {:region => 'us-west-1', :id => 'subnet-5678efef' } }
       config
     end

     let(:env) { IdeeliSpinup::Environment.new(config, @base_options) }

     it "should only return only 1 key" do
       env.regional_subnets(config[:subnets]).size.should == 1
     end

     it "the key should be 'subnet_east'" do
       env.regional_subnets(config[:subnets]).keys.first.should == 'subnet_east'
     end
 
   end

   describe '#security_group_from_name' do
     let(:env) { IdeeliSpinup::Environment.new(@base_config, @base_options)  }

     it "should return a sg- string if passed a friendly name of default" do
       env.security_group_from_name('default').should =~ /^sg-/
     end

     it "should return sg-abcd1234 if passed a sg" do
       env.security_group_from_name('sg-abcd1234').should == "sg-abcd1234"
     end

     it "should raise an exception if there is no matching friendly name" do
       lambda { env.security_group_from_name('bogus')}.should raise_error
     end

   end
end
