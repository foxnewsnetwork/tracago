require 'spec_helper'

describe Itps::Escrows::AgreementsController do
  describe '#new' do
    before do
      @escrow = JewFactory::Escrow.mock
      get 'new', escrow_id: @escrow.permalink
    end
    it 'should render correctly' do
      response.should render_template 'new'
    end
  end
end