module Harbor
  class FileStore
    class File

      attr_accessor :store, :path

      def initialize(store, path)
        @store = store
        @path = path

        @copy_on_write = []
        if store.options[:copy_on_write]
          store.options[:copy_on_write].each do |name|
            @copy_on_write << Harbor::FileStore[name].get(@path)
          end
        end

        @copy_on_read = []
        if store.options[:copy_on_read]
          store.options[:copy_on_read].each do |name|
            @copy_on_read << Harbor::FileStore[name].get(@path)
          end
        end
      end

      def write(data)
        open("wb")

        @copy_on_write.each { |file| file.write(data) }

        if data
          @stream.write(data)
        else
          @stream.close
          @stream = nil
        end
      end

      def read(bytes = nil)
        open("r")

        data = @stream.read(bytes)

        @copy_on_read.each { |file| file.write(data) }

        unless bytes && data
          @stream.close
          @stream = nil
        end

        data
      end

      def size
        store.size(path)
      end

      def open(mode = "r")
        @stream ||= store.open(path, mode)
      end

    end
  end
end