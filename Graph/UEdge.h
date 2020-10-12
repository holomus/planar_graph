#pragma once
#include "Edge.h"

template <typename VertexValue>
struct UEdge : public Edge<VertexValue>
{
	UEdge(const Vertex<VertexValue>& u, const Vertex<VertexValue>& v) : Edge<VertexValue>(u, v) {};
	friend bool operator==(const UEdge& lhs, const UEdge& rhs) { return Edge::operator==(lhs, rhs) || Edge::operator==(rhs, lhs); };
};

