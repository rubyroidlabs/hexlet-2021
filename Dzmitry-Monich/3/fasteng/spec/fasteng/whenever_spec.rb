# frozen_string_literal: true

describe Whenever::Test::Schedule do
  before { load 'Rakefile' }

  it 'rake statements exists' do
    expect(Rake::Task.task_defined?(subject.jobs[:rake].first[:task])).to be_truthy
  end

  it 'cron is registered' do
    expect(subject.jobs[:rake].first[:task]).to eq 'cron:notify'
    expect(subject.jobs[:rake].first[:every]).to eq [:minute]
  end
end
