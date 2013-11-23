module Spree::Normalizable
  def normalize(whatever)
    return whatever if whatever.is_a? self
    return find_by_id_romanized_name_local_presentation_or_permalink(whatever.to_s).first
  end

  def normalize!(whatever)
    normalize(whatever) || find(whatever)
  end

  def find_by_id_romanized_name_local_presentation_or_permalink(name)
    ss = ['id','romanized_name','local_presentation','permalink'].map do |key| 
      "#{self.table_name}." + key + ' = ?' 
    end
    ns = ss.map { name }
    where ss.join(' or '), *ns
  end
end