require_relative 'repositories/sequel/plan_repository.rb'

# PlanRepositoryを使ってPlanの一覧を取得
plans = Repository::Sequel::PlanRepository.all
puts "all: #{plans.size} plans found."
