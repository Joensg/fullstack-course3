class Racer
  # include Mongoid::Document

  attr_accessor :id, :number, :first_name, :last_name, :gender, :group, :secs

  @@db = nil

  def initialize(params={})
    @id = params[:_id].nil? ? params[:id] : params[:_id].to_s
    @number = params[:number].to_i
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @gender = params[:gender]
    @group = params[:group]
    @secs = params[:secs].to_i
  end

  def self.all(prototype = {}, sort = {:number => 1}, skip = 0, limit = nil)
    result = collection.find(prototype).sort(sort).skip(skip)
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
    mongo_client unless @@db
    @@db[:racers]
  end

  def self.find id
    result = collection.find(_id: BSON::ObjectId.from_string(id)).first
    return result.nil? ? nil : Racer.new(result)
  end

  def save
    result = self.class.collection.insert_one(
      number: self.number,
      first_name: first_name,
      last_name: last_name,
      gender: gender,
      group: group,
      secs: secs
    )
    @id = result.inserted_id.to_s
  end

  def update(params)
    @number = params[:number].to_i
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @gender = params[:gender]
    @group = params[:group]
    @secs = params[:secs].to_i

    racer = self.class.collection.find(_id: BSON::ObjectId.from_string(@id)).first

    self.class.collection.find(_id: racer[:_id]).replace_one(
      number: self.number,
      first_name: first_name,
      last_name: last_name,
      gender: gender,
      group: group,
      secs: secs
    )
  end

  def destroy
    racer = self.class.collection.find(number: @number)
    racer.delete_one
  end

end
