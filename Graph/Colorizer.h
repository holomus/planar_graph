#pragma once
#include <algorithm>
#include <array>
#include "Graph.h"


template <typename VertexValue, typename vertex_iterator>
class Colorizer
{
public:
	Colorizer() {
		colors[0] = "red";
		colors[1] = "blue";
		colors[2] = "orange";
		colors[3] = "green";
		colors[4] = "yellow";
		std::sort(colors.begin(), colors.end());
	}
	void color(Graph<VertexValue, vertex_iterator>& graph) {
		auto end_vertices = graph.get_vertices();
		if (graph.vertice_num() < 5) {
			for (int i = 0; end_vertices.first != end_vertices.second; ++end_vertices.first, ++i) {
				(*end_vertices.first).color = colors[i];
			}
			return;
		}
		/*std::sort(end_vertices.first, end_vertices.second, [](Vertex<VertexValue> left, Vertex<VertexValue> right) {
			return left.degree < right.degree;
		});

		for (auto sub_end = std::next(end_vertices.first, 1); sub_end != end_vertices.second; ++sub_end) {
			for (auto left_vertex = end_vertices.first; left_vertex != sub_end; ++left_vertex) {
				if (graph.adjacent((*sub_end), (*left_vertex))) {

				}
			}
		}*/
		
		auto it = std::find_if(end_vertices.first, end_vertices.second, [](Vertex<VertexValue> v) { return v.degree <= 5; });
		auto subgraph = graph.clone();
		subgraph->remove_vertex(*it);
		if ((*it).degree < 5) {			
			color(*subgraph);
			copy_color(graph, *subgraph);
			color_vertex_by_neihgbours(graph, (*it));
		}
		if ((*it).degree == 5) {
			end_vertices = subgraph->get_vertices();
			
			auto neighbours = subgraph->neighbors((*end_vertices.first));
			while (end_vertices.first != end_vertices.second) {
				for(auto right = std::next(end_vertices.first, 1); right != end_vertices.second; ++right){
					if (subgraph->adjacent((*end_vertices.first), (*right)) == false) {
						Vertex<VertexValue> u = (*end_vertices.first);
						Vertex<VertexValue> v = (*right);
						subgraph->merge(*right, *end_vertices.first);
						color(*subgraph);
						copy_color(graph, *subgraph);
						std::string color = subgraph->get_vertex_color(v);
						graph.set_vertex_color(u, color);
						color_vertex_by_neihgbours(graph, (*it));
						delete subgraph;
						return;
					}
				}
				++end_vertices.first;
			}
			
		}
		delete subgraph;
	}

	bool correctly_colored(Graph<VertexValue, vertex_iterator>& graph) {
		auto end_vertices = graph.get_vertices();
		while (end_vertices.first != end_vertices.second) {
			auto neighbours = graph.neighbors(*end_vertices.first);
			for (auto& neighbour : neighbours) {
				if (neighbour.color == (*end_vertices.first).color || (*end_vertices.first).color == "blank") {
					return false;
				}
			}
			++end_vertices.first;
		}
		return true;
	}

protected:
	void copy_color(Graph<VertexValue, vertex_iterator>& graph, Graph<VertexValue, vertex_iterator>& subgraph) {
		auto graph_ends = graph.get_vertices();
		std::sort(graph_ends.first, graph_ends.second, [](const Vertex<VertexValue>& u, const Vertex<VertexValue>& v) {
			return u.number < v.number;
		});
		auto subgraph_ends = subgraph.get_vertices();
		std::sort(subgraph_ends.first, subgraph_ends.second, [](const Vertex<VertexValue>& u, const Vertex<VertexValue>& v) {
			return u.number < v.number;
		});
		graph_ends = graph.get_vertices();
		subgraph_ends = subgraph.get_vertices();
		while (subgraph_ends.first != subgraph_ends.second) {
			while ((*graph_ends.first).number != (*subgraph_ends.first).number)
				++graph_ends.first;
			(*graph_ends.first).color = (*subgraph_ends.first).color;
			++subgraph_ends.first;
			++graph_ends.first;
		}
	}
	void color_vertex_by_neihgbours(Graph<VertexValue, vertex_iterator>& graph, Vertex<VertexValue>& x) {
		auto neighbours = graph.neighbors(x);

		/*std::sort(neighbours.begin(), neighbours.end(), [](const Vertex<VertexValue>& u, const Vertex<VertexValue>& v) {
			return u.color.compare(v.color) < 0;
		});
		std::string spare;
		for (size_t i = 0; i < neighbours.size(); ++i) {
			if (colors[i] != neighbours[i].color) {
				spare = colors[i];
			}
		}
		if (spare.empty())
			spare = colors[4];

		x.color = spare;*/
		std::string spare;
		for (size_t i = 0; i < colors.size(); ++i) {
			spare = colors[i];
			for (auto& neighbour : neighbours) {
				if (neighbour.color == colors[i])
				{
					spare.clear();
				}
			}
			if (!spare.empty()) {
				x.color = spare;
				return;
			}
		}
	}
	std::array<std::string, 5> colors;
};

