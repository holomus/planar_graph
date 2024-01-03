create or replace package Hln_Error is
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_001(i_Group_Names varchar2);
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_002(i_Exam_Name varchar2);
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_003
  (
    i_Exam_Name          varchar2,
    i_Pattern_Name       varchar2,
    i_Pattern_Quantity   number,
    i_Questions_Quantity number
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_004(i_Question_Group_Name varchar2);
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_005(i_Question_Group_Name varchar2);
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_006(i_Question_Type_Name varchar2);
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_007(i_Question_Type_Name varchar2);
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_008(i_Question_Id varchar2);
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_009(i_Question_Id varchar2);
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_010(i_Question_Id varchar2);
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_011
  (
    i_Exam_Question_Count number,
    i_Question_Count      number
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_012
  (
    i_Sum_Quantity        number,
    i_Exam_Question_Count number
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_013
  (
    i_Testing_Number     varchar2,
    i_Attestation_Number varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_014(i_Testing_Number number);
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_015
  (
    i_Testing_Number varchar2,
    i_Status_Name    varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_016(i_Testing_Number varchar2);
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_017
  (
    i_Testing_Number varchar2,
    i_Status_Name    varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_018(i_Testing_Number varchar2);
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_019
  (
    i_Begin_Time     varchar2,
    i_Testing_Number varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_020
  (
    i_Begin_Time     varchar2,
    i_End_Time       varchar2,
    i_Testing_Number varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_021
  (
    i_Testing_Number varchar2,
    i_Status_Name    varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_022
  (
    i_Testing_Number varchar2,
    i_Status_Name    varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_023
  (
    i_Testing_Number varchar2,
    i_Status_Name    varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_024
  (
    i_Testing_Number varchar2,
    i_Status_Name    varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_025(i_Testing_Number varchar2);
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_026(i_Testing_Number varchar2);
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_027
  (
    i_End_Time       varchar2,
    i_Testing_Number varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_028
  (
    i_Testing_Number varchar2,
    i_Status_Name    varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_029
  (
    i_End_Time       varchar2,
    i_Testing_Number varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_030
  (
    i_Testing_Number varchar2,
    i_Status_Name    varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_031
  (
    i_Current_Date   date,
    i_Testing_Date   date,
    i_Testing_Number varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_032
  (
    i_Testing_Number varchar2,
    i_Status_Name    varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_033
  (
    i_Attestation_Number varchar2,
    i_Status_Name        varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_034
  (
    i_Attestation_Number varchar2,
    i_Person_Names       varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_035
  (
    i_Attestation_Number varchar2,
    i_Status_Name        varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_036
  (
    i_Testing_Number varchar2,
    i_Status_Name    varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_037
  (
    i_Testing_Number varchar2,
    i_Question_Id    number
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_038
  (
    i_Testing_Number varchar2,
    i_Question_Id    number
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_039
  (
    i_Testing_Number varchar2,
    i_Question_Id    number
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_040
  (
    i_Testing_Number varchar2,
    i_Status_Name    varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_041
  (
    i_Training_Number varchar2,
    i_Status_Name     varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_042
  (
    i_Training_Number varchar2,
    i_Status_Name     varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_043
  (
    i_Training_Number varchar2,
    i_Status_Name     varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_044
  (
    i_Training_Number varchar2,
    i_Status_Name     varchar2
  );
  -----------------------------------------------------------------------------------------------
  Procedure Raise_045
  (
    i_Training_Number varchar2,
    i_Status_Name     varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_046(i_Training_Number varchar2);
  ---------------------------------------------------------------------------------------------------
  Procedure Raise_047
  (
    i_Training_Number varchar2,
    i_Status_Name     varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_048
  (
    i_Testing_Number       varchar2,
    i_Attached_Person_Name varchar2,
    i_Person_Name          varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_049(i_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_050(i_Training_Number varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_051
  (
    i_Training_Number varchar2,
    i_Status_Name     varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_052;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_053;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_054
  (
    i_Testing_Number varchar2,
    i_Period_Begin   date,
    i_Period_End     date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_055
  (
    i_Testing_Number varchar2,
    i_Period_Begin   date,
    i_Period_End     date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_056
  (
    i_Attestation_Number varchar2,
    i_Period_Begin       date,
    i_Period_End         date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_057(i_Exam_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_058
  (
    i_Exam_Name   varchar2,
    i_Question_Id varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_059
  (
    i_Exam_Name   varchar2,
    i_Question_Id varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_060
  (
    i_Exam_Name   varchar2,
    i_Question_Id varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_061(i_Exam_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_062(i_Subject_Group_Name varchar2);
end Hln_Error;
/
create or replace package body Hln_Error is
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
    return b.Translate('HLN:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
    b.Raise_Extended(i_Code    => Verifix.Hln_Error_Code || i_Code,
                     i_Message => i_Message,
                     i_Title   => i_Title,
                     i_S1      => i_S1,
                     i_S2      => i_S2,
                     i_S3      => i_S3,
                     i_S4      => i_S4,
                     i_S5      => i_S5);
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_001(i_Group_Names varchar2) is
  begin
    Error(i_Code    => '001',
          i_Message => t('001:message:$1{question_group_names} are required, question type must be chosen for them',
                         i_Group_Names),
          i_Title   => t('001:title:question type not choosen'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_002(i_Exam_Name varchar2) is
  begin
    Error(i_Code    => '002',
          i_Message => t('002:message:pick kind of $1{exam_name} is not auto', i_Exam_Name),
          i_S1      => t('002:solution:change the pick kind of $1{exam_name} to auto', i_Exam_Name));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_003
  (
    i_Exam_Name          varchar2,
    i_Pattern_Name       varchar2,
    i_Pattern_Quantity   number,
    i_Questions_Quantity number
  ) is
    v_Required_Amount number := i_Pattern_Quantity - i_Questions_Quantity;
  begin
    Error(i_Code    => '003',
          i_Message => t('003:message:not enough questions for pattern, exam name: $1{exam_name}, pattern name: $2{pattern_name}, pattern quantity: $3{pattern_quantity}, question quantity: $4{question_quantity}',
                         i_Exam_Name,
                         i_Pattern_Name,
                         i_Pattern_Quantity,
                         i_Questions_Quantity),
          i_S1      => t('003:solution:add many questions as required in this exam, or reduce the quantity of questions, required amount: $1',
                         v_Required_Amount));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_004(i_Question_Group_Name varchar2) is
  begin
    Error(i_Code    => '004',
          i_Message => t('004:message:cannot change system question group, question group name: $1{group_name}',
                         i_Question_Group_Name));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_005(i_Question_Group_Name varchar2) is
  begin
    Error(i_Code    => '005',
          i_Message => t('005:message:cannot delete system question group, question group name: $1{group_name}',
                         i_Question_Group_Name));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_006(i_Question_Type_Name varchar2) is
  begin
    Error(i_Code    => '006',
          i_Message => t('006:message:the group of $1{question_type_name} cannot be changed',
                         i_Question_Type_Name));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_007(i_Question_Type_Name varchar2) is
  begin
    Error(i_Code    => '007',
          i_Message => t('007:message:$1{question_type_name} is system question type, it cannot be deleted',
                         i_Question_Type_Name));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_008(i_Question_Id varchar2) is
  begin
    Error(i_Code    => '008',
          i_Message => t('008:message:question must include at least 2 options, question_id=$1',
                         i_Question_Id),
          i_Title   => t('008:title:not enough options'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_009(i_Question_Id varchar2) is
  begin
    Error(i_Code    => '009',
          i_Message => t('009:message:there must be at least 1 correct answer, question_id=$1',
                         i_Question_Id),
          i_Title   => t('009:title:no correct answers'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_010(i_Question_Id varchar2) is
  begin
    Error(i_Code    => '010',
          i_Message => t('010:message:answer type is single but correct answers more than 1, question_id=$1',
                         i_Question_Id),
          i_Title   => t('010:title:multiple correct answers'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_011
  (
    i_Exam_Question_Count number,
    i_Question_Count      number
  ) is
  begin
    Error(i_Code    => '011',
          i_Message => t('011:message:$1{exam_question_count} selected questions are less than $2{question_count} exam questions',
                         i_Exam_Question_Count,
                         i_Question_Count));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_012
  (
    i_Sum_Quantity        number,
    i_Exam_Question_Count number
  ) is
  begin
    Error(i_Code    => '012',
          i_Message => t('012:message:sum of patterns question quantity count($1) must be equal exams question count($2)',
                         i_Sum_Quantity,
                         i_Exam_Question_Count),
          i_Title   => t('012:title:questions count are different'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_013
  (
    i_Testing_Number     varchar2,
    i_Attestation_Number varchar2
  ) is
  begin
    Error(i_Code    => '013',
          i_Message => t('013:message:this $1{testing_number} testing depends on $2{attestation_number} attestation',
                         i_Testing_Number,
                         i_Attestation_Number),
          i_Title   => t('013:title:testing depends on attestation'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_014(i_Testing_Number number) is
  begin
    Error(i_Code    => '014',
          i_Message => t('014:message:examiner and participant must be different, testing id: $1',
                         i_Testing_Number));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_015
  (
    i_Testing_Number varchar2,
    i_Status_Name    varchar2
  ) is
  begin
    Error(i_Code    => '015',
          i_Message => t('015:message:to update testing, status must be new, testing number: $1, current status: $2',
                         i_Testing_Number,
                         i_Status_Name),
          i_Title   => t('015:title:testing in another status'),
          i_S1      => t('015:solution:change status to new and try again'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_016(i_Testing_Number varchar2) is
  begin
    Error(i_Code    => '016',
          i_Message => t('016:message:testing status is already new, testing number: $1',
                         i_Testing_Number));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_017
  (
    i_Testing_Number varchar2,
    i_Status_Name    varchar2
  ) is
  begin
    Error(i_Code    => '017',
          i_Message => t('017:message:to enter the testing, testing status must be new, testing number: $1, current status: $2',
                         i_Testing_Number,
                         i_Status_Name),
          i_Title   => t('017:title:testing in another status'),
          i_S1      => t('017:solution:change status to new and try again'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_018(i_Testing_Number varchar2) is
  begin
    Error(i_Code    => '018',
          i_Message => t('018:message:to enter the testing, begin time must be set, testing number: $1',
                         i_Testing_Number),
          i_S1      => t('018:solution:set begin time for test and try again'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_019
  (
    i_Begin_Time     varchar2,
    i_Testing_Number varchar2
  ) is
  begin
    Error(i_Code    => '019',
          i_Message => t('019:message:$1{testing_number} testing cannot be execute before $2{begin_time}',
                         i_Testing_Number,
                         i_Begin_Time),
          i_S1      => t('019:solution:wait until $1{begin_time} or change begin time as you need',
                         i_Begin_Time));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_020
  (
    i_Begin_Time     varchar2,
    i_End_Time       varchar2,
    i_Testing_Number varchar2
  ) is
  begin
    Error(i_Code    => '020',
          i_Message => t('020:message:testing executes between $1{begin_time} and $2{end_time}, testing number: $3',
                         i_Begin_Time,
                         i_End_Time,
                         i_Testing_Number));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_021
  (
    i_Testing_Number varchar2,
    i_Status_Name    varchar2
  ) is
  begin
    Error(i_Code    => '021',
          i_Message => t('021:message:to return execute, status must be checking or finished, testing number: $1, current status: $2',
                         i_Testing_Number,
                         i_Status_Name),
          i_Title   => t('021:title:testing in another status'),
          i_S1      => t('021:solution:change status checking or finished and try again'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_022
  (
    i_Testing_Number varchar2,
    i_Status_Name    varchar2
  ) is
  begin
    Error(i_Code    => '022',
          i_Message => t('022:message:to pause testing, status must be execute, testing number: $1, current status: $2',
                         i_Testing_Number,
                         i_Status_Name),
          i_Title   => t('022:title:testing in another status'),
          i_S1      => t('022:solution:change status execute and try again'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_023
  (
    i_Testing_Number varchar2,
    i_Status_Name    varchar2
  ) is
  begin
    Error(i_Code    => '023',
          i_Message => t('023:message:to continue testing, status must be pause, testing number: $1, current status: $2',
                         i_Testing_Number,
                         i_Status_Name),
          i_Title   => t('023:title:testing in another status'),
          i_S1      => t('023:solution:change status pause and try again'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_024
  (
    i_Testing_Number varchar2,
    i_Status_Name    varchar2
  ) is
  begin
    Error(i_Code    => '024',
          i_Message => t('024:message:to return checking, testing status must be finished, testing number: $1, current status: $2',
                         i_Testing_Number,
                         i_Status_Name),
          i_Title   => t('024:title:testing in another status'),
          i_S1      => t('024:solution:change status finished and try again'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_025(i_Testing_Number varchar2) is
  begin
    Error(i_Code    => '025',
          i_Message => t('025:message:testing already finished, testing number: $1',
                         i_Testing_Number));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_026(i_Testing_Number varchar2) is
  begin
    Error(i_Code    => '026',
          i_Message => t('026:message:cannot finish testing, writing questions are not checked completely, testing number: $1',
                         i_Testing_Number),
          i_Title   => t('026:title:unchecked answers found'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_027
  (
    i_End_Time       varchar2,
    i_Testing_Number varchar2
  ) is
  begin
    Error(i_Code    => '027',
          i_Message => t('027:message:cannot finish to new status until $1{end_time}, testing number: $2',
                         i_End_Time,
                         i_Testing_Number),
          i_S1      => t('027:solution:wait until $1{end_time} or change end time as you need',
                         i_End_Time));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_028
  (
    i_Testing_Number varchar2,
    i_Status_Name    varchar2
  ) is
  begin
    Error(i_Code    => '028',
          i_Message => t('028:message:to stop testing, status must be executed or paused, testing number: $1, current status: $2',
                         i_Testing_Number,
                         i_Status_Name),
          i_Title   => t('028:title:testing in another status'),
          i_S1      => t('028:solution:change status execute or pause and try again'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_029
  (
    i_End_Time       varchar2,
    i_Testing_Number varchar2
  ) is
  begin
    Error(i_Code    => '029',
          i_Message => t('029:message:cannot stop testing until $1{end_time}, except attached person, testing number: $2',
                         i_End_Time,
                         i_Testing_Number),
          i_S1      => t('029:solution:wait until $1{end_time}', i_End_Time));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_030
  (
    i_Testing_Number varchar2,
    i_Status_Name    varchar2
  ) is
  begin
    Error(i_Code    => '030',
          i_Message => t('030:message:to set begin time, status must be new, testing number: $1, current status: $2',
                         i_Testing_Number,
                         i_Status_Name),
          i_Title   => t('030:title:testing in another status'),
          i_S1      => t('030:solution:change status to new'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_031
  (
    i_Current_Date   date,
    i_Testing_Date   date,
    i_Testing_Number varchar2
  ) is
  begin
    Error(i_Code    => '031',
          i_Message => t('031:message:current date($1) must be equal to testing date($2), testing number: $3',
                         i_Current_Date,
                         i_Testing_Date,
                         i_Testing_Number));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_032
  (
    i_Testing_Number varchar2,
    i_Status_Name    varchar2
  ) is
  begin
    Error(i_Code    => '032',
          i_Message => t('032:message:to start testing, status must be new, testing number: $1, current status: $2',
                         i_Testing_Number,
                         i_Status_Name),
          i_Title   => t('032:title:testing in another status'),
          i_S1      => t('032:solution:change status to new'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_033
  (
    i_Attestation_Number varchar2,
    i_Status_Name        varchar2
  ) is
  begin
    Error(i_Code    => '033',
          i_Message => t('033:message:to save attestation, status must be new, attestation number: $1, current status: $2',
                         i_Attestation_Number,
                         i_Status_Name),
          i_Title   => t('033:title:attestation in another status'),
          i_S1      => t('033:solution:change status to new'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_034
  (
    i_Attestation_Number varchar2,
    i_Person_Names       varchar2
  ) is
  begin
    Error(i_Code    => '034',
          i_Message => t('034:message:persons must be unique, attestation number: $1, duplicate persons: $2',
                         i_Attestation_Number,
                         i_Person_Names),
          i_Title   => t('034:title:duplicate persons found'),
          i_S1      => t('034:solution:remove dublicate persons'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_035
  (
    i_Attestation_Number varchar2,
    i_Status_Name        varchar2
  ) is
  begin
    Error(i_Code    => '035',
          i_Message => t('035:message:to delete attestation, status must be new, attestation number: $1, current status: $2',
                         i_Attestation_Number,
                         i_Status_Name),
          i_Title   => t('035:title:attestation in another status'),
          i_S1      => t('035:solution:change status to new'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_036
  (
    i_Testing_Number varchar2,
    i_Status_Name    varchar2
  ) is
  begin
    Error(i_Code    => '036',
          i_Message => t('036:message:to send answer, status must be executed, testing number: $1, current status: $2',
                         i_Testing_Number,
                         i_Status_Name),
          i_Title   => t('036:title:testing in another status'),
          i_S1      => t('036:solution:change status to executed'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_037
  (
    i_Testing_Number varchar2,
    i_Question_Id    number
  ) is
  begin
    Error(i_Code    => '037',
          i_Message => t('037:message:answer type of $1{testing_number} testing is single, only one answer can be selected, question id: $2',
                         i_Testing_Number,
                         i_Question_Id),
          i_Title   => t('037:title:several selected answers found'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_038
  (
    i_Testing_Number varchar2,
    i_Question_Id    number
  ) is
  begin
    Error(i_Code    => '038',
          i_Message => t('038:message:answer type is writing, testing number: $1, question id: $2',
                         i_Testing_Number,
                         i_Question_Id),
          i_Title   => t('038:title:answers found'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_039
  (
    i_Testing_Number varchar2,
    i_Question_Id    number
  ) is
  begin
    Error(i_Code    => '039',
          i_Message => t('039:message:answer type is not writing, testing number: $1, question id: $2',
                         i_Testing_Number,
                         i_Question_Id),
          i_Title   => t('039:title:write answer found'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_040
  (
    i_Testing_Number varchar2,
    i_Status_Name    varchar2
  ) is
  begin
    Error(i_Code    => '040',
          i_Message => t('040:message:to check answers, status must be checking, testing number: $1, current status: $2',
                         i_Testing_Number,
                         i_Status_Name),
          i_Title   => t('040:title:testing in another status'),
          i_S1      => t('040:solution:change status to checking'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_041
  (
    i_Training_Number varchar2,
    i_Status_Name     varchar2
  ) is
  begin
    Error(i_Code    => '041',
          i_Message => t('041:message:to save training, status must be new, training number: $1, current status: $2',
                         i_Training_Number,
                         i_Status_Name),
          i_Title   => t('041:title:training in another status'),
          i_S1      => t('041:solution:change status to new'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_042
  (
    i_Training_Number varchar2,
    i_Status_Name     varchar2
  ) is
  begin
    Error(i_Code    => '042',
          i_Message => t('042:message:to delete training, status must be new, training number: $1, current status: $2',
                         i_Training_Number,
                         i_Status_Name),
          i_Title   => t('042:title:training in another status'),
          i_S1      => t('042:solution:change status to new'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_043
  (
    i_Training_Number varchar2,
    i_Status_Name     varchar2
  ) is
  begin
    Error(i_Code    => '043',
          i_Message => t('043:message:to assess person in training, status must be execute, training number: $1, current status: $2',
                         i_Training_Number,
                         i_Status_Name),
          i_Title   => t('043:title:training in another status'),
          i_S1      => t('043:solution:change status to execute'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_044
  (
    i_Training_Number varchar2,
    i_Status_Name     varchar2
  ) is
  begin
    Error(i_Code    => '044',
          i_Message => t('044:message:to set new in training, status must be executed, training number: $1, current status: $2',
                         i_Training_Number,
                         i_Status_Name),
          i_Title   => t('044:title:training in another status'),
          i_S1      => t('044:solution:change status to executed'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_045
  (
    i_Training_Number varchar2,
    i_Status_Name     varchar2
  ) is
  begin
    Error(i_Code    => '045',
          i_Message => t('045:message:to execute training, status must be finished, training number: $1, current status: $2',
                         i_Training_Number,
                         i_Status_Name),
          i_Title   => t('045:title:training in another status'),
          i_S1      => t('045:solution:change status to finished'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_046(i_Training_Number varchar2) is
  begin
    Error(i_Code    => '046',
          i_Message => t('046:message:to finish training, all persons must be checked, training number: $1',
                         i_Training_Number),
          i_Title   => t('046:title:found unchecked persons'));
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Raise_047
  (
    i_Training_Number varchar2,
    i_Status_Name     varchar2
  ) is
  begin
    Error(i_Code    => '047',
          i_Message => t('047:message:to finish training, status must be executed, training number: $1, current status: $2',
                         i_Training_Number,
                         i_Status_Name),
          i_Title   => t('047:title:training in another status'),
          i_S1      => t('047:solution:change status to executed'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_048
  (
    i_Testing_Number       varchar2,
    i_Attached_Person_Name varchar2,
    i_Person_Name          varchar2
  ) is
  begin
    Error(i_Code    => '048',
          i_Message => t('048:message:testing atteched to $1{attached_person_name}, not to $2{person_name}, testing number: $3',
                         i_Attached_Person_Name,
                         i_Person_Name,
                         i_Testing_Number));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_049(i_Name varchar2) is
  begin
    Error(i_Code    => '049',
          i_Message => t('049:message:$1{question_type_name} not found among question types', i_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_050(i_Training_Number varchar2) is
  begin
    Error(i_Code    => '050',
          i_Message => t('050:message:only admin or mentor can assess, training number: $1',
                         i_Training_Number),
          i_Title   => t('050:title:not access to assess'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_051
  (
    i_Training_Number varchar2,
    i_Status_Name     varchar2
  ) is
  begin
    Error(i_Code    => '051',
          i_Message => t('051:message:to assess training, status must be executed, training number: $1, current status: $2',
                         i_Training_Number,
                         i_Status_Name),
          i_Title   => t('051:title:training in another status'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_052 is
  begin
    Error(i_Code => '052', i_Message => t('052:message:you must select at least one subject'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_053 is
  begin
    Error(i_Code    => '053',
          i_Message => t('053:message:testing period change value must be in (Y, N)'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_054
  (
    i_Testing_Number varchar2,
    i_Period_Begin   date,
    i_Period_End     date
  ) is
  begin
    Error(i_Code    => '054',
          i_Message => t('054:message:testing must be begin between period begin and period end, testing number: $1, period begin: $2, period end: $3',
                         i_Testing_Number,
                         i_Period_Begin,
                         i_Period_End),
          i_Title   => t('054:title:you can not start testing in this time'),
          i_S1      => t('054:solution:change period begin and period end time'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_055
  (
    i_Testing_Number varchar2,
    i_Period_Begin   date,
    i_Period_End     date
  ) is
  begin
    Error(i_Code    => '055',
          i_Message => t('055:message:begin time period begin must be less than begin time period end, testing number: $1, begin time: $2, end time: $3',
                         i_Testing_Number,
                         i_Period_Begin,
                         i_Period_End),
          i_Title   => t('055:title:period times are in valid'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_056
  (
    i_Attestation_Number varchar2,
    i_Period_Begin       date,
    i_Period_End         date
  ) is
  begin
    Error(i_Code    => '056',
          i_Message => t('056:message:begin time period begin must be less than begin time period end, attestation number: $1, begin time: $2, end time: $3',
                         i_Attestation_Number,
                         i_Period_Begin,
                         i_Period_End),
          i_Title   => t('056:title:period times are in valid'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_057(i_Exam_Name varchar2) is
  begin
    Error(i_Code    => '057',
          i_Message => t('057:message:if this exam for recruitment, pick kind must be manual, exam name: $1{exam_name}',
                         i_Exam_Name),
          i_Title   => t('057:title:pick kind must be manual'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_058
  (
    i_Exam_Name   varchar2,
    i_Question_Id varchar2
  ) is
  begin
    Error(i_Code    => '058',
          i_Message => t('058:message:find question with file, if this vacancy for recruitment file should not be set in question or in option, exam name: $1{exam_name}, question id: $2{question_id}',
                         i_Exam_Name,
                         i_Question_Id),
          i_Title   => t('058:title:question not validate'),
          i_S1      => t('058:solution:find this question, remove all files, in question and in options, and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_059
  (
    i_Exam_Name   varchar2,
    i_Question_Id varchar2
  ) is
  begin
    Error(i_Code    => '059',
          i_Message => t('059:message:if this vacancy for recruitment, options must be less than 4, exam name: $1{exam_name}, question id: $2{question_id}',
                         i_Exam_Name,
                         i_Question_Id),
          i_Title   => t('059:title:question not validate'),
          i_S1      => t('059:solution:find this question, reduce number of options, and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_060
  (
    i_Exam_Name   varchar2,
    i_Question_Id varchar2
  ) is
  begin
    Error(i_Code    => '060',
          i_Message => t('060:message:if this vacancy for recruitment, answer type of question must be Single, exam name: $1{exam_name}, question id: $2{question_id}',
                         i_Exam_Name,
                         i_Question_Id),
          i_Title   => t('060:title:question not validate'),
          i_S1      => t('060:solution:find this question, change answer type to Single, and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_061(i_Exam_Name varchar2) is
  begin
    Error(i_Code    => '061',
          i_Message => t('061:message:old exam was for recrutiment, new exam is not, you can not edit if its already set for recruitment, exam name: $1{exam_name}',
                         i_Exam_Name),
          i_Title   => t('061:title:you can not update exam'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_062(i_Subject_Group_Name varchar2) is
  begin
    Error(i_Code    => '062',
          i_Message => t('062:message:subjects not found for this subject group, subject group name: $1',
                         i_Subject_Group_Name),
          i_Title   => t('062:title:subjects not found'));
  end;

end Hln_Error;
/
