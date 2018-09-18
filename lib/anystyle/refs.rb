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
      score = [
        indent_score(indent),
        delta_score(delta),
        years_score(a, b),
        terminal_score(a, b),
        initial_score(a, b),
        length_score(a, b),
        pages_score(a, b)
      ]
      score.reduce(&:+) >= 1
    end

    def indent_score(indent)
      case
      when indent > 0 then 1.25
      when indent < 0 then -1
      else
        0
      end
    end

    def delta_score(delta = @delta)
      case delta
      when 0 then 1
      when 1 then 0.5
      when 2, 3 then 0
      else
        delta > 6 ? -1 : -0.5
      end
    end

    def years_score(a, b)
      if match_year?(a)
        if match_year?(b)
          case
          when b.length < 18
            1
          when b.length < 25
            0.5
          when b.length > 60
            -0.75
          else
            0
          end
        else
          if a.match(/[\d,] \(?(1[4-9]|2[01])\d\d[a-z]?\)?\.$/)
            -0.5
          else
            1
          end
        end
      else
        1
      end
    end

    def match_year?(string)
      !!string.match(/\b(1[4-9]|2[01])\d\d[a-z]?\b/)
    end

    def pages_score(a, b)
      if match_pages?(a, true)
        -0.25
      else
        if match_pages?(b, false)
          1
        else
          0
        end
      end
    end

    def match_pages?(string, not_years = true)
      m = string.match(/(\d+)\p{Pd}(\d+)|\bpp?\.|\d+\(\d+\)/)
      return false if m.nil?
      return false if not_years && m[1] && match_year?(m[1]) && match_year?(m[2])
      return true
    end

    def terminal_score(a, b)
      case
      when a.match(/https?:\/\/\w+/i)
        -0.25
      when a.match(/[,;:&\p{Pd}]$/), a.match(/\s(et al|pp|pg)\.$/)
        2
      when a.match(/\((1[4-9]|2[01])\d\d\)\.?$/)
        0
      when a.match(/(\p{^Lu}\.|\])$/)
        -1
      when a.match(/\d$/) && b.match(/^\p{Lu}/)
        -0.25
      else
        0
      end
    end

    def initial_score(a, b)
      case
      when b.match(/^\p{Ll}/) && !b.match(/^(de|v[oa]n|v\.)\s/)
        1.5
      when a.match(/\p{L}$/) && b.match(/^\p{L}/)
        1
      when b.match(/^["'”„’‚´«「『‘“`»]/)
        1
      when b.match(/^(url|doi|isbn|vol)\b/i)
        1.5
      when b.match(/^([\p{Pd}_*][\p{Pd}_* ]+|\p{Co})/)
        -1.5
      when b.match(/^\((1[4-9]|2[01])\d\d\)/) && !a.match(/(\p{Lu}|al|others)\.$/)
        -1
      when b.match(/^\p{Lu}[\p{Ll}-]+,?\s\p{Lu}/) && !a.match(/\p{L}$/)
        -0.5
      when match_list?(b)
        if match_list?(a)
          -1.5
        else
          -0.75
        end
      when b.match(/^\p{L}+:/), b.match(/^\p{L}+ \d/)
        0.5
      else
        0
      end
    end

    def match_list?(string)
      string.match(/^(\d{1,3}(\.\s+|\s{2,})\p{L}|\[\p{Alnum}+\])/)
    end

    def length_score(a, b)
      case
      when b.length < a.length
        case
        when b.length < 10
          2.5
        when b.length < 15
          2
        when b.length < 20
          1.75
        when b.length < 25
          1.5
        when b.length < 30
          1
        when b.length < 50
          0.75
        else
          0
        end
      when (b.length - a.length) > 12
        -0.5
      else
        0
      end
    end

    def join(a, b)
      if a =~ /\p{Pd}$/
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
