class Racer
  include Mongoid::Document

  def mongo_client
    Mongoid::Clients.default
  end

end
