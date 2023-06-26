require "csv"

nutrition = CSV.read("dailysummary.csv")[1..-1]
calories = nutrition.map{|row| [row[0], row[1].to_i]}.to_h
protein = nutrition.map{|row| [row[0], row[-6].to_i]}.to_h

exercise = CSV.read("exercises.csv")[1..-1]

# Collect exercise calories per day, handling multiple exercises per day:
exercise_calories = exercise.reduce({}) do |acc, row|
    date = row[0]
    kcal = -row[3].to_i
    if acc.key?(date)
        acc[date] += kcal
    else
        acc[date] = kcal
    end
    acc
end

last_day = Date.today - 1
#first_day = Date.strptime("2022-11-08", "%Y-%m-%d")
first_day = last_day - 60

period = (last_day - first_day).to_i

sum_kcal = 0
sum_protein = 0
tracked_days = 0

first_day.upto(last_day) do |day|
    date = day.strftime("%Y-%m-%d")
    if calories.key?(date)
        kcal = calories[date]
        sum_kcal += kcal
        puts "#{date} #{kcal} Cronometer"

        negative_kcal = exercise_calories[date]
        if negative_kcal
            sum_kcal -= negative_kcal
            puts "#{date} -#{negative_kcal} Sport"
        end

        sum_protein += protein[date]
        tracked_days += 1
    end
end

puts
puts "Average kcal: #{sum_kcal / tracked_days}"
puts "Average protein: #{sum_protein / tracked_days}"
