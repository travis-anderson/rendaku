require 'minitest/autorun'
require './lib/rendaku'

class TestRendaku < Minitest::Test
  include Rendaku

  def setup
    @image = Image::read(File.dirname(__FILE__)+'/test_images/ankh.png')[0]
    @book = Book.new 2, 300, 18
    @pattern = Pattern.new @book, @image
  end

  def test_book_has_properties
    assert_equal @book.first_page, 2
    assert_equal @book.last_page, 300
    assert_equal @book.height, 18
  end

  def test_image_has_properties
    assert_includes @image.filename, 'ankh.png'
  end

  def test_pattern_has_properties
    assert_equal @pattern.image, @image
    assert_equal @pattern.book, @book
    refute_empty @pattern.template
  end

  def test_template_has_properties
    assert_includes @pattern.template[0], :page
    assert_includes @pattern.template[0], :top
    assert_includes @pattern.template[0], :bottom
  end

  def test_template_has_correct_values
    assert_equal @pattern.template[0][:page], 2
    assert_equal @pattern.template[0][:top], 6.04
    assert_equal @pattern.template[0][:bottom], 6.08
  end
end
