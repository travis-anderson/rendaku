# Rendaku [![Build Status](https://travis-ci.org/travis-anderson/rendaku.svg)](https://travis-ci.org/travis-anderson/rendaku)

Rendaku is a ruby gem which accepts book dimensions and a simple image file for
generating book art page-folding instructions.

![book-folding art by my wife](https://i.imgur.com/9KTDiUG.png)


Inspired by the work at https://github.com/Moini/BookArtGenerator

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rendaku'
```

And then execute:

```shell
bundle
```

Or install it locally:

```shell
gem install rendaku
```

## Usage

```ruby
book_first_page   = 2
book_last_page    = 300
book_height_in_cm = 18 # or inches
book = Rendaku::Book.new book_first_page, book_last_page, book_height_in_cm

# image can be of jpeg, gif, or png format,
# but should be a simple black & white image for best results
image = Rendaku::Image::read('/path/to/file.png').first

pattern = Rendaku::Pattern.new book, image

pattern.book #=> #<Rendaku::Book:0x007fde931e03b0 @first_page=2, @last_page=300, @height=18>
pattern.image #=> /path/to/file.png PNG 629x1241=>150x1800 150x1800+0+0 DirectClass 8-bit

# the template outputs a list of page numbers and associated folds
# measured from the top of the page
pattern.template #=> [[{ :page => 2, :top => 6.04, :bottom => 6.08 }],[{ :page => 4, :top => 6.02, :bottom => 6.11 }]]
```
