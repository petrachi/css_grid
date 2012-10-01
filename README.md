# CssGrid

This Gem allow you to use a css grid, and provide several helpers.

__Grid__ is a 12 column alignment system, based on 1140px width. That fit for 1280*720 screens. This is responsive design and adapt for smaller screens, and mobile screens.

__Helpers__ facilitate the use of the grid syntax, to produce correct html markdown. This allow you to pass collections and block, and map the result to insert it into correct html tags.

## Installation

Add this line to your application's Gemfile:

    gem 'css_grid'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install css_grid

## Use

### Css Grid

To use the css class for grid, you need to require the grid.css file in you'r asset pipeline.

app/assets/stylesheets/application.css
```css
	/*
	 *= require grid
	 */
```

### Grid Helpers

To use the methods helper provide, you need to include GridHelper

app/helpers/application_helper.rb
```ruby
	include GridHelper
```

## Usage

### Css Grid Tags

__Container__ is a full width div that allows layouts to have a background that spans the full width of the browser

__Row__ is a row of columns. It centres them and defines the 1140px max-width.

__Span__ is the column, there are twelve classes to define the width for each column. Defined from 'one_span' to 'twelve_span'

There is some example of what you can do :
```html
	<div class="container">
			<div class="row">
				<div class="six_span">
					<!-- this is a half width column -->
				</div>
				<div class="six_span">
					<!-- this is a half width column -->
				</div>
			</div>
		</div>
	</div>
```

```html
	<div class="container">
		<div class="row">
			<div class="three_span">
				<!-- this is a quart width column -->
			</div>
			<div class="three_span">
				<!-- this is a quart width column -->
			</div>
			<div class="six_span">
				<!-- this is a half width column -->
			</div>
		</div>
			
		<div class="row">
			<div class="twelve_span">
				<!-- this is a full width column -->
			</div>
		</div>
	</div>
```


### Grid Helpers

The grid helpers allow you to shortcut creation for the css grid tags.

#### Basics 

You can call 'container', 'row' or '*_span' functions that create the corresponding divs

Code

erb code
```erb
	<%= container do %>
		<!-- some html -->
	<% end %>
```

will produce
```html
	<div class="container">
		<!-- some html -->
	</div>
```

You can pass specific html ids or class as arguments

erb code
```erb
	<%= row :class=>:some_class do %>
		<!-- some html -->
	<% end %>
```

will produce
```html
	<div class="row some_class">
		<!-- some html -->
	</div>
```

--
erb code
```erb
	<%= six_span :id=>:some_id, :class=>"class_one class_two" do %>
		<!-- some html -->
	<% end %>
```

will produce
```html
	<div class="six_span class_one class_two" id="some_id">
		<!-- some html -->
	</div>
```

You can also pass 'offset' as an argument for the '*_span' helpers. Offset will slide the column to the left. (like you insert a empty *_span before)

erb code
```erb
	<%= four_span :offset=>:two do %>
		<!-- some html -->
	<% end %>
```

will produce
```html
	<div class="four_span offset_two">
		<!-- some html -->
	</div>
```

--
erb code
```erb
	<%= four_span :offset=>2 do %>
		<!-- some html -->
	<% end %>
```

will produce
```html
	<div class="four_span offset_two">
		<!-- some html -->
	</div>
```

#### Collections

The most interesting part if you ask me! 
GridHelper allow you to create severals columns in one time. And include them directly into row or container.

Imagine I have this yml file
```yml
	en:
		array:
			name: Array
			description: It's an array !
			
		hash:
			name: Hash
			descrption: I love hash, it's so fun !
			
		string:
			name: Text
			description: Just read the text.
```

I can do in my view
```erb
	<%= two_col_container :collection=>[:array, :hash, :string] do |i18n_key| %>
		<h2><%=t "#{ i18n_key }.name" %></h2>
		<p><%=t "#{ i18n_key }.description" %></p>
	<% end %>
```

This will use two col per row (so six_span width), yield the block for each element, and place them into correct rows / container
So the produced html will be
```html
	<div class="container">
		<div class="row">
			<div class="six_span">
				<h2>Array</h2>
				<p>It's an array !</p>
			</div>
			<div class="six_span">
				<h2>Hash</h2>
				<p>I love hash, it's so fun !</p>
			</div>
		</div>
		
		<div class="row">
			<div class="six_span">
				<h2>Text</h2>
				<p>Just read the text.</p>
			</div>
		</div>
	</div>
```

So You can play easily with grid and your collections. Users.all for example ;)

--
If you just want to create a single row, you can just do 
```erb
	<%= four_col_row :collection=>[1, 2, 3, 4], :id=>:count_style do |i| %>
		<p>count <%= i %></p>
	<% end %>
```

will use four col per row (so three_span width), will produce
```html
	<div class="row count_style">
		<div class="three_span">
			<p>count 1</p>
		</div>
		<div class="three_span">
			<p>count 2</p>
		</div>
		<div class="three_span">
			<p>count 3</p>
		</div>
		<div class="three_span">
			<p>count 4</p>
		</div>
	</div>
```

FYI: 'id' and 'class' options can also be used for *_col_ccontainer and *_col_row, wich is applied to the container / row


## Future ameliorations

I will add the possibility, in *_col_container, to use several *_span for the same object.
I think this will be great, forms for example.

```html
	<div class="row">
		<div class="three_span">
			<label>Email</label>
		</div>
		<div class="nine_span">
			<input id="email">
		</div>
	</div>
```

by passing
```erb
	<%= twelve_col_container :collection=>[:email], :auto_span=>:disabled do |field| %>
		<%= three_span{ label_tag field }%>
		<%= nine_span{ text_field_tag field }%>
	<% end %>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
