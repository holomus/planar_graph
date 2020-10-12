#include "geometry.h"
#pragma warning(disable:4996)
#define SQR(a) ((a) * (a))



SPoint *SetPointArr(FILE *fin, int size)
{
	int i;
	SPoint *arr = (SPoint *)malloc(size * sizeof(*arr));
	for (i = 0; i < size; ++i)
		fscanf(fin, "%lf%lf", &((arr + i)->x), &((arr + i)->y));
	return arr;
}

SPoint* CreateP(int num)
{
	SPoint *P = (SPoint*)malloc(num * sizeof(*P));
	return P;
}

void destroyP(SPoint *P)
{
	if (P != NULL)
	{
		free(P);
		P = NULL;
	}
}

int findNextMinCosPointIndex(SVector *Line, SPoint *PArr, int size)
{
	int i, minCosIndex;
	double cos, minCos;
	minCos = Cos(Line->begin, Line->end, PArr, Line->end);
	minCosIndex = 0;
	for (i = 1; i < size; ++i)
	{
		cos = Cos(Line->begin, Line->end, PArr + i, Line->end);
		if (cos < minCos)
		{
			minCos = cos;
			minCosIndex = i;
		}
	}
	return minCosIndex;
}

double Cos(SPoint *P1, SPoint *P2, SPoint *P3, SPoint *P4)
{
	double scalarProduct;
	double Vec1Length, Vec2Length;
	scalarProduct = (P2->x - P1->x) * (P4->x - P3->x) + (P2->y - P1->y) * (P4->y - P3->y);
	Vec1Length = sqrt(SQR(P2->x - P1->x) + SQR(P2->y - P1->y));
	Vec2Length = sqrt(SQR(P4->x - P3->x) + SQR(P4->y - P3->y));
	return scalarProduct / (Vec1Length * Vec2Length);
}



int findSecondPointIndex(SPoint *PArr, int size, SPoint *startPoint)
{
	int i, minTanIndex = 0;
	double tan = 0.0, minTan = 0.0;
	minTan = (PArr->y - startPoint->y) / (PArr->x - startPoint->x);
	for (i = 0; i < size - 1; ++i)
	{
		tan = ((PArr + i)->y - startPoint->y) / ((PArr + i)->x - startPoint->x);
		if (tan < minTan)
		{
			minTan = tan;
			minTanIndex = i;
		}
	}
	return minTanIndex;
}

int findLowestLeftmostPointIndex(SPoint *PArr, int size)
{
	int i, minYindex, minXindex;
	double minY, minX;
	minX = PArr->x;
	minXindex = 0;
	for (i = 1; i < size; ++i)
	{
		if ((PArr + i)->x < minX)
		{
			minX = (PArr + i)->x;
			minXindex = i;
		}
	}
	minY = (PArr + minXindex)->y;
	minYindex = minXindex;
	for (i = 0; i < size; ++i)
	{
		if ((fabs((PArr + minXindex)->x - (PArr + i)->x) < DBL_MIN) && ((PArr + i)->y < minY))
		{
			minY = (PArr + i)->y;
			minYindex = i;
		}
	}
	return minYindex;
}

void ConvexHull(SPoint *PArr, int size, SPoint *tmpP, int *nextPointIndex)
{
	int tmpIndex = 0;
	double minTan = 0.0, Tan = 0.0, prevTan = 0.0;
	SPoint *nextPoint = NULL;
	SVector Line;
	tmpIndex = findLowestLeftmostPointIndex(PArr, size); //then put it at the end
	swapPoints(PArr + tmpIndex, PArr + size - 1, tmpP);
	tmpIndex = findSecondPointIndex(PArr, size, PArr + size - 1); //then put it at the beginning
	swapPoints(PArr + tmpIndex, PArr, tmpP);
	Line.begin = PArr + size - 1;	Line.end = PArr;
	(*nextPointIndex) = 1;
	while (1)
	{
		nextPoint = PArr + (*nextPointIndex);
		tmpIndex = findNextMinCosPointIndex(&Line, nextPoint, size - (*nextPointIndex));
		tmpIndex += (*nextPointIndex);
		swapPoints(nextPoint, PArr + tmpIndex, tmpP);
		if (tmpIndex == size - 1)
		{
			++(*nextPointIndex);
			break;
		}
		Line.begin = Line.end; Line.end = nextPoint;
		++(*nextPointIndex);
	}
}

void swapPoints(SPoint *P1, SPoint *P2, SPoint *tmpP)
{
	if ((P1 == NULL) || (P2 == NULL) || (tmpP == NULL))
		return;
	memcpy(tmpP, P2, sizeof(*tmpP));
	memcpy(P2, P1, sizeof(*tmpP));
	memcpy(P1, tmpP, sizeof(*tmpP));
}