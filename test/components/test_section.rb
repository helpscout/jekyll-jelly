require "helper"

class SectionComponent < JekyllUnitTest
  should "accept id, class, and style props" do
    h = %Q[
      {% Section
        class: "hello"
        data_one_two: "three"
        data_src: "bg.png"
        id: "hello-id"
        style: "background: red; padding: 20px;"
      %}
        Hello
      {% endSection %}
    ]
    doc = @joule.render(h)
    section = doc.css(".o-section")[0]

    assert(section)
    assert(section["id"].include?("hello"))
    assert(section["class"].include?("hello"))
    assert(section["style"].include?("background"))
  end

  should "accept data props" do
    h = %Q[
      {% Section
        class: "hello"
        data_one_two: "three"
        data_src: "bg.png"
        id: "hello-id"
        style: "background: red; padding: 20px;"
      %}
        Hello
      {% endSection %}
    ]
    doc = @joule.render(h)
    section = doc.css(".o-section")[0]

    assert_equal(section["data-src"], "bg.png")
    assert_equal(section["data-one-two"], "three")
    assert(section.text.downcase.include?("hello"))
  end

  should "render content" do
    h = %Q[
      {% Section
        class: "hello"
        data_one_two: "three"
        data_src: "bg.png"
        id: "hello-id"
        style: "background: red; padding: 20px;"
      %}
        Hello
      {% endSection %}
    ]
    doc = @joule.render(h)
    section = doc.css(".o-section")[0]

    assert(section.text.downcase.include?("hello"))
  end

  should "render recursively" do
    h = %Q[
      {% Section class: "recursion" %}
        {% Section class: "inner" %}
          {% Section class: "milk" %}
            Ahhhh!!!!
            {% Image src: "milk.png" %}
          {% endSection %}
        {% endSection %}
      {% endSection %}
    ]
    doc = @joule.render(h)
    section = doc.css(".recursion")[0]
    inner = doc.css(".recursion .inner")[0]
    milk = doc.css(".recursion .inner .milk")[0]

    assert(section)
    assert(inner)
    assert(milk)
    assert(milk.text.downcase.include?("ahh"))
  end

  should "render inner components" do
    h = %Q[
      {% Section class: "recursion" %}
        {% Section class: "inner" %}
          {% Section class: "milk" %}
            Ahhhh!!!!
            {% Image src: "milk.png" %}
          {% endSection %}
        {% endSection %}
      {% endSection %}
    ]
    doc = @joule.render(h)
    image = doc.css(".recursion img")[0]

    assert(image)
  end

  should "render a container by default" do
    h = %Q[
      {% Section
        class: "hello"
        data_one_two: "three"
        data_src: "bg.png"
        id: "hello-id"
        style: "background: red; padding: 20px;"
      %}
        Hello
      {% endSection %}
    ]
    doc = @joule.render(h)
    container = doc.css(".o-section.hello .o-container")[0]

    assert(container)
  end

  should "omit a container if set to false" do
    h = %Q[
      {% Section container: false class: "container" %}
        Contained!
      {% endSection %}
    ]
    doc = @joule.render(h)
    section = doc.css(".o-section.container")[0]
    container = doc.css(".o-section.container .o-container")[0]

    assert(section)
    assert(!container)
  end
end

