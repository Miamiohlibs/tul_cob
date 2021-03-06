class BentoSearch::BlacklightEngine
  include BentoSearch::SearchEngine


  def search_implementation(args)
    query = args.fetch(:query, "")

    results = BentoSearch::Results.new

    search_results({q: query}).each do |item|
      results << conform_to_bento_result(item)
    end

    results
  end


  def conform_to_bento_result(item)
    BentoSearch::ResultItem.new({
      title: item.fetch("title_display", []).first,
      authors: item.fetch("creator_display", []).map { |author| BentoSearch::Author.new({display: author})},
      link: Rails.application.routes.url_helpers.solr_document_url(item["id"], :only_path => true)
      })
  end


  def search_results(args)
    SearchHelperWrapper.search_results(args).first["response"]["docs"]
  end

end

class SearchHelperWrapper
  include Blacklight::SearchHelper

  def blacklight_config
    CatalogController.blacklight_config
  end

  def self.search_results(args)
     self.new.search_results(args)
  end
end
