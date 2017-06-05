require "helper"

class ImageComponent < JekyllUnitTest
  should "generate an <img> even without the src/srcset prop defined" do
    @joule.render(%Q[
      {% Image class: "nope" %}
    ])
    o = @joule.find("img")

    assert(o)
    assert(o.prop("class").include?("nope"))
  end

  should "accept primary <img> attributes" do
    h = %Q[
      {% img
        alt: "alt"
        class: "one"
        height: "200"
        src: "test.png"
        style: "background: red;"
        title: "title"
        width: "400"
      %}
    ]
    doc = @joule.render(h)
    image = doc.css("img")[0]

    class_name = image["class"]
    data_src = image["data-src"]
    src = image["src"]

    assert(image["class"].include? "one")
    assert(image["style"].include? "background")
    assert_equal(image["alt"], "alt")
    assert_equal(image["height"], "200")
    assert_equal(image["title"], "title")
    assert_equal(image["width"], "400")
  end

  should "accept default <img> attributes" do
    h = %Q[
      {% img
        alt: "alt"
        class: "one"
        height: "200"
        src: "test.png"
        style: "background: red;"
        title: "title"
        width: "400"
      %}
    ]
    doc = @joule.render(h)
    image = doc.css(".one")[0]

    class_name = image["class"]
    data_src = image["data-src"]
    src = image["src"]

    assert(image["class"].include? "one")
    assert(image["style"].include? "background")
    assert_equal(image["alt"], "alt")
    assert_equal(image["height"], "200")
    assert_equal(image["title"], "title")
    assert_equal(image["width"], "400")
  end

  should "accept data attributes" do
    h = %Q[
      {% img
        class: "data-attr"
        data_jared: "cupcake"
      %}
    ]
    doc = @joule.render(h)
    image = doc.css("img.data-attr")[0]

    assert(image["data-jared"].include? "cupcake")
  end

  should "have HTML safe alt and title props" do
    h = %Q[
      {% img
        alt: "Don't break now. \"Weeee\""
        class: "encode"
        height: "200"
        src: "test.png"
        style: "background: red;"
        title: "Don't break now. \"Weeee\""
        width: "400"
      %}
    ]
    doc = @joule.render(h)
    image = doc.css("img.encode")[0]

    assert(!image["alt"].include?("'"))
    assert(!image["alt"].include?("\""))
    assert(image["alt"].include? "Dont break now")
    assert(!image["title"].include?("'"))
    assert(!image["title"].include?("\""))
    assert(image["title"].include? "Dont break now")
  end

  should "lazy-load by default" do
    h = %Q[
      {% img
        alt: "alt"
        class: "one"
        height: "200"
        src: "test.png"
        style: "background: red;"
        title: "title"
        width: "400"
      %}
    ]
    doc = @joule.render(h)
    image = doc.css("img")[0]

    class_name = image["class"]
    data_src = image["data-src"]
    src = image["src"]

    assert(src.include?("base64"), "src uses a base64 placeholder image")
    assert(data_src.include?("test.png"), "data-src is prepped for lazy-loader")
    assert(class_name.include?("b-lazy"), "has lazy-load class")
  end

  should "be able to skip lazy-loading" do
    h = %Q[
      {% img
        class: "no-lazy"
        src: "test.png"
        skip_lazy: true
      %}
    ]
    doc = @joule.render(h)
    image = doc.css("img.no-lazy")[0]

    assert(image["src"].include?("test.png"))
    assert(image["class"].include?("b-skipped"))
  end

  should "include <noscript> img" do
    h = %Q[
      {% img
        alt: "alt"
        class: "one"
        height: "200"
        src: "test.png"
        style: "background: red;"
        title: "title"
        width: "400"
      %}
    ]
    doc = @joule.render(h)
    image = doc.css("noscript img")[0]

    assert(image["src"].include?("test.png"))
  end

  should "not use responsive images by default" do
    h = %Q[
      {% img
        alt: "alt"
        class: "one"
        height: "200"
        src: "test.png"
        style: "background: red;"
        title: "title"
        width: "400"
      %}
    ]
    doc = @joule.render(h)
    image = doc.css("img")[0]

    assert(!image["data-src"].include?("@1x"))
    assert(!image["data-src"].include?("@2x"))
    assert(!image["srcset"])
  end


  should "generate responsive image sizes when using srcset" do
    h = %Q[
      {% img
        class: "responsive"
        srcset: "test.png"
        width: "600"
      %}
    ]
    doc = @joule.render(h)
    image = doc.css("img.responsive")[0]
    width = 600

    assert(image["data-src"].include?("@1x"))
    assert(!image["data-src"].include?("@2x"))
    assert(image["srcset"].include?("@1x"))
    assert(image["srcset"].include?("@2x"))
    assert(image["srcset"].include?("#{width}w"))
    assert(image["srcset"].include?("#{width * 2}w"))
  end

  should "not generate w image srcset, if width is missing" do
    markup = %Q[
      {% img
        srcset: "hello.png"
        height: 100
      %}
    ]
    @joule.render(markup)
    image = @joule.find("img")

    assert(!image["srcset"].include?("w"))
  end
end
