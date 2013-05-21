ROOT = File.dirname(File.absolute_path(__FILE__))

require ROOT + "/flickr-store/version"

require 'securerandom'
require 'tempfile'
require 'open-uri'
require 'fileutils'
require "png-encode"
require "flickraw"

FlickRaw.secure = true

module Flickr
  class Store
    DICT_FILE = Dir.home + '/.flickr-store'

    def self.authenticate(key, secret)
      FlickRaw.api_key = key
      FlickRaw.shared_secret = secret

      token = flickr.get_request_token
      auth_url = flickr.get_authorize_url(token['oauth_token'], perms: 'delete')

      `open #{auth_url}`
      puts "Visit this URL in your browser: #{auth_url}"
      puts "Paste the number given after logging in:"
      verify = gets.strip

      begin
        flickr.get_access_token(token['oauth_token'], token['oauth_token_secret'], verify)
        login = flickr.test.login

        puts "Authentication complete! Logged in as #{login.username}."
      rescue FlickRaw::FailedRepsonse => e
        puts "Authentication failed: #{e.msg}"
      end

      self.new(key, secret, flickr.access_token, flickr.access_secret)
    end

    def initialize(key, secret, access_token, access_secret)
      FlickRaw.api_key = key
      FlickRaw.shared_secret = secret
      flickr.access_token = access_token
      flickr.access_secret = access_secret

      if File.exists?(DICT_FILE)
        begin
          @dict = Marshal.load File.read(DICT_FILE)
        rescue
          FileUtils.touch(DICT_FILE)
          @dict = {}
        end
      else
        FileUtils.touch(DICT_FILE)
        @dict = {}
      end
    end

    [:access_token, :access_secret].each do |meth|
      define_method meth do
        flickr.send(meth)
      end
    end

    def upload(file)
      original_file = File.new(file, 'r')
      outfile = Tempfile.new(SecureRandom.hex)
      encoded_file = PNG.encode(original_file, outfile)

      id = flickr.upload_photo encoded_file, title: File.basename(original_file.path)

      outfile.close!
      outfile.unlink

      @dict[File.realpath(original_file.path)] = id
      update_dict!
    end

    def fetch(name, outfile)
      path = File.realpath(name)
      id = @dict[path]
      sizes = flickr.photos.getSizes(photo_id: id)
      image = sizes.select { |s| s['label'].downcase == 'original' }.first
      url = image['source']

      file = Tempfile.new(SecureRandom.hex)
      file.write open(url).read
      file.flush

      PNG.decode(file, outfile)
      
      file.close!
      file.unlink
    end

    private

    def update_dict!
      File.write DICT_FILE, Marshal.dump(@dict)
    end
  end
end
