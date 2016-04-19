class Tweet < ActiveRecord::Base
   belongs_to :user
  # attr_reader :username, :status
  
  # ALL = []

  # def initialize(username, status)
  #   @username = username
  #   @status = status
  #   ALL << self
  # end

  # def username
  #   @username
  # end

  # def status
  #   @status
  # end

  # def self.all
  #   ALL
  # end
end