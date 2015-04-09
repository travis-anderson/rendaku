module Rendaku
  require 'rmagick'
  include Magick

  class Book
    attr_accessor :first_page, :last_page, :height

    def initialize fp, lp, h
      @first_page = fp
      @last_page  = lp
      @height     = h
    end
  end

  class Pattern
    attr_accessor :book, :image, :template

    def initialize b, i
      @book  = b
      @image = i
      @template = fold_template prepare_pattern
    end

    private

      def fold_template pattern
        template = []
        pattern.each_with_index do |contents, col|
          top_corner    = contents[0][:start]
          bottom_corner = contents[0][:end]
          page          = (col*2) + @book.first_page

          template << { page: page, top: top_corner, bottom: bottom_corner }
        end

        template
      end

      def prepare_pattern
        pages   = (@book.last_page - @book.first_page)/2 + 1
        height  = @book.height * 100
        image   = squish_image pages, height, @image
        white   = Rendaku::Pixel.from_color 'white'
        pattern = []

        pages.times do |x|
          pixel_above = nil
          changes     = false
          color_bands = -1
          pattern[x]  = []

          height.times do |y|
            pixel = image.pixel_color(x, y)
            if pixel_above.nil? && pixel != white
              pixel_above = pixel
              color_bands += 1
              pattern[x][color_bands] = { start: 0 }
              changes = true
            elsif pixel != white && y == height-1
              pattern[x][color_bands][:end] = (y+1).fdiv(100)
              changes = true
            elsif pixel_above.nil? || pixel_above == pixel
              pixel_above = pixel
              next
            elsif pixel_above == white && pixel != white
              pixel_above = pixel
              color_bands += 1
              pattern[x][color_bands] = { start: y.fdiv(100) }
              changes = true
            elsif pixel_above != white && pixel == white
              pixel_above = pixel
              pattern[x][color_bands][:end] = (y+1).fdiv(100)
              changes = true
            end
          end
          pattern[x] = "nofolds" unless changes
        end

        create_final pattern
      end

      def squish_image pages, height, image
        img = image.resize! pages, height
        img.threshold Rendaku::QuantumRange*0.5
        img.trim!
      end

      def too_many_holes? pattern
        empty         = 0
        empty_allowed = 0

        empty_allowed += 1 if pattern[0] == "nofolds"
        empty_allowed += 1 if pattern.last == "nofolds"

        pattern.each_with_index do |p, i|
          if p == "nofolds"
            if i == 0
              empty += 1
            elsif pattern[i-1] != "nofolds"
              empty += 1
            end
          end
        end

        empty > empty_allowed
      end

      def create_final pattern
        final_pattern = []

        pattern.each_with_index do |bands,col|
          if bands.length == 1
            final_pattern[col] = bands unless bands == "nofolds"
            next
          elsif bands.length > 6
            raise "Too much detail"
          else
            final_pattern[col] = [bands[col%bands.length]]
          end
        end

        final_pattern
      end
  end
end
