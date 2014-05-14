class Itps::Contracts::Agreements::Emailer

  def initialize(contract)
    @contract = contract
  end

  def inform_other_party!
    Itps::Contracts::AgreementMailer.inform_seller_email(@contract).deliver!
  end
end