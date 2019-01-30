class UrlsController < ApplicationController
  include UrlsHelper
  $domain_name = ''
#page for url shortner 
  def index

  	@url = Url.new

  end

  def create
    # long_url = NormalizeUrl.process(params[:url][:long_url])
    # domain_name = (Domainatrix.parse(long_url)).domain
    long_url = params[:url][:long_url]
    domain_name = params[:url][:domain_name]
    print domain_name
    #long_url = params[:url][:long_url]
    url = Url.find_by_long_url(params[:url][:long_url])
    render_response_for_create_url(url,params,domain_name)
  end

# show Long Url to User
  def show

    @short_url = params[:short_url]

  end
# view page for converting short url to long url
  def long_url

    @url = Url.new

  end

#Getting long url form a given short url
  def get_long_url

    if(params[:short_url] == "")
      flash[:message]="Please Enter Url"
      redirect_to urls_longurl_path
    else
      long_url = Url.long_url(params)
      render_reponse_for_long_url(long_url)
      
    end
  end


  def show_long_url
    @long_url = params[:long_url]
  end

# Elastic search
  def search
    query = params[:urls_search].presence && params[:urls_search][:query]
    if query
      #query = "*" + query + "*"
      #puts params[:urls_search]
      @urls = Url.custom_search(params[:urls_search][:query],params[:urls_search][:field])
      #binding.pry
    end
  end

  private

    def url_params
      params.require(:url).permit(:long_url , :domain_name)
    end

end
