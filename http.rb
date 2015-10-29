require 'sinatra'
require './eco'

get '/api/users/:id' do
  content_type :json
  user_id = params[:id]
  result = Eco.new('task3').send('task3', user_id)
  p result
  result.to_json
end