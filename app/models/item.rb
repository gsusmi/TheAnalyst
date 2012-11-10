require 'cgi'

class Item
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial

  # The name as on the Frisco list.
  property :name, String

  # If true, we will not try to look up metadata.
  property :metadata_known, Boolean

  # A detailed description
  property :description, Text

  # Type of beer, flemish red, wheat, etc.
  property :item_type, String

  # URL to more detail on BeerAdvocate, or Google if BA draws a blank.
  property :external_link, String

  # Alcohol by volume expressed as a percentage (i.e. 7.5 for 7.5% ABV)
  property :abv, Decimal, scale: 2

  # Rating from BeerAdvocate
  property :rating_score, Integer

  property :rating_desc, String

  def rating_description
    return self.rating_desc if self.rating_desc
    return nil unless self.rating_score
    "BA: #{self.rating_display_score}"
  end

  def external_link_or_google
    return self.external_link if self.external_link
    "http://www.google.com/search?q=" + CGI.escape(self.name)
  end

  def rating_display_score
    return "N/A" if self.rating_score <= 0
    self.rating_score
  end

  def abv_text
    return nil unless self.abv
    sprintf("%.f%% ABV", self.abv)
  end

  def has_abv?
    self.abv
  end

  def has_rating?
    (self.rating_score && self.rating_score > 0) || self.rating_desc
  end

  def has_type?
    self.item_type
  end

  def to_s
    "Beer[#{self.name}]"
  end
end
