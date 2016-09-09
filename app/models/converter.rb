require 'nokogiri'

class Converter
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :file

  validates :file, presence: true
  validate :permit_mime_type?, on: :parse!

  def initialize(attributes = {})
    @file = attributes[:file]
    @sentences = []
  end

  def persisted?
    false
  end

  def mime_type(path)
    `file --brief --mime-type #{path}`.strip
  end

  def permit_mime_type?
    message = " '#{@file.original_filename}' have file type not allowed:
     '#{mime_type(@file.tempfile.path)}'. Please, choose a file type #{permited_mime_type.join(' or ')}"

    errors.add(:file, message) unless permited_mime_type.include? mime_type(@file.tempfile.path)
  end

  def permited_mime_type
    %w[text/plain text/html]
  end

  def parse!
    doc = Nokogiri::HTML(File.open(@file.tempfile.path))

    regex = /^(q:|a:)/i

    doc.css('p').each do |p|

      if regex.match p.content.downcase
        p.xpath('//@class|//@lang').remove
        @sentences << p.to_html.sub(/(?<=>)\w{1}:\s{0,}/, '').gsub(/\r|\n/, ' ')
      end

    end

  end

  def to_card
    @sentences.each_slice(2)
  end

  def buffer
    str = ''
    to_card.each { |s| str << s.join('|') + "\n" }
    str.strip
  end

  def has_sentences?
    @sentences.size > 0
  end

  def resume
    cards = {questions: 0, answers: 0}

    to_card.each do |p|
      cards[:questions] += sanitize(p[0]).split(" ").size
      cards[:answers] += sanitize(p[1]).split(" ").size
    end

    cards
  end

  def sanitize(str)
    Rails::Html::FullSanitizer.new.sanitize(str)
  end

end
