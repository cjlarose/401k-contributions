require 'bigdecimal'

REMAINING_PAY_PERIODS = 13
MAX_ANNUAL_EMPLOYEE_CONTRIBUTION = BigDecimal '19500.00'

annual_gross_salary = BigDecimal ARGV[0]
elective_deferral_ytd = BigDecimal ARGV[1]
elective_deferral_percentage = BigDecimal(ARGV[2]) / 100

def simulate_pay_period(params)
  annual_gross_salary = params[:annual_gross_salary]
  elective_deferral_ytd = params[:elective_deferral_ytd]
  elective_deferral_percentage = params[:elective_deferral_percentage]

  gross_paycheck = annual_gross_salary / 26
  employee_contribution = [(gross_paycheck * elective_deferral_percentage).round(2),
                           MAX_ANNUAL_EMPLOYEE_CONTRIBUTION - elective_deferral_ytd].min
  #employee_contribution = (gross_paycheck * elective_deferral_percentage).round(2)
  effective_contribution_percentage = employee_contribution / gross_paycheck

  employer_contribution_percentage = [effective_contribution_percentage, BigDecimal('0.06')].min / 2
  employer_contribution = (gross_paycheck * employer_contribution_percentage).round(2)
  total_contribution_this_paycheck = employee_contribution + employer_contribution

  new_elective_deferral_ytd = elective_deferral_ytd + employee_contribution

  puts "ytd: #{elective_deferral_ytd.to_s('F')}"
  puts "employee_contribution: #{employee_contribution.to_s('F')}"
  puts "employer_contribution: #{employer_contribution.to_s('F')}"
  puts "employer_contribution_percentage: #{employer_contribution_percentage.to_s('F')}"
  puts "total_contribution_this_paycheck: #{total_contribution_this_paycheck.to_s('F')}"
  puts "new_elective_deferral_ytd: #{new_elective_deferral_ytd.to_s('F')}"
  puts

  {
    annual_gross_salary: annual_gross_salary,
    elective_deferral_ytd: new_elective_deferral_ytd,
    elective_deferral_percentage: elective_deferral_percentage,
  }
end

start = {
  annual_gross_salary: annual_gross_salary,
  elective_deferral_ytd: elective_deferral_ytd,
  elective_deferral_percentage: elective_deferral_percentage,
}
REMAINING_PAY_PERIODS.times.reduce start do |current|
  simulate_pay_period current
end
