require_relative '../../models/plan/demand_charge.rb'

module Repository
  module Sequel
    class DemandChargeRepository
      class << self
        def to_model(record)
          Plan::DemandCharge.new(**(record.reject { |k, v| k == :plan_id }))
        end
      end
    end
  end
end