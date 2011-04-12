Hash.send :define_method, :to_sym do
  new_hash = {}
  self.each{|k,v| new_hash[k.to_sym] = Hash === v ? symbolize_keys(v) : Array === v ? v.to_sym : v}
  new_hash
end

Array.send :define_method, :to_sym do
  self.collect do |item|
    item.respond_to?(:to_sym) ? item.to_sym : item
  end
end