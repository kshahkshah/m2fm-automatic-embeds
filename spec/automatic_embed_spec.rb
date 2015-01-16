require 'spec_helper'
require 'byebug'

describe Mail2FrontMatter::AutomaticEmbed, "configuration" do
  let(:config) { 
    test_config = File.join(File.dirname(__FILE__), '..', 'fixtures', 'config.yml')
    config = YAML.load_file(test_config).deep_symbolize_keys!
  }

  it "should store filters internally as symbols" do
    Mail2FrontMatter::AutomaticEmbed.register(config[:keys_demo])
    keys = Mail2FrontMatter::AutomaticEmbed.instance_variable_get :@filters

    keys.all?{|k|k.is_a?(Symbol)}.should eq(true)
  end

  it "should allow a white list" do
    Mail2FrontMatter::AutomaticEmbed.register(config[:white_list_demo])
    keys = Mail2FrontMatter::AutomaticEmbed.instance_variable_get :@filters

    white_list = [:youtube, :soundcloud, :vimeo]
    keys.sort.should eq(white_list.sort)
  end

  it "should allow a black list" do
    Mail2FrontMatter::AutomaticEmbed.register(config[:black_list_demo])
    keys = Mail2FrontMatter::AutomaticEmbed.instance_variable_get :@filters
    all_keys = Mail2FrontMatter::AutomaticEmbed.instance_variable_get :@all_filters

    black_list = [:vimeo]
    keys.sort.should eq((all_keys - black_list).sort)
  end

  it "should allow the forwarding of options to an auto_html filter" do
    Mail2FrontMatter::AutomaticEmbed.register(config[:options_demo])

    metadata = {
      subject: "Interstellar"
    }
    body = "I think B Colony made the wormhole. https://www.youtube.com/watch?v=jo5m5GXF9Ec"

    AutoHtml::Builder.any_instance.should_receive(:youtube).with({autoplay: true})

    # run it
    Mail2FrontMatter::AutomaticEmbed.run(metadata, body)
  end
end

describe Mail2FrontMatter::AutomaticEmbed, "behaviour" do

  let(:soundcloud) { 
    Mail::Message.new(File.read(File.join(File.dirname(__FILE__), '..', 'fixtures', 'soundcloud-link.eml'))) 
  }
  let(:youtube) { 
    Mail::Message.new(File.read(File.join(File.dirname(__FILE__), '..', 'fixtures', 'youtube-link.eml'))) 
  }
  let(:wrapped) { 
    Mail::Message.new(File.read(File.join(File.dirname(__FILE__), '..', 'fixtures', 'wrapped-links.eml'))) 
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

  it "should unwrap links without specific names before using filters" do
    Mail2FrontMatter::AutomaticEmbed.register
    parser = Mail2FrontMatter::Parser.new(wrapped)

    metadata, body = Mail2FrontMatter::AutomaticEmbed.run(parser.metadata, parser.body)

    body.should_not match(/href/)

  end

end