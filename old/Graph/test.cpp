#include "GraphGen.h"
#include "Colorizer.h"
#include <iostream>

int main() {
	GraphGen<int, vertex_iterator<int>> gen;
	Colorizer<int, vertex_iterator<int>> col;

	/*AdjacencyMatrix<int> graph = gen.generate_planar_graph(10);
	

	gen.save(graph);

	col.color(graph);

	gen.save(graph);*/

	for (int i = 0; i < 10000; ++i) {
		auto graph = gen.generate_planar_graph(10);
		/*std::cout << graph << std::endl;*/
		col.color(graph);
		/*std::cout << "Colored\n";*/
		if (!col.correctly_colored(graph)) {
			/*std::cout << "colored incorrectly\n";*/
			gen.save(graph);
			break;
		}
		/*std::cout << "colored correctly\n";*/
	}

	/*AdjacencyMatrix<int> graph(1);

	std::ifstream input("inGraph.txt");
	input >> graph;
	col.color(graph);
	gen.save(graph);
	std::cout << "Colored\n";
	if (!col.correctly_colored(graph))
		std::cout << "colored incorrectly\n";*/

	return 0;
}