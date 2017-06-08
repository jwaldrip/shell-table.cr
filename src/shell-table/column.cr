class ShellTable::Column
  property value : String? = nil
  property color : Symbol? = nil

  def initialize(@value = nil)
  end

  def size
    @value.to_s.size
  end

  def to_s(io)
    @value.to_s(io)
  end
end
