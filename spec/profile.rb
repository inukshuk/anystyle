require 'anystyle'
require 'tempfile'
require 'ruby-prof'

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


parser = AnyStyle.parser


result = RubyProf.profile do
	parser.prepare(data, true)
end

dot = Tempfile.new('dot')
RubyProf::DotPrinter.new(result).print(dot, :min_percent => 5)
dot.close

system "dot -Tpng -oprofile.png #{dot.path}"

# dot.unlink
