# Mail2FrontMatter::AutomaticEmbeds

AutomaticEmbeds is a [Mail2FrontMatter](https://github.com/whistlerbrk/mail2frontmatter) plugin which generates embed codes for links. This is a thin layer around the [auto_html](https://github.com/whistlerbrk/auto_html) project to generate the necessary HTML.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'm2fm-automatic-embeds', require: false
```

And then execute:

    $ bundle

## Configuration

In your Mail2FrontMatter YAML configuration enable the plugin by adding it to your preprocessors:

```yaml
preprocessors:
  - key: 'automatic-embeds'
```

You can provide a whitelist or blacklist for filters as well as providing filters options. Filter options are documented at the auto_html project.

```yaml
preprocessors:
  - key: 'automatic-embeds'
    options:
      white_list:
        - youtube
        - soundcloud
        - vimeo
      filters:
        youtube:
          autoplay: true
          other_attribute: other_value
```

## Usage

That's it! Now incoming links from a number of [content providers](https://github.com/dejan/auto_html/tree/master/lib/auto_html/filters) will be embedded automatically.

## Contributing

1. Fork it ( https://github.com/whistlerbrk/m2fm-automatic-embed/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
