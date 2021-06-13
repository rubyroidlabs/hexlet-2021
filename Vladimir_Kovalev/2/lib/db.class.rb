class Db
  class << self
    def load_file(csv_file)
      @@all_data = CSV.read(csv_file).uniq
    end

    def csv
      @@all_data
    end

    def subdomains_clear
      @@all_data.reject! do |e|
        subdomain = Domainatrix.parse(e).subdomain
        true if subdomain.length.positive? && subdomain != "www"
      end
    end

    def total
      @@all_data.count
    end

    def populate
      @@result = {}
      @@all_data.each.with_index(1) do |e, i|
        @@result[i] = { host: e[0] }
      end
    end

    def result
      @@result
    end

    def out
      out = { Total: 0, Success: 0, Failed: 0, Errored: 0 }
      @@result.map { |e| e[1][:code] }.each do |e|
        case e
        when /^[23]/
          out[:Success] += 1
        when /^[45]/
          out[:Failed] += 1
        else
          out[:Errored] += 1
        end
        out[:Total] += 1
      end
      out
    end
  end
end
