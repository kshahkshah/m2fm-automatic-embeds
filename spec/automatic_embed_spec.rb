require 'spec_helper'
require 'byebug'

describe Mail2FrontMatter::Parser, "parsing" do

  let(:soundcloud) { 
    Mail::Message.new(File.read(File.join(File.dirname(__FILE__), '..', 'fixtures', 'soundcloud-link.eml'))) 
  }
  let(:youtube) { 
    Mail::Message.new(File.read(File.join(File.dirname(__FILE__), '..', 'fixtures', 'youtube-link.eml'))) 
  }
  let(:control) { 
    Mail::Message.new(File.read(File.join(File.dirname(__FILE__), '..', 'fixtures', 'no-links.eml'))) 
  }

  it "should identify and transform youtube link" do
    Mail2FrontMatter::AutomaticEmbed.register

    parser = Mail2FrontMatter::Parser.new(youtube)
    metadata, body = Mail2FrontMatter::PreProcessor.process(parser.metadata, parser.body)

    body.should match(/embed/)

  end

end