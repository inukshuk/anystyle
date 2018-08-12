module AnyStyle
  class Refs
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
        indent_score(indent),
        delta_score(delta),
        years_score(a, b),
        terminal_score(a),
        initial_score(a, b),
        length_score(a, b),
        pages_score(a, b)
      ].reduce(&:+) > 1
    end

    def indent_score(idt)
      (idt > 0) ? 1 : (idt < 0) ? -1 : 0
    end

    def delta_score(dta)
      (dta == 0) ? 1 : (dta > 5) ? -1 : 0
    end

    def years_score(a, b)
      return -1 if match_year?(a) && match_year?(b)
      return  1
    end

    def pages_score(a, b)
      return 1 if match_pages?(b) && !match_pages?(a)
      return 0
    end

    def terminal_score(a)
      return -1 if a.match(/(\p{^Lu}\.|\])$/)
      return  1 if a.match(/[,;:&\p{Pd}]$/)
      return  0
    end

    def initial_score(a, b)
      return  1 if b.match(/^\p{Ll}/) && !b.match(/^(de|v[oa]n)\b/)
      return  1 if a.match(/\p{L}$/) && b.match(/^\p{L}/)
      return  1 if b.match(/^["']/)
      return -1 if b.match(/^\[\d/)
      #return -1 if b.match(/^(\p{Pd}\p{Pd}|\p{Lu}\p{Ll}+, \p{Lu}\p{Ll}*[\.;])/)
      return  0
    end

    def length_score(a, b)
      return  1 if b.length < a.length && b.length < 50
      return -1 if (b.length - a.length) > 12
      return  0
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

    def match_year?(string)
      !!string.match(/(1[4-9]|2[01])\d\d/)
    end

    def match_pages?(string)
      !!string.match(/\d+\p{Pd}\d+/)
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
