PL/SQL Developer Test script 3.0
41
declare
  -- Local variables here
  v_Company_Id    number := 600;
  v_Fr_Person_Ids Array_Number;
  v_Sc_Person_Ids Array_Number;
  v_Match         number;
  v_Other         Array_Number;

  v_Photos Array_Varchar2;
begin
  select q.Photo_Sha
    bulk collect
    into v_Photos
    from (select q.Photo_Sha
            from Htt_Person_Photos q
           where q.Company_Id = 1700
          union
          select w.Photo_Sha
            from Hac_Hik_Ex_Persons w
           where w.Organization_Code = '16'
             and w.Photo_Sha is not null) q
   where exists (select 1
            from Hes_Photo_Vectors w
           where w.Sha = q.Photo_Sha);

  for i in 1 .. v_Photos.Count
  loop
    for j in i + 1 .. v_Photos.Count
    loop
      v_Match := Ui_Vhr621.Calc_Verification_Photo(i_Fr_Photo => v_Photos(i),
                                                   i_Sc_Photo => v_Photos(j));
    
      if v_Match < 10.734 then
        insert into Hes_Matched_Photos
          (Fr_Sha, Sc_Sha, Match_Score)
        values
          (v_Photos(i), v_Photos(j), v_Match);
      end if;
    end loop;
  end loop;
end;
0
0
