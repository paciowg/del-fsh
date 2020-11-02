select
  questions.*,
  trim(hqm.hit_qstn_cd) as loincCode,
  trim(hqm.qstn_map_txt) as loincText
from (
  select
    av.asmt_id,
    av.asmt_vrsn_id,
    asr.asmt_sbst_id,
    aqv.asmt_qstn_id,
    concat(a.asmt_shrt_name, '-', asr.asmt_sbst_shrt_name, '-', aqv.asmt_vrsn_id) as "assessmentId",
    ascr.asmt_sect_id as "sectionId",
    ascr.asmt_sect_name as "sectionName",
    ascr.sect_desc as "sectionDesc",
    lower(der.rspns_dtype_name) as "dataType",
    lower(der.rspns_type_name) as "dataTypeName",
    der.rspns_lngth_amt as "maxLength",
    deq.data_ele_qstn_id as "questionId",
    deq.prnt_data_ele_qstn_id as "parentId",
    regexp_replace(deq.qstn_label_name, '[^a-zA-Z0-9]', '_', 'g') as label,
    deq.qstn_shrt_name as name,
    deq.qstn_txt as text,
    --Get Sort order of questions
    aqv.asmt_qstn_srt_num as asmt_qstn_srt_num
  from
    del_data.asmt_qstn_vrsn aqv
    inner join del_data.asmt_qstn aq on aq.asmt_qstn_id = aqv.asmt_qstn_id
    inner join del_data.asmt_vrsn av on av.asmt_vrsn_id = aqv.asmt_vrsn_id
      and av.asmt_id = aqv.asmt_id
    inner join del_data.asmt a on a.asmt_id = aqv.asmt_id
    inner join del_data.asmt_qstn_sbst aqs on aqs.asmt_qstn_id = aqv.asmt_qstn_id
      and aqs.asmt_id = aqv.asmt_id
      and aqs.asmt_vrsn_id = aqv.asmt_vrsn_id
    inner join del_data.asmt_sbst_rfrnc asr on asr.asmt_sbst_id = aqs.asmt_sbst_id
    inner join del_data.data_ele_qstn deq on deq.data_ele_qstn_id = aq.data_ele_qstn_id
    -- join to get section
    inner join del_data.asmt_sect_rfrnc ascr on ascr.asmt_sect_id = aqv.asmt_sect_id
    -- join to get response type
    left join del_data.data_ele_rspns der on der.data_ele_rspns_id = deq.data_ele_qstn_id
  where
    -- only active questions
    deq.qstn_stus_id = 1
  ) questions
  -- joins for loinc codes
  left join del_data.hit_qstn_map hqm on hqm.asmt_qstn_id = questions.asmt_qstn_id
    and hqm.asmt_id = questions.asmt_id
    and hqm.asmt_vrsn_id = questions.asmt_vrsn_id
  left join del_data.hit_std_vrsn hsv on hsv.hit_std_vrsn_id = hqm.hit_std_vrsn_id
where
--  "assessmentId" = 'FASI-FA-1.1'
 "assessmentId" = $1 and
  "sectionId" = $2

--  and hsv.hit_std_id = 1
order by
  "parentId" nulls first,
    --order by new srt_num after parentId
    asmt_qstn_srt_num
,
  "questionId";
