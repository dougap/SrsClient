class NameMultiValuePair
  @namep
  @valuep

  def initialize(name, value = {})
    @namep = name
    @valuep = value
  end
end

class NameValuePair
  @namep
  @valuep

  def initialize(name, value)
    @namep = name
    @valuep = value
  end
end

class APQL
  @terms
  @ordinal
  @count
  @fieldsp
  @groupby
  @orderby

  def to_s

    if @ordinal then
      if !@ordinal.is_a?(Integer)
        raise 'Ordinal must be an integer.'
      end
    else
      @ordinal = 0
    end

    if @count then
      if !@count.is_a?(Integer)
        raise 'Count must be an integer.'
      end
    else
      @count = 10
    end

    s = "select top(#{@ordinal}, #{@count}) * from system where "

    defined?(needsand) or needsand = false

    if @terms && !@terms.is_a?(String)
      raise 'Terms must be a string.'
    end

    if @terms
      s << "terms('#{@terms}')"
      needsand = true
    end

    if @fieldsp

     if !@fieldsp.is_a?(Array)
        raise 'Fields must be an array of NameMultiValuePair.'
     end

      if needsand==true
        s<<" AND "
      end

      s << "filters('"

     defined?(needsfieldand) or needsfieldand = false

      @fieldsp.each do |fieldp|

        if !fieldp.is_a?(NameMultiValuePair)
          raise 'Field must be a NameMultiValuePair.'
        end

        if !fieldp.instance_variable_get(:@valuep).is_a?(Array)
          raise 'Value must be an Array Of NameMultiValuePair.'
        end

        if needsfieldand==true
          s<<" AND "
        end

        needsfieldand = true

        s<< fieldp.instance_variable_get(:@namep)
        s<< "=("

        defined?(needsvaluecomma) or needsvaluecomma = false

        fieldvalue = fieldp.instance_variable_get(:@valuep)

        fieldvalue.each do |myvalue|

          if !myvalue.is_a?(String)
            raise 'Field value must be a String.'
          end

          if needsvaluecomma==true
            s<<", "
          end

          needsvaluecomma = true
          s<< myvalue
        end

        s<< ")"
      end
      s<<"') "
    end

    if @groupby
      if !@groupby.is_a?(Array)
        raise 'Groupby must be an array of String.'
      end

      s<< " GROUP BY "

      defined?(needsgroupbycomma) or needsgroupbycomma = false

      @groupby.each do |mygroup|
        if !mygroup.is_a?(String)
          raise 'Group must be a String.'
        end

        if needsgroupbycomma==true
          s<<", "
        end

        s<< mygroup

        needsgroupbycomma = true
      end

    end

    if @orderby
      if !@orderby.is_a?(Array)
        raise 'Orderby must be an array of NameValuePair.'
      end

      s<< " ORDER BY "

      defined?(needsorderbycomma) or needsorderbycomma = false

      @orderby.each do |myorder|
        if !myorder.is_a?(NameValuePair)
          raise 'Order must be a NameValuePair.'
        end

        if needsorderbycomma==true
          s<<", "
        end

        s<< myorder.instance_variable_get(:@namep) + " " + myorder.instance_variable_get(:@valuep)

        needsorderbycomma = true
      end

    end

    return s
  end

  def initialize(ordinal, count, terms, fields = {}, groupby = {}, orderby = {})
    @ordinal = ordinal
    @count = count
    @fieldsp = fields
    @groupby = groupby
    @orderby = orderby
    @terms = terms
  end
end