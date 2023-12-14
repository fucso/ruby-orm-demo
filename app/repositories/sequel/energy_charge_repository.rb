require_relative '../../models/plan/energy_charge.rb'

module Repository
  module Sequel
    class EnergyChargeRepository
      class << self
        def to_model(record)
          Plan::EnergyCharge.new(**(record.reject { |k, v| k == :plan_id }))
        end
      end
    end
  end
end