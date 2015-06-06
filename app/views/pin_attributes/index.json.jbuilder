json.array!(@pin_attributes) do |pin_attribute|
  json.extract! pin_attribute, :id, :name
  json.url pin_attribute_url(pin_attribute, format: :json)
end
