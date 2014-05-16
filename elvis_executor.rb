require_relative 'search_executor'
require_relative 'apql'
require_relative 'abstract_response'

class ElvisExecutor
  def Search(url, apql)
    if !apql.is_a?(APQL)
      raise 'APQL object required.'
    end

    search = SearchExecutor.new()
    result = search.Execute(url, apql.to_s, "Elvis")
    return AbstractResponse.new(result)

  end
end

elvis = ElvisExecutor.new()

result = elvis.Search("http://rdielvf1.rnd.local/search/searchservice.svc",
                      APQL.new(0, 25, "obama", [ NameMultiValuePair.new("itemid", [ "3431fc395d3e4a77a3f12aa167ffcab2", "0c4012ef43ba417baf7415f1cc0c949d" ])], ["itemid"], [NameValuePair.new("arrivaldatetime", "desc")]))

puts result