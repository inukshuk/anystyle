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

  puts "parsing #{file} ..."

  output = AnyStyle.finder.label input
  output.save File.join(dst, "#{File.basename(file, extn)}.ttx"), format: 'txt', tagged: true

  File.write File.join(dst, "#{File.basename(file, extn)}"), output[0].references.join("\n")
end
