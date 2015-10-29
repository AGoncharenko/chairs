require 'rspec'
require './eco'

describe Eco do

  let(:task1) do
    "FIRST_NAME | COUNT\n"\
    "-----------|------\n"\
    "Immanuel   | 2    \n"\
    "Luc        | 2    \n"\
    "Malaya     | 2    \n"\
    "Charleen   | 2    \n"\
    "Blake      | 2    \n"\
  end

  it 'should do tasks1' do
    expect { tp.set :io, $stdout; Eco.new('task1', nil).result }.to output(task1).to_stdout
  end
end