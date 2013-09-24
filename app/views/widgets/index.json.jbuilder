json.array!(@widgets) do |widget|
  json.extract! widget, :name
  json.url widget_url(widget, format: :json)
end
