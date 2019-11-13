require "minitest/autorun"
require "minitest/pride"
require "securerandom"

require_relative "../store"

describe Store do
  before do
    @file_path = "/tmp/store_test_#{SecureRandom.hex}.json"
    @store = Store.new(file: @file_path)
  end

  def remove_store
    FileUtils.rm(@file_path, force: true)
  end

  def initialise_store
    File.open(@file_path, "w") { |f| f << "{}" }
  end

  def read_store
    File.read(@file_path)
  end

  describe "#read" do
    describe "when store does not exist" do
      before { remove_store }

      it "creates the store" do
        File.exists?(@file_path).must_equal false

        value = @store.read('some key')

        File.exists?(@file_path).must_equal true
        assert_nil(value)
      end

      it "with block, creates the store, returns block value" do
        File.exists?(@file_path).must_equal false
        value = @store.read('some key') { 'fallback' }

        File.exists?(@file_path).must_equal true
        value.must_equal 'fallback'
      end
    end

    describe "when store exists" do
      before { initialise_store }

      it "without found value, and no block, returns nil" do
        value = @store.read('some key')

        assert_nil(value)
      end

      it "without found value, with block, returns block value" do
        value = @store.read('some key') { 'fallback' }

        value.must_equal 'fallback'
      end

      it "finds values stored under the key, skipping the block" do
        File.open(@file_path, "w") { |f| f << '{"some key":5}' }

        value = @store.read('some key') { raise }

        value.must_equal 5
      end
    end
  end

  describe "#write" do
    describe "when the store does not exist" do
      before { remove_store }

      describe "with nil value" do
        it "initialises the store" do
          @store.write('some key', nil)

          read_store.must_equal "{}"
        end
      end

      describe "with a value" do
        describe "new key" do
          it "adds the key to the store" do
            @store.write('some key', 'some value')

            read_store.must_equal %[{"some key":"some value"}]
          end
        end
      end
    end

    describe "when the store exists" do
      before { initialise_store }

      describe "with nil value" do
        it "does not write to the store" do
          store_mtime = File.mtime(@file_path).nsec

          @store.write('some key', nil)

          File.mtime(@file_path).nsec.must_equal store_mtime
        end
      end

      describe "with a value" do
        it "writes to the store" do
          @store.write('some key', 999)

          read_store.must_equal %[{"some key":999}]
        end

        it "overwrites an existing key" do
          @store.write('some key', 123)
          @store.write('some key', 456)

          read_store.must_equal %[{"some key":456}]
        end

        it "does not write unchanged values" do
          @store.write('some key', 555)
          store_mtime = File.mtime(@file_path).nsec

          @store.write('some key', 555)

          File.mtime(@file_path).nsec.must_equal store_mtime
        end

        it "does not overwrite other keys" do
          @store.write('some key', 123)
          @store.write('other key', 123)

          read_store.must_equal %[{"some key":123,"other key":123}]
        end
      end
    end
  end
end
