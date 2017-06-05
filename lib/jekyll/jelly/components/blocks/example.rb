require "jekyll-spark"
require "rouge"

module Jekyll
  class ExampleComponent < ComponentBlock
    include Liquid::StandardFilters

    # The regular expression syntax checker. Start with the language specifier.
    # Follow that by zero or more space separated options that take one of three
    # forms: name, name=value, or name="<quoted list>"
    #
    # <quoted list> is a space-separated list of numbers
    SYNTAX = /^([a-zA-Z0-9.+#-]+)((\s+\w+(=((\w|[0-9_-])+|"([0-9]+\s)*[0-9]+"))?)*)$/

    def initialize(tag_name, markup, tokens)
      super
      if markup.strip =~ SYNTAX
        @lang = $1.downcase
        @options = {}
        # if defined?($2) && $2 != ''
        #   # Split along 3 possible forms -- key="<quoted list>", key=value, or key
        #   $2.scan(/(?:\w+(?:=(?:(?:\w|[0-9_-])+|"[^"]*")?)?)/) do |opt|
        #     key, value = opt.split('=')
        #     # If a quoted list, convert to array
        #     if value && value.include?("\"")
        #         value.gsub!(/"/, "")
        #         value = value.split
        #     end
        #     @options[key.to_sym] = value || true
        #   end
        # end
        @options[:linenos] = "inline" if @options.key?(:linenos) and @options[:linenos] == true
      end
    end

    def example(code, output)
      language = @lang.to_s

      if(language == "html" or language == "")
        output = "<div class=\"c-card hs-code u-mrg-t-4 u-mrg-b-7\" data-js=\""+@lang.to_s+"\"><div class=\"u-pad-5 hs-code__example\" data-example-id=\"#{@options[:id]}\">\n#{code}\n</div>"
      else
        output = "<div class=\"c-card hs-code u-mrg-t-4 u-mrg-b-7\" data-js=\""+@lang.to_s+"\">"
      end

      output
    end

    def render_rouge(code)
      formatter = Rouge::Formatters::HTML.new(line_numbers: @options[:linenos], wrap: false)
      lexer = Rouge::Lexer.find_fancy(@lang, code) || Rouge::Lexers::PlainText
      code = formatter.format(lexer.lex(code))
      "<div class=\"c-clipboard-copy-container js-code-snippet t-bdr-top\"><div class=\"u-pad-5 hs-code__highlight highlight\"><pre>#{code}</pre></div></div></div>"
    end

    def add_code_tag(code)
      # Add nested <code> tags to code blocks
      code = code.sub(/<pre>\n*/,'<pre><code class="language-' + @lang.to_s.gsub("+", "-") + '" data-lang="' + @lang.to_s + '">')
      code = code.sub(/\n*<\/pre>/,"</code></pre>")
      code.strip
    end

    def template(context)
      content = @props["content"]
      prefix = context["highlighter_prefix"] || ""
      suffix = context["highlighter_suffix"] || ""
      code = content.to_s.strip

      output = case context.registers[:site].highlighter

      when 'rouge'
        render_rouge(code)
      end

      if (@lang.to_s == "html")
        rendered_output = example(code, output) + add_code_tag(output)
      else
        rendered_output = example(code, output) + '</div>'
      end
      prefix + rendered_output + suffix
    end

  end
end

Liquid::Template.register_tag("example", Jekyll::ExampleComponent)
Liquid::Template.register_tag("Example", Jekyll::ExampleComponent)
