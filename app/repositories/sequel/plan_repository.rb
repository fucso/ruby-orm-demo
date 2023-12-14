require 'sequel'
require_relative '../../models/plan.rb'
require_relative './demand_charge_repository.rb'
require_relative './energy_charge_repository.rb'

DB = Sequel.connect('postgres://postgres:password@db:5432/mydatabase')
QUERY = DB[Sequel[:plans]]
BUILDERS = {
  demand_charges: Repository::Sequel::DemandChargeRepository,
  energy_charges: Repository::Sequel::EnergyChargeRepository
}

module Repository
  module Sequel
    class PlanRepository

      class << self
        def all()
          dataset_to_model(QUERY.all)
        end

        def find_by_capacity(capacity)
          dataset = QUERY.join(:demand_charges, plan_id: :id).select_all(:plans).where(::Sequel.lit('? BETWEEN ampere_from AND ampere_to', capacity))
          dataset_to_model(dataset.all)
        end

        def to_model(record, demand_charges: [], energy_charges: [])
          Plan.new(
            id: record[:id],
            name: record[:name],
            code: record[:code],
            demand_charges: demand_charges,
            energy_charges: energy_charges
          )
        end

        private

        def dataset_to_model(dataset)
          plan_ids = dataset.map { |p| p[:id] }
          relations = BUILDERS.keys.map do |table|
            records = DB[table].where(plan_id: plan_ids).all
            [table, records.group_by { |r| r[:plan_id] }]
          end.to_h
          
          dataset.map do |plan|
            id = plan[:id]
            sub_models = relations.map do |table, record_by_plan|
              rows = record_by_plan[id]
              [table, rows.map { |row| BUILDERS[table].to_model(row) }]
            end.to_h
            to_model(plan, **sub_models)
          end
        end
      end
    end
  end
end