json.array!(@snippets) do |snippet|
  json.extract! snippet, :id, :snippet, :lang_id, :description
  json.url snippet_url(snippet, format: :json)
end
