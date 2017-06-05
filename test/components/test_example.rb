require "helper"

class ExampleComponent < JekyllUnitTest
  should "render example block with specified syntax language" do
    h = %Q[
      {% example html %}
        <button class="c-button">Button</button>
      {% endexample %}
    ]
    doc = @joule.render(h)
    o = doc.find(".c-card")

    assert(o)
    assert_equal(o.prop("data-js"), "html")
    assert(o.find(".hs-code__example"))
    assert(o.find(".highlight"))
    assert(o.find("button.c-button"))
  end

  should "render example block without syntax language" do
    h = %Q[
      {% example %}
        <button class="c-button">Button</button>
      {% endexample %}
    ]
    doc = @joule.render(h)
    o = doc.find(".c-card")

    assert(o)
    assert_equal(o.get("data-js"), "")
    assert(o.find(".hs-code__example"))
    assert(o.find("button.c-button"))
  end

  should "render example block non HTML syntax language" do
    h = %Q[
      {% example css %}
        .c-button {
          display: block;
        }
      {% endexample %}
    ]
    doc = @joule.render(h)
    o = doc.find(".c-card")

    assert(o)
    assert_equal(o.get("data-js"), "css")
    assert(!o.find(".hs-code__example"))
  end
end
