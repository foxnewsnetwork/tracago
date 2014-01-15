module Itps::Shared::HeaderHelper
  def append_query_to_path(query={})
    _query_merge _original_path, _querystring_merge(query)
  end

  private
  def _query_merge(path, querystring)
    "#{path}?#{querystring}"
  end

  def _original_path
    request.path_info
  end

  def _querystring_merge(query)
    _to_querystring _original_query_hash.merge query.stringify_keys
  end

  def _to_querystring(hash)
    hash.to_a.inject("") do |string, array|
      "#{string}#{array.first.to_s}=#{array.last.to_s}&"
    end
  end

  def _original_query_string
    URI(request.original_fullpath).query || ""
  end

  def _original_query_hash
    hash = _original_query_string.split("&").reject do |array|
      array.first.blank? || array.last.blank?
    end.inject({}) do |hash, query|
      key = query.split("=").first.to_s
      value = query.split("=").last.to_s
      hash[key] = value
      hash
    end
  end
end