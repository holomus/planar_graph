#pragma once
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <float.h>
#include <time.h>

typedef struct _SPoint {
	double x;
	double y;
}SPoint;

typedef struct _SVector {
	SPoint *begin;
	SPoint *end;
}SVector;


void ConvexHull(SPoint *PArr, int size, SPoint *tmpP, int *n);
int findSecondPointIndex(SPoint *PArr, int size, SPoint *startPoint);
int findLowestLeftmostPointIndex(SPoint *PArr, int size);
void swapPoints(SPoint *P1, SPoint *P2, SPoint *tmpP);
int findNextMinCosPointIndex(SVector *Line, SPoint *PArr, int size);
double Cos(SPoint *P1, SPoint *P2, SPoint *P3, SPoint *P4);
SPoint *SetPointArr(FILE *fin, int size);
SPoint* CreateP(int num);
void destroyP(SPoint *PArr);