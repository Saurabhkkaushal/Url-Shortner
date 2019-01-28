class UrlsController < ApplicationController
  include UrlsHelper
  def index
  
  end
  def create
  		@url = Url.new(url_params)
  		#puts @url.short_url
  		if @url.short_url == nil
  			puts 'hii'
			if Url.where(long_url: @url.long_url).first == nil 
				@url.short_url =  url_shortner(@url.long_url)

				puts @url.short_url


				@url.save
				redirect_to url_path(id: @url.id , short_url: @url.short_url)
				
			else
				puts "already exist"
			end
		else
			puts @url.short_url
			@var = Url.where(short_url: @url.short_url).first
			#binding.pry
			puts @var.long_url
			redirect_to url_path(long_url: @var.long_url)
		end	
  end
  def show
  	@var = Url.new 
  	if(params[:long_url])
  		@var.long_url = params[:long_url]
  	else
  		@var.short_url = 	params[:short_url]
	end  		
  end
 
  private
		def url_params
			if(params[:url][:long_url])
				params.require(:url).permit(:long_url , :domain_name)
			else	
				params.require(:url).permit(:short_url)
			end	
		end
end
