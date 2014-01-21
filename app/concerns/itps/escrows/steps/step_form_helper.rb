class Itps::Escrows::Steps::StepFormHelper < Spree::FormHelperBase
  Fields = [ 
    :title,
    :instructions,
    :document_name,
    :document_description,
    :payment_step
  ]
  attr_accessor :attributes
  attr_hash_accessor *Fields
  validates :title,
    presence: true
  def initialize(escrow)
    @escrow = escrow
  end

  def step!
    if valid?
      @step ||= _escrow.steps.create!(_processed_params).tap do |step|
        step.documents.create! _document_params if _has_doc?
      end
    end
  end

  private
  def _escrow
    @escrow
  end

  def _processed_params
    {
      title: title,
      instructions: instructions,
    }.merge _class_name_params
  end

  def _class_name_params
    return { class_name: 'pay_step' } if _payment_step?
    return {}
  end

  def _payment_step?
    "1" == payment_step.to_s
  end

  def _document_params
    {
      title: document_name,
      description: document_description
    }
  end

  def _has_doc?
    document_name.present?
  end
end