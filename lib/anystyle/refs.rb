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

    def initialize(max_delta: 15)
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
          if join?(@pending, line, @delta, at - @indent)
            @pending = join @pending, line
          else
            commit pending: line, indent: at
          end
        else
          reset pending: line, indent: at
        end
      when 'blank', 'meta'
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

    def join?(a, b, delta = 0, indent = 0)
      pro = [
        indent > 0,
        delta == 0,
        b.length < 50,
        a.length < 65,
        !!a.match(/[,;:&\p{Pd}]$/),
        !!b.match(/^\p{Ll}/) || !!a.match(/\p{L}$/) && !!b.match(/^\p{L}/)
      ].count(true)

      con = [
        indent < 0,
        delta > 8,
        !!a.match(/\.\]$/),
        a.length > 500,
        (b.length - a.length) > 12,
        !!b.match(/^(\p{Pd}\p{Pd}|\p{Lu}\p{Ll}+, \p{Lu}\.|\[\d)/)
      ].count(true)

      (pro - con) > 1
    end

    def join(a, b)
      if a[-1] == '-'
        if b =~ /^\p{Ll}/
          "#{a[0...-1]}#{b}"
        else
          "#{a}#{b}"
        end
      else
        "#{a} #{b}"
      end
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
