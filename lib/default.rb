class Default
  
  attr_accessor :pattern, :right
  
  def initialize(pattern, right)
    @pattern = Regexp.new pattern
    @right = right
  end
  
end