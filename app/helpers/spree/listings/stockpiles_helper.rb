module Spree::Listings::StockpilesHelper

  def material_options_for_select
    _material_options.present_unshift _material_options_from_params
  end

  def packaging_options_for_select
    _something_options_for_select!("Packaging")
  end

  def process_state_options_for_select
    _something_options_for_select!("Process State")
  end

  private

  def _something_options_for_select!(something)
    Spree::OptionType.find_by_presentation!(something).option_values.map(&:presentation)
  end

  def _material_options
    Spree::Material.all_as_options_array
  end

  def _material_options_from_params
    material = Spree::Material.normalize! params[:material]
    material.try(:to_options_array)
  end

end