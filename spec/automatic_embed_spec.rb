require 'spec_helper'

describe Mail2FrontMatter::AutomaticEmbeds, "configuration" do
  let(:config) { 
    test_config = File.join(File.dirname(__FILE__), '..', 'fixtures', 'config.yml')
    config = YAML.load_file(test_config).deep_symbolize_keys!
  }

  it "should store filters internally as symbols" do
    Mail2FrontMatter::AutomaticEmbeds.register(config[:keys_demo])
    keys = Mail2FrontMatter::AutomaticEmbeds.instance_variable_get :@filters

    expect(keys.all?{|k|k.is_a?(Symbol)}).to eq(true)
  end

  it "should allow a white list" do
    Mail2FrontMatter::AutomaticEmbeds.register(config[:white_list_demo])
    keys = Mail2FrontMatter::AutomaticEmbeds.instance_variable_get :@filters

    white_list = [:youtube, :soundcloud, :vimeo]
    expect(keys.sort).to eq(white_list.sort)
  end

  it "should allow a black list" do
    Mail2FrontMatter::AutomaticEmbeds.register(config[:black_list_demo])
    keys = Mail2FrontMatter::AutomaticEmbeds.instance_variable_get :@filters
    all_keys = Mail2FrontMatter::AutomaticEmbeds.instance_variable_get :@all_filters

    black_list = [:vimeo]
    expect(keys.sort).to eq((all_keys - black_list).sort)
  end

  it "should allow the forwarding of options to an auto_html filter" do
    Mail2FrontMatter::AutomaticEmbeds.register(config[:options_demo])

    metadata = {
      subject: "Interstellar"
    }
    body = "I think B Colony made the wormhole. https://www.youtube.com/watch?v=jo5m5GXF9Ec"

    expect_any_instance_of(AutoHtml::Builder).to receive(:youtube).with({autoplay: true})

    # run it
    Mail2FrontMatter::AutomaticEmbeds.run(metadata, body)
  end
end

describe Mail2FrontMatter::AutomaticEmbeds, "behaviour" do

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
    Mail2FrontMatter::AutomaticEmbeds.register

    parser = Mail2FrontMatter::Parser.new(youtube)
    metadata, body = Mail2FrontMatter::PreProcessor.process(parser.metadata, parser.body)

    expect(body).to match(/embed/)

  end

  it "should unwrap links without specific names before using filters" do
    Mail2FrontMatter::AutomaticEmbeds.register
    parser = Mail2FrontMatter::Parser.new(wrapped)

    metadata, body = Mail2FrontMatter::AutomaticEmbeds.run(parser.metadata, parser.body)

    expect(body).to_not match(/href/)

  end

end