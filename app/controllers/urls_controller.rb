class UrlsController < ApplicationController
  include UrlsHelper
  $domain_name = 'https://www.'

  def index

  	@url = Url.new

  end

  def create
    long_url = params[:url][:long_url]
    @url = Url.find_by_long_url(params[:url][:long_url])
    if @url.present? && @url.domain_name == params[:url][:domain_name] #!= nil
      puts "url.present"
      respond_to do |format|
        format.html {flash[:message] = "long url with same value already present and shorturl is: " + $domain_name +@url.short_domain + '/' + @url.short_url 
        redirect_to urls_path  } 
        format.json  { render json: {"shorturl" => $domain_name + @url.short_url} }
      end

    elsif @url.present? && @url.domain_name != params[:url][:domain_name]    
      respond_to do |format|
        format.html {flash[:message] = "short Url is present but domain name not matched please enter correct domain name" 
        redirect_to urls_path  } 
        format.json  { render json: {"shorturl"=> "short Url is present but domain name not matched please enter correct domain name"} }
      end
    else
      @url = Url.new(url_params)
      @url.short_url = Url.url_shortner(@url.long_url)
      @url.short_domain = Url.domain_shortner(@url.domain_name)

      if @url.short_url == 'error'
        respond_to do |format|
          format.html {flash[:message] = "sorry, Unable to convert"
          redirect_to urls_path  } 
          format.json  { render json: {"error"=>"sorry, Unable to convert"} }
        end

      elsif  @url.save
        respond_to do |format|
          @url.short_url = @url.short_domain + "/" + @url.short_url
          format.html {redirect_to url_path(id: @url , short_url: @url.short_url) }
          format.json  { render json: {"shorturl"=> $domain_name + @url.short_url} }
        end
      else
        respond_to do |format|
          format.html {render 'urls/index' }
          format.json  { render json: {"shorturl"=> "please input in correct format "} }
        end
      end
    end
  end


  def show

    @var = params[:short_url]

  end

  def long_url

    @url = Url.new

  end

  def get_long_url

    if(params[:short_url] == "")
      flash[:message]="Please Enter Url"
      redirect_to urls_longurl_path
    else
      @shorturl = params[:short_url]
      len = @shorturl.length
      @shorturl = @shorturl[17..len]
      @long_url = Url.caching_implementation_for_short_Url(@shorturl)
      if @long_url != nil 
        respond_to do |format|
          format.html {redirect_to urls_showlongurl_path(long_url: @long_url.long_url) }
          format.json  { render  json: {"longurl"=> @long_url.long_url} }
        end
      else
        respond_to do |format|
          format.html {redirect_to urls_error_path}
          format.json  { render  json: {"longurl"=> "No mapping availabale"} }
        end
      end
    end
  end


  def show_long_url
    @var = params[:long_url]
  end

  def error

  end

  def search

    puts params
    query = params[:urls_search].presence && params[:urls_search][:query]
    if query
      query = "*" + query + "*"
      @urls = Url.search(query)
    end

  end

  private

    def url_params
      params.require(:url).permit(:long_url , :domain_name)
    end

end
