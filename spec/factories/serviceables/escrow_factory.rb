class ChineseFactory::Serviceables::Escrow < ChineseFactory::Base

  def attributes
    {
      payment_amount: rand(230842)
    }
  end
end