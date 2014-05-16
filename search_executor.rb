require 'httparty'

class SearchExecutor

  def Execute(url, query, environment)
     case environment
        when "Elvis"
          formatter = "elvis-content-formatter"
          provider = "elvis-service-provider"
        when "Video"
          formatter = "video-appl-content-formatter"
          provider = "video-service-provider"
        when "Photo"
          formatter = "photo-appl-content-formatter"
          provider = "photo-service-provider"
        else
          raise "Unknown environment #{environment}"
     end

    soap = SoapExecutor.new()
    return soap.Execute(url,
                         "http://schemas.ap.org/services/ISearchService/Search",
                         "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\"><s:Body><Search xmlns=\"http://schemas.ap.org/services\"><request xmlns:a=\"http://schemas.ap.org\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\"><a:ActivityId>00000000-0000-0000-0000-000000000000</a:ActivityId><a:FormattingProvider>#{formatter}</a:FormattingProvider><a:GrammarProvider>apql2-grammar-provider</a:GrammarProvider><a:QueryCredentials><a:Identity i:nil=\"true\"/><a:SystemIdentity i:nil=\"true\"/></a:QueryCredentials><a:ServiceProvider xmlns:b=\"http://schemas.microsoft.com/2003/10/Serialization/Arrays\"><b:string>#{provider}</b:string></a:ServiceProvider><a:SearchQuery><a:Query>#{query}</a:Query></a:SearchQuery></request></Search></s:Body></s:Envelope>"
    )

  end

end

class SoapExecutor
  include HTTParty
  format :xml

  def Execute(url, soapaction, envelope)

    response = HTTParty.post(url,
                             :headers => { "Content-Type" => "text/xml; charset=utf-8",
                                           "SOAPAction" => soapaction
                             },
                             :body => envelope
                            )

    puts response

    return response
  end
end


