#pragma once
#include "CGeom_funcs.h"


struct Triangle {
	Triangle(Point a, Point b, Point c) :a(a), b(b), c(c) {};


	bool is_in_Triangle(Point x);

	bool is_on_Triangle_vertices(Point x);

	bool is_on_Triangle_edges(Point x);

	Point a;
	Point b;
	Point c;
};