require "css_grid/version"
require "css_grid/engine"
require 'css_grid/railtie' if defined?(Rails)

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
    options.map_values! do |value|        
      value.class == Proc ? value.call(@elt) : value 
    end
    
    prepend = if options[:prepend].present? and TWELVE_STRING_INTS_INVERT.has_key? (prepend = options.delete(:prepend)).abs
      if prepend > 0
        "#{ GRID_CONFIG[:classes][:prepend] }_#{ TWELVE_STRING_INTS_INVERT[prepend] }"
      else
        "#{ GRID_CONFIG[:classes][:minus] }_#{ TWELVE_STRING_INTS_INVERT[prepend.abs] }"
      end
    elsif prepend
      warn "WARNING : invalid value for ':prepend'"
    end
    
    append = if options[:append].present? and TWELVE_STRING_INTS_INVERT.has_key? (append = options.delete(:append))
      "#{ GRID_CONFIG[:classes][:append] }_#{ TWELVE_STRING_INTS_INVERT[options.delete :append] }"
    elsif append
      warn "WARNING : invalid value for ':append'"
    end
    
    
    warn "WARNING : argument ':nested' is not supported for '#{ tag }'" if options[:nested].present? and tag != :row
    
    if tag =~ /(one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve)_span$/
      @nested_stack << $1
        
      unstack = true
    else
      warn "WARNING : argument ':prepend' is not supported for '#{ tag }'" if prepend.present?
      warn "WARNING : argument ':append' is not supported for '#{ tag }'" if append.present?
            
      unstack = false
    end
    
    content_class = [GRID_CONFIG[:classes][tag], options.delete(:class), prepend, append].compact
    content_class << GRID_CONFIG[:classes][:nested] if options.delete(:nested)
    options.merge! :class => content_class.join(" ")
                                 
    safe_buffer = content_tag(options.delete(:element) || GRID_CONFIG[:elements][tag], options, &block)
    
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
        @elt = elt
        
        if disable.include? :spans
          capture(elt, &block)
          
        else
          grid("#{ span_width }_span".to_sym, options[:spans].clone) do
            safe_buffer = capture(elt, &block)
            safe_buffer = grid(:row, :nested=>true){ safe_buffer } if nested.include? :spans
            
            safe_buffer
          end
        end
      end
      @elt = nil

      grid(:row, options[:rows].clone){ cols.reduce(:safe_concat) }
    end
    
    safe_buffer = rows.reduce(:safe_concat)
    safe_buffer = grid(:container, options.except!(:spans, :rows)){ safe_buffer } unless disable.delete :container
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
