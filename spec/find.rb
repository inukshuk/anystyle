require 'bundler'
begin
  Bundler.setup
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

$:.unshift(File.join(File.dirname(__FILE__), '../lib'))
require 'anystyle'

src = ARGV[0]
dst = "#{(ARGV[1] || '.')}".untaint

if File.directory?(src)
  src = Dir["#{src}/*.{txt,ttx,pdf}"].map(&:untaint)
else
  src = [src.dup.untaint]
end

src.each do |input|
  file = File.basename(input)
  extn = File.extname(input)
  base = File.basename(input, extn)

  print "Parsing #{file} ... "

  output = AnyStyle.finder.label input
  output.save File.join(dst, "#{base}.ttx"), format: 'txt', tagged: true

  refs = output[0].references
  if refs.length > 0
    puts "#{refs.length} references found ..."
    refs = refs.join("\n")
    File.write File.join(dst, base), refs
    File.write File.join(dst, "#{base}.xml"),
      AnyStyle.parser.label(refs).to_xml(indent: 2).to_s
  else
    puts "no references found."
  end
end
