require 'sendgrid/api/entities/entity'

module Sendgrid
  module API
    module Entities
      class Email < Entity

        attribute :email, :name, :unsubscribe_code, :username

      end
    end
  end
end