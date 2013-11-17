class Spree::Finalizations::Serviceables::Trucks::CausalityValidator < ActiveModel::Validator
  
  def validate(model)
    return if _causality_holds? model
    model.errors.add :arrive_at, :before_pickup
  end

  private

  def _causality_holds?(model)
    pickup = Spree::DateTime.new model.pickup_at
    arrive = Spree::DateTime.new model.arrive_at
    arrive > pickup
  end

end