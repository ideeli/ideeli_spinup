module IdeeliSpinup
class Server
  attr_accessor :availability_zone, 
                :hostname,
                :subnet
                
  def initialize ( hostname, environment, options = {} )
    @hostname          = IdeeliSpinup::Hostname.new(hostname)
    @environment       = environment
    @subnet            = @environment.subnet
    @availability_zone = options[:availability_zone] || calc_az_from_hostname
    @instance_type     = options[:instance_type]
    @logger            = options[:logger]
    @security_group    = options[:security_group]
  end

  def log ( msg, level = Logger::DEBUG )
    @logger.add(level) { msg } if @logger
  end

  def spinup
    @environment.compute.servers.create( :subnet_id         => @subnet,
                                         :availability_zone => @availability_zone,
                                         :flavor_id         => @instance_type,
                                         :image_id          => @environment.image,
                                         :groups            => [@security_group] )
  end

# Public: Return the String of the availability zone based on a modulus
#         of the hostname.  Return the first available zone if there is 
#         no number at the end of the hostname.  Return the zone passed
#         in if user specified.
#
# Examples
#
#   s = IdeeliSpinup::Server.new( 'server2.foo.com' )
#   s.calc_az
#   # => 'us-east-1b'
#
#   s = IdeeliSpinup::Server.new( 'server2.foo.com', 
#                                 :availability_zone => 'us-east-1c'
#   s.availability_zone = 'us-east-1c'
#   s.calc_az
#   # => 'us-east-1c'
#
# Returns a String of the availability zone
#
  def calc_az_from_hostname
    return @availability_zone if @availability_zone

    zones = @environment.availability_zones
    index = ((@hostname.numeric_part || 1)-1) % zones.size
    zones[index]
  end


end # class
end # module
