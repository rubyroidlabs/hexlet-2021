class UrlCache
  @@cache_dir_name = ".cache"
  @@cache_dir = File.join(Dir.pwd, @@cache_dir_name)
  class << self
    def fetch(url)
      f = self.filename(url)
      puts "#{Time.now.to_i - File.atime(f).to_i} < #{60 * 60}" if Options.verbose
      if self.exist?(f) && (Time.now.to_i - File.atime(f).to_i) < 60 * 60
        YAML.safe_load(IO.read(f))
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
      FileUtils.rm self.filename(url) if self.exist?(self.filename(url))
      IO.write(self.filename(url), data.to_yaml)
    end

    def exist?(file)
      Dir.mkdir @@cache_dir unless Dir.exist? @@cache_dir
      File.exist? file
    end
  end
end
