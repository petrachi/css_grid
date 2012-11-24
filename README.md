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

#### Rails <= 3.0

Add the following lines to your rakefile then run 'rake css:grid:setup' to copy 'grid.css' to public/stylesheets
```
	require 'css_grid'
	require 'css_grid/tasks'
```

Then include the grid.css file in your layout

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

```erb
	<%= container do %>
		<!-- some html -->
	<% end %>
```

```html
	<div class="container">
		<!-- some html -->
	</div>
```

--

You can pass specific html ids or class as arguments

```erb
	<%= row :class=>:some_class do %>
		<!-- some html -->
	<% end %>
```

```html
	<div class="row some_class">
		<!-- some html -->
	</div>
```

--

You can also pass 'prepend' or 'append as an argument for the '*_span' helpers. Prepend will slide the column to the left. Append will slide the next column to the left.

```erb
	<%= four_span :prepend=>2 do %>
		<!-- some html -->
	<% end %>
```

```html
	<div class="four_span prepend_two">
		<!-- some html -->
	</div>
```

```erb
	<%= four_span :append=>1 do %>
		<!-- some html -->
	<% end %>
```

```html
	<div class="four_span append_one">
		<!-- some html -->
	</div>
```

Note that 'prepend' accept negative values

```erb
	<%= four_span :prepend=>-1 do %>
		<!-- some html -->
	<% end %>
```

```html
	<div class="four_span minus_one">
		<!-- some html -->
	</div>
```

--

You can add any attributes just like in content_tag. For example new html5 deta-* attributes.

```erb
	<%= six_span :'data-name'=>"Thomas Petrachi" do %>
		<!-- some html -->
	<% end %>
```

```html
	<div class="six_span" data-name="Thomas Petrachi">
		<!-- some html -->
	</div>
```

--

You can use the 'element' option to specify the html element wich will be created

```erb
	<%= container :element=>:header do %>
		<!-- some html -->
	<% end %>
```

```html
	<header class="container">
		<!-- some html -->
	</header>
```

--

If you want to use rows inside *_spans tags, you can use :nested option.

```erb
	<%= four_span do %>
		<%= row :nested => true do %>
			<%= two_span do %>
				<!-- some html -->
			<% end %>
			
			<%= two_span do %>
				<!-- some other html -->
			<% end %>
		<% end %>
	<% end %>
```

```html
	<div class="four_span">
		<div class="row nested">
			<div class="two_span">
				<!-- some html -->
			</div>
			
			<div class="two_span">
				<!-- some other html -->
			</div>
		</div>
	</div>
```

#### Collections

GridHelper allow you to create severals columns in one time. And include them directly into row or container.

There is my collection
```ruby
	@collection = [Enumerable, Array, String].inject([]){ |collection, klass| 
		collection << {:name=>klass.name, :methods=>"#{ klass.methods.count } methods"} 
	}
	
	@large_collection = [Hash, Set, Fixnum, Float, NilClass, TrueClass].inject([]){ |collection, klass| 
		collection << {:name=>klass.name, :methods=>"#{ klass.methods.count } methods"} 
	}
```

I can call *_col_container with a :collection option
```erb
	<%= three_cols_container :collection=>@collection do |elt| %>
		Class : <%= elt[:name] %><br/>
		Detail : <%= elt[:methods] %>
	<% end %>
```

It will create an grid structure using four_spans (three columns on a twelve grid).
```html
	<section class="container ">
		<div class="row ">
			<div class="four_span ">
				Class : Enumerable<br>
				Detail : 163 methods
			</div>
			<div class="four_span ">
				Class : Array<br>
				Detail : 178 methods
			</div>
			<div class="four_span ">
				Class : String<br>
				Detail : 177 methods
			</div>
		</div>
	</section>
```

Screenshot
![css_grid normal](https://raw.github.com/petrachi/css_grid/master/ressources/readme/normal.png)


If you'r more comfortable by telling width of spans istead of the nurmber of columns to use, you can use *_span_container the exact same way than *_col_container. To create the same output as previously, call :
```erb
	<%= four_spans_container :collection=>@collection do |elt| %>
		Class : <%= elt[:name] %><br/>
		Detail : <%= elt[:methods] %>
	<% end %>
```

Note that *_col_container and *_span_container can also be called *_cols_container and *_spans_container. They respond to the following regexp : 
````ruby
	/^(one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve)_cols?_container$/
	/^(one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve)_spans?_container$/
```

Here is a list of options you can use. Following exemples.
* :id => String or Symbol - set the id attribute for the container.
* :class => String or Symbol - set the class attribute for the container.
* :nested => :spans - allow to use *_span tags directly inside the block passed by.
* :disable => :spans or :container or [:spans, :container] - disable automatic creation of *_spans tags, or container tag, or both, allow you to handle this part manually.
* :spans => Hash (authorized keys are :id, :class, :prepend, :append) - pass by options to automatic created *_spans tags.
* :rows => Hash (authorized keys are :id, :class and :nested) - pass by options to automatic created rows tags.

Note :
* You can use procs in any option.

Also : 
* :nested also accept :container as a value (works the same way as :disable). It allows to use *_col_container inside a *_span tag. :nested_with => Integer must be informed in that case, telling the width of the span you'r in.
* the GridHelper automaticly calculate if you are in a nested container and pass options :nested=>:container and :nested_width on his own. So you normaly don't have to care about that.


Shortcuts : 
* one_col_row method create a row with a full with span inside (usualy twelve_span, but this can change if you'r in nested container).
* options :disable and :rows will be ignore, and options :id and :class will be directly applied to the row tag.

Examples : 
```erb
	<%= three_cols_container :collection=>@collection, :spans=>{:id => Proc.new{ |elt| elt[:name].downcase }} do |elt| %>
		<%= four_span do %>
			Class : <%= elt[:name] %><br/>
			Detail : <%= elt[:methods] %>
		<% end %>
	<% end %>
```

```html
	<section class="container " id="nested">
		<div class="row ">
			<div class="four_span " id="enumerable">
				Class : Enumerable<br/>
				Detail : 163 methods
			</div>
			<div class="four_span " id="array">
				Class : Array<br/>
				Detail : 178 methods
			</div>
			<div class="four_span " id="string">
				Class : String<br/>
				Detail : 177 methods
			</div>
		</div>
	</section>
```

--


```erb
	<%= three_cols_container :id=>"nested", :collection=>@collection, :nested=>:spans do |elt| %>
		<%= two_span do %>
			Class : <%= elt[:name] %>
		<% end %>

		<%= two_span do %>
			Detail : <%= elt[:methods] %>
		<% end %>
	<% end %>
```

```html
	<section class="container " id="nested">
		<div class="row ">
			<div class="four_span ">
				<div class="row  nested">
					<div class="two_span ">Class : Enumerable</div>	
					<div class="two_span ">Detail : 163 methods</div>
				</div>
			</div>
			<div class="four_span ">
				<div class="row  nested">
					<div class="two_span ">Class : Array</div>	
					<div class="two_span ">Detail : 178 methods</div>
				</div>
			</div>
			<div class="four_span ">
				<div class="row  nested">
					<div class="two_span ">Class : String</div>	
					<div class="two_span ">Detail : 177 methods</div>
				</div>
			</div>
		</div>
	</section>
```

![css_grid nested](https://raw.github.com/petrachi/css_grid/master/ressources/readme/nested.png)

--


```erb
	<%= three_cols_container :id=>"disable_spans", :collection=>@collection, :disable=>:spans do |elt| %>
		<%= two_span do %>
			Class : <%= elt[:name] %>
		<% end %>

		<%= two_span do %>
			Detail : <%= elt[:methods] %>
		<% end %>
	<% end %>
```

```html
	<section class="container " id="disable_spans">
		<div class="row ">
			<div class="two_span ">Class : Enumerable</div>	
			<div class="two_span ">Detail : 163 methods</div>
			
			<div class="two_span ">Class : Array</div>	
			<div class="two_span ">Detail : 178 methods</div>
			
			<div class="two_span ">Class : String</div>	
			<div class="two_span ">Detail : 177 methods</div>
		</div>
	</section>
```

![css_grid disable](https://raw.github.com/petrachi/css_grid/master/ressources/readme/disable.png)

--


```erb
	<%= three_cols_container :id=>"prepend", :collection=>@collection, :spans=>{:prepend=>2} do |elt| %>
		Class : <%= elt[:name] %><br/>
		Detail : <%= elt[:methods] %>
	<% end %>
```

```html
	<section class="container " id="prepend">
		<div class="row ">
			<div class="two_span  prepend_two">
				Class : Enumerable<br>
				Detail : 163 methods
			</div>
			<div class="two_span  prepend_two">
				Class : Array<br>
				Detail : 178 methods
			</div>
			<div class="two_span  prepend_two">
				Class : String<br>
				Detail : 177 methods
			</div>
		</div>
	</section>
```

![css_grid prepend](https://raw.github.com/petrachi/css_grid/master/ressources/readme/prepend.png)

--


```erb
	<%= one_cols_container :disable=>:spans do %>

		<%= three_span :id=>:menu do %>
			Menu
		<% end %>

		<%= nine_span :id=>:content do %>
			<%= three_cols_container :id=>"nested_container", :collection=>@large_collection do |elt| %>
				Class : <%= elt[:name] %><br/>
				Detail : <%= elt[:methods] %>
			<% end %>
		<% end %>
	<% end %>
```

```html
	<section class="container ">
		<div class="row ">
			<div class="three_span " id="menu">Menu</div>
				
			<div class="nine_span " id="content">
				<section class="container " id="nested_container">
					<div class="row  nested">
						<div class="three_span ">
							Class : Hash<br>
							Detail : 178 methods
						</div>
						<div class="three_span ">
							Class : Set<br>
							Detail : 176 methods
						</div>
						<div class="three_span ">
							Class : Fixnum<br>
							Detail : 174 methods
						</div>
					</div>
					<div class="row  nested">
						<div class="three_span ">
							Class : Float<br>
							Detail : 174 methods
						</div>
						<div class="three_span ">
							Class : NilClass<br>
							Detail : 175 methods
						</div>
						<div class="three_span ">
							Class : TrueClass<br>
							Detail : 174 methods
						</div>
					</div>
				</section>		
			</div>
		</div>
	</section>
```

![css_grid menu](https://raw.github.com/petrachi/css_grid/master/ressources/readme/menu.png)

--


```erb
	<%= container do %>
		<%= one_col_row :id=>:one_row do %>
			shortcut for row + twelve_span
		<% end %>
	<% end %>
```

```html
	<section class="container ">
		<div class="row " id="one_row">
			<div class="twelve_span ">shortcut for row + twelve_span</div>
		</div>
	</section>
```

![css_grid one_col_row](https://raw.github.com/petrachi/css_grid/master/ressources/readme/one_col_row.png)

--


```erb
	<%= one_col_container :id=>"multi_nested", :nested=>:spans do %>
		<%= four_span :id=>:menu do %>
			Menu
		<% end %>

		<%= eight_span do %>
			<%= two_col_container :collection=>@large_collection do |elt| %>
				<%= two_col_container(:collection=>elt.values){ |val| val } %>
			<% end %>
		<% end %>
	<% end %>
```

```html
	<section class="container " id="multi_nested">
		<div class="row ">
			<div class="twelve_span ">
				<div class="row  nested">
					<div class="four_span " id="mena">Menu</div>
					
					<div class="eight_span ">
						<section class="container ">
							<div class="row  nested">
								<div class="four_span ">
									<section class="container ">
										<div class="row  nested">
											<div class="two_span ">Hash</div>
											<div class="two_span ">178 methods</div>
										</div>
									</section>
								</div>
								<div class="four_span ">
									<section class="container ">
										<div class="row  nested">
											<div class="two_span ">Set</div>
											<div class="two_span ">176 methods</div>
										</div>
									</section>
								</div>
							</div>
							<div class="row  nested">
								<div class="four_span ">
									<section class="container ">
										<div class="row  nested">
											<div class="two_span ">Fixnum</div>
											<div class="two_span ">174 methods</div>
										</div>
									</section>
								</div>
								<div class="four_span ">
									<section class="container ">
										<div class="row  nested">
											<div class="two_span ">Float</div>
											<div class="two_span ">174 methods</div>
										</div>
									</section>
								</div>
							</div>
							<div class="row  nested">
								<div class="four_span ">
									<section class="container ">
										<div class="row  nested">
											<div class="two_span ">NilClass</div>
											<div class="two_span ">175 methods</div>
										</div>
									</section>
								</div>
								<div class="four_span ">
									<section class="container ">
										<div class="row  nested">
											<div class="two_span ">TrueClass</div>
											<div class="two_span ">174 methods</div>
										</div>
									</section>
								</div>
							</div>
						</section>
					</div>
				</div>
			</div>
		</div>
	</section>
```

![css_grid multi_nested](https://raw.github.com/petrachi/css_grid/master/ressources/readme/multi_nested.png)

--

## To Do

I made a constant to personalize created elements to fit a different grid stylesheet.
Today this variable looks like this
```ruby
	GRID_CONFIG = { :classes => { :container => :container,
	                                :row => :row, :nested => :nested,                                                                                                  
	                                :prepend => :prepend, :append => :append,                                                                                              
	                                :one_span => :one_span, :two_span => :two_span, :three_span => :three_span, :four_span => :four_span,                                  
	                                :five_span => :five_span, :six_span => :six_span, :seven_span => :seven_span, :eight_span => :eight_span,                              
	                                :nine_span => :nine_span, :ten_span => :ten_span, :eleven_span => :eleven_span, :twelve_span => :twelve_span },
	                  :elements => {:container => :section,
	                                :row => :div,                                                                                              
	                                :one_span => :div, :two_span => :div, :three_span => :div, :four_span => :div,                                  
	                                :five_span => :div, :six_span => :div, :seven_span => :div, :eight_span => :div,                              
	                                :nine_span => :div, :ten_span => :div, :eleven_span => :div, :twelve_span => :div}
	                }
```

Need to test it with the most commons versions of grid stylesheets (twitter bootstrap for example) and provide correct config variable.

--

Preprend and Append are not fully handled by the GRID_CONFIG constant. Specialy prepend negative values.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
