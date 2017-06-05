require "jekyll-spark"

module Jekyll
  class SectionComponent < ComponentBlock
    DEFAULT_TAG_PROPS = [
      "id",
      "style",
    ]

    def template(context)
      class_name = @props["class"]
      container = @props["container"].nil? ? true : @props["container"]
      content = @props["content"]
      default_props = selector_props(DEFAULT_TAG_PROPS)

      if (container)
        content = %Q[
          <div class="o-container">
            #{content}
          </div>
        ]
      end

      render = %Q[
        <div class="o-section #{class_name}" #{default_props}>
          #{content}
        </div>
      ]
    end
  end
end

Liquid::Template.register_tag(
  "Section",
  Jekyll::SectionComponent
)
