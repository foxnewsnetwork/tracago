class Array
  def random_chunk
    start = rand length
    finish = start + rand(length - start)
    slice start, finish
  end

  def random
    self[rand(length)]
  end
end