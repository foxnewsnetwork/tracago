class Itps::Escrows::Document < ActiveRecord::Base
  belongs_to :step,
    class_name: 'Itps::Escrows::Step'

end