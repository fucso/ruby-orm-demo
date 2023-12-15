require 'active_record'

module Repository
  module ActiveRecord
    module Model
      class EnergyCharge < ::ActiveRecord::Base
        belongs_to :plan
      end
    end
  end
end