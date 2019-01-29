class Url < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  after_create :start_background_processing
  validates :long_url, url: true , uniqueness: true,presence: true 
  validates :short_url , presence: true
  validates :domain_name , presence: true , length: { minimum: 4 }

  settings do
    mappings dynamic: false do
    indexes :long_url, type: :text, analyzer: :english
    indexes :short_url, type: :text, analyzer: :english
    indexes :domain_name, type: :text, analyzer: :english
    end
  end

  def start_background_processing
    HardWorker.perform_async
  end

  def as_indexed_json(options={})
    as_json(only: [:long_url, :short_url, :domain_name])
  end


  def self.url_shortner(long_url)

    short_url_1 = Digest::MD5.hexdigest long_url

    short_url_2 = Digest::MD5.hexdigest short_url_1

    short_url = short_url_2[1..8]
    itr = 2 
    while itr+7 <= short_url_2.length && Url.where(short_url:  short_url).first != nil do
      short_url = short_url_2[itr..itr + 7]
    	itr += 1
    end
    if(Url.where(short_url:  short_url).first != nil)
      return "error"
    end	
    return short_url
  end

  def self.domain_shortner(domain_name)
    encode_domain = Digest::MD5.hexdigest domain_name
    short_domain = encode_domain[1..4]
    itr = 2 
    while itr+3 <= encode_domain.length && Url.find_by_short_domain(short_domain) != nil && Url.find_by_short_domain(short_domain).domain_name != domain_name 
			short_domain = encode_domain[itr..itr+3]
			itr += 1
			puts itr
		end
		return short_domain
  end
  def self.caching_implementation_for_short_Url(short_url)
    Rails.cache.fetch("#{short_url}",expires_in: 15.minutes) do
      Url.find_by_short_url(short_url)
    end
  end	

end
