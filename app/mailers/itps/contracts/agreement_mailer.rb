class Itps::Contracts::AgreementMailer < Itps::BaseMailer
  attr_hash_accessor :contract
  layout 'itps/layouts/email'
  def inform_seller_email(contract)
    self.mailer_method = 'inform_seller_email'
    self.contract = contract
    self.subject = "Contract##{contract.bullshit_id} From '#{contract.account.company_name}' Requires Your Review"
    self.to = contract.seller_email
    mail _mail_params
  end
end