# == Schema Information
#
# Table name: itps_drafts
#
#  id             :integer          not null, primary key
#  account_id     :integer
#  permalink      :string(255)      not null
#  content        :text
#  created_at     :datetime
#  updated_at     :datetime
#  class_name     :string(255)
#  last_step_name :string(255)
#

class Itps::Drafts::International < Itps::Draft
  self.table_name = 'itps_drafts'
  IncotermsHash = YAML.load_file(Rails.root.join 'config', 'incoterms.yml').freeze
  Incoterms = IncotermsHash['Incoterms'].freeze
  IncotermDuties = IncotermsHash['Incoterm Duties']
end
