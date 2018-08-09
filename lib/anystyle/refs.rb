module AnyStyle
  class Refs
    class << self
      def parse(lines, **opts)
        lines.inject(new(**opts)) do |refs, line|
          refs.append line.value, line.label
        end
      end
    end

    attr_reader :all, :max_delta

    def initialize(max_delta: 10)
      @all, @max_delta = [], max_delta
      reset
    end

    def reset(delta: 0, indent: 0, pending: nil)
      @delta, @indent, @pending = delta, indent, pending
    end

    def commit(**opts)
      @all << @pending
      reset(**opts)
    end

    def to_a
      commit if pending?
      @all
    end

    def pending?
      !@pending.nil?
    end

    def append(line, label = 'ref')
      case label
      when 'ref'
        (line, at) = strip line

        if pending?
          if join?(@pending, line, at - @indent)
            @pending = join @pending, line
          else
            commit pending: line, indent: at
          end
        else
          reset pending: line, indent: at
        end
      when 'meta'
        # skip
      when 'blank'
        if pending?
          if @delta > max_delta
            commit
          else
            @delta += 1
          end
        end
      else
        commit if pending?
      end

      self
    end

    def join?(a, b, indent = 0, delta = @delta)
      ay = match_year?(a)
      by = match_year?(b)

      pro = [
        indent > 0,
        delta == 0,
        b.length < 50 || a.length < 65,
        ay ^ by,
        !!a.match(/[,;:&\p{Pd}]$/),
        !!b.match(/^\p{Ll}/) || !!a.match(/\p{L}$/) && !!b.match(/^\p{L}/)
      ].count(true)

      con = [
        indent < 0,
        delta > 5,
        !!a.match(/[\.\]]$/),
        a.length > 500,
        (b.length - a.length) > 12,
        ay && by,
        !!b.match(/^(\p{Pd}\p{Pd}|\p{Lu}\p{Ll}+, \p{Lu}\.|\[\d)/)
      ].count(true)

      (pro - con) > 1
    end

    def join(a, b)
      if a =~ /\p{Ll}-$/
        if b =~ /^\p{Ll}/
          "#{a[0...-1]}#{b}"
        else
          "#{a}#{b}"
        end
      else
        "#{a} #{b}"
      end
    end

    def match_year?(string)
      !!string.match(/(1[4-9]|2[01])\d\d/)
    end

    def strip(string)
      string = StringUtils.display_chars(string)
      [string.strip, indent_depth(string)]
    end

    def indent_depth(string)
      string[/^\s*/].length
    end
  end
end
