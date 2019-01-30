module UrlsHelper
  def render_response_for_create_url(url,domain_name)
    respond_to do |format|
      if url.present? 
        short_domain = Domain.find_by_long_domain(domain_name).short_domain
        format.html {flash[:message] = "long url with same value already present and shorturl is: " +  short_domain + '/' + url.short_url 
        redirect_to urls_path  } 
        format.json  { render json: {"shorturl" =>  short_domain + '/' + url.short_url} }
      else
        url = Url.new(url_params)
        @url , short_domain = url.pass_parameter(url)
        if @url.short_url == 'error'
          format.html {flash[:message] = "sorry, Unable to convert"
          redirect_to urls_path  } 
          format.json  { render json: {"error"=>"sorry, Unable to convert"} }
        elsif  @url.save
       
          @url.short_url = short_domain + "/" + @url.short_url
          format.html {redirect_to url_path(id: @url , short_url: @url.short_url) }
          format.json  { render json: {"shorturl"=>  @url.short_url} }
       
        else
        
          format.html {render 'urls/index' }
          format.json  { render json: {"shorturl"=> "please input in correct format "} }
        end
      end
    end
	end

  def render_reponse_for_long_url(long_url)
    respond_to do |format|
        if long_url != nil 
          format.html {redirect_to urls_showlongurl_path(long_url: long_url.long_url) }
          format.json  { render  json: {"longurl"=> long_url.long_url} }
        
        else
          format.html {flash[:message] = "Not Found"
           redirect_to urls_longurl_path }
          format.json  { render  json: {"longurl"=> "No mapping availabale"} }
        end  
      end
  end

end
