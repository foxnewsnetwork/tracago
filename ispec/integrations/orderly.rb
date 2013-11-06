class ChineseIntegration::Ordered
  class Slave
    def step(key, &block)
      _steps_ordered_hash[key] = &block
    end

    def helper(key, &block)
      class_eval { define_method(key, &block) }
    end

    def run!
      _steps_ordered_hash.each do |key, &block|
        instance_eval(&block)
      end
    end

    private

    def _steps_ordered_hash
      @steps ||= ActiveSupport::OrderedHash.new
    end
  end
  include Singleton

  def namespace(key, &block)
    _namespaces[key] = &block
  end

  def run!(*keys)
    keys = _namespaces.keys if keys.blank?
    keys.map { |key| _namespaces[key] }.each do |&block|
      Slave.new.tap { |s| s.instance_eval(&block) }.run!
    end
  end

  private

  def _namespaces
    @namespaces ||= {}
  end
end