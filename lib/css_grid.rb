require "css_grid/version"
require "css_grid/engine"

module GridHelper
  TWELVE_STRING_INTS = { :one => 1, :two => 2, :three => 3, :four => 4, :five => 5, :six => 6, 
                         :seven => 7, :eight => 8, :nine => 9, :ten => 10, :eleven => 11, :twelve => 12 }
  TWELVE_STRING_INTS_INVERT = TWELVE_STRING_INTS.invert
  
  
  GRID_CONFIG ||= { :classes => Hash.new{ |hash, key| hash[key] = key }, 
                    :elements => Hash.new(:div).merge(:container => :section) }
  
  def initialize *args
    @nested_stack = []
    super
  end
  
  def grid tag, options = {}, &block
    prepend = if options[:prepend].present? 
      if options[:prepend] > 0
        TWELVE_STRING_INTS_INVERT[options.delete :prepend]
      else
        "minus_#{ TWELVE_STRING_INTS_INVERT[options.delete :prepend] }"
      end
    end
    append = TWELVE_STRING_INTS_INVERT[options.delete :append]
    
    warn "WARNING : argument ':nested' is not supported for '#{ tag }'" if options[:nested].present? and tag != :row
    
    if tag =~ /(one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve)_span$/
        @nested_stack << $1
        
        unstack = true
    else
      warn "WARNING : argument ':prepend' is not supported for '#{ tag }'" if prepend.present?
      warn "WARNING : argument ':append' is not supported for '#{ tag }'" if append.present?
            
      unstack = false
    end
    
    content_class = [GRID_CONFIG[:classes][tag], options.delete(:class)]
    content_class << "#{ GRID_CONFIG[:classes][:prepend] }_#{ prepend }" if prepend
    content_class << "#{ GRID_CONFIG[:classes][:append] }_#{ append }" if append
    content_class << GRID_CONFIG[:classes][:nested] if options.delete(:nested)
    
    safe_buffer = content_tag(GRID_CONFIG[:elements][tag], nil, :id => options.delete(:id), :class => content_class.join(" ") , &block)
    
    @nested_stack.pop if unstack
    safe_buffer
  end

  def recollect size, collection
    recollected = []
    0.step(collection.size - 1, size) do |i|
      recollected << collection[i..i + size - 1]
    end
    recollected
  end
  
  def cols_container col_number, options = {}, &block
    options[:rows] ||= {}
    options[:spans] ||= {}
    
    if @nested_stack.present?
      options[:rows].merge!({:nested => true})
      options[:nested_width] ||= TWELVE_STRING_INTS[@nested_stack.last.to_sym]
    end
        
    disable = [*options.delete(:disable)]
    nested = [*options.delete(:nested)]
    
    options[:rows].merge!({:nested => true}) if nested.delete :container    
    
    collection_length = TWELVE_STRING_INTS[col_number]
    span_width = @span_width || TWELVE_STRING_INTS_INVERT[(options.delete(:nested_width) || 12) / (collection_length + (options[:spans][:prepend] || 0) + (options[:spans][:append] || 0))]
    
    rows = recollect(collection_length, options.delete(:collection) || [1]).map do |collection_mini|
      cols = collection_mini.map do |elt|

        if disable.include? :spans
          capture(elt, &block)
          
        else
          spans_options = options[:spans].clone
          spans_options[:id] = spans_options[:id].call elt if spans_options[:id].class == Proc
          spans_options[:class] = spans_options[:class].call elt if spans_options[:class].class == Proc
          
          grid("#{ span_width }_span".to_sym, spans_options) do
            safe_buffer = capture(elt, &block)
            safe_buffer = grid(:row, :nested=>true){ safe_buffer } if nested.include? :spans
            
            safe_buffer
          end
        end
      end
      
      rows_options = options[:rows].clone
      rows_options[:id] = rows_options[:id].call elt if rows_options[:id].class == Proc
      rows_options[:class] = rows_options[:class].call elt if rows_options[:class].class == Proc
      
      grid(:row, rows_options){ cols.reduce(:safe_concat) }
    end
    
    safe_buffer = rows.reduce(:safe_concat)
    safe_buffer = grid(:container, :id=>options.delete(:id), :class=>options.delete(:class)){ safe_buffer } unless disable.delete :container
    safe_buffer
  end
  
  def spans_container span_width, options = {}, &block
    if @nested_stack.present?
      options[:nested_width] ||= TWELVE_STRING_INTS[@nested_stack.last.to_sym]
    end
    
    @span_width = span_width
    col_number = TWELVE_STRING_INTS_INVERT[(options.delete(:nested_width) || 12) / TWELVE_STRING_INTS[span_width]]
    
    safe_buffer = cols_container col_number, options, &block
    
    @span_width = nil
    safe_buffer
  end
  
  
  def one_col_row options = {}, &block
    cols_container :one, options.merge(:disable=>:container, :rows=>{:id=>options.delete(:id), :class=>options.delete(:class)}), &block
  end
  
  TWELVE_FOR_REGEXP = TWELVE_STRING_INTS.keys.join '|'
  def method_missing method_name, *args, &block
    case method_name.to_sym
    when /^(container|row|(#{ TWELVE_FOR_REGEXP })_span)$/
      self.grid($1.to_sym, *args, &block)
    when /^(#{ TWELVE_FOR_REGEXP })_cols?_container$/
      self.cols_container($1.to_sym, *args, &block)
    when /^(#{ TWELVE_FOR_REGEXP })_spans?_container$/
      self.spans_container($1.to_sym, *args, &block)
    else super
    end
  end
  
  def respond_to? method_name, include_private = false
    case method_name.to_s
    when  /^(container|row|(#{ TWELVE_FOR_REGEXP })_span)$/, 
          /^(#{ TWELVE_FOR_REGEXP })_cols?_container$/,
          /^(#{ TWELVE_FOR_REGEXP })_spans?_container$/
      true
    else super
    end
  end

end
