#include "CGeom_funcs.h"

double distance(Point a, Point b)
{
	return sqrt((a.first - b.first)*(a.first - b.first) + (a.second - b.second)*(a.second - b.second));
}

bool higher_than_line(Line l, Point x) {
	return (x.first - l.first.first) * (l.second.second - l.first.second) -
		(x.second - l.first.second) * (l.second.first - l.first.first) > 0;
}

bool lower_than_line(Line l, Point x) {
	return (x.first - l.first.first) * (l.second.second - l.first.second) -
		(x.second - l.first.second) * (l.second.first - l.first.first) < 0;
}

bool is_on_line(Line l, Point x) {
	return (!equal(l.first, x) && !equal(l.second, x)) &&
		(scalar_product(Line(x, l.first), Line(x, l.second)) < 0) &&
		fabs((x.first - l.first.first) * (l.second.second - l.first.second) -
		(x.second - l.first.second) * (l.second.first - l.first.first)) < std::numeric_limits<double>::epsilon();
};

bool equal(Point a, Point b) {
	return fabs(a.first - b.first) < std::numeric_limits<double>::epsilon() &&
		fabs(a.second - b.second) < std::numeric_limits<double>::epsilon();
}

double scalar_product(Line a, Line b) {
	return (a.first.first - a.second.first) * (b.first.first - b.second.first) + (a.first.second - a.second.second) * (b.first.second - b.second.second);
}