------------------------------ Custom Views ------------------------------
-- View: core.view_validation_inner_company_user
-- DROP VIEW core.view_validation_inner_company_user;

CREATE OR REPLACE VIEW core.view_validation_inner_company_user
 AS
 SELECT vv.id_validation,
    vv.id_company,
    vv.type_validation,
    vv.status_validation,
    vv.pattern_validation,
    vv.message_validation,
    vv.deleted_validation,
    vu.name_user
   FROM core.view_validation vv
     JOIN core.view_company vc ON vv.id_company = vc.id_company
     JOIN core.view_user vu ON vu.id_company = vc.id_company
  WHERE vv.status_validation = true;

ALTER TABLE core.view_validation_inner_company_user
    OWNER TO postgres;
  
-- View: core.view_user_inner_join_cvc_cvs
-- DROP VIEW core.view_user_inner_join_cvc_cvs;

CREATE OR REPLACE VIEW core.view_user_inner_join_cvc_cvs
 AS
 SELECT cvs.save_log, cvu.id_user, cvu.name_user
   FROM core.view_user cvu
     JOIN core.view_company cvc ON cvu.id_company = cvc.id_company
     JOIN core.view_setting cvs ON cvc.id_setting = cvs.id_setting;

ALTER TABLE core.view_user_inner_join_cvc_cvs
    OWNER TO postgres;

-- View: core.view_user_inner_join_cvc_cvs_cvp_cvtu_cvpro
-- DROP VIEW core.view_user_inner_join_cvc_cvs_cvp_cvtu_cvpro;

CREATE OR REPLACE VIEW core.view_user_inner_join_cvc_cvs_cvp_cvtu_cvpro
 AS
 SELECT vu.id_user,
    vu.id_company,
    vu.id_person,
    vu.id_type_user,
    vu.name_user,
    vu.avatar_user,
    vu.status_user,
    vc.id_setting,
    vc.name_company,
    vc.status_company,
    vs.expiration_token,
    vs.inactivity_time,
    vp.dni_person,
    vp.name_person,
    vp.last_name_person,
    vp.address_person,
    vp.phone_person,
    vtu.id_profile,
    vtu.name_type_user,
    vtu.description_type_user,
    vtu.status_type_user,
    vpr.type_profile,
    vpr.name_profile,
    vpr.description_profile,
    vpr.status_profile
   FROM core.view_user vu
     JOIN core.view_company vc ON vu.id_company = vc.id_company
     JOIN core.view_setting vs ON vc.id_setting = vs.id_setting
     JOIN core.view_person vp ON vu.id_person = vp.id_person
     JOIN core.view_type_user vtu ON vtu.id_type_user = vu.id_type_user
     JOIN core.view_profile vpr ON vpr.id_profile = vtu.id_profile;

ALTER TABLE core.view_user_inner_join_cvc_cvs_cvp_cvtu_cvpro
    OWNER TO postgres;
  
-- View: core.view_navigation_inner_join_cvpn_cvp_cvtu_cvu
-- DROP VIEW core.view_navigation_inner_join_cvpn_cvp_cvtu_cvu;

CREATE OR REPLACE VIEW core.view_navigation_inner_join_cvpn_cvp_cvtu_cvu
 AS
 SELECT vn.id_navigation,
    vn.name_navigation,
    vn.description_navigation,
    vn.type_navigation,
    vn.status_navigation,
    vn.content_navigation,
    vn.deleted_navigation,
    vu.*
   FROM core.view_navigation vn
     JOIN core.view_profile_navigation vpn ON vn.id_navigation = vpn.id_navigation
     JOIN core.view_profile vp ON vp.id_profile = vpn.id_profile
     JOIN core.view_type_user vtu ON vtu.id_profile = vp.id_profile
     JOIN core.view_user vu ON vu.id_type_user = vtu.id_type_user;

ALTER TABLE core.view_navigation_inner_join_cvpn_cvp_cvtu_cvu
    OWNER TO postgres;

------------------------------ Default Views ------------------------------

-- View: core.view_company_inner_join
-- DROP VIEW core.view_company_inner_join;

CREATE OR REPLACE VIEW core.view_company_inner_join
 AS
 SELECT cvc.id_company,
    cvc.id_setting,
    cvc.name_company,
    cvc.acronym_company,
    cvc.address_company,
    cvc.status_company,
    cvc.deleted_company,
    cvs.expiration_token,
    cvs.expiration_verification_code,
    cvs.inactivity_time,
    cvs.session_limit,
    cvs.save_log,
    cvs.save_file_alfresco,
    cvs.modification_status
   FROM core.view_company cvc
     JOIN core.view_setting cvs ON cvc.id_setting = cvs.id_setting
  WHERE cvc.deleted_company = false
  ORDER BY cvc.id_company DESC;

ALTER TABLE core.view_company_inner_join
    OWNER TO postgres;
    
-- View: core.view_validation_inner_join
-- DROP VIEW core.view_validation_inner_join;

CREATE OR REPLACE VIEW core.view_validation_inner_join
 AS
 SELECT cvv.id_validation,
    cvv.id_company,
    cvv.type_validation,
    cvv.status_validation,
    cvv.pattern_validation,
    cvv.message_validation,
    cvv.deleted_validation,
    cvc.id_setting,
    cvc.name_company,
    cvc.acronym_company,
    cvc.address_company,
    cvc.status_company
   FROM core.view_validation cvv
     JOIN core.view_company cvc ON cvv.id_company = cvc.id_company
  WHERE cvv.deleted_validation = false
  ORDER BY cvv.id_validation DESC;

ALTER TABLE core.view_validation_inner_join
    OWNER TO postgres;

-- View: core.view_navigation_inner_join
-- DROP VIEW core.view_navigation_inner_join;

CREATE OR REPLACE VIEW core.view_navigation_inner_join
 AS
 SELECT cvn.id_navigation,
    cvn.id_company,
    cvn.name_navigation,
    cvn.description_navigation,
    cvn.type_navigation,
    cvn.status_navigation,
    cvn.content_navigation,
    cvn.deleted_navigation,
    cvc.id_setting,
    cvc.name_company,
    cvc.acronym_company,
    cvc.address_company,
    cvc.status_company
   FROM core.view_navigation cvn
     JOIN core.view_company cvc ON cvn.id_company = cvc.id_company
  WHERE cvn.deleted_navigation = false
  ORDER BY cvn.id_navigation DESC;

ALTER TABLE core.view_navigation_inner_join
    OWNER TO postgres;

-- View: core.view_profile_inner_join
-- DROP VIEW core.view_profile_inner_join;

CREATE OR REPLACE VIEW core.view_profile_inner_join
 AS
 SELECT cvp.id_profile,
    cvp.id_company,
    cvp.type_profile,
    cvp.name_profile,
    cvp.description_profile,
    cvp.status_profile,
    cvp.deleted_profile,
    cvc.id_setting,
    cvc.name_company,
    cvc.acronym_company,
    cvc.address_company,
    cvc.status_company
   FROM core.view_profile cvp
     JOIN core.view_company cvc ON cvp.id_company = cvc.id_company
  WHERE cvp.deleted_profile = false
  ORDER BY cvp.id_profile DESC;

ALTER TABLE core.view_profile_inner_join
    OWNER TO postgres;


-- View: core.view_type_user_inner_join
-- DROP VIEW core.view_type_user_inner_join;

CREATE OR REPLACE VIEW core.view_type_user_inner_join
 AS
 SELECT cvtu.id_type_user,
    cvtu.id_company,
    cvtu.id_profile,
    cvtu.name_type_user,
    cvtu.description_type_user,
    cvtu.status_type_user,
    cvtu.deleted_type_user,
    cvc.id_setting,
    cvc.name_company,
    cvc.acronym_company,
    cvc.address_company,
    cvc.status_company,
    cvp.type_profile,
    cvp.name_profile,
    cvp.description_profile,
    cvp.status_profile
   FROM core.view_type_user cvtu
     JOIN core.view_company cvc ON cvtu.id_company = cvc.id_company
     JOIN core.view_profile cvp ON cvtu.id_profile = cvp.id_profile
  WHERE cvtu.deleted_type_user = false
  ORDER BY cvtu.id_type_user DESC;

ALTER TABLE core.view_type_user_inner_join
    OWNER TO postgres;

-- View: core.view_profile_navigation_inner_join
-- DROP VIEW core.view_profile_navigation_inner_join;

CREATE OR REPLACE VIEW core.view_profile_navigation_inner_join
 AS
 SELECT cvpn.id_profile_navigation,
    cvpn.id_profile,
    cvpn.id_navigation,
    cvp.type_profile,
    cvp.name_profile,
    cvp.description_profile,
    cvp.status_profile,
    cvn.name_navigation,
    cvn.description_navigation,
    cvn.type_navigation,
    cvn.status_navigation,
    cvn.content_navigation
   FROM core.view_profile_navigation cvpn
     JOIN core.view_profile cvp ON cvpn.id_profile = cvp.id_profile
     JOIN core.view_navigation cvn ON cvpn.id_navigation = cvn.id_navigation
  ORDER BY cvpn.id_profile_navigation DESC;

ALTER TABLE core.view_profile_navigation_inner_join
    OWNER TO postgres;

-- View: core.view_user_inner_join
-- DROP VIEW core.view_user_inner_join;

CREATE OR REPLACE VIEW core.view_user_inner_join
 AS
 SELECT cvu.id_user,
    cvu.id_company,
    cvu.id_person,
    cvu.id_type_user,
    cvu.name_user,
    cvu.password_user,
    cvu.avatar_user,
    cvu.status_user,
    cvu.deleted_user,
    cvc.id_setting,
    cvc.name_company,
    cvc.acronym_company,
    cvc.address_company,
    cvc.status_company,
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
   FROM core.view_user cvu
     JOIN core.view_company cvc ON cvu.id_company = cvc.id_company
     JOIN core.view_person cvp ON cvu.id_person = cvp.id_person
     JOIN core.view_type_user cvtu ON cvu.id_type_user = cvtu.id_type_user
     JOIN core.view_academic cva ON cvp.id_academic = cva.id_academic
     JOIN core.view_job cvj ON cvp.id_job = cvj.id_job
  WHERE cvu.deleted_user = false
  ORDER BY cvu.id_user DESC;

ALTER TABLE core.view_user_inner_join
    OWNER TO postgres;

-- View: core.view_session_inner_join
-- DROP VIEW core.view_session_inner_join;

CREATE OR REPLACE VIEW core.view_session_inner_join
 AS
 SELECT cvs.id_session,
    cvs.id_user,
    cvs.host_session,
    cvs.agent_session,
    cvs.date_sign_in_session,
    cvs.date_sign_out_session,
    cvs.status_session,
    cvu.id_company,
    cvu.id_person,
    cvu.id_type_user,
    cvu.name_user,
    cvu.password_user,
    cvu.avatar_user,
    cvu.status_user
   FROM core.view_session cvs
     JOIN core.view_user cvu ON cvs.id_user = cvu.id_user
  ORDER BY cvs.id_session DESC;

ALTER TABLE core.view_session_inner_join
    OWNER TO postgres;

-- View: core.view_system_event_inner_join
-- DROP VIEW core.view_system_event_inner_join;

CREATE OR REPLACE VIEW core.view_system_event_inner_join
 AS
 SELECT cvse.id_system_event,
    cvse.id_user,
    cvse.table_system_event,
    cvse.row_system_event,
    cvse.action_system_event,
    cvse.date_system_event,
    cvse.deleted_system_event,
    cvu.id_company,
    cvu.id_person,
    cvu.id_type_user,
    cvu.name_user,
    cvu.password_user,
    cvu.avatar_user,
    cvu.status_user
   FROM core.view_system_event cvse
     JOIN core.view_user cvu ON cvse.id_user = cvu.id_user
  WHERE cvse.deleted_system_event = false
  ORDER BY cvse.id_system_event DESC;

ALTER TABLE core.view_system_event_inner_join
    OWNER TO postgres;


