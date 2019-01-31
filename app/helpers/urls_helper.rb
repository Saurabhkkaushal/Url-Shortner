module UrlsHelper
  #rendering reponse for create method
  def render_response_for_create_url(url,domain_name)
    domain = Domain.check_presence_of_domain(domain_name)
    if domain.present?
      respond_to do |format|
        if url.present? 
          format.html {
            flash[:message] = "long url with same value already present and shorturl is: " +  domain.short_domain + '/' + url.short_url 
            redirect_to urls_path
          } 
          format.json {
            render json: {
              "message" => "successful",
              "status" => "200,ok" ,
              "short_url" =>  domain.short_domain + '/' + url.short_url
              } 
            }
        else
          url = Url.new(url_params)
          @url , short_domain = url.pass_parameter(url)
          if @url.short_url == 'error'
            format.html {
              flash[:message] = "sorry, Unable to convert"
              redirect_to urls_path 
            } 
            format.json {
              render json: {
                "message" => "error",
                "status" => "500 , Internal server error"
              } 
            }
          elsif  @url.save
         
            @url.short_url = domain.short_domain + "/" + @url.short_url
            format.html {
              redirect_to url_path(id: @url , short_url: @url.short_url)
            }
            format.json { 
              render json: {
                "message" => "successful",
                "status" => "200,ok",
                "shorturl"=>  @url.short_url
              } 
            }
         
          else
          
            format.html {
              render 'urls/index'
            }
            format.json  {
              render json: {
                "message" => "please input in correct format ",
                "status" => "400,Bad Request"
                }
            }
          end
        end
      end
    else
      respond_to do |format|
        format.html {
          flash[:message] = "Currently,given domain is not available with us. first have a domain" 
          redirect_to urls_path 
        } 
        format.json {
          render json: {
            "message" => "Given Domain is not available",
            "status" => "400,Bad Request"
          } 
        }
      end
    end 
	end

  #rendering response for get_long_url method 

  def render_reponse_for_long_url(long_url)

    respond_to do |format|
        if long_url != nil 
          format.html {
            redirect_to urls_showlongurl_path(long_url: long_url.long_url)
          }
          format.json { 
            render  json: {
              "message" => "successful",
              "status" => "200,ok",
              "long_url"=> long_url.long_url
            } 
          }
        
        else
          format.html {
            flash[:message] = "Not Found"
            redirect_to urls_longurl_path
          }
          format.json {
            render  json: {
            "message" => "Not found",
            "status" => "404"
            } 
          }
        end  
      end
  end
  

end
