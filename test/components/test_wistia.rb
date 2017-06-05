require "helper"

class WistiaComponent < JekyllUnitTest
  should "not generate unless an ID prop is passed" do
    h = %Q[
      {% Wistia class: "nope" %}
    ]
    doc = @joule.render(h)

    assert(!doc.find(".nope"))
    assert(!doc.find("script"))
  end

  should "should accept class prop" do
    h = %Q[
      {% Wistia id: "something123" class: "yup" %}
    ]
    doc = @joule.render(h)
    o = doc.find(".yup")

    assert(o)
  end


  should "strip wistia- (hyphen) from the ID" do
    h = %Q[
      <div class="wistia-thing">
        {% Wistia id: "wistia-123" %}
      </div>
    ]
    doc = @joule.render(h)
    script = doc.find(".wistia-thing script")

    assert(!script.prop("src").include?("wistia-"))
  end

  should "strip wistia_ (underscore) from the ID" do
    h = %Q[
      <div class="wistia-thing">
        {% Wistia id: "wistia_123" %}
      </div>
    ]
    doc = @joule.render(h)
    script = doc.find(".wistia-thing script")

    assert(!script.prop("src").include?("wistia_"))
  end
end
