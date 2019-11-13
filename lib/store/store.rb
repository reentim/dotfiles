require 'fileutils'
require 'json'
require 'securerandom'

class Store
  def initialize(namespace = nil, file: nil)
    @store = file || "#{
      [File.join(Dir.home, '.tmp/store'), namespace]
        .flatten
        .reject(&:nil?)
        .join('_')
    }.json"
  end

  def read(key)
    unless File.exists?(@store)
      value = yield if block_given?
      return write(key, value)
    end

    JSON.parse(File.read(@store)).fetch(key.to_s) do
      value = yield if block_given?
      write(key, value)
    end
  end

  def write(key, value)
    store = File.exists?(@store) && File.read(@store)
    data = JSON.parse(store || "{}").tap { |store|
      store.merge!({ key => value }) if value
    }.to_json

    atomic_write(data) unless data == store
    value
  end

  private

  def atomic_write(string)
    tmp_file = @store + ".tmp_#{SecureRandom.uuid}"
    File.open(tmp_file, "w") { |file| file << string }
    FileUtils.mv(tmp_file, @store)
    true
  end
end
