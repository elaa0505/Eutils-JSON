require 'uri'
require 'open-uri'
require 'nori'
require 'json'

class Nori
  class XMLUtilityNode

  def prefixed_attributes
      attributes.inject({}) do |memo, (key, value)|
        memo[prefixed_attribute_name(key)] = value
        memo
      end
    end
  end
end

app = lambda do |env|
  req = Rack::Request.new(env)
  parser = Nori.new(:advanced_typecasting => true)
  req.update_param('retmode','xml')
  params = Array.new
  req.params().each do |k,v|
    params.push("#{k}=#{v}")
  end
  query_string=URI.escape(params.join("&"))
  eutils = "http://eutils.ncbi.nlm.nih.gov" + req.path()+"?"+query_string
  begin
    res = URI.parse(eutils).read
    h = parser.parse(res)
    h["status"]="ok"
    body = h.to_json
    [200, {"Content-Type" => "application/json", "Content-Length" => body.length.to_s}, [body]]
  rescue OpenURI::HTTPError => e
    body = {"status"=>"error","message" => e.message}.to_json
    [200, {"Content-Type" => "application/json", "Content-Length" => body.length.to_s}, [body]]
  rescue URI::InvalidURIError => e
    body = {"status"=>"error","message" => e.message}.to_json
    [200, {"Content-Type" => "application/json", "Content-Length" => body.length.to_s}, [body]]
  end
end
 
run app
