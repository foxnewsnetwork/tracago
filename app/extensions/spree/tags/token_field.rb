class Spree::Tags::TokenField < ActionView::Helpers::Tags::TextField

  def render
    @options[:token_field_data_hook] = true
    @options["data-tokens"] = _tokens.map(&:to_s).to_json
    @options["showAutocompleteOnFocus"] = true
    super
  end

  private

  def _tokens
    @_tokens ||= @options.delete(:tokens) || ["placeholder1", "placeholder2"]
  end

  def field_type
    "text"
  end

end