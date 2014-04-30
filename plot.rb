#!/usr/bin/env ruby

require 'csv'

file_names = Dir.entries('./results').select { |file| file.include? '.csv' }
file_names.each do |file_name|
  columns = 0
  CSV.foreach('./results/' + file_name) do |row|
    columns = row.length
    break
  end
  puts columns
  file_name.slice!('.csv')
  parts = file_name.split('__')
  metric = parts[1] 
  name = './results/' + file_name
  puts "gnuplot -e \"columns=#{columns - 1} ; metric='#{metric}' ; name= '#{name}'\" plotter.p"
  output = `gnuplot -e "columns=#{columns - 1} ; metric='#{metric}' ; name= '#{name}'" plotter.p`
  puts output
end

# colnum is the number of columns you want to plot, metric is the y axix label, 
# name  is the name of the csv input file for example "test.csv". it will create a .ps output file
