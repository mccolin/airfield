# AIRFIELD
# ContentSerializer - Handles load and unload of JSON content serialized into the
#  database for Page and Post content.

class ContentMashSerializer

  # Load a content hash from a stored JSON string
  def load(raw)
    raw = "{}" if raw.nil?        # nil values are converted to empty content sets
    begin
      obj = JSON.parse(raw)       # Generally, we attempt to parse standard JSON
    rescue JSON::ParserError => json_e
      obj = {body:raw}            # On failure, we assume naked String and promote it
    end
    Hashie::Mash.new(obj)
  end

  # Store a content hash as a well-formed JSON string
  def dump(obj)
    if obj.nil?                   # nil values stored as such
      return nil
    elsif obj.is_a?(Hash)         # Hashie::Mash, Hash are simply pushed to JSON
      return obj.to_json
    elsif obj.is_a?(String)       # Strings are converted to single-key JSON hash
      return {body:obj}.to_json
    else
      raise ActiveRecord::SerializationTypeMismatch,
        "Content expected to be of Hash or String type, but was a #{obj.class} -- #{obj.inspect}"
    end
  end

end
