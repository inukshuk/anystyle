# -*- encoding: utf-8 -*-

module Anystyle
  module Parser

    class Feature

      @dict = Dictionary.instance
      @instances = []

      class << self

        attr_reader :dict, :instances

        def define(name, &block)
          instances << new(name, block)
        end

        def undefine(name)
          instances.reject! { |f| f.name == name }
        end

      end

      attr_accessor :name, :matcher

      def initialize(name, matcher)
        @name, @matcher = name, matcher
      end

      def match(*arguments)
        matcher.call(*arguments)
      end

    end


    # Is the the last character upper-/lowercase, numeric or something else?
    # Returns A, a, 0 or the last character itself.
    Feature.define :last_character do |token, stripped, sequence, offset|
      case char = token.split(//)[-1]
      when /^[[:upper:]]$/
        :upper
      when /^[[:lower:]]$/
        :lower
      when /^\d$/
        :numeric
      else
        char
      end
    end

    # Sequences of the first four characters
    Feature.define :first do |token, stripped, sequence, offset|
      c = token.split(//)[0,4]
      (0..3).map { |i| c[0..i].join }
    end

    # Sequences of the last four characters
    Feature.define :last do |token, stripped, sequence, offset|
      c = token.split(//).reverse[0,4]
      (0..3).map { |i| c[0..i].reverse.join }
    end

    Feature.define :stripped_lowercase do |token, stripped, sequence, offset|
      stripped.empty? ? :EMPTY : stripped.downcase
    end

    Feature.define :capitalization do |token, stripped, sequence, offset|
      case stripped
      when /^[[:upper:]]$/
        :single
      when /^[[:upper:]][[:lower:]]/
        :initial
      when /^[[:upper:]]+$/
        :all
      else
        :other
      end
    end

    Feature.define :numbers do |token, stripped, sequence, offset|
      case token
      when /\d\(\d+([—–-]\d+)?\)/
        :volume
      when /^\(\d{4}\)[^[:alnum:]]*$/, /^(1\d{3}|20\d{2})[\.,;:]?$/
        :year
      when /\d{4}\s*[—–-]+\s*\d{4}/
        :'year-range'
      when /\d+\s*[—–-]+\s*\d+/, /^[^[:alnum:]]*pp?\.\d*[^[:alnum:]]*$/, /^((pp?|s)\.?|pages?)$/i
        :page
      when /^\d$/
        :single
      when /^\d{2}$/
        :double
      when /^\d{3}$/
        :triple
      when /^\d+$/
        :digits
      when /^\d+[\d-]+$/
        :serial
      when /^-\d+$/
        :negative
      when /\d+(th|st|nd|rd)[^[:alnum:]]*/i
        :ordinal
      when /\d/
        :numeric
      else
        :none
      end
    end

    Feature.define :dictionary do |token, stripped, sequence, offset|
      c = Feature.dict[stripped.downcase]
      f = Dictionary.keys.map do |k|
        c & Dictionary.code[k] > 0 ? k : ['no',k].join('-').to_sym
      end
      f.unshift(c)
    end

    # TODO sequence features should be called just once per sequence
    # TODO improve / disambiguate edition
    Feature.define :editors do |token, stripped, sequence, offest|
      sequence.any? { |t| t =~ /^(ed|editor|editors|eds|edited|hrsg)$/i } ? :editors : :'no-editors'
    end

    # TODO Translated

    Feature.define :location do |token, stripped, sequence, offset|
      ((offset.to_f / sequence.length) * 10).round
    end

    Feature.define :punctuation do |token, stripped, sequence, offset|
      case token
      when /^["'”’´‘“`]/
        :quote
      when /["'”’´‘“`][!\?\.]$/
        :'terminal-unquote'
      when /["'”’´‘“`][,;:-]$/
        :'internal-unquote'
      when /["'”’´‘“`]$/
        :unquote
      when /^[\[\{].*[\}\]][!\?\.,;:-]?$/
        :braces
      when /^<.*>[!\?\.,;:-]?$/
        :tags
      when /^[\(].*[\)][!\?\.]$/
        :'terminal-parens'
      when /^\(.*\)[,;:-]$/
        :'internal-parens'
      when /^\(.*\)$/
        :parens
      when /^[\[\{]/
        :'opening-brace'
      when /[\}\]][!\?\.,;:-]?$/
        :'closing-brace'
      when /^</
        :'opening-tag'
      when />[!\?\.,;:-]?$/
        :'closing-tag'
      when /^\(/
        :'opening-parens'
      when /\)[,;:-]$/
        :'internal-closing-parens'
      when /^\)$/
        :'closing-parens'
      when /[,;:-]$/
        :internal
      when /[!\?\."']$/
        :terminal
      when /^\d{2,5}\(\d{2,5}\).?$/
        :volume
      when /-+/
        :hyphen
      else
        :others
      end
    end


    Feature.define :type do |token, stripped, sequence, offset|
      s = sequence.join(' ')
      case
      when s =~ /dissertation abstract/i
        :dissertaion
      when s =~ /proceeding/i
        :proceedings
      when stripped =~ /^in$/i && sequence[offset+1].to_s =~ /^[[:upper:]]/ && sequence[offset-1].to_s =~ /["'”’´‘“`\.;,]$/
        :collection
      else
        :other
      end
    end

    Feature.define :reference do |token, stripped, sequence, offset|
      case token
      when /retrieved/i
        :retrieved
      when /isbn/i
        :isbn
      when /^doi:/i
        :doi
      when /^url|http|www\.[\w\.]+/i
        :url
      else
        :none
      end
    end

  end
end
