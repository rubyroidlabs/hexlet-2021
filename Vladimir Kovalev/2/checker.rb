require 'csv'
require 'net/http'
require 'benchmark'
require 'digest'
require 'yaml'
require 'optparse'
require 'singleton'
require 'fileutils'

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

a = CSV.read 'test.csv'
a.uniq!


a.reject do |e|
  e.count('.') > 2
end if Options.nosubdomains

b = {}
a.each.with_index(1) {|e,i| b[i] = {host: e[0]} }




class UrlCache
	@@cache_dir_name = ".cache"
	@@cache_dir = File.join(Dir.pwd, @@cache_dir_name)
	class << self
		def fetch(url)
      f = self::filename(url)
      puts "#{Time.now.to_i - File.atime(f).to_i} < #{60 * 60}" if Options.verbose
			if self::exist?(f) && (Time.now.to_i - File.atime(f).to_i) < 60 * 60
				YAML.load(IO.read(f))
			else
				false
			end
		end

		def hash_of_file(url)
			Digest::MD5.hexdigest url
		end

		def filename(url)
			File.join(@@cache_dir, hash_of_file(url))
		end

		def push(url, data)
      FileUtils.rm self::filename(url) if self::exist?(self::filename(url)) 
			IO.write(self::filename(url), data.to_yaml)
		end
		
		def exist?(file)
			Dir.mkdir @@cache_dir unless Dir.exist? @@cache_dir
			File.exist? file
		end
	end
end

class Body
	attr_reader :body
	def initialize(body)
		@body = body
	end
	def match_keyword?(keyword)
	end
end

def info(h)
	print "#{h[:code]} (#{h[:time]})"
end

total = a.count
1.upto(total) do |i|
	
	print "#{100 / total * i}% - #{b[i][:host]} - "
	
	if cached = UrlCache.fetch(b[i][:host])
		b[i] = cached
		puts " cached #{info(b[i])}"
		next
	end

	uri = URI::HTTP.build(:host => b[i][:host])
	res = nil

	begin
		time = Benchmark.measure do
			res = Net::HTTP.get_response(uri)
		end
		b[i].merge!({ code: res.code,
			 time: time.real.truncate > 0 ? "#{time.real.truncate}s" : "#{time.real.to_s.split('.')[1][0..2]}ms",
			 body: Body.new(res.body) })
	rescue => e
		b[i].merge!({ code: e.message })
	ensure
		UrlCache.push(b[i][:host], b[i])
	end

	print " #{info(b[i])} "
	puts "done"
end
out = Hash.new(0)
b.map { |e| e[1][:code] }.each do |e|
  out[e] += 1
end

puts out



