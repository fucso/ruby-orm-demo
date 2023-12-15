require 'active_record'

module Repository
  module ActiveRecord
    module Model
      class DemandCharge < ::ActiveRecord::Base
        belongs_to :plan
      end
    end
  end
end