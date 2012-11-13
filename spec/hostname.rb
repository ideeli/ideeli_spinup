require 'ideeli_spinup'


describe IdeeliSpinup::Hostname do
  context "normal" do
    let(:hostname) {  IdeeliSpinup::Hostname.new('foo12.bar.com') }
    
    describe '#to_s' do
      it "should return the hostname string" do
        hostname.to_s.should == "foo12.bar.com"
      end
    end

    describe '#each' do 
      it "should return the first part of the hostname" do
        hostname.first.should == 'foo12'
      end
    end
  end

  context "numeric hostname" do
    let(:hostname) { IdeeliSpinup::Hostname.new('foo12.bar.com') }

    describe '#numeric_part' do
      it "should return the numeric part of the hostname" do
        hostname.numeric_part.should == 12
      end
    end
  end

  context "non-numeric hostname" do
    let(:hostname) { IdeeliSpinup::Hostname.new('foo.bar.com') }

    describe '#numeric_part' do
      it "should return nil" do
        hostname.numeric_part.nil?.should be_true
      end
    end
  end
end
