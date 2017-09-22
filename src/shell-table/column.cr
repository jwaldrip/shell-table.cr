class ShellTable::Column
  property value : String
  property color : Symbol? = nil

  def initialize(value = nil)
    @value = value.to_s
  end

  def ansi_delta
    to_s.size - size
  end

  def size
    @value.to_s.gsub(/\x1b\[[0-9;]*[mG]/, "").size
  end

  def to_s(io)
    @value.to_s(io)
  end
end
