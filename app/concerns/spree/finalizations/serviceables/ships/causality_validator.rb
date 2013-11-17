class Spree::Finalizations::Serviceables::Ships::CausalityValidator < ActiveModel::Validator
  attr_accessor :cutoff_at, :arrive_at, :depart_at, :return_at
  def validate(model)
    _establish_dates model
    return if _causality_holds?  
    model.errors.add :arrive_at, "#{arrive_at} must happen last" if _arrived_not_last?
    model.errors.add :depart_at, "#{depart_at} before #{cutoff_at}" if _depart_before_cutoff?
    model.errors.add :return_at, "#{return_at} after #{depart_at} " if _return_after_depart?
    model.errors.add :cutoff_at, "#{cutoff_at} before #{return_at}" if _cutoff_before_return?
  end

  private

  def _causality_holds?
    !_causality_broken?
  end

  def _causality_broken?
    _cutoff_before_return? || _depart_before_cutoff? || _return_after_depart? || _arrived_not_last?
  end

  def _cutoff_before_return?
    cutoff_at < return_at
  end

  def _depart_before_cutoff?
    depart_at < cutoff_at
  end

  def _return_after_depart?
    depart_at < return_at
  end

  def _arrived_not_last?
    arrive_at < depart_at || arrive_at < return_at || arrive_at < cutoff_at
  end

  def _establish_dates(model)
    @return_at = Spree::DateTime.new( model.return_at || :never )
    @cutoff_at = Spree::DateTime.new( model.cutoff_at || :never )
    @arrive_at = Spree::DateTime.new( model.arrive_at || :never )
    @depart_at = Spree::DateTime.new( model.depart_at || :never )
  end
end