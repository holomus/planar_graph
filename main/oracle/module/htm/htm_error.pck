create or replace package Htm_Error is
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_001
  (
    i_From_Rank_Name varchar2,
    i_Attempt_No     number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002
  (
    i_Job_Name        varchar2,
    i_Experience_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_003(i_Document_Number varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_004(i_Document_Number varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_005
  (
    i_Document_Number  varchar2,
    i_Document_Status  varchar2,
    i_Current_Status   varchar2,
    i_Allowed_Statuses Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_006
  (
    i_Document_Status varchar,
    i_Current_Status  varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_007
  (
    i_Document_Status varchar,
    i_Current_Status  varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_008
  (
    i_Ignore_Score   number,
    i_Success_Score  number,
    i_From_Rank_Name varchar2,
    i_Attempt_No     number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_009
  (
    i_Ignore_Score   number,
    i_From_Rank_Name varchar2,
    i_Attempt_No     number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_010
  (
    i_Success_Score  number,
    i_From_Rank_Name varchar2,
    i_Attempt_No     number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_011
  (
    i_From_Rank_Name varchar2,
    i_Attempt_No     number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_012
  (
    i_From_Rank_Name varchar2,
    i_Attempt_No     number
  );
end Htm_Error;
/
create or replace package body Htm_Error is
  ----------------------------------------------------------------------------------------------------
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('HTM:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Error
  (
    i_Code    varchar2,
    i_Message varchar2,
    i_Title   varchar2 := null,
    i_S1      varchar2 := null,
    i_S2      varchar2 := null,
    i_S3      varchar2 := null,
    i_S4      varchar2 := null,
    i_S5      varchar2 := null
  ) is
  begin
    b.Raise_Extended(i_Code    => Verifix.Htm_Error_Code || i_Code,
                     i_Message => i_Message,
                     i_Title   => i_Title,
                     i_S1      => i_S1,
                     i_S2      => i_S2,
                     i_S3      => i_S3,
                     i_S4      => i_S4,
                     i_S5      => i_S5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_001
  (
    i_From_Rank_Name varchar2,
    i_Attempt_No     number
  ) is
  begin
    Error(i_Code    => '001',
          i_Message => t('001:message:nearest day must be less than total period day, from rank name: $1{from_rank_name} on attempt_no $2{attempt_no}',
                         i_From_Rank_Name,
                         i_Attempt_No),
          i_Title   => t('001:title:nearest day is more than total period'),
          i_S1      => t('001:solution:reduce number of nearest days'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002
  (
    i_Job_Name        varchar2,
    i_Experience_Name varchar2
  ) is
  begin
    Error(i_Code    => '002',
          i_Message => t('002:message:this job $1{job_name} is attached to $2{experience_name}',
                         i_Job_Name,
                         i_Experience_Name),
          i_Title   => t('002:title:job found in another experience'),
          i_S1      => t('002:solution:remove this job from the list and try again'),
          i_S2      => t('002:solution:detach job from attached experience $1{experience_name} and try again',
                         i_Experience_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_003(i_Document_Number varchar2) is
  begin
    Error(i_Code    => '003',
          i_Message => t('003:message:cannot change/save document. document $1{document_number} is not in status new',
                         i_Document_Number),
          i_S1      => t('003:solution:set the document status into new and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_004(i_Document_Number varchar2) is
  begin
    Error(i_Code    => '004',
          i_Message => t('004:message:cannot delete document. document $1{document_number} is not in status new',
                         i_Document_Number),
          i_S1      => t('004:solution:set the document status into new and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_005
  (
    i_Document_Number  varchar2,
    i_Document_Status  varchar2,
    i_Current_Status   varchar2,
    i_Allowed_Statuses Array_Varchar2
  ) is
  begin
    Error(i_Code    => '005',
          i_Message => t('005:message:cannot set document status into $1{document_status}. document $2{document_number} status must be in $3{allowed_statuses}, but current status is $4{current_status}',
                         i_Document_Status,
                         i_Document_Number,
                         Fazo.Gather(i_Allowed_Statuses, ', '),
                         i_Current_Status),
          i_S1      => t('005:solution:set document to allowed status and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_006
  (
    i_Document_Status varchar,
    i_Current_Status  varchar2
  ) is
  begin
    Error(i_Code    => '006',
          i_Message => t('006:message:to change training and exam settings for staff document must be in status $1{document_status}, but current status is $2{current_status}',
                         i_Document_Status,
                         i_Current_Status),
          i_S1      => t('006:solution:set document to correct status and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_007
  (
    i_Document_Status varchar,
    i_Current_Status  varchar2
  ) is
  begin
    Error(i_Code    => '007',
          i_Message => t('007:message:to change staff increment status and set indicator values document must be in status $1{document_status}, but current status is $2{current_status}',
                         i_Document_Status,
                         i_Current_Status),
          i_S1      => t('007:solution:set document to correct status and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_008
  (
    i_Ignore_Score   number,
    i_Success_Score  number,
    i_From_Rank_Name varchar2,
    i_Attempt_No     number
  ) is
  begin
    Error(i_Code    => '008',
          i_Message => t('008:message:ignore score $1{ignore_score} must be less than success score $2{success_score}, from rank name $3{from_rank_name} on attempt $4{attempt_no}',
                         i_Ignore_Score,
                         i_Success_Score,
                         i_From_Rank_Name,
                         i_Attempt_No));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_009
  (
    i_Ignore_Score   number,
    i_From_Rank_Name varchar2,
    i_Attempt_No     number
  ) is
  begin
    Error(i_Code    => '009',
          i_Message => t('009:message:ignore score $1{ignore_score} must be less than 100 percent, from rank name $2{from_rank_name} on attempt $3{attempt_no}',
                         i_Ignore_Score,
                         i_From_Rank_Name,
                         i_Attempt_No));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_010
  (
    i_Success_Score  number,
    i_From_Rank_Name varchar2,
    i_Attempt_No     number
  ) is
  begin
    Error(i_Code    => '010',
          i_Message => t('010:message:success score $1{ignore_score} must be less than or equal 100 percent, from rank name $2{from_rank_name} on attempt $3{attempt_no}',
                         i_Success_Score,
                         i_From_Rank_Name,
                         i_Attempt_No));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_011
  (
    i_From_Rank_Name varchar2,
    i_Attempt_No     number
  ) is
  begin
    Error(i_Code    => '011',
          i_Message => t('011:message:attempt period must be bigger than 0, from rank name $1{from_rank_name} on attempt $2{attempt_no}',
                         i_From_Rank_Name,
                         i_Attempt_No));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_012
  (
    i_From_Rank_Name varchar2,
    i_Attempt_No     number
  ) is
  begin
    Error(i_Code    => '012',
          i_Message => t('012:message:attempt nearest period must be bigger than 0, from rank name $1{from_rank_name} on attempt $2{attempt_no}',
                         i_From_Rank_Name,
                         i_Attempt_No));
  end;

end Htm_Error;
/
