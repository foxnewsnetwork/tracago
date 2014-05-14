class Itps::Contracts::Agreements::Interactor < Spree::FormHelperBase
  class Result
    def initialize(flag)
      @flag = flag
    end

    def success?
      true == @flag
    end

    def failed?
      !success?
    end
  end
  Fields = [
    :agree,
    :contract_text
  ]
  attr_hash_accessor *Fields
  attr_accessor :attributes
  attr_reader :contract
  validates :agree,
    :contract_text,
    presence: true

  def initialize(contract)
    super
    @contract = contract
  end

  def escrow
    @escrow ||= contract.reload.escrow
  end

  def agree!
    Result.new valid? && _updated_contract!
  end

  private
  def _updated_contract!
    contract.update(_contract_params) && contract.generate_checksum!
  end
  def _contract_params
    {
      content_summary: contract_text,
      escrow: _escrow
    }
  end

  def _escrow
    @escrow ||= _escrow_interactor.escrow!
  end

  def _escrow_interactor
    @escrow_interactor ||= Itps::Buys::Internationals::EscrowInteractor.new.tap do |i|
      i.contract = contract
    end
  end

end