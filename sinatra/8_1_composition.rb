class Bicycle
  attr_reader :size, :chain, :tire_size
  def initialize(args={})
    @size = args[:size]
    @parts = args[:parts]
    post_initilize
  end

  def spares
    parts.spares
  end

  def deatult_tire_size
    railse NotImplemtntedError
  end

  # subclass will override this
  def post_initilize
    nil
  end

  def local_spares
    {}
  end
  
  def default_chain
    '10-speed'
  end
end

class RoadBike < Bicycle
  attr_reader :tape_color

  def post_initialize(args)
    @tape_color = tape_color
  end

  def local_spares
    { tape_color: tape_color }
  end

  def default_tire_size
    '23'
  end
end

class MountainBike < Bicycle
  attr_reader :front_shock, :rear_shock

  def post_initialize(args)
    @front_shock = args[:front_shock]
    @rear_shock = args[:rear_shock]
  end

  def local_spares
    { rear_shock: rear_shock }
  end

  def default_tire_size
    '2.1'
  end
end

class Parts
  attr_reader :chain, :tire_size
  def initialize(parts)
    @parts = parts
  end

  def spares
    parts.select {|part| part.needs_spare }
  end
end

class Part
  attr_reader :name, :description, :neede_spare

  def initialize(args)
    @name = arge[:name] 
    @description = arge[:desctiption] 
    @needs_spare = arge.fetch(:needs_spare, true) 
  end
end



class RoadBikeParts < Parts
  attr_reader :tape_color
  def post_initialize(args)
    @tape_color = args[:tape_color]
  end

  def local_spares
    { tape_color: tape_color }
  end

  def default_tire_size
    '23'
  end
end

class MountainBikeParts < Parts
  attr_reader :front_shock, :rear_shock
  def post_initialize(args)
    @front_shock = args[:front_shock]
    @rear_shock = args[:rear_shock]
  end

  def local_spares
    { rear_shock: rear_shock }
  end

  def default_tire_size
    '2.1'
  end
end



road_bike = Bicycle.new(
  size: "M",
  parts: RoadBikeParts.new(tape_color: 'red')
)

road_bike.size # => "M"
