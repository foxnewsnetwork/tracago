class Itps::Buys::Internationals::StepInteractor
  def initialize(escrow)
    @escrow = escrow
  end
  def seller_preloading_pictures_step
    _form_helper.tap do |f|
      f.attributes = {
        title: "Seller provides preloading pictures",
        instructions: 'Upload pictures of the material to be transacted. This is a gesture of good faith and shows you have the material.',
        document_name: 'Preloading Pictures',
        document_description: 'Preloading pictures should clearly depict at least 1 bale of the materials to be sold. The more pictures the better.'
      }
    end.step!
  end
  def buyer_funds_escrow_step
    _form_helper.tap do |f|
      f.attributes = {
        title: "Buyer funds escrow account",
        instructions: 'The buyer must wire money to the GTPC Escrow account to initiate the transaction.',
        step_type: 'payin_step'
      }
    end.step!
  end
  def seller_weight_ticket_step
    _form_helper.tap do |f|
      f.attributes = {
        title: "Seller provides weight tickets",
        instructions: 'The seller must provide a weight ticket from a certified scale for each container in this shipment.',
        document_name: 'Weight tickets',
        document_description: 'Weight tickets are often scanned documents from a public certified scale detailing the empty and full weights of a truck.'
      }
    end.step!
  end
  def seller_loading_pics_step
    _form_helper.tap do |f|
      f.attributes = {
        title: "Seller provides loading pictures",
        instructions: 'The seller must provide container loading pictures for each container.',
        document_name: 'Loading pictures',
        document_description: 'The seller should provide a minimum of 5 pictures per container detailing the material being loaded.',
        step_type: 'load_step'
      }
    end.step!
  end
  def seller_bill_of_lading
    _form_helper.tap do |f|
      f.attributes = {
        title: "Seller provides bill of lading",
        instructions: 'The must provide the buyer with a bill of lading document so the buyer can retrieve the material from the port.',
        document_name: 'Bill of Lading',
        document_description: 'The Bill of Lading is a legal document recognized by port authorities and steamship lines around the world as the right to claim a material.',
        step_type: 'load_step'
      }
    end.step!
  end
  def seller_invoice_step
    _form_helper.tap do |f|
      f.attributes = {
        title: "Seller provides an invoice",
        instructions: 'The seller generates a formal invoice based upon the packing list and weight tickets for each container in this shipment. This is the amount paid to the Buyer.',
        document_name: 'Invoice',
        document_description: 'The invoice should reflect reasonably accurate shipment dates, price terms, commodity weights, and prices.'
      }
    end.step!
  end
  def seller_packing_list
    _form_helper.tap do |f|
      f.attributes = {
        title: "Seller provides a packing list",
        instructions: 'The seller must generate a packing list that details the contents of each container in this shipment.',
        document_name: 'Packing List',
        document_description: 'The packing list should reflect exact what went into each container.'
      }
    end.step!
  end
  private
  def _form_helper
    Itps::Escrows::Steps::StepFormHelper.new @escrow
  end
end