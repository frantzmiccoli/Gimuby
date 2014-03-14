require 'gimuby/dependencies'
require 'gimuby/factory'

module Gimuby

  def self.get_factory
    Factory.new
  end

end