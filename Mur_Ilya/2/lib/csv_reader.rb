class CSVReader
  attr_reader :csv_rows

  def initialize(csv_path)
    @csv_rows = CSV.read(csv_path).map(&:join)
  end

  def filter_by_domains
    csv_rows.reject { |row| row.count('.') > 1 }
  end

  def filter_by_opensourse(data_path)
    opensourse_data = CSV.read(data_path).map(&:join)

    csv_rows.select do |row|
      opensourse_data.find { |res| row.index(res.downcase) }
    end
  end
end
