class Racer
  include Mongoid::Document

  @@db = nil

  def self.all(prototype = {}, sort = {:number => 1}, skip = 0, limit = nil)
    result = self.collection.find(prototype).sort(sort).skip(skip)
    result = result.limit(limit) unless limit.nil?
    return result
  end

  # a class method that returns a MongoDB Client configured to communicate to the default database
  # as specified in the config/mongoid.yml file
  def self.mongo_client
    @@db = Mongoid::Clients.default
  end

  # a class method that returns the racers MongoDB Collection object
  def self.collection
    self.mongo_client unless @@db
    @@db[:racers]
  end

end
