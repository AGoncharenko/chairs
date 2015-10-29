require "csv"
require 'table_print'
require 'optparse'
require 'json'

class Eco
  def initialize(task, params=nil)
    @options = {}
    OptionParser.new do |opt|
      opt.on('-t', '--task TASK (e.g. task1)') { |o| @options[:task] = o }
      opt.on('-f', '--format FORMAT (e.g. csv)') { |o| @options[:format] = o }
      opt.on('-i', '--user_id USER_ID (e.g. 1)') { |o| @options[:user_id] = o }
    end.parse!

    @task = task
    @params = params
    @result = []
  end

  def result
    self.send(@options[:task]) if self.respond_to?(@options[:task], true)
  end

  private

  def task1
    array = MyCsv.read('task1.csv')
    tmp = []
    hash = Hash.new(0)

    #select only first_names from csv
    array.each_with_index do |arr, index|
      next if index == 0
      tmp << arr[1]
    end

    #count first_names
    tmp.each do |v|
      hash[v] += 1
    end

    # form result
    hash.each {|k,v| @result << {first_name: k, count: v} if v > 1}
    output(__method__)
  end

  def task2
    array1 = MyCsv.read('task1.csv')
    array2 = MyCsv.read('task2.csv')
    tmp = []
    array1.each_with_index do |arr, index|
      next if index == 0
      tmp << array2.select {|a| a[0] == arr[0]}
    end
    tmp.each do |v|
      if v.empty?
        @result << {first_name: 'NULL'}
      else
        @result << {first_name: v[0][1]}
      end
    end
    output(__method__)
  end

  def task3(id)
    return puts "Please specify user_id" unless id
    array1 = MyCsv.read('task1.csv')
    array2 = MyCsv.read('task2.csv')
    tmp = []
    result = {data: {}}
    array2.each_with_index do |arr, index|
      next if index == 0
      element = array1.select {|a| a[0] == arr[0]}
      (tmp << {id: element[0][0], first_name: element[0][1], last_name: element[0][2]}) if !element.empty?
    end
    result[:data] = tmp.find {|hash| hash[:id] == id }
    result
  end

  def output(task)
    if @options[:format] == 'csv'
      file_name = MyCsv.write(task, @result)
      puts "Please find result in #{file_name}"
    else
      tp @result
    end
  end

end

class MyCsv
  def self.read(file)
    CSV.read(file)
  end

  def self.write(file, data)
    file_name = "result_#{file}.csv"
    File.delete(file_name) if File.exist?(file_name)
    CSV.open(file_name, "wb") do |csv|
      csv << data.first.keys
      data.each do |h|
        csv << [ h[:first_name], h[:count] ]
      end
    end
    file_name
  end
end

# Eco.new(ARGV[0], ARGV[1]).result