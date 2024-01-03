#pragma once
#include "Vertex.h"
#include <vector>
#include "Edge.h"


template <typename VertexValue, typename vertex_iterator>
class Graph
{
public:
	//tests whether there is an edge from the vertex x to the vertex y
	virtual bool adjacent(const Vertex<VertexValue> x, const Vertex<VertexValue> y) = 0;

	//lists all vertices y such that there is an edge from the vertex x to the vertex y;
	virtual std::vector<Vertex<VertexValue>> neighbors(const Vertex<VertexValue> x) = 0;

	//adds the vertex x, if it is not there; return true if successful
	virtual void add_vertex(const Vertex<VertexValue>& x) = 0;

	//removes the vertex x, if it is there; return true if successful
	virtual void remove_vertex(const Vertex<VertexValue>& x) = 0;

	//adds the edge from the vertex x to the vertex y, if it is not there;
	virtual void add_edge(Vertex<VertexValue> x, const Vertex<VertexValue> y) = 0;

	//removes the edge from the vertex x to the vertex y, if it is there;
	virtual void remove_edge(Vertex<VertexValue>& x, const Vertex<VertexValue>& y) = 0;

	virtual std::string get_vertex_color(const Vertex<VertexValue>& x) = 0;

	virtual void set_vertex_color(Vertex<VertexValue>& x, std::string color) = 0;
	
	//returns the value associated with the vertex x;
	virtual VertexValue get_vertex_value(const Vertex<VertexValue>& x) = 0;

	//sets the value associated with the vertex x to v.
	virtual void set_vertex_value(Vertex<VertexValue>& x, VertexValue& value) = 0;

	virtual std::pair<vertex_iterator, vertex_iterator> get_vertices() = 0;

	virtual size_t vertice_num() = 0;

	virtual void merge(Vertex<VertexValue>& x, Vertex<VertexValue>& y) = 0;

	virtual Graph* clone() = 0;
	//returns the value associated with the edge (x, y);
	//get_edge_value();

	//sets the value associated with the edge(x, y) to v.
	//set_edge_value(value);
};









//#include <vector>
//#include "Vertice.h"
//#include "boost/graph/adjacency_list.hpp"
//#include "boost/graph/adjacency_matrix.hpp"
//
//using namespace boost;
//
//typedef property<vertex_index_t, int, 
//		property<vertex_color_t, std::string, 
//		property<vertex_degree_t, int>>> VertexProperty;
//
//typedef adjacency_list<setS, vecS, undirectedS, VertexProperty> AdjacencyList;
//typedef adjacency_matrix<setS, vecS, undirectedS, VertexProperty> AdjacencyMatrix;
//
//
//class Graph
//{
//public:
//	Graph(int vertice_num) :list(vertice_num), matrix(vertice_num) {};
//	~Graph() {};
//	
//	size_t num_vertices() {
//		return boost::num_vertices(matrix);
//	}
//	
//	std::pair<bool, bool>  add_edge(int u, int v) {
//		return std::pair<bool, bool>(
//				boost::add_edge(u, v, list	).second,
//				boost::add_edge(u, v, matrix).second);
//	};
//
//protected:
//	AdjacencyList list;
//	AdjacencyMatrix matrix;
//};

