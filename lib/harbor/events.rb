module Harbor
  module Events

    def self.included(target)
      target.extend(ClassMethods)
    end
    
    def raise_event(name, *args)
      if self.class.events[name].nil?
        return false
      else
        self.class.events[name].each do |event|
          event.call(*args)
        end
        return true
      end
    end
    
    module ClassMethods
      
      def events
        @@events ||= {}
      end
      
      def events=(hash)
        @@events = hash
      end
      
      def register_event(name, &block)
        events[name] ||= []
        events[name] << block
      end
      
      def clear_events!(name=nil)
        if name
          events[name] = nil
        else
          events = {}
        end
      end
      
    end
    
  end
end