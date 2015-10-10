require "csv"
require 'table_print'
require 'json'

class Chair
  def initialize
    @result = []
  end

  def result(task='task1', param=nil)
    if task == 'task1'
      fill_array('task1.csv')
      find_identical_first_names(param)
    elsif task == 'task2'
      left_join('task1.csv', 'task2.csv', param)
    elsif task == 'task3'
      json_format(param)
    end

  end

  private
  def fill_array(file_name)
    @array = []
    if file_name && File.exist?(file_name)
      read_file_to(@array, file_name)
    end
    @array
  end

  def find_identical_first_names(method)
    @array.each do |user|
      table = {}
      table[:first_name] = user[:first_name]
      table[:count] = @array.select {|h| h[:first_name] == user[:first_name] }.count
      @result << table
    end
    output(@result.select {|user| user[:count] > 1}.uniq, method)
  end

  def output(result, method)
    if method == 'csv'
      file_name = "result.csv"
      File.delete(file_name) if File.exist?(file_name)
      CSV.open(file_name, "wb") do |csv|
        csv << result.first.keys
        result.each do |h|
          csv << [ h[:first_name], h[:count] ]
        end
      end
    else
      tp result
    end
  end

  def left_join(file1, file2, method)
    @array = []
    read_file_to(@array, file1)

    File.open(file2).each_with_index do |line, index|
      if index != 0
        hash = {}
        array = line.split(',')
        hash[:id] = array[0].to_i
        hash[:first_name] = array[1]
        hash[:last_name] = array[2][0..-3]
        i = @array.index {|h| h[:id] == hash[:id]}
        @array[i] = hash
      end
    end
    output(@array.map {|user| {first_name: user[:first_name]}}, method)
  end

  def json_format(param=nil)
    @array = []
    read_file_to(@array, 'task1.csv')
    File.open('task2.csv').each_with_index do |line, index|
      if index != 0
        hash = {}
        array = line.split(',')
        hash[:id] = array[0].to_i
        hash[:first_name] = array[1]
        hash[:last_name] = array[2][0..-3]
        @result << @array.select {|h| h[:id] == hash[:id]}
      end
    end
    @result = @result.flatten
    file_name = "result.json"
    File.delete(file_name) if File.exist?(file_name)
    if param.nil?
      puts "Please enter user id"
    else
      user = @result.find {|user| user[:id] == param.to_i}
      if user.nil?
        puts "User isn't found"
      else
        puts user
        File.open(file_name,"w") do |f|
          f.write({data: user}.to_json)
        end
      end
    end
  end

  def read_file_to(array, file)
    File.open(file).each_with_index do |line, index|
      if index != 0
        hash = {}
        tmp_array = line.split(',')
        hash[:id] = tmp_array[0].to_i
        hash[:first_name] = tmp_array[1]
        hash[:last_name] = tmp_array[2][0..-3]
        array << hash
      end
    end
    array
  end
end

Chair.new.result(ARGV[0], ARGV[1])