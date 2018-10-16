require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    
    doc_arr = []
    
    doc.css("div.student-card").each do |student|
      
      student_hash = { 
                       :name => student.css('h4.student-name').text, 
                       :location => student.css('.student-location').text, 
                       :profile_url => student.css('a').first['href']
      }
      
      doc_arr << student_hash
      end
    doc_arr
  end

  
  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    
    profile_hash = {}
    
    doc.css('div.social-icon-container a').each do |links|
    
      link = links.attr('href')
    
        if link.include?('twitter')
          profile_hash[:twitter] = link
        elsif link.include?('linkedin')
          profile_hash[:linkedin] = link
        elsif link.include?('github')
          profile_hash[:github] = link
        else
          profile_hash[:blog] = link
        end
    end
    profile_hash[:profile_quote] = doc.css('div.profile-quote').text
    profile_hash[:bio] = doc.css('div.description-holder p').text
    profile_hash
  end
  
end




