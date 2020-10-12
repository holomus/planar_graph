#include "Triangle.h"

bool Triangle::is_in_Triangle(Point x)
{
	return higher_than_line(Line(a, b), x) &&
		higher_than_line(Line(a, c), x) &&
		higher_than_line(Line(b, c), x) ||
		lower_than_line(Line(a, b), x) &&
		lower_than_line(Line(a, c), x) &&
		lower_than_line(Line(b, c), x);
}

bool Triangle::is_on_Triangle_vertices(Point x)
{
	return equal(a, x) ||
		equal(b, x) ||
		equal(c, x);
}

bool Triangle::is_on_Triangle_edges(Point x)
{
	return is_on_line(Line(a, b), x) ||
		is_on_line(Line(a, c), x) ||
		is_on_line(Line(b, c), x);
}
