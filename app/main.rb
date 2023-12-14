require_relative 'repositories/sequel/plan_repository.rb'

capacity_cases = [10, 20, 30, 40, 50, 60, 61, 490, 500]
def count_time(times: 1)
  start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  times.times { yield if block_given? } 
  end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  execution_time = end_time - start_time
  execution_time # 返り値として実行時間を秒単位で返す
end

# sequel
time = count_time(times: 100) do
  plans = Repository::Sequel::PlanRepository.all
  capacity_cases.each do |capacity|
    plans = Repository::Sequel::PlanRepository.find_by_capacity(capacity)
  end
end
puts "sequel: #{time} sec"