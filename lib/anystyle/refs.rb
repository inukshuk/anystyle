module AnyStyle
  class Refs
    include StringUtils

    class << self
      def parse(lines, **opts)
        lines.inject(new(**opts)) do |refs, line|
          refs.append line.value, line.label
        end
      end

      def normalize!(lines, max_win_size: 2)
        win = []
        lines.each do |line|
          case line.label
          when 'text'
            win << line
          when 'ref'
            unless win.length == 0 || win.length > max_win_size
              win.each { |tk| tk.label = 'ref' }
            end
            win = []
          when 'blank', 'meta'
            # ignore
          else
            win = []
          end
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
      [
        0.75 * indent_score(indent),
        0.75 * delta_score(delta),
        0.75 * years_score(a, b),
        1.0  * terminal_score(a),
        1.0  * initial_score(a, b),
        0.75 * length_score(a, b),
        0.75 * pages_score(a, b)
      ].reduce(&:+) >= 1
    end

    def indent_score(indent)
      case
      when indent > 0 then 1
      when indent < 0 then -1
      else
        0
      end
    end

    def delta_score(delta = @delta)
      case delta
      when 0 then 1
      when 1 then 0.5
      when 2 then 0
      else
        delta > 5 ? -1 : -0.5
      end
    end

    def years_score(a, b)
      if a.match(/(1[4-9]|2[01])\d\d/)
        if b.match(/(1[4-9]|2[01])\d\d/)
          -1
        else
          if a.match(/(1[4-9]|2[01])\d\d\.$/)
            -0.75
          else
            0.75
          end
        end
      else
        1
      end
    end

    def pages_score(a, b)
      if match_pages?(b) && !match_pages?(a)
        1
      else
        0
      end
    end

    def match_pages?(string)
      !!string.match(/\d+\p{Pd}\d+/)
    end


    def terminal_score(string)
      case string
      when /[,;:&\p{Pd}]$/
        1.5
      when /\((1[4-9]|2[01])\d\d\)\.?$/
        0.5
      when /(\p{^Lu}\.|\])$/
        -1
      else
        0
      end
    end

    def initial_score(a, b)
      case
      when b.match(/^\p{Ll}/) && !b.match(/^(de|v[oa]n)\b/)
        1.5
      when a.match(/\p{L}$/) && b.match(/^\p{L}/)
        1
      when b.match(/^["'”„’‚´«「『‘“`»]/), b.match(/^url|http/i)
        1
      when b.match(/^\[\w+\]/)
        -1
      when b.match(/^\d+\.\s+\p{Lu}/)
        -0.5
      else
        0
      end
    end

    def length_score(a, b)
      case
      when b.length < a.length && b.length < 50
        1
      when (b.length - a.length) > 12
        -0.5
      else
        0
      end
    end

    def join(a, b)
      if a.end_with? '-'
        if a =~ /\p{Ll}-$/ && b =~ /^\p{Ll}/
          "#{a[0...-1]}#{b}"
        else
          "#{a}#{b}"
        end
      else
        "#{a} #{b}"
      end
    end

    def strip(string)
      string = display_chars(string)
      [string.lstrip, indent_depth(string)]
    end

    def indent_depth(string)
      string[/^\s*/].length
    end
  end
end
