require "css_grid/version"
require "css_grid/engine"

module GridHelper
  TWELVE_STRING_INTS = {:one => 1, :two => 2, :three => 3, :four => 4, :five => 5, :six => 6, :seven => 7, :eight => 8, :nine => 9, :ten => 10, :evelen => 11, :twelve => 12}

  def grid element_class, options = Hash.new, &block
    html_id, html_class, offset = options.delete_many :id, :class, :offset
    offset = TWELVE_STRING_INTS.invert[offset] if offset.class == Fixnum
    
    content_tag(:div, nil, :id => html_id, :class => "#{ element_class } #{ html_class } #{ "offset_#{ offset }" if offset }" , &block)
  end

  def col col_number, options = Hash.new, &block
    html_id, html_class, collection = options.delete_many :id, :class, :collection
    collection ||= [1]

    collection_length = TWELVE_STRING_INTS[col_number.to_sym]
    span_width = TWELVE_STRING_INTS.invert[ 12 / collection_length ]

    raise ArgumentError, "collection.size must be <= #{ collection_length }" if collection.size > collection_length

    cols = collection.map do |elt|
      eval %{
        #{ span_width }_span do
          capture(elt, &block)
        end }
    end

    row :id => html_id, :class => html_class do
      cols.inject(ActiveSupport::SafeBuffer.new){ |buffer, col| buffer.safe_concat(col) }
    end
  end

  def recollect size, collection
    recollected = Array.new
    0.step(collection.size - 1, size) do |i|
      recollected << collection[i..i + size - 1]
    end
    recollected
  end

  def rows col_number, options = Hash.new, &block
    html_id, html_class, collection = options.delete_many :id, :class, :collection    
    collection ||= [1]

    recollection_size = TWELVE_STRING_INTS[col_number.to_sym]

    rows = recollect(recollection_size, collection).map do |collection_mini|
      col col_number, {:collection => collection_mini}, &block
    end

    container :id => html_id, :class => html_class do
      rows.inject(ActiveSupport::SafeBuffer.new){ |buffer, col| buffer.safe_concat(col) }
    end
  end
  
  
  def method_missing method_name, *args, &block
    case method_name.to_s
    when /^(container|row|(one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve)_span)$/
      self.grid($1, *args, &block)
    when /^(one|two|three|four|six|twelve)_col_row$/
      self.col($1, *args, &block)
    when /^(one|two|three|four|six|twelve)_col_container$/
      self.rows($1, *args, &block)
    else super
    end
  end
  
  def respond_to? method_name, include_private = false
    case method_name.to_s
    when  /^(container|row|(one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve)_span)$/, 
          /^(one|two|three|four|six|twelve)_col_row$/,
          /^(one|two|three|four|six|twelve)_col_container$/
      true
    else super
    end
  end
end
