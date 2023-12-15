require 'active_record'
require_relative './demand_charge.rb'
require_relative './energy_charge.rb'

module Repository
  module ActiveRecord
    module Model
      class Plan < ::ActiveRecord::Base
        has_many :demand_charges, class_name: '::Repository::ActiveRecord::Model::DemandCharge'
        has_many :energy_charges, class_name: '::Repository::ActiveRecord::Model::EnergyCharge'
      end
    end
  end
end