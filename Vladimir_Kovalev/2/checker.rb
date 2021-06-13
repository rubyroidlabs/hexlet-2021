require "csv"
require "benchmark"
require "net/http"
require "digest"
require "yaml"
require "optparse"
require "singleton"
require "fileutils"
require "domainatrix"

Dir["./lib/*.rb"].each { |file| require_relative file }

class Options
  include Singleton
  attr_accessor :verbose, :nosubdomains, :filter, :solutions, :parallel, :cache

  def self.method_missing(*name)
    instance.send(*name)
  end
end

parser = OptionParser.new do |opts|
  opts.banner = "Usage: checker.rb [options] file.csv"

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    Options.verbose = v
  end
  opts.on("--no-subdomains", "Exclude subdomains") do |v|
    Options.nosubdomains = v
  end
  opts.on("--filter=sales", "Body filter") do |v|
    Options.filter = v
  end
  opts.on("--exclude-solutions", "Exclude OpenSource projects") do |v|
    Options.solutions = v
  end
  opts.on("--parallel=N", "Using threads") do |v|
    Options.parallel = v
  end
  opts.on("--no-cache", "Without cache") do |v|
    Options.cache = v
  end
end

begin
  parser.parse!
rescue OptionParser::InvalidOption => e
  puts e
  puts parser.help
  exit
end

if Options.verbose
  p Options.instance
  p ARGV
end

if ARGV.count != 1
  puts parser.help
  exit
end

unless File.exist? ARGV[0]
  puts "File not found"
  puts parser.help
  exit
end

Db.load_file ARGV[0]
Db.subdomains_clear if Options.nosubdomains
Db.populate

def info(row)
  print " #{row[:code]} (#{row[:time]}) "
end

def print_percent(step)
  print "#{100 / Db.total * step}% - "
end

1.upto(Db.total) do |i|
  print_percent(i) unless Options.filter
  print "#{Db.result[i][:host]} - "

  cached = UrlCache.fetch(Db.result[i][:host])
  if cached = UrlCache.fetch(Db.result[i][:host])
    Db.result[i] = cached
    puts " cached #{info(Db.result[i])}"
    next
  end

  uri = URI::HTTP.build(host: Db.result[i][:host])
  res = nil

  begin
    time = Benchmark.measure do
      res = Net::HTTP.get_response(uri)
    end
    time_string = if time.real.truncate.positive?
        "#{time.real.truncate}s"
      else
        "#{time.real.to_s.split(".")[1][0..2]}ms"
      end
    Db.result[i].merge!({ code: res.code,
                          time: time_string,
                          body: Body.new(res.body) })
  rescue => e
    Db.result[i].merge!({ code: e.message })
  ensure
    UrlCache.push(Db.result[i][:host], Db.result[i])
  end

  info(Db.result[i])
  puts "done"
end
puts Db.out
