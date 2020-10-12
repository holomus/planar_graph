#pragma once
#include <time.h>
#include <fstream>
#include <array>
#include <list>
#include <random>
#include <algorithm>
#include "Triangle.h"
#include "geometry_wrapper.h"
#include "AdjacencyMatrix.h"

template <typename VertexValue, typename vertex_iterator>
class GraphGen
{
public:
	AdjacencyMatrix<VertexValue> generate_random_graph(int vertice_num)
	{
		AdjacencyMatrix<VertexValue> graph(vertice_num);

		/*srand(time(NULL));*/
		//srand(1000);

		for (int i = 0; i < vertice_num; ++i) {
			int random_vertice_num = rand() % vertice_num;
			int random_vertice_index;
			for (int j = 0; i < random_vertice_num; ++i) {
				random_vertice_index = rand() % vertice_num;
				if (i == random_vertice_index) continue;
				graph.add_edge(i, random_vertice_index);
				graph.add_edge(random_vertice_index, i);
			}
		}

		make_connected(graph);

		return graph;
	}

	AdjacencyMatrix<VertexValue> generate_not_so_planar_graph(int vertice_num)
	{
		AdjacencyMatrix<VertexValue> graph(vertice_num);

		std::vector<std::array<double, 3>> hor;
		std::vector<std::array<double, 3>> ver;

		std::random_device rd;
		std::uniform_real_distribution<double> real_dist(0.0, 10.0);
		std::default_random_engine re(rd());
		
		double rnum;
		double rdelta;

		for (int i = 0; i < vertice_num; ++i) {
			rnum = real_dist(re);
			rdelta = real_dist(re);
			hor.push_back(std::array<double, 3>{ rnum, rnum + rdelta, real_dist(re) });
		}

		std::uniform_int_distribution<int> int_dist(vertice_num, 3 * vertice_num - 6);
		int edge_num = int_dist(re);
		for (int i = 0; i < edge_num; ++i) {
			rnum = real_dist(re);
			rdelta = real_dist(re);
			ver.push_back(std::array<double, 3>{ rnum, rnum + rdelta, real_dist(re) });
		}
		
		
		/*std::sort(ver.begin(), ver.end(), [](std::array<double, 3> left, std::array<double, 3> right) {
			return left[2] < right[2];
		});

		
		
		std::sort(hor.begin(), hor.end(), [](std::array<double, 3> left, std::array<double, 3> right) {
			return left[0] < right[0];
		});


		for (auto it = ver.begin(); it != std::next(it, ver.size() / 2); ++it) {
			for (auto& hsegment : hor) {
				if (hsegment[0] <= (*it)[2]) {
					if (hsegment[1] >= (*it)[2]) {
						if(hsegment[3] >= (*it)[0] && hsegment[1] <= (*it)[1]){
							
						}
					}
				}
			}
		}

		std::sort(hor.begin(), hor.end(), [](std::array<double, 3> left, std::array<double, 3> right) {
			return left[1] < right[1];
		});

		for (auto it = std::next(ver.begin(), ver.size() / 2); it != ver.end(); ++it) {
			for (auto& hsegment : hor) {
				if (hsegment[1] >= (*it)[2]) {
					if (hsegment[0] <= (*it)[2]) {
						if (hsegment[3] >= (*it)[0] && hsegment[1] <= (*it)[1]) {

						}
					}
				}
			}
		}*/

		for (auto& vseg : ver) {
			int index = 0;
			std::vector<int> intersect;
			for (auto& hseg : hor) {
				if (hseg[0] <= vseg[2] && hseg[1] >= vseg[2]) {
					if (vseg[0] <= hseg[2] && vseg[1] >= hseg[2]) {
						intersect.push_back(index);
					}
				}
				++index;
			}
			if (intersect.size() > 1) {
				for (size_t i = 1; i < intersect.size(); ++i) {
					graph.add_edge(intersect[i], intersect[i - 1]);
					graph.add_edge(intersect[i - 1], intersect[i]);
				}
			}
		}

		/*make_connected(graph);*/

		return graph;
	}

	AdjacencyMatrix<VertexValue> generate_planar_graph(int vertice_num) {
		AdjacencyMatrix<VertexValue> graph(vertice_num);
		
		std::random_device rd;
		std::uniform_real_distribution<double> real_dist(0.0, 10.0);
		std::default_random_engine re(rd());

		std::vector<Point> points(vertice_num);
		std::list<Triangle> triangles;
		int i = 0;
		for (auto& point : points) {
			point = Point(real_dist(re), real_dist(re), i++);
		}

		/*std::sort(points.begin(), points.end(), [](std::pair<double, double> left, std::pair<double, double> right) {
			return left.first < right.first;
		});

		if (vertice_num > 2) {
			bool is_on_line = std::fabs(((points[2].first - points[0].first) / (points[1].first - points[0].first) -
							 (points[2].second - points[0].second) / (points[1].second - points[0].second))) < std::numeric_limits<double>::epsilon();
			if (is_on_line)
			{
				points[2].first += 1;
				points[2].second += 1;
			}

			triangles.push_back(Triangle(points[0], points[1], points[2]));

			for (int i = 3; i < vertice_num; ++i) {

			}
		}*/

		std::ofstream points_set("Points.csv");
		std::ofstream hull_points("Hull.csv");

		for (size_t i = 0; i < points.size(); ++i) {
			points_set << points[i].first << ", " << points[i].second << std::endl;
		}

		auto hull = make_convex_hull(points);

		for (size_t i = 0; i < hull.size(); ++i) {
			hull_points << hull[i].first << ", " << hull[i].second << std::endl;
		}

		for (size_t i = 0; i < points.size(); ++i) {
			for (size_t j = 0; j < hull.size(); ++j) {
				if (equal(hull[j], points[i])) {
					hull[j].index = points[i].index;
					break;
				}
			}
		}

		for (size_t i = 1; i < hull.size() - 1; ++i) {
			triangles.push_back(Triangle(hull[0], hull[i], hull[i + 1]));
		}

		for (auto& point : points) {
			for (auto it = triangles.begin(); it != triangles.end(); ++it) {
				if (it->is_in_Triangle(point)) {
					triangles.push_back(Triangle(it->a, it->b, point));
					triangles.push_back(Triangle(it->a, it->c, point));
					triangles.push_back(Triangle(it->b, it->c, point));
					triangles.erase(it);
					break;
				}
				if (it->is_on_Triangle_edges(point)) {
					if (is_on_line(Line(it->a, it->b), point)) {
						triangles.push_back(Triangle(it->a, it->b, point));
					}
					if (is_on_line(Line(it->a, it->c), point)) {
						triangles.push_back(Triangle(it->a, it->c, point));
					}
					if (is_on_line(Line(it->b, it->c), point)) {
						triangles.push_back(Triangle(it->b, it->c, point));
					}
				}
				if (it->is_on_Triangle_vertices(point)) {
					break;
				}
			}
		}

		for (auto& triangle : triangles) {
			graph.add_edge(triangle.a.index, triangle.b.index);
			graph.add_edge(triangle.b.index, triangle.a.index);
			graph.add_edge(triangle.a.index, triangle.c.index);
			graph.add_edge(triangle.c.index, triangle.a.index);
			graph.add_edge(triangle.b.index, triangle.c.index);
			graph.add_edge(triangle.c.index, triangle.b.index);
		}

		return graph;
	}

	void save(AdjacencyMatrix<VertexValue>& graph)
	{
		std::ofstream outputFile("Graph.txt");
		outputFile << graph;
	}

protected:
	void make_connected(Graph<VertexValue, vertex_iterator>& graph) {
		size_t vertice_num = graph.vertice_num();
		for (size_t i = 1; i < vertice_num; ++i) {
			graph.add_edge(i, i - 1);
			graph.add_edge(i - 1, i);
		}
	}
};

