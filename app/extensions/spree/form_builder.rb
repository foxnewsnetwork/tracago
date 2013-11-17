class Spree::FormBuilder < ActionView::Helpers::FormBuilder

  def token_field(method, options={})
    ::Spree::Tags::TokenField.new(object_name, method, self, options).render
  end
end