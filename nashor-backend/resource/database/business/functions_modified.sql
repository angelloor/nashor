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
	_COUNT = (select count(*) from business.view_process bvp  where bvp.id_flow_version = 1 and bvp.finalized_process = false);
	
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
    RETURNS TABLE(id_official numeric, id_company numeric, id_user numeric, id_area numeric, id_position numeric, deleted_official boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, name_area character varying, description_area character varying, name_position character varying, description_position character varying, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_profile numeric, name_type_user character varying, description_type_user character varying, status_type_user boolean, title_academic character varying, abbreviation_academic character varying, nivel_academic character varying, name_job character varying, address_job character varying, phone_job character varying, position_job character varying) 
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
	_nivel_academic character varying,
	_name_job character varying,
	_address_job character varying,
	_phone_job character varying,
	_position_job character varying,
	_id_area numeric,
	_id_position numeric)
    RETURNS TABLE(id_official numeric, id_company numeric, id_user numeric, id_area numeric, id_position numeric, deleted_official boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, name_area character varying, description_area character varying, name_position character varying, description_position character varying, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_profile numeric, name_type_user character varying, description_type_user character varying, status_type_user boolean, title_academic character varying, abbreviation_academic character varying, nivel_academic character varying, name_job character varying, address_job character varying, phone_job character varying, position_job character varying) 
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
	_UPDATE_ACADEMIC = (select * from core.dml_academic_update(id_user_, _id_academic, _title_academic, _abbreviation_academic, _nivel_academic, false));
				
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
    RETURNS TABLE(id_item numeric, id_company numeric, id_item_category numeric, name_item character varying, description_item character varying, cpc_item character varying, deleted_item boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, name_item_category character varying, description_item_category character varying) 
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
		_ID_ITEM = (select * from business.dml_item_create(id_user_, _id_company, _ID_ITEM_CATEGORY, 'Nuevo articulo', '', '', false));
		
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
	_cpc_item character varying,
	_deleted_item boolean)
    RETURNS TABLE(id_item numeric, id_company numeric, id_item_category numeric, name_item character varying, description_item character varying, cpc_item character varying, deleted_item boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, name_item_category character varying, description_item_category character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_ITEM BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_ITEM = (select * from business.dml_item_update(id_user_, _id_item, _id_company, _id_item_category, _name_item, _description_item, _cpc_item, _deleted_item));

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

ALTER FUNCTION business.dml_item_update_modified(numeric, numeric, numeric, numeric, character varying, character varying, character varying, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_control_create_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_control_create_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_control_create_modified(
	id_user_ numeric,
	_id_company numeric)
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
	_ID_CONTROL = (select * from business.dml_control_create(id_user_, _ID_COMPANY, 'input', 'Nuevo control', 'form_control', '', false, 1, 1, '', false, '[]', false, false));
	
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

ALTER FUNCTION business.dml_control_create_modified(numeric, numeric)
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

-- FUNCTION: business.dml_template_create_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_template_create_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_template_create_modified(
	id_user_ numeric,
	_id_company numeric)
    RETURNS TABLE(id_template numeric, id_company numeric, id_documentation_profile numeric, plugin_item_process boolean, plugin_attached_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, in_use boolean, deleted_template boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, name_documentation_profile character varying, description_documentation_profile character varying, status_documentation_profile boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_DOCUMENTATION_PROFILE NUMERIC;
	_ID_TEMPLATE NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_DOCUMENTATION_PROFILE = (select bvdp.id_documentation_profile from business.view_documentation_profile bvdp order by bvdp.id_documentation_profile asc limit 1);
	
	IF (_ID_DOCUMENTATION_PROFILE IS NULL) THEN
		_EXCEPTION = 'No se encontró un documentation_profile';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	
	_ID_TEMPLATE = (select * from business.dml_template_create(id_user_, _ID_COMPANY, _ID_DOCUMENTATION_PROFILE, false, false, 'Nueva plantilla', '', false, now()::timestamp, false, false));
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

-- FUNCTION: business.dml_template_update_modified(numeric, numeric, numeric, numeric, boolean, boolean, character varying, character varying, boolean, timestamp without time zone, boolean, boolean)
-- DROP FUNCTION IF EXISTS business.dml_template_update_modified(numeric, numeric, numeric, numeric, boolean, boolean, character varying, character varying, boolean, timestamp without time zone, boolean, boolean);

CREATE OR REPLACE FUNCTION business.dml_template_update_modified(
	id_user_ numeric,
	_id_template numeric,
	_id_company numeric,
	_id_documentation_profile numeric,
	_plugin_item_process boolean,
	_plugin_attached_process boolean,
	_name_template character varying,
	_description_template character varying,
	_status_template boolean,
	_last_change timestamp without time zone,
	_in_use boolean,
	_deleted_template boolean)
    RETURNS TABLE(id_template numeric, id_company numeric, id_documentation_profile numeric, plugin_item_process boolean, plugin_attached_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, in_use boolean, deleted_template boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, name_documentation_profile character varying, description_documentation_profile character varying, status_documentation_profile boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_TEMPLATE BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_TEMPLATE = (select * from business.dml_template_update(id_user_, _id_template, _id_company, _id_documentation_profile, _plugin_item_process, _plugin_attached_process, _name_template, _description_template, _status_template, _last_change, _in_use, _deleted_template));

 	IF (_UPDATE_TEMPLATE) THEN
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

ALTER FUNCTION business.dml_template_update_modified(numeric, numeric, numeric, numeric, boolean, boolean, character varying, character varying, boolean, timestamp without time zone, boolean, boolean)
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
    RETURNS TABLE(id_template_control numeric, id_template numeric, id_control numeric, ordinal_position numeric, id_documentation_profile numeric, plugin_item_process boolean, plugin_attached_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, type_control business."TYPE_CONTROL", title_control character varying, form_name_control character varying, initial_value_control character varying, required_control boolean, min_length_control numeric, max_length_control numeric, placeholder_control character varying, spell_check_control boolean, options_control json, in_use boolean, id_company numeric) 
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
    RETURNS TABLE(id_template_control numeric, id_template numeric, id_control numeric, ordinal_position numeric, id_documentation_profile numeric, plugin_item_process boolean, plugin_attached_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, type_control business."TYPE_CONTROL", title_control character varying, form_name_control character varying, initial_value_control character varying, required_control boolean, min_length_control numeric, max_length_control numeric, placeholder_control character varying, spell_check_control boolean, options_control json, in_use boolean, id_company numeric) 
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
	_ID_CONTROL = (select newControl.id_control from (select * from business.dml_control_create_modified(id_user_,_ID_COMPANY)) as newControl);
	
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
    RETURNS TABLE(id_template_control numeric, id_template numeric, id_control numeric, ordinal_position numeric, id_documentation_profile numeric, plugin_item_process boolean, plugin_attached_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, type_control business."TYPE_CONTROL", title_control character varying, form_name_control character varying, initial_value_control character varying, required_control boolean, min_length_control numeric, max_length_control numeric, placeholder_control character varying, spell_check_control boolean, options_control json, in_use boolean, id_company numeric) 
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
 	_UPDATE_CONTROL = (select * from business.dml_control_update(id_user_, _id_control, _id_company, _type_control, _title_control, _form_name_control, _initial_value_control, _required_control, _min_length_control, _max_length_control, _placeholder_control, _spell_check_control, _options_control, _in_use, _deleted_control));
 	
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
	_template_control json)
    RETURNS TABLE(id_template_control numeric, id_template numeric, id_control numeric, ordinal_position numeric, id_documentation_profile numeric, plugin_item_process boolean, plugin_attached_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, type_control business."TYPE_CONTROL", title_control character varying, form_name_control character varying, initial_value_control character varying, required_control boolean, min_length_control numeric, max_length_control numeric, placeholder_control character varying, spell_check_control boolean, options_control json, in_use boolean, id_company numeric) 
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
	
		RETURN QUERY select * from business.view_template_control_inner_join bvtcij order by bvtcij.ordinal_position asc;
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

ALTER FUNCTION business.dml_template_control_update_positions(numeric, json)
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

-- FUNCTION: business.dml_process_type_create_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_process_type_create_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_process_type_create_modified(
	id_user_ numeric,
	_id_company numeric)
    RETURNS TABLE(id_process_type numeric, id_company numeric, name_process_type character varying, description_process_type character varying, acronym_process_type character varying, sequential_process_type numeric, deleted_process_type boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_PROCESS_TYPE NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_PROCESS_TYPE = (select business.dml_process_type_create(id_user_, _id_company, 'Nuevo tipo de proceso', '', '', 1, false));
	
	IF (_ID_PROCESS_TYPE >= 1) THEN
		EXECUTE 'CREATE SEQUENCE IF NOT EXISTS business.serial_process_type_id_'||_ID_PROCESS_TYPE||' INCREMENT 1 MINVALUE  1 MAXVALUE 9999999999 START 2 CACHE 1';
	
		RETURN QUERY select * from business.view_process_type_inner_join bvptij 
			where bvptij.id_process_type = _ID_PROCESS_TYPE;
	ELSE
		_EXCEPTION = 'Ocurrió un error al ingresar process_type';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_type_create_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_process_type_create_modified(numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_process_type_update_modified(numeric, numeric, numeric, character varying, character varying, character varying, numeric, boolean)
-- DROP FUNCTION IF EXISTS business.dml_process_type_update_modified(numeric, numeric, numeric, character varying, character varying, character varying, numeric, boolean);

CREATE OR REPLACE FUNCTION business.dml_process_type_update_modified(
	id_user_ numeric,
	_id_process_type numeric,
	_id_company numeric,
	_name_process_type character varying,
	_description_process_type character varying,
	_acronym_process_type character varying,
	_sequential_process_type numeric,
	_deleted_process_type boolean)
    RETURNS TABLE(id_process_type numeric, id_company numeric, name_process_type character varying, description_process_type character varying, acronym_process_type character varying, sequential_process_type numeric, deleted_process_type boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_PROCESS_TYPE BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_PROCESS_TYPE = (select * from business.dml_process_type_update(id_user_, _id_process_type, _id_company, _name_process_type, _description_process_type, _acronym_process_type, _sequential_process_type, _deleted_process_type));

 	IF (_UPDATE_PROCESS_TYPE) THEN
		RETURN QUERY select * from business.view_process_type_inner_join bvptij 
			where bvptij.id_process_type = _id_process_type;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar process_type';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_type_update_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_process_type_update_modified(numeric, numeric, numeric, character varying, character varying, character varying, numeric, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_process_type_delete_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_process_type_delete_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_process_type_delete_modified(
	id_user_ numeric,
	_id_process_type numeric)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
 	_COUNT_DELETE BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_COUNT_DELETE = (select * from business.dml_process_type_delete(id_user_, _id_process_type));
		
	IF (_COUNT_DELETE) THEN
		EXECUTE 'DROP SEQUENCE IF EXISTS business.serial_process_type_id_'||_id_process_type||'';
		RETURN true;
	ELSE
		_EXCEPTION = 'Ocurrió un error al eliminar process_type';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_type_delete_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION business.dml_process_type_delete_modified(numeric, numeric)
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
    RETURNS TABLE(id_level numeric, id_company numeric, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, deleted_level boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, id_documentation_profile numeric, plugin_item_process boolean, plugin_attached_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, in_use boolean, name_level_profile character varying, description_level_profile character varying, name_level_status character varying, description_level_status character varying, color_level_status character varying) 
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
    RETURNS TABLE(id_level numeric, id_company numeric, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, deleted_level boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, id_documentation_profile numeric, plugin_item_process boolean, plugin_attached_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, in_use boolean, name_level_profile character varying, description_level_profile character varying, name_level_status character varying, description_level_status character varying, color_level_status character varying) 
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

-- FUNCTION: business.dml_flow_create_modified(numeric, numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_flow_create_modified(numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_flow_create_modified(
	id_user_ numeric,
	_id_company numeric,
	_id_process_type numeric)
    RETURNS TABLE(id_flow numeric, id_company numeric, id_process_type numeric, name_flow character varying, description_flow character varying, deleted_flow boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, name_process_type character varying, description_process_type character varying, acronym_process_type character varying, sequential_process_type numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_FLOW NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_FLOW = (select * from business.dml_flow_create(id_user_, _id_company, _id_process_type, 'Nuevo flujo', '', false));
	
	IF (_ID_FLOW >= 1) THEN
		RETURN QUERY select * from business.view_flow_inner_join bvfij 
			where bvfij.id_flow = _ID_FLOW;
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

ALTER FUNCTION business.dml_flow_create_modified(numeric, numeric, numeric)
    OWNER TO postgres;

-- FUNCTION: business.dml_flow_update_modified(numeric, numeric, numeric, numeric, character varying, character varying, boolean)
-- DROP FUNCTION IF EXISTS business.dml_flow_update_modified(numeric, numeric, numeric, numeric, character varying, character varying, boolean);

CREATE OR REPLACE FUNCTION business.dml_flow_update_modified(
	id_user_ numeric,
	_id_flow numeric,
	_id_company numeric,
	_id_process_type numeric,
	_name_flow character varying,
	_description_flow character varying,
	_deleted_flow boolean)
    RETURNS TABLE(id_flow numeric, id_company numeric, id_process_type numeric, name_flow character varying, description_flow character varying, deleted_flow boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, name_process_type character varying, description_process_type character varying, acronym_process_type character varying, sequential_process_type numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_FLOW BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_FLOW = (select * from business.dml_flow_update(id_user_, _id_flow, _id_company, _id_process_type, _name_flow, _description_flow, _deleted_flow));

 	IF (_UPDATE_FLOW) THEN
		RETURN QUERY select * from business.view_flow_inner_join bvfij 
			where bvfij.id_flow = _id_flow;
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

ALTER FUNCTION business.dml_flow_update_modified(numeric, numeric, numeric, numeric, character varying, character varying, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_flow_version_create_modified(numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_flow_version_create_modified(numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_flow_version_create_modified(
	id_user_ numeric,
	_id_flow numeric)
    RETURNS TABLE(id_flow_version numeric, id_flow numeric, number_flow_version numeric, status_flow_version boolean, creation_date_flow_version timestamp without time zone, deleted_flow_version boolean, id_company numeric, id_process_type numeric, name_flow character varying, description_flow character varying) 
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
    RETURNS TABLE(id_flow_version numeric, id_flow numeric, number_flow_version numeric, status_flow_version boolean, creation_date_flow_version timestamp without time zone, deleted_flow_version boolean, id_company numeric, id_process_type numeric, name_flow character varying, description_flow character varying) 
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
	
		_ID_FLOW_VERSION_LEVEL = (select * from business.dml_flow_version_level_create(id_user_, _id_flow_version, _ID_LEVEL, _LAST_POSITION_LEVEL + 1, 0, _type_element, '', '==', '', false, 25, 25));
	
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
	_id_process_type numeric)
    RETURNS TABLE(id_process numeric, id_process_type numeric, id_official numeric, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, deleted_process boolean, name_process_type character varying, description_process_type character varying, acronym_process_type character varying, sequential_process_type numeric, id_user numeric, id_area numeric, id_position numeric, id_flow numeric, number_flow_version numeric, status_flow_version boolean, creation_date_flow_version timestamp without time zone) 
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
	_ACRONYM_PROCESS_TYPE CHARACTER VARYING;
	_SERIAL_PROCESS_TYPE NUMERIC;
	_NUMBER_PROCESS CHARACTER VARYING;
	_ID_PROCESS NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_OFFICIAL = (select bvo.id_official from business.view_official bvo where bvo.id_user = id_user_);
	
	IF (_ID_OFFICIAL IS NULL) THEN
		_EXCEPTION = 'Tienes que estar registrado como funcionario';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	
	_ID_FLOW_VERSION = (select bvfv.id_flow_version from business.view_flow_version bvfv inner join business.view_flow bvf on bvfv.id_flow = bvf.id_flow inner join business.view_process_type bvpt on bvf.id_process_type = bvpt.id_process_type where bvpt.id_process_type = _id_process_type and bvfv.status_flow_version = true);
	
	IF (_ID_FLOW_VERSION IS NULL) THEN
		_EXCEPTION = 'El flujo del tipo de proceso no tiene una version activa';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	
	_ID_FLOW_VERSION_LEVEL = (select count(*) from business.view_flow_version_level bvfvl where bvfvl.id_flow_version = _ID_FLOW_VERSION);
	
	RAISE NOTICE '%', _ID_FLOW_VERSION_LEVEL;
	
	IF (_ID_FLOW_VERSION_LEVEL = 0) THEN
		_EXCEPTION = 'La version del flujo no tiene niveles asignados';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	
	-- _ACRONYM_COMPANY
	_ACRONYM_COMPANY = (select cvc.acronym_company from core.view_user cvu inner join core.view_company cvc on cvu.id_company = cvc.id_company where cvu.id_user = id_user_);
	RAISE NOTICE '%',_ACRONYM_COMPANY;
	-- _ACRONYM_PROCESS_TYPE
	_ACRONYM_PROCESS_TYPE = (select bvpt.acronym_process_type from business.view_process_type bvpt where bvpt.id_process_type = _id_process_type);
	RAISE NOTICE '%',_ACRONYM_PROCESS_TYPE;
	
	_SERIAL_PROCESS_TYPE =  (select nextval('business.serial_process_type_id_'||_id_process_type||'')-1);
	IF (_SERIAL_PROCESS_TYPE >= 1) THEN
		_NUMBER_PROCESS = ''||UPPER(_ACRONYM_COMPANY)||'-'||UPPER(_ACRONYM_PROCESS_TYPE)||'-'||_SERIAL_PROCESS_TYPE||'';
		_ID_PROCESS = (select business.dml_process_create(id_user_, _id_process_type, _ID_OFFICIAL, _ID_FLOW_VERSION, _NUMBER_PROCESS, now()::timestamp, false, false, false));
		
		IF (_ID_PROCESS >= 1) THEN
			RETURN QUERY select * from business.view_process_inner_join bvpij 
			where bvpij.id_process = _ID_PROCESS;
		ELSE
			_EXCEPTION = 'Ocurrió un error al ingresar process';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE 
		_EXCEPTION = 'No se encontro el secuencial de process_type';
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

-- FUNCTION: business.dml_process_update_modified(numeric, numeric, numeric, numeric, numeric, character varying, timestamp without time zone, boolean, boolean, boolean)
-- DROP FUNCTION IF EXISTS business.dml_process_update_modified(numeric, numeric, numeric, numeric, numeric, character varying, timestamp without time zone, boolean, boolean, boolean);

CREATE OR REPLACE FUNCTION business.dml_process_update_modified(
	id_user_ numeric,
	_id_process numeric,
	_id_process_type numeric,
	_id_official numeric,
	_id_flow_version numeric,
	_number_process character varying,
	_date_process timestamp without time zone,
	_generated_task boolean,
	_finalized_process boolean,
	_deleted_process boolean)
    RETURNS TABLE(id_process numeric, id_process_type numeric, id_official numeric, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, deleted_process boolean, name_process_type character varying, description_process_type character varying, acronym_process_type character varying, sequential_process_type numeric, id_user numeric, id_area numeric, id_position numeric, id_flow numeric, number_flow_version numeric, status_flow_version boolean, creation_date_flow_version timestamp without time zone) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_PROCESS BOOLEAN;
	_ID_LEVEL NUMERIC;
	_ID_TASK NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_LEVEL = (select bvfvl.id_level from business.view_flow_version_level bvfvl where bvfvl.id_flow_version = _id_flow_version order by bvfvl.position_level asc limit 1);
	
	IF (_ID_LEVEL IS null) THEN
		_EXCEPTION = 'La version del proceso no tiene niveles asignados';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF; 	
	
 	--_UPDATE_PROCESS = (select business.dml_process_update(id_user_, _id_process, _id_process_type, (select bvp.id_official from business.view_process bvp where bvp.id_process = _id_process), _id_flow_version, _number_process, _date_process, _generated_task, _finalized_process, _deleted_process));
 	_UPDATE_PROCESS = (select * from business.dml_process_update(id_user_, _id_process, _id_process_type, _id_official, _id_flow_version, _number_process, _date_process, _generated_task, _finalized_process, _deleted_process));
 	
	IF (_UPDATE_PROCESS) THEN
 		-- Generate task
		_ID_LEVEL = (select bvfvl.id_level from business.view_flow_version_level bvfvl where bvfvl.id_flow_version = _id_flow_version order by bvfvl.position_level asc limit 1);
		
		_ID_TASK = (select * from business.dml_task_create(id_user_, _id_process, _id_official, _ID_LEVEL, now()::timestamp, 'progress', 'dispatched', now()::timestamp, false));
		
		IF (_ID_TASK) THEN
			RETURN QUERY select * from business.view_process_inner_join bvpij 
				where bvpij.id_process = _id_process;
		ELSE
			_EXCEPTION = 'Ocurrió un error al generar la tarea';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
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

ALTER FUNCTION business.dml_process_update_modified(numeric, numeric, numeric, numeric, numeric, character varying, timestamp without time zone, boolean, boolean, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_task_create_modified(numeric, numeric, numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_task_create_modified(numeric, numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_task_create_modified(
	id_user_ numeric,
	_id_process numeric,
	_id_official numeric,
	_id_level numeric)
    RETURNS TABLE(id_task numeric, id_process numeric, id_official numeric, id_level numeric, creation_date_task timestamp without time zone, type_status_task business."TYPE_STATUS_TASK", type_action_task business."TYPE_ACTION_TASK", action_date_task timestamp with time zone, deleted_task boolean, id_process_type numeric, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, id_user numeric, id_area numeric, id_position numeric, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_TASK NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_TASK = (select * from business.dml_task_create(id_user_, _id_process, _id_official, _id_level, now()::timestamp, 'progress', 'dispatched', now()::timestamp, false));
	
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

-- FUNCTION: business.dml_task_update_modified(numeric, numeric, numeric, numeric, numeric, timestamp without time zone, business."TYPE_STATUS_TASK", business."TYPE_ACTION_TASK", timestamp with time zone, boolean)
-- DROP FUNCTION IF EXISTS business.dml_task_update_modified(numeric, numeric, numeric, numeric, numeric, timestamp without time zone, business."TYPE_STATUS_TASK", business."TYPE_ACTION_TASK", timestamp with time zone, boolean);

CREATE OR REPLACE FUNCTION business.dml_task_update_modified(
	id_user_ numeric,
	_id_task numeric,
	_id_process numeric,
	_id_official numeric,
	_id_level numeric,
	_creation_date_task timestamp without time zone,
	_type_status_task business."TYPE_STATUS_TASK",
	_type_action_task business."TYPE_ACTION_TASK",
	_action_date_task timestamp with time zone,
	_deleted_task boolean)
    RETURNS TABLE(id_task numeric, id_process numeric, id_official numeric, id_level numeric, creation_date_task timestamp without time zone, type_status_task business."TYPE_STATUS_TASK", type_action_task business."TYPE_ACTION_TASK", action_date_task timestamp with time zone, deleted_task boolean, id_process_type numeric, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, id_user numeric, id_area numeric, id_position numeric, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_TASK BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_TASK = (select * from business.dml_task_update(id_user_, _id_task, _id_process, _id_official, _id_level, _creation_date_task, _type_status_task, _type_action_task, _action_date_task, _deleted_task));

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

ALTER FUNCTION business.dml_task_update_modified(numeric, numeric, numeric, numeric, numeric, timestamp without time zone, business."TYPE_STATUS_TASK", business."TYPE_ACTION_TASK", timestamp with time zone, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_task_reasign(numeric, numeric, numeric, numeric, numeric, timestamp without time zone, business."TYPE_STATUS_TASK", business."TYPE_ACTION_TASK", timestamp with time zone, boolean)
-- DROP FUNCTION IF EXISTS business.dml_task_reasign(numeric, numeric, numeric, numeric, numeric, timestamp without time zone, business."TYPE_STATUS_TASK", business."TYPE_ACTION_TASK", timestamp with time zone, boolean);

CREATE OR REPLACE FUNCTION business.dml_task_reasign(
	id_user_ numeric,
	_id_task numeric,
	_id_process numeric,
	_id_official numeric,
	_id_level numeric,
	_creation_date_task timestamp without time zone,
	_type_status_task business."TYPE_STATUS_TASK",
	_type_action_task business."TYPE_ACTION_TASK",
	_action_date_task timestamp with time zone,
	_deleted_task boolean)
    RETURNS TABLE(id_task numeric, id_process numeric, id_official numeric, id_level numeric, creation_date_task timestamp without time zone, type_status_task business."TYPE_STATUS_TASK", type_action_task business."TYPE_ACTION_TASK", action_date_task timestamp with time zone, deleted_task boolean, id_process_type numeric, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, id_user numeric, id_area numeric, id_position numeric, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_OFFICIAL_PRIMARY NUMERIC;
 	_UPDATE_TASK BOOLEAN;
	_ID_NEW_TASK NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ID_OFFICIAL_PRIMARY = (select bvt.id_official from business.view_task bvt where bvt.id_task = _id_task);

 	_UPDATE_TASK = (select * from business.dml_task_update(id_user_, _id_task, _id_process, _ID_OFFICIAL_PRIMARY, _id_level, _creation_date_task, 'finished', 'reassigned', now()::timestamp, _deleted_task));

 	IF (_UPDATE_TASK) THEN
		-- Generate task
		_ID_NEW_TASK = (select * from business.dml_task_create(id_user_, _id_process, _id_official, _ID_LEVEL, now()::timestamp, 'progress', 'dispatched', now()::timestamp, false));
		
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

ALTER FUNCTION business.dml_task_reasign(numeric, numeric, numeric, numeric, numeric, timestamp without time zone, business."TYPE_STATUS_TASK", business."TYPE_ACTION_TASK", timestamp with time zone, boolean)
    OWNER TO postgres;

-- FUNCTION: business.dml_process_item_create_modified(numeric, numeric, numeric, numeric, numeric)
-- DROP FUNCTION IF EXISTS business.dml_process_item_create_modified(numeric, numeric, numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION business.dml_process_item_create_modified(
	id_user_ numeric,
	_id_official numeric,
	_id_process numeric,
	_id_task numeric,
	_id_level numeric)
    RETURNS TABLE(id_process_item numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, id_item numeric, amount_process_item numeric, features_process_item character varying, entry_date_process_item timestamp without time zone, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_process_type numeric, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, creation_date_task timestamp without time zone, type_status_task business."TYPE_STATUS_TASK", type_action_task business."TYPE_ACTION_TASK", action_date_task timestamp with time zone, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, id_item_category numeric, name_item character varying, description_item character varying, cpc_item character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_ID_COMPANY NUMERIC;
	_ID_ITEM NUMERIC;
	_ID_PROCESS_ITEM NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	-- Get the id company _ID_COMPANY
	_ID_COMPANY = (select vu.id_company from core.view_user vu where vu.id_user = id_user_); 

	_ID_ITEM = (select items.id_item from (select * from business.view_item bvi where bvi.id_company = _ID_COMPANY) as items
		LEFT JOIN (select distinct bvpi.id_item from business.view_process_item bvpi where bvpi.id_level = _id_level) as assignedItems
		on items.id_item = assignedItems.id_item where assignedItems.id_item IS NULL order by items.id_item asc limit 1);

	IF (_ID_ITEM >= 1) THEN
		_ID_PROCESS_ITEM = (select * from business.dml_process_item_create(id_user_, _id_official, _id_process, _id_task, _id_level, _ID_ITEM, 1, '', now()::timestamp));
	
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

-- FUNCTION: business.dml_process_item_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, character varying, timestamp without time zone)
-- DROP FUNCTION IF EXISTS business.dml_process_item_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, character varying, timestamp without time zone);

CREATE OR REPLACE FUNCTION business.dml_process_item_update_modified(
	id_user_ numeric,
	_id_process_item numeric,
	_id_official numeric,
	_id_process numeric,
	_id_task numeric,
	_id_level numeric,
	_id_item numeric,
	_amount_process_item numeric,
	_features_process_item character varying,
	_entry_date_process_item timestamp without time zone)
    RETURNS TABLE(id_process_item numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, id_item numeric, amount_process_item numeric, features_process_item character varying, entry_date_process_item timestamp without time zone, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_process_type numeric, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, creation_date_task timestamp without time zone, type_status_task business."TYPE_STATUS_TASK", type_action_task business."TYPE_ACTION_TASK", action_date_task timestamp with time zone, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, id_item_category numeric, name_item character varying, description_item character varying, cpc_item character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
 	_UPDATE_PROCESS_ITEM BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_UPDATE_PROCESS_ITEM = (select * from business.dml_process_item_update(id_user_, _id_process_item, _id_official, _id_process, _id_task, _id_level, _id_item, _amount_process_item, _features_process_item, now()::timestamp));

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

ALTER FUNCTION business.dml_process_item_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, character varying, timestamp without time zone)
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
    RETURNS TABLE(id_process_attached numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, id_attached numeric, file_name character varying, length_mb character varying, extension character varying, server_path character varying, alfresco_path character varying, upload_date timestamp without time zone, deleted_process_attached boolean, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_process_type numeric, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, creation_date_task timestamp without time zone, type_status_task business."TYPE_STATUS_TASK", type_action_task business."TYPE_ACTION_TASK", action_date_task timestamp with time zone, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, name_attached character varying, description_attached character varying, length_mb_attached numeric, required_attached boolean) 
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
    RETURNS TABLE(id_process_attached numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, id_attached numeric, file_name character varying, length_mb character varying, extension character varying, server_path character varying, alfresco_path character varying, upload_date timestamp without time zone, deleted_process_attached boolean, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_process_type numeric, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, creation_date_task timestamp without time zone, type_status_task business."TYPE_STATUS_TASK", type_action_task business."TYPE_ACTION_TASK", action_date_task timestamp with time zone, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, name_attached character varying, description_attached character varying, length_mb_attached numeric, required_attached boolean) 
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
    RETURNS TABLE(id_process_control numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, id_control numeric, value_process_control text, last_change_process_control timestamp without time zone, deleted_process_control boolean, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_process_type numeric, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, creation_date_task timestamp without time zone, type_status_task business."TYPE_STATUS_TASK", type_action_task business."TYPE_ACTION_TASK", action_date_task timestamp with time zone, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, type_control business."TYPE_CONTROL", title_control character varying, form_name_control character varying, initial_value_control character varying, required_control boolean, min_length_control numeric, max_length_control numeric, placeholder_control character varying, spell_check_control boolean, options_control json, in_use boolean) 
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
    RETURNS TABLE(id_process_control numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, id_control numeric, value_process_control text, last_change_process_control timestamp without time zone, deleted_process_control boolean, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_process_type numeric, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, creation_date_task timestamp without time zone, type_status_task business."TYPE_STATUS_TASK", type_action_task business."TYPE_ACTION_TASK", action_date_task timestamp with time zone, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, type_control business."TYPE_CONTROL", title_control character varying, form_name_control character varying, initial_value_control character varying, required_control boolean, min_length_control numeric, max_length_control numeric, placeholder_control character varying, spell_check_control boolean, options_control json, in_use boolean) 
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
    RETURNS TABLE(id_process_comment numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, value_process_comment character varying, date_process_comment timestamp without time zone, deleted_process_comment boolean, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_process_type numeric, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, creation_date_task timestamp without time zone, type_status_task business."TYPE_STATUS_TASK", type_action_task business."TYPE_ACTION_TASK", action_date_task timestamp with time zone, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying) 
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
    RETURNS TABLE(id_process_comment numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, value_process_comment character varying, date_process_comment timestamp without time zone, deleted_process_comment boolean, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_process_type numeric, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, creation_date_task timestamp without time zone, type_status_task business."TYPE_STATUS_TASK", type_action_task business."TYPE_ACTION_TASK", action_date_task timestamp with time zone, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying) 
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