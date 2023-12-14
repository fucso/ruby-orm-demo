require 'sequel'
require_relative '../../models/plan.rb'
require_relative './demand_charge_repository.rb'
require_relative './energy_charge_repository.rb'

DB = Sequel.connect('postgres://postgres:password@db:5432/mydatabase')
BUILDERS = {
  demand_charges: Repository::Sequel::DemandChargeRepository,
  energy_charges: Repository::Sequel::EnergyChargeRepository
}

module Repository
  module Sequel
    class PlanRepository

      class << self
        def all()
          plans = DB[:plans].all
          plan_ids = plans.map { |p| p[:id] }
          relations = BUILDERS.keys.map do |table|
            records = DB[table].where(plan_id: plan_ids).all
            [table, records.group_by { |r| r[:plan_id] }]
          end.to_h
          
          plans.map do |plan|
            id = plan[:id]
            sub_models = relations.map do |table, record_by_plan|
              rows = record_by_plan[id]
              [table, rows.map { |row| BUILDERS[table].to_model(row) }]
            end.to_h
            Plan.new(**(plan.merge(sub_models)))
          end
        end
      end
    end
  end
end