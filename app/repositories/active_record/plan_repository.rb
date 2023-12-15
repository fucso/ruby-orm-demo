require 'active_record'
require_relative './models/plan.rb'
require_relative '../../models/plan.rb'
require_relative '../../models/plan/demand_charge.rb'
require_relative '../../models/plan/energy_charge.rb'

# Establish ActiveRecord database connection
root_dir = File.expand_path('../..', __dir__)
ActiveRecord::Base.establish_connection(
  adapter:  'postgresql',
  host:     'db',
  username: 'postgres',
  password: 'password',
  database: 'mydatabase',
  pool:     5,
  timeout:  5000
)

module Repository
  module ActiveRecord
    class PlanRepository

      class << self
        def all
          plans = Repository::ActiveRecord::Model::Plan.includes(:demand_charges, :energy_charges).all
          plans.map { |plan| to_model(plan) }
        end

        def find_by_capacity(capacity)
          plans = Repository::ActiveRecord::Model::Plan.joins(:demand_charges)
                .where('demand_charges.ampere_from <= ? AND demand_charges.ampere_to >= ?', capacity, capacity)
          plans.map { |plan| to_model(plan) }
        end

        def to_model(plan)
          demand_charges = plan.demand_charges.map { |demand_charge| Plan::DemandCharge.new(**demand_charge.attributes.symbolize_keys.reject { |k, v| k == :plan_id }) }
          energy_charges = plan.energy_charges.map { |energy_charge| Plan::EnergyCharge.new(**energy_charge.attributes.symbolize_keys.reject { |k, v| k == :plan_id }) }
          Plan.new(**plan.attributes.symbolize_keys.merge(demand_charges: demand_charges, energy_charges: energy_charges))
        end
      end

    end
  end
end