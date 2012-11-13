require 'ideeli_spinup'
require 'fog'

describe IdeeliSpinup::Environment do
  before do
    Fog.mock!
    @base_options = { :region            => 'us-east-1',
                      :image             => 'lucid64',
                      :security_group    => 'default' }
 
    @base_config = { :accounts => 
                     { 'account' => 
                       { :aws_access_key_id     =>"ABCDEFG",
                         :aws_secret_access_key =>"ABCDEFG" }
                     }
                   }
    @config = {:subnets=>
                {"vpc1_public"=>{:id=>"subnet-a2790ec9", :region=>"us-east-1"},
                 "vpc1_private"=>{:id=>"subnet-a7790ecc", :region=>"us-east-1"}},
               :classifier=>
                {:url=>"https://ic.ideeli.com:3001",
                 :type=>"iclassify",
                 :username=>"abrown",
                 :password=>"iDftP$Il"},
               :security_groups=>{:"us-east-1"=>"default"},
               :accounts=>
                {"another"=>
                  {:aws_access_key_id=>"ABCDEFG",
                   :aws_secret_access_key=>"ABCDEFG"},
                 "default"=>
                  {:aws_access_key_id=>"123456789",
                   :aws_secret_access_key=>"123456789"}},
               :images=>
                {"us-west-1"=>
                  {"default"=>"ami-73ad8836",
                   "lucid64ebs"=>"ami-19ad885c",
                   "lucid64"=>"ami-73ad8836"},
                 "us-east-1"=>
                  {"default"=>"ami-3fe54d56",
                   "lucid64ebs"=>"ami-d5e54dbc",
                   "lucid64"=>"ami-3fe54d56"}},
               :keys=>{:"us-east-1"=>"mykeypair"}}
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
      config = @base_config
      config[:images] = { "us-east-1"=> {"lucid64"=>"ami-1234abcd"} }
      IdeeliSpinup::Environment.new(config, @base_options) 
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

     let(:env) do
       IdeeliSpinup::Environment.new(config, @base_options) 
     end

     it "should only return only 1 key" do
       env.regional_subnets(config[:subnets]).size.should == 1
     end

     it "the key should be 'subnet_east'" do
       env.regional_subnets(config[:subnets]).keys.first.should == 'subnet_east'
     end
 
   end
end
