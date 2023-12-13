require_relative 'models/plan'
require_relative 'models/plan/price'

# 単一のPlanのインスタンスを作成
plan = Plan.new(id: 1, name: "プランA", code: "CODE001")

# 複数のPriceインスタンスをPlanに関連付け
plan.prices = [
  Plan::Price.new(id: 1, ampere: 10, charge: 1000),
  Plan::Price.new(id: 2, ampere: 20, charge: 2000),
  Plan::Price.new(id: 3, ampere: 30, charge: 3000)
]

# Planの詳細を出力
puts "Plan: #{plan.name} (Code: #{plan.code})"
puts "Prices:"

# Planに関連するPriceの詳細を出力
plan.prices.each do |price|
  puts "  - Ampere: #{price.ampere}, Charge: #{price.charge}"
end