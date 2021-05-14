# frozen_string_literal: true

describe Fasteng::Config do
  context 'when passed argument is valid' do
    let(:controller_name) { 'polling' }

    it 'config gets controller type' do
      subject.controller = controller_name

      expect(subject.controller).to eq controller_name
    end
  end

  context 'when passed argument not valid' do
    let(:controller_name) { 'wrong' }

    it 'error ocurres' do
      expect { subject.controller = controller_name }
        .to raise_error(ArgumentError, "no such controller: #{controller_name}")
    end
  end
end
