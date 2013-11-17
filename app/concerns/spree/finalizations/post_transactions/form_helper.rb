class Spree::Finalizations::PostTransactions::FormHelper
  include ActiveModel::Validations
  class << self
    def model_name
      ActiveModel::Name.new self, nil, "post_transactions"
    end
  end
  def initialize(attributes={})
    @attributes = attributes
  end

  def persisted?
    false
  end

  def to_partial_path
    Spree.r.listings_path
  end

  def to_param
    nil
  end

  def to_key
    nil
  end

  def post_transaction_params
    @attributes
  end
end