#pragma once
#include "geometry_wrapper.h"
 
double distance(Point a, Point b);

double scalar_product(Line a, Line b);

bool higher_than_line(Line l, Point x);

bool lower_than_line(Line l, Point x);

bool is_on_line(Line l, Point x);

bool equal(Point a, Point b);

