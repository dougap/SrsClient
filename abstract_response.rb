require 'httparty'
require 'data_mapper'

class AbstractResponse
  include DataMapper::Resource

  @searchresultset

  property :Action, String, :required => true
  property :DataSource, String, :required => true
  property :QueryTime, String, :required => true
  property :TotalTime, String, :required => true
  property :Response, String, :required => true
  property :TargetCommand, String, :required => true
  property :Hits, Numeric, :required => true
  property :TotalHits, Numeric, :required => true
  property :Page, Numeric, :required => false
  property :PageSize, Numeric, :required => false
  property :TotalDocuments, Numeric, :required => true
  property :TotalHits, Numeric, :required => true

  def initialize(httppartyresponse)
    if !httppartyresponse
      raise "Return type must be HTTParty Response."
    end

    @searchresultset = httppartyresponse["Envelope"]["Body"]["SearchResponse"]["SearchResult"]["SearchResultSet"]

    self.Action = @searchresultset["Action"]
    self.DataSource = @searchresultset["DataSource"]
    self.QueryTime = @searchresultset["QueryTime"][2..-2]
    self.TotalTime = @searchresultset["TotalTime"][2..-2]
    self.Response = @searchresultset["Response"]
    self.Hits = @searchresultset["Hits"]
    self.TotalHits = @searchresultset["TotalHits"]
    self.Page = @searchresultset["Page"]
    self.PageSize = @searchresultset["PageSize"]
    self.TotalDocuments = @searchresultset["TotalDocuments"]
    self.TotalHits = @searchresultset["TotalHits"]

  end
end