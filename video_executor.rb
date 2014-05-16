require_relative 'search_executor'
require_relative 'apql'

class VideoExecutor
  def Search(url, apql)
    if !apql.is_a?(APQL)
      raise 'APQL object required.'
    end

    search = SearchExecutor.new()

    return search.Execute(url, apql.to_s, "Video")

  end
end