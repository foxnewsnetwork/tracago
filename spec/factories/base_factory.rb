module ChineseFactory
  class Base
    class << self
      def belongs_to(thing)
        new.belongs_to(thing)
      end

      def mock
        new.create
      end
    end
    def create
      _creator.create! attributes
    end
    alias_method :mock, :create

    def attributes
      throw :NotImplemeneted
    end

    private

    def _creator
      self.class.to_s.split("::").tail.reduce(Spree) do |cc, name|
        begin
          cc.const_get name
        rescue TypeError => e
          e.messages += "Current class: #{cc}\n"
          e.messages += "Requested name: #{name}"
          raise e
        end
      end
    end
  end
end
module JewFactory
  class Base < ::ChineseFactory::Base
    private

    def _creator
      self.class.to_s.split("::").tail.reduce(Itps) do |cc, name|
        begin
          cc.const_get name
        rescue TypeError => e
          e.messages += "Current class: #{cc}\n"
          e.messages += "Requested name: #{name}"
          raise e
        end
      end
    end
  end
end