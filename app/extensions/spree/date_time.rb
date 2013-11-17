class Spree::DateTime
  class CausalityConflict < StandardError; end
  class << self
    def always
      new nil
    end

    def never
      new :never
    end

    def normalize(date_time)
      return date_time if date_time.is_a? self
      return new date_time if _timelike? date_time
      new nil
    end

    def _timelike?(thing)
      thing.is_a?( ActiveSupport::TimeWithZone) ||
        thing.is_a?( Time) ||
        thing.is_a?( DateTime)
    end

  end
  def initialize(time_with_zone)
    @never_flag = true if :never == time_with_zone
    @time_with_zone = time_with_zone
  end

  def >(date_time)
    _operation! date_time, &:>
  end

  def >=(date_time)
    _operation! date_time, &:>=
  end

  def <(date_time)
    _operation! date_time, &:<
  end

  def <=(date_time)
    _operation! date_time, &:<=
  end

  def ==(date_time)
    _operation! date_time, &:==
  end

  def always?
    @time_with_zone.blank?
  end

  def never?
    @never_flag.present?
  end

  def inspect
    to_datetime.inspect
  end

  def to_s
    to_datetime.to_s
  end

  def to_datetime
    return :always if always?
    return :never if never?
    @time_with_zone
  end

  private

  def _operation!(date_time, &operator)
    other = _n date_time
    _consider_complaining_about! date_time
    return false if never? || other.never?
    return true if always? || other.always?
    return yield(to_datetime, other.to_datetime).present?
  end

  def _consider_complaining_about!(x)
    _raise_causality_error! if _spacetime_breakdown? x
  end

  def _raise_causality_error!
    raise CausalityConflict, "Cannot logically deduce the result of comparison between always and never"
  end

  def _spacetime_breakdown?(date_time)
    (always? && date_time.never?) || (never? && date_time.always?)
  end

  def _n(date_time)
    self.class.normalize date_time
  end

end