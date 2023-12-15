require_relative 'repositories/sequel/plan_repository.rb'
require_relative 'repositories/active_record/plan_repository.rb' 

capacity_cases = [10, 20, 30, 40, 50, 60, 61, 490, 500]
def count_time(times: 1)
  start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  times.times { yield if block_given? } 
  end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  execution_time = end_time - start_time
  execution_time # 返り値として実行時間を秒単位で返す
end

def verify_plan_model(plan)
  dc = plan.demand_charges.length
  ec = plan.energy_charges.length
  
  match_data = plan.code.match(/plan(\d+)/)
  number = match_data[1].to_i

  expected = case number
  when 1..20
    [6, 3]
  when 21..40
    [1, 3]
  when 41..60
    [3, 3]
  when 61..80
    [3, 3]
  when 81..100
    [7, 3]
  else
    nil
  end

  unless dc == expected[0] && ec == expected[1]
    raise "plan #{plan.code} has wrong number of charges\n code: #{plan.code}, expected: #{expected}, dc: #{dc}, ec: #{ec}"
  end
end

# sequel
time = count_time do
  plans = Repository::Sequel::PlanRepository.all
  plans.each { |plan| verify_plan_model(plan) }
  capacity_cases.each do |capacity|
    plans = Repository::Sequel::PlanRepository.find_by_capacity(capacity)
    plans.each { |plan| verify_plan_model(plan) }
  end
end
puts "sequel: #{time} sec"

# ActiveRecord
time = count_time do
  plans = Repository::ActiveRecord::PlanRepository.all
  plans.each { |plan| verify_plan_model(plan) }
  capacity_cases.each do |capacity|
    plans = Repository::ActiveRecord::PlanRepository.find_by_capacity(capacity)
    plans.each { |plan| verify_plan_model(plan) }
  end
end
puts "ActiveRecord: #{time} sec"