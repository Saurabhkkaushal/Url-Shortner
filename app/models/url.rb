class Url < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
 # before_save :create_new_url_object
  
  validates :long_url, url: true , uniqueness: true,presence: true 
  validates :short_url , presence: true
  validates :domain_name , presence: true , length: { minimum: 4 }
  after_create :start_background_processing
  # settings do
  #   mappings dynamic: false do
  #   indexes :long_url, type: :text, analyzer: :english
  #   indexes :short_url, type: :text, analyzer: :english
  #   indexes :domain_name, type: :text, analyzer: :english
  #   end
  # end

  settings index: {
  number_of_shards: 1,
  number_of_replicas: 0,
  analysis: {
    analyzer: {
      pattern: {
        type: 'pattern',
        pattern: "\\s|_|-|\\.",
        lowercase: true
      },
      trigram: {
        tokenizer: 'trigram'
      }
    },
    tokenizer: {
      trigram: {
        type: 'ngram',
        min_gram: 3,
        max_gram: 1000,
        token_chars: ['letter', 'digit']
      }
    }
  } } do
  mapping do
        indexes :short_url, type: 'text', analyzer: 'english' do
      indexes :keyword, analyzer: 'keyword'
      indexes :pattern, analyzer: 'pattern'
      indexes :trigram, analyzer: 'trigram'
    end
       indexes :long_url, type: 'text', analyzer: 'english' do
      indexes :keyword, analyzer: 'keyword'
      indexes :pattern, analyzer: 'pattern'
      indexes :trigram, analyzer: 'trigram'
  end


  end
  end


  def self.custom_search(query , field)
  puts field , query
  field = field + ".trigram"
 # query = params[:urls_search][:query]
  urls = self.__elasticsearch__.search(
  {
   query: {
    bool: {
     must: [{
      term: {
       "#{field}":"#{query}"
      }
     }]
    }
   }
  }).records
  return urls
  end

  def start_background_processing
    HardWorker.perform_async
  end

  def as_indexed_json(options={})
    as_json(only: [:long_url, :short_url, :domain_name])
  end

  def pass_parameter(url)
    puts url.domain_name
    url.short_url = url_shortner(url.long_url)
    url.short_domain = domain_shortner(url.domain_name)
    return url
  end
  def self.caching_implementation_for_short_Url(short_url)
      Rails.cache.fetch("#{short_url}",expires_in: 15.minutes) do
      Url.find_by_short_url(short_url)
    end
   end 
   def self.long_url(params)
      shorturl = params[:short_url]
      start = 6
      length = shorturl.length
      shorturl = shorturl[start..length]                                                        #parsing_short_url 
      long_url = Url.caching_implementation_for_short_Url(shorturl)
   end
  private
    def url_shortner(long_url)
      low = 1
      high = 7
      short_url_1 = Digest::MD5.hexdigest long_url

      short_url_2 = Digest::MD5.hexdigest short_url_1

      short_url = short_url_2[low..low+high]
      itr = 2 

      while itr+high <= short_url_2.length && Url.where(short_url:  short_url).first != nil do
        short_url = short_url_2[itr..itr + high]
        itr += 1
      end
      if Url.where(short_url:  short_url).first.present?
        return "error"
      end 
      return short_url
    end
 
    def domain_shortner(domain_name)
      binding.pry
      short_domain = Domain.find_by_long_domain(domain_name).short_domain
      # encode_domain = Digest::MD5.hexdigest domain_name
      # short_domain = encode_domain[1..4]
      # itr = 2 
      # while itr+3 <= encode_domain.length && Url.find_by_short_domain(short_domain) != nil && Url.find_by_short_domain(short_domain).domain_name != domain_name 
      #   short_domain = encode_domain[itr..itr+3]
      #   itr += 1
      #   puts itr
      # end
        return short_domain
      end

end
