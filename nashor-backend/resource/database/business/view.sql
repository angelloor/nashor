-- View: business.view_area_inner_join
-- DROP VIEW business.view_area_inner_join;

CREATE OR REPLACE VIEW business.view_area_inner_join
 AS
 SELECT bva.id_area,
    bva.id_company,
    bva.name_area,
    bva.description_area,
    bva.deleted_area,
    cvc.id_setting,
    cvc.name_company,
    cvc.acronym_company,
    cvc.address_company,
    cvc.status_company
   FROM business.view_area bva
     JOIN core.view_company cvc ON bva.id_company = cvc.id_company
  WHERE bva.deleted_area = false
  ORDER BY bva.id_area DESC;

ALTER TABLE business.view_area_inner_join
    OWNER TO postgres;

-- View: business.view_position_inner_join
-- DROP VIEW business.view_position_inner_join;

CREATE OR REPLACE VIEW business.view_position_inner_join
 AS
 SELECT bvp.id_position,
    bvp.id_company,
    bvp.name_position,
    bvp.description_position,
    bvp.deleted_position,
    cvc.id_setting,
    cvc.name_company,
    cvc.acronym_company,
    cvc.address_company,
    cvc.status_company
   FROM business.view_position bvp
     JOIN core.view_company cvc ON bvp.id_company = cvc.id_company
  WHERE bvp.deleted_position = false
  ORDER BY bvp.id_position DESC;

ALTER TABLE business.view_position_inner_join
    OWNER TO postgres;

-- View: business.view_official_inner_join
-- DROP VIEW business.view_official_inner_join;

CREATE OR REPLACE VIEW business.view_official_inner_join
 AS
 SELECT bvo.id_official,
    bvo.id_company,
    bvo.id_user,
    bvo.id_area,
    bvo.id_position,
    bvo.deleted_official,
    cvc.id_setting,
    cvc.name_company,
    cvc.acronym_company,
    cvc.address_company,
    cvc.status_company,
    cvu.id_person,
    cvu.id_type_user,
    cvu.name_user,
    cvu.password_user,
    cvu.avatar_user,
    cvu.status_user,
    bva.name_area,
    bva.description_area,
    bvp.name_position,
    bvp.description_position,
    cvp.id_academic,
    cvp.id_job,
    cvp.dni_person,
    cvp.name_person,
    cvp.last_name_person,
    cvp.address_person,
    cvp.phone_person,
    cvtu.id_profile,
    cvtu.name_type_user,
    cvtu.description_type_user,
    cvtu.status_type_user,
    cva.title_academic,
    cva.abbreviation_academic,
    cva.nivel_academic,
    cvj.name_job,
    cvj.address_job,
    cvj.phone_job,
    cvj.position_job
   FROM business.view_official bvo
     JOIN core.view_company cvc ON bvo.id_company = cvc.id_company
     JOIN core.view_user cvu ON bvo.id_user = cvu.id_user
     JOIN core.view_person cvp ON cvu.id_person = cvp.id_person
     JOIN core.view_academic cva ON cvp.id_academic = cva.id_academic
     JOIN core.view_job cvj ON cvp.id_job = cvj.id_job
     JOIN core.view_type_user cvtu ON cvu.id_type_user = cvtu.id_type_user
     JOIN business.view_area bva ON bvo.id_area = bva.id_area
     JOIN business.view_position bvp ON bvo.id_position = bvp.id_position
  WHERE bvo.deleted_official = false
  ORDER BY bvo.id_official DESC;

ALTER TABLE business.view_official_inner_join
    OWNER TO postgres;
  
-- View: business.view_attached_inner_join
-- DROP VIEW business.view_attached_inner_join;

CREATE OR REPLACE VIEW business.view_attached_inner_join
 AS
 SELECT bva.id_attached,
    bva.id_company,
    bva.name_attached,
    bva.description_attached,
    bva.length_mb_attached,
    bva.required_attached,
    bva.deleted_attached,
    cvc.id_setting,
    cvc.name_company,
    cvc.acronym_company,
    cvc.address_company,
    cvc.status_company
   FROM business.view_attached bva
     JOIN core.view_company cvc ON bva.id_company = cvc.id_company
  WHERE bva.deleted_attached = false
  ORDER BY bva.id_attached DESC;

ALTER TABLE business.view_attached_inner_join
    OWNER TO postgres;

-- View: business.view_documentation_profile_inner_join
-- DROP VIEW business.view_documentation_profile_inner_join;

CREATE OR REPLACE VIEW business.view_documentation_profile_inner_join
 AS
 SELECT bvdp.id_documentation_profile,
    bvdp.id_company,
    bvdp.name_documentation_profile,
    bvdp.description_documentation_profile,
    bvdp.status_documentation_profile,
    bvdp.deleted_documentation_profile,
    cvc.id_setting,
    cvc.name_company,
    cvc.acronym_company,
    cvc.address_company,
    cvc.status_company
   FROM business.view_documentation_profile bvdp
     JOIN core.view_company cvc ON bvdp.id_company = cvc.id_company
  WHERE bvdp.deleted_documentation_profile = false
  ORDER BY bvdp.id_documentation_profile DESC;

ALTER TABLE business.view_documentation_profile_inner_join
    OWNER TO postgres;
  
-- View: business.view_documentation_profile_attached_inner_join
-- DROP VIEW business.view_documentation_profile_attached_inner_join;

CREATE OR REPLACE VIEW business.view_documentation_profile_attached_inner_join
 AS
 SELECT bvdpa.id_documentation_profile_attached,
    bvdpa.id_documentation_profile,
    bvdpa.id_attached,
    bvdp.name_documentation_profile,
    bvdp.description_documentation_profile,
    bvdp.status_documentation_profile,
    bva.name_attached,
    bva.description_attached,
    bva.length_mb_attached,
    bva.required_attached
   FROM business.view_documentation_profile_attached bvdpa
     JOIN business.view_documentation_profile bvdp ON bvdpa.id_documentation_profile = bvdp.id_documentation_profile
     JOIN business.view_attached bva ON bvdpa.id_attached = bva.id_attached
  ORDER BY bvdpa.id_documentation_profile_attached DESC;

ALTER TABLE business.view_documentation_profile_attached_inner_join
    OWNER TO postgres;
  
-- View: business.view_item_category_inner_join
-- DROP VIEW business.view_item_category_inner_join;

CREATE OR REPLACE VIEW business.view_item_category_inner_join
 AS
 SELECT bvic.id_item_category,
    bvic.id_company,
    bvic.name_item_category,
    bvic.description_item_category,
    bvic.deleted_item_category,
    cvc.id_setting,
    cvc.name_company,
    cvc.acronym_company,
    cvc.address_company,
    cvc.status_company
   FROM business.view_item_category bvic
     JOIN core.view_company cvc ON bvic.id_company = cvc.id_company
  WHERE bvic.deleted_item_category = false
  ORDER BY bvic.id_item_category DESC;

ALTER TABLE business.view_item_category_inner_join
    OWNER TO postgres;

-- View: business.view_item_inner_join
-- DROP VIEW business.view_item_inner_join;

CREATE OR REPLACE VIEW business.view_item_inner_join
 AS
 SELECT bvi.id_item,
    bvi.id_company,
    bvi.id_item_category,
    bvi.name_item,
    bvi.description_item,
    bvi.cpc_item,
    bvi.deleted_item,
    cvc.id_setting,
    cvc.name_company,
    cvc.acronym_company,
    cvc.address_company,
    cvc.status_company,
    bvic.name_item_category,
    bvic.description_item_category
   FROM business.view_item bvi
     JOIN core.view_company cvc ON bvi.id_company = cvc.id_company
     JOIN business.view_item_category bvic ON bvi.id_item_category = bvic.id_item_category
  WHERE bvi.deleted_item = false
  ORDER BY bvi.id_item DESC;

ALTER TABLE business.view_item_inner_join
    OWNER TO postgres;

-- View: business.view_control_inner_join
-- DROP VIEW business.view_control_inner_join;

CREATE OR REPLACE VIEW business.view_control_inner_join
 AS
 SELECT bvc.id_control,
    bvc.id_company,
    bvc.type_control,
    bvc.title_control,
    bvc.form_name_control,
    bvc.initial_value_control,
    bvc.required_control,
    bvc.min_length_control,
    bvc.max_length_control,
    bvc.placeholder_control,
    bvc.spell_check_control,
    bvc.options_control,
    bvc.in_use,
    bvc.deleted_control,
    cvc.id_setting,
    cvc.name_company,
    cvc.acronym_company,
    cvc.address_company,
    cvc.status_company
   FROM business.view_control bvc
     JOIN core.view_company cvc ON bvc.id_company = cvc.id_company
  WHERE bvc.deleted_control = false
  ORDER BY bvc.id_control DESC;

ALTER TABLE business.view_control_inner_join
    OWNER TO postgres;

-- View: business.view_template_inner_join
-- DROP VIEW business.view_template_inner_join;

CREATE OR REPLACE VIEW business.view_template_inner_join
 AS
 SELECT bvt.id_template,
    bvt.id_company,
    bvt.id_documentation_profile,
    bvt.plugin_item_process,
    bvt.plugin_attached_process,
    bvt.name_template,
    bvt.description_template,
    bvt.status_template,
    bvt.last_change,
    bvt.in_use,
    bvt.deleted_template,
    cvc.id_setting,
    cvc.name_company,
    cvc.acronym_company,
    cvc.address_company,
    cvc.status_company,
    bvdp.name_documentation_profile,
    bvdp.description_documentation_profile,
    bvdp.status_documentation_profile
   FROM business.view_template bvt
     JOIN core.view_company cvc ON bvt.id_company = cvc.id_company
     JOIN business.view_documentation_profile bvdp ON bvt.id_documentation_profile = bvdp.id_documentation_profile
  WHERE bvt.deleted_template = false
  ORDER BY bvt.id_template DESC;

ALTER TABLE business.view_template_inner_join
    OWNER TO postgres;

-- View: business.view_template_control_inner_join
-- DROP VIEW business.view_template_control_inner_join;

CREATE OR REPLACE VIEW business.view_template_control_inner_join
 AS
 SELECT bvtc.id_template_control,
    bvtc.id_template,
    bvtc.id_control,
    bvtc.ordinal_position,
    bvt.id_documentation_profile,
    bvt.plugin_item_process,
    bvt.plugin_attached_process,
    bvt.name_template,
    bvt.description_template,
    bvt.status_template,
    bvt.last_change,
    bvc.type_control,
    bvc.title_control,
    bvc.form_name_control,
    bvc.initial_value_control,
    bvc.required_control,
    bvc.min_length_control,
    bvc.max_length_control,
    bvc.placeholder_control,
    bvc.spell_check_control,
    bvc.options_control,
	 bvc.in_use,
    bvco.id_company
   FROM business.view_template_control bvtc
     JOIN business.view_template bvt ON bvtc.id_template = bvt.id_template
     JOIN business.view_control bvc ON bvtc.id_control = bvc.id_control
     join core.view_company bvco ON bvt.id_company = bvco.id_company
  ORDER BY bvtc.id_template_control DESC;

ALTER TABLE business.view_template_control_inner_join
    OWNER TO postgres;
  
-- View: business.view_process_type_inner_join
-- DROP VIEW business.view_process_type_inner_join;

CREATE OR REPLACE VIEW business.view_process_type_inner_join
 AS
 SELECT bvpt.id_process_type,
    bvpt.id_company,
    bvpt.name_process_type,
    bvpt.description_process_type,
    bvpt.acronym_process_type,
    bvpt.sequential_process_type,
    bvpt.deleted_process_type,
    cvc.id_setting,
    cvc.name_company,
    cvc.acronym_company,
    cvc.address_company,
    cvc.status_company
   FROM business.view_process_type bvpt
     JOIN core.view_company cvc ON bvpt.id_company = cvc.id_company
  WHERE bvpt.deleted_process_type = false
  ORDER BY bvpt.id_process_type DESC;

ALTER TABLE business.view_process_type_inner_join
    OWNER TO postgres;

-- View: business.view_level_status_inner_join
-- DROP VIEW business.view_level_status_inner_join;

CREATE OR REPLACE VIEW business.view_level_status_inner_join
 AS
 SELECT bvls.id_level_status,
    bvls.id_company,
    bvls.name_level_status,
    bvls.description_level_status,
    bvls.color_level_status,
    bvls.deleted_level_status,
    cvc.id_setting,
    cvc.name_company,
    cvc.acronym_company,
    cvc.address_company,
    cvc.status_company
   FROM business.view_level_status bvls
     JOIN core.view_company cvc ON bvls.id_company = cvc.id_company
  WHERE bvls.deleted_level_status = false
  ORDER BY bvls.id_level_status DESC;

ALTER TABLE business.view_level_status_inner_join
    OWNER TO postgres;

-- View: business.view_level_profile_inner_join
-- DROP VIEW business.view_level_profile_inner_join;

CREATE OR REPLACE VIEW business.view_level_profile_inner_join
 AS
 SELECT bvlp.id_level_profile,
    bvlp.id_company,
    bvlp.name_level_profile,
    bvlp.description_level_profile,
    bvlp.deleted_level_profile,
    cvc.id_setting,
    cvc.name_company,
    cvc.acronym_company,
    cvc.address_company,
    cvc.status_company
   FROM business.view_level_profile bvlp
     JOIN core.view_company cvc ON bvlp.id_company = cvc.id_company
  WHERE bvlp.deleted_level_profile = false
  ORDER BY bvlp.id_level_profile DESC;

ALTER TABLE business.view_level_profile_inner_join
    OWNER TO postgres;

-- View: business.view_level_profile_official_inner_join
-- DROP VIEW business.view_level_profile_official_inner_join;

CREATE OR REPLACE VIEW business.view_level_profile_official_inner_join
 AS
 SELECT bvlpo.id_level_profile_official,
    bvlpo.id_level_profile,
    bvlpo.id_official,
    bvlpo.official_modifier,
    bvlp.name_level_profile,
    bvlp.description_level_profile,
    bvo.id_user,
    bvo.id_area,
    bvo.id_position,
    cvu.id_person, 
    cvu.id_type_user, 
    cvu.name_user, 
    cvu.password_user, 
    cvu.avatar_user, 
    cvu.status_user, 
    cvp.id_academic, 
    cvp.id_job, 
    cvp.dni_person, 
    cvp.name_person, 
    cvp.last_name_person, 
    cvp.address_person, 
    cvp.phone_person
   FROM business.view_level_profile_official bvlpo
     JOIN business.view_level_profile bvlp ON bvlpo.id_level_profile = bvlp.id_level_profile
     JOIN business.view_official bvo ON bvlpo.id_official = bvo.id_official
	   JOIN core.view_user cvu on bvo.id_user = cvu.id_user
	   JOIN core.view_person cvp on cvu.id_person = cvp.id_person
  ORDER BY bvlpo.id_level_profile_official DESC;

ALTER TABLE business.view_level_profile_official_inner_join
    OWNER TO postgres;

-- View: business.view_level_inner_join
-- DROP VIEW business.view_level_inner_join;

CREATE OR REPLACE VIEW business.view_level_inner_join
 AS
 SELECT bvl.id_level,
    bvl.id_company,
    bvl.id_template,
    bvl.id_level_profile,
    bvl.id_level_status,
    bvl.name_level,
    bvl.description_level,
    bvl.deleted_level,
    cvc.id_setting,
    cvc.name_company,
    cvc.acronym_company,
    cvc.address_company,
    cvc.status_company,
    bvt.id_documentation_profile,
    bvt.plugin_item_process,
    bvt.plugin_attached_process,
    bvt.name_template,
    bvt.description_template,
    bvt.status_template,
    bvt.last_change,
    bvt.in_use,
    bvlp.name_level_profile,
    bvlp.description_level_profile,
    bvls.name_level_status,
    bvls.description_level_status,
    bvls.color_level_status
   FROM business.view_level bvl
     JOIN core.view_company cvc ON bvl.id_company = cvc.id_company
     JOIN business.view_template bvt ON bvl.id_template = bvt.id_template
     JOIN business.view_level_profile bvlp ON bvl.id_level_profile = bvlp.id_level_profile
     JOIN business.view_level_status bvls ON bvl.id_level_status = bvls.id_level_status
  WHERE bvl.deleted_level = false
  ORDER BY bvl.id_level DESC;

ALTER TABLE business.view_level_inner_join
    OWNER TO postgres;

-- View: business.view_flow_inner_join
-- DROP VIEW business.view_flow_inner_join;

CREATE OR REPLACE VIEW business.view_flow_inner_join
 AS
 SELECT bvf.id_flow,
    bvf.id_company,
    bvf.id_process_type,
    bvf.name_flow,
    bvf.description_flow,
    bvf.deleted_flow,
    cvc.id_setting,
    cvc.name_company,
    cvc.acronym_company,
    cvc.address_company,
    cvc.status_company,
    bvpt.name_process_type,
    bvpt.description_process_type,
    bvpt.acronym_process_type,
    bvpt.sequential_process_type
   FROM business.view_flow bvf
     JOIN core.view_company cvc ON bvf.id_company = cvc.id_company
     JOIN business.view_process_type bvpt ON bvf.id_process_type = bvpt.id_process_type
  WHERE bvf.deleted_flow = false
  ORDER BY bvf.id_flow DESC;

ALTER TABLE business.view_flow_inner_join
    OWNER TO postgres;

-- View: business.view_flow_version_inner_join
-- DROP VIEW business.view_flow_version_inner_join;

CREATE OR REPLACE VIEW business.view_flow_version_inner_join
 AS
 SELECT bvfv.id_flow_version,
    bvfv.id_flow,
    bvfv.number_flow_version,
    bvfv.status_flow_version,
    bvfv.creation_date_flow_version,
    bvfv.deleted_flow_version,
    bvf.id_company,
    bvf.id_process_type,
    bvf.name_flow,
    bvf.description_flow
   FROM business.view_flow_version bvfv
     JOIN business.view_flow bvf ON bvfv.id_flow = bvf.id_flow
  WHERE bvfv.deleted_flow_version = false
  ORDER BY bvfv.id_flow_version DESC;

ALTER TABLE business.view_flow_version_inner_join
    OWNER TO postgres;

-- View: business.view_flow_version_level_inner_join
-- DROP VIEW business.view_flow_version_level_inner_join;

CREATE OR REPLACE VIEW business.view_flow_version_level_inner_join
 AS
 SELECT bvfvl.id_flow_version_level,
    bvfvl.id_flow_version,
    bvfvl.id_level,
    bvfvl.position_level,
    bvfvl.is_level,
    bvfvl.is_go,
    bvfvl.is_finish,
    bvfvl.is_conditional,
    bvfvl.type_conditional,
    bvfvl.expression,
    bvfv.id_flow,
    bvfv.number_flow_version,
    bvfv.status_flow_version,
    bvfv.creation_date_flow_version,
    bvl.id_company,
    bvl.id_template,
    bvl.id_level_profile,
    bvl.id_level_status,
    bvl.name_level,
    bvl.description_level
   FROM business.view_flow_version_level bvfvl
     JOIN business.view_flow_version bvfv ON bvfvl.id_flow_version = bvfv.id_flow_version
     JOIN business.view_level bvl ON bvfvl.id_level = bvl.id_level
  ORDER BY bvfvl.id_flow_version_level DESC;

ALTER TABLE business.view_flow_version_level_inner_join
    OWNER TO postgres;

-- View: business.view_process_inner_join
-- DROP VIEW business.view_process_inner_join;

CREATE OR REPLACE VIEW business.view_process_inner_join
 AS
 SELECT bvp.id_process,
    bvp.id_process_type,
    bvp.id_official,
    bvp.id_flow_version,
    bvp.number_process,
    bvp.date_process,
    bvp.generated_task,
    bvp.finalized_process,
    bvp.deleted_process,
    bvpt.name_process_type,
    bvpt.description_process_type,
    bvpt.acronym_process_type,
    bvpt.sequential_process_type,
    bvo.id_user,
    bvo.id_area,
    bvo.id_position,
    bvfv.id_flow,
    bvfv.number_flow_version,
    bvfv.status_flow_version,
    bvfv.creation_date_flow_version
   FROM business.view_process bvp
     JOIN business.view_process_type bvpt ON bvp.id_process_type = bvpt.id_process_type
     JOIN business.view_official bvo ON bvp.id_official = bvo.id_official
     JOIN business.view_flow_version bvfv ON bvp.id_flow_version = bvfv.id_flow_version
  WHERE bvp.deleted_process = false
  ORDER BY bvp.id_process DESC;

ALTER TABLE business.view_process_inner_join
    OWNER TO postgres;



