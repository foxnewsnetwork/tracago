ChineseIntegration::Ordered.instance.namespace :main_usage do

  step :start_at_root do
    _seller.visits('/')
    _buyer.visits('/')
  end

  step :seller_visits_new_listing_page do
    _seller.clicks('//*[@id="new-listing"]/a')
  end

  step :seller_makes_a_listing do
    _seller.selects('PET').in '//*[@id="listing_form_helper_material"]'
    _seller.writes('Milk Jugs').in '//*[@id="listing_form_helper_origin_products"]'
    _seller.writes(4800).in '//*[@id="listing_form_helper_pounds_on_hand"]'
    _seller.selects('Supersacks').in '//*[@id="listing_form_helper_packaging"]'
    _seller.writes('Regrind').in '//*[@id="listing_form_helper_process_state"]'
    _seller.picks(Time.now).in '//*[@id="listing_form_helper_available_on"]'
    _seller.picks(1.month.from_now).in '//*[@id="listing_form_helper_expires_on"]'
    _seller.writes("You're a faggot").in '//*[@id="listing_form_helper_notes"]'
    _seller.clicks '//*[@id="content"]/div/div[2]/div/form/fieldset/div/input'
  end

  step :buyer_visits_listing_page do

  end

  step :buyer_makes_an_offer do

  end

  step :seller_makes_a_suggestion do

  end

  step :buyer_modifies_offer_accordingly do

  end

  step :seller_accepts_new_offer do

  end

  helper :_seller do
    @seller ||= ChineseIntegration::Player.new
  end

  helper :_buyer do
    @buyer ||= ChineseIntegration::Player.new
  end

end