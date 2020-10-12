#pragma once
#include <string>
#include <list>


template <typename VertexValue>
struct Vertex
{
	Vertex(int number, std::string color, VertexValue value) : Vertex(number, color), value(value) {};
	Vertex(int number, std::string color) : number(number), color(color), degree(0) {};
	Vertex(int number) : Vertex(number, "blank") {};
	~Vertex() {};
	friend bool operator==(const Vertex<VertexValue>& lhs, const Vertex<VertexValue>& rhs) { return lhs.number == rhs.number; };
	friend std::ostream& operator<<(std::ostream& os, const Vertex<VertexValue>& obj)
	{
		os << obj.number << "	" << obj.color << "	" << obj.value;
		return os;
	}
	//friend std::istream& operator>>(std::istream& is, Vertice& obj)
	//{
	//	// read obj from stream
	//	if ( /* T could not be constructed */)
	//		is.setstate(std::ios::failbit);
	//	return is;
	//}

	int number;
	size_t degree;
	std::string color;
	VertexValue value;
};

