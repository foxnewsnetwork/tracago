module Spree::Optionable
  module ClassMethods
    def to_options_array(thing)
      normalize(thing).try :select_options_array
    end

    def to_options_prompt(thing)
      normalize(thing).try :local_presentation
    end

    def select_options_arrays
      @options_arrays ||= all.map(&:select_options_array).sort
    end
  end

  module InstanceMethods
    def select_options_array
      [romanized_name[0..11], permalink]
    end
  end

  def self.included(base)
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods
  end
end