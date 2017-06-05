require "helper"

class WistiaPopoverComponent < JekyllUnitTest
  should "not generate unless an ID prop is passed" do
    h = %Q[
      {% WistiaPopover class: "first" %}
        Hello
      {% endWistiaPopover %}
    ]
    doc = @joule.render(h)
    o = doc.find(".first")

    assert(!o)
  end

  should "generate an async Wistia popover embed code with an ID" do
    h = %Q[
      {% WistiaPopover id: "hello" class: "first" %}
        Hello
      {% endWistiaPopover %}
    ]
    doc = @joule.render(h)
    span = doc.css(".first")[0]

    assert(span)
    assert(span.text.downcase.include?("hello"))
    assert(span["class"].include?("wistia_async_hello"))
  end

  should "have the appropriate default Wistia popover embed classes" do
    h = %Q[
      {% WistiaPopover id: "hello" class: "first" %}
        Hello
      {% endWistiaPopover %}
    ]
    doc = @joule.render(h)
    span = doc.css(".first")[0]

    assert(span["class"].include?("popover=true"))
    assert(span["class"].include?("popoverContent=link"))
  end

  should "generate a block with markup-based content" do
    h = %Q[
      {% WistiaPopover id: "linky" class: "linky" %}
        <a href="https://helpscout.net">Help Scout</a>
      {% endWistiaPopover %}
    ]
    doc = @joule.render(h)
    span = doc.css(".linky")[0]
    link = doc.css(".linky a")[0]

    assert(span)
    assert(span["class"].include?("wistia_async_linky"))
    assert(link)
    assert(link["href"].include?("helpscout.net"))
    assert(link.text.include?("Help Scout"))
  end

  should "render style prop" do
    h = %Q[
      {% WistiaPopover
        id: "mov123"
        class: "stylin"
        style: "display: inline-block"
      %}
        <a class="text-link link-caret-right" href="#">Watch the video</a>
      {% endWistiaPopover %}
    ]
    doc = @joule.render(h)
    span = doc.css(".stylin")[0]
    link = doc.css(".stylin a")[0]

    assert(span)
    assert(span["style"].include?("inline-block"))
    assert(link)
    assert(link["class"].include?("text-link"))
    assert(link["href"].include?("#"))
    assert(link.text.include?("video"))
  end

  should "evaluate variables within content" do
    h = %Q[
      ---
      title: "Wistia Popover"
      text: "wut"
      ---
      {% WistiaPopover id: "linky" class: "eval" %}
        {% if page.text %}
          {{ page.text }}
        {% else %}
          Nope!
        {% endif %}
      {% endWistiaPopover %}
    ]
    doc = @joule.render(h)
    span = doc.css(".eval")[0]

    assert(span)
    assert(span.text.include?("wut"))
  end

  should "render alternative selector if specified" do
    h = %Q[
      {% WistiaPopover
        class: "divvy"
        id: "mov123"
        selector: "div"
      %}
        Divvy
      {% endWistiaPopover %}
    ]
    doc = @joule.render(h)
    o = doc.css("div.divvy")[0]

    assert(o)
  end
end
