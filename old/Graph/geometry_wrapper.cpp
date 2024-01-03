#include "geometry_wrapper.h"

std::vector<Point> make_convex_hull(std::vector<Point>& points)
{
	auto struct_points = CreateP(points.size());
	auto tmpP = CreateP(1);
	int n = 0;

	for (size_t i = 0; i < points.size(); ++i) {
		struct_points[i].x = points[i].first;
		struct_points[i].y = points[i].second;
	}

	ConvexHull(struct_points, points.size(), tmpP, &n);
	std::vector<Point> hull(n);
	for (int i = 0; i < n; ++i) {
		hull[i].first = struct_points[i].x;
		hull[i].second = struct_points[i].y;
	}



	delete struct_points;
	delete tmpP;

	return hull;
}
