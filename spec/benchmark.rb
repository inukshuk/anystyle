require 'anystyle'
require 'benchmark'
include Benchmark

data = <<-END_REFERENCES
<author> A. Cau, R. Kuiper, and W.-P. de Roever. </author> <title> Formalising Dijkstra's development strategy within Stark's formalism. </title> <editor> In C. B. Jones, R. C. Shaw, and T. Denvir, editors, </editor> <container-title> Proc. 5th. BCS-FACS Refinement Workshop, </container-title> <date> 1992. </date>
<author> M. Kitsuregawa, H. Tanaka, and T. Moto-oka. </author> <title> Application of hash to data base machine and its architecture. </title> <journal> New Generation Computing, </journal> <volume> 1(1), </volume> <date> 1983. </date>
<author> Alexander Vrchoticky. </author> <title> Modula/R language definition. </title> <tech> Technical Report TU Wien rr-02-92, version 2.0, </tech> <institution> Dept. for Real-Time Systems, Technical University of Vienna, </institution> <date> May 1993. </date>
<author> Marc Shapiro and Susan Horwitz. </author> <title> Fast and accurate flow-insensitive points-to analysis. </title> <container-title> In Proceedings of the 24th Annual ACM Symposium on Principles of Programming Languages, </container-title> <date> January 1997. </date>
<author> W. Landi and B. G. Ryder. </author> <title> Aliasing with and without pointers: A problem taxonomy. </title> <institution> Center for Computer Aids for Industrial Productivity </institution> <tech> Technical Report CAIP-TR-125, </tech> <institution> Rutgers University, </institution> <date> September 1990. </date>
<author> W. H. Enright. </author> <title> Improving the efficiency of matrix operations in the numerical solution of stiff ordinary differential equations. </title> <journal> ACM Trans. Math. Softw., </journal> <volume> 4(2), </volume> <pages> 127-136, </pages> <date> June 1978. </date>
<author> Gmytrasiewicz, P. J., Durfee, E. H., & Wehe, D. K. </author> <date> (1991a). </date> <title> A decision theoretic approach to coordinating multiagent interaction. </title> <container-title> In Proceedings of the Twelfth International Joint Conference on Artificial Intelligence, </container-title> <pages> pp. 62-68 </pages> <location> Sydney, Australia. </location>
<author> A. Bookstein and S. T. Klein, </author> <title> Detecting content-bearing words by serial clustering, </title> <container-title> Proceedings of the Nineteenth Annual International ACM SIGIR Conference on Research and Development in Information Retrieval, </container-title> <pages> pp. 319327, </pages> <date> 1995. </date>
<author> U. Dayal, H. Garcia-Molina, M. Hsu, B. Kao, and M.- C. Shan. </author> <title> Third generation TP monitors: A database challenge. </title> <container-title> In ACM SIGMOD Conference on Management of Data, </container-title> <pages> pages 393-397, </pages> <location> Washington, D. C., </location> <date> May 1993. </date>
<author> C. Qiao and R. Melhem, </author> <title> "Reducing Communication Latency with Path Multiplexing in Optically Interconnected Multiprocessor Systems", </title> <container-title> Proc. of HPCA-1, </container-title> <date> 1995. </date>
END_REFERENCES

data = data * 100

data = data.split("\n")
parser = AnyStyle.parser

n, k = 100, 5

f = []
g = []

Benchmark.benchmark((" "*15) + CAPTION, 7, FORMAT, '%14s:' % 'sum(f)', '%14s:' % 'sum(g)') do |b|
	1.step(n,k) do |i|

		input = data[0,i]
		f << b.report('%14s:' % "f(#{i})") do
			input.each { |line| parser.prepare(line, true) }
		end

		input = input.join("\n")
		g << b.report('%14s:' % "g(#{i})") do
			parser.prepare(input, true)
		end

		[f.reduce(:+), g.reduce(:+)]
	end

end

require 'gnuplot'

f = f.map(&:total)
g = g.map(&:total)

x = 1.step(n,k).to_a

Gnuplot.open do |gp|
	Gnuplot::Plot.new(gp) do |plot|
		plot.title 'AnyStyle Parser Benchmark'
		plot.ylabel 't'
		plot.xlabel 'n'

		plot.data << Gnuplot::DataSet.new([x,f]) do |ds|
      ds.with = 'linespoints'
      ds.title = 'f'
    end

    plot.data << Gnuplot::DataSet.new([x,g]) do |ds|
      ds.with = 'linespoints'
      ds.title = 'g'
    end

	end
end
