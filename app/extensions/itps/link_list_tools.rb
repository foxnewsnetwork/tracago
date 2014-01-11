module Itps::LinkListTools
  class CircularLinkedList < StandardError; end
  class Sorter
    class << self
      def in_order(elements)
        new(elements).ordered
      end
    end
    attr_accessor :ordered
    # O(N * N / 2); pretty shitty, can be improved with just using a hashing while-loop, but then
    # we would lose the ability to detect circular dependencies without storing lots of elements
    # to memory... but then again, considering my usage of ruby here, I'm ALREADY commiting lots of
    # unnecessary objects to memory just to do a simple sort. Optimize this in the future
    def initialize(elements)
      @elements = elements
      if @elements.empty?
        @ordered = []
      else
        raise CircularLinkedList, @elements if _head.blank?
        @ordered = _head + self.class.in_order(_tail)
      end
    end

    private
    def _head
      @head ||= _select { |element| _refers_to_no_other_element? element }
    end

    def _tail
      @tail ||= _reject { |element| _head.include? element }
    end

    def _refers_to_no_other_element?(element)
      element.reference_id.blank? || _reference_hash[element.reference_id].blank?
    end

    def _reference_hash
      @reference_hash ||= Hash[_reference_hash_array]
    end

    def _reference_hash_array
      @reference_array ||= @elements.map do |element|
        [element.id, element]
      end
    end

    def _select(&filter)
      @elements.select(&filter)
    end

    def _reject(&filter)
      @elements.reject(&filter)
    end
  end
  class << self
    # An elements is an array where each element respond to an "next" or "previous" method
    # that leads to another object in the given array
    def sort_in_order(elements)
      Sorter.in_order(elements)
    end
  end
end