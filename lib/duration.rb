class Duration 
  attr_accessor :seconds
  include Comparable

  UNITS = { :second => 1, 
            :minute => 60,
            :hour   => 60*60, 
            :day    => 60*60*24, 
            :year   => 60*60*24*365 }

  def initialize(description)
    case description
    when String
      value, units = description.to_s.split
      multiplier = units.nil? ? 1 : UNITS[units.downcase.chomp('s').to_sym]
      if multiplier.nil? then raise "Unknown duration units '#{units}'" end    
      @seconds = value.to_i * multiplier
    when Integer, Fixnum, Float
      @seconds = description 
    else raise "Invalid duration criteria #{description}"
    end
  end

  def <=>(other)
    @seconds <=> other.seconds
  end

  def method_missing(name, *args, &blk)
    ret = @seconds.send(name, *args, &blk)
    ret.is_a?(Numeric) ? Duration.new(ret) : ret
  end

  def approx_human_description
    units, value = UNITS.map{|k,v| [k.to_s,@seconds.to_f/v]}.
                         find_all{|i| i[1] >= 1}.sort_by(&:last).first
    value = value < 5 ? ((value*10).round)/10 : value.round
    units += 's' unless value == 1
    "#{value} #{units}"
  end

end 

