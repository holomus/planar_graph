#pragma once
#include "Vertex.h"

template <typename VertexValue>
struct Edge
{
	Edge(const Vertex<VertexValue>& u, const Vertex<VertexValue>& v) :source(u), target(v) {};
	friend bool operator==(const Edge& lhs, const Edge& rhs) { return lhs.source == rhs.source && lhs.target == rhs.target; };
	const Vertex<VertexValue>& source;
	const Vertex<VertexValue>& target;
};

