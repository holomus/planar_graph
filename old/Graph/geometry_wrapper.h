#pragma once
#include "geometry.h"
#include <algorithm>
#include <vector>

struct Point {
	Point(double first, double second, size_t index) : first(first), second(second), index(index) {};
	Point(double first, double second) : Point(first, second, 0) {};
	Point() : Point(0.0, 0.0, 0) {};
	double first;
	double second;
	size_t index;
};

typedef std::pair<Point, Point> Line;

std::vector<Point> make_convex_hull(std::vector<Point>& points);