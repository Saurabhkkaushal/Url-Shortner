module UrlsHelper
  def render_response_for_create_url(url,params,domain_name)
    #binding.pry
    respond_to do |format|
      if url.present? #&& url.domain_name == params[:url][:domain_name]
        url.short_domain = Domain.find_by_long_domain(domain_name).short_domain
        format.html {flash[:message] = "long url with same value already present and shorturl is: " +  url.short_domain + '/' + url.short_url 
        redirect_to urls_path  } 
        format.json  { render json: {"shorturl" =>  url.short_domain + '/' + url.short_url} }
      

      # elsif url.present? && url.domain_name != params[:url][:domain_name]    
      #   format.html {flash[:message] = "short Url is present but domain name not matched please enter correct domain name" 
      #   redirect_to urls_path  } 
      #   format.json  { render json: {"shorturl"=> "short Url is present but domain name not matched please enter correct domain name"} }
       else
        url = Url.new(url_params)
        @url = url.pass_parameter(url)
        if @url.short_url == 'error'
          format.html {flash[:message] = "sorry, Unable to convert"
          redirect_to urls_path  } 
          format.json  { render json: {"error"=>"sorry, Unable to convert"} }
        elsif  @url.save
       
          @url.short_url = @url.short_domain + "/" + @url.short_url
          format.html {redirect_to url_path(id: @url , short_url: @url.short_url) }
          format.json  { render json: {"shorturl"=>  @url.short_domain + '/' + @url.short_url} }
       
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
       # respond_to do |format|
          format.html {flash[:message] = "Not Found"
           redirect_to urls_longurl_path }
          format.json  { render  json: {"longurl"=> "No mapping availabale"} }
      #  end
        end  
      end
  end

end
