# frozen_string_literal: true

RSpec.describe Checker::Print do
  describe '.to_s' do
    it 'print status of requests' do
    end
  end
  it { should respond_to(:to_s) }
  it { should respond_to(:logger) }
  it { should respond_to(:console_print) }
end
