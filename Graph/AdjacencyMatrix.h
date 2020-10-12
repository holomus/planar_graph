#pragma once
#include "Graph.h"
#include <ios>

template <typename VertexValue>
using vertex_iterator = typename std::vector<Vertex<VertexValue>>::iterator;


template <typename VertexValue>
class AdjacencyMatrix : public Graph<VertexValue, vertex_iterator<VertexValue>> {
public:
	AdjacencyMatrix(int num_vertices) : vertices(num_vertices, Vertex<VertexValue>(0)), matrix(num_vertices, std::vector<int>(num_vertices, 0)) {
		int i = 0;
		for (auto& vertice : vertices) {
			vertice.number = i++;
		}
	};

	

	bool adjacent(const Vertex<VertexValue> x, const Vertex<VertexValue> y) override {
		size_t index_x = find_index(x);
		size_t index_y = find_index(y);
		return matrix[index_x][index_y] != 0;
	}
	
	std::vector<Vertex<VertexValue>> neighbors(const Vertex<VertexValue> x) {
		std::vector<Vertex<VertexValue>> vec;
		size_t index = find_index(x);
		for (size_t i = 0; i < vertices.size(); ++i) {
			if (matrix[index][i] != 0)
				vec.push_back(Vertex<VertexValue>(vertices[i]));
		}
		return vec;
	}

	void add_vertex(const Vertex<VertexValue>& x) override {
		for (auto& row : matrix) {
			row.push_back(0);
		}
		matrix.push_back(std::vector<int>(matrix.size() + 1, 0));
		vertices.push_back(x);
		vertices.back().number = vertices.at(vertices.size() - 2).number + 1;
	}

	void remove_vertex(const Vertex<VertexValue>& x) override {
		size_t index = find_index(x);
		for (auto& row : matrix) {
			row.erase(std::next(row.begin(), index));
		}
		matrix.erase(std::next(matrix.begin(), index));
		vertices.erase(std::next(vertices.begin(), index));
		auto vertices_it = vertices.begin();
		for (auto matrix_start = matrix.begin(); matrix_start != matrix.end(); ++matrix_start, ++vertices_it) {
				(*vertices_it).degree = std::count_if((*matrix_start).begin(), (*matrix_start).end(), [](int i) { return i != 0; });
		}
	}

	void add_edge(Vertex<VertexValue> x, const Vertex<VertexValue> y) override {
		size_t index_x = find_index(x);
		size_t index_y = find_index(y);
		vertices[index_x].degree = vertices[index_x].degree - 1 * matrix[index_x][index_y];
		matrix[index_x][index_y] = 1;
		++vertices[index_x].degree;
	}

	void remove_edge(Vertex<VertexValue>& x, const Vertex<VertexValue>& y) override {
		size_t index_x = find_index(x);
		size_t index_y = find_index(y);
		vertices[index_x].degree = vertices[index_x].degree - 1 *(1 - matrix[index_x][index_y]);
		matrix[index_x][index_y] = 0;
		--vertices[index_x].degree;
	}

	std::string get_vertex_color(const Vertex<VertexValue>& x) override {
		size_t index = find_index(x);
		return vertices[index].color;
	}

	void set_vertex_color(Vertex<VertexValue>& x, std::string color) override {
		size_t index = find_index(x);
		vertices[index].color = color;
	}

	VertexValue get_vertex_value(const Vertex<VertexValue>& x) override {
		size_t index = find_index(x);
		return vertices[index].value;
	}

	void set_vertex_value(Vertex<VertexValue>& x, VertexValue& value) override {
		size_t index = find_index(x);
		vertices[index].value = value;
	}

	size_t vertice_num() override {
		return vertices.size();
	}

	std::pair<vertex_iterator<VertexValue>, vertex_iterator<VertexValue>> get_vertices() {
		return std::make_pair(vertices.begin(), vertices.end());
	}

	void merge(Vertex<VertexValue>& x, Vertex<VertexValue>& y) {
		size_t index_x = find_index(x);
		size_t index_y = find_index(y);
		for (size_t i = 0; i < matrix[index_x].size(); ++i) {
			matrix[index_x][i] = std::max(matrix[index_x][i], matrix[index_y][i]);
			matrix[i][index_x] = std::max(matrix[i][index_x], matrix[i][index_y]);
		}
		matrix[index_x][index_x] = 0;
		remove_vertex(y);
	}

	Graph<VertexValue, vertex_iterator<VertexValue>>* clone() {
		return new AdjacencyMatrix<VertexValue>(*this);
	}

	friend std::ostream& operator<<(std::ostream& os, const AdjacencyMatrix<VertexValue>& graph)
	{
		for (auto& vertex : graph.vertices)
			os << vertex << std::endl;

		for (auto& row : graph.matrix) {
			for (auto& elem : row) {
				os << elem << " ";
			}
			os << std::endl;
		}
		return os;
	}

	friend std::istream& operator>>(std::istream& is, AdjacencyMatrix<VertexValue>& graph)
	{
		size_t vertices_num = 0;
		is >> vertices_num;
		AdjacencyMatrix<VertexValue> tmpGr(vertices_num);
		int value;
		for (size_t i = 0; i < vertices_num; ++i) {
			for (size_t j = 0; j < vertices_num; ++j) {
				if(is >> value && value == 1)
					tmpGr.add_edge(i, j);
			}
		}
		graph = tmpGr;
		//hope everything is good
		//too lazy to do this
		return is;
	}

protected:
	size_t find_index(const Vertex<VertexValue>& x) {
		for (size_t i = 0; i < vertices.size(); ++i) {
			if (x == vertices[i])
				return i;
		}
		return -1;
	}

private:
	std::vector<std::vector<int>>  matrix;
	std::vector<Vertex<VertexValue>> vertices;
};

