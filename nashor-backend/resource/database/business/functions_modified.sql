------------------------------ VALIDATION ------------------------------
-- FUNCTION: business.validation_flow_version(numeric)
-- DROP FUNCTION IF EXISTS business.validation_flow_version(numeric);

CREATE OR REPLACE FUNCTION business.validation_flow_version(
	_id_flow_version numeric)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_COUNT NUMERIC;
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN
	-- Verificar si la version del flujo se encuentra en uso
	_COUNT = (select count(*) from business.view_process bvp  where bvp.id_flow_version = _id_flow_version and bvp.finalized_process = false);
	
	IF (_COUNT >= 1) THEN
		RETURN true;
	ELSE 
		RETURN false;
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

ALTER FUNCTION business.validation_flow_version(numeric)
    OWNER TO postgres;

------------------------------ VALIDATION ------------------------------

-- FUNCTION: business.dml_area_create_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_area_create_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_area_create_modified(
	id_user_ numeric,
	_id_company numeric)
    RETURNS TABLE(id_area numeric, id_company numeric, name_area character varying, description_area character varying, deleted_area boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_AREA NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_AREA = (select * from business.dml_area_create(id_user_, _id_company, 'Nueva area', '', false));
	
	IF (_ID_AREA >= 1) THEN
		RETURN QUERY select * from business.view_area_inner_join bvaij 
			where bvaij.id_area = _ID_AREA;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar area';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_area_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_area_create_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_area_update_modified(numeric, numeric, numeric, character varying, character varying, boolean)
-- DROP FUNCTION IF EXISTS business.dml_area_update_modified(numeric, numeric, numeric, character varying, character varying, boolean);

CREATE OR REPLACE FUNCTION business.dml_area_update_modified(
	id_user_ numeric,
	_id_area numeric,
	_id_company numeric,
	_name_area character varying,
	_description_area character varying,
	_deleted_area boolean)
    RETURNS TABLE(id_area numeric, id_company numeric, name_area character varying, description_area character varying, deleted_area boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_AREA BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_AREA = (select * from business.dml_area_update(id_user_, _id_area, _id_company, _name_area, _description_area, _deleted_area));

 	IF (_UPDATE_AREA) THEN
		RETURN QUERY select * from business.view_area_inner_join bvaij 
			where bvaij.id_area = _id_area;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar area';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_area_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_area_update_modified(numeric, numeric, numeric, character varying, character varying, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_position_create_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_position_create_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_position_create_modified(
	id_user_ numeric,
	_id_company numeric)
    RETURNS TABLE(id_position numeric, id_company numeric, name_position character varying, description_position character varying, deleted_position boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_POSITION NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_POSITION = (select * from business.dml_position_create(id_user_, _id_company, 'Nuevo cargo', '', false));
	
	IF (_ID_POSITION >= 1) THEN
		RETURN QUERY select * from business.view_position_inner_join bvpij 
			where bvpij.id_position = _ID_POSITION;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar position';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_position_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_position_create_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_position_update_modified(numeric, numeric, numeric, character varying, character varying, boolean)
-- DROP FUNCTION IF EXISTS business.dml_position_update_modified(numeric, numeric, numeric, character varying, character varying, boolean);

CREATE OR REPLACE FUNCTION business.dml_position_update_modified(
	id_user_ numeric,
	_id_position numeric,
	_id_company numeric,
	_name_position character varying,
	_description_position character varying,
	_deleted_position boolean)
    RETURNS TABLE(id_position numeric, id_company numeric, name_position character varying, description_position character varying, deleted_position boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_POSITION BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_POSITION = (select * from business.dml_position_update(id_user_, _id_position, _id_company, _name_position, _description_position, _deleted_position));

 	IF (_UPDATE_POSITION) THEN
		RETURN QUERY select * from business.view_position_inner_join bvpij 
			where bvpij.id_position = _id_position;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar position';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_position_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_position_update_modified(numeric, numeric, numeric, character varying, character varying, boolean)
    OWNER TO postgres;
	
-- FUNCTION: business.dml_official_create_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_official_create_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_official_create_modified(
	id_user_ numeric,
	_id_company numeric)
    RETURNS TABLE(id_official numeric, id_company numeric, id_user numeric, id_area numeric, id_position numeric, deleted_official boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, name_area character varying, description_area character varying, name_position character varying, description_position character varying, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_profile numeric, name_type_user character varying, description_type_user character varying, status_type_user boolean, title_academic character varying, abbreviation_academic character varying, level_academic character varying, name_job character varying, address_job character varying, phone_job character varying, position_job character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_ACADEMIC NUMERIC;
	_ID_JOB NUMERIC;
	_ID_PERSON NUMERIC;
	_ID_TYPE_USER NUMERIC;
	_ID_USER NUMERIC;
	_ID_AREA NUMERIC;
	_ID_POSITION NUMERIC;
	_ID_OFFICIAL NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_ACADEMIC = (select * from core.dml_academic_create(id_user_, '', '', '', false));
				
	IF (_ID_ACADEMIC >= 1) THEN
		_ID_JOB = (select * from core.dml_job_create(id_user_, '', '', '', '', false));
		
		IF (_ID_JOB >= 1) THEN
			_ID_PERSON = (select * from core.dml_person_create(id_user_, _ID_ACADEMIC, _ID_JOB, '9999999999999', 'Nuevo', 'usuario', '', '', false));
			
			IF (_ID_PERSON >= 1) THEN
				_ID_TYPE_USER = (select cvtu.id_type_user from core.view_type_user cvtu where cvtu.id_company = _id_company order by cvtu.id_type_user asc limit 1);
				
				IF (_ID_TYPE_USER >= 1) THEN
					_ID_USER = (select * from core.dml_user_create(id_user_, _id_company, _ID_PERSON, _ID_TYPE_USER, 'new.user@nashor.com', '', 'default.svg', false, false));
					
					IF (_ID_USER >= 1) THEN
						_ID_AREA = (select bva.id_area from business.view_area bva where bva.id_company = _id_company order by bva.id_area asc limit 1);
						
						IF (_ID_AREA >= 1) THEN
							_ID_POSITION = (select bvp.id_position from business.view_position bvp where bvp.id_company = _id_company order by bvp.id_position asc limit 1);
							
							IF (_ID_POSITION >= 1) THEN
								_ID_OFFICIAL = (select * from business.dml_official_create(id_user_, _id_company, _ID_USER, _ID_AREA, _ID_POSITION, false));
	
								IF (_ID_OFFICIAL >= 1) THEN
									RETURN QUERY select * from business.view_official_inner_join bvoij 
										where bvoij.id_official = _ID_OFFICIAL;
								ELSE
									_EXCEPTION = 'Ocurrió un error al ingresar official';
									RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
								END IF;
							ELSE
								_EXCEPTION = 'No se encontró un position';
								RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
							END IF;
						ELSE
							_EXCEPTION = 'No se encontró un area';
							RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
						END IF;
					ELSE
						_EXCEPTION = 'Ocurrió un error al ingresar user';
						RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
					END IF;
				ELSE
					_EXCEPTION = 'No se encontró un profile';
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
			RAISE EXCEPTION '%', 'dml_official_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_official_create_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_official_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, character varying, character varying, character varying, boolean, numeric, numeric, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_official_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, character varying, character varying, character varying, boolean, numeric, numeric, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_official_update_modified(
	id_user_ numeric,
	_id_official numeric,
	_id_user numeric,
	_id_company numeric,
	_id_person numeric,
	_id_type_user numeric,
	_name_user character varying,
	_password_user character varying,
	_avatar_user character varying,
	_status_user boolean,
	_id_academic numeric,
	_id_job numeric,
	_dni_person character varying,
	_name_person character varying,
	_last_name_person character varying,
	_address_person character varying,
	_phone_person character varying,
	_title_academic character varying,
	_abbreviation_academic character varying,
	_level_academic character varying,
	_name_job character varying,
	_address_job character varying,
	_phone_job character varying,
	_position_job character varying,
	_id_area numeric,
	_id_position numeric)
    RETURNS TABLE(id_official numeric, id_company numeric, id_user numeric, id_area numeric, id_position numeric, deleted_official boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, name_area character varying, description_area character varying, name_position character varying, description_position character varying, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_profile numeric, name_type_user character varying, description_type_user character varying, status_type_user boolean, title_academic character varying, abbreviation_academic character varying, level_academic character varying, name_job character varying, address_job character varying, phone_job character varying, position_job character varying) 
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
	_UPDATE_OFFICIAL BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_UPDATE_ACADEMIC = (select * from core.dml_academic_update(id_user_, _id_academic, _title_academic, _abbreviation_academic, _level_academic, false));
				
	IF (_UPDATE_ACADEMIC) THEN
		_UPDATE_JOB = (select * from core.dml_job_update(id_user_, _id_job, _name_job, _address_job, _phone_job, _position_job, false));
		
		IF (_UPDATE_JOB) THEN
			_UPDATE_PERSON = (select * from core.dml_person_update(id_user_, _id_person, _id_academic, _id_job, _dni_person, _name_person, _last_name_person, _address_person, _phone_person, false));
			
			IF (_UPDATE_PERSON) THEN
				_UPDATE_USER = (select * from core.dml_user_update(id_user_, _id_user, _id_company, _id_person, _id_type_user, _name_user, _password_user, _avatar_user, _status_user, false));
					
				IF (_UPDATE_USER) THEN
					_UPDATE_OFFICIAL = (select * from business.dml_official_update(id_user_, _id_official, _id_company, _id_user, _id_area, _id_position, false));

					IF (_UPDATE_OFFICIAL) THEN
						RETURN QUERY select * from business.view_official_inner_join bvoij 
							where bvoij.id_official = _id_official;
					ELSE
						_EXCEPTION = 'Ocurrió un error al actualizar official';
						RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
					END IF;
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
			RAISE EXCEPTION '%', 'dml_official_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_official_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, character varying, character varying, character varying, boolean, numeric, numeric, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_official_delete_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_official_delete_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_official_delete_modified(
	id_user_ numeric,
	_id_official numeric)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_ID_USER NUMERIC;
	_ID_PERSON NUMERIC;
	_ID_JOB NUMERIC;
	_ID_ACADEMIC NUMERIC;
	_DELETE_ACADEMIC BOOLEAN;
	_DELETE_JOB BOOLEAN;
	_DELETE_PERSON BOOLEAN;
	_DELETE_USER BOOLEAN;
	_DELETE_OFFICIAL BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_USER = (select bvo.id_user from business.view_official bvo where bvo.id_official = _id_official);
 	_ID_PERSON = (select cvu.id_person from core.view_user cvu where cvu.id_user = _ID_USER);
	_ID_JOB = (select cvp.id_job from core.view_person cvp where cvp.id_person = _ID_PERSON);
	_ID_ACADEMIC = (select cva.id_academic from core.view_academic cva where cva.id_academic = _ID_PERSON);
 
 	_DELETE_OFFICIAL = (select * from business.dml_official_delete(id_user_, _id_official));
 
 	IF (_DELETE_OFFICIAL) THEN
		_DELETE_USER = (select * from core.dml_user_delete(id_user_, _ID_USER));
	
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
	ELSE
		_EXCEPTION = 'Ocurrió un error al eliminar official';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_official_delete_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_official_delete_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_attached_create_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_attached_create_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_attached_create_modified(
	id_user_ numeric,
	_id_company numeric)
    RETURNS TABLE(id_attached numeric, id_company numeric, name_attached character varying, description_attached character varying, length_mb_attached numeric, required_attached boolean, deleted_attached boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_ATTACHED NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_ATTACHED = (select * from business.dml_attached_create(id_user_, _id_company, 'Nuevo anexo', '', 1, false, false));
	
	IF (_ID_ATTACHED >= 1) THEN
		RETURN QUERY select * from business.view_attached_inner_join bvaij 
			where bvaij.id_attached = _ID_ATTACHED;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar attached';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_attached_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_attached_create_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_attached_update_modified(numeric, numeric, numeric, character varying, character varying, numeric, boolean, boolean)
-- DROP FUNCTION IF EXISTS business.dml_attached_update_modified(numeric, numeric, numeric, character varying, character varying, numeric, boolean, boolean);

CREATE OR REPLACE FUNCTION business.dml_attached_update_modified(
	id_user_ numeric,
	_id_attached numeric,
	_id_company numeric,
	_name_attached character varying,
	_description_attached character varying,
	_length_mb_attached numeric,
	_required_attached boolean,
	_deleted_attached boolean)
    RETURNS TABLE(id_attached numeric, id_company numeric, name_attached character varying, description_attached character varying, length_mb_attached numeric, required_attached boolean, deleted_attached boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_ATTACHED BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_ATTACHED = (select * from business.dml_attached_update(id_user_, _id_attached, _id_company, _name_attached, _description_attached, _length_mb_attached, _required_attached, _deleted_attached));

 	IF (_UPDATE_ATTACHED) THEN
		RETURN QUERY select * from business.view_attached_inner_join bvaij 
			where bvaij.id_attached = _id_attached;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar attached';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_attached_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_attached_update_modified(numeric, numeric, numeric, character varying, character varying, numeric, boolean, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_documentation_profile_create_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_documentation_profile_create_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_documentation_profile_create_modified(
	id_user_ numeric,
	_id_company numeric)
    RETURNS TABLE(id_documentation_profile numeric, id_company numeric, name_documentation_profile character varying, description_documentation_profile character varying, status_documentation_profile boolean, deleted_documentation_profile boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_DOCUMENTATION_PROFILE NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_DOCUMENTATION_PROFILE = (select * from business.dml_documentation_profile_create(id_user_, _id_company, 'Nuevo perfil de documentación', '', false, false));
	
	IF (_ID_DOCUMENTATION_PROFILE >= 1) THEN
		RETURN QUERY select * from business.view_documentation_profile_inner_join bvdpij 
			where bvdpij.id_documentation_profile = _ID_DOCUMENTATION_PROFILE;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar documentation_profile';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_documentation_profile_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_documentation_profile_create_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_documentation_profile_update_modified(numeric, numeric, numeric, character varying, character varying, boolean, boolean)
-- DROP FUNCTION IF EXISTS business.dml_documentation_profile_update_modified(numeric, numeric, numeric, character varying, character varying, boolean, boolean);

CREATE OR REPLACE FUNCTION business.dml_documentation_profile_update_modified(
	id_user_ numeric,
	_id_documentation_profile numeric,
	_id_company numeric,
	_name_documentation_profile character varying,
	_description_documentation_profile character varying,
	_status_documentation_profile boolean,
	_deleted_documentation_profile boolean)
    RETURNS TABLE(id_documentation_profile numeric, id_company numeric, name_documentation_profile character varying, description_documentation_profile character varying, status_documentation_profile boolean, deleted_documentation_profile boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_DOCUMENTATION_PROFILE BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_DOCUMENTATION_PROFILE = (select * from business.dml_documentation_profile_update(id_user_, _id_documentation_profile, _id_company, _name_documentation_profile, _description_documentation_profile, _status_documentation_profile, _deleted_documentation_profile));

 	IF (_UPDATE_DOCUMENTATION_PROFILE) THEN
		RETURN QUERY select * from business.view_documentation_profile_inner_join bvdpij 
			where bvdpij.id_documentation_profile = _id_documentation_profile;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar documentation_profile';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_documentation_profile_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_documentation_profile_update_modified(numeric, numeric, numeric, character varying, character varying, boolean, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_documentation_profile_delete_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_documentation_profile_delete_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_documentation_profile_delete_modified(
	id_user_ numeric,
	_id_documentation_profile numeric)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_X RECORD;
	_DELETE_ATTACHED BOOLEAN;
	_DELETE_DOCUMENTATION_PROFILE BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	FOR _X IN select * from business.view_documentation_profile_attached bvdpa where bvdpa.id_documentation_profile = _id_documentation_profile LOOP
		_DELETE_ATTACHED = (select * from business.dml_documentation_profile_attached_delete(id_user_, _X.id_documentation_profile_attached));
	END LOOP;
	
	_DELETE_DOCUMENTATION_PROFILE = (select * from business.dml_documentation_profile_delete(id_user_, _id_documentation_profile));
	IF (_DELETE_DOCUMENTATION_PROFILE) THEN
		RETURN true;
	ELSE
		_EXCEPTION = 'Ocurrió un error al eliminar documentation_profile';
	RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_documentation_profile_delete_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_documentation_profile_delete_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_documentation_profile_attached_create_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_documentation_profile_attached_create_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_documentation_profile_attached_create_modified(
	id_user_ numeric,
	_id_documentation_profile numeric)
    RETURNS TABLE(id_documentation_profile_attached numeric, id_documentation_profile numeric, id_attached numeric, name_documentation_profile character varying, description_documentation_profile character varying, status_documentation_profile boolean, name_attached character varying, description_attached character varying, length_mb_attached numeric, required_attached boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_COMPANY numeric;
	_ID_ATTACHED numeric;
	_ID_DOCUMENTATION_PROFILE_ATTACHED numeric;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	-- Get the id company _ID_COMPANY
	_ID_COMPANY = (select vu.id_company from core.view_user vu where vu.id_user = id_user_); 

	_ID_ATTACHED = (select attacheds.id_attached from (select bva.id_attached from business.view_attached bva where bva.id_company = _ID_COMPANY) as attacheds
		LEFT JOIN (select distinct bvdpa.id_attached from business.view_documentation_profile_attached bvdpa where bvdpa.id_documentation_profile = _id_documentation_profile) as assignedAttacheds
		on attacheds.id_attached = assignedAttacheds.id_attached where assignedAttacheds.id_attached IS NULL order by attacheds.id_attached asc limit 1);

	IF (_ID_ATTACHED >= 1) THEN
		_ID_DOCUMENTATION_PROFILE_ATTACHED = (select * from business.dml_documentation_profile_attached_create(id_user_, _id_documentation_profile, _ID_ATTACHED));

		IF (_ID_DOCUMENTATION_PROFILE_ATTACHED >= 1) THEN
			RETURN QUERY select * from business.view_documentation_profile_attached_inner_join bvdpaij 
				where bvdpaij.id_documentation_profile_attached = _ID_DOCUMENTATION_PROFILE_ATTACHED;
		ELSE
			_EXCEPTION = 'Ocurrió un error al ingresar attached';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'No se encontraron attached registrados';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_documentation_profile_attached_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_documentation_profile_attached_create_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_documentation_profile_attached_update_modified(numeric, numeric, numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_documentation_profile_attached_update_modified(numeric, numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_documentation_profile_attached_update_modified(
	id_user_ numeric,
	_id_documentation_profile_attached numeric,
	_id_documentation_profile numeric,
	_id_attached numeric)
    RETURNS TABLE(id_documentation_profile_attached numeric, id_documentation_profile numeric, id_attached numeric, name_documentation_profile character varying, description_documentation_profile character varying, status_documentation_profile boolean, name_attached character varying, description_attached character varying, length_mb_attached numeric, required_attached boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_DOCUMENTATION_PROFILE_ATTACHED BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_DOCUMENTATION_PROFILE_ATTACHED = (select * from business.dml_documentation_profile_attached_update(id_user_, _id_documentation_profile_attached, _id_documentation_profile, _id_attached));

 	IF (_UPDATE_DOCUMENTATION_PROFILE_ATTACHED) THEN
		RETURN QUERY select * from business.view_documentation_profile_attached_inner_join bvdpaij 
			where bvdpaij.id_documentation_profile_attached = _id_documentation_profile_attached;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar documentation_profile_attached';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_documentation_profile_attached_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_documentation_profile_attached_update_modified(numeric, numeric, numeric, numeric)
    OWNER TO postgres;
	
-- FUNCTION: business.dml_item_category_create_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_item_category_create_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_item_category_create_modified(
	id_user_ numeric,
	_id_company numeric)
    RETURNS TABLE(id_item_category numeric, id_company numeric, name_item_category character varying, description_item_category character varying, deleted_item_category boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_ITEM_CATEGORY NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_ITEM_CATEGORY = (select * from business.dml_item_category_create(id_user_, _id_company, 'Nueva categoria', '', false));
	
	IF (_ID_ITEM_CATEGORY >= 1) THEN
		RETURN QUERY select * from business.view_item_category_inner_join bvicij 
			where bvicij.id_item_category = _ID_ITEM_CATEGORY;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar item_category';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_item_category_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_item_category_create_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_item_category_update_modified(numeric, numeric, numeric, character varying, character varying, boolean)
-- DROP FUNCTION IF EXISTS business.dml_item_category_update_modified(numeric, numeric, numeric, character varying, character varying, boolean);

CREATE OR REPLACE FUNCTION business.dml_item_category_update_modified(
	id_user_ numeric,
	_id_item_category numeric,
	_id_company numeric,
	_name_item_category character varying,
	_description_item_category character varying,
	_deleted_item_category boolean)
    RETURNS TABLE(id_item_category numeric, id_company numeric, name_item_category character varying, description_item_category character varying, deleted_item_category boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_ITEM_CATEGORY BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_ITEM_CATEGORY = (select * from business.dml_item_category_update(id_user_, _id_item_category, _id_company, _name_item_category, _description_item_category, _deleted_item_category));

 	IF (_UPDATE_ITEM_CATEGORY) THEN
		RETURN QUERY select * from business.view_item_category_inner_join bvicij 
			where bvicij.id_item_category = _id_item_category;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar item_category';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_item_category_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_item_category_update_modified(numeric, numeric, numeric, character varying, character varying, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_item_create_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_item_create_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_item_create_modified(
	id_user_ numeric,
	_id_company numeric)
    RETURNS TABLE(id_item numeric, id_company numeric, id_item_category numeric, name_item character varying, description_item character varying, deleted_item boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, name_item_category character varying, description_item_category character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_ITEM_CATEGORY NUMERIC;
	_ID_ITEM NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_ITEM_CATEGORY = (select bvic.id_item_category from business.view_item_category bvic where bvic.id_company = _id_company order by bvic.id_item_category asc limit 1);
	
	IF (_ID_ITEM_CATEGORY >= 1) THEN
		_ID_ITEM = (select * from business.dml_item_create(id_user_, _id_company, _ID_ITEM_CATEGORY, 'Nuevo articulo', '', false));
		
		IF (_ID_ITEM >= 1) THEN
			RETURN QUERY select * from business.view_item_inner_join bviij 
				where bviij.id_item = _ID_ITEM;
		ELSE
			_EXCEPTION = 'Ocurrió un error al ingresar item';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'No se encontraron categorías registradas';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_item_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_item_create_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_item_update_modified(numeric, numeric, numeric, numeric, character varying, character varying, character varying, boolean)
-- DROP FUNCTION IF EXISTS business.dml_item_update_modified(numeric, numeric, numeric, numeric, character varying, character varying, character varying, boolean);

CREATE OR REPLACE FUNCTION business.dml_item_update_modified(
	id_user_ numeric,
	_id_item numeric,
	_id_company numeric,
	_id_item_category numeric,
	_name_item character varying,
	_description_item character varying,
	_deleted_item boolean)
    RETURNS TABLE(id_item numeric, id_company numeric, id_item_category numeric, name_item character varying, description_item character varying, deleted_item boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, name_item_category character varying, description_item_category character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_ITEM BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_ITEM = (select * from business.dml_item_update(id_user_, _id_item, _id_company, _id_item_category, _name_item, _description_item, _deleted_item));

 	IF (_UPDATE_ITEM) THEN
		RETURN QUERY select * from business.view_item_inner_join bviij 
			where bviij.id_item = _id_item;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar item';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_item_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_item_update_modified(numeric, numeric, numeric, numeric, character varying, character varying, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_control_create(numeric, numeric, business."TYPE_CONTROL", character varying, character varying, character varying, boolean, numeric, numeric, character varying, boolean, json, boolean, boolean, numeric)
-- DROP FUNCTION IF EXISTS business.dml_control_create(numeric, numeric, business."TYPE_CONTROL", character varying, character varying, character varying, boolean, numeric, numeric, character varying, boolean, json, boolean, boolean, numeric);

CREATE OR REPLACE FUNCTION business.dml_control_create(
	id_user_ numeric,
	_id_company numeric,
	_type_control business."TYPE_CONTROL",
	_title_control character varying,
	_form_name_control character varying,
	_initial_value_control character varying,
	_required_control boolean,
	_min_length_control numeric,
	_max_length_control numeric,
	_placeholder_control character varying,
	_spell_check_control boolean,
	_options_control json,
	_in_use boolean,
	_deleted_control boolean,
	_id_template numeric)
    RETURNS numeric
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_RESPONSE BOOLEAN DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_ATT NUMERIC;
	_COUNT_EXTERNALS_IDS NUMERIC;
	_RETURNING NUMERIC;
	_CURRENT_ID NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN 
	-- company
	_COUNT_EXTERNALS_IDS = (select count(*) from core.view_company v where v.id_company = _id_company);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_company||' de la tabla company no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_CURRENT_ID = (select nextval('business.serial_control')-1);
	_COUNT = (select count(*) from business.view_control t where t.id_control = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from business.view_template_control bvtc
			inner join business.view_control bvc on bvtc.id_control = bvc.id_control
			where bvc.form_name_control = _form_name_control and bvtc.id_template = _id_template);
			
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO business.control(id_control, id_company, type_control, title_control, form_name_control, initial_value_control, required_control, min_length_control, max_length_control, placeholder_control, spell_check_control, options_control, in_use, deleted_control) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6 ,$7 ,$8 ,$9 ,$10 ,$11 ,$12 ,$13 ,$14) RETURNING id_control LOOP
				_RETURNING = _X.id_control;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'control',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
					IF (_RESPONSE != true) THEN
						_EXCEPTION = 'Ocurrió un error al registrar el evento del sistema';
						RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
					ELSE
						RETURN _CURRENT_ID;
					END IF;
				ELSE 
					RETURN _CURRENT_ID;
				END IF;
			ELSE
				_EXCEPTION = 'Ocurrió un error al insertar el registro';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE
			_EXCEPTION = 'Ya existe un registro con el form_name_control '||_form_name_control||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla control';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_control'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_control_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_control_create(numeric, numeric, business."TYPE_CONTROL", character varying, character varying, character varying, boolean, numeric, numeric, character varying, boolean, json, boolean, boolean, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_control_create_modified(numeric, numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_control_create_modified(numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_control_create_modified(
	id_user_ numeric,
	_id_company numeric,
	_id_template numeric)
    RETURNS TABLE(id_control numeric, id_company numeric, type_control business."TYPE_CONTROL", title_control character varying, form_name_control character varying, initial_value_control character varying, required_control boolean, min_length_control numeric, max_length_control numeric, placeholder_control character varying, spell_check_control boolean, options_control json, in_use boolean, deleted_control boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_CONTROL NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_CONTROL = (select * from business.dml_control_create(id_user_, _ID_COMPANY, 'input', 'Nuevo control', 'form_control', '', false, 1, 1, '', false, '[
	  {
		"name": "One",
		"value": "one"
	  },
	  {
		"name": "Two",
		"value": "two"
	  },
	  {
		"name": "Three",
		"value": "three"
	  }
	]', false, false, _id_template));
	
	IF (_ID_CONTROL >= 1) THEN
		RETURN QUERY select * from business.view_control_inner_join bvcij 
			where bvcij.id_control = _ID_CONTROL;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar control';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_control_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_control_create_modified(numeric, numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_control_update(numeric, numeric, numeric, business."TYPE_CONTROL", character varying, character varying, character varying, boolean, numeric, numeric, character varying, boolean, json, boolean, boolean, numeric)
-- DROP FUNCTION IF EXISTS business.dml_control_update(numeric, numeric, numeric, business."TYPE_CONTROL", character varying, character varying, character varying, boolean, numeric, numeric, character varying, boolean, json, boolean, boolean, numeric);

CREATE OR REPLACE FUNCTION business.dml_control_update(
	id_user_ numeric,
	_id_control numeric,
	_id_company numeric,
	_type_control business."TYPE_CONTROL",
	_title_control character varying,
	_form_name_control character varying,
	_initial_value_control character varying,
	_required_control boolean,
	_min_length_control numeric,
	_max_length_control numeric,
	_placeholder_control character varying,
	_spell_check_control boolean,
	_options_control json,
	_in_use boolean,
	_deleted_control boolean,
	_id_template numeric)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_ATT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_EXTERNALS_IDS NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN 
	-- company
	_COUNT_EXTERNALS_IDS = (select count(*) from core.view_company v where v.id_company = _id_company);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_company||' de la tabla company no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_COUNT = (select count(*) from business.view_control t where t.id_control = _id_control);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_control t where t.id_control = _id_control and deleted_control = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from business.view_template_control bvtc
				inner join business.view_control bvc on bvtc.id_control = bvc.id_control
				where bvc.form_name_control = _form_name_control and bvtc.id_template = _id_template and bvtc.id_control != _id_control);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE business.control SET id_company=$3, type_control=$4, title_control=$5, form_name_control=$6, initial_value_control=$7, required_control=$8, min_length_control=$9, max_length_control=$10, placeholder_control=$11, spell_check_control=$12, options_control=$13, in_use=$14, deleted_control=$15 WHERE id_control=$2 RETURNING id_control LOOP
					_RETURNING = _X.id_control;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'control',_id_control,'UPDATE', now()::timestamp, false));
						
						IF (_RESPONSE != true) THEN
							_EXCEPTION = 'Ocurrió un error al registrar el evento del sistema';
							RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
						ELSE
							RETURN _RESPONSE;
						END IF;
					ELSE
						RETURN true;
					END IF;
				ELSE
					_EXCEPTION = 'Ocurrió un error al actualizar el registro';
					RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
				END IF;
			ELSE
				_EXCEPTION = 'Ya existe un registro con el form_name_control '||_form_name_control||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_control||' no se encuentra registrado en la tabla control';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_control_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_control_update(numeric, numeric, numeric, business."TYPE_CONTROL", character varying, character varying, character varying, boolean, numeric, numeric, character varying, boolean, json, boolean, boolean, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_control_update_modified(numeric, numeric, numeric, business."TYPE_CONTROL", character varying, character varying, character varying, boolean, numeric, numeric, character varying, boolean, json, boolean, boolean)
-- DROP FUNCTION IF EXISTS business.dml_control_update_modified(numeric, numeric, numeric, business."TYPE_CONTROL", character varying, character varying, character varying, boolean, numeric, numeric, character varying, boolean, json, boolean, boolean);

CREATE OR REPLACE FUNCTION business.dml_control_update_modified(
	id_user_ numeric,
	_id_control numeric,
	_id_company numeric,
	_type_control business."TYPE_CONTROL",
	_title_control character varying,
	_form_name_control character varying,
	_initial_value_control character varying,
	_required_control boolean,
	_min_length_control numeric,
	_max_length_control numeric,
	_placeholder_control character varying,
	_spell_check_control boolean,
	_options_control json,
	_in_use boolean,
	_deleted_control boolean)
    RETURNS TABLE(id_control numeric, id_company numeric, type_control business."TYPE_CONTROL", title_control character varying, form_name_control character varying, initial_value_control character varying, required_control boolean, min_length_control numeric, max_length_control numeric, placeholder_control character varying, spell_check_control boolean, options_control json, in_use boolean, deleted_control boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_CONTROL BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_CONTROL = (select * from business.dml_control_update(id_user_, _id_control, _id_company, _type_control, _title_control, _form_name_control, _initial_value_control, _required_control, _min_length_control, _max_length_control, _placeholder_control, _spell_check_control, _options_control, _in_use, _deleted_control));

 	IF (_UPDATE_CONTROL) THEN
		RETURN QUERY select * from business.view_control_inner_join bvcij 
			where bvcij.id_control = _id_control;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar control';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_control_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_control_update_modified(numeric, numeric, numeric, business."TYPE_CONTROL", character varying, character varying, character varying, boolean, numeric, numeric, character varying, boolean, json, boolean, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_control_delete_cascade(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_control_delete_cascade(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_control_delete_cascade(
	id_user_ numeric,
	_id_control numeric)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
 	_X RECORD;
	_DELETE_TEMPLATE_CONTROL BOOLEAN;
	_DELETE_CONTROL BOOLEAN;
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN
 	FOR _X IN select * from business.view_template_control bvtc where bvtc.id_control = _id_control LOOP
		_DELETE_TEMPLATE_CONTROL = (select * from business.dml_template_control_delete(id_user_, _X.id_template_control));
	END LOOP;
 
	_DELETE_CONTROL = (select * from business.dml_control_delete(id_user_, _id_control));
	IF (_DELETE_CONTROL) THEN
		RETURN true;
	ELSE
		_EXCEPTION = 'Ocurrió un error al eliminar control';
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

ALTER FUNCTION business.dml_control_delete_cascade(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_control_by_position_level(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_control_by_position_level(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_control_by_position_level(
	id_user_ numeric,
	_position_level numeric)
    RETURNS TABLE(id_control numeric, id_company numeric, type_control business."TYPE_CONTROL", title_control character varying, form_name_control character varying, initial_value_control character varying, required_control boolean, min_length_control numeric, max_length_control numeric, placeholder_control character varying, spell_check_control boolean, options_control json, in_use boolean, deleted_control boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN 
	IF (_position_level > 0) THEN
		RETURN QUERY select tc.id_control, tc.id_company, tc.type_control, tc.title_control, tc.form_name_control, tc.initial_value_control, tc.required_control, tc.min_length_control, tc.max_length_control, tc.placeholder_control, tc.spell_check_control, tc.options_control, tc.in_use, tc.deleted_control, tc.id_setting, tc.name_company, tc.acronym_company, tc.address_company, tc.status_company from (select 
			bvtc.id_template, bvc.*, cvc.id_setting, cvc.name_company, cvc.acronym_company, cvc.address_company, cvc.status_company 
			from business.view_template_control bvtc
			inner join business.view_control bvc on bvc.id_control = bvtc.id_control
			inner join core.view_company cvc on cvc.id_company = bvc.id_company) as tc 
			LEFT JOIN (select DISTINCT bvt.id_template from business.view_flow_version_level bvfvl
			inner join business.view_level bvl on bvl.id_level = bvfvl.id_level
			inner join business.view_template bvt on bvt.id_template = bvl.id_template
			where bvfvl.position_level < _position_level) as fvl 
		on tc.id_template = fvl.id_template where fvl.id_template IS NOT NULL order by tc.id_control asc;
	ELSE
		_EXCEPTION = 'El _position_level '||_position_level||' es incorrecto';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_control_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_control_by_position_level(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_plugin_item_create_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_plugin_item_create_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_plugin_item_create_modified(
	id_user_ numeric,
	_id_company numeric)
    RETURNS TABLE(id_plugin_item numeric, id_company numeric, name_plugin_item character varying, description_plugin_item character varying, select_plugin_item boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_PLUGIN_ITEM NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_PLUGIN_ITEM = (select * from business.dml_plugin_item_create(id_user_, _id_company, 'Nuevo plugin item', '', false));
	
	IF (_ID_PLUGIN_ITEM >= 1) THEN
		RETURN QUERY select * from business.view_plugin_item_inner_join bvpiij 
			where bvpiij.id_plugin_item = _ID_PLUGIN_ITEM;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar plugin_item';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_plugin_item_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_plugin_item_create_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_plugin_item_update_modified(numeric, numeric, numeric, character varying, character varying)
-- DROP FUNCTION IF EXISTS business.dml_plugin_item_update_modified(numeric, numeric, numeric, character varying, character varying);

CREATE OR REPLACE FUNCTION business.dml_plugin_item_update_modified(
	id_user_ numeric,
	_id_plugin_item numeric,
	_id_company numeric,
	_name_plugin_item character varying,
	_description_plugin_item character varying,
	_select_plugin_item boolean)
    RETURNS TABLE(id_plugin_item numeric, id_company numeric, name_plugin_item character varying, description_plugin_item character varying, select_plugin_item boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_PLUGIN_ITEM BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_PLUGIN_ITEM = (select * from business.dml_plugin_item_update(id_user_, _id_plugin_item, _id_company, _name_plugin_item, _description_plugin_item, _select_plugin_item));

 	IF (_UPDATE_PLUGIN_ITEM) THEN
		RETURN QUERY select * from business.view_plugin_item_inner_join bvpiij 
			where bvpiij.id_plugin_item = _id_plugin_item;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar plugin_item';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_plugin_item_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_plugin_item_update_modified(numeric, numeric, numeric, character varying, character varying, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_plugin_item_column_create_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_plugin_item_column_create_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_plugin_item_column_create_modified(
	id_user_ numeric,
	_id_plugin_item numeric)
    RETURNS TABLE(id_plugin_item_column numeric, id_plugin_item numeric, name_plugin_item_column character varying, lenght_plugin_item_column numeric, id_company numeric, name_plugin_item character varying, description_plugin_item character varying, select_plugin_item boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_PLUGIN_ITEM_COLUMN NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_PLUGIN_ITEM_COLUMN = (select * from business.dml_plugin_item_column_create(id_user_, _id_plugin_item, 'Nueva columna', 10));
	
	IF (_ID_PLUGIN_ITEM_COLUMN >= 1) THEN
		RETURN QUERY select * from business.view_plugin_item_column_inner_join bvpicij 
			where bvpicij.id_plugin_item_column = _ID_PLUGIN_ITEM_COLUMN;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar plugin_item_column';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_plugin_item_column_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_plugin_item_column_create_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_plugin_item_column_update_modified(numeric, numeric, numeric, character varying, numeric)
-- DROP FUNCTION IF EXISTS business.dml_plugin_item_column_update_modified(numeric, numeric, numeric, character varying, numeric);

CREATE OR REPLACE FUNCTION business.dml_plugin_item_column_update_modified(
	id_user_ numeric,
	_id_plugin_item_column numeric,
	_id_plugin_item numeric,
	_name_plugin_item_column character varying,
	_lenght_plugin_item_column numeric)
    RETURNS TABLE(id_plugin_item_column numeric, id_plugin_item numeric, name_plugin_item_column character varying, lenght_plugin_item_column numeric, id_company numeric, name_plugin_item character varying, description_plugin_item character varying, select_plugin_item boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_PLUGIN_ITEM_COLUMN BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_PLUGIN_ITEM_COLUMN = (select * from business.dml_plugin_item_column_update(id_user_, _id_plugin_item_column, _id_plugin_item, _name_plugin_item_column, _lenght_plugin_item_column));

 	IF (_UPDATE_PLUGIN_ITEM_COLUMN) THEN
		RETURN QUERY select * from business.view_plugin_item_column_inner_join bvpicij 
			where bvpicij.id_plugin_item_column = _id_plugin_item_column;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar plugin_item_column';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_plugin_item_column_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_plugin_item_column_update_modified(numeric, numeric, numeric, character varying, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_template_create_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_template_create_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_template_create_modified(
	id_user_ numeric,
	_id_company numeric)
    RETURNS TABLE(id_template numeric, id_company numeric, id_documentation_profile numeric, id_plugin_item numeric, plugin_attached_process boolean, plugin_item_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, in_use boolean, deleted_template boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, name_documentation_profile character varying, description_documentation_profile character varying, status_documentation_profile boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_DOCUMENTATION_PROFILE NUMERIC;
	_ID_PLUGIN_ITEM NUMERIC;
	_ID_TEMPLATE NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_DOCUMENTATION_PROFILE = (select bvdp.id_documentation_profile from business.view_documentation_profile bvdp order by bvdp.id_documentation_profile asc limit 1);
	
	IF (_ID_DOCUMENTATION_PROFILE IS NULL) THEN
		_EXCEPTION = 'No se encontró un documentation_profile';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	
	_ID_PLUGIN_ITEM = (select bvpi.id_plugin_item from business.view_plugin_item bvpi order by bvpi.id_plugin_item asc limit 1);
	
	IF (_ID_DOCUMENTATION_PROFILE IS NULL) THEN
		_EXCEPTION = 'No se encontró un plugin_item';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	
	_ID_TEMPLATE = (select * from business.dml_template_create(id_user_, _ID_COMPANY, _ID_DOCUMENTATION_PROFILE, _ID_PLUGIN_ITEM, false, false, 'Nueva plantilla', '', false, now()::timestamp, false, false));
	IF (_ID_TEMPLATE >= 1) THEN
		RETURN QUERY select * from business.view_template_inner_join bvtij 
			where bvtij.id_template = _ID_TEMPLATE;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar template';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_template_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_template_create_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_template_update_modified(numeric, numeric, numeric, numeric, numeric, boolean, boolean, character varying, character varying, boolean, timestamp without time zone, boolean, boolean)
-- DROP FUNCTION IF EXISTS business.dml_template_update_modified(numeric, numeric, numeric, numeric, numeric, boolean, boolean, character varying, character varying, boolean, timestamp without time zone, boolean, boolean);

CREATE OR REPLACE FUNCTION business.dml_template_update_modified(
	id_user_ numeric,
	_id_template numeric,
	_id_company numeric,
	_id_documentation_profile numeric,
	_id_plugin_item numeric,
	_plugin_attached_process boolean,
	_plugin_item_process boolean,
	_name_template character varying,
	_description_template character varying,
	_status_template boolean,
	_last_change timestamp without time zone,
	_in_use boolean,
	_deleted_template boolean)
    RETURNS TABLE(id_template numeric, id_company numeric, id_documentation_profile numeric, id_plugin_item numeric, plugin_attached_process boolean, plugin_item_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, in_use boolean, deleted_template boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, name_documentation_profile character varying, description_documentation_profile character varying, status_documentation_profile boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_TEMPLATE BOOLEAN;
 	_UPDATE_LAST_CHANGE BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_TEMPLATE = (select * from business.dml_template_update(id_user_, _id_template, _id_company, _id_documentation_profile, _id_plugin_item, _plugin_attached_process, _plugin_item_process, _name_template, _description_template, _status_template, _last_change, _in_use, _deleted_template));

 	IF (_UPDATE_TEMPLATE) THEN
		_UPDATE_LAST_CHANGE = (select * from business.dml_template_update_last_change(id_user_, _id_template));

		RETURN QUERY select * from business.view_template_inner_join bvtij 
			where bvtij.id_template = _id_template;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar template';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_template_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_template_update_modified(numeric, numeric, numeric, numeric, numeric, boolean, boolean, character varying, character varying, boolean, timestamp without time zone, boolean, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_template_delete_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_template_delete_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_template_delete_modified(
	id_user_ numeric,
	_id_template numeric)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_X RECORD;
	_DELETE_CONTROL BOOLEAN;
	_DELETE_TEMPLATE BOOLEAN;
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN
	FOR _X IN select * from business.view_template_control bvtc where bvtc.id_template = _id_template LOOP
		_DELETE_CONTROL = (select * from business.dml_template_control_delete(id_user_, _X.id_template_control));
	END LOOP;
	
	_DELETE_TEMPLATE = (select * from business.dml_template_delete(id_user_, _id_template));
	IF (_DELETE_TEMPLATE) THEN
		RETURN true;
	ELSE
		_EXCEPTION = 'Ocurrió un error al eliminar template';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_template_delete_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_template_delete_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_template_control_create_modified(numeric, numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_template_control_create_modified(numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_template_control_create_modified(
	id_user_ numeric,
	_id_template numeric,
	_id_control numeric)
    RETURNS TABLE(id_template_control numeric, id_template numeric, id_control numeric, ordinal_position numeric, id_documentation_profile numeric, id_plugin_item numeric, plugin_attached_process boolean, plugin_item_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, type_control business."TYPE_CONTROL", title_control character varying, form_name_control character varying, initial_value_control character varying, required_control boolean, min_length_control numeric, max_length_control numeric, placeholder_control character varying, spell_check_control boolean, options_control json, in_use boolean, id_company numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ORDINAL_POSITION NUMERIC;
	_ID_TEMPLATE_CONTROL NUMERIC;
	_UPDATE_LAST_CHANGE BOOLEAN;
	_UPDATE_IN_USE BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ORDINAL_POSITION = (select bvtc.ordinal_position from business.view_template_control bvtc order by bvtc.id_template_control desc limit 1);

	IF (_ORDINAL_POSITION IS NULL) THEN
		_ORDINAL_POSITION = 0;
	END IF;
	
	_ID_TEMPLATE_CONTROL = (select * from business.dml_template_control_create(id_user_, _id_template, _id_control, _ORDINAL_POSITION + 1));
	
	IF (_ID_TEMPLATE_CONTROL >= 1) THEN
		_UPDATE_LAST_CHANGE = (select * from business.dml_template_update_last_change(id_user_, _id_template));
		_UPDATE_IN_USE = (select * from business.dml_control_update_in_use(id_user_, _id_control, true));
		
		RETURN QUERY select * from business.view_template_control_inner_join bvtcij 
			where bvtcij.id_template_control = _ID_TEMPLATE_CONTROL;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar template_control';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_template_control_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_template_control_create_modified(numeric, numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_template_control_create_with_new_control(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_template_control_create_with_new_control(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_template_control_create_with_new_control(
	id_user_ numeric,
	_id_template numeric)
    RETURNS TABLE(id_template_control numeric, id_template numeric, id_control numeric, ordinal_position numeric, id_documentation_profile numeric, id_plugin_item numeric, plugin_attached_process boolean, plugin_item_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, type_control business."TYPE_CONTROL", title_control character varying, form_name_control character varying, initial_value_control character varying, required_control boolean, min_length_control numeric, max_length_control numeric, placeholder_control character varying, spell_check_control boolean, options_control json, in_use boolean, id_company numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ORDINAL_POSITION NUMERIC;
	_ID_COMPANY NUMERIC;
	_ID_CONTROL NUMERIC;
	_ID_TEMPLATE_CONTROL NUMERIC;
	_UPDATE_LAST_CHANGE BOOLEAN;
	_UPDATE_IN_USE BOOLEAN;
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN
	_ORDINAL_POSITION = (select bvtc.ordinal_position from business.view_template_control bvtc order by bvtc.id_template_control desc limit 1);
	
	IF (_ORDINAL_POSITION IS NULL) THEN
		_ORDINAL_POSITION = 0;
	END IF;
		
	-- Get the id company _ID_COMPANY
	_ID_COMPANY = (select vu.id_company from core.view_user vu where vu.id_user = id_user_); 
	_ID_CONTROL = (select newControl.id_control from (select * from business.dml_control_create_modified(id_user_,_ID_COMPANY,_id_template)) as newControl);
	
	IF (_ID_CONTROL >= 1) THEN
		_ID_TEMPLATE_CONTROL = (select * from business.dml_template_control_create(id_user_, _id_template, _ID_CONTROL, _ORDINAL_POSITION + 1));
		
		IF (_ID_TEMPLATE_CONTROL >= 1) THEN
			_UPDATE_LAST_CHANGE = (select * from business.dml_template_update_last_change(id_user_, _id_template));
			_UPDATE_IN_USE = (select * from business.dml_control_update_in_use(id_user_, _id_control, true));
			
			RETURN QUERY select * from business.view_template_control_inner_join bvtcij 
			where bvtcij.id_template_control = _ID_TEMPLATE_CONTROL;
		ELSE
			_EXCEPTION = 'Ocurrió un error al ingresar template_control';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar control';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_template_control_create_with_new_control -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
			
$BODY$;

ALTER FUNCTION business.dml_template_control_create_with_new_control(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_template_update_last_change(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_template_update_last_change(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_template_update_last_change(
	id_user_ numeric,
	_id_template numeric)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_RETURNIG NUMERIC;
	_X RECORD;
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN 
	FOR _X IN UPDATE business.template SET last_change = now()::timestamp  WHERE id_template = _id_template RETURNING id_template LOOP
		_RETURNIG = _X.id_template;
	END LOOP;

	IF (_RETURNIG >= 1) THEN
		RETURN true;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar last_change';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_template_update_last_change -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
			 
$BODY$;

ALTER FUNCTION business.dml_template_update_last_change(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_control_update_in_use(numeric, numeric, boolean)
-- DROP FUNCTION IF EXISTS business.dml_control_update_in_use(numeric, numeric, boolean);

CREATE OR REPLACE FUNCTION business.dml_control_update_in_use(
	id_user_ numeric,
	_id_control numeric,
	_in_use boolean)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_ATT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_EXTERNALS_IDS NUMERIC;
	_RETURNIG NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN 
 	FOR _X IN UPDATE business.control SET in_use = _in_use WHERE id_control = _id_control RETURNING id_control LOOP
		_RETURNIG = _X.id_control;
 	END LOOP;
 	
	IF (_RETURNIG >= 1) THEN
	 	RETURN true;
 	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar in_use';
	 	RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
 	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_control_update_in_use -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
			 
$BODY$;

ALTER FUNCTION business.dml_control_update_in_use(numeric, numeric, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_template_control_update_control_properties_modified(numeric, numeric, numeric, numeric, numeric, numeric, business."TYPE_CONTROL", character varying, character varying, character varying, boolean, numeric, numeric, character varying, boolean, json, boolean, boolean)
-- DROP FUNCTION IF EXISTS business.dml_template_control_update_control_properties_modified(numeric, numeric, numeric, numeric, numeric, numeric, business."TYPE_CONTROL", character varying, character varying, character varying, boolean, numeric, numeric, character varying, boolean, json, boolean, boolean);

CREATE OR REPLACE FUNCTION business.dml_template_control_update_control_properties_modified(
	id_user_ numeric,
	_id_template_control numeric,
	_id_template numeric,
	_id_control numeric,
	_ordinal_position numeric,
	_id_company numeric,
	_type_control business."TYPE_CONTROL",
	_title_control character varying,
	_form_name_control character varying,
	_initial_value_control character varying,
	_required_control boolean,
	_min_length_control numeric,
	_max_length_control numeric,
	_placeholder_control character varying,
	_spell_check_control boolean,
	_options_control json,
	_in_use boolean,
	_deleted_control boolean)
    RETURNS TABLE(id_template_control numeric, id_template numeric, id_control numeric, ordinal_position numeric, id_documentation_profile numeric, id_plugin_item numeric, plugin_attached_process boolean, plugin_item_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, type_control business."TYPE_CONTROL", title_control character varying, form_name_control character varying, initial_value_control character varying, required_control boolean, min_length_control numeric, max_length_control numeric, placeholder_control character varying, spell_check_control boolean, options_control json, in_use boolean, id_company numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_CONTROL BOOLEAN;
 	_UPDATE_TEMPLATE_CONTROL BOOLEAN;
	_UPDATE_LAST_CHANGE BOOLEAN;
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_CONTROL = (select * from business.dml_control_update(id_user_, _id_control, _id_company, _type_control, _title_control, _form_name_control, _initial_value_control, _required_control, _min_length_control, _max_length_control, _placeholder_control, _spell_check_control, _options_control, _in_use, _deleted_control, _id_template));
 	
	IF (_UPDATE_CONTROL) THEN
		_UPDATE_TEMPLATE_CONTROL = (select * from business.dml_template_control_update(id_user_, _id_template_control, _id_template, _id_control, _ordinal_position));
		IF (_UPDATE_TEMPLATE_CONTROL) THEN
			_UPDATE_LAST_CHANGE = (select * from business.dml_template_update_last_change(id_user_, _id_template));
		
			RETURN QUERY select * from business.view_template_control_inner_join bvtcij 
				where bvtcij.id_template_control = _id_template_control;
		ELSE
			_EXCEPTION = 'Ocurrió un error al actualizar template_control';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar control';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_template_control_update_control_properties_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
			 
$BODY$;

ALTER FUNCTION business.dml_template_control_update_control_properties_modified(numeric, numeric, numeric, numeric, numeric, numeric, business."TYPE_CONTROL", character varying, character varying, character varying, boolean, numeric, numeric, character varying, boolean, json, boolean, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_template_control_update_positions(numeric, json)
-- DROP FUNCTION IF EXISTS business.dml_template_control_update_positions(numeric, json);

CREATE OR REPLACE FUNCTION business.dml_template_control_update_positions(
	id_user_ numeric,
	_id_template numeric,
	_template_control json)
    RETURNS TABLE(id_template_control numeric, id_template numeric, id_control numeric, ordinal_position numeric, id_documentation_profile numeric, id_plugin_item numeric, plugin_attached_process boolean, plugin_item_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, type_control business."TYPE_CONTROL", title_control character varying, form_name_control character varying, initial_value_control character varying, required_control boolean, min_length_control numeric, max_length_control numeric, placeholder_control character varying, spell_check_control boolean, options_control json, in_use boolean, id_company numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_X RECORD;
	_INDEX NUMERIC = 0;
 	_UPDATE_ORDINAL_POSITION BOOLEAN;
	_ID_TEMPLATE NUMERIC;
	_UPDATE_LAST_CHANGE BOOLEAN;
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN
	FOR _X IN SELECT * FROM json_array_elements(_template_control) LOOP
		_INDEX = _INDEX + 1;
		_ID_TEMPLATE = (_X.value->'template'->>'id_template')::numeric;
		_UPDATE_ORDINAL_POSITION = (select * from business.dml_template_control_update_ordinal_position(id_user_, (_X.value->>'id_template_control')::numeric, _INDEX));
	END LOOP;
 	
	IF (_UPDATE_ORDINAL_POSITION) THEN
		_UPDATE_LAST_CHANGE = (select * from business.dml_template_update_last_change(id_user_, _ID_TEMPLATE));
	
		RETURN QUERY select * from business.view_template_control_inner_join bvtcij where bvtcij.id_template = _id_template order by bvtcij.ordinal_position asc;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar positions';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_template_control_update_positions -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
			 
$BODY$;

ALTER FUNCTION business.dml_template_control_update_positions(numeric, numeric, json)
    OWNER TO postgres;

-- FUNCTION: business.dml_template_control_delete(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_template_control_delete(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_template_control_delete(
	id_user_ numeric,
	_id_template_control numeric)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_ID_CONTROL NUMERIC;
	_UPDATE_IN_USE BOOLEAN;
	_RETURNIG NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_template_control t where t.id_template_control = _id_template_control);
	
	IF (_COUNT = 1) THEN
		_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','template_control', _id_template_control));
			
		IF (_COUNT_DEPENDENCY > 0) THEN
			_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		ELSE
			_ID_CONTROL = (select bvtc.id_control from business.view_template_control bvtc where bvtc.id_template_control = _id_template_control);
			
			FOR _X IN DELETE FROM business.template_control WHERE id_template_control = _id_template_control RETURNING id_template_control LOOP
				_RETURNIG = _X.id_template_control;
			END LOOP;
			
			IF (_RETURNIG >= 1) THEN
				_UPDATE_IN_USE = (select * from business.dml_control_update_in_use(id_user_, _ID_CONTROL, false));
				
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'template_control',_id_template_control,'DELETE', now()::timestamp, false));
						
					IF (_RESPONSE != true) THEN
						_EXCEPTION = 'Ocurrió un error al registrar el evento del sistema';
						RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
					ELSE
						RETURN _RESPONSE;
					END IF;
				ELSE
					RETURN true;
				END IF;
			ELSE
				_EXCEPTION = 'Ocurrió un error al eliminar el registro';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_template_control||' no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_template_control_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
			 
$BODY$;

ALTER FUNCTION business.dml_template_control_delete(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_template_control_delete_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_template_control_delete_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_template_control_delete_modified(
	id_user_ numeric,
	_id_template_control numeric)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_ID_CONTROL NUMERIC;
	_ID_TEMPLATE NUMERIC;
 	_COUNT_DELETE_CONTROL BOOLEAN;
 	_COUNT_DELETE BOOLEAN;
 	_UPDATE_LAST_CHANGE BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_CONTROL = (select bvtc.id_control from business.view_template_control bvtc where bvtc.id_template_control = _id_template_control);
	_ID_TEMPLATE = (select bvtc.id_template from business.view_template_control bvtc where bvtc.id_template_control = _id_template_control);
	
	_COUNT_DELETE = (select * from business.dml_template_control_delete(id_user_, _id_template_control));
	
	IF (_COUNT_DELETE) THEN
		_COUNT_DELETE_CONTROL = (select * from business.dml_control_delete(id_user_, _ID_CONTROL));
		
		IF (_COUNT_DELETE_CONTROL) THEN
			_UPDATE_LAST_CHANGE = (select * from business.dml_template_update_last_change(id_user_, _ID_TEMPLATE));

			RETURN true;
		ELSE
			_EXCEPTION = 'Ocurrió un error al eliminar control';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'Ocurrió un error al eliminar template_control';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_template_control_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
			 
$BODY$;

ALTER FUNCTION business.dml_template_control_delete_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_template_control_update_ordinal_position(numeric, numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_template_control_update_ordinal_position(numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_template_control_update_ordinal_position(
	id_user_ numeric,
	_id_template_control numeric,
	_ordinal_position numeric)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
 	_X RECORD;
 	_RETURNIG NUMERIC;
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN
	FOR _X IN UPDATE business.template_control SET ordinal_position = _ordinal_position WHERE id_template_control = _id_template_control RETURNING id_template_control LOOP
		_RETURNIG = _X.id_template_control;
	END LOOP;
	
 	IF (_RETURNIG >= 1) THEN
		RETURN true;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar ordinal position';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_template_control_update_ordinal_position -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
			 
$BODY$;

ALTER FUNCTION business.dml_template_control_update_ordinal_position(numeric, numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_flow_create_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_flow_create_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_flow_create_modified(
	id_user_ numeric,
	_id_company numeric)
    RETURNS TABLE(id_flow numeric, id_company numeric, name_flow character varying, description_flow character varying, acronym_flow character varying, acronym_task character varying, sequential_flow numeric, deleted_flow boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_FLOW NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_FLOW = (select business.dml_flow_create(id_user_, _id_company, 'Nuevo flujo', '', '', '', 1, false));
	
	IF (_ID_FLOW >= 1) THEN
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS business.serial_flow_id_'||_ID_FLOW||' INCREMENT 1 MINVALUE  1 MAXVALUE 9999999999 START 1 CACHE 1';
	
		RETURN QUERY select * from business.view_flow_inner_join bvptij 
			where bvptij.id_flow = _ID_FLOW;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar flow';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_flow_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_flow_create_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_flow_update_modified(numeric, numeric, numeric, character varying, character varying, character varying, numeric, boolean)
-- DROP FUNCTION IF EXISTS business.dml_flow_update_modified(numeric, numeric, numeric, character varying, character varying, character varying, numeric, boolean);

CREATE OR REPLACE FUNCTION business.dml_flow_update_modified(
	id_user_ numeric,
	_id_flow numeric,
	_id_company numeric,
	_name_flow character varying,
	_description_flow character varying,
	_acronym_flow character varying,
	_acronym_task character varying,
	_sequential_flow numeric,
	_deleted_flow boolean)
    RETURNS TABLE(id_flow numeric, id_company numeric, name_flow character varying, description_flow character varying, acronym_flow character varying, acronym_task character varying, sequential_flow numeric, deleted_flow boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_FLOW BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_FLOW = (select * from business.dml_flow_update(id_user_, _id_flow, _id_company, _name_flow, _description_flow, _acronym_flow, _acronym_task, _sequential_flow, _deleted_flow));

 	IF (_UPDATE_FLOW) THEN
		RETURN QUERY select * from business.view_flow_inner_join bvptij 
			where bvptij.id_flow = _id_flow;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar flow';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_flow_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_flow_update_modified(numeric, numeric, numeric, character varying, character varying, character varying, character varying, numeric, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_flow_update_sequential(numeric, numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_flow_update_sequential(numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_flow_update_sequential(
	id_user_ numeric,
	_id_flow numeric,
	_sequential_flow numeric)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_ATT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN 
	_COUNT = (select count(*) from business.view_flow t where t.id_flow = _id_flow);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_flow t where t.id_flow = _id_flow and deleted_flow = true); 
		IF (_COUNT_DELETED = 0) THEN
			FOR _X IN UPDATE business.flow SET sequential_flow = _sequential_flow WHERE id_flow = _id_flow RETURNING id_flow LOOP
				_RETURNING = _X.id_flow;
			END LOOP;
				
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'flow',_id_flow,'UPDATE', now()::timestamp, false));
						
					IF (_RESPONSE != true) THEN
						_EXCEPTION = 'Ocurrió un error al registrar el evento del sistema';
						RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
					ELSE
						RETURN _RESPONSE;
					END IF;
				ELSE
					RETURN true;
				END IF;
			ELSE
				_EXCEPTION = 'Ocurrió un error al actualizar el registro';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_flow||' no se encuentra registrado en la tabla flow';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_flow_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_flow_update_sequential(numeric, numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_flow_delete_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_flow_delete_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_flow_delete_modified(
	id_user_ numeric,
	_id_flow numeric)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
 	_COUNT_DELETE BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_COUNT_DELETE = (select * from business.dml_flow_delete(id_user_, _id_flow));
		
	IF (_COUNT_DELETE) THEN
		EXECUTE 'DROP SEQUENCE IF EXISTS business.serial_flow_id_'||_id_flow||'';
		RETURN true;
	ELSE
		_EXCEPTION = 'Ocurrió un error al eliminar flow';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_flow_delete_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_flow_delete_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_level_status_create_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_level_status_create_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_level_status_create_modified(
	id_user_ numeric,
	_id_company numeric)
    RETURNS TABLE(id_level_status numeric, id_company numeric, name_level_status character varying, description_level_status character varying, color_level_status character varying, deleted_level_status boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_LEVEL_STATUS NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_LEVEL_STATUS = (select * from business.dml_level_status_create(id_user_, _id_company, 'Nuevo estado del nivel', '', '#ffffff', false));
	
	IF (_ID_LEVEL_STATUS >= 1) THEN
		RETURN QUERY select * from business.view_level_status_inner_join bvlsij 
			where bvlsij.id_level_status = _ID_LEVEL_STATUS;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar level_status';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_level_status_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_level_status_create_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_level_status_update_modified(numeric, numeric, numeric, character varying, character varying, character varying, boolean)
-- DROP FUNCTION IF EXISTS business.dml_level_status_update_modified(numeric, numeric, numeric, character varying, character varying, character varying, boolean);

CREATE OR REPLACE FUNCTION business.dml_level_status_update_modified(
	id_user_ numeric,
	_id_level_status numeric,
	_id_company numeric,
	_name_level_status character varying,
	_description_level_status character varying,
	_color_level_status character varying,
	_deleted_level_status boolean)
    RETURNS TABLE(id_level_status numeric, id_company numeric, name_level_status character varying, description_level_status character varying, color_level_status character varying, deleted_level_status boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_LEVEL_STATUS BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_LEVEL_STATUS = (select * from business.dml_level_status_update(id_user_, _id_level_status, _id_company, _name_level_status, _description_level_status, _color_level_status, _deleted_level_status));

 	IF (_UPDATE_LEVEL_STATUS) THEN
		RETURN QUERY select * from business.view_level_status_inner_join bvlsij 
			where bvlsij.id_level_status = _id_level_status;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar level_status';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_level_status_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_level_status_update_modified(numeric, numeric, numeric, character varying, character varying, character varying, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_level_profile_create_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_level_profile_create_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_level_profile_create_modified(
	id_user_ numeric,
	_id_company numeric)
    RETURNS TABLE(id_level_profile numeric, id_company numeric, name_level_profile character varying, description_level_profile character varying, deleted_level_profile boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_LEVEL_PROFILE NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_LEVEL_PROFILE = (select * from business.dml_level_profile_create(id_user_, _id_company, 'Nuevo nivel de perfil', '', false));
	
	IF (_ID_LEVEL_PROFILE >= 1) THEN
		RETURN QUERY select * from business.view_level_profile_inner_join bvlpij 
			where bvlpij.id_level_profile = _ID_LEVEL_PROFILE;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar level_profile';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_level_profile_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_level_profile_create_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_level_profile_update_modified(numeric, numeric, numeric, character varying, character varying, boolean)
-- DROP FUNCTION IF EXISTS business.dml_level_profile_update_modified(numeric, numeric, numeric, character varying, character varying, boolean);

CREATE OR REPLACE FUNCTION business.dml_level_profile_update_modified(
	id_user_ numeric,
	_id_level_profile numeric,
	_id_company numeric,
	_name_level_profile character varying,
	_description_level_profile character varying,
	_deleted_level_profile boolean)
    RETURNS TABLE(id_level_profile numeric, id_company numeric, name_level_profile character varying, description_level_profile character varying, deleted_level_profile boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_LEVEL_PROFILE BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_LEVEL_PROFILE = (select * from business.dml_level_profile_update(id_user_, _id_level_profile, _id_company, _name_level_profile, _description_level_profile, _deleted_level_profile));

 	IF (_UPDATE_LEVEL_PROFILE) THEN
		RETURN QUERY select * from business.view_level_profile_inner_join bvlpij 
			where bvlpij.id_level_profile = _id_level_profile;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar level_profile';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_level_profile_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_level_profile_update_modified(numeric, numeric, numeric, character varying, character varying, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_level_profile_delete_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_level_profile_delete_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_level_profile_delete_modified(
	id_user_ numeric,
	_id_level_profile numeric)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_X RECORD;
	_DELETE_OFFICIAL BOOLEAN;
	_DELETE_LEVEL_PROFILE BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	FOR _X IN select * from business.view_level_profile_official bvlpo where bvlpo.id_level_profile = _id_level_profile LOOP
		_DELETE_OFFICIAL = (select * from business.dml_level_profile_official_delete(id_user_, _X.id_level_profile_official));
	END LOOP;
	
	_DELETE_LEVEL_PROFILE = (select * from business.dml_level_profile_delete(id_user_, _id_level_profile));
	IF (_DELETE_LEVEL_PROFILE) THEN
		RETURN true;
	ELSE
		_EXCEPTION = 'Ocurrió un error al eliminar level_profile';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_level_profile_delete_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_level_profile_delete_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_level_profile_official_create_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_level_profile_official_create_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_level_profile_official_create_modified(
	id_user_ numeric,
	_id_level_profile numeric)
    RETURNS TABLE(number_task numeric, id_level_profile_official numeric, id_level_profile numeric, id_official numeric, official_modifier boolean, name_level_profile character varying, description_level_profile character varying, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_OFFICIAL NUMERIC;
	_ID_LEVEL_PROFILE_OFFICIAL NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN

	-- Descartar officials que ya esten asignadas en el level_profile
	_ID_OFFICIAL = (select officials.id_official from (select bvo.id_official from business.view_official bvo) as officials
		LEFT JOIN (select distinct bvlpo.id_official from business.view_level_profile_official bvlpo where bvlpo.id_level_profile = _id_level_profile) as assignedOfficials
		on officials.id_official = assignedOfficials.id_official where assignedOfficials.id_official IS NULL order by officials.id_official asc limit 1);
	
	IF (_ID_OFFICIAL IS NULL) THEN 
		_EXCEPTION = 'No se encontró officials registrados';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	
	_ID_LEVEL_PROFILE_OFFICIAL = (select business.dml_level_profile_official_create(id_user_, _id_level_profile, _ID_OFFICIAL, false));
	
	IF (_ID_LEVEL_PROFILE_OFFICIAL >= 1) THEN
		RETURN QUERY select * from business.view_level_profile_official_inner_join bvlpoij 
			where bvlpoij.id_level_profile_official = _ID_LEVEL_PROFILE_OFFICIAL;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar level_profile_official';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_level_profile_official_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_level_profile_official_create_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_level_profile_official_update_modified(numeric, numeric, numeric, numeric, boolean)
-- DROP FUNCTION IF EXISTS business.dml_level_profile_official_update_modified(numeric, numeric, numeric, numeric, boolean);

CREATE OR REPLACE FUNCTION business.dml_level_profile_official_update_modified(
	id_user_ numeric,
	_id_level_profile_official numeric,
	_id_level_profile numeric,
	_id_official numeric,
	_official_modifier boolean)
    RETURNS TABLE(number_task numeric, id_level_profile_official numeric, id_level_profile numeric, id_official numeric, official_modifier boolean, name_level_profile character varying, description_level_profile character varying, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_LEVEL_PROFILE_OFFICIAL BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_LEVEL_PROFILE_OFFICIAL = (select * from business.dml_level_profile_official_update(id_user_, _id_level_profile_official, _id_level_profile, _id_official, _official_modifier));

 	IF (_UPDATE_LEVEL_PROFILE_OFFICIAL) THEN
		RETURN QUERY select * from business.view_level_profile_official_inner_join bvlpoij 
			where bvlpoij.id_level_profile_official = _id_level_profile_official;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar level_profile_official';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_level_profile_official_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_level_profile_official_update_modified(numeric, numeric, numeric, numeric, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_level_create_modified(numeric, numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_level_create_modified(numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_level_create_modified(
	id_user_ numeric,
	_id_company numeric,
	_id_template numeric)
    RETURNS TABLE(id_level numeric, id_company numeric, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, deleted_level boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, id_documentation_profile numeric, id_plugin_item numeric, plugin_attached_process boolean, plugin_item_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, in_use boolean, name_level_profile character varying, description_level_profile character varying, name_level_status character varying, description_level_status character varying, color_level_status character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_LEVEL_PROFILE NUMERIC; 
	_ID_LEVEL_STATUS NUMERIC;
	_ID_LEVEL NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_LEVEL_PROFILE = (select bvlp.id_level_profile from business.view_level_profile bvlp where bvlp.id_company = _id_company order by bvlp.id_level_profile asc limit 1);

	IF (_ID_LEVEL_PROFILE >= 1) THEN
		_ID_LEVEL_STATUS = (select bvls.id_level_status from business.view_level_status bvls where bvls.id_company = _id_company order by bvls.id_level_status asc limit 1);

		IF (_ID_LEVEL_STATUS >= 1) THEN
			_ID_LEVEL = (select business.dml_level_create(id_user_, _id_company, _id_template, _ID_LEVEL_PROFILE, _ID_LEVEL_STATUS, 'Nuevo nivel', '', false));
			
			IF (_ID_LEVEL >= 1) THEN
				RETURN QUERY select * from business.view_level_inner_join bvlij 
				where bvlij.id_level = _ID_LEVEL;
			ELSE
				_EXCEPTION = 'Ocurrió un error al ingresar level';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'No se encontró un level_status';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE 
		_EXCEPTION = 'No se encontró un level_profile';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_level_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_level_create_modified(numeric, numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_level_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, character varying, character varying, boolean)
-- DROP FUNCTION IF EXISTS business.dml_level_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, character varying, character varying, boolean);

CREATE OR REPLACE FUNCTION business.dml_level_update_modified(
	id_user_ numeric,
	_id_level numeric,
	_id_company numeric,
	_id_template numeric,
	_id_level_profile numeric,
	_id_level_status numeric,
	_name_level character varying,
	_description_level character varying,
	_deleted_level boolean)
    RETURNS TABLE(id_level numeric, id_company numeric, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, deleted_level boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, id_documentation_profile numeric, id_plugin_item numeric, plugin_attached_process boolean, plugin_item_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, in_use boolean, name_level_profile character varying, description_level_profile character varying, name_level_status character varying, description_level_status character varying, color_level_status character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_LEVEL BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_LEVEL = (select * from business.dml_level_update(id_user_, _id_level, _id_company, _id_template, _id_level_profile, _id_level_status, _name_level, _description_level, _deleted_level));

 	IF (_UPDATE_LEVEL) THEN
		RETURN QUERY select * from business.view_level_inner_join bvlij 
			where bvlij.id_level = _id_level;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar level';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_level_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_level_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, character varying, character varying, boolean)
    OWNER TO postgres;
-- FUNCTION: business.dml_flow_version_create_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_flow_version_create_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_flow_version_create_modified(
	id_user_ numeric,
	_id_flow numeric)
    RETURNS TABLE(id_flow_version numeric, id_flow numeric, number_flow_version numeric, status_flow_version boolean, creation_date_flow_version timestamp without time zone, deleted_flow_version boolean, id_company numeric, name_flow character varying, description_flow character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_LAST_VERSION NUMERIC;
	_ID_FLOW_VERSION NUMERIC;
	_STATUS_VALIDATION BOOLEAN;
	_ID_LEVEL NUMERIC;
	_LAST_POSITION_LEVEL NUMERIC;
	_ID_FLOW_VERSION_LEVEL NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_LAST_VERSION = (select bvfv.number_flow_version from business.view_flow_version bvfv where bvfv.id_flow = _id_flow order by bvfv.number_flow_version desc limit 1);
	
	IF (_LAST_VERSION IS NULL) THEN
		_LAST_VERSION = 0;
	END IF;

	_ID_FLOW_VERSION = (select business.dml_flow_version_create(id_user_, _id_flow, _LAST_VERSION + 1, false, now()::timestamp, false));
	
	IF (_ID_FLOW_VERSION >= 1) THEN
		RETURN QUERY select * from business.view_flow_version_inner_join bvfvij 
			where bvfvij.id_flow_version = _ID_FLOW_VERSION;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar flow_version';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_flow_version_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_flow_version_create_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_flow_version_update_modified(numeric, numeric, numeric, numeric, boolean, timestamp without time zone, boolean)
-- DROP FUNCTION IF EXISTS business.dml_flow_version_update_modified(numeric, numeric, numeric, numeric, boolean, timestamp without time zone, boolean);

CREATE OR REPLACE FUNCTION business.dml_flow_version_update_modified(
	id_user_ numeric,
	_id_flow_version numeric,
	_id_flow numeric,
	_number_flow_version numeric,
	_status_flow_version boolean,
	_creation_date_flow_version timestamp without time zone,
	_deleted_flow_version boolean)
    RETURNS TABLE(id_flow_version numeric, id_flow numeric, number_flow_version numeric, status_flow_version boolean, creation_date_flow_version timestamp without time zone, deleted_flow_version boolean, id_company numeric, name_flow character varying, description_flow character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_FLOW_VERSION BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_FLOW_VERSION = (select * from business.dml_flow_version_update(id_user_, _id_flow_version, _id_flow, _number_flow_version, _status_flow_version, _creation_date_flow_version, _deleted_flow_version));

 	IF (_UPDATE_FLOW_VERSION) THEN
		RETURN QUERY select * from business.view_flow_version_inner_join bvfvij 
			where bvfvij.id_flow_version = _id_flow_version;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar flow_version';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_flow_version_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_flow_version_update_modified(numeric, numeric, numeric, numeric, boolean, timestamp without time zone, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_flow_version_level_create(numeric, numeric, numeric, numeric, numeric, business."TYPE_ELEMENT", character varying, business."TYPE_OPERATOR", character varying, boolean, numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_flow_version_level_create(numeric, numeric, numeric, numeric, numeric, business."TYPE_ELEMENT", character varying, business."TYPE_OPERATOR", character varying, boolean, numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_flow_version_level_create(
	id_user_ numeric,
	_id_flow_version numeric,
	_id_level numeric,
	_position_level numeric,
	_position_level_father numeric,
	_type_element business."TYPE_ELEMENT",
	_id_control character varying,
	_operator business."TYPE_OPERATOR",
	_value_against character varying,
	_option_true boolean,
	_x numeric,
	_y numeric)
    RETURNS numeric
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_RESPONSE BOOLEAN DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_EXTERNALS_IDS NUMERIC;
	_RETURNING NUMERIC;
	_CURRENT_ID NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN 
	-- flow_version
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_flow_version v where v.id_flow_version = _id_flow_version);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_flow_version||' de la tabla flow_version no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- level
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_level v where v.id_level = _id_level);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_level||' de la tabla level no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;

	_CURRENT_ID = (select nextval('business.serial_flow_version_level')-1);
	_COUNT = (select count(*) from business.view_flow_version_level t where t.id_flow_version_level = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		FOR _X IN INSERT INTO business.flow_version_level(id_flow_version_level, id_flow_version, id_level, position_level, position_level_father, type_element, id_control, operator, value_against, option_true, x, y) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6 ,$7 ,$8 ,$9 ,$10 ,$11 ,$12) RETURNING id_flow_version_level LOOP
			_RETURNING = _X.id_flow_version_level;
		END LOOP;
		
		IF (_RETURNING >= 1) THEN
			_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
				where cvuij.id_user = id_user_);
			
			IF (_SAVE_LOG) THEN
				_RESPONSE = (select * from core.dml_system_event_create(id_user_,'flow_version_level',_CURRENT_ID,'CREATE', now()::timestamp, false));
				
				IF (_RESPONSE != true) THEN
					_EXCEPTION = 'Ocurrió un error al registrar el evento del sistema';
					RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
				ELSE
					RETURN _CURRENT_ID;
				END IF;
			ELSE 
				RETURN _CURRENT_ID;
			END IF;
		ELSE
			_EXCEPTION = 'Ocurrió un error al insertar el registro';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla flow_version_level';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_flow_version_level'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_flow_version_level_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_flow_version_level_create(numeric, numeric, numeric, numeric, numeric, business."TYPE_ELEMENT", character varying, business."TYPE_OPERATOR", character varying, boolean, numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_flow_version_level_create_modified(numeric, numeric, business."TYPE_ELEMENT")
-- DROP FUNCTION IF EXISTS business.dml_flow_version_level_create_modified(numeric, numeric, business."TYPE_ELEMENT");

CREATE OR REPLACE FUNCTION business.dml_flow_version_level_create_modified(
	id_user_ numeric,
	_id_flow_version numeric,
	_type_element business."TYPE_ELEMENT")
    RETURNS TABLE(id_flow_version_level numeric, id_flow_version numeric, id_level numeric, position_level numeric, position_level_father numeric, type_element business."TYPE_ELEMENT", id_control character varying, operator business."TYPE_OPERATOR", value_against character varying, option_true boolean, x numeric, y numeric, id_flow numeric, number_flow_version numeric, status_flow_version boolean, creation_date_flow_version timestamp without time zone, id_company numeric, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_STATUS_VALIDATION BOOLEAN;
	_ID_LEVEL NUMERIC;
	_LAST_POSITION_LEVEL NUMERIC;
	_ID_FLOW_VERSION_LEVEL NUMERIC;
	_X RECORD;
	_POSITION_X NUMERIC DEFAULT 50;
	_POSITION_Y NUMERIC DEFAULT 120;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	-- validation_flow_version
  	_STATUS_VALIDATION = (select * from business.validation_flow_version(_id_flow_version));
  
  	IF (_STATUS_VALIDATION) THEN
 		_EXCEPTION = 'La version '||_id_flow_version||' se encuentra en uso dentro de un proceso';
	 	RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
  	END IF;
	
  	-- Descartar niveles que ya estan asignados
  	_ID_LEVEL = (select levels.id_level from (select bvl.id_level from business.view_level bvl) as levels 
		LEFT JOIN (select bvfvl.id_level from business.view_flow_version_level bvfvl where bvfvl.id_flow_version = _id_flow_version and bvfvl.position_level > 0) as assignedLevels 
		on levels.id_level = assignedLevels.id_level where assignedLevels.id_level IS NULL order by levels.id_level asc limit 1);
	
  	IF (_ID_LEVEL >= 1) THEN
  		_LAST_POSITION_LEVEL = (select distinct bvfvl.position_level from business.view_flow_version_level bvfvl where bvfvl.id_flow_version = _id_flow_version and bvfvl.position_level > 0 order by bvfvl.position_level desc limit 1); 
		
		IF (_LAST_POSITION_LEVEL IS NULL) THEN
			_LAST_POSITION_LEVEL = 0;
		END IF;
		
		FOR _X IN select bvfvl.x, bvfvl.y from business.view_flow_version_level bvfvl where bvfvl.id_flow_version = _id_flow_version limit 1 LOOP
			_POSITION_X = _X.x + 50;
			_POSITION_Y = _X.y + 80;
		END LOOP;
	
		_ID_FLOW_VERSION_LEVEL = (select * from business.dml_flow_version_level_create(id_user_, _id_flow_version, _ID_LEVEL, _LAST_POSITION_LEVEL + 1, 0, _type_element, '', '==', '', false, _POSITION_X, _POSITION_Y));
	
		IF (_ID_FLOW_VERSION_LEVEL >= 1) THEN
			RETURN QUERY select * from business.view_flow_version_level_inner_join bvfvlij 
			where bvfvlij.id_flow_version_level = _ID_FLOW_VERSION_LEVEL;
		ELSE
			_EXCEPTION = 'Ocurrió un error al ingresar flow_version_level';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
  	ELSE
  		_EXCEPTION = 'No se encontraron levels registrados';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
  	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_flow_version_level_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_flow_version_level_create_modified(numeric, numeric, business."TYPE_ELEMENT")
    OWNER TO postgres;

-- FUNCTION: business.dml_flow_version_level_update(numeric, numeric, numeric, numeric, numeric, numeric, business."TYPE_ELEMENT", character varying, business."TYPE_OPERATOR", character varying, boolean, numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_flow_version_level_update(numeric, numeric, numeric, numeric, numeric, numeric, business."TYPE_ELEMENT", character varying, business."TYPE_OPERATOR", character varying, boolean, numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_flow_version_level_update(
	id_user_ numeric,
	_id_flow_version_level numeric,
	_id_flow_version numeric,
	_id_level numeric,
	_position_level numeric,
	_position_level_father numeric,
	_type_element business."TYPE_ELEMENT",
	_id_control character varying,
	_operator business."TYPE_OPERATOR",
	_value_against character varying,
	_option_true boolean,
	_x numeric,
	_y numeric)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_EXTERNALS_IDS NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN 
	-- flow_version
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_flow_version v where v.id_flow_version = _id_flow_version);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_flow_version||' de la tabla flow_version no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- level
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_level v where v.id_level = _id_level);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_level||' de la tabla level no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
 	_COUNT = (select count(*) from business.view_flow_version_level t where t.id_flow_version_level = _id_flow_version_level);

	IF (_COUNT = 1) THEN
		FOR _X IN UPDATE business.flow_version_level SET id_flow_version=$3, id_level=$4, position_level=$5, position_level_father=$6, type_element=$7, id_control=$8, operator=$9, value_against=$10, option_true=$11, x=$12, y=$13 WHERE id_flow_version_level=$2 RETURNING id_flow_version_level LOOP
			_RETURNING = _X.id_flow_version_level;
		END LOOP;
			
		IF (_RETURNING >= 1) THEN
			_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
				where cvuij.id_user = id_user_);

			IF (_SAVE_LOG) THEN
				_RESPONSE = (select * from core.dml_system_event_create(id_user_,'flow_version_level',_id_flow_version_level,'UPDATE', now()::timestamp, false));
				
				IF (_RESPONSE != true) THEN
					_EXCEPTION = 'Ocurrió un error al registrar el evento del sistema';
					RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
				ELSE
					RETURN _RESPONSE;
				END IF;
			ELSE
				RETURN true;
			END IF;
		ELSE
			_EXCEPTION = 'Ocurrió un error al actualizar el registro';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_flow_version_level||' no se encuentra registrado en la tabla flow_version_level';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_flow_version_level_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_flow_version_level_update(numeric, numeric, numeric, numeric, numeric, numeric, business."TYPE_ELEMENT", character varying, business."TYPE_OPERATOR", character varying, boolean, numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_flow_version_level_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, business."TYPE_ELEMENT", character varying, business."TYPE_OPERATOR", character varying, boolean, numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_flow_version_level_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, business."TYPE_ELEMENT", character varying, business."TYPE_OPERATOR", character varying, boolean, numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_flow_version_level_update_modified(
	id_user_ numeric,
	_id_flow_version_level numeric,
	_id_flow_version numeric,
	_id_level numeric,
	_position_level numeric,
	_position_level_father numeric,
	_type_element business."TYPE_ELEMENT",
	_name_control character varying,
	_operator business."TYPE_OPERATOR",
	_value_against character varying,
	_option_true boolean,
	_x numeric,
	_y numeric)
    RETURNS TABLE(id_flow_version_level numeric, id_flow_version numeric, id_level numeric, position_level numeric, position_level_father numeric, type_element business."TYPE_ELEMENT", id_control character varying, operator business."TYPE_OPERATOR", value_against character varying, option_true boolean, x numeric, y numeric, id_flow numeric, number_flow_version numeric, status_flow_version boolean, creation_date_flow_version timestamp without time zone, id_company numeric, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_FLOW_VERSION_LEVEL BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_FLOW_VERSION_LEVEL = (select * from business.dml_flow_version_level_update(id_user_, _id_flow_version_level, _id_flow_version, _id_level, _position_level, _position_level_father, _type_element, _name_control, _operator, _value_against, _option_true, _x, _y));

 	IF (_UPDATE_FLOW_VERSION_LEVEL) THEN
		RETURN QUERY select * from business.view_flow_version_level_inner_join bvfvlij 
			where bvfvlij.id_flow_version_level = _id_flow_version_level;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar flow_version_level';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_flow_version_level_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_flow_version_level_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, business."TYPE_ELEMENT", character varying, business."TYPE_OPERATOR", character varying, boolean, numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_flow_version_level_reset(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_flow_version_level_reset(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_flow_version_level_reset(
	id_usuario_ numeric,
	_id_flow_version numeric)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_X RECORD;
	_STATUS_VALIDATION BOOLEAN;
	_DELETED BOOLEAN;
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN
	-- validation_flow_version
  	_STATUS_VALIDATION = (select * from business.validation_flow_version(_id_flow_version));
  
  	IF (_STATUS_VALIDATION) THEN
 		_EXCEPTION = 'La version '||_id_flow_version||' se encuentra en uso dentro de un proceso';
	 	RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
  	END IF;
 
	FOR _X IN select * from business.view_flow_version_level bvfvl where bvfvl.id_flow_version = _id_flow_version LOOP
		_DELETED = (select * from business.dml_flow_version_level_delete(id_usuario_, _X.id_flow_version_level));
	END LOOP;
	return true;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%',SQLERRM USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
			 
$BODY$;

ALTER FUNCTION business.dml_flow_version_level_reset(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_process_create_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_process_create_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_process_create_modified(
	id_user_ numeric,
	_id_flow numeric)
    RETURNS TABLE(id_process numeric, id_official numeric, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, deleted_process boolean, id_user numeric, id_area numeric, id_position numeric, number_flow_version numeric, status_flow_version boolean, creation_date_flow_version timestamp without time zone, id_flow numeric, name_flow character varying, description_flow character varying, acronym_flow character varying, acronym_task character varying, sequential_flow numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_OFFICIAL NUMERIC;
	_ID_FLOW_VERSION NUMERIC;
	_ID_FLOW_VERSION_LEVEL NUMERIC;
	_ACRONYM_COMPANY CHARACTER VARYING;
	_ACRONYM_FLOW CHARACTER VARYING;
	_SERIAL_FLOW NUMERIC;
	_NUMBER_PROCESS CHARACTER VARYING;
	_ACRONYM_TASK CHARACTER VARYING;
	_NUMBER_TASK CHARACTER VARYING;
	_ID_PROCESS NUMERIC;
	_STATUS_UPDATE_SEQUENCE BOOLEAN;
	_ID_LEVEL NUMERIC;
	_ID_TASK NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_OFFICIAL = (select bvo.id_official from business.view_official bvo where bvo.id_user = id_user_);
	
	IF (_ID_OFFICIAL IS NULL) THEN
		_EXCEPTION = 'Tienes que estar registrado como funcionario';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	
	_ID_FLOW_VERSION = (select bvfv.id_flow_version from business.view_flow_version bvfv inner join business.view_flow bvf on bvfv.id_flow = bvf.id_flow inner join business.view_flow bvpt on bvf.id_flow = bvpt.id_flow where bvpt.id_flow = _id_flow and bvfv.status_flow_version = true limit 1);

	IF (_ID_FLOW_VERSION IS NULL) THEN
		_EXCEPTION = 'El flujo del tipo de proceso no tiene una version activa';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	
	_ID_FLOW_VERSION_LEVEL = (select count(*) from business.view_flow_version_level bvfvl where bvfvl.id_flow_version = _ID_FLOW_VERSION);
	
	IF (_ID_FLOW_VERSION_LEVEL = 0) THEN
		_EXCEPTION = 'La version del flujo no tiene niveles asignados';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	
	-- _ACRONYM_COMPANY
	_ACRONYM_COMPANY = (select cvc.acronym_company from core.view_user cvu inner join core.view_company cvc on cvu.id_company = cvc.id_company where cvu.id_user = id_user_);
	RAISE NOTICE '%',_ACRONYM_COMPANY;
	-- _ACRONYM_FLOW
	_ACRONYM_FLOW = (select bvpt.acronym_flow from business.view_flow bvpt where bvpt.id_flow = _id_flow);
	RAISE NOTICE '%',_ACRONYM_FLOW;
	
	_SERIAL_FLOW =  (select nextval('business.serial_flow_id_'||_id_flow||'')-1);
	IF (_SERIAL_FLOW >= 1) THEN
		_NUMBER_PROCESS = ''||UPPER(_ACRONYM_COMPANY)||'-'||UPPER(_ACRONYM_FLOW)||'-'||_SERIAL_FLOW||'';
		_ID_PROCESS = (select business.dml_process_create(id_user_, _ID_OFFICIAL, _ID_FLOW_VERSION, _NUMBER_PROCESS, now()::timestamp, true, false, false));
	RAISE NOTICE '%',_ID_PROCESS;
		
		-- UPDATE SEQUENCE
		_STATUS_UPDATE_SEQUENCE = (select * from business.dml_flow_update_sequential(id_user_, _id_flow, _SERIAL_FLOW));
		
		IF (_STATUS_UPDATE_SEQUENCE) THEN
			IF (_ID_PROCESS >= 1) THEN
				 -- GENERATE TASK
				_ID_LEVEL = (select bvfvl.id_level from business.view_flow_version_level bvfvl where bvfvl.id_flow_version = _ID_FLOW_VERSION order by bvfvl.position_level asc limit 1);
				
				_ACRONYM_TASK = (select bvpt.acronym_task from business.view_flow bvpt where bvpt.id_flow = _id_flow);

				_NUMBER_TASK = ''||_NUMBER_PROCESS||'-'||_ACRONYM_TASK||'-';
				_ID_TASK = (select * from business.dml_task_create(id_user_, _ID_PROCESS, _ID_OFFICIAL, _ID_LEVEL, _NUMBER_TASK, 'created', now()::timestamp, false));
				
				IF (_ID_TASK >= 1) THEN
					RETURN QUERY select * from business.view_process_inner_join bvpij 
						where bvpij.id_process = _ID_PROCESS;
				ELSE
					_EXCEPTION = 'Ocurrió un error al generar la tarea';
					RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
				END IF;
			ELSE
				_EXCEPTION = 'Ocurrió un error al ingresar process';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE
			_EXCEPTION = 'Ocurrió un error al actualizar sequential_flow';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE 
		_EXCEPTION = 'No se encontro el secuencial de flow';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_process_create_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_process_update_modified(numeric, numeric, numeric, numeric, character varying, timestamp without time zone, boolean, boolean, boolean)
-- DROP FUNCTION IF EXISTS business.dml_process_update_modified(numeric, numeric, numeric, numeric, character varying, timestamp without time zone, boolean, boolean, boolean);

CREATE OR REPLACE FUNCTION business.dml_process_update_modified(
	id_user_ numeric,
	_id_process numeric,
	_id_official numeric,
	_id_flow_version numeric,
	_number_process character varying,
	_date_process timestamp without time zone,
	_generated_task boolean,
	_finalized_process boolean,
	_deleted_process boolean)
    RETURNS TABLE(id_process numeric, id_official numeric, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, deleted_process boolean, id_user numeric, id_area numeric, id_position numeric, number_flow_version numeric, status_flow_version boolean, creation_date_flow_version timestamp without time zone, id_flow numeric, name_flow character varying, description_flow character varying, acronym_flow character varying, acronym_task character varying, sequential_flow numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_PROCESS BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_PROCESS = (select * from business.dml_process_update(id_user_, _id_process, _id_official, _id_flow_version, _number_process, _date_process, _generated_task, _finalized_process, _deleted_process));
 	
	IF (_UPDATE_PROCESS) THEN
		RETURN QUERY select * from business.view_process_inner_join bvpij 
			where bvpij.id_process = _id_process;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar process';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_process_update_modified(numeric, numeric, numeric, numeric, character varying, timestamp without time zone, boolean, boolean, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_task_create(numeric, numeric, numeric, numeric, character varying, timestamp without time zone, business."TYPE_STATUS_TASK", timestamp without time zone, boolean)
-- DROP FUNCTION IF EXISTS business.dml_task_create(numeric, numeric, numeric, numeric, character varying, timestamp without time zone, business."TYPE_STATUS_TASK", timestamp without time zone, boolean);

CREATE OR REPLACE FUNCTION business.dml_task_create(
	id_user_ numeric,
	_id_process numeric,
	_id_official numeric,
	_id_level numeric,
	_number_task character varying,
	_type_status_task business."TYPE_STATUS_TASK",
	_date_task timestamp without time zone,
	_deleted_task boolean)
    RETURNS numeric
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_RESPONSE BOOLEAN DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_ATT NUMERIC;
	_COUNT_EXTERNALS_IDS NUMERIC;
	_RETURNING NUMERIC;
	_CURRENT_ID NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN 
	-- process
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_process v where v.id_process = _id_process);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_process||' de la tabla process no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- official
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_official v where v.id_official = _id_official);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_official||' de la tabla official no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- level
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_level v where v.id_level = _id_level);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_level||' de la tabla level no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_CURRENT_ID = (select nextval('business.serial_task')-1);
	_COUNT = (select count(*) from business.view_task t where t.id_task = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from business.view_task t where t.id_task = _CURRENT_ID);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO business.task(id_task, id_process, id_official, id_level, number_task, type_status_task, date_task, deleted_task) VALUES (_CURRENT_ID, $2, $3, $4, ''||_number_task||''||_CURRENT_ID||'', $6, $7, $8) RETURNING id_task LOOP
				_RETURNING = _X.id_task;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'task',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
					IF (_RESPONSE != true) THEN
						_EXCEPTION = 'Ocurrió un error al registrar el evento del sistema';
						RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
					ELSE
						RETURN _CURRENT_ID;
					END IF;
				ELSE 
					RETURN _CURRENT_ID;
				END IF;
			ELSE
				_EXCEPTION = 'Ocurrió un error al insertar el registro';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE
			_EXCEPTION = 'Ya existe un registro con el id_task '||_id_task||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla task';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_task'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_task_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_task_create(numeric, numeric, numeric, numeric, character varying, business."TYPE_STATUS_TASK", timestamp without time zone, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_task_create_modified(numeric, numeric, numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_task_create_modified(numeric, numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_task_create_modified(
	id_user_ numeric,
	_id_process numeric,
	_id_official numeric,
	_id_level numeric)
    RETURNS TABLE(id_task numeric, id_process numeric, id_official numeric, id_level numeric, number_task character varying, type_status_task business."TYPE_STATUS_TASK", date_task timestamp without time zone, deleted_task boolean, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, id_user numeric, id_area numeric, id_position numeric, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, id_flow numeric, number_flow_version numeric, status_flow_version boolean, creation_date_flow_version timestamp without time zone, id_company numeric, name_flow character varying, description_flow character varying, acronym_flow character varying, acronym_task character varying, sequential_flow numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_TASK NUMERIC;
	_NUMBER_PROCESS CHARACTER VARYING;
	_ACRONYM_TASK CHARACTER VARYING;
	_NUMBER_TASK CHARACTER VARYING;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_NUMBER_PROCESS = (select bvp.number_process from business.view_process bvp where bvp.id_process = _id_process);
	
	_ACRONYM_TASK = (select bvf.acronym_task from business.view_process bvp
		inner join business.view_flow_version bvfv on bvp.id_flow_version = bvfv.id_flow_version
		inner join business.view_flow bvf on bvfv.id_flow = bvf.id_flow
		where bvp.id_process = _id_process);
	
	_NUMBER_TASK = ''||_NUMBER_PROCESS||'-'||_ACRONYM_TASK||'-';

	_ID_TASK = (select * from business.dml_task_create(id_user_, _id_process, _id_official, _id_level, _NUMBER_TASK, 'created', now()::timestamp, false));
	
	IF (_ID_TASK >= 1) THEN
		RETURN QUERY select * from business.view_task_inner_join bvtij 
			where bvtij.id_task = _ID_TASK;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar task';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_task_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_task_create_modified(numeric, numeric, numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_task_update_modified(numeric, numeric, numeric, numeric, numeric, character varying, timestamp without time zone, business."TYPE_STATUS_TASK", timestamp without time zone, boolean)
-- DROP FUNCTION IF EXISTS business.dml_task_update_modified(numeric, numeric, numeric, numeric, numeric, character varying, timestamp without time zone, business."TYPE_STATUS_TASK", timestamp without time zone, boolean);

CREATE OR REPLACE FUNCTION business.dml_task_update_modified(
	id_user_ numeric,
	_id_task numeric,
	_id_process numeric,
	_id_official numeric,
	_id_level numeric,
	_number_task character varying,
	_type_status_task business."TYPE_STATUS_TASK",
	_date_task timestamp without time zone,
	_deleted_task boolean)
    RETURNS TABLE(id_task numeric, id_process numeric, id_official numeric, id_level numeric, number_task character varying, type_status_task business."TYPE_STATUS_TASK", date_task timestamp without time zone, deleted_task boolean, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, id_user numeric, id_area numeric, id_position numeric, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, id_flow numeric, number_flow_version numeric, status_flow_version boolean, creation_date_flow_version timestamp without time zone, id_company numeric, name_flow character varying, description_flow character varying, acronym_flow character varying, acronym_task character varying, sequential_flow numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_TASK BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_TASK = (select * from business.dml_task_update(id_user_, _id_task, _id_process, _id_official, _id_level, _number_task, _type_status_task, _date_task, _deleted_task));

 	IF (_UPDATE_TASK) THEN
		RETURN QUERY select * from business.view_task_inner_join bvtij 
			where bvtij.id_task = _id_task;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar task';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_task_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_task_update_modified(numeric, numeric, numeric, numeric, numeric, character varying, business."TYPE_STATUS_TASK", timestamp without time zone, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_task_reasign(numeric, numeric, numeric, numeric, numeric, character varying, timestamp without time zone, business."TYPE_STATUS_TASK", timestamp without time zone, boolean)
-- DROP FUNCTION IF EXISTS business.dml_task_reasign(numeric, numeric, numeric, numeric, numeric, character varying, timestamp without time zone, business."TYPE_STATUS_TASK", timestamp without time zone, boolean);

CREATE OR REPLACE FUNCTION business.dml_task_reasign(
	id_user_ numeric,
	_id_task numeric,
	_id_process numeric,
	_id_official numeric,
	_id_level numeric,
	_number_task character varying,
	_type_status_task business."TYPE_STATUS_TASK",
	_date_task timestamp without time zone,
	_deleted_task boolean)
    RETURNS TABLE(id_task numeric, id_process numeric, id_official numeric, id_level numeric, number_task character varying, type_status_task business."TYPE_STATUS_TASK", date_task timestamp without time zone, deleted_task boolean, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, id_user numeric, id_area numeric, id_position numeric, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, id_flow numeric, number_flow_version numeric, status_flow_version boolean, creation_date_flow_version timestamp without time zone, id_company numeric, name_flow character varying, description_flow character varying, acronym_flow character varying, acronym_task character varying, sequential_flow numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_COUNT NUMERIC;
	_ID_OFFICIAL_PRIMARY NUMERIC;
 	_UPDATE_TASK BOOLEAN;
	_ID_NEW_TASK NUMERIC;
	_NUMBER_PROCESS CHARACTER VARYING;
	_ACRONYM_TASK CHARACTER VARYING;
	_NUMBER_TASK_NEW_TASK CHARACTER VARYING;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_COUNT = (select count(*) from business.view_task t where t.id_task = _id_task);
	
	IF (_COUNT = 0) THEN 
		_EXCEPTION = 'El registro con id '||_id_task||' no se encuentra registrado en la tabla task';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;

	_ID_OFFICIAL_PRIMARY = (select bvt.id_official from business.view_task bvt where bvt.id_task = _id_task);

 	_UPDATE_TASK = (select * from business.dml_task_update(id_user_, _id_task, _id_process, _ID_OFFICIAL_PRIMARY, _id_level, _number_task, 'reassigned', now()::timestamp, _deleted_task));

 	IF (_UPDATE_TASK) THEN
		-- Generate task
		_NUMBER_PROCESS = (select bvp.number_process from business.view_process bvp where bvp.id_process = _id_process);
		
		_ACRONYM_TASK = (select bvf.acronym_task from business.view_process bvp
			inner join business.view_flow_version bvfv on bvp.id_flow_version = bvfv.id_flow_version
			inner join business.view_flow bvf on bvfv.id_flow = bvf.id_flow
			where bvp.id_process = _id_process);

		_NUMBER_TASK_NEW_TASK = ''||_NUMBER_PROCESS||'-'||_ACRONYM_TASK||'-';

		_ID_NEW_TASK = (select * from business.dml_task_create(id_user_, _id_process, _id_official, _ID_LEVEL, _NUMBER_TASK_NEW_TASK, 'created', now()::timestamp, false));
		
		IF (_ID_NEW_TASK >= 1) THEN
			RETURN QUERY select * from business.view_task_inner_join bvtij 
				where bvtij.id_task = _id_task;
		ELSE
			_EXCEPTION = 'Ocurrió un error al generar la tarea';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar task';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_task_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_task_reasign(numeric, numeric, numeric, numeric, numeric, character varying, business."TYPE_STATUS_TASK", timestamp without time zone, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_task_send(numeric, numeric, numeric, numeric, numeric, character varying, business."TYPE_STATUS_TASK", timestamp without time zone, boolean)
-- DROP FUNCTION IF EXISTS business.dml_task_send(numeric, numeric, numeric, numeric, numeric, character varying, business."TYPE_STATUS_TASK", timestamp without time zone, boolean);

CREATE OR REPLACE FUNCTION business.dml_task_send(
	id_user_ numeric,
	_id_task numeric,
	_id_process numeric,
	_id_official numeric,
	_id_level numeric,
	_number_task character varying,
	_type_status_task business."TYPE_STATUS_TASK",
	_date_task timestamp without time zone,
	_deleted_task boolean)
    RETURNS TABLE(id_task numeric, id_process numeric, id_official numeric, id_level numeric, number_task character varying, type_status_task business."TYPE_STATUS_TASK", date_task timestamp without time zone, deleted_task boolean, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, id_user numeric, id_area numeric, id_position numeric, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, id_flow numeric, number_flow_version numeric, status_flow_version boolean, creation_date_flow_version timestamp without time zone, id_company numeric, name_flow character varying, description_flow character varying, acronym_flow character varying, acronym_task character varying, sequential_flow numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_COUNT NUMERIC;
	_ID_OFFICIAL_PRIMARY NUMERIC;
 	_UPDATE_TASK BOOLEAN;
	_POSITION_LEVEL_CURRENT_LEVEL NUMERIC;
	_POSITION_LEVEL_NEXT_LEVEL NUMERIC DEFAULT 0;
	_TYPE_ELEMENT_NEXT_LEVEL business."TYPE_ELEMENT";
	_ID_CONTROL_NEXT_LEVEL CHARACTER VARYING;
	_OPERATOR_NEXT_LEVEL business."TYPE_OPERATOR";
	_VALUE_AGAINST_NEXT_LEVEL CHARACTER VARYING;
	_OPTION_TRUE_NEXT_LEVEL BOOLEAN;
	_LEVEL_PROFILE_NEXT_LEVEL NUMERIC;
	_OFFICIAL_NEXT_LEVEL NUMERIC;
	
	_NUMBER_PROCESS CHARACTER VARYING;
	_ACRONYM_TASK CHARACTER VARYING;
	_NUMBER_TASK_NEW_TASK CHARACTER VARYING;

	_VALUE_PROCESS_CONTROL TEXT;

	_ID_NEW_TASK NUMERIC DEFAULT 0;
	_X RECORD;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_COUNT = (select count(*) from business.view_task t where t.id_task = _id_task);
	
	IF (_COUNT = 0) THEN 
		_EXCEPTION = 'El registro con id '||_id_task||' no se encuentra registrado en la tabla task';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;

	_ID_OFFICIAL_PRIMARY = (select bvt.id_official from business.view_task bvt where bvt.id_task = _id_task);

 	_UPDATE_TASK = (select * from business.dml_task_update(id_user_, _id_task, _id_process, _ID_OFFICIAL_PRIMARY, _id_level, _number_task, 'dispatched', now()::timestamp, _deleted_task));

 	IF (_UPDATE_TASK) THEN
		-- Obtener la posicion del siguiente nivel
		_POSITION_LEVEL_CURRENT_LEVEL = (select bvfvl.position_level from business.view_flow_version_level bvfvl where bvfvl.id_level = _id_level order by bvfvl.id_flow_version_level limit 1);
		
		FOR _X IN (select bvfvl.* from business.view_process bvp
			inner join business.view_flow_version bvfv on bvp.id_flow_version = bvfv.id_flow_version
			inner join business.view_flow_version_level bvfvl on bvfv.id_flow_version = bvfvl.id_flow_version
			where bvp.id_process = _id_process order by bvfvl.position_level asc) LOOP
			
			IF (_X.position_level_father = _POSITION_LEVEL_CURRENT_LEVEL) THEN
				_POSITION_LEVEL_NEXT_LEVEL = _X.position_level;
				_TYPE_ELEMENT_NEXT_LEVEL = _X.type_element;
				_ID_CONTROL_NEXT_LEVEL = _X.id_control;
				_OPERATOR_NEXT_LEVEL = _X.operator;
				_VALUE_AGAINST_NEXT_LEVEL = _X.value_against;
				_OPTION_TRUE_NEXT_LEVEL = _X.option_true;
			END IF;
		END LOOP;
		
		IF (_POSITION_LEVEL_NEXT_LEVEL > 0) THEN
			RAISE NOTICE '_POSITION_LEVEL_NEXT_LEVEL -> %', _POSITION_LEVEL_NEXT_LEVEL;
			RAISE NOTICE '_TYPE_ELEMENT_NEXT_LEVEL -> %', _TYPE_ELEMENT_NEXT_LEVEL;
			RAISE NOTICE '_ID_CONTROL_NEXT_LEVEL -> %', _ID_CONTROL_NEXT_LEVEL;
			RAISE NOTICE '_OPERATOR_NEXT_LEVEL -> %', _OPERATOR_NEXT_LEVEL;
			RAISE NOTICE '_VALUE_AGAINST_NEXT_LEVEL -> %', _VALUE_AGAINST_NEXT_LEVEL;
			RAISE NOTICE '_OPTION_TRUE_NEXT_LEVEL -> %', _OPTION_TRUE_NEXT_LEVEL;
			
			IF (_TYPE_ELEMENT_NEXT_LEVEL = 'level') THEN
				-- IS LEVEL
				-- Obtener el perfil del nivel de acuerdo al nivel
				_LEVEL_PROFILE_NEXT_LEVEL = (select bvl.id_level_profile from business.view_level bvl where bvl.id_level = _POSITION_LEVEL_NEXT_LEVEL);
				
				RAISE NOTICE '%', _LEVEL_PROFILE_NEXT_LEVEL;
				
				-- Obtener el funcionario de acuerdo al perfil del nivel (Se selecciona el funcionario que tenga menos tareas)								
				_OFFICIAL_NEXT_LEVEL =  (select bvlpoij.id_official from business.view_level_profile_official_inner_join bvlpoij where bvlpoij.id_level_profile = _LEVEL_PROFILE_NEXT_LEVEL order by bvlpoij.number_task asc limit 1);
				RAISE NOTICE '%', _OFFICIAL_NEXT_LEVEL;
				
				
				IF (_OFFICIAL_NEXT_LEVEL > 0) THEN
					_NUMBER_PROCESS = (select bvp.number_process from business.view_process bvp where bvp.id_process = _id_process);
					
					_ACRONYM_TASK = (select bvf.acronym_task from business.view_process bvp
						inner join business.view_flow_version bvfv on bvp.id_flow_version = bvfv.id_flow_version
						inner join business.view_flow bvf on bvfv.id_flow = bvf.id_flow
						where bvp.id_process = _id_process);
						
					_NUMBER_TASK_NEW_TASK = ''||_NUMBER_PROCESS||'-'||_ACRONYM_TASK||'-';
					
					_ID_NEW_TASK = (select * from business.dml_task_create(id_user_, _id_process, _OFFICIAL_NEXT_LEVEL, _POSITION_LEVEL_NEXT_LEVEL, _NUMBER_TASK_NEW_TASK, 'created', now()::timestamp, false));
		
					IF (_ID_NEW_TASK > 0) THEN
						RETURN QUERY select * from business.view_task_inner_join bvtij 
							where bvtij.id_task = _id_task;
					ELSE
						_EXCEPTION = 'Ocurrió un error al generar la tarea';
						RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
					END IF;
				ELSE
					_EXCEPTION = 'El siguiente nivel no tiene funcionarios registrados en su perfil del nivel';
					RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
				END IF;
			ELSE
				IF (_TYPE_ELEMENT_NEXT_LEVEL = 'conditional') THEN
					-- IS CONDITIONAL
					_VALUE_PROCESS_CONTROL = (select bvpc.value_process_control from business.view_process_control bvpc where bvpc.id_process = _id_process and bvpc.id_level = _id_level and bvpc.id_control = _ID_CONTROL_NEXT_LEVEL::numeric);
							
					--_EXCEPTION = _VALUE_PROCESS_CONTROL;
					-- RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
					
					-- Evaluar los tipos de operadores
					IF (_OPERATOR_NEXT_LEVEL = '==') THEN
						IF (_VALUE_PROCESS_CONTROL = _VALUE_AGAINST_NEXT_LEVEL) THEN
							_POSITION_LEVEL_NEXT_LEVEL = (select bvfvl.id_level from business.view_flow_version_level bvfvl where bvfvl.position_level_father = _POSITION_LEVEL_NEXT_LEVEL and bvfvl.option_true = true);						
						
							-- Obtener el perfil del nivel de acuerdo al nivel
							_LEVEL_PROFILE_NEXT_LEVEL = (select bvl.id_level_profile from business.view_level bvl where bvl.id_level = _POSITION_LEVEL_NEXT_LEVEL);

							-- Obtener el funcionario de acuerdo al perfil del nivel (Se selecciona el funcionario que tenga menos tareas)								
							_OFFICIAL_NEXT_LEVEL =  (select bvlpoij.id_official from business.view_level_profile_official_inner_join bvlpoij where bvlpoij.id_level_profile = _LEVEL_PROFILE_NEXT_LEVEL order by bvlpoij.number_task asc limit 1);
							RAISE NOTICE '%', _OFFICIAL_NEXT_LEVEL;
							
							IF (_OFFICIAL_NEXT_LEVEL > 0) THEN
								_NUMBER_PROCESS = (select bvp.number_process from business.view_process bvp where bvp.id_process = _id_process);

								_ACRONYM_TASK = (select bvf.acronym_task from business.view_process bvp
									inner join business.view_flow_version bvfv on bvp.id_flow_version = bvfv.id_flow_version
									inner join business.view_flow bvf on bvfv.id_flow = bvf.id_flow
									where bvp.id_process = _id_process);

								_NUMBER_TASK_NEW_TASK = ''||_NUMBER_PROCESS||'-'||_ACRONYM_TASK||'-';

								_ID_NEW_TASK = (select * from business.dml_task_create(id_user_, _id_process, _OFFICIAL_NEXT_LEVEL, _POSITION_LEVEL_NEXT_LEVEL, _NUMBER_TASK_NEW_TASK, now()::timestamp, 'progress', 'received', now()::timestamp, false));

								IF (_ID_NEW_TASK > 0) THEN
									RETURN QUERY select * from business.view_task_inner_join bvtij 
										where bvtij.id_task = _id_task;
								ELSE
									_EXCEPTION = 'Ocurrió un error al generar la tarea';
									RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
								END IF;
							ELSE
								_EXCEPTION = 'El siguiente nivel no tiene funcionarios registrados en su perfil del nivel';
								RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
							END IF;
						ELSE
							_POSITION_LEVEL_NEXT_LEVEL = (select bvfvl.id_level from business.view_flow_version_level bvfvl where bvfvl.position_level_father = _POSITION_LEVEL_NEXT_LEVEL and bvfvl.option_true = true);						
						
							-- Obtener el perfil del nivel de acuerdo al nivel
							_LEVEL_PROFILE_NEXT_LEVEL = (select bvl.id_level_profile from business.view_level bvl where bvl.id_level = _POSITION_LEVEL_NEXT_LEVEL);

							-- Obtener el funcionario de acuerdo al perfil del nivel (Se selecciona el funcionario que tenga menos tareas)								
							_OFFICIAL_NEXT_LEVEL =  (select bvlpoij.id_official from business.view_level_profile_official_inner_join bvlpoij where bvlpoij.id_level_profile = _LEVEL_PROFILE_NEXT_LEVEL order by bvlpoij.number_task asc limit 1);
							RAISE NOTICE '%', _OFFICIAL_NEXT_LEVEL;
							
							IF (_OFFICIAL_NEXT_LEVEL > 0) THEN
								_NUMBER_PROCESS = (select bvp.number_process from business.view_process bvp where bvp.id_process = _id_process);

								_ACRONYM_TASK = (select bvf.acronym_task from business.view_process bvp
									inner join business.view_flow_version bvfv on bvp.id_flow_version = bvfv.id_flow_version
									inner join business.view_flow bvf on bvfv.id_flow = bvf.id_flow
									where bvp.id_process = _id_process);

								_NUMBER_TASK_NEW_TASK = ''||_NUMBER_PROCESS||'-'||_ACRONYM_TASK||'-';

								_ID_NEW_TASK = (select * from business.dml_task_create(id_user_, _id_process, _OFFICIAL_NEXT_LEVEL, _POSITION_LEVEL_NEXT_LEVEL, _NUMBER_TASK_NEW_TASK, now()::timestamp, 'progress', 'received', now()::timestamp, false));

								IF (_ID_NEW_TASK > 0) THEN
									RETURN QUERY select * from business.view_task_inner_join bvtij 
										where bvtij.id_task = _id_task;
								ELSE
									_EXCEPTION = 'Ocurrió un error al generar la tarea';
									RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
								END IF;
							ELSE
								_EXCEPTION = 'El siguiente nivel no tiene funcionarios registrados en su perfil del nivel';
								RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
							END IF;
						END IF;
					ELSE
						-- IS OPERATOR DISTINCT ==
						_EXCEPTION = 'IS OPERATOR DISTINCT ==';
						RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';	
					END IF;
				ELSE
					-- IS CONDITIONAL
					_EXCEPTION = 'IS FINISH';
					RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';				
				END IF;
			END IF;
		ELSE
			_EXCEPTION = 'El nivel actual no tiene niveles siguientes enlazados';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;

	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar task';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_task_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_task_send(numeric, numeric, numeric, numeric, numeric, character varying, business."TYPE_STATUS_TASK", timestamp without time zone, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_process_item_create_modified(numeric, numeric, numeric, numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_process_item_create_modified(numeric, numeric, numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_process_item_create_modified(
	id_user_ numeric,
	_id_official numeric,
	_id_process numeric,
	_id_task numeric,
	_id_level numeric)
    RETURNS TABLE(id_process_item numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, id_item numeric, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, number_task character varying, type_status_task business."TYPE_STATUS_TASK", date_task timestamp without time zone, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, id_item_category numeric, name_item character varying, description_item character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_COMPANY NUMERIC;
	_ID_ITEM NUMERIC;
	_ID_PROCESS_ITEM NUMERIC;
	_PLUGIN_ITEM_PROCESS BOOLEAN;
	_SELECT_PLUGIN_ITEM BOOLEAN DEFAULT FALSE;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	-- Get the id company _ID_COMPANY
	_ID_COMPANY = (select vu.id_company from core.view_user vu where vu.id_user = id_user_); 

	-- Obtener el estado del plugin item con el id_level
	_PLUGIN_ITEM_PROCESS = (select bvt.plugin_item_process from business.view_level bvl 
		inner join business.view_template bvt on bvt.id_template = bvl.id_template
		where bvl.id_level = 1);
		
	IF (_PLUGIN_ITEM_PROCESS) THEN
	 	_SELECT_PLUGIN_ITEM = (select bvpi.select_plugin_item from business.view_level bvl 
			inner join business.view_template bvt on bvt.id_template = bvl.id_template
			inner join business.view_plugin_item bvpi on bvpi.id_plugin_item = bvt.id_plugin_item
			where bvl.id_level = 1);
	END IF;
		
	IF (_SELECT_PLUGIN_ITEM) THEN
		_ID_ITEM = (select items.id_item from (select * from business.view_item bvi where bvi.id_company = _ID_COMPANY) as items
		LEFT JOIN (select distinct bvpi.id_item from business.view_process_item bvpi where bvpi.id_level = _id_level) as assignedItems
		on items.id_item = assignedItems.id_item where assignedItems.id_item IS NULL order by items.id_item asc limit 1);
	ELSE
		_ID_ITEM = (select bvi.id_item from business.view_item bvi order by bvi.id_item asc limit 1);
	END IF;

	IF (_ID_ITEM >= 1) THEN
		_ID_PROCESS_ITEM = (select * from business.dml_process_item_create(id_user_, _id_official, _id_process, _id_task, _id_level, _ID_ITEM));
	
		IF (_ID_PROCESS_ITEM >= 1) THEN
			RETURN QUERY select * from business.view_process_item_inner_join bvpiij 
				where bvpiij.id_process_item = _ID_PROCESS_ITEM;
		ELSE
			_EXCEPTION = 'Ocurrió un error al ingresar process_item';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'No se encontraron items registrados';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_item_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_process_item_create_modified(numeric, numeric, numeric, numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_process_item_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_process_item_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_process_item_update_modified(
	id_user_ numeric,
	_id_process_item numeric,
	_id_official numeric,
	_id_process numeric,
	_id_task numeric,
	_id_level numeric,
	_id_item numeric)
    RETURNS TABLE(id_process_item numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, id_item numeric, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, number_task character varying, type_status_task business."TYPE_STATUS_TASK", date_task timestamp without time zone, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, id_item_category numeric, name_item character varying, description_item character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_PROCESS_ITEM BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_PROCESS_ITEM = (select * from business.dml_process_item_update(id_user_, _id_process_item, _id_official, _id_process, _id_task, _id_level, _id_item));

 	IF (_UPDATE_PROCESS_ITEM) THEN
		RETURN QUERY select * from business.view_process_item_inner_join bvpiij 
			where bvpiij.id_process_item = _id_process_item;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar process_item';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_item_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_process_item_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_process_item_delete_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_process_item_delete_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_process_item_delete_modified(
	id_user_ numeric,
	_id_process_item numeric)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
	_X RECORD;
	_COUNT_COLUMN_PROCESS_ITEM NUMERIC DEFAULT 0;
	_DELETE_COLUMN_PROCESS_ITEM BOOLEAN DEFAULT false;
	_DELETE_PROCESS_ITEM BOOLEAN;
BEGIN
	FOR _X IN select bvcpi.id_column_process_item from business.view_column_process_item bvcpi where bvcpi.id_process_item = _id_process_item LOOP
		_DELETE_COLUMN_PROCESS_ITEM = (select * from business.dml_column_process_item_delete(id_user_, _X.id_column_process_item));
		_COUNT_COLUMN_PROCESS_ITEM = _COUNT_COLUMN_PROCESS_ITEM + 1;
	END LOOP;
	
	IF (_COUNT_COLUMN_PROCESS_ITEM = 0) THEN
		_DELETE_COLUMN_PROCESS_ITEM = true;
	END IF;
	
	IF (_DELETE_COLUMN_PROCESS_ITEM) THEN
		_DELETE_PROCESS_ITEM = (select * from business.dml_process_item_delete(id_user_, _id_process_item));
		
		IF (_DELETE_PROCESS_ITEM) THEN
			RETURN true;
		ELSE
			_EXCEPTION = 'Ocurrió un error al eliminar process item';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'Ocurrió un error al eliminar columns process item';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_item_delete_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_process_item_delete_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_column_process_item_create_modified(numeric, numeric, numeric, character varying)
-- DROP FUNCTION IF EXISTS business.dml_column_process_item_create_modified(numeric, numeric, numeric, character varying);

CREATE OR REPLACE FUNCTION business.dml_column_process_item_create_modified(
	id_user_ numeric,
	_id_plugin_item_column numeric,
	_id_process_item numeric,
	_value_column_process_item character varying)
    RETURNS TABLE(id_column_process_item numeric, id_plugin_item_column numeric, id_process_item numeric, value_column_process_item text, entry_date_column_process_item timestamp without time zone, id_plugin_item numeric, name_plugin_item_column character varying, lenght_plugin_item_column numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, id_item numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_COLUMN_PROCESS_ITEM NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_COLUMN_PROCESS_ITEM = (select * from business.dml_column_process_item_create(id_user_, _id_plugin_item_column, _id_process_item, _value_column_process_item, now()::timestamp));
	
	IF (_ID_COLUMN_PROCESS_ITEM >= 1) THEN
		RETURN QUERY select * from business.view_column_process_item_inner_join bvcpiij 
			where bvcpiij.id_column_process_item = _ID_COLUMN_PROCESS_ITEM;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar column_process_item';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_column_process_item_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_column_process_item_create_modified(numeric, numeric, numeric, character varying)
    OWNER TO postgres;

-- FUNCTION: business.dml_column_process_item_update_modified(numeric, numeric, numeric, numeric, text, timestamp without time zone)
-- DROP FUNCTION IF EXISTS business.dml_column_process_item_update_modified(numeric, numeric, numeric, numeric, text, timestamp without time zone);

CREATE OR REPLACE FUNCTION business.dml_column_process_item_update_modified(
	id_user_ numeric,
	_id_column_process_item numeric,
	_id_plugin_item_column numeric,
	_id_process_item numeric,
	_value_column_process_item text,
	_entry_date_column_process_item timestamp without time zone)
    RETURNS TABLE(id_column_process_item numeric, id_plugin_item_column numeric, id_process_item numeric, value_column_process_item text, entry_date_column_process_item timestamp without time zone, id_plugin_item numeric, name_plugin_item_column character varying, lenght_plugin_item_column numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, id_item numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_COLUMN_PROCESS_ITEM BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_COLUMN_PROCESS_ITEM = (select * from business.dml_column_process_item_update(id_user_, _id_column_process_item, _id_plugin_item_column, _id_process_item, _value_column_process_item, _entry_date_column_process_item));

 	IF (_UPDATE_COLUMN_PROCESS_ITEM) THEN
		RETURN QUERY select * from business.view_column_process_item_inner_join bvcpiij 
			where bvcpiij.id_column_process_item = _id_column_process_item;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar column_process_item';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_column_process_item_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_column_process_item_update_modified(numeric, numeric, numeric, numeric, text, timestamp without time zone)
    OWNER TO postgres;

-- FUNCTION: business.dml_template_update_modified(numeric, numeric, numeric, numeric, numeric, boolean, boolean, character varying, character varying, boolean, timestamp without time zone, boolean, boolean)
-- DROP FUNCTION IF EXISTS business.dml_template_update_modified(numeric, numeric, numeric, numeric, numeric, boolean, boolean, character varying, character varying, boolean, timestamp without time zone, boolean, boolean);

CREATE OR REPLACE FUNCTION business.dml_template_update_modified(
	id_user_ numeric,
	_id_template numeric,
	_id_company numeric,
	_id_documentation_profile numeric,
	_id_plugin_item numeric,
	_plugin_attached_process boolean,
	_plugin_item_process boolean,
	_name_template character varying,
	_description_template character varying,
	_status_template boolean,
	_last_change timestamp without time zone,
	_in_use boolean,
	_deleted_template boolean)
    RETURNS TABLE(id_template numeric, id_company numeric, id_documentation_profile numeric, id_plugin_item numeric, plugin_attached_process boolean, plugin_item_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, in_use boolean, deleted_template boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, name_documentation_profile character varying, description_documentation_profile character varying, status_documentation_profile boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_TEMPLATE BOOLEAN;
 	_UPDATE_LAST_CHANGE BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_TEMPLATE = (select * from business.dml_template_update(id_user_, _id_template, _id_company, _id_documentation_profile, _id_plugin_item, _plugin_attached_process, _plugin_item_process, _name_template, _description_template, _status_template, _last_change, _in_use, _deleted_template));

 	IF (_UPDATE_TEMPLATE) THEN
		_UPDATE_LAST_CHANGE = (select * from business.dml_template_update_last_change(id_user_, _id_template));

		RETURN QUERY select * from business.view_template_inner_join bvtij 
			where bvtij.id_template = _id_template;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar template';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_template_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_template_update_modified(numeric, numeric, numeric, numeric, numeric, boolean, boolean, character varying, character varying, boolean, timestamp without time zone, boolean, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_process_attached_create_modified(numeric, numeric, numeric, numeric, numeric, numeric, character varying, character varying, character varying, character varying, character varying)
-- DROP FUNCTION IF EXISTS business.dml_process_attached_create_modified(numeric, numeric, numeric, numeric, numeric, numeric, character varying, character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION business.dml_process_attached_create_modified(
	id_user_ numeric,
	_id_official numeric,
	_id_process numeric,
	_id_task numeric,
	_id_level numeric,
	_id_attached numeric,
	_file_name character varying,
	_length_mb character varying,
	_extension character varying,
	_server_path character varying,
	_alfresco_path character varying)
    RETURNS TABLE(id_process_attached numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, id_attached numeric, file_name character varying, length_mb character varying, extension character varying, server_path character varying, alfresco_path character varying, upload_date timestamp without time zone, deleted_process_attached boolean, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, number_task character varying, type_status_task business."TYPE_STATUS_TASK", date_task timestamp without time zone, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, name_attached character varying, description_attached character varying, length_mb_attached numeric, required_attached boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_PROCESS_ATTACHED NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_PROCESS_ATTACHED = (select * from business.dml_process_attached_create(id_user_, _id_official, _id_process, _id_task, _id_level, _id_attached, _file_name, _length_mb, _extension, _server_path, _alfresco_path, now()::timestamp, false));
	
	IF (_ID_PROCESS_ATTACHED >= 1) THEN
		RETURN QUERY select * from business.view_process_attached_inner_join bvpaij 
			where bvpaij.id_process_attached = _ID_PROCESS_ATTACHED;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar process_attached';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_attached_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_process_attached_create_modified(numeric, numeric, numeric, numeric, numeric, numeric, character varying, character varying, character varying, character varying, character varying)
    OWNER TO postgres;

-- FUNCTION: business.dml_process_attached_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, numeric, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, boolean)
-- DROP FUNCTION IF EXISTS business.dml_process_attached_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, numeric, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, boolean);

CREATE OR REPLACE FUNCTION business.dml_process_attached_update_modified(
	id_user_ numeric,
	_id_process_attached numeric,
	_id_official numeric,
	_id_process numeric,
	_id_task numeric,
	_id_level numeric,
	_id_attached numeric,
	_file_name character varying,
	_length_mb character varying,
	_extension character varying,
	_server_path character varying,
	_alfresco_path character varying,
	_upload_date timestamp without time zone,
	_deleted_process_attached boolean)
    RETURNS TABLE(id_process_attached numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, id_attached numeric, file_name character varying, length_mb character varying, extension character varying, server_path character varying, alfresco_path character varying, upload_date timestamp without time zone, deleted_process_attached boolean, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, number_task character varying, type_status_task business."TYPE_STATUS_TASK", date_task timestamp without time zone, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, name_attached character varying, description_attached character varying, length_mb_attached numeric, required_attached boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_PROCESS_ATTACHED BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_PROCESS_ATTACHED = (select * from business.dml_process_attached_update(id_user_, _id_process_attached, _id_official, _id_process, _id_task, _id_level, _id_attached, _file_name, _length_mb, _extension, _server_path, _alfresco_path, now()::timestamp, _deleted_process_attached));

 	IF (_UPDATE_PROCESS_ATTACHED) THEN
		RETURN QUERY select * from business.view_process_attached_inner_join bvpaij 
			where bvpaij.id_process_attached = _id_process_attached;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar process_attached';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_attached_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_process_attached_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, numeric, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_process_control_create_modified(numeric, numeric, numeric, numeric, numeric, numeric, text)
-- DROP FUNCTION IF EXISTS business.dml_process_control_create_modified(numeric, numeric, numeric, numeric, numeric, numeric, text);

CREATE OR REPLACE FUNCTION business.dml_process_control_create_modified(
	id_user_ numeric,
	_id_official numeric,
	_id_process numeric,
	_id_task numeric,
	_id_level numeric,
	_id_control numeric,
	_value_process_control text)
    RETURNS TABLE(id_process_control numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, id_control numeric, value_process_control text, last_change_process_control timestamp without time zone, deleted_process_control boolean, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, number_task character varying, type_status_task business."TYPE_STATUS_TASK", date_task timestamp without time zone, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, type_control business."TYPE_CONTROL", title_control character varying, form_name_control character varying, initial_value_control character varying, required_control boolean, min_length_control numeric, max_length_control numeric, placeholder_control character varying, spell_check_control boolean, options_control json, in_use boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_PROCESS_CONTROL NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_PROCESS_CONTROL = (select * from business.dml_process_control_create(id_user_, _id_official, _id_process, _id_task, _id_level, _id_control, _value_process_control, now()::timestamp, false));
	
	IF (_ID_PROCESS_CONTROL >= 1) THEN
		RETURN QUERY select * from business.view_process_control_inner_join bvpcij 
			where bvpcij.id_process_control = _ID_PROCESS_CONTROL;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar process_control';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_control_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_process_control_create_modified(numeric, numeric, numeric, numeric, numeric, numeric, text)
    OWNER TO postgres;

-- FUNCTION: business.dml_process_control_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, numeric, text, timestamp without time zone, boolean)
-- DROP FUNCTION IF EXISTS business.dml_process_control_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, numeric, text, timestamp without time zone, boolean);

CREATE OR REPLACE FUNCTION business.dml_process_control_update_modified(
	id_user_ numeric,
	_id_process_control numeric,
	_id_official numeric,
	_id_process numeric,
	_id_task numeric,
	_id_level numeric,
	_id_control numeric,
	_value_process_control text,
	_last_change_process_control timestamp without time zone,
	_deleted_process_control boolean)
    RETURNS TABLE(id_process_control numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, id_control numeric, value_process_control text, last_change_process_control timestamp without time zone, deleted_process_control boolean, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, number_task character varying, type_status_task business."TYPE_STATUS_TASK", date_task timestamp without time zone, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, type_control business."TYPE_CONTROL", title_control character varying, form_name_control character varying, initial_value_control character varying, required_control boolean, min_length_control numeric, max_length_control numeric, placeholder_control character varying, spell_check_control boolean, options_control json, in_use boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_PROCESS_CONTROL BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_PROCESS_CONTROL = (select * from business.dml_process_control_update(id_user_, _id_process_control, _id_official, _id_process, _id_task, _id_level, _id_control, _value_process_control, now()::timestamp, _deleted_process_control));

 	IF (_UPDATE_PROCESS_CONTROL) THEN
		RETURN QUERY select * from business.view_process_control_inner_join bvpcij 
			where bvpcij.id_process_control = _id_process_control;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar process_control';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_control_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_process_control_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, numeric, text, timestamp without time zone, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_process_comment_create_modified(numeric, numeric, numeric, numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_process_comment_create_modified(numeric, numeric, numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_process_comment_create_modified(
	id_user_ numeric,
	_id_official numeric,
	_id_process numeric,
	_id_task numeric,
	_id_level numeric)
    RETURNS TABLE(id_process_comment numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, value_process_comment character varying, date_process_comment timestamp without time zone, deleted_process_comment boolean, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, number_task character varying, type_status_task business."TYPE_STATUS_TASK", date_task timestamp without time zone, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_PROCESS_COMMENT NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_PROCESS_COMMENT = (select * from business.dml_process_comment_create(id_user_, _id_official, _id_process, _id_task, _id_level, 'Nuevo comentario', now()::timestamp, false));
	
	IF (_ID_PROCESS_COMMENT >= 1) THEN
		RETURN QUERY select * from business.view_process_comment_inner_join bvpcij 
			where bvpcij.id_process_comment = _ID_PROCESS_COMMENT;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar process_comment';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_comment_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_process_comment_create_modified(numeric, numeric, numeric, numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_process_comment_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, character varying, timestamp without time zone, boolean)
-- DROP FUNCTION IF EXISTS business.dml_process_comment_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, character varying, timestamp without time zone, boolean);

CREATE OR REPLACE FUNCTION business.dml_process_comment_update_modified(
	id_user_ numeric,
	_id_process_comment numeric,
	_id_official numeric,
	_id_process numeric,
	_id_task numeric,
	_id_level numeric,
	_value_process_comment character varying,
	_date_process_comment timestamp without time zone,
	_deleted_process_comment boolean)
    RETURNS TABLE(id_process_comment numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, value_process_comment character varying, date_process_comment timestamp without time zone, deleted_process_comment boolean, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, number_task character varying, type_status_task business."TYPE_STATUS_TASK", date_task timestamp without time zone, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_PROCESS_COMMENT BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_PROCESS_COMMENT = (select * from business.dml_process_comment_update(id_user_, _id_process_comment, _id_official, _id_process, _id_task, _id_level, _value_process_comment, now()::timestamp, _deleted_process_comment));

 	IF (_UPDATE_PROCESS_COMMENT) THEN
		RETURN QUERY select * from business.view_process_comment_inner_join bvpcij 
			where bvpcij.id_process_comment = _id_process_comment;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar process_comment';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_comment_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_process_comment_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, character varying, timestamp without time zone, boolean)
    OWNER TO postgres;