-- FUNCTION: core.dml_company_create_modified(numeric)
-- DROP FUNCTION IF EXISTS core.dml_company_create_modified(numeric);

CREATE OR REPLACE FUNCTION core.dml_company_create_modified(
	id_user_ numeric)
    RETURNS TABLE(id_company numeric, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, deleted_company boolean, expiration_token numeric, expiration_verification_code numeric, inactivity_time numeric, session_limit numeric, save_log boolean, save_file_alfresco boolean, modification_status boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_X RECORD;
	_ID_SETTING NUMERIC;
	_ID_COMPANY NUMERIC;
	_ID_VALIDATION NUMERIC;
	_CURRENT_ID_VALIDATION NUMERIC;
	_ID_INITIAL_VALIDATION NUMERIC;
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN
	_ID_SETTING = (select * from core.dml_setting_create(id_user_, 604800, 300, 86400, 999, false, false, false, false));
	
	IF (_ID_SETTING >= 1) THEN
		_ID_COMPANY = (select * from core.dml_company_create(id_user_, _ID_SETTING, 'Nueva empresa', '', '', false, false));
		
		IF (_ID_COMPANY >= 1) THEN
			_CURRENT_ID_VALIDATION = (select nextval('core.serial_validation')-1);
			_ID_INITIAL_VALIDATION = _CURRENT_ID_VALIDATION;
			FOR _X IN INSERT INTO core.validation(id_validation, id_company, type_validation, status_validation, pattern_validation, message_validation, deleted_validation) VALUES (_CURRENT_ID_VALIDATION, _ID_COMPANY, 'validationPassword', false, 'RegExp', 'No cumple con la RegExp', false) RETURNING id_validation LOOP
				_ID_VALIDATION = _X.id_validation;
			END LOOP;

			_CURRENT_ID_VALIDATION = (select nextval('core.serial_validation')-1);
			FOR _X IN INSERT INTO core.validation(id_validation, id_company, type_validation, status_validation, pattern_validation, message_validation, deleted_validation) VALUES (_CURRENT_ID_VALIDATION, _ID_COMPANY, 'validationDNI', false, 'RegExp', 'No cumple con la RegExp', false) RETURNING id_validation LOOP
				_ID_VALIDATION = _X.id_validation;
			END LOOP;

			_CURRENT_ID_VALIDATION = (select nextval('core.serial_validation')-1);
			FOR _X IN INSERT INTO core.validation(id_validation, id_company, type_validation, status_validation, pattern_validation, message_validation, deleted_validation) VALUES (_CURRENT_ID_VALIDATION, _ID_COMPANY, 'validationPhoneNumber', false, 'RegExp', 'No cumple con la RegExp', false) RETURNING id_validation LOOP
				_ID_VALIDATION = _X.id_validation;
			END LOOP;

			RETURN QUERY select * from core.view_company_inner_join cvcij 
				where cvcij.id_company = _ID_COMPANY;
		ELSE
			_EXCEPTION = 'Ocurrió un error al ingresar company';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar setting';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_ID_INITIAL_VALIDATION >= 1) THEN 
			EXECUTE 'select setval(''core.serial_validation'', '||_ID_INITIAL_VALIDATION||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%',SQLERRM USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION core.dml_company_create_modified(numeric)
    OWNER TO postgres;

-- FUNCTION: core.dml_company_update_modified(numeric, numeric, numeric, character varying, character varying, character varying, boolean, boolean, numeric, numeric, numeric, numeric)
-- DROP FUNCTION IF EXISTS core.dml_company_update_modified(numeric, numeric, numeric, character varying, character varying, character varying, boolean, boolean, numeric, numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION core.dml_company_update_modified(
	id_user_ numeric,
	_id_company numeric,
	_id_setting numeric,
	_name_company character varying,
	_acronym_company character varying,
	_address_company character varying,
	_status_company boolean,
	_deleted_company boolean,
	_expiration_token numeric,
	_expiration_verification_code numeric,
	_inactivity_time numeric,
	_session_limit numeric,
	_save_log boolean,
	_save_file_alfresco boolean, 
	_modification_status boolean)
    RETURNS TABLE(id_company numeric, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, deleted_company boolean, expiration_token numeric, expiration_verification_code numeric, inactivity_time numeric, session_limit numeric, save_log boolean, save_file_alfresco boolean, modification_status boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_SETTING BOOLEAN;
 	_UPDATE_COMPANY BOOLEAN;
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_SETTING = (select * from core.dml_setting_update(id_user_, _id_setting, _expiration_token, _expiration_verification_code, _inactivity_time, _session_limit, _save_log, _save_file_alfresco, _modification_status, false));
 	
	 IF (_UPDATE_SETTING) THEN
 		
		 _UPDATE_COMPANY = (select * from core.dml_company_update(id_user_, _id_company, _id_setting, _name_company, _acronym_company, _address_company, _status_company, _deleted_company));
		IF (_UPDATE_COMPANY) THEN
			RETURN QUERY select * from core.view_company_inner_join cvcij 
				where cvcij.id_company = _id_company;
		ELSE
			_EXCEPTION = 'Ocurrió un error al actualizar company';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar setting';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%',SQLERRM USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION core.dml_company_update_modified(numeric, numeric, numeric, character varying, character varying, character varying, boolean, boolean, numeric, numeric, numeric, numeric, boolean, boolean, boolean)
    OWNER TO postgres;

-- FUNCTION: core.dml_company_delete_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS core.dml_company_delete_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION core.dml_company_delete_modified(
	id_user_ numeric,
	_id_company numeric)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
 	_ID_SETTING NUMERIC;
 	_DELETE_SETTING BOOLEAN;
 	_DELETE_COMPANY BOOLEAN;
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN
 	_ID_SETTING = (select vs.id_setting from core.view_company vc inner join core.view_setting vs on vc.id_setting = vs.id_setting where vc.id_company = _id_company);
 
 	IF (_ID_SETTING >= 1) THEN
 		_DELETE_COMPANY = (select * from core.dml_company_delete(id_user_, _id_company));
		
		IF (_DELETE_COMPANY) THEN
 			_DELETE_SETTING = (select * from core.dml_setting_delete(id_user_, _id_setting));
			
			IF (_DELETE_SETTING) THEN
				return true;
			ELSE
				_EXCEPTION = 'Ocurrió un error al eliminar setting';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE
			_EXCEPTION = 'Ocurrió un error al eliminar company';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
 	ELSE
		_EXCEPTION = 'No se encontró el id_setting';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%',SQLERRM USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION core.dml_company_delete_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: core.dml_validation_create_modified(numeric, numeric, core."TYPE_VALIDATION")
-- DROP FUNCTION IF EXISTS core.dml_validation_create_modified(numeric, numeric, core."TYPE_VALIDATION");

CREATE OR REPLACE FUNCTION core.dml_validation_create_modified(
	id_user_ numeric,
	_id_company numeric,
	_type_validation core."TYPE_VALIDATION")
    RETURNS TABLE(id_validation numeric, id_company numeric, type_validation core."TYPE_VALIDATION", status_validation boolean, pattern_validation character varying, message_validation character varying, deleted_validation boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_VALIDATION NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_VALIDATION = (select * from core.dml_validation_create(id_user_, _id_company, _type_validation, false, '', '', false));
	
	IF (_ID_VALIDATION >= 1) THEN
		RETURN QUERY select * from core.view_validation_inner_join cvvij 
			where cvvij.id_validation = _ID_VALIDATION;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar validation';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_validation_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION core.dml_validation_create_modified(numeric, numeric, core."TYPE_VALIDATION")
    OWNER TO postgres;

-- FUNCTION: core.dml_validation_update_modified(numeric, numeric, numeric, core."TYPE_VALIDATION", boolean, character varying, character varying, boolean)
-- DROP FUNCTION IF EXISTS core.dml_validation_update_modified(numeric, numeric, numeric, core."TYPE_VALIDATION", boolean, character varying, character varying, boolean);

CREATE OR REPLACE FUNCTION core.dml_validation_update_modified(
	id_user_ numeric,
	_id_validation numeric,
	_id_company numeric,
	_type_validation core."TYPE_VALIDATION",
	_status_validation boolean,
	_pattern_validation character varying,
	_message_validation character varying,
	_deleted_validation boolean)
    RETURNS TABLE(id_validation numeric, id_company numeric, type_validation core."TYPE_VALIDATION", status_validation boolean, pattern_validation character varying, message_validation character varying, deleted_validation boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_VALIDATION BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_VALIDATION = (select * from core.dml_validation_update(id_user_, _id_validation, _id_company, _type_validation, _status_validation, _pattern_validation, _message_validation, _deleted_validation));

 	IF (_UPDATE_VALIDATION) THEN
		RETURN QUERY select * from core.view_validation_inner_join cvvij 
			where cvvij.id_validation = _id_validation;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar validation';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_validation_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION core.dml_validation_update_modified(numeric, numeric, numeric, core."TYPE_VALIDATION", boolean, character varying, character varying, boolean)
    OWNER TO postgres;

-- FUNCTION: core.dml_navigation_create_modified(numeric, numeric, core."TYPE_NAVIGATION")
-- DROP FUNCTION IF EXISTS core.dml_navigation_create_modified(numeric, numeric, core."TYPE_NAVIGATION");

CREATE OR REPLACE FUNCTION core.dml_navigation_create_modified(
	id_user_ numeric,
	_id_company numeric,
	_type_navigation core."TYPE_NAVIGATION")
    RETURNS TABLE(id_navigation numeric, id_company numeric, name_navigation character varying, description_navigation character varying, type_navigation core."TYPE_NAVIGATION", status_navigation boolean, content_navigation json, deleted_navigation boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_NAVIGATION NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_NAVIGATION = (select * from core.dml_navigation_create(id_user_, _id_company, 'Nueva navegación', '', _type_navigation, false, '[]', false));
	
	IF (_ID_NAVIGATION >= 1) THEN
		RETURN QUERY select * from core.view_navigation_inner_join cvnij 
			where cvnij.id_navigation = _ID_NAVIGATION;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar navigation';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_navigation_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION core.dml_navigation_create_modified(numeric, numeric, core."TYPE_NAVIGATION")
    OWNER TO postgres;

-- FUNCTION: core.dml_navigation_update_modified(numeric, numeric, numeric, character varying, character varying, core."TYPE_NAVIGATION", boolean, json, boolean)
-- DROP FUNCTION IF EXISTS core.dml_navigation_update_modified(numeric, numeric, numeric, character varying, character varying, core."TYPE_NAVIGATION", boolean, json, boolean);

CREATE OR REPLACE FUNCTION core.dml_navigation_update_modified(
	id_user_ numeric,
	_id_navigation numeric,
	_id_company numeric,
	_name_navigation character varying,
	_description_navigation character varying,
	_type_navigation core."TYPE_NAVIGATION",
	_status_navigation boolean,
	_content_navigation json,
	_deleted_navigation boolean)
    RETURNS TABLE(id_navigation numeric, id_company numeric, name_navigation character varying, description_navigation character varying, type_navigation core."TYPE_NAVIGATION", status_navigation boolean, content_navigation json, deleted_navigation boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_NAVIGATION BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_NAVIGATION = (select * from core.dml_navigation_update(id_user_, _id_navigation, _id_company, _name_navigation, _description_navigation, _type_navigation, _status_navigation, _content_navigation, _deleted_navigation));

 	IF (_UPDATE_NAVIGATION) THEN
		RETURN QUERY select * from core.view_navigation_inner_join cvnij 
			where cvnij.id_navigation = _id_navigation;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar navigation';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_navigation_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION core.dml_navigation_update_modified(numeric, numeric, numeric, character varying, character varying, core."TYPE_NAVIGATION", boolean, json, boolean)
    OWNER TO postgres;

-- FUNCTION: core.dml_profile_create_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS core.dml_profile_create_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION core.dml_profile_create_modified(
	id_user_ numeric,
	_id_company numeric)
    RETURNS TABLE(id_profile numeric, id_company numeric, type_profile core."TYPE_PROFILE", name_profile character varying, description_profile character varying, status_profile boolean, deleted_profile boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_PROFILE NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_PROFILE = (select * from core.dml_profile_create(id_user_, _id_company, 'commonProfile', 'Nuevo perfil', '', false, false));
	
	IF (_ID_PROFILE >= 1) THEN
		RETURN QUERY select * from core.view_profile_inner_join cvpij 
			where cvpij.id_profile = _ID_PROFILE;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar profile';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_profile_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION core.dml_profile_create_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: core.dml_profile_update_modified(numeric, numeric, numeric, core."TYPE_PROFILE", character varying, character varying, boolean, boolean)
-- DROP FUNCTION IF EXISTS core.dml_profile_update_modified(numeric, numeric, numeric, core."TYPE_PROFILE", character varying, character varying, boolean, boolean);

CREATE OR REPLACE FUNCTION core.dml_profile_update_modified(
	id_user_ numeric,
	_id_profile numeric,
	_id_company numeric,
	_type_profile core."TYPE_PROFILE",
	_name_profile character varying,
	_description_profile character varying,
	_status_profile boolean,
	_deleted_profile boolean)
    RETURNS TABLE(id_profile numeric, id_company numeric, type_profile core."TYPE_PROFILE", name_profile character varying, description_profile character varying, status_profile boolean, deleted_profile boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_PROFILE BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_PROFILE = (select * from core.dml_profile_update(id_user_, _id_profile, _id_company, _type_profile, _name_profile, _description_profile, _status_profile, _deleted_profile));

 	IF (_UPDATE_PROFILE) THEN
		RETURN QUERY select * from core.view_profile_inner_join cvpij 
			where cvpij.id_profile = _id_profile;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar profile';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_profile_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION core.dml_profile_update_modified(numeric, numeric, numeric, core."TYPE_PROFILE", character varying, character varying, boolean, boolean)
    OWNER TO postgres;

-- FUNCTION: core.dml_profile_delete_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS core.dml_profile_delete_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION core.dml_profile_delete_modified(
	id_user_ numeric,
	_id_profile numeric)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_X RECORD;
	_DELETE_NAVIGATION BOOLEAN;
	_DELETE_PROFILE BOOLEAN;
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN
 	FOR _X IN select * from core.view_profile_navigation cvpn where cvpn.id_profile = _id_profile LOOP
		RAISE NOTICE '%', _X.id_profile_navigation;
		_DELETE_NAVIGATION = (select * from core.dml_profile_navigation_delete(id_user_, _X.id_profile_navigation));
	END LOOP;
				
	_DELETE_PROFILE = (select * from core.dml_profile_delete(id_user_, _id_profile));
	IF (_DELETE_PROFILE) THEN
		RETURN true;
	ELSE
		_EXCEPTION = 'Ocurrió un error al eliminar profile';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_profile_delete_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION core.dml_profile_delete_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: core.dml_type_user_create_modified(numeric)
-- DROP FUNCTION IF EXISTS core.dml_type_user_create_modified(numeric);

CREATE OR REPLACE FUNCTION core.dml_type_user_create_modified(
	id_user_ numeric)
    RETURNS TABLE(id_type_user numeric, id_company numeric, id_profile numeric, name_type_user character varying, description_type_user character varying, status_type_user boolean, deleted_type_user boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, type_profile core."TYPE_PROFILE", name_profile character varying, description_profile character varying, status_profile boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_TYPE_USER NUMERIC;
	_ID_COMPANY NUMERIC;
	_ID_PROFILE NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	-- Get the id company _ID_COMPANY
	_ID_COMPANY = (select cvu.id_company from core.view_user cvu where cvu.id_user = id_user_);
	
	_ID_PROFILE = (select cvp.id_profile from core.view_profile cvp order by cvp.id_profile asc limit 1);
	
	IF (_ID_PROFILE >= 1) THEN
		_ID_TYPE_USER = (select * from core.dml_type_user_create(id_user_, _ID_COMPANY, _ID_PROFILE, 'Nuevo tipo de usuario', '', false, false));

		IF (_ID_TYPE_USER >= 1) THEN
			RETURN QUERY select * from core.view_type_user_inner_join cvtuij 
				where cvtuij.id_type_user = _ID_TYPE_USER;
		ELSE
			_EXCEPTION = 'Ocurrió un error al ingresar type_user';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'No se encontró un profile';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_type_user_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION core.dml_type_user_create_modified(numeric)
    OWNER TO postgres;

-- FUNCTION: core.dml_type_user_update_modified(numeric, numeric, numeric, numeric, character varying, character varying, boolean, boolean)
-- DROP FUNCTION IF EXISTS core.dml_type_user_update_modified(numeric, numeric, numeric, numeric, character varying, character varying, boolean, boolean);

CREATE OR REPLACE FUNCTION core.dml_type_user_update_modified(
	id_user_ numeric,
	_id_type_user numeric,
	_id_company numeric,
	_id_profile numeric,
	_name_type_user character varying,
	_description_type_user character varying,
	_status_type_user boolean,
	_deleted_type_user boolean)
    RETURNS TABLE(id_type_user numeric, id_company numeric, id_profile numeric, name_type_user character varying, description_type_user character varying, status_type_user boolean, deleted_type_user boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, type_profile core."TYPE_PROFILE", name_profile character varying, description_profile character varying, status_profile boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_TYPE_USER BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_TYPE_USER = (select * from core.dml_type_user_update(id_user_, _id_type_user, _id_company, _id_profile, _name_type_user, _description_type_user, _status_type_user, _deleted_type_user));

 	IF (_UPDATE_TYPE_USER) THEN
		RETURN QUERY select * from core.view_type_user_inner_join cvtuij 
			where cvtuij.id_type_user = _id_type_user;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar type_user';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_type_user_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION core.dml_type_user_update_modified(numeric, numeric, numeric, numeric, character varying, character varying, boolean, boolean)
    OWNER TO postgres;

-- FUNCTION: core.dml_profile_navigation_create_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS core.dml_profile_navigation_create_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION core.dml_profile_navigation_create_modified(
	id_user_ numeric,
	_id_profile numeric)
    RETURNS TABLE(id_profile_navigation numeric, id_profile numeric, id_navigation numeric, type_profile core."TYPE_PROFILE", name_profile character varying, description_profile character varying, status_profile boolean, name_navigation character varying, description_navigation character varying, type_navigation core."TYPE_NAVIGATION", status_navigation boolean, content_navigation json) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_COMPANY numeric;
	_ID_NAVIGATION numeric;
	_ID_PROFILE_NAVIGATION NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	-- Get the id company _ID_COMPANY
	_ID_COMPANY = (select vu.id_company from core.view_user vu where vu.id_user = id_user_); 
	
	_ID_NAVIGATION = (select navigations.id_navigation from (select vn.id_navigation from core.view_navigation vn where vn.id_company = _ID_COMPANY) as navigations 
		LEFT JOIN (select distinct vpn.id_navigation from core.view_profile_navigation vpn inner join core.view_navigation vn on vpn.id_navigation = vn.id_navigation where vpn.id_profile = _id_profile and vn.id_company = _ID_COMPANY) as navigationsAssigned 
		on navigations.id_navigation = navigationsAssigned.id_navigation where navigationsAssigned.id_navigation IS NULL order by navigations.id_navigation asc limit 1);

	IF (_ID_NAVIGATION >= 1) THEN
		_ID_PROFILE_NAVIGATION = (select * from core.dml_profile_navigation_create(id_user_, _id_profile, _ID_NAVIGATION));
		
		IF (_ID_PROFILE_NAVIGATION >= 1) THEN
			RETURN QUERY select * from core.view_profile_navigation_inner_join cvpnij 
				where cvpnij.id_profile_navigation = _ID_PROFILE_NAVIGATION;
		ELSE
			_EXCEPTION = 'Ocurrió un error al ingresar profile_navigation';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'No se encontraron navegaciones registradas';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_profile_navigation_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION core.dml_profile_navigation_create_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: core.dml_profile_navigation_update_modified(numeric, numeric, numeric, numeric)
-- DROP FUNCTION IF EXISTS core.dml_profile_navigation_update_modified(numeric, numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION core.dml_profile_navigation_update_modified(
	id_user_ numeric,
	_id_profile_navigation numeric,
	_id_profile numeric,
	_id_navigation numeric)
    RETURNS TABLE(id_profile_navigation numeric, id_profile numeric, id_navigation numeric, type_profile core."TYPE_PROFILE", name_profile character varying, description_profile character varying, status_profile boolean, name_navigation character varying, description_navigation character varying, type_navigation core."TYPE_NAVIGATION", status_navigation boolean, content_navigation json) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_PROFILE_NAVIGATION BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_PROFILE_NAVIGATION = (select * from core.dml_profile_navigation_update(id_user_, _id_profile_navigation, _id_profile, _id_navigation));

 	IF (_UPDATE_PROFILE_NAVIGATION) THEN
		RETURN QUERY select * from core.view_profile_navigation_inner_join cvpnij 
			where cvpnij.id_profile_navigation = _id_profile_navigation;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar profile_navigation';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_profile_navigation_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION core.dml_profile_navigation_update_modified(numeric, numeric, numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: core.dml_user_create_modified(numeric)
-- DROP FUNCTION IF EXISTS core.dml_user_create_modified(numeric);

CREATE OR REPLACE FUNCTION core.dml_user_create_modified(
	id_user_ numeric)
    RETURNS TABLE(id_user numeric, id_company numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, deleted_user boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_profile numeric, name_type_user character varying, description_type_user character varying, status_type_user boolean, title_academic character varying, abbreviation_academic character varying, nivel_academic character varying, name_job character varying, address_job character varying, phone_job character varying, position_job character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_COMPANY NUMERIC;
	_ID_ACADEMIC NUMERIC;
	_ID_JOB NUMERIC;
	_ID_PERSON NUMERIC;
	_ID_TYPE_USER NUMERIC;
	_ID_USER NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	-- Get the id company _ID_COMPANY
	_ID_COMPANY = (select vu.id_company from core.view_user vu where vu.id_user = id_user_);
	
	_ID_ACADEMIC = (select * from core.dml_academic_create(id_user_, '', '', '', false));
	
	IF (_ID_ACADEMIC >= 1) THEN
		_ID_JOB = (select * from core.dml_job_create(id_user_, '', '', '', '', false));
		
		IF (_ID_JOB >= 1) THEN
			_ID_PERSON = (select * from core.dml_person_create(id_user_, _ID_ACADEMIC, _ID_JOB, '', 'Nuevo', 'usuario', '', '', false));
			
			IF (_ID_PERSON >= 1) THEN
				_ID_TYPE_USER = (select cvtu.id_type_user from core.view_type_user cvtu order by cvtu.id_type_user asc limit 1);
				
				IF (_ID_TYPE_USER >= 1) THEN
					_ID_USER = (select * from core.dml_user_create(id_user_, _ID_COMPANY, _ID_PERSON, _ID_TYPE_USER, 'new.user@nashor.com', '', 'default.svg', false, false));

					IF (_ID_USER >= 1) THEN
						RETURN QUERY select * from core.view_user_inner_join cvuij 
							where cvuij.id_user = _ID_USER;
					ELSE
						_EXCEPTION = 'Ocurrió un error al ingresar _user';
						RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
					END IF;
				ELSE
					_EXCEPTION = 'No se encontró un type_user';
					RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
				END IF;
			ELSE
				_EXCEPTION = 'Ocurrió un error al ingresar person';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE
			_EXCEPTION = 'Ocurrió un error al ingresar job';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar academic';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_user_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION core.dml_user_create_modified(numeric)
    OWNER TO postgres;

-- FUNCTION: core.dml_user_update_modified(numeric, numeric, numeric, numeric, numeric, character varying, character varying, character varying, boolean, boolean, numeric, numeric, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)
-- DROP FUNCTION IF EXISTS core.dml_user_update_modified(numeric, numeric, numeric, numeric, numeric, character varying, character varying, character varying, boolean, boolean, numeric, numeric, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION core.dml_user_update_modified(
	id_user_ numeric,
	_id_user numeric,
	_id_company numeric,
	_id_person numeric,
	_id_type_user numeric,
	_name_user character varying,
	_password_user character varying,
	_avatar_user character varying,
	_status_user boolean,
	_deleted_user boolean,
	_id_academic numeric,
	_id_job numeric,
	_dni_person character varying,
	_name_person character varying,
	_last_name_person character varying,
	_address_person character varying,
	_phone_person character varying,
	_title_academic character varying,
	_abbreviation_academic character varying,
	_nivel_academic character varying,
	_name_job character varying,
	_address_job character varying,
	_phone_job character varying,
	_position_job character varying)
    RETURNS TABLE(id_user numeric, id_company numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, deleted_user boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_profile numeric, name_type_user character varying, description_type_user character varying, status_type_user boolean, title_academic character varying, abbreviation_academic character varying, nivel_academic character varying, name_job character varying, address_job character varying, phone_job character varying, position_job character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_ACADEMIC BOOLEAN;
	_UPDATE_JOB BOOLEAN;
	_UPDATE_PERSON BOOLEAN;
	_UPDATE_USER BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_UPDATE_ACADEMIC = (select * from core.dml_academic_update(id_user_, _id_academic, _title_academic, _abbreviation_academic, _nivel_academic, false));
	
	IF (_UPDATE_ACADEMIC) THEN
		_UPDATE_JOB = (select * from core.dml_job_update(id_user_, _id_job, _name_job, _address_job, _phone_job, _position_job, false));
		
		IF (_UPDATE_JOB) THEN
			_UPDATE_PERSON = (select * from core.dml_person_update(id_user_, _id_person, _id_academic, _id_job, _dni_person, _name_person, _last_name_person, _address_person, _phone_person, false));
			
			IF (_UPDATE_PERSON) THEN
 				_UPDATE_USER = (select * from core.dml_user_update(id_user_, _id_user, _id_company, _id_person, _id_type_user, _name_user, _password_user, _avatar_user, _status_user, _deleted_user));
					
				IF (_UPDATE_USER) THEN
					RETURN QUERY select * from core.view_user_inner_join cvuij 
						where cvuij.id_user = _id_user;
				ELSE
					_EXCEPTION = 'Ocurrió un error al actualizar _user';
					RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
				END IF;
			ELSE
				_EXCEPTION = 'Ocurrió un error al actualizar person';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE
			_EXCEPTION = 'Ocurrió un error al actualizar job';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar academic';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_user_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION core.dml_user_update_modified(numeric, numeric, numeric, numeric, numeric, character varying, character varying, character varying, boolean, boolean, numeric, numeric, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)
    OWNER TO postgres;

-- FUNCTION: core.dml_user_delete_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS core.dml_user_delete_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION core.dml_user_delete_modified(
	id_user_ numeric,
	_id_user numeric)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_ID_PERSON NUMERIC;
	_ID_JOB NUMERIC;
	_ID_ACADEMIC NUMERIC;
	_DELETE_ACADEMIC BOOLEAN;
	_DELETE_JOB BOOLEAN;
	_DELETE_PERSON BOOLEAN;
	_DELETE_USER BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_PERSON = (select vu.id_person from core.view_user vu where vu.id_user = _id_user);
	_ID_JOB = (select vp.id_job from core.view_person vp where vp.id_person = _ID_PERSON);
	_ID_ACADEMIC = (select va.id_academic from core.view_academic va where va.id_academic = _ID_PERSON);
 
 	_DELETE_USER = (select * from core.dml_user_delete(id_user_, _id_user));
	
	IF (_DELETE_USER) THEN
 		_DELETE_PERSON = (select * from core.dml_person_delete(id_user_, _ID_PERSON));
		
		IF (_DELETE_PERSON) THEN
 			_DELETE_JOB = (select * from core.dml_job_delete(id_user_, _ID_JOB));
			
			IF (_DELETE_JOB) THEN
				_DELETE_ACADEMIC = (select * from core.dml_academic_delete(id_user_, _ID_ACADEMIC));
				
				IF (_DELETE_ACADEMIC) THEN
					return true;
				ELSE
					_EXCEPTION = 'Ocurrió un error al eliminar academic';
					RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
				END IF;
			ELSE
				_EXCEPTION = 'Ocurrió un error al eliminar job';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE
			_EXCEPTION = 'Ocurrió un error al eliminar person';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'Ocurrió un error al eliminar user';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_user_delete_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION core.dml_user_delete_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: core.dml_session_release(numeric)
-- DROP FUNCTION IF EXISTS core.dml_session_release(numeric);

CREATE OR REPLACE FUNCTION core.dml_session_release(
	_id_session numeric)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_COUNT NUMERIC;
	_RETURNIG NUMERIC;
	_X RECORD;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN 
 	_COUNT = (select count(*) from core.view_session cvs where cvs.id_session = _id_session);
	
	IF (_COUNT = 1) THEN
		FOR _X IN UPDATE core.session SET date_sign_out_session = now()::timestamp, status_session = false WHERE id_session = _id_session RETURNING id_session LOOP
			_RETURNIG = _X.id_session;
		END LOOP;
		
		IF (_RETURNIG >= 1) THEN
			RETURN true;
		ELSE
			RETURN false;
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_session||' no se encuentra registrado en la tabla session';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%',SQLERRM USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION core.dml_session_release(numeric)
    OWNER TO postgres;

-- FUNCTION: core.dml_session_by_session_release(numeric, numeric)
-- DROP FUNCTION IF EXISTS core.dml_session_by_session_release(numeric, numeric);

CREATE OR REPLACE FUNCTION core.dml_session_by_session_release(
	id_user_ numeric,
	_id_session numeric)
    RETURNS TABLE(id_session numeric, id_user numeric, host_session text, agent_session json, date_sign_in_session timestamp without time zone, date_sign_out_session timestamp without time zone, status_session boolean, id_company numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_RELEASE_SESSION boolean;
	_RESPONSE BOOLEAN;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN 
	_RELEASE_SESSION = (select * from core.dml_session_release(_id_session));
	
	IF (_RELEASE_SESSION) THEN
		_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
			where cvuij.id_user = id_user_);
		
		IF (_SAVE_LOG) THEN
			_RESPONSE = (core.dml_system_event_create(id_user_,'session',_id_session,'bySessionRelease', now()::timestamp, false));
			
			IF (_RESPONSE != true) THEN
				_EXCEPTION = 'Ocurrió un error al registrar el evento del sistema';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		END IF;
		RETURN QUERY select * from core.view_session_inner_join cvsij 
			where cvsij.id_session = _ID_SESSION;
	ELSE
		_EXCEPTION = 'Ocurrió un error al liberar la sessión';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%',SQLERRM USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION core.dml_session_by_session_release(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: core.dml_session_by_user_release_all(numeric, numeric)
-- DROP FUNCTION IF EXISTS core.dml_session_by_user_release_all(numeric, numeric);

CREATE OR REPLACE FUNCTION core.dml_session_by_user_release_all(
	id_user_ numeric,
	_id_user numeric)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
 	_COUNT_SESSION NUMERIC;
	_RELEASE_SESSION boolean;
	_RESPONSE BOOLEAN;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT_SESSION = (select count(*) from core.view_session cvs where cvs.id_user = _id_user and cvs.status_session = true);
	
	IF (_COUNT_SESSION = 0) THEN
		_EXCEPTION = 'El usuario '||_id_user||' no tiene sessiones activas';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	
	FOR _X IN select cvs.id_session from core.view_session cvs where cvs.id_user = _id_user and cvs.status_session = true LOOP
		_RELEASE_SESSION = (select * from core.dml_session_release(_X.id_session));
	END LOOP;
	
	IF (_RELEASE_SESSION) THEN
		_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
			where cvuij.id_user = id_user_);
			
		IF (_SAVE_LOG) THEN
			_RESPONSE = (core.dml_system_event_create(id_user_,'session',_id_user,'byUserReleaseAll', now()::timestamp, false));
			
			IF (_RESPONSE != true) THEN
				_EXCEPTION = 'Ocurrió un error al registrar el evento del sistema';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		END IF;
		RETURN true;
	ELSE
		_EXCEPTION = 'Ocurrió un error al liberar las sessiones del usuario '||_id_user||'';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%',SQLERRM USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION core.dml_session_by_user_release_all(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: core.dml_session_by_company_release_all(numeric, numeric)
-- DROP FUNCTION IF EXISTS core.dml_session_by_company_release_all(numeric, numeric);

CREATE OR REPLACE FUNCTION core.dml_session_by_company_release_all(
	id_user_ numeric,
	_id_company numeric)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
 	_COUNT_SESSION NUMERIC;
	_RELEASE_SESSION boolean;
	_RESPONSE BOOLEAN;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT_SESSION = (select count(*) from core.view_session cvs inner join core.view_user cvu on cvs.id_user = cvu.id_user where cvu.id_company = _id_company and cvs.status_session = true);
	
	IF (_COUNT_SESSION = 0) THEN
		_EXCEPTION = 'La empresa '||_id_company||' no tiene sessiones activas';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	
	-- Sessions of company
	FOR _X IN select cvs.id_session from core.view_session cvs inner join core.view_user cvu on cvs.id_user = cvu.id_user where cvu.id_company = _id_company and cvs.status_session = true LOOP
		_RELEASE_SESSION = (select * from core.dml_session_release(_X.id_session));
	END LOOP;
	
	IF (_RELEASE_SESSION) THEN
		_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
			where cvuij.id_user = id_user_);
		
		IF (_SAVE_LOG) THEN
			_RESPONSE = (core.dml_system_event_create(id_user_,'session',_id_company,'byCompanyReleaseAll', now()::timestamp, false));
			
			IF (_RESPONSE != true) THEN
				_EXCEPTION = 'Ocurrió un error al registrar el evento del sistema';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		END IF;
		RETURN true;
	ELSE
		_EXCEPTION = 'Ocurrió un error al liberar las sessiones de la empresa '||_id_company||'';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%',SQLERRM USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION core.dml_session_by_company_release_all(numeric, numeric)
    OWNER TO postgres;
