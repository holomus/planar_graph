create or replace package Htt_Geo_Util is
  ----------------------------------------------------------------------------------------------------
  Function Latlng(i_Latlng varchar2) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Distance
  (
    i_Point1_Lat number,
    i_Point1_Lng number,
    i_Point2_Lat number,
    i_Point2_Lng number
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Calc_Distance
  (
    i_Point1 varchar2,
    i_Point2 varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Distance_To_Edge
  (
    i_Point   varchar2,
    i_Vertex1 varchar2,
    i_Vertex2 varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Distance_To_Polygon
  (
    i_Company_Id  number,
    i_Location_Id number,
    i_Point       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Is_Point_In_Polygon
  (
    i_Company_Id  number,
    i_Location_Id number,
    i_Point       varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Is_Point_In_Polygon
  (
    i_Company_Id  number,
    i_Location_Id number,
    i_Point_Lat   number,
    i_Point_Lng   number
  ) return varchar2;
end Htt_Geo_Util;
/
create or replace package body Htt_Geo_Util is
  ----------------------------------------------------------------------------------------------------
  Function Latlng(i_Latlng varchar2) return Array_Number is
  begin
    return Fazo.To_Array_Number(i_Val      => Fazo.Split(i_Latlng, ','),
                                i_Format   => '999D999999999999999999',
                                i_Nlsparam => 'NLS_NUMERIC_CHARACTERS=''. ''');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Distance
  (
    i_Point1_Lat number,
    i_Point1_Lng number,
    i_Point2_Lat number,
    i_Point2_Lng number
  ) return number is
  begin
    return Nvl(Power(Power(69.1 * (i_Point2_Lat - i_Point1_Lat), 2) +
                     Power(53.0 * (i_Point2_Lng - i_Point1_Lng), 2),
                     0.5) / 0.00062137,
               0);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calc_Distance
  (
    i_Point1 varchar2,
    i_Point2 varchar2
  ) return number is
    v_Point1 Array_Number := Latlng(i_Point1);
    v_Point2 Array_Number := Latlng(i_Point2);
  begin
    return Calc_Distance(i_Point1_Lat => v_Point1(1),
                         i_Point1_Lng => v_Point1(2),
                         i_Point2_Lat => v_Point2(1),
                         i_Point2_Lng => v_Point2(2));
  end;

  ----------------------------------------------------------------------------------------------------
  -- point and edge forms a triangle (with points: i_Point, i_Vertex1, i_Vertex2)
  ----------------------------------------------------------------------------------------------------
  Function Distance_To_Edge
  (
    i_Point   varchar2,
    i_Vertex1 varchar2,
    i_Vertex2 varchar2
  ) return number is
    -- edges of the triangle
    v_Edge  number := Calc_Distance(i_Vertex1, i_Vertex2); -- side of the triange (with points: i_Vertex1, i_Vertex2)
    v_Dist1 number := Calc_Distance(i_Point, i_Vertex1); -- side of the triange (with points: i_Point, i_Vertex1)
    v_Dist2 number := Calc_Distance(i_Point, i_Vertex2); -- side of the triange (with points: i_Point, i_Vertex2)
  
    v_Edge_Pw2  number := v_Edge * v_Edge; -- v_Edge^2
    v_Dist1_Pw2 number := v_Dist1 * v_Dist1; -- v_Dist1^2
    v_Dist2_Pw2 number := v_Dist2 * v_Dist2; -- v_Dist2^2
  
    v_Sp   number; -- semi-perimeter of the triangle
    v_Area number; -- area of the triangle
  begin
    -- return v_Dist1 if i_Vertex1 point is obtuse-angled (>90 degrees)
    if v_Edge_Pw2 + v_Dist1_Pw2 <= v_Dist2_Pw2 then
      return v_Dist1;
    end if;
  
    -- return v_Dist2 if i_Vertex2 point is obtuse-angled (>90 degrees)
    if v_Edge_Pw2 + v_Dist2_Pw2 <= v_Dist1_Pw2 then
      return v_Dist2;
    end if;
  
    -- if both i_Vertex1 & i_Vertex2 points are acute-angled (<90 degrees) then
    -- the distance btw point to edge is equal to triangle height from i_point to base (i_Vertex1 & i_Vertex2)
  
    -- semi-perimeter is needed to calculate AREA of the triangle, using "Heron's formula"
    v_Sp   := (v_Edge + v_Dist1 + v_Dist2) / 2;
    v_Area := Power(v_Sp * (v_Sp - v_Edge) * (v_Sp - v_Dist1) * (v_Sp - v_Dist2), 0.5);
  
    -- height is calculated as: height = 2 * area / base
    return 2 * v_Area / v_Edge;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Distance_To_Polygon
  (
    i_Company_Id  number,
    i_Location_Id number,
    i_Point       varchar2
  ) return number is
    v_Vertices Array_Varchar2;
    v_Distance number;
  begin
    select t.Latlng
      bulk collect
      into v_Vertices
      from Htt_Location_Polygon_Vertices t
     where t.Company_Id = i_Company_Id
       and t.Location_Id = i_Location_Id
     order by t.Order_No;
  
    v_Vertices.Extend;
    v_Vertices(v_Vertices.Count) := v_Vertices(1);
  
    select min(Distance_To_Edge(i_Point, Vertex_1, Vertex_2))
      into v_Distance
      from (select Lag(t.Column_Value) Over(order by Rownum) Vertex_1, t.Column_Value Vertex_2
              from table(v_Vertices) t Offset 1 row);
  
    return Round(v_Distance);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Point_In_Polygon
  (
    i_Company_Id  number,
    i_Location_Id number,
    i_Point       varchar2
  ) return varchar2 is
    v_Point    Array_Number;
    v_Inside   boolean := false;
    v_Accuracy number;
    v_Distance number;
  begin
    v_Point := Latlng(i_Point);
  
    -- iteration over each vertices
    for r in (select Latlng(Lag(t.Latlng) Over(order by t.Order_No)) Vertex_1,
                     Latlng(t.Latlng) Vertex_2
                from Htt_Location_Polygon_Vertices t
               where t.Company_Id = i_Company_Id
                 and t.Location_Id = i_Location_Id
               order by t.Order_No Offset 1 row)
    loop
      if (v_Point(2) < r.Vertex_1(2)) <> (v_Point(2) < r.Vertex_2(2)) and
         v_Point(1) < (r.Vertex_2(1) - r.Vertex_1(1)) * (v_Point(2) - r.Vertex_1(2)) /
         (r.Vertex_2(2) - r.Vertex_1(2)) + r.Vertex_1(1) then
        v_Inside := not v_Inside;
      end if;
    end loop;
  
    if not v_Inside then
      v_Accuracy := z_Htt_Locations.Load(i_Company_Id => i_Company_Id, i_Location_Id => i_Location_Id).Accuracy;
      v_Distance := Distance_To_Polygon(i_Company_Id  => i_Company_Id,
                                        i_Location_Id => i_Location_Id,
                                        i_Point       => i_Point);
      v_Inside   := v_Distance <= v_Accuracy;
    end if;
  
    if v_Inside then
      return 'Y';
    end if;
  
    return 'N';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Point_In_Polygon
  (
    i_Company_Id  number,
    i_Location_Id number,
    i_Point_Lat   number,
    i_Point_Lng   number
  ) return varchar2 is
  begin
    return Is_Point_In_Polygon(i_Company_Id  => i_Company_Id,
                               i_Location_Id => i_Location_Id,
                               i_Point       => i_Point_Lat || ',' || i_Point_Lng);
  end;

end Htt_Geo_Util;
/
