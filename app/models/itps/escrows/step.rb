class Itps::Escrows::Step < ActiveRecord::Base
  belongs_to :escrow,
    class_name: 'Itps::Escrow'
  has_many :documents,
    class_name: 'Itps::Escrows::Documents'
end