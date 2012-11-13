module IdeeliSpinup
class Environment
  attr_reader :compute, 
              :subnet, 
              :region

  def initialize ( config, options )
    @accounts = config[:accounts]
    account   = options[:account] || default_account_name
    keys      = @accounts[account]
    @images   = config[:images]
    @region   = options[:region]
    @subnets  = regional_subnets(config[:subnets])
    @subnet   = subnet_from_name(options[:subnet])

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
# Returns a String of the ami id.
#
  def image_from_name ( name )
    name =~ /^ami-/ ? name : @images[@region][name]  
  end

# Internal: Return the AWS subnet name given a user friendly name.  
#           If name starts with subnet- then fallthrough and 
#           return the passed in String.
#
# name - The friendly name
#
# Examples
#   
#   o.subnet_from_name('public_vpc1')
#   # => "subnet-3fe54d56"
#
#   o.image_from_name('subnet-3fe54d56')
#   # => "subnet-3fe54d56"
#
# Returns a String of the subnet id.
#
  def subnet_from_name ( name )
    return name if name =~ /^subnet-/ || name.nil?

    if @subnets[name]
      @subnets[name][:id]
    else
      raise "Subnet #{name} not found in config."
    end
  end

  def regional_subnets ( subnets )
    return [] unless subnets
    Hash[subnets.select { |k,v| v[:region] == @region }]
  end
end # class

end # module
