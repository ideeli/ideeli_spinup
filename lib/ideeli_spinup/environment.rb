module IdeeliSpinup
class Environment
  attr_reader :compute, :subnet, :region

  def initialize ( config, options )
    @accounts = config[:accounts]
    account   = options[:account] || default_account_name
    keys      = @accounts[account]
    @images   = config[:images]
    @region   = options[:region]
    @subnet   = nil

    if options[:subnet]
      @subnet = config[:subnets][options[:subnet]][:id]
    end

    fog_opts = { :aws_access_key_id     => keys[:aws_access_key_id],
                 :aws_secret_access_key => keys[:aws_secret_access_key],
                 :provider              => 'AWS', 
                 :region                => @region }

    @compute = Fog::Compute.new(fog_opts)
  end

# Get the key name of the default account
#
# Returns a String that is a key into the @accounts Hash.
  def default_account_name
    return @accounts.first[0] if @accounts.size == 1
    @accounts['default'] ? 'default' : nil
  end

# Public: Return an Array of available availability zones
#         within the current AWS region
#
# Examples
#
#   o.availability_zones
#   # => ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e"]
#
# Returns an Array of Strings that are the names of the 
# availability zones
#
  def availability_zones
    return [az_from_subnet] if @subnet

    az_info = @compute.describe_availability_zones.body["availabilityZoneInfo"]
    az_info.select { |x| x['zoneState'] == 'available' }.map { |x| x['zoneName'] }.sort
  end

  def az_from_subnet
    @compute.subnets.select { |x| x.subnet_id == @subnet }.first.availability_zone  
  end
# Internal: Return the AWS ami name for the current region 
#           given a user friendly.  If name starts with ami-
#           fallthrough and return the passed in String.
#
# name - The friendly name
#
# Examples
#   
#   o.image_from_name('lucid64')
#   # => "ami-3fe54d56"
#
#   o.image_from_name('ami-3fe54d56')
#   # => "ami-3fe54d56"
#
# Returns a String of the ami name.
#
  def image_from_name ( name )
    name =~ /^ami-/ ? name : @images[@region][name]  
  end
end # class


end # module
