# == Schema Information
#
# Table name: itps_doc_tags
#
#  id               :integer          not null, primary key
#  permalink        :string(255)      not null
#  title            :string(255)      not null
#  parent_id        :integer
#  documentation_id :integer
#  level            :integer          default(0), not null
#

