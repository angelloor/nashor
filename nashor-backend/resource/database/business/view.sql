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
    cva.level_academic,
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

-- View: business.view_plugin_item_inner_join
-- DROP VIEW business.view_plugin_item_inner_join;

CREATE OR REPLACE VIEW business.view_plugin_item_inner_join
 AS
 SELECT bvpi.id_plugin_item,
    bvpi.id_company,
    bvpi.name_plugin_item,
    bvpi.description_plugin_item,
    bvpi.select_plugin_item,
    cvc.id_setting,
    cvc.name_company,
    cvc.acronym_company,
    cvc.address_company,
    cvc.status_company
   FROM business.view_plugin_item bvpi
     JOIN core.view_company cvc ON bvpi.id_company = cvc.id_company
  ORDER BY bvpi.id_plugin_item DESC;

ALTER TABLE business.view_plugin_item_inner_join
    OWNER TO postgres;

-- View: business.view_template_inner_join
-- DROP VIEW business.view_template_inner_join;

CREATE OR REPLACE VIEW business.view_template_inner_join
 AS
 SELECT bvt.id_template,
    bvt.id_company,
    bvt.id_documentation_profile,
    bvt.id_plugin_item,
    bvt.plugin_attached_process,
    bvt.plugin_item_process,
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
    bvt.id_plugin_item,
    bvt.plugin_attached_process,
    bvt.plugin_item_process,
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
  
-- View: business.view_flow_inner_join
-- DROP VIEW business.view_flow_inner_join;

CREATE OR REPLACE VIEW business.view_flow_inner_join
 AS
 SELECT bvf.id_flow,
    bvf.id_company,
    bvf.name_flow,
    bvf.description_flow,
    bvf.acronym_flow,
    bvf.acronym_task,
    bvf.sequential_flow,
    bvf.deleted_flow,
    cvc.id_setting,
    cvc.name_company,
    cvc.acronym_company,
    cvc.address_company,
    cvc.status_company
   FROM business.view_flow bvf
     JOIN core.view_company cvc ON bvf.id_company = cvc.id_company
  WHERE bvf.deleted_flow = false
  ORDER BY bvf.id_flow DESC;

ALTER TABLE business.view_flow_inner_join
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
 SELECT (( SELECT count(*) AS count
           FROM business.view_task bvt
          WHERE bvt.id_official = bvlpo.id_official AND bvt.type_status_task = 'progress'::business."TYPE_STATUS_TASK"))::numeric AS number_task,
    bvlpo.id_level_profile_official,
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
     JOIN core.view_user cvu ON bvo.id_user = cvu.id_user
     JOIN core.view_person cvp ON cvu.id_person = cvp.id_person
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
    bvt.id_plugin_item,
    bvt.plugin_attached_process,
    bvt.plugin_item_process,
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
    bvf.name_flow,
    bvf.description_flow
   FROM business.view_flow_version bvfv
     JOIN business.view_flow bvf ON bvfv.id_flow = bvf.id_flow
  WHERE bvfv.deleted_flow_version = false
  ORDER BY bvfv.id_flow_version DESC;

ALTER TABLE business.view_flow_version_inner_join
    OWNER TO postgres;

-- View: business.view_flow_version_level_inner_join
-- View: business.view_flow_version_level_inner_join
-- DROP VIEW business.view_flow_version_level_inner_join;

CREATE OR REPLACE VIEW business.view_flow_version_level_inner_join
 AS
 SELECT bvfvl.id_flow_version_level,
    bvfvl.id_flow_version,
    bvfvl.id_level,
    bvfvl.position_level,
    bvfvl.position_level_father,
    bvfvl.type_element,
    bvfvl.id_control,
    bvfvl.operator,
    bvfvl.value_against,
    bvfvl.option_true,
    bvfvl.x,
    bvfvl.y,
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
-- 

CREATE OR REPLACE VIEW business.view_process_inner_join
 AS
 SELECT bvp.id_process,
    bvp.id_official,
    bvp.id_flow_version,
    bvp.number_process,
    bvp.date_process,
    bvp.generated_task,
    bvp.finalized_process,
    bvp.deleted_process,
    bvo.id_user,
    bvo.id_area,
    bvo.id_position,
    bvfv.number_flow_version,
    bvfv.status_flow_version,
    bvfv.creation_date_flow_version,
    bvf.id_flow,
    bvf.name_flow,
    bvf.description_flow,
    bvf.acronym_flow,
    bvf.acronym_task,
    bvf.sequential_flow
   FROM business.view_process bvp
     JOIN business.view_official bvo ON bvp.id_official = bvo.id_official
     JOIN business.view_flow_version bvfv ON bvp.id_flow_version = bvfv.id_flow_version
	 JOIN business.view_flow bvf ON bvfv.id_flow = bvf.id_flow
  WHERE bvp.deleted_process = false
  ORDER BY bvp.id_process DESC;

ALTER TABLE business.view_process_inner_join
    OWNER TO postgres;

-- View: business.view_control_inner_join_bvt_bvtc_bvc
-- DROP VIEW business.view_control_inner_join_bvt_bvtc_bvc;

CREATE OR REPLACE VIEW business.view_control_inner_join_bvt_bvtc_bvc
 AS
 SELECT bvl.id_level, 
 	bvc.id_control,
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
    bvc.deleted_control
   FROM business.view_level bvl
     JOIN business.view_template bvt ON bvl.id_template = bvt.id_template
     JOIN business.view_template_control bvtc ON bvt.id_template = bvtc.id_template
     JOIN business.view_control bvc ON bvtc.id_control = bvc.id_control
  ORDER BY bvc.id_control DESC;

ALTER TABLE business.view_control_inner_join_bvt_bvtc_bvc
    OWNER TO postgres;

-- View: business.view_task_inner_join
-- DROP VIEW business.view_task_inner_join;

CREATE OR REPLACE VIEW business.view_task_inner_join
 AS
 SELECT bvt.id_task,
    bvt.id_process,
    bvt.id_official,
    bvt.id_level,
    bvt.number_task,
    bvt.creation_date_task,
    bvt.type_status_task,
    bvt.type_action_task,
    bvt.action_date_task,
    bvt.deleted_task,
    bvp.id_flow_version,
    bvp.number_process,
    bvp.date_process,
    bvp.generated_task,
    bvp.finalized_process,
    bvo.id_user,
    bvo.id_area,
    bvo.id_position,
    bvl.id_template,
    bvl.id_level_profile,
    bvl.id_level_status,
    bvl.name_level,
    bvl.description_level,
    bvfv.id_flow,
    bvfv.number_flow_version,
    bvfv.status_flow_version,
    bvfv.creation_date_flow_version,
    bvf.id_company,
    bvf.name_flow,
    bvf.description_flow,
    bvf.acronym_flow,
    bvf.acronym_task,
    bvf.sequential_flow
   FROM business.view_task bvt
     JOIN business.view_process bvp ON bvt.id_process = bvp.id_process
     JOIN business.view_flow_version bvfv ON bvp.id_flow_version = bvfv.id_flow_version
     JOIN business.view_flow bvf ON bvfv.id_flow = bvf.id_flow
     JOIN business.view_official bvo ON bvt.id_official = bvo.id_official
     JOIN business.view_level bvl ON bvt.id_level = bvl.id_level
  WHERE bvt.deleted_task = false
  ORDER BY bvt.id_task DESC;

ALTER TABLE business.view_task_inner_join
    OWNER TO postgres;

-- View: business.view_process_item_inner_join
-- DROP VIEW business.view_process_item_inner_join;

CREATE OR REPLACE VIEW business.view_process_item_inner_join
 AS
 SELECT bvpi.id_process_item,
    bvpi.id_official,
    bvpi.id_process,
    bvpi.id_task,
    bvpi.id_level,
    bvpi.id_item,
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
    cvp.phone_person,
    bvp.id_flow_version,
    bvp.number_process,
    bvp.date_process,
    bvp.generated_task,
    bvp.finalized_process,
    bvt.number_task,
    bvt.creation_date_task,
    bvt.type_status_task,
    bvt.type_action_task,
    bvt.action_date_task,
    bvl.id_template,
    bvl.id_level_profile,
    bvl.id_level_status,
    bvl.name_level,
    bvl.description_level,
    bvi.id_item_category,
    bvi.name_item,
    bvi.description_item
   FROM business.view_process_item bvpi
     JOIN business.view_official bvo ON bvpi.id_official = bvo.id_official
     JOIN core.view_user cvu ON bvo.id_user = cvu.id_user
     JOIN core.view_person cvp ON cvu.id_person = cvp.id_person
     JOIN business.view_process bvp ON bvpi.id_process = bvp.id_process
     JOIN business.view_task bvt ON bvpi.id_task = bvt.id_task
     JOIN business.view_level bvl ON bvpi.id_level = bvl.id_level
     JOIN business.view_item bvi ON bvpi.id_item = bvi.id_item
  ORDER BY bvpi.id_process_item DESC;

ALTER TABLE business.view_process_item_inner_join
    OWNER TO postgres;

-- View: business.view_column_process_item_inner_join
-- DROP VIEW business.view_column_process_item_inner_join;

CREATE OR REPLACE VIEW business.view_column_process_item_inner_join
 AS
 SELECT bvcpi.id_column_process_item,
    bvcpi.id_plugin_item_column,
    bvcpi.id_process_item,
    bvcpi.value_column_process_item,
    bvcpi.entry_date_column_process_item,
    bvpic.id_plugin_item,
    bvpic.name_plugin_item_column,
    bvpic.lenght_plugin_item_column,
    bvpi.id_official,
    bvpi.id_process,
    bvpi.id_task,
    bvpi.id_level,
    bvpi.id_item
   FROM business.view_column_process_item bvcpi
     JOIN business.view_plugin_item_column bvpic ON bvcpi.id_plugin_item_column = bvpic.id_plugin_item_column
     JOIN business.view_process_item bvpi ON bvcpi.id_process_item = bvpi.id_process_item
  ORDER BY bvcpi.id_column_process_item DESC;

ALTER TABLE business.view_column_process_item_inner_join
    OWNER TO postgres;

-- View: business.view_process_attached_inner_join
-- DROP VIEW business.view_process_attached_inner_join;

CREATE OR REPLACE VIEW business.view_process_attached_inner_join
 AS
 SELECT bvpa.id_process_attached,
    bvpa.id_official,
    bvpa.id_process,
    bvpa.id_task,
    bvpa.id_level,
    bvpa.id_attached,
    bvpa.file_name,
    bvpa.length_mb,
    bvpa.extension,
    bvpa.server_path,
    bvpa.alfresco_path,
    bvpa.upload_date,
    bvpa.deleted_process_attached,
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
    cvp.phone_person,
    bvp.id_flow_version,
    bvp.number_process,
    bvp.date_process,
    bvp.generated_task,
    bvp.finalized_process,
    bvt.number_task,
    bvt.creation_date_task,
    bvt.type_status_task,
    bvt.type_action_task,
    bvt.action_date_task,
    bvl.id_template,
    bvl.id_level_profile,
    bvl.id_level_status,
    bvl.name_level,
    bvl.description_level,
    bva.name_attached,
    bva.description_attached,
    bva.length_mb_attached,
    bva.required_attached
   FROM business.view_process_attached bvpa
     JOIN business.view_official bvo ON bvpa.id_official = bvo.id_official
     JOIN core.view_user cvu ON bvo.id_user = cvu.id_user
     JOIN core.view_person cvp ON cvu.id_person = cvp.id_person
     JOIN business.view_process bvp ON bvpa.id_process = bvp.id_process
     JOIN business.view_task bvt ON bvpa.id_task = bvt.id_task
     JOIN business.view_level bvl ON bvpa.id_level = bvl.id_level
     JOIN business.view_attached bva ON bvpa.id_attached = bva.id_attached
  WHERE bvpa.deleted_process_attached = false
  ORDER BY bvpa.id_process_attached DESC;

ALTER TABLE business.view_process_attached_inner_join
    OWNER TO postgres;

-- View: business.view_process_control_inner_join
-- DROP VIEW business.view_process_control_inner_join;

CREATE OR REPLACE VIEW business.view_process_control_inner_join
 AS
 SELECT bvpc.id_process_control,
    bvpc.id_official,
    bvpc.id_process,
    bvpc.id_task,
    bvpc.id_level,
    bvpc.id_control,
    bvpc.value_process_control,
    bvpc.last_change_process_control,
    bvpc.deleted_process_control,
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
    cvp.phone_person,
    bvp.id_flow_version,
    bvp.number_process,
    bvp.date_process,
    bvp.generated_task,
    bvp.finalized_process,
    bvt.number_task,
    bvt.creation_date_task,
    bvt.type_status_task,
    bvt.type_action_task,
    bvt.action_date_task,
    bvl.id_template,
    bvl.id_level_profile,
    bvl.id_level_status,
    bvl.name_level,
    bvl.description_level,
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
    bvc.in_use
   FROM business.view_process_control bvpc
     JOIN business.view_official bvo ON bvpc.id_official = bvo.id_official
     JOIN core.view_user cvu ON bvo.id_user = cvu.id_user
     JOIN core.view_person cvp ON cvu.id_person = cvp.id_person
     JOIN business.view_process bvp ON bvpc.id_process = bvp.id_process
     JOIN business.view_task bvt ON bvpc.id_task = bvt.id_task
     JOIN business.view_level bvl ON bvpc.id_level = bvl.id_level
     JOIN business.view_control bvc ON bvpc.id_control = bvc.id_control
  WHERE bvpc.deleted_process_control = false
  ORDER BY bvpc.id_process_control DESC;

ALTER TABLE business.view_process_control_inner_join
    OWNER TO postgres;

-- View: business.view_process_comment_inner_join
-- DROP VIEW business.view_process_comment_inner_join;

CREATE OR REPLACE VIEW business.view_process_comment_inner_join
 AS
 SELECT bvpc.id_process_comment,
    bvpc.id_official,
    bvpc.id_process,
    bvpc.id_task,
    bvpc.id_level,
    bvpc.value_process_comment,
    bvpc.date_process_comment,
    bvpc.deleted_process_comment,
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
    cvp.phone_person,
    bvp.id_flow_version,
    bvp.number_process,
    bvp.date_process,
    bvp.generated_task,
    bvp.finalized_process,
    bvt.number_task,
    bvt.creation_date_task,
    bvt.type_status_task,
    bvt.type_action_task,
    bvt.action_date_task,
    bvl.id_template,
    bvl.id_level_profile,
    bvl.id_level_status,
    bvl.name_level,
    bvl.description_level
   FROM business.view_process_comment bvpc
     JOIN business.view_official bvo ON bvpc.id_official = bvo.id_official
     JOIN core.view_user cvu ON bvo.id_user = cvu.id_user
     JOIN core.view_person cvp ON cvu.id_person = cvp.id_person
     JOIN business.view_process bvp ON bvpc.id_process = bvp.id_process
     JOIN business.view_task bvt ON bvpc.id_task = bvt.id_task
     JOIN business.view_level bvl ON bvpc.id_level = bvl.id_level
  WHERE bvpc.deleted_process_comment = false
  ORDER BY bvpc.id_process_comment DESC;

ALTER TABLE business.view_process_comment_inner_join
    OWNER TO postgres;

  -- View: business.view_plugin_item_column_inner_join
-- DROP VIEW business.view_plugin_item_column_inner_join;

CREATE OR REPLACE VIEW business.view_plugin_item_column_inner_join
 AS
 SELECT bvpic.id_plugin_item_column,
    bvpic.id_plugin_item,
    bvpic.name_plugin_item_column,
    bvpic.lenght_plugin_item_column,
    bvpi.id_company,
    bvpi.name_plugin_item,
    bvpi.description_plugin_item,
    bvpi.select_plugin_item
   FROM business.view_plugin_item_column bvpic
     JOIN business.view_plugin_item bvpi ON bvpic.id_plugin_item = bvpi.id_plugin_item
  ORDER BY bvpic.id_plugin_item_column DESC;

ALTER TABLE business.view_plugin_item_column_inner_join
    OWNER TO postgres;

