class Spree::Function
  class << self
    def linear_range(r)
      lambda { |n| r.include?(n) ? n : 0 }
    end
  end
end