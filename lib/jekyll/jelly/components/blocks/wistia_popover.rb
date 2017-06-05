require "jekyll-spark"

module Jekyll
  class WistiaPopoverComponent < ComponentBlock
    def template(context)
      unless @props["id"]
        return ""
      end

      id = @props["id"].gsub("wistia_", "").gsub("Wistia_", "")
      class_name = @props["class"]
      content = @props["content"]
      popover_content = @props["popoverContent"] || "link"
      selector = @props["selector"] || "span"
      style = @props["style"]

      popover_content = "popoverContent=#{popover_content}"

      render = %Q[
        <script src="https://fast.wistia.com/embed/medias/#{id}.jsonp" async></script>
        <#{selector}
          class="
            #{class_name}
            wistia_embed wistia_async_#{id}
            popover=true popoverAnimateThumbnail=true
            #{popover_content}
          "
          style="#{style}"
        >
          #{content}
        </#{selector}>
      ]
    end
  end
end

Liquid::Template.register_tag('WistiaPopover', Jekyll::WistiaPopoverComponent)
