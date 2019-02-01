class UrlsController < ApplicationController
  include UrlsHelper
=begin
 **Author:** saurabh kaushal <br/>
 **Common Name:** index page of our system <br />
 **Request Type:** GET <br />
 **Route :** '/welcome/index' <br />
 **Authentication Required:** None <br />
=end
  def index

  	@url = Url.new

  end

=begin
 **Author:** saurabh kaushal <br/>
 **Common Name:** post method for shotening url <br />
 **Request Type:** post <br />
 **Route :** '/urls' <br />
 **Authentication Required:** None <br />
 ** Request format
 {
   long_url: "https://www.proptiger.com/" (mandatory)
   domain_name: "proptiger"               (mandatory)
 }
 **Responset Format**
 Success(status : 200)
 {
   short_url: "pr.tg/c56760c7"
 }
=end

  def create
    long_url = params[:url][:long_url]
    domain_name = params[:url][:domain_name]
    url = Url.find_by_long_url(params[:url][:long_url])
    render_response_for_create_url(url,domain_name,long_url)
  end

=begin
 **Author:** saurabh kaushal <br/>
 **Common Name:** view page for short url on front-end <br />
 **Request Type:** GET <br />
 **Route :** '/urls/show' <br />
 **Authentication Required:** None <br />
=end
  def show

    @short_url = params[:short_url]

  end
=begin
 **Author:** saurabh kaushal <br/>
 **Common Name:** conversion of short_url to long_url front end<br />
 **Request Type:** GET <br />
 **Route :** '/urls/long_url' <br />
 **Authentication Required:** None <br />
=end
  def long_url

    @url = Url.new

  end

=begin
 **Author:** saurabh kaushal <br/>
 **Common Name:** conversion of short_url to long_url <br />
 **Request Type:** POST <br />
 **Route :** '/urls/getlongurl' <br />
 **Authentication Required:** None <br />
 ** Request format
 {
   short_url: "pr.tg/c56760c7" (mandatory)
 }
 **Responset Format**
 Success(status : 200)
 {
    long_url: "https://www.proptiger.com/"
 }
=end


  def get_long_url

    if(params[:short_url] == "")
      flash[:message]="Please Enter Url"
      redirect_to urls_longurl_path
    else
      long_url = Url.long_url(params)
      render_reponse_for_long_url(long_url)
      
    end
  end

=begin
 **Author:** saurabh kaushal <br/>
 **Common Name:** showing long_url on front end <br />
 **Request Type:** GET <br />
 **Route :** '/urls/showlongurl' <br />
 **Authentication Required:** None <br />
=end
  def show_long_url
    @long_url = params[:long_url]
  end

=begin
 **Author:** saurabh kaushal <br/>
 **Common Name:** elastic search on query <br />
 **Request Type:** GET <br />
 **Route :** '/urls/search' <br />
 **Authentication Required:** None <br />
=end
  def search
    query = params[:urls_search].presence && params[:urls_search][:query]
    if query
      @urls = Url.custom_search(params[:urls_search][:query],params[:urls_search][:field])
    end
  end

  private

    def url_params
      params.require(:url).permit(:long_url , :domain_name)
    end

end
