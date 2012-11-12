module IdeeliSpinup
class Hostname
  include Enumerable

  def initialize ( hostname )
    @hostname = hostname   
  end

  def each
    @hostname.split('.').each do |x|
      yield x
    end
  end

  def numeric_part
    match = self.first.match(/([0-9]+)$/)
    match ? match[0].to_i : nil
  end

  def to_s
    @hostname
  end
end

end
