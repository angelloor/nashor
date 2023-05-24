--
-- PostgreSQL database dump
--

-- Dumped from database version 13.7 (Ubuntu 13.7-1.pgdg22.04+1)
-- Dumped by pg_dump version 13.8

-- Started on 2023-05-23 21:57:50

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 20441)
-- Name: business; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA business;


ALTER SCHEMA business OWNER TO postgres;

--
-- TOC entry 4 (class 2615 OID 20417)
-- Name: core; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA core;


ALTER SCHEMA core OWNER TO postgres;

--
-- TOC entry 2 (class 3079 OID 20520)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA core;


--
-- TOC entry 4168 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 1064 (class 1247 OID 20443)
-- Name: TYPE_CONTROL; Type: TYPE; Schema: business; Owner: app_nashor
--

CREATE TYPE business."TYPE_CONTROL" AS ENUM (
    'input',
    'textArea',
    'radioButton',
    'checkBox',
    'select',
    'date',
    'dateRange'
);


ALTER TYPE business."TYPE_CONTROL" OWNER TO app_nashor;

--
-- TOC entry 1070 (class 1247 OID 20468)
-- Name: TYPE_ELEMENT; Type: TYPE; Schema: business; Owner: app_nashor
--

CREATE TYPE business."TYPE_ELEMENT" AS ENUM (
    'level',
    'conditional',
    'finish'
);


ALTER TYPE business."TYPE_ELEMENT" OWNER TO app_nashor;

--
-- TOC entry 1073 (class 1247 OID 20476)
-- Name: TYPE_OPERATOR; Type: TYPE; Schema: business; Owner: app_nashor
--

CREATE TYPE business."TYPE_OPERATOR" AS ENUM (
    '==',
    '!=',
    '<',
    '>',
    '<=',
    '>='
);


ALTER TYPE business."TYPE_OPERATOR" OWNER TO app_nashor;

--
-- TOC entry 1067 (class 1247 OID 20458)
-- Name: TYPE_STATUS_TASK; Type: TYPE; Schema: business; Owner: app_nashor
--

CREATE TYPE business."TYPE_STATUS_TASK" AS ENUM (
    'created',
    'progress',
    'reassigned',
    'dispatched'
);


ALTER TYPE business."TYPE_STATUS_TASK" OWNER TO app_nashor;

--
-- TOC entry 1055 (class 1247 OID 20419)
-- Name: TYPE_NAVIGATION; Type: TYPE; Schema: core; Owner: app_nashor
--

CREATE TYPE core."TYPE_NAVIGATION" AS ENUM (
    'defaultNavigation',
    'compactNavigation',
    'futuristicNavigation',
    'horizontalNavigation'
);


ALTER TYPE core."TYPE_NAVIGATION" OWNER TO app_nashor;

--
-- TOC entry 1061 (class 1247 OID 20436)
-- Name: TYPE_PROFILE; Type: TYPE; Schema: core; Owner: app_nashor
--

CREATE TYPE core."TYPE_PROFILE" AS ENUM (
    'administator',
    'commonProfile'
);


ALTER TYPE core."TYPE_PROFILE" OWNER TO app_nashor;

--
-- TOC entry 1058 (class 1247 OID 20428)
-- Name: TYPE_VALIDATION; Type: TYPE; Schema: core; Owner: app_nashor
--

CREATE TYPE core."TYPE_VALIDATION" AS ENUM (
    'validationPassword',
    'validationDNI',
    'validationPhoneNumber'
);


ALTER TYPE core."TYPE_VALIDATION" OWNER TO app_nashor;

--
-- TOC entry 493 (class 1255 OID 21658)
-- Name: dml_area_create(numeric, numeric, character varying, character varying, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_area_create(id_user_ numeric, _id_company numeric, _name_area character varying, _description_area character varying, _deleted_area boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
			
	_CURRENT_ID = (select nextval('business.serial_area')-1);
	_COUNT = (select count(*) from business.view_area t where t.id_area = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from business.view_area t where t.name_area = _name_area);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO business.area(id_area, id_company, name_area, description_area, deleted_area) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5) RETURNING id_area LOOP
				_RETURNING = _X.id_area;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'area',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el name_area '||_name_area||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla area';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_area'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_area_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_area_create(id_user_ numeric, _id_company numeric, _name_area character varying, _description_area character varying, _deleted_area boolean) OWNER TO app_nashor;

--
-- TOC entry 568 (class 1255 OID 21799)
-- Name: dml_area_create_modified(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_area_create_modified(id_user_ numeric, _id_company numeric) RETURNS TABLE(id_area numeric, id_company numeric, name_area character varying, description_area character varying, deleted_area boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_area_create_modified(id_user_ numeric, _id_company numeric) OWNER TO postgres;

--
-- TOC entry 495 (class 1255 OID 21660)
-- Name: dml_area_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_area_delete(id_user_ numeric, _id_area numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_area t where t.id_area = _id_area);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_area t where t.id_area = _id_area and deleted_area = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','area', _id_area));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE business.area SET deleted_area=true WHERE id_area = _id_area RETURNING id_area LOOP
					_RETURNING = _X.id_area;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'area',_id_area,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_area||' no se encuentra registrado en la tabla area';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_area_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_area_delete(id_user_ numeric, _id_area numeric) OWNER TO app_nashor;

--
-- TOC entry 494 (class 1255 OID 21659)
-- Name: dml_area_update(numeric, numeric, numeric, character varying, character varying, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_area_update(id_user_ numeric, _id_area numeric, _id_company numeric, _name_area character varying, _description_area character varying, _deleted_area boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
			
	_COUNT = (select count(*) from business.view_area t where t.id_area = _id_area);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_area t where t.id_area = _id_area and deleted_area = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from business.view_area t where t.name_area = _name_area and t.id_area != _id_area);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE business.area SET id_company=$3, name_area=$4, description_area=$5, deleted_area=$6 WHERE id_area=$2 RETURNING id_area LOOP
					_RETURNING = _X.id_area;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'area',_id_area,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el name_area '||_name_area||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_area||' no se encuentra registrado en la tabla area';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_area_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_area_update(id_user_ numeric, _id_area numeric, _id_company numeric, _name_area character varying, _description_area character varying, _deleted_area boolean) OWNER TO app_nashor;

--
-- TOC entry 569 (class 1255 OID 21800)
-- Name: dml_area_update_modified(numeric, numeric, numeric, character varying, character varying, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_area_update_modified(id_user_ numeric, _id_area numeric, _id_company numeric, _name_area character varying, _description_area character varying, _deleted_area boolean) RETURNS TABLE(id_area numeric, id_company numeric, name_area character varying, description_area character varying, deleted_area boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_area_update_modified(id_user_ numeric, _id_area numeric, _id_company numeric, _name_area character varying, _description_area character varying, _deleted_area boolean) OWNER TO postgres;

--
-- TOC entry 508 (class 1255 OID 21673)
-- Name: dml_attached_create(numeric, numeric, character varying, character varying, numeric, boolean, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_attached_create(id_user_ numeric, _id_company numeric, _name_attached character varying, _description_attached character varying, _length_mb_attached numeric, _required_attached boolean, _deleted_attached boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
			
	_CURRENT_ID = (select nextval('business.serial_attached')-1);
	_COUNT = (select count(*) from business.view_attached t where t.id_attached = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from business.view_attached t where t.name_attached = _name_attached);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO business.attached(id_attached, id_company, name_attached, description_attached, length_mb_attached, required_attached, deleted_attached) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6 ,$7) RETURNING id_attached LOOP
				_RETURNING = _X.id_attached;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'attached',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el name_attached '||_name_attached||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla attached';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_attached'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_attached_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_attached_create(id_user_ numeric, _id_company numeric, _name_attached character varying, _description_attached character varying, _length_mb_attached numeric, _required_attached boolean, _deleted_attached boolean) OWNER TO app_nashor;

--
-- TOC entry 573 (class 1255 OID 21806)
-- Name: dml_attached_create_modified(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_attached_create_modified(id_user_ numeric, _id_company numeric) RETURNS TABLE(id_attached numeric, id_company numeric, name_attached character varying, description_attached character varying, length_mb_attached numeric, required_attached boolean, deleted_attached boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_attached_create_modified(id_user_ numeric, _id_company numeric) OWNER TO postgres;

--
-- TOC entry 510 (class 1255 OID 21675)
-- Name: dml_attached_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_attached_delete(id_user_ numeric, _id_attached numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_attached t where t.id_attached = _id_attached);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_attached t where t.id_attached = _id_attached and deleted_attached = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','attached', _id_attached));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE business.attached SET deleted_attached=true WHERE id_attached = _id_attached RETURNING id_attached LOOP
					_RETURNING = _X.id_attached;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'attached',_id_attached,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_attached||' no se encuentra registrado en la tabla attached';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_attached_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_attached_delete(id_user_ numeric, _id_attached numeric) OWNER TO app_nashor;

--
-- TOC entry 509 (class 1255 OID 21674)
-- Name: dml_attached_update(numeric, numeric, numeric, character varying, character varying, numeric, boolean, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_attached_update(id_user_ numeric, _id_attached numeric, _id_company numeric, _name_attached character varying, _description_attached character varying, _length_mb_attached numeric, _required_attached boolean, _deleted_attached boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
			
	_COUNT = (select count(*) from business.view_attached t where t.id_attached = _id_attached);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_attached t where t.id_attached = _id_attached and deleted_attached = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from business.view_attached t where t.name_attached = _name_attached and t.id_attached != _id_attached);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE business.attached SET id_company=$3, name_attached=$4, description_attached=$5, length_mb_attached=$6, required_attached=$7, deleted_attached=$8 WHERE id_attached=$2 RETURNING id_attached LOOP
					_RETURNING = _X.id_attached;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'attached',_id_attached,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el name_attached '||_name_attached||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_attached||' no se encuentra registrado en la tabla attached';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_attached_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_attached_update(id_user_ numeric, _id_attached numeric, _id_company numeric, _name_attached character varying, _description_attached character varying, _length_mb_attached numeric, _required_attached boolean, _deleted_attached boolean) OWNER TO app_nashor;

--
-- TOC entry 576 (class 1255 OID 21807)
-- Name: dml_attached_update_modified(numeric, numeric, numeric, character varying, character varying, numeric, boolean, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_attached_update_modified(id_user_ numeric, _id_attached numeric, _id_company numeric, _name_attached character varying, _description_attached character varying, _length_mb_attached numeric, _required_attached boolean, _deleted_attached boolean) RETURNS TABLE(id_attached numeric, id_company numeric, name_attached character varying, description_attached character varying, length_mb_attached numeric, required_attached boolean, deleted_attached boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_attached_update_modified(id_user_ numeric, _id_attached numeric, _id_company numeric, _name_attached character varying, _description_attached character varying, _length_mb_attached numeric, _required_attached boolean, _deleted_attached boolean) OWNER TO postgres;

--
-- TOC entry 565 (class 1255 OID 21733)
-- Name: dml_column_process_item_create(numeric, numeric, numeric, text, timestamp without time zone); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_column_process_item_create(id_user_ numeric, _id_plugin_item_column numeric, _id_process_item numeric, _value_column_process_item text, _entry_date_column_process_item timestamp without time zone) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
	-- plugin_item_column
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_plugin_item_column v where v.id_plugin_item_column = _id_plugin_item_column);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_plugin_item_column||' de la tabla plugin_item_column no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- process_item
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_process_item v where v.id_process_item = _id_process_item);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_process_item||' de la tabla process_item no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_CURRENT_ID = (select nextval('business.serial_column_process_item')-1);
	_COUNT = (select count(*) from business.view_column_process_item t where t.id_column_process_item = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		FOR _X IN INSERT INTO business.column_process_item(id_column_process_item, id_plugin_item_column, id_process_item, value_column_process_item, entry_date_column_process_item) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5) RETURNING id_column_process_item LOOP
			_RETURNING = _X.id_column_process_item;
		END LOOP;
		
		IF (_RETURNING >= 1) THEN
			_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
				where cvuij.id_user = id_user_);
			
			IF (_SAVE_LOG) THEN
				_RESPONSE = (select * from core.dml_system_event_create(id_user_,'column_process_item',_CURRENT_ID,'CREATE', now()::timestamp, false));
				
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
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla column_process_item';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_column_process_item'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_column_process_item_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_column_process_item_create(id_user_ numeric, _id_plugin_item_column numeric, _id_process_item numeric, _value_column_process_item text, _entry_date_column_process_item timestamp without time zone) OWNER TO app_nashor;

--
-- TOC entry 635 (class 1255 OID 21870)
-- Name: dml_column_process_item_create_modified(numeric, numeric, numeric, character varying); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_column_process_item_create_modified(id_user_ numeric, _id_plugin_item_column numeric, _id_process_item numeric, _value_column_process_item character varying) RETURNS TABLE(id_column_process_item numeric, id_plugin_item_column numeric, id_process_item numeric, value_column_process_item text, entry_date_column_process_item timestamp without time zone, id_plugin_item numeric, name_plugin_item_column character varying, lenght_plugin_item_column numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, id_item numeric)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_column_process_item_create_modified(id_user_ numeric, _id_plugin_item_column numeric, _id_process_item numeric, _value_column_process_item character varying) OWNER TO postgres;

--
-- TOC entry 567 (class 1255 OID 21735)
-- Name: dml_column_process_item_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_column_process_item_delete(id_user_ numeric, _id_column_process_item numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_column_process_item t where t.id_column_process_item = _id_column_process_item);
		
	IF (_COUNT = 1) THEN
		_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','column_process_item', _id_column_process_item));
			
		IF (_COUNT_DEPENDENCY > 0) THEN
			_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		ELSE
			FOR _X IN DELETE FROM business.column_process_item WHERE id_column_process_item = _id_column_process_item RETURNING id_column_process_item LOOP
				_RETURNING = _X.id_column_process_item;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'column_process_item',_id_column_process_item,'DELETE', now()::timestamp, false));
					
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
		_EXCEPTION = 'El registro con id '||_id_column_process_item||' no se encuentra registrado en la tabla column_process_item';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_column_process_item_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_column_process_item_delete(id_user_ numeric, _id_column_process_item numeric) OWNER TO app_nashor;

--
-- TOC entry 566 (class 1255 OID 21734)
-- Name: dml_column_process_item_update(numeric, numeric, numeric, numeric, text, timestamp without time zone); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_column_process_item_update(id_user_ numeric, _id_column_process_item numeric, _id_plugin_item_column numeric, _id_process_item numeric, _value_column_process_item text, _entry_date_column_process_item timestamp without time zone) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_EXTERNALS_IDS NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN 
	-- plugin_item_column
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_plugin_item_column v where v.id_plugin_item_column = _id_plugin_item_column);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_plugin_item_column||' de la tabla plugin_item_column no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- process_item
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_process_item v where v.id_process_item = _id_process_item);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_process_item||' de la tabla process_item no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
 	_COUNT = (select count(*) from business.view_column_process_item t where t.id_column_process_item = _id_column_process_item);

	IF (_COUNT = 1) THEN
		FOR _X IN UPDATE business.column_process_item SET id_plugin_item_column=$3, id_process_item=$4, value_column_process_item=$5, entry_date_column_process_item=$6 WHERE id_column_process_item=$2 RETURNING id_column_process_item LOOP
			_RETURNING = _X.id_column_process_item;
		END LOOP;
			
		IF (_RETURNING >= 1) THEN
			_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
				where cvuij.id_user = id_user_);

			IF (_SAVE_LOG) THEN
				_RESPONSE = (select * from core.dml_system_event_create(id_user_,'column_process_item',_id_column_process_item,'UPDATE', now()::timestamp, false));
				
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
		_EXCEPTION = 'El registro con id '||_id_column_process_item||' no se encuentra registrado en la tabla column_process_item';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_column_process_item_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_column_process_item_update(id_user_ numeric, _id_column_process_item numeric, _id_plugin_item_column numeric, _id_process_item numeric, _value_column_process_item text, _entry_date_column_process_item timestamp without time zone) OWNER TO app_nashor;

--
-- TOC entry 636 (class 1255 OID 21871)
-- Name: dml_column_process_item_update_modified(numeric, numeric, numeric, numeric, text, timestamp without time zone); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_column_process_item_update_modified(id_user_ numeric, _id_column_process_item numeric, _id_plugin_item_column numeric, _id_process_item numeric, _value_column_process_item text, _entry_date_column_process_item timestamp without time zone) RETURNS TABLE(id_column_process_item numeric, id_plugin_item_column numeric, id_process_item numeric, value_column_process_item text, entry_date_column_process_item timestamp without time zone, id_plugin_item numeric, name_plugin_item_column character varying, lenght_plugin_item_column numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, id_item numeric)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_column_process_item_update_modified(id_user_ numeric, _id_column_process_item numeric, _id_plugin_item_column numeric, _id_process_item numeric, _value_column_process_item text, _entry_date_column_process_item timestamp without time zone) OWNER TO postgres;

--
-- TOC entry 590 (class 1255 OID 21822)
-- Name: dml_control_by_position_level(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_control_by_position_level(id_user_ numeric, _position_level numeric) RETURNS TABLE(id_control numeric, id_company numeric, type_control business."TYPE_CONTROL", title_control character varying, form_name_control character varying, initial_value_control character varying, required_control boolean, min_length_control numeric, max_length_control numeric, placeholder_control character varying, spell_check_control boolean, options_control json, in_use boolean, deleted_control boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_control_by_position_level(id_user_ numeric, _position_level numeric) OWNER TO postgres;

--
-- TOC entry 505 (class 1255 OID 21670)
-- Name: dml_control_create(numeric, numeric, business."TYPE_CONTROL", character varying, character varying, character varying, boolean, numeric, numeric, character varying, boolean, json, boolean, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_control_create(id_user_ numeric, _id_company numeric, _type_control business."TYPE_CONTROL", _title_control character varying, _form_name_control character varying, _initial_value_control character varying, _required_control boolean, _min_length_control numeric, _max_length_control numeric, _placeholder_control character varying, _spell_check_control boolean, _options_control json, _in_use boolean, _deleted_control boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
		_COUNT_ATT = (select count(*) from business.view_control t where t.form_name_control = _form_name_control);
	
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
END;$_$;


ALTER FUNCTION business.dml_control_create(id_user_ numeric, _id_company numeric, _type_control business."TYPE_CONTROL", _title_control character varying, _form_name_control character varying, _initial_value_control character varying, _required_control boolean, _min_length_control numeric, _max_length_control numeric, _placeholder_control character varying, _spell_check_control boolean, _options_control json, _in_use boolean, _deleted_control boolean) OWNER TO app_nashor;

--
-- TOC entry 586 (class 1255 OID 21817)
-- Name: dml_control_create(numeric, numeric, business."TYPE_CONTROL", character varying, character varying, character varying, boolean, numeric, numeric, character varying, boolean, json, boolean, boolean, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_control_create(id_user_ numeric, _id_company numeric, _type_control business."TYPE_CONTROL", _title_control character varying, _form_name_control character varying, _initial_value_control character varying, _required_control boolean, _min_length_control numeric, _max_length_control numeric, _placeholder_control character varying, _spell_check_control boolean, _options_control json, _in_use boolean, _deleted_control boolean, _id_template numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
$_$;


ALTER FUNCTION business.dml_control_create(id_user_ numeric, _id_company numeric, _type_control business."TYPE_CONTROL", _title_control character varying, _form_name_control character varying, _initial_value_control character varying, _required_control boolean, _min_length_control numeric, _max_length_control numeric, _placeholder_control character varying, _spell_check_control boolean, _options_control json, _in_use boolean, _deleted_control boolean, _id_template numeric) OWNER TO postgres;

--
-- TOC entry 587 (class 1255 OID 21818)
-- Name: dml_control_create_modified(numeric, numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_control_create_modified(id_user_ numeric, _id_company numeric, _id_template numeric) RETURNS TABLE(id_control numeric, id_company numeric, type_control business."TYPE_CONTROL", title_control character varying, form_name_control character varying, initial_value_control character varying, required_control boolean, min_length_control numeric, max_length_control numeric, placeholder_control character varying, spell_check_control boolean, options_control json, in_use boolean, deleted_control boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_control_create_modified(id_user_ numeric, _id_company numeric, _id_template numeric) OWNER TO postgres;

--
-- TOC entry 507 (class 1255 OID 21672)
-- Name: dml_control_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_control_delete(id_user_ numeric, _id_control numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_control t where t.id_control = _id_control);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_control t where t.id_control = _id_control and deleted_control = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','control', _id_control));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE business.control SET deleted_control=true WHERE id_control = _id_control RETURNING id_control LOOP
					_RETURNING = _X.id_control;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'control',_id_control,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_control||' no se encuentra registrado en la tabla control';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_control_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_control_delete(id_user_ numeric, _id_control numeric) OWNER TO app_nashor;

--
-- TOC entry 424 (class 1255 OID 21821)
-- Name: dml_control_delete_cascade(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_control_delete_cascade(id_user_ numeric, _id_control numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
			 
$$;


ALTER FUNCTION business.dml_control_delete_cascade(id_user_ numeric, _id_control numeric) OWNER TO postgres;

--
-- TOC entry 506 (class 1255 OID 21671)
-- Name: dml_control_update(numeric, numeric, numeric, business."TYPE_CONTROL", character varying, character varying, character varying, boolean, numeric, numeric, character varying, boolean, json, boolean, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_control_update(id_user_ numeric, _id_control numeric, _id_company numeric, _type_control business."TYPE_CONTROL", _title_control character varying, _form_name_control character varying, _initial_value_control character varying, _required_control boolean, _min_length_control numeric, _max_length_control numeric, _placeholder_control character varying, _spell_check_control boolean, _options_control json, _in_use boolean, _deleted_control boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
			_COUNT_ATT = (select count(*) from business.view_control t where t.form_name_control = _form_name_control and t.id_control != _id_control);
			
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
END;$_$;


ALTER FUNCTION business.dml_control_update(id_user_ numeric, _id_control numeric, _id_company numeric, _type_control business."TYPE_CONTROL", _title_control character varying, _form_name_control character varying, _initial_value_control character varying, _required_control boolean, _min_length_control numeric, _max_length_control numeric, _placeholder_control character varying, _spell_check_control boolean, _options_control json, _in_use boolean, _deleted_control boolean) OWNER TO app_nashor;

--
-- TOC entry 588 (class 1255 OID 21819)
-- Name: dml_control_update(numeric, numeric, numeric, business."TYPE_CONTROL", character varying, character varying, character varying, boolean, numeric, numeric, character varying, boolean, json, boolean, boolean, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_control_update(id_user_ numeric, _id_control numeric, _id_company numeric, _type_control business."TYPE_CONTROL", _title_control character varying, _form_name_control character varying, _initial_value_control character varying, _required_control boolean, _min_length_control numeric, _max_length_control numeric, _placeholder_control character varying, _spell_check_control boolean, _options_control json, _in_use boolean, _deleted_control boolean, _id_template numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
$_$;


ALTER FUNCTION business.dml_control_update(id_user_ numeric, _id_control numeric, _id_company numeric, _type_control business."TYPE_CONTROL", _title_control character varying, _form_name_control character varying, _initial_value_control character varying, _required_control boolean, _min_length_control numeric, _max_length_control numeric, _placeholder_control character varying, _spell_check_control boolean, _options_control json, _in_use boolean, _deleted_control boolean, _id_template numeric) OWNER TO postgres;

--
-- TOC entry 599 (class 1255 OID 21833)
-- Name: dml_control_update_in_use(numeric, numeric, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_control_update_in_use(id_user_ numeric, _id_control numeric, _in_use boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
			 
$$;


ALTER FUNCTION business.dml_control_update_in_use(id_user_ numeric, _id_control numeric, _in_use boolean) OWNER TO postgres;

--
-- TOC entry 589 (class 1255 OID 21820)
-- Name: dml_control_update_modified(numeric, numeric, numeric, business."TYPE_CONTROL", character varying, character varying, character varying, boolean, numeric, numeric, character varying, boolean, json, boolean, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_control_update_modified(id_user_ numeric, _id_control numeric, _id_company numeric, _type_control business."TYPE_CONTROL", _title_control character varying, _form_name_control character varying, _initial_value_control character varying, _required_control boolean, _min_length_control numeric, _max_length_control numeric, _placeholder_control character varying, _spell_check_control boolean, _options_control json, _in_use boolean, _deleted_control boolean) RETURNS TABLE(id_control numeric, id_company numeric, type_control business."TYPE_CONTROL", title_control character varying, form_name_control character varying, initial_value_control character varying, required_control boolean, min_length_control numeric, max_length_control numeric, placeholder_control character varying, spell_check_control boolean, options_control json, in_use boolean, deleted_control boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_control_update_modified(id_user_ numeric, _id_control numeric, _id_company numeric, _type_control business."TYPE_CONTROL", _title_control character varying, _form_name_control character varying, _initial_value_control character varying, _required_control boolean, _min_length_control numeric, _max_length_control numeric, _placeholder_control character varying, _spell_check_control boolean, _options_control json, _in_use boolean, _deleted_control boolean) OWNER TO postgres;

--
-- TOC entry 541 (class 1255 OID 21706)
-- Name: dml_documentation_profile_attached_create(numeric, numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_documentation_profile_attached_create(id_user_ numeric, _id_documentation_profile numeric, _id_attached numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
	-- documentation_profile
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_documentation_profile v where v.id_documentation_profile = _id_documentation_profile);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_documentation_profile||' de la tabla documentation_profile no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- attached
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_attached v where v.id_attached = _id_attached);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_attached||' de la tabla attached no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_CURRENT_ID = (select nextval('business.serial_documentation_profile_attached')-1);
	_COUNT = (select count(*) from business.view_documentation_profile_attached t where t.id_documentation_profile_attached = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		FOR _X IN INSERT INTO business.documentation_profile_attached(id_documentation_profile_attached, id_documentation_profile, id_attached) VALUES (_CURRENT_ID, $2 ,$3) RETURNING id_documentation_profile_attached LOOP
			_RETURNING = _X.id_documentation_profile_attached;
		END LOOP;
		
		IF (_RETURNING >= 1) THEN
			_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
				where cvuij.id_user = id_user_);
			
			IF (_SAVE_LOG) THEN
				_RESPONSE = (select * from core.dml_system_event_create(id_user_,'documentation_profile_attached',_CURRENT_ID,'CREATE', now()::timestamp, false));
				
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
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla documentation_profile_attached';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_documentation_profile_attached'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_documentation_profile_attached_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_documentation_profile_attached_create(id_user_ numeric, _id_documentation_profile numeric, _id_attached numeric) OWNER TO app_nashor;

--
-- TOC entry 578 (class 1255 OID 21811)
-- Name: dml_documentation_profile_attached_create_modified(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_documentation_profile_attached_create_modified(id_user_ numeric, _id_documentation_profile numeric) RETURNS TABLE(id_documentation_profile_attached numeric, id_documentation_profile numeric, id_attached numeric, name_documentation_profile character varying, description_documentation_profile character varying, status_documentation_profile boolean, name_attached character varying, description_attached character varying, length_mb_attached numeric, required_attached boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_documentation_profile_attached_create_modified(id_user_ numeric, _id_documentation_profile numeric) OWNER TO postgres;

--
-- TOC entry 543 (class 1255 OID 21708)
-- Name: dml_documentation_profile_attached_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_documentation_profile_attached_delete(id_user_ numeric, _id_documentation_profile_attached numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_documentation_profile_attached t where t.id_documentation_profile_attached = _id_documentation_profile_attached);
		
	IF (_COUNT = 1) THEN
		_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','documentation_profile_attached', _id_documentation_profile_attached));
			
		IF (_COUNT_DEPENDENCY > 0) THEN
			_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		ELSE
			FOR _X IN DELETE FROM business.documentation_profile_attached WHERE id_documentation_profile_attached = _id_documentation_profile_attached RETURNING id_documentation_profile_attached LOOP
				_RETURNING = _X.id_documentation_profile_attached;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'documentation_profile_attached',_id_documentation_profile_attached,'DELETE', now()::timestamp, false));
					
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
		_EXCEPTION = 'El registro con id '||_id_documentation_profile_attached||' no se encuentra registrado en la tabla documentation_profile_attached';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_documentation_profile_attached_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_documentation_profile_attached_delete(id_user_ numeric, _id_documentation_profile_attached numeric) OWNER TO app_nashor;

--
-- TOC entry 542 (class 1255 OID 21707)
-- Name: dml_documentation_profile_attached_update(numeric, numeric, numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_documentation_profile_attached_update(id_user_ numeric, _id_documentation_profile_attached numeric, _id_documentation_profile numeric, _id_attached numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_EXTERNALS_IDS NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN 
	-- documentation_profile
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_documentation_profile v where v.id_documentation_profile = _id_documentation_profile);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_documentation_profile||' de la tabla documentation_profile no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- attached
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_attached v where v.id_attached = _id_attached);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_attached||' de la tabla attached no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
 	_COUNT = (select count(*) from business.view_documentation_profile_attached t where t.id_documentation_profile_attached = _id_documentation_profile_attached);

	IF (_COUNT = 1) THEN
		FOR _X IN UPDATE business.documentation_profile_attached SET id_documentation_profile=$3, id_attached=$4 WHERE id_documentation_profile_attached=$2 RETURNING id_documentation_profile_attached LOOP
			_RETURNING = _X.id_documentation_profile_attached;
		END LOOP;
			
		IF (_RETURNING >= 1) THEN
			_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
				where cvuij.id_user = id_user_);

			IF (_SAVE_LOG) THEN
				_RESPONSE = (select * from core.dml_system_event_create(id_user_,'documentation_profile_attached',_id_documentation_profile_attached,'UPDATE', now()::timestamp, false));
				
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
		_EXCEPTION = 'El registro con id '||_id_documentation_profile_attached||' no se encuentra registrado en la tabla documentation_profile_attached';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_documentation_profile_attached_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_documentation_profile_attached_update(id_user_ numeric, _id_documentation_profile_attached numeric, _id_documentation_profile numeric, _id_attached numeric) OWNER TO app_nashor;

--
-- TOC entry 581 (class 1255 OID 21812)
-- Name: dml_documentation_profile_attached_update_modified(numeric, numeric, numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_documentation_profile_attached_update_modified(id_user_ numeric, _id_documentation_profile_attached numeric, _id_documentation_profile numeric, _id_attached numeric) RETURNS TABLE(id_documentation_profile_attached numeric, id_documentation_profile numeric, id_attached numeric, name_documentation_profile character varying, description_documentation_profile character varying, status_documentation_profile boolean, name_attached character varying, description_attached character varying, length_mb_attached numeric, required_attached boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_documentation_profile_attached_update_modified(id_user_ numeric, _id_documentation_profile_attached numeric, _id_documentation_profile numeric, _id_attached numeric) OWNER TO postgres;

--
-- TOC entry 511 (class 1255 OID 21676)
-- Name: dml_documentation_profile_create(numeric, numeric, character varying, character varying, boolean, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_documentation_profile_create(id_user_ numeric, _id_company numeric, _name_documentation_profile character varying, _description_documentation_profile character varying, _status_documentation_profile boolean, _deleted_documentation_profile boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
			
	_CURRENT_ID = (select nextval('business.serial_documentation_profile')-1);
	_COUNT = (select count(*) from business.view_documentation_profile t where t.id_documentation_profile = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from business.view_documentation_profile t where t.name_documentation_profile = _name_documentation_profile);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO business.documentation_profile(id_documentation_profile, id_company, name_documentation_profile, description_documentation_profile, status_documentation_profile, deleted_documentation_profile) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6) RETURNING id_documentation_profile LOOP
				_RETURNING = _X.id_documentation_profile;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'documentation_profile',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el name_documentation_profile '||_name_documentation_profile||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla documentation_profile';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_documentation_profile'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_documentation_profile_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_documentation_profile_create(id_user_ numeric, _id_company numeric, _name_documentation_profile character varying, _description_documentation_profile character varying, _status_documentation_profile boolean, _deleted_documentation_profile boolean) OWNER TO app_nashor;

--
-- TOC entry 577 (class 1255 OID 21808)
-- Name: dml_documentation_profile_create_modified(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_documentation_profile_create_modified(id_user_ numeric, _id_company numeric) RETURNS TABLE(id_documentation_profile numeric, id_company numeric, name_documentation_profile character varying, description_documentation_profile character varying, status_documentation_profile boolean, deleted_documentation_profile boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_documentation_profile_create_modified(id_user_ numeric, _id_company numeric) OWNER TO postgres;

--
-- TOC entry 513 (class 1255 OID 21678)
-- Name: dml_documentation_profile_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_documentation_profile_delete(id_user_ numeric, _id_documentation_profile numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_documentation_profile t where t.id_documentation_profile = _id_documentation_profile);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_documentation_profile t where t.id_documentation_profile = _id_documentation_profile and deleted_documentation_profile = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','documentation_profile', _id_documentation_profile));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE business.documentation_profile SET deleted_documentation_profile=true WHERE id_documentation_profile = _id_documentation_profile RETURNING id_documentation_profile LOOP
					_RETURNING = _X.id_documentation_profile;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'documentation_profile',_id_documentation_profile,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_documentation_profile||' no se encuentra registrado en la tabla documentation_profile';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_documentation_profile_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_documentation_profile_delete(id_user_ numeric, _id_documentation_profile numeric) OWNER TO app_nashor;

--
-- TOC entry 580 (class 1255 OID 21810)
-- Name: dml_documentation_profile_delete_modified(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_documentation_profile_delete_modified(id_user_ numeric, _id_documentation_profile numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_documentation_profile_delete_modified(id_user_ numeric, _id_documentation_profile numeric) OWNER TO postgres;

--
-- TOC entry 512 (class 1255 OID 21677)
-- Name: dml_documentation_profile_update(numeric, numeric, numeric, character varying, character varying, boolean, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_documentation_profile_update(id_user_ numeric, _id_documentation_profile numeric, _id_company numeric, _name_documentation_profile character varying, _description_documentation_profile character varying, _status_documentation_profile boolean, _deleted_documentation_profile boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
			
	_COUNT = (select count(*) from business.view_documentation_profile t where t.id_documentation_profile = _id_documentation_profile);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_documentation_profile t where t.id_documentation_profile = _id_documentation_profile and deleted_documentation_profile = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from business.view_documentation_profile t where t.name_documentation_profile = _name_documentation_profile and t.id_documentation_profile != _id_documentation_profile);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE business.documentation_profile SET id_company=$3, name_documentation_profile=$4, description_documentation_profile=$5, status_documentation_profile=$6, deleted_documentation_profile=$7 WHERE id_documentation_profile=$2 RETURNING id_documentation_profile LOOP
					_RETURNING = _X.id_documentation_profile;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'documentation_profile',_id_documentation_profile,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el name_documentation_profile '||_name_documentation_profile||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_documentation_profile||' no se encuentra registrado en la tabla documentation_profile';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_documentation_profile_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_documentation_profile_update(id_user_ numeric, _id_documentation_profile numeric, _id_company numeric, _name_documentation_profile character varying, _description_documentation_profile character varying, _status_documentation_profile boolean, _deleted_documentation_profile boolean) OWNER TO app_nashor;

--
-- TOC entry 579 (class 1255 OID 21809)
-- Name: dml_documentation_profile_update_modified(numeric, numeric, numeric, character varying, character varying, boolean, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_documentation_profile_update_modified(id_user_ numeric, _id_documentation_profile numeric, _id_company numeric, _name_documentation_profile character varying, _description_documentation_profile character varying, _status_documentation_profile boolean, _deleted_documentation_profile boolean) RETURNS TABLE(id_documentation_profile numeric, id_company numeric, name_documentation_profile character varying, description_documentation_profile character varying, status_documentation_profile boolean, deleted_documentation_profile boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_documentation_profile_update_modified(id_user_ numeric, _id_documentation_profile numeric, _id_company numeric, _name_documentation_profile character varying, _description_documentation_profile character varying, _status_documentation_profile boolean, _deleted_documentation_profile boolean) OWNER TO postgres;

--
-- TOC entry 517 (class 1255 OID 21682)
-- Name: dml_flow_create(numeric, numeric, character varying, character varying, character varying, character varying, numeric, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_flow_create(id_user_ numeric, _id_company numeric, _name_flow character varying, _description_flow character varying, _acronym_flow character varying, _acronym_task character varying, _sequential_flow numeric, _deleted_flow boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
			
	_CURRENT_ID = (select nextval('business.serial_flow')-1);
	_COUNT = (select count(*) from business.view_flow t where t.id_flow = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from business.view_flow t where t.name_flow = _name_flow);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO business.flow(id_flow, id_company, name_flow, description_flow, acronym_flow, acronym_task, sequential_flow, deleted_flow) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6 ,$7 ,$8) RETURNING id_flow LOOP
				_RETURNING = _X.id_flow;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'flow',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el name_flow '||_name_flow||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla flow';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_flow'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_flow_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_flow_create(id_user_ numeric, _id_company numeric, _name_flow character varying, _description_flow character varying, _acronym_flow character varying, _acronym_task character varying, _sequential_flow numeric, _deleted_flow boolean) OWNER TO app_nashor;

--
-- TOC entry 604 (class 1255 OID 21838)
-- Name: dml_flow_create_modified(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_flow_create_modified(id_user_ numeric, _id_company numeric) RETURNS TABLE(id_flow numeric, id_company numeric, name_flow character varying, description_flow character varying, acronym_flow character varying, acronym_task character varying, sequential_flow numeric, deleted_flow boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_flow_create_modified(id_user_ numeric, _id_company numeric) OWNER TO postgres;

--
-- TOC entry 519 (class 1255 OID 21684)
-- Name: dml_flow_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_flow_delete(id_user_ numeric, _id_flow numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_flow t where t.id_flow = _id_flow);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_flow t where t.id_flow = _id_flow and deleted_flow = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','flow', _id_flow));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE business.flow SET deleted_flow=true WHERE id_flow = _id_flow RETURNING id_flow LOOP
					_RETURNING = _X.id_flow;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'flow',_id_flow,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_flow||' no se encuentra registrado en la tabla flow';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_flow_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_flow_delete(id_user_ numeric, _id_flow numeric) OWNER TO app_nashor;

--
-- TOC entry 607 (class 1255 OID 21841)
-- Name: dml_flow_delete_modified(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_flow_delete_modified(id_user_ numeric, _id_flow numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_flow_delete_modified(id_user_ numeric, _id_flow numeric) OWNER TO postgres;

--
-- TOC entry 518 (class 1255 OID 21683)
-- Name: dml_flow_update(numeric, numeric, numeric, character varying, character varying, character varying, character varying, numeric, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_flow_update(id_user_ numeric, _id_flow numeric, _id_company numeric, _name_flow character varying, _description_flow character varying, _acronym_flow character varying, _acronym_task character varying, _sequential_flow numeric, _deleted_flow boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
			
	_COUNT = (select count(*) from business.view_flow t where t.id_flow = _id_flow);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_flow t where t.id_flow = _id_flow and deleted_flow = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from business.view_flow t where t.name_flow = _name_flow and t.id_flow != _id_flow);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE business.flow SET id_company=$3, name_flow=$4, description_flow=$5, acronym_flow=$6, acronym_task=$7, sequential_flow=$8, deleted_flow=$9 WHERE id_flow=$2 RETURNING id_flow LOOP
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
				_EXCEPTION = 'Ya existe un registro con el name_flow '||_name_flow||'';
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
END;$_$;


ALTER FUNCTION business.dml_flow_update(id_user_ numeric, _id_flow numeric, _id_company numeric, _name_flow character varying, _description_flow character varying, _acronym_flow character varying, _acronym_task character varying, _sequential_flow numeric, _deleted_flow boolean) OWNER TO app_nashor;

--
-- TOC entry 605 (class 1255 OID 21839)
-- Name: dml_flow_update_modified(numeric, numeric, numeric, character varying, character varying, character varying, character varying, numeric, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_flow_update_modified(id_user_ numeric, _id_flow numeric, _id_company numeric, _name_flow character varying, _description_flow character varying, _acronym_flow character varying, _acronym_task character varying, _sequential_flow numeric, _deleted_flow boolean) RETURNS TABLE(id_flow numeric, id_company numeric, name_flow character varying, description_flow character varying, acronym_flow character varying, acronym_task character varying, sequential_flow numeric, deleted_flow boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_flow_update_modified(id_user_ numeric, _id_flow numeric, _id_company numeric, _name_flow character varying, _description_flow character varying, _acronym_flow character varying, _acronym_task character varying, _sequential_flow numeric, _deleted_flow boolean) OWNER TO postgres;

--
-- TOC entry 606 (class 1255 OID 21840)
-- Name: dml_flow_update_sequential(numeric, numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_flow_update_sequential(id_user_ numeric, _id_flow numeric, _sequential_flow numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_flow_update_sequential(id_user_ numeric, _id_flow numeric, _sequential_flow numeric) OWNER TO postgres;

--
-- TOC entry 544 (class 1255 OID 21709)
-- Name: dml_flow_version_create(numeric, numeric, numeric, boolean, timestamp without time zone, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_flow_version_create(id_user_ numeric, _id_flow numeric, _number_flow_version numeric, _status_flow_version boolean, _creation_date_flow_version timestamp without time zone, _deleted_flow_version boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
	-- flow
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_flow v where v.id_flow = _id_flow);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_flow||' de la tabla flow no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_CURRENT_ID = (select nextval('business.serial_flow_version')-1);
	_COUNT = (select count(*) from business.view_flow_version t where t.id_flow_version = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from business.view_flow_version t where t.id_flow_version = _CURRENT_ID);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO business.flow_version(id_flow_version, id_flow, number_flow_version, status_flow_version, creation_date_flow_version, deleted_flow_version) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6) RETURNING id_flow_version LOOP
				_RETURNING = _X.id_flow_version;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'flow_version',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el id_flow_version '||_id_flow_version||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla flow_version';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_flow_version'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_flow_version_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_flow_version_create(id_user_ numeric, _id_flow numeric, _number_flow_version numeric, _status_flow_version boolean, _creation_date_flow_version timestamp without time zone, _deleted_flow_version boolean) OWNER TO app_nashor;

--
-- TOC entry 617 (class 1255 OID 21851)
-- Name: dml_flow_version_create_modified(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_flow_version_create_modified(id_user_ numeric, _id_flow numeric) RETURNS TABLE(id_flow_version numeric, id_flow numeric, number_flow_version numeric, status_flow_version boolean, creation_date_flow_version timestamp without time zone, deleted_flow_version boolean, id_company numeric, name_flow character varying, description_flow character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_flow_version_create_modified(id_user_ numeric, _id_flow numeric) OWNER TO postgres;

--
-- TOC entry 546 (class 1255 OID 21711)
-- Name: dml_flow_version_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_flow_version_delete(id_user_ numeric, _id_flow_version numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_flow_version t where t.id_flow_version = _id_flow_version);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_flow_version t where t.id_flow_version = _id_flow_version and deleted_flow_version = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','flow_version', _id_flow_version));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE business.flow_version SET deleted_flow_version=true WHERE id_flow_version = _id_flow_version RETURNING id_flow_version LOOP
					_RETURNING = _X.id_flow_version;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'flow_version',_id_flow_version,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_flow_version||' no se encuentra registrado en la tabla flow_version';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_flow_version_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_flow_version_delete(id_user_ numeric, _id_flow_version numeric) OWNER TO app_nashor;

--
-- TOC entry 619 (class 1255 OID 21712)
-- Name: dml_flow_version_level_create(numeric, numeric, numeric, numeric, numeric, business."TYPE_ELEMENT", character varying, business."TYPE_OPERATOR", character varying, boolean, numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_flow_version_level_create(id_user_ numeric, _id_flow_version numeric, _id_level numeric, _position_level numeric, _position_level_father numeric, _type_element business."TYPE_ELEMENT", _id_control character varying, _operator business."TYPE_OPERATOR", _value_against character varying, _option_true boolean, _x numeric, _y numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
$_$;


ALTER FUNCTION business.dml_flow_version_level_create(id_user_ numeric, _id_flow_version numeric, _id_level numeric, _position_level numeric, _position_level_father numeric, _type_element business."TYPE_ELEMENT", _id_control character varying, _operator business."TYPE_OPERATOR", _value_against character varying, _option_true boolean, _x numeric, _y numeric) OWNER TO postgres;

--
-- TOC entry 620 (class 1255 OID 21853)
-- Name: dml_flow_version_level_create_modified(numeric, numeric, business."TYPE_ELEMENT"); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_flow_version_level_create_modified(id_user_ numeric, _id_flow_version numeric, _type_element business."TYPE_ELEMENT") RETURNS TABLE(id_flow_version_level numeric, id_flow_version numeric, id_level numeric, position_level numeric, position_level_father numeric, type_element business."TYPE_ELEMENT", id_control character varying, operator business."TYPE_OPERATOR", value_against character varying, option_true boolean, x numeric, y numeric, id_flow numeric, number_flow_version numeric, status_flow_version boolean, creation_date_flow_version timestamp without time zone, id_company numeric, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_flow_version_level_create_modified(id_user_ numeric, _id_flow_version numeric, _type_element business."TYPE_ELEMENT") OWNER TO postgres;

--
-- TOC entry 547 (class 1255 OID 21714)
-- Name: dml_flow_version_level_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_flow_version_level_delete(id_user_ numeric, _id_flow_version_level numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_flow_version_level t where t.id_flow_version_level = _id_flow_version_level);
		
	IF (_COUNT = 1) THEN
		_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','flow_version_level', _id_flow_version_level));
			
		IF (_COUNT_DEPENDENCY > 0) THEN
			_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		ELSE
			FOR _X IN DELETE FROM business.flow_version_level WHERE id_flow_version_level = _id_flow_version_level RETURNING id_flow_version_level LOOP
				_RETURNING = _X.id_flow_version_level;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'flow_version_level',_id_flow_version_level,'DELETE', now()::timestamp, false));
					
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
		_EXCEPTION = 'El registro con id '||_id_flow_version_level||' no se encuentra registrado en la tabla flow_version_level';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_flow_version_level_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_flow_version_level_delete(id_user_ numeric, _id_flow_version_level numeric) OWNER TO app_nashor;

--
-- TOC entry 623 (class 1255 OID 21855)
-- Name: dml_flow_version_level_reset(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_flow_version_level_reset(id_usuario_ numeric, _id_flow_version numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
			 
$$;


ALTER FUNCTION business.dml_flow_version_level_reset(id_usuario_ numeric, _id_flow_version numeric) OWNER TO postgres;

--
-- TOC entry 621 (class 1255 OID 21713)
-- Name: dml_flow_version_level_update(numeric, numeric, numeric, numeric, numeric, numeric, business."TYPE_ELEMENT", character varying, business."TYPE_OPERATOR", character varying, boolean, numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_flow_version_level_update(id_user_ numeric, _id_flow_version_level numeric, _id_flow_version numeric, _id_level numeric, _position_level numeric, _position_level_father numeric, _type_element business."TYPE_ELEMENT", _id_control character varying, _operator business."TYPE_OPERATOR", _value_against character varying, _option_true boolean, _x numeric, _y numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
$_$;


ALTER FUNCTION business.dml_flow_version_level_update(id_user_ numeric, _id_flow_version_level numeric, _id_flow_version numeric, _id_level numeric, _position_level numeric, _position_level_father numeric, _type_element business."TYPE_ELEMENT", _id_control character varying, _operator business."TYPE_OPERATOR", _value_against character varying, _option_true boolean, _x numeric, _y numeric) OWNER TO postgres;

--
-- TOC entry 622 (class 1255 OID 21854)
-- Name: dml_flow_version_level_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, business."TYPE_ELEMENT", character varying, business."TYPE_OPERATOR", character varying, boolean, numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_flow_version_level_update_modified(id_user_ numeric, _id_flow_version_level numeric, _id_flow_version numeric, _id_level numeric, _position_level numeric, _position_level_father numeric, _type_element business."TYPE_ELEMENT", _name_control character varying, _operator business."TYPE_OPERATOR", _value_against character varying, _option_true boolean, _x numeric, _y numeric) RETURNS TABLE(id_flow_version_level numeric, id_flow_version numeric, id_level numeric, position_level numeric, position_level_father numeric, type_element business."TYPE_ELEMENT", id_control character varying, operator business."TYPE_OPERATOR", value_against character varying, option_true boolean, x numeric, y numeric, id_flow numeric, number_flow_version numeric, status_flow_version boolean, creation_date_flow_version timestamp without time zone, id_company numeric, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_flow_version_level_update_modified(id_user_ numeric, _id_flow_version_level numeric, _id_flow_version numeric, _id_level numeric, _position_level numeric, _position_level_father numeric, _type_element business."TYPE_ELEMENT", _name_control character varying, _operator business."TYPE_OPERATOR", _value_against character varying, _option_true boolean, _x numeric, _y numeric) OWNER TO postgres;

--
-- TOC entry 545 (class 1255 OID 21710)
-- Name: dml_flow_version_update(numeric, numeric, numeric, numeric, boolean, timestamp without time zone, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_flow_version_update(id_user_ numeric, _id_flow_version numeric, _id_flow numeric, _number_flow_version numeric, _status_flow_version boolean, _creation_date_flow_version timestamp without time zone, _deleted_flow_version boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
	-- flow
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_flow v where v.id_flow = _id_flow);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_flow||' de la tabla flow no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_COUNT = (select count(*) from business.view_flow_version t where t.id_flow_version = _id_flow_version);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_flow_version t where t.id_flow_version = _id_flow_version and deleted_flow_version = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from business.view_flow_version t where t.id_flow_version = _id_flow_version and t.id_flow_version != _id_flow_version);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE business.flow_version SET id_flow=$3, number_flow_version=$4, status_flow_version=$5, creation_date_flow_version=$6, deleted_flow_version=$7 WHERE id_flow_version=$2 RETURNING id_flow_version LOOP
					_RETURNING = _X.id_flow_version;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'flow_version',_id_flow_version,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el id_flow_version '||_id_flow_version||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_flow_version||' no se encuentra registrado en la tabla flow_version';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_flow_version_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_flow_version_update(id_user_ numeric, _id_flow_version numeric, _id_flow numeric, _number_flow_version numeric, _status_flow_version boolean, _creation_date_flow_version timestamp without time zone, _deleted_flow_version boolean) OWNER TO app_nashor;

--
-- TOC entry 618 (class 1255 OID 21852)
-- Name: dml_flow_version_update_modified(numeric, numeric, numeric, numeric, boolean, timestamp without time zone, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_flow_version_update_modified(id_user_ numeric, _id_flow_version numeric, _id_flow numeric, _number_flow_version numeric, _status_flow_version boolean, _creation_date_flow_version timestamp without time zone, _deleted_flow_version boolean) RETURNS TABLE(id_flow_version numeric, id_flow numeric, number_flow_version numeric, status_flow_version boolean, creation_date_flow_version timestamp without time zone, deleted_flow_version boolean, id_company numeric, name_flow character varying, description_flow character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_flow_version_update_modified(id_user_ numeric, _id_flow_version numeric, _id_flow numeric, _number_flow_version numeric, _status_flow_version boolean, _creation_date_flow_version timestamp without time zone, _deleted_flow_version boolean) OWNER TO postgres;

--
-- TOC entry 523 (class 1255 OID 21688)
-- Name: dml_item_category_create(numeric, numeric, character varying, character varying, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_item_category_create(id_user_ numeric, _id_company numeric, _name_item_category character varying, _description_item_category character varying, _deleted_item_category boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
			
	_CURRENT_ID = (select nextval('business.serial_item_category')-1);
	_COUNT = (select count(*) from business.view_item_category t where t.id_item_category = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from business.view_item_category t where t.name_item_category = _name_item_category);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO business.item_category(id_item_category, id_company, name_item_category, description_item_category, deleted_item_category) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5) RETURNING id_item_category LOOP
				_RETURNING = _X.id_item_category;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'item_category',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el name_item_category '||_name_item_category||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla item_category';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_item_category'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_item_category_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_item_category_create(id_user_ numeric, _id_company numeric, _name_item_category character varying, _description_item_category character varying, _deleted_item_category boolean) OWNER TO app_nashor;

--
-- TOC entry 582 (class 1255 OID 21813)
-- Name: dml_item_category_create_modified(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_item_category_create_modified(id_user_ numeric, _id_company numeric) RETURNS TABLE(id_item_category numeric, id_company numeric, name_item_category character varying, description_item_category character varying, deleted_item_category boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_item_category_create_modified(id_user_ numeric, _id_company numeric) OWNER TO postgres;

--
-- TOC entry 525 (class 1255 OID 21690)
-- Name: dml_item_category_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_item_category_delete(id_user_ numeric, _id_item_category numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_item_category t where t.id_item_category = _id_item_category);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_item_category t where t.id_item_category = _id_item_category and deleted_item_category = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','item_category', _id_item_category));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE business.item_category SET deleted_item_category=true WHERE id_item_category = _id_item_category RETURNING id_item_category LOOP
					_RETURNING = _X.id_item_category;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'item_category',_id_item_category,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_item_category||' no se encuentra registrado en la tabla item_category';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_item_category_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_item_category_delete(id_user_ numeric, _id_item_category numeric) OWNER TO app_nashor;

--
-- TOC entry 524 (class 1255 OID 21689)
-- Name: dml_item_category_update(numeric, numeric, numeric, character varying, character varying, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_item_category_update(id_user_ numeric, _id_item_category numeric, _id_company numeric, _name_item_category character varying, _description_item_category character varying, _deleted_item_category boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
			
	_COUNT = (select count(*) from business.view_item_category t where t.id_item_category = _id_item_category);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_item_category t where t.id_item_category = _id_item_category and deleted_item_category = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from business.view_item_category t where t.name_item_category = _name_item_category and t.id_item_category != _id_item_category);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE business.item_category SET id_company=$3, name_item_category=$4, description_item_category=$5, deleted_item_category=$6 WHERE id_item_category=$2 RETURNING id_item_category LOOP
					_RETURNING = _X.id_item_category;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'item_category',_id_item_category,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el name_item_category '||_name_item_category||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_item_category||' no se encuentra registrado en la tabla item_category';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_item_category_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_item_category_update(id_user_ numeric, _id_item_category numeric, _id_company numeric, _name_item_category character varying, _description_item_category character varying, _deleted_item_category boolean) OWNER TO app_nashor;

--
-- TOC entry 583 (class 1255 OID 21814)
-- Name: dml_item_category_update_modified(numeric, numeric, numeric, character varying, character varying, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_item_category_update_modified(id_user_ numeric, _id_item_category numeric, _id_company numeric, _name_item_category character varying, _description_item_category character varying, _deleted_item_category boolean) RETURNS TABLE(id_item_category numeric, id_company numeric, name_item_category character varying, description_item_category character varying, deleted_item_category boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_item_category_update_modified(id_user_ numeric, _id_item_category numeric, _id_company numeric, _name_item_category character varying, _description_item_category character varying, _deleted_item_category boolean) OWNER TO postgres;

--
-- TOC entry 526 (class 1255 OID 21691)
-- Name: dml_item_create(numeric, numeric, numeric, character varying, character varying, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_item_create(id_user_ numeric, _id_company numeric, _id_item_category numeric, _name_item character varying, _description_item character varying, _deleted_item boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
			 
	-- item_category
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_item_category v where v.id_item_category = _id_item_category);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_item_category||' de la tabla item_category no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_CURRENT_ID = (select nextval('business.serial_item')-1);
	_COUNT = (select count(*) from business.view_item t where t.id_item = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from business.view_item t where t.name_item = _name_item);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO business.item(id_item, id_company, id_item_category, name_item, description_item, deleted_item) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6) RETURNING id_item LOOP
				_RETURNING = _X.id_item;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'item',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el name_item '||_name_item||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla item';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_item'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_item_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_item_create(id_user_ numeric, _id_company numeric, _id_item_category numeric, _name_item character varying, _description_item character varying, _deleted_item boolean) OWNER TO app_nashor;

--
-- TOC entry 584 (class 1255 OID 21815)
-- Name: dml_item_create_modified(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_item_create_modified(id_user_ numeric, _id_company numeric) RETURNS TABLE(id_item numeric, id_company numeric, id_item_category numeric, name_item character varying, description_item character varying, deleted_item boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, name_item_category character varying, description_item_category character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_item_create_modified(id_user_ numeric, _id_company numeric) OWNER TO postgres;

--
-- TOC entry 528 (class 1255 OID 21693)
-- Name: dml_item_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_item_delete(id_user_ numeric, _id_item numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_item t where t.id_item = _id_item);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_item t where t.id_item = _id_item and deleted_item = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','item', _id_item));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE business.item SET deleted_item=true WHERE id_item = _id_item RETURNING id_item LOOP
					_RETURNING = _X.id_item;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'item',_id_item,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_item||' no se encuentra registrado en la tabla item';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_item_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_item_delete(id_user_ numeric, _id_item numeric) OWNER TO app_nashor;

--
-- TOC entry 527 (class 1255 OID 21692)
-- Name: dml_item_update(numeric, numeric, numeric, numeric, character varying, character varying, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_item_update(id_user_ numeric, _id_item numeric, _id_company numeric, _id_item_category numeric, _name_item character varying, _description_item character varying, _deleted_item boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
			 
	-- item_category
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_item_category v where v.id_item_category = _id_item_category);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_item_category||' de la tabla item_category no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_COUNT = (select count(*) from business.view_item t where t.id_item = _id_item);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_item t where t.id_item = _id_item and deleted_item = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from business.view_item t where t.name_item = _name_item and t.id_item != _id_item);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE business.item SET id_company=$3, id_item_category=$4, name_item=$5, description_item=$6, deleted_item=$7 WHERE id_item=$2 RETURNING id_item LOOP
					_RETURNING = _X.id_item;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'item',_id_item,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el name_item '||_name_item||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_item||' no se encuentra registrado en la tabla item';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_item_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_item_update(id_user_ numeric, _id_item numeric, _id_company numeric, _id_item_category numeric, _name_item character varying, _description_item character varying, _deleted_item boolean) OWNER TO app_nashor;

--
-- TOC entry 585 (class 1255 OID 21816)
-- Name: dml_item_update_modified(numeric, numeric, numeric, numeric, character varying, character varying, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_item_update_modified(id_user_ numeric, _id_item numeric, _id_company numeric, _id_item_category numeric, _name_item character varying, _description_item character varying, _deleted_item boolean) RETURNS TABLE(id_item numeric, id_company numeric, id_item_category numeric, name_item character varying, description_item character varying, deleted_item boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, name_item_category character varying, description_item_category character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_item_update_modified(id_user_ numeric, _id_item numeric, _id_company numeric, _id_item_category numeric, _name_item character varying, _description_item character varying, _deleted_item boolean) OWNER TO postgres;

--
-- TOC entry 520 (class 1255 OID 21685)
-- Name: dml_level_create(numeric, numeric, numeric, numeric, numeric, character varying, character varying, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_level_create(id_user_ numeric, _id_company numeric, _id_template numeric, _id_level_profile numeric, _id_level_status numeric, _name_level character varying, _description_level character varying, _deleted_level boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
			 
	-- template
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_template v where v.id_template = _id_template);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_template||' de la tabla template no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- level_profile
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_level_profile v where v.id_level_profile = _id_level_profile);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_level_profile||' de la tabla level_profile no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- level_status
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_level_status v where v.id_level_status = _id_level_status);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_level_status||' de la tabla level_status no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_CURRENT_ID = (select nextval('business.serial_level')-1);
	_COUNT = (select count(*) from business.view_level t where t.id_level = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from business.view_level t where t.name_level = _name_level);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO business.level(id_level, id_company, id_template, id_level_profile, id_level_status, name_level, description_level, deleted_level) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6 ,$7 ,$8) RETURNING id_level LOOP
				_RETURNING = _X.id_level;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'level',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el name_level '||_name_level||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla level';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_level'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_level_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_level_create(id_user_ numeric, _id_company numeric, _id_template numeric, _id_level_profile numeric, _id_level_status numeric, _name_level character varying, _description_level character varying, _deleted_level boolean) OWNER TO app_nashor;

--
-- TOC entry 615 (class 1255 OID 21849)
-- Name: dml_level_create_modified(numeric, numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_level_create_modified(id_user_ numeric, _id_company numeric, _id_template numeric) RETURNS TABLE(id_level numeric, id_company numeric, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, deleted_level boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, id_documentation_profile numeric, id_plugin_item numeric, plugin_attached_process boolean, plugin_item_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, in_use boolean, name_level_profile character varying, description_level_profile character varying, name_level_status character varying, description_level_status character varying, color_level_status character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_level_create_modified(id_user_ numeric, _id_company numeric, _id_template numeric) OWNER TO postgres;

--
-- TOC entry 522 (class 1255 OID 21687)
-- Name: dml_level_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_level_delete(id_user_ numeric, _id_level numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_level t where t.id_level = _id_level);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_level t where t.id_level = _id_level and deleted_level = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','level', _id_level));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE business.level SET deleted_level=true WHERE id_level = _id_level RETURNING id_level LOOP
					_RETURNING = _X.id_level;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'level',_id_level,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_level||' no se encuentra registrado en la tabla level';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_level_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_level_delete(id_user_ numeric, _id_level numeric) OWNER TO app_nashor;

--
-- TOC entry 499 (class 1255 OID 21664)
-- Name: dml_level_profile_create(numeric, numeric, character varying, character varying, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_level_profile_create(id_user_ numeric, _id_company numeric, _name_level_profile character varying, _description_level_profile character varying, _deleted_level_profile boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
			
	_CURRENT_ID = (select nextval('business.serial_level_profile')-1);
	_COUNT = (select count(*) from business.view_level_profile t where t.id_level_profile = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from business.view_level_profile t where t.name_level_profile = _name_level_profile);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO business.level_profile(id_level_profile, id_company, name_level_profile, description_level_profile, deleted_level_profile) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5) RETURNING id_level_profile LOOP
				_RETURNING = _X.id_level_profile;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'level_profile',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el name_level_profile '||_name_level_profile||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla level_profile';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_level_profile'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_level_profile_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_level_profile_create(id_user_ numeric, _id_company numeric, _name_level_profile character varying, _description_level_profile character varying, _deleted_level_profile boolean) OWNER TO app_nashor;

--
-- TOC entry 610 (class 1255 OID 21844)
-- Name: dml_level_profile_create_modified(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_level_profile_create_modified(id_user_ numeric, _id_company numeric) RETURNS TABLE(id_level_profile numeric, id_company numeric, name_level_profile character varying, description_level_profile character varying, deleted_level_profile boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_level_profile_create_modified(id_user_ numeric, _id_company numeric) OWNER TO postgres;

--
-- TOC entry 501 (class 1255 OID 21666)
-- Name: dml_level_profile_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_level_profile_delete(id_user_ numeric, _id_level_profile numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_level_profile t where t.id_level_profile = _id_level_profile);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_level_profile t where t.id_level_profile = _id_level_profile and deleted_level_profile = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','level_profile', _id_level_profile));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE business.level_profile SET deleted_level_profile=true WHERE id_level_profile = _id_level_profile RETURNING id_level_profile LOOP
					_RETURNING = _X.id_level_profile;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'level_profile',_id_level_profile,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_level_profile||' no se encuentra registrado en la tabla level_profile';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_level_profile_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_level_profile_delete(id_user_ numeric, _id_level_profile numeric) OWNER TO app_nashor;

--
-- TOC entry 612 (class 1255 OID 21846)
-- Name: dml_level_profile_delete_modified(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_level_profile_delete_modified(id_user_ numeric, _id_level_profile numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_level_profile_delete_modified(id_user_ numeric, _id_level_profile numeric) OWNER TO postgres;

--
-- TOC entry 533 (class 1255 OID 21697)
-- Name: dml_level_profile_official_create(numeric, numeric, numeric, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_level_profile_official_create(id_user_ numeric, _id_level_profile numeric, _id_official numeric, _official_modifier boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
	-- level_profile
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_level_profile v where v.id_level_profile = _id_level_profile);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_level_profile||' de la tabla level_profile no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- official
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_official v where v.id_official = _id_official);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_official||' de la tabla official no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_CURRENT_ID = (select nextval('business.serial_level_profile_official')-1);
	_COUNT = (select count(*) from business.view_level_profile_official t where t.id_level_profile_official = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		FOR _X IN INSERT INTO business.level_profile_official(id_level_profile_official, id_level_profile, id_official, official_modifier) VALUES (_CURRENT_ID, $2 ,$3 ,$4) RETURNING id_level_profile_official LOOP
			_RETURNING = _X.id_level_profile_official;
		END LOOP;
		
		IF (_RETURNING >= 1) THEN
			_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
				where cvuij.id_user = id_user_);
			
			IF (_SAVE_LOG) THEN
				_RESPONSE = (select * from core.dml_system_event_create(id_user_,'level_profile_official',_CURRENT_ID,'CREATE', now()::timestamp, false));
				
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
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla level_profile_official';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_level_profile_official'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_level_profile_official_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_level_profile_official_create(id_user_ numeric, _id_level_profile numeric, _id_official numeric, _official_modifier boolean) OWNER TO app_nashor;

--
-- TOC entry 613 (class 1255 OID 21847)
-- Name: dml_level_profile_official_create_modified(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_level_profile_official_create_modified(id_user_ numeric, _id_level_profile numeric) RETURNS TABLE(number_task numeric, id_level_profile_official numeric, id_level_profile numeric, id_official numeric, official_modifier boolean, name_level_profile character varying, description_level_profile character varying, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_level_profile_official_create_modified(id_user_ numeric, _id_level_profile numeric) OWNER TO postgres;

--
-- TOC entry 535 (class 1255 OID 21699)
-- Name: dml_level_profile_official_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_level_profile_official_delete(id_user_ numeric, _id_level_profile_official numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_level_profile_official t where t.id_level_profile_official = _id_level_profile_official);
		
	IF (_COUNT = 1) THEN
		_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','level_profile_official', _id_level_profile_official));
			
		IF (_COUNT_DEPENDENCY > 0) THEN
			_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		ELSE
			FOR _X IN DELETE FROM business.level_profile_official WHERE id_level_profile_official = _id_level_profile_official RETURNING id_level_profile_official LOOP
				_RETURNING = _X.id_level_profile_official;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'level_profile_official',_id_level_profile_official,'DELETE', now()::timestamp, false));
					
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
		_EXCEPTION = 'El registro con id '||_id_level_profile_official||' no se encuentra registrado en la tabla level_profile_official';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_level_profile_official_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_level_profile_official_delete(id_user_ numeric, _id_level_profile_official numeric) OWNER TO app_nashor;

--
-- TOC entry 534 (class 1255 OID 21698)
-- Name: dml_level_profile_official_update(numeric, numeric, numeric, numeric, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_level_profile_official_update(id_user_ numeric, _id_level_profile_official numeric, _id_level_profile numeric, _id_official numeric, _official_modifier boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_EXTERNALS_IDS NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN 
	-- level_profile
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_level_profile v where v.id_level_profile = _id_level_profile);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_level_profile||' de la tabla level_profile no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- official
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_official v where v.id_official = _id_official);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_official||' de la tabla official no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
 	_COUNT = (select count(*) from business.view_level_profile_official t where t.id_level_profile_official = _id_level_profile_official);

	IF (_COUNT = 1) THEN
		FOR _X IN UPDATE business.level_profile_official SET id_level_profile=$3, id_official=$4, official_modifier=$5 WHERE id_level_profile_official=$2 RETURNING id_level_profile_official LOOP
			_RETURNING = _X.id_level_profile_official;
		END LOOP;
			
		IF (_RETURNING >= 1) THEN
			_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
				where cvuij.id_user = id_user_);

			IF (_SAVE_LOG) THEN
				_RESPONSE = (select * from core.dml_system_event_create(id_user_,'level_profile_official',_id_level_profile_official,'UPDATE', now()::timestamp, false));
				
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
		_EXCEPTION = 'El registro con id '||_id_level_profile_official||' no se encuentra registrado en la tabla level_profile_official';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_level_profile_official_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_level_profile_official_update(id_user_ numeric, _id_level_profile_official numeric, _id_level_profile numeric, _id_official numeric, _official_modifier boolean) OWNER TO app_nashor;

--
-- TOC entry 614 (class 1255 OID 21848)
-- Name: dml_level_profile_official_update_modified(numeric, numeric, numeric, numeric, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_level_profile_official_update_modified(id_user_ numeric, _id_level_profile_official numeric, _id_level_profile numeric, _id_official numeric, _official_modifier boolean) RETURNS TABLE(number_task numeric, id_level_profile_official numeric, id_level_profile numeric, id_official numeric, official_modifier boolean, name_level_profile character varying, description_level_profile character varying, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_level_profile_official_update_modified(id_user_ numeric, _id_level_profile_official numeric, _id_level_profile numeric, _id_official numeric, _official_modifier boolean) OWNER TO postgres;

--
-- TOC entry 500 (class 1255 OID 21665)
-- Name: dml_level_profile_update(numeric, numeric, numeric, character varying, character varying, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_level_profile_update(id_user_ numeric, _id_level_profile numeric, _id_company numeric, _name_level_profile character varying, _description_level_profile character varying, _deleted_level_profile boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
			
	_COUNT = (select count(*) from business.view_level_profile t where t.id_level_profile = _id_level_profile);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_level_profile t where t.id_level_profile = _id_level_profile and deleted_level_profile = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from business.view_level_profile t where t.name_level_profile = _name_level_profile and t.id_level_profile != _id_level_profile);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE business.level_profile SET id_company=$3, name_level_profile=$4, description_level_profile=$5, deleted_level_profile=$6 WHERE id_level_profile=$2 RETURNING id_level_profile LOOP
					_RETURNING = _X.id_level_profile;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'level_profile',_id_level_profile,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el name_level_profile '||_name_level_profile||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_level_profile||' no se encuentra registrado en la tabla level_profile';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_level_profile_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_level_profile_update(id_user_ numeric, _id_level_profile numeric, _id_company numeric, _name_level_profile character varying, _description_level_profile character varying, _deleted_level_profile boolean) OWNER TO app_nashor;

--
-- TOC entry 611 (class 1255 OID 21845)
-- Name: dml_level_profile_update_modified(numeric, numeric, numeric, character varying, character varying, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_level_profile_update_modified(id_user_ numeric, _id_level_profile numeric, _id_company numeric, _name_level_profile character varying, _description_level_profile character varying, _deleted_level_profile boolean) RETURNS TABLE(id_level_profile numeric, id_company numeric, name_level_profile character varying, description_level_profile character varying, deleted_level_profile boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_level_profile_update_modified(id_user_ numeric, _id_level_profile numeric, _id_company numeric, _name_level_profile character varying, _description_level_profile character varying, _deleted_level_profile boolean) OWNER TO postgres;

--
-- TOC entry 514 (class 1255 OID 21679)
-- Name: dml_level_status_create(numeric, numeric, character varying, character varying, character varying, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_level_status_create(id_user_ numeric, _id_company numeric, _name_level_status character varying, _description_level_status character varying, _color_level_status character varying, _deleted_level_status boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
			
	_CURRENT_ID = (select nextval('business.serial_level_status')-1);
	_COUNT = (select count(*) from business.view_level_status t where t.id_level_status = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from business.view_level_status t where t.name_level_status = _name_level_status);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO business.level_status(id_level_status, id_company, name_level_status, description_level_status, color_level_status, deleted_level_status) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6) RETURNING id_level_status LOOP
				_RETURNING = _X.id_level_status;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'level_status',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el name_level_status '||_name_level_status||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla level_status';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_level_status'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_level_status_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_level_status_create(id_user_ numeric, _id_company numeric, _name_level_status character varying, _description_level_status character varying, _color_level_status character varying, _deleted_level_status boolean) OWNER TO app_nashor;

--
-- TOC entry 608 (class 1255 OID 21842)
-- Name: dml_level_status_create_modified(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_level_status_create_modified(id_user_ numeric, _id_company numeric) RETURNS TABLE(id_level_status numeric, id_company numeric, name_level_status character varying, description_level_status character varying, color_level_status character varying, deleted_level_status boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_level_status_create_modified(id_user_ numeric, _id_company numeric) OWNER TO postgres;

--
-- TOC entry 516 (class 1255 OID 21681)
-- Name: dml_level_status_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_level_status_delete(id_user_ numeric, _id_level_status numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_level_status t where t.id_level_status = _id_level_status);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_level_status t where t.id_level_status = _id_level_status and deleted_level_status = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','level_status', _id_level_status));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE business.level_status SET deleted_level_status=true WHERE id_level_status = _id_level_status RETURNING id_level_status LOOP
					_RETURNING = _X.id_level_status;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'level_status',_id_level_status,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_level_status||' no se encuentra registrado en la tabla level_status';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_level_status_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_level_status_delete(id_user_ numeric, _id_level_status numeric) OWNER TO app_nashor;

--
-- TOC entry 515 (class 1255 OID 21680)
-- Name: dml_level_status_update(numeric, numeric, numeric, character varying, character varying, character varying, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_level_status_update(id_user_ numeric, _id_level_status numeric, _id_company numeric, _name_level_status character varying, _description_level_status character varying, _color_level_status character varying, _deleted_level_status boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
			
	_COUNT = (select count(*) from business.view_level_status t where t.id_level_status = _id_level_status);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_level_status t where t.id_level_status = _id_level_status and deleted_level_status = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from business.view_level_status t where t.name_level_status = _name_level_status and t.id_level_status != _id_level_status);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE business.level_status SET id_company=$3, name_level_status=$4, description_level_status=$5, color_level_status=$6, deleted_level_status=$7 WHERE id_level_status=$2 RETURNING id_level_status LOOP
					_RETURNING = _X.id_level_status;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'level_status',_id_level_status,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el name_level_status '||_name_level_status||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_level_status||' no se encuentra registrado en la tabla level_status';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_level_status_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_level_status_update(id_user_ numeric, _id_level_status numeric, _id_company numeric, _name_level_status character varying, _description_level_status character varying, _color_level_status character varying, _deleted_level_status boolean) OWNER TO app_nashor;

--
-- TOC entry 609 (class 1255 OID 21843)
-- Name: dml_level_status_update_modified(numeric, numeric, numeric, character varying, character varying, character varying, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_level_status_update_modified(id_user_ numeric, _id_level_status numeric, _id_company numeric, _name_level_status character varying, _description_level_status character varying, _color_level_status character varying, _deleted_level_status boolean) RETURNS TABLE(id_level_status numeric, id_company numeric, name_level_status character varying, description_level_status character varying, color_level_status character varying, deleted_level_status boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_level_status_update_modified(id_user_ numeric, _id_level_status numeric, _id_company numeric, _name_level_status character varying, _description_level_status character varying, _color_level_status character varying, _deleted_level_status boolean) OWNER TO postgres;

--
-- TOC entry 521 (class 1255 OID 21686)
-- Name: dml_level_update(numeric, numeric, numeric, numeric, numeric, numeric, character varying, character varying, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_level_update(id_user_ numeric, _id_level numeric, _id_company numeric, _id_template numeric, _id_level_profile numeric, _id_level_status numeric, _name_level character varying, _description_level character varying, _deleted_level boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
			 
	-- template
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_template v where v.id_template = _id_template);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_template||' de la tabla template no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- level_profile
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_level_profile v where v.id_level_profile = _id_level_profile);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_level_profile||' de la tabla level_profile no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- level_status
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_level_status v where v.id_level_status = _id_level_status);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_level_status||' de la tabla level_status no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_COUNT = (select count(*) from business.view_level t where t.id_level = _id_level);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_level t where t.id_level = _id_level and deleted_level = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from business.view_level t where t.name_level = _name_level and t.id_level != _id_level);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE business.level SET id_company=$3, id_template=$4, id_level_profile=$5, id_level_status=$6, name_level=$7, description_level=$8, deleted_level=$9 WHERE id_level=$2 RETURNING id_level LOOP
					_RETURNING = _X.id_level;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'level',_id_level,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el name_level '||_name_level||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_level||' no se encuentra registrado en la tabla level';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_level_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_level_update(id_user_ numeric, _id_level numeric, _id_company numeric, _id_template numeric, _id_level_profile numeric, _id_level_status numeric, _name_level character varying, _description_level character varying, _deleted_level boolean) OWNER TO app_nashor;

--
-- TOC entry 616 (class 1255 OID 21850)
-- Name: dml_level_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, character varying, character varying, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_level_update_modified(id_user_ numeric, _id_level numeric, _id_company numeric, _id_template numeric, _id_level_profile numeric, _id_level_status numeric, _name_level character varying, _description_level character varying, _deleted_level boolean) RETURNS TABLE(id_level numeric, id_company numeric, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, deleted_level boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, id_documentation_profile numeric, id_plugin_item numeric, plugin_attached_process boolean, plugin_item_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, in_use boolean, name_level_profile character varying, description_level_profile character varying, name_level_status character varying, description_level_status character varying, color_level_status character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_level_update_modified(id_user_ numeric, _id_level numeric, _id_company numeric, _id_template numeric, _id_level_profile numeric, _id_level_status numeric, _name_level character varying, _description_level character varying, _deleted_level boolean) OWNER TO postgres;

--
-- TOC entry 490 (class 1255 OID 21655)
-- Name: dml_official_create(numeric, numeric, numeric, numeric, numeric, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_official_create(id_user_ numeric, _id_company numeric, _id_user numeric, _id_area numeric, _id_position numeric, _deleted_official boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
			 
	-- user
	_COUNT_EXTERNALS_IDS = (select count(*) from core.view_user v where v.id_user = _id_user);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_user||' de la tabla user no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- area
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_area v where v.id_area = _id_area);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_area||' de la tabla area no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- position
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_position v where v.id_position = _id_position);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_position||' de la tabla position no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_CURRENT_ID = (select nextval('business.serial_official')-1);
	_COUNT = (select count(*) from business.view_official t where t.id_official = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from business.view_official t where t.id_official = _CURRENT_ID);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO business.official(id_official, id_company, id_user, id_area, id_position, deleted_official) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6) RETURNING id_official LOOP
				_RETURNING = _X.id_official;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'official',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el id_official '||_id_official||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla official';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_official'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_official_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_official_create(id_user_ numeric, _id_company numeric, _id_user numeric, _id_area numeric, _id_position numeric, _deleted_official boolean) OWNER TO app_nashor;

--
-- TOC entry 572 (class 1255 OID 21803)
-- Name: dml_official_create_modified(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_official_create_modified(id_user_ numeric, _id_company numeric) RETURNS TABLE(id_official numeric, id_company numeric, id_user numeric, id_area numeric, id_position numeric, deleted_official boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, name_area character varying, description_area character varying, name_position character varying, description_position character varying, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_profile numeric, name_type_user character varying, description_type_user character varying, status_type_user boolean, title_academic character varying, abbreviation_academic character varying, level_academic character varying, name_job character varying, address_job character varying, phone_job character varying, position_job character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_official_create_modified(id_user_ numeric, _id_company numeric) OWNER TO postgres;

--
-- TOC entry 492 (class 1255 OID 21657)
-- Name: dml_official_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_official_delete(id_user_ numeric, _id_official numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_official t where t.id_official = _id_official);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_official t where t.id_official = _id_official and deleted_official = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','official', _id_official));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE business.official SET deleted_official=true WHERE id_official = _id_official RETURNING id_official LOOP
					_RETURNING = _X.id_official;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'official',_id_official,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_official||' no se encuentra registrado en la tabla official';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_official_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_official_delete(id_user_ numeric, _id_official numeric) OWNER TO app_nashor;

--
-- TOC entry 575 (class 1255 OID 21805)
-- Name: dml_official_delete_modified(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_official_delete_modified(id_user_ numeric, _id_official numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_official_delete_modified(id_user_ numeric, _id_official numeric) OWNER TO postgres;

--
-- TOC entry 491 (class 1255 OID 21656)
-- Name: dml_official_update(numeric, numeric, numeric, numeric, numeric, numeric, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_official_update(id_user_ numeric, _id_official numeric, _id_company numeric, _id_user numeric, _id_area numeric, _id_position numeric, _deleted_official boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
			 
	-- user
	_COUNT_EXTERNALS_IDS = (select count(*) from core.view_user v where v.id_user = _id_user);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_user||' de la tabla user no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- area
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_area v where v.id_area = _id_area);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_area||' de la tabla area no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- position
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_position v where v.id_position = _id_position);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_position||' de la tabla position no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_COUNT = (select count(*) from business.view_official t where t.id_official = _id_official);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_official t where t.id_official = _id_official and deleted_official = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from business.view_official t where t.id_official = _id_official and t.id_official != _id_official);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE business.official SET id_company=$3, id_user=$4, id_area=$5, id_position=$6, deleted_official=$7 WHERE id_official=$2 RETURNING id_official LOOP
					_RETURNING = _X.id_official;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'official',_id_official,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el id_official '||_id_official||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_official||' no se encuentra registrado en la tabla official';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_official_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_official_update(id_user_ numeric, _id_official numeric, _id_company numeric, _id_user numeric, _id_area numeric, _id_position numeric, _deleted_official boolean) OWNER TO app_nashor;

--
-- TOC entry 574 (class 1255 OID 21804)
-- Name: dml_official_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, character varying, character varying, character varying, boolean, numeric, numeric, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_official_update_modified(id_user_ numeric, _id_official numeric, _id_user numeric, _id_company numeric, _id_person numeric, _id_type_user numeric, _name_user character varying, _password_user character varying, _avatar_user character varying, _status_user boolean, _id_academic numeric, _id_job numeric, _dni_person character varying, _name_person character varying, _last_name_person character varying, _address_person character varying, _phone_person character varying, _title_academic character varying, _abbreviation_academic character varying, _level_academic character varying, _name_job character varying, _address_job character varying, _phone_job character varying, _position_job character varying, _id_area numeric, _id_position numeric) RETURNS TABLE(id_official numeric, id_company numeric, id_user numeric, id_area numeric, id_position numeric, deleted_official boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, name_area character varying, description_area character varying, name_position character varying, description_position character varying, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_profile numeric, name_type_user character varying, description_type_user character varying, status_type_user boolean, title_academic character varying, abbreviation_academic character varying, level_academic character varying, name_job character varying, address_job character varying, phone_job character varying, position_job character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_official_update_modified(id_user_ numeric, _id_official numeric, _id_user numeric, _id_company numeric, _id_person numeric, _id_type_user numeric, _name_user character varying, _password_user character varying, _avatar_user character varying, _status_user boolean, _id_academic numeric, _id_job numeric, _dni_person character varying, _name_person character varying, _last_name_person character varying, _address_person character varying, _phone_person character varying, _title_academic character varying, _abbreviation_academic character varying, _level_academic character varying, _name_job character varying, _address_job character varying, _phone_job character varying, _position_job character varying, _id_area numeric, _id_position numeric) OWNER TO postgres;

--
-- TOC entry 557 (class 1255 OID 21730)
-- Name: dml_plugin_item_column_create(numeric, numeric, character varying, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_plugin_item_column_create(id_user_ numeric, _id_plugin_item numeric, _name_plugin_item_column character varying, _lenght_plugin_item_column numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
	-- plugin_item
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_plugin_item v where v.id_plugin_item = _id_plugin_item);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_plugin_item||' de la tabla plugin_item no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_CURRENT_ID = (select nextval('business.serial_plugin_item_column')-1);
	_COUNT = (select count(*) from business.view_plugin_item_column t where t.id_plugin_item_column = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		FOR _X IN INSERT INTO business.plugin_item_column(id_plugin_item_column, id_plugin_item, name_plugin_item_column, lenght_plugin_item_column) VALUES (_CURRENT_ID, $2 ,$3 ,$4) RETURNING id_plugin_item_column LOOP
			_RETURNING = _X.id_plugin_item_column;
		END LOOP;
		
		IF (_RETURNING >= 1) THEN
			_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
				where cvuij.id_user = id_user_);
			
			IF (_SAVE_LOG) THEN
				_RESPONSE = (select * from core.dml_system_event_create(id_user_,'plugin_item_column',_CURRENT_ID,'CREATE', now()::timestamp, false));
				
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
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla plugin_item_column';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_plugin_item_column'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_plugin_item_column_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_plugin_item_column_create(id_user_ numeric, _id_plugin_item numeric, _name_plugin_item_column character varying, _lenght_plugin_item_column numeric) OWNER TO app_nashor;

--
-- TOC entry 593 (class 1255 OID 21825)
-- Name: dml_plugin_item_column_create_modified(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_plugin_item_column_create_modified(id_user_ numeric, _id_plugin_item numeric) RETURNS TABLE(id_plugin_item_column numeric, id_plugin_item numeric, name_plugin_item_column character varying, lenght_plugin_item_column numeric, id_company numeric, name_plugin_item character varying, description_plugin_item character varying, select_plugin_item boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_plugin_item_column_create_modified(id_user_ numeric, _id_plugin_item numeric) OWNER TO postgres;

--
-- TOC entry 564 (class 1255 OID 21732)
-- Name: dml_plugin_item_column_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_plugin_item_column_delete(id_user_ numeric, _id_plugin_item_column numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_plugin_item_column t where t.id_plugin_item_column = _id_plugin_item_column);
		
	IF (_COUNT = 1) THEN
		_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','plugin_item_column', _id_plugin_item_column));
			
		IF (_COUNT_DEPENDENCY > 0) THEN
			_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		ELSE
			FOR _X IN DELETE FROM business.plugin_item_column WHERE id_plugin_item_column = _id_plugin_item_column RETURNING id_plugin_item_column LOOP
				_RETURNING = _X.id_plugin_item_column;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'plugin_item_column',_id_plugin_item_column,'DELETE', now()::timestamp, false));
					
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
		_EXCEPTION = 'El registro con id '||_id_plugin_item_column||' no se encuentra registrado en la tabla plugin_item_column';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_plugin_item_column_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_plugin_item_column_delete(id_user_ numeric, _id_plugin_item_column numeric) OWNER TO app_nashor;

--
-- TOC entry 563 (class 1255 OID 21731)
-- Name: dml_plugin_item_column_update(numeric, numeric, numeric, character varying, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_plugin_item_column_update(id_user_ numeric, _id_plugin_item_column numeric, _id_plugin_item numeric, _name_plugin_item_column character varying, _lenght_plugin_item_column numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_EXTERNALS_IDS NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN 
	-- plugin_item
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_plugin_item v where v.id_plugin_item = _id_plugin_item);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_plugin_item||' de la tabla plugin_item no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
 	_COUNT = (select count(*) from business.view_plugin_item_column t where t.id_plugin_item_column = _id_plugin_item_column);

	IF (_COUNT = 1) THEN
		FOR _X IN UPDATE business.plugin_item_column SET id_plugin_item=$3, name_plugin_item_column=$4, lenght_plugin_item_column=$5 WHERE id_plugin_item_column=$2 RETURNING id_plugin_item_column LOOP
			_RETURNING = _X.id_plugin_item_column;
		END LOOP;
			
		IF (_RETURNING >= 1) THEN
			_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
				where cvuij.id_user = id_user_);

			IF (_SAVE_LOG) THEN
				_RESPONSE = (select * from core.dml_system_event_create(id_user_,'plugin_item_column',_id_plugin_item_column,'UPDATE', now()::timestamp, false));
				
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
		_EXCEPTION = 'El registro con id '||_id_plugin_item_column||' no se encuentra registrado en la tabla plugin_item_column';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_plugin_item_column_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_plugin_item_column_update(id_user_ numeric, _id_plugin_item_column numeric, _id_plugin_item numeric, _name_plugin_item_column character varying, _lenght_plugin_item_column numeric) OWNER TO app_nashor;

--
-- TOC entry 594 (class 1255 OID 21826)
-- Name: dml_plugin_item_column_update_modified(numeric, numeric, numeric, character varying, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_plugin_item_column_update_modified(id_user_ numeric, _id_plugin_item_column numeric, _id_plugin_item numeric, _name_plugin_item_column character varying, _lenght_plugin_item_column numeric) RETURNS TABLE(id_plugin_item_column numeric, id_plugin_item numeric, name_plugin_item_column character varying, lenght_plugin_item_column numeric, id_company numeric, name_plugin_item character varying, description_plugin_item character varying, select_plugin_item boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_plugin_item_column_update_modified(id_user_ numeric, _id_plugin_item_column numeric, _id_plugin_item numeric, _name_plugin_item_column character varying, _lenght_plugin_item_column numeric) OWNER TO postgres;

--
-- TOC entry 529 (class 1255 OID 21694)
-- Name: dml_plugin_item_create(numeric, numeric, character varying, character varying, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_plugin_item_create(id_user_ numeric, _id_company numeric, _name_plugin_item character varying, _description_plugin_item character varying, _select_plugin_item boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
	-- company
	_COUNT_EXTERNALS_IDS = (select count(*) from core.view_company v where v.id_company = _id_company);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_company||' de la tabla company no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_CURRENT_ID = (select nextval('business.serial_plugin_item')-1);
	_COUNT = (select count(*) from business.view_plugin_item t where t.id_plugin_item = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		FOR _X IN INSERT INTO business.plugin_item(id_plugin_item, id_company, name_plugin_item, description_plugin_item, select_plugin_item) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5) RETURNING id_plugin_item LOOP
			_RETURNING = _X.id_plugin_item;
		END LOOP;
		
		IF (_RETURNING >= 1) THEN
			_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
				where cvuij.id_user = id_user_);
			
			IF (_SAVE_LOG) THEN
				_RESPONSE = (select * from core.dml_system_event_create(id_user_,'plugin_item',_CURRENT_ID,'CREATE', now()::timestamp, false));
				
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
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla plugin_item';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_plugin_item'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_plugin_item_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_plugin_item_create(id_user_ numeric, _id_company numeric, _name_plugin_item character varying, _description_plugin_item character varying, _select_plugin_item boolean) OWNER TO app_nashor;

--
-- TOC entry 591 (class 1255 OID 21823)
-- Name: dml_plugin_item_create_modified(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_plugin_item_create_modified(id_user_ numeric, _id_company numeric) RETURNS TABLE(id_plugin_item numeric, id_company numeric, name_plugin_item character varying, description_plugin_item character varying, select_plugin_item boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_plugin_item_create_modified(id_user_ numeric, _id_company numeric) OWNER TO postgres;

--
-- TOC entry 532 (class 1255 OID 21696)
-- Name: dml_plugin_item_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_plugin_item_delete(id_user_ numeric, _id_plugin_item numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_plugin_item t where t.id_plugin_item = _id_plugin_item);
		
	IF (_COUNT = 1) THEN
		_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','plugin_item', _id_plugin_item));
			
		IF (_COUNT_DEPENDENCY > 0) THEN
			_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		ELSE
			FOR _X IN DELETE FROM business.plugin_item WHERE id_plugin_item = _id_plugin_item RETURNING id_plugin_item LOOP
				_RETURNING = _X.id_plugin_item;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'plugin_item',_id_plugin_item,'DELETE', now()::timestamp, false));
					
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
		_EXCEPTION = 'El registro con id '||_id_plugin_item||' no se encuentra registrado en la tabla plugin_item';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_plugin_item_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_plugin_item_delete(id_user_ numeric, _id_plugin_item numeric) OWNER TO app_nashor;

--
-- TOC entry 531 (class 1255 OID 21695)
-- Name: dml_plugin_item_update(numeric, numeric, numeric, character varying, character varying, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_plugin_item_update(id_user_ numeric, _id_plugin_item numeric, _id_company numeric, _name_plugin_item character varying, _description_plugin_item character varying, _select_plugin_item boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
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
			
 	_COUNT = (select count(*) from business.view_plugin_item t where t.id_plugin_item = _id_plugin_item);

	IF (_COUNT = 1) THEN
		FOR _X IN UPDATE business.plugin_item SET id_company=$3, name_plugin_item=$4, description_plugin_item=$5, select_plugin_item=$6 WHERE id_plugin_item=$2 RETURNING id_plugin_item LOOP
			_RETURNING = _X.id_plugin_item;
		END LOOP;
			
		IF (_RETURNING >= 1) THEN
			_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
				where cvuij.id_user = id_user_);

			IF (_SAVE_LOG) THEN
				_RESPONSE = (select * from core.dml_system_event_create(id_user_,'plugin_item',_id_plugin_item,'UPDATE', now()::timestamp, false));
				
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
		_EXCEPTION = 'El registro con id '||_id_plugin_item||' no se encuentra registrado en la tabla plugin_item';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_plugin_item_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_plugin_item_update(id_user_ numeric, _id_plugin_item numeric, _id_company numeric, _name_plugin_item character varying, _description_plugin_item character varying, _select_plugin_item boolean) OWNER TO app_nashor;

--
-- TOC entry 592 (class 1255 OID 21824)
-- Name: dml_plugin_item_update_modified(numeric, numeric, numeric, character varying, character varying, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_plugin_item_update_modified(id_user_ numeric, _id_plugin_item numeric, _id_company numeric, _name_plugin_item character varying, _description_plugin_item character varying, _select_plugin_item boolean) RETURNS TABLE(id_plugin_item numeric, id_company numeric, name_plugin_item character varying, description_plugin_item character varying, select_plugin_item boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_plugin_item_update_modified(id_user_ numeric, _id_plugin_item numeric, _id_company numeric, _name_plugin_item character varying, _description_plugin_item character varying, _select_plugin_item boolean) OWNER TO postgres;

--
-- TOC entry 496 (class 1255 OID 21661)
-- Name: dml_position_create(numeric, numeric, character varying, character varying, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_position_create(id_user_ numeric, _id_company numeric, _name_position character varying, _description_position character varying, _deleted_position boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
			
	_CURRENT_ID = (select nextval('business.serial_position')-1);
	_COUNT = (select count(*) from business.view_position t where t.id_position = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from business.view_position t where t.name_position = _name_position);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO business.position(id_position, id_company, name_position, description_position, deleted_position) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5) RETURNING id_position LOOP
				_RETURNING = _X.id_position;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'position',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el name_position '||_name_position||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla position';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_position'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_position_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_position_create(id_user_ numeric, _id_company numeric, _name_position character varying, _description_position character varying, _deleted_position boolean) OWNER TO app_nashor;

--
-- TOC entry 570 (class 1255 OID 21801)
-- Name: dml_position_create_modified(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_position_create_modified(id_user_ numeric, _id_company numeric) RETURNS TABLE(id_position numeric, id_company numeric, name_position character varying, description_position character varying, deleted_position boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_position_create_modified(id_user_ numeric, _id_company numeric) OWNER TO postgres;

--
-- TOC entry 498 (class 1255 OID 21663)
-- Name: dml_position_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_position_delete(id_user_ numeric, _id_position numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_position t where t.id_position = _id_position);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_position t where t.id_position = _id_position and deleted_position = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','position', _id_position));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE business.position SET deleted_position=true WHERE id_position = _id_position RETURNING id_position LOOP
					_RETURNING = _X.id_position;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'position',_id_position,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_position||' no se encuentra registrado en la tabla position';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_position_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_position_delete(id_user_ numeric, _id_position numeric) OWNER TO app_nashor;

--
-- TOC entry 497 (class 1255 OID 21662)
-- Name: dml_position_update(numeric, numeric, numeric, character varying, character varying, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_position_update(id_user_ numeric, _id_position numeric, _id_company numeric, _name_position character varying, _description_position character varying, _deleted_position boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
			
	_COUNT = (select count(*) from business.view_position t where t.id_position = _id_position);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_position t where t.id_position = _id_position and deleted_position = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from business.view_position t where t.name_position = _name_position and t.id_position != _id_position);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE business.position SET id_company=$3, name_position=$4, description_position=$5, deleted_position=$6 WHERE id_position=$2 RETURNING id_position LOOP
					_RETURNING = _X.id_position;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'position',_id_position,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el name_position '||_name_position||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_position||' no se encuentra registrado en la tabla position';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_position_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_position_update(id_user_ numeric, _id_position numeric, _id_company numeric, _name_position character varying, _description_position character varying, _deleted_position boolean) OWNER TO app_nashor;

--
-- TOC entry 571 (class 1255 OID 21802)
-- Name: dml_position_update_modified(numeric, numeric, numeric, character varying, character varying, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_position_update_modified(id_user_ numeric, _id_position numeric, _id_company numeric, _name_position character varying, _description_position character varying, _deleted_position boolean) RETURNS TABLE(id_position numeric, id_company numeric, name_position character varying, description_position character varying, deleted_position boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_position_update_modified(id_user_ numeric, _id_position numeric, _id_company numeric, _name_position character varying, _description_position character varying, _deleted_position boolean) OWNER TO postgres;

--
-- TOC entry 556 (class 1255 OID 21724)
-- Name: dml_process_attached_create(numeric, numeric, numeric, numeric, numeric, numeric, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_process_attached_create(id_user_ numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _id_attached numeric, _file_name character varying, _length_mb character varying, _extension character varying, _server_path character varying, _alfresco_path character varying, _upload_date timestamp without time zone, _deleted_process_attached boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
	-- official
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_official v where v.id_official = _id_official);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_official||' de la tabla official no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- process
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_process v where v.id_process = _id_process);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_process||' de la tabla process no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- task
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_task v where v.id_task = _id_task);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_task||' de la tabla task no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- level
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_level v where v.id_level = _id_level);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_level||' de la tabla level no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- attached
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_attached v where v.id_attached = _id_attached);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_attached||' de la tabla attached no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_CURRENT_ID = (select nextval('business.serial_process_attached')-1);
	_COUNT = (select count(*) from business.view_process_attached t where t.id_process_attached = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from business.view_process_attached t where t.id_process_attached = _CURRENT_ID);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO business.process_attached(id_process_attached, id_official, id_process, id_task, id_level, id_attached, file_name, length_mb, extension, server_path, alfresco_path, upload_date, deleted_process_attached) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6 ,$7 ,$8 ,$9 ,$10 ,$11 ,$12 ,$13) RETURNING id_process_attached LOOP
				_RETURNING = _X.id_process_attached;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'process_attached',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el id_process_attached '||_id_process_attached||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla process_attached';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_process_attached'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_attached_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_process_attached_create(id_user_ numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _id_attached numeric, _file_name character varying, _length_mb character varying, _extension character varying, _server_path character varying, _alfresco_path character varying, _upload_date timestamp without time zone, _deleted_process_attached boolean) OWNER TO app_nashor;

--
-- TOC entry 638 (class 1255 OID 21872)
-- Name: dml_process_attached_create_modified(numeric, numeric, numeric, numeric, numeric, numeric, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_process_attached_create_modified(id_user_ numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _id_attached numeric, _file_name character varying, _length_mb character varying, _extension character varying, _server_path character varying, _alfresco_path character varying) RETURNS TABLE(id_process_attached numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, id_attached numeric, file_name character varying, length_mb character varying, extension character varying, server_path character varying, alfresco_path character varying, upload_date timestamp without time zone, deleted_process_attached boolean, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, number_task character varying, type_status_task business."TYPE_STATUS_TASK", date_task timestamp without time zone, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, name_attached character varying, description_attached character varying, length_mb_attached numeric, required_attached boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_process_attached_create_modified(id_user_ numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _id_attached numeric, _file_name character varying, _length_mb character varying, _extension character varying, _server_path character varying, _alfresco_path character varying) OWNER TO postgres;

--
-- TOC entry 559 (class 1255 OID 21726)
-- Name: dml_process_attached_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_process_attached_delete(id_user_ numeric, _id_process_attached numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_process_attached t where t.id_process_attached = _id_process_attached);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_process_attached t where t.id_process_attached = _id_process_attached and deleted_process_attached = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','process_attached', _id_process_attached));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE business.process_attached SET deleted_process_attached=true WHERE id_process_attached = _id_process_attached RETURNING id_process_attached LOOP
					_RETURNING = _X.id_process_attached;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'process_attached',_id_process_attached,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_process_attached||' no se encuentra registrado en la tabla process_attached';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_attached_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_process_attached_delete(id_user_ numeric, _id_process_attached numeric) OWNER TO app_nashor;

--
-- TOC entry 558 (class 1255 OID 21725)
-- Name: dml_process_attached_update(numeric, numeric, numeric, numeric, numeric, numeric, numeric, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_process_attached_update(id_user_ numeric, _id_process_attached numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _id_attached numeric, _file_name character varying, _length_mb character varying, _extension character varying, _server_path character varying, _alfresco_path character varying, _upload_date timestamp without time zone, _deleted_process_attached boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
	-- official
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_official v where v.id_official = _id_official);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_official||' de la tabla official no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- process
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_process v where v.id_process = _id_process);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_process||' de la tabla process no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- task
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_task v where v.id_task = _id_task);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_task||' de la tabla task no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- level
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_level v where v.id_level = _id_level);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_level||' de la tabla level no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- attached
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_attached v where v.id_attached = _id_attached);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_attached||' de la tabla attached no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_COUNT = (select count(*) from business.view_process_attached t where t.id_process_attached = _id_process_attached);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_process_attached t where t.id_process_attached = _id_process_attached and deleted_process_attached = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from business.view_process_attached t where t.id_process_attached = _id_process_attached and t.id_process_attached != _id_process_attached);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE business.process_attached SET id_official=$3, id_process=$4, id_task=$5, id_level=$6, id_attached=$7, file_name=$8, length_mb=$9, extension=$10, server_path=$11, alfresco_path=$12, upload_date=$13, deleted_process_attached=$14 WHERE id_process_attached=$2 RETURNING id_process_attached LOOP
					_RETURNING = _X.id_process_attached;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'process_attached',_id_process_attached,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el id_process_attached '||_id_process_attached||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_process_attached||' no se encuentra registrado en la tabla process_attached';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_attached_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_process_attached_update(id_user_ numeric, _id_process_attached numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _id_attached numeric, _file_name character varying, _length_mb character varying, _extension character varying, _server_path character varying, _alfresco_path character varying, _upload_date timestamp without time zone, _deleted_process_attached boolean) OWNER TO app_nashor;

--
-- TOC entry 639 (class 1255 OID 21873)
-- Name: dml_process_attached_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, numeric, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_process_attached_update_modified(id_user_ numeric, _id_process_attached numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _id_attached numeric, _file_name character varying, _length_mb character varying, _extension character varying, _server_path character varying, _alfresco_path character varying, _upload_date timestamp without time zone, _deleted_process_attached boolean) RETURNS TABLE(id_process_attached numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, id_attached numeric, file_name character varying, length_mb character varying, extension character varying, server_path character varying, alfresco_path character varying, upload_date timestamp without time zone, deleted_process_attached boolean, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, number_task character varying, type_status_task business."TYPE_STATUS_TASK", date_task timestamp without time zone, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, name_attached character varying, description_attached character varying, length_mb_attached numeric, required_attached boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_process_attached_update_modified(id_user_ numeric, _id_process_attached numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _id_attached numeric, _file_name character varying, _length_mb character varying, _extension character varying, _server_path character varying, _alfresco_path character varying, _upload_date timestamp without time zone, _deleted_process_attached boolean) OWNER TO postgres;

--
-- TOC entry 553 (class 1255 OID 21721)
-- Name: dml_process_comment_create(numeric, numeric, numeric, numeric, numeric, character varying, timestamp without time zone, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_process_comment_create(id_user_ numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _value_process_comment character varying, _date_process_comment timestamp without time zone, _deleted_process_comment boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
	-- official
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_official v where v.id_official = _id_official);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_official||' de la tabla official no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- process
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_process v where v.id_process = _id_process);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_process||' de la tabla process no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- task
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_task v where v.id_task = _id_task);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_task||' de la tabla task no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- level
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_level v where v.id_level = _id_level);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_level||' de la tabla level no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_CURRENT_ID = (select nextval('business.serial_process_comment')-1);
	_COUNT = (select count(*) from business.view_process_comment t where t.id_process_comment = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from business.view_process_comment t where t.id_process_comment = _CURRENT_ID);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO business.process_comment(id_process_comment, id_official, id_process, id_task, id_level, value_process_comment, date_process_comment, deleted_process_comment) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6 ,$7 ,$8) RETURNING id_process_comment LOOP
				_RETURNING = _X.id_process_comment;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'process_comment',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el id_process_comment '||_id_process_comment||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla process_comment';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_process_comment'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_comment_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_process_comment_create(id_user_ numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _value_process_comment character varying, _date_process_comment timestamp without time zone, _deleted_process_comment boolean) OWNER TO app_nashor;

--
-- TOC entry 642 (class 1255 OID 21876)
-- Name: dml_process_comment_create_modified(numeric, numeric, numeric, numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_process_comment_create_modified(id_user_ numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric) RETURNS TABLE(id_process_comment numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, value_process_comment character varying, date_process_comment timestamp without time zone, deleted_process_comment boolean, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, number_task character varying, type_status_task business."TYPE_STATUS_TASK", date_task timestamp without time zone, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_process_comment_create_modified(id_user_ numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric) OWNER TO postgres;

--
-- TOC entry 555 (class 1255 OID 21723)
-- Name: dml_process_comment_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_process_comment_delete(id_user_ numeric, _id_process_comment numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_process_comment t where t.id_process_comment = _id_process_comment);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_process_comment t where t.id_process_comment = _id_process_comment and deleted_process_comment = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','process_comment', _id_process_comment));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE business.process_comment SET deleted_process_comment=true WHERE id_process_comment = _id_process_comment RETURNING id_process_comment LOOP
					_RETURNING = _X.id_process_comment;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'process_comment',_id_process_comment,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_process_comment||' no se encuentra registrado en la tabla process_comment';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_comment_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_process_comment_delete(id_user_ numeric, _id_process_comment numeric) OWNER TO app_nashor;

--
-- TOC entry 554 (class 1255 OID 21722)
-- Name: dml_process_comment_update(numeric, numeric, numeric, numeric, numeric, numeric, character varying, timestamp without time zone, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_process_comment_update(id_user_ numeric, _id_process_comment numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _value_process_comment character varying, _date_process_comment timestamp without time zone, _deleted_process_comment boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
	-- official
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_official v where v.id_official = _id_official);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_official||' de la tabla official no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- process
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_process v where v.id_process = _id_process);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_process||' de la tabla process no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- task
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_task v where v.id_task = _id_task);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_task||' de la tabla task no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- level
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_level v where v.id_level = _id_level);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_level||' de la tabla level no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_COUNT = (select count(*) from business.view_process_comment t where t.id_process_comment = _id_process_comment);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_process_comment t where t.id_process_comment = _id_process_comment and deleted_process_comment = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from business.view_process_comment t where t.id_process_comment = _id_process_comment and t.id_process_comment != _id_process_comment);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE business.process_comment SET id_official=$3, id_process=$4, id_task=$5, id_level=$6, value_process_comment=$7, date_process_comment=$8, deleted_process_comment=$9 WHERE id_process_comment=$2 RETURNING id_process_comment LOOP
					_RETURNING = _X.id_process_comment;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'process_comment',_id_process_comment,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el id_process_comment '||_id_process_comment||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_process_comment||' no se encuentra registrado en la tabla process_comment';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_comment_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_process_comment_update(id_user_ numeric, _id_process_comment numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _value_process_comment character varying, _date_process_comment timestamp without time zone, _deleted_process_comment boolean) OWNER TO app_nashor;

--
-- TOC entry 643 (class 1255 OID 21877)
-- Name: dml_process_comment_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, character varying, timestamp without time zone, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_process_comment_update_modified(id_user_ numeric, _id_process_comment numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _value_process_comment character varying, _date_process_comment timestamp without time zone, _deleted_process_comment boolean) RETURNS TABLE(id_process_comment numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, value_process_comment character varying, date_process_comment timestamp without time zone, deleted_process_comment boolean, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, number_task character varying, type_status_task business."TYPE_STATUS_TASK", date_task timestamp without time zone, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_process_comment_update_modified(id_user_ numeric, _id_process_comment numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _value_process_comment character varying, _date_process_comment timestamp without time zone, _deleted_process_comment boolean) OWNER TO postgres;

--
-- TOC entry 560 (class 1255 OID 21727)
-- Name: dml_process_control_create(numeric, numeric, numeric, numeric, numeric, numeric, text, timestamp without time zone, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_process_control_create(id_user_ numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _id_control numeric, _value_process_control text, _last_change_process_control timestamp without time zone, _deleted_process_control boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
	-- official
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_official v where v.id_official = _id_official);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_official||' de la tabla official no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- process
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_process v where v.id_process = _id_process);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_process||' de la tabla process no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- task
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_task v where v.id_task = _id_task);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_task||' de la tabla task no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- level
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_level v where v.id_level = _id_level);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_level||' de la tabla level no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- control
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_control v where v.id_control = _id_control);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_control||' de la tabla control no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_CURRENT_ID = (select nextval('business.serial_process_control')-1);
	_COUNT = (select count(*) from business.view_process_control t where t.id_process_control = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from business.view_process_control t where t.id_process_control = _CURRENT_ID);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO business.process_control(id_process_control, id_official, id_process, id_task, id_level, id_control, value_process_control, last_change_process_control, deleted_process_control) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6 ,$7 ,$8 ,$9) RETURNING id_process_control LOOP
				_RETURNING = _X.id_process_control;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'process_control',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el id_process_control '||_id_process_control||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla process_control';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_process_control'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_control_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_process_control_create(id_user_ numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _id_control numeric, _value_process_control text, _last_change_process_control timestamp without time zone, _deleted_process_control boolean) OWNER TO app_nashor;

--
-- TOC entry 640 (class 1255 OID 21874)
-- Name: dml_process_control_create_modified(numeric, numeric, numeric, numeric, numeric, numeric, text); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_process_control_create_modified(id_user_ numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _id_control numeric, _value_process_control text) RETURNS TABLE(id_process_control numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, id_control numeric, value_process_control text, last_change_process_control timestamp without time zone, deleted_process_control boolean, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, number_task character varying, type_status_task business."TYPE_STATUS_TASK", date_task timestamp without time zone, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, type_control business."TYPE_CONTROL", title_control character varying, form_name_control character varying, initial_value_control character varying, required_control boolean, min_length_control numeric, max_length_control numeric, placeholder_control character varying, spell_check_control boolean, options_control json, in_use boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_process_control_create_modified(id_user_ numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _id_control numeric, _value_process_control text) OWNER TO postgres;

--
-- TOC entry 562 (class 1255 OID 21729)
-- Name: dml_process_control_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_process_control_delete(id_user_ numeric, _id_process_control numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_process_control t where t.id_process_control = _id_process_control);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_process_control t where t.id_process_control = _id_process_control and deleted_process_control = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','process_control', _id_process_control));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE business.process_control SET deleted_process_control=true WHERE id_process_control = _id_process_control RETURNING id_process_control LOOP
					_RETURNING = _X.id_process_control;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'process_control',_id_process_control,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_process_control||' no se encuentra registrado en la tabla process_control';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_control_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_process_control_delete(id_user_ numeric, _id_process_control numeric) OWNER TO app_nashor;

--
-- TOC entry 561 (class 1255 OID 21728)
-- Name: dml_process_control_update(numeric, numeric, numeric, numeric, numeric, numeric, numeric, text, timestamp without time zone, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_process_control_update(id_user_ numeric, _id_process_control numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _id_control numeric, _value_process_control text, _last_change_process_control timestamp without time zone, _deleted_process_control boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
	-- official
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_official v where v.id_official = _id_official);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_official||' de la tabla official no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- process
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_process v where v.id_process = _id_process);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_process||' de la tabla process no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- task
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_task v where v.id_task = _id_task);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_task||' de la tabla task no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- level
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_level v where v.id_level = _id_level);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_level||' de la tabla level no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- control
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_control v where v.id_control = _id_control);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_control||' de la tabla control no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_COUNT = (select count(*) from business.view_process_control t where t.id_process_control = _id_process_control);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_process_control t where t.id_process_control = _id_process_control and deleted_process_control = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from business.view_process_control t where t.id_process_control = _id_process_control and t.id_process_control != _id_process_control);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE business.process_control SET id_official=$3, id_process=$4, id_task=$5, id_level=$6, id_control=$7, value_process_control=$8, last_change_process_control=$9, deleted_process_control=$10 WHERE id_process_control=$2 RETURNING id_process_control LOOP
					_RETURNING = _X.id_process_control;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'process_control',_id_process_control,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el id_process_control '||_id_process_control||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_process_control||' no se encuentra registrado en la tabla process_control';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_control_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_process_control_update(id_user_ numeric, _id_process_control numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _id_control numeric, _value_process_control text, _last_change_process_control timestamp without time zone, _deleted_process_control boolean) OWNER TO app_nashor;

--
-- TOC entry 641 (class 1255 OID 21875)
-- Name: dml_process_control_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, numeric, text, timestamp without time zone, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_process_control_update_modified(id_user_ numeric, _id_process_control numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _id_control numeric, _value_process_control text, _last_change_process_control timestamp without time zone, _deleted_process_control boolean) RETURNS TABLE(id_process_control numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, id_control numeric, value_process_control text, last_change_process_control timestamp without time zone, deleted_process_control boolean, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, number_task character varying, type_status_task business."TYPE_STATUS_TASK", date_task timestamp without time zone, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, type_control business."TYPE_CONTROL", title_control character varying, form_name_control character varying, initial_value_control character varying, required_control boolean, min_length_control numeric, max_length_control numeric, placeholder_control character varying, spell_check_control boolean, options_control json, in_use boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_process_control_update_modified(id_user_ numeric, _id_process_control numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _id_control numeric, _value_process_control text, _last_change_process_control timestamp without time zone, _deleted_process_control boolean) OWNER TO postgres;

--
-- TOC entry 536 (class 1255 OID 21700)
-- Name: dml_process_create(numeric, numeric, numeric, character varying, timestamp without time zone, boolean, boolean, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_process_create(id_user_ numeric, _id_official numeric, _id_flow_version numeric, _number_process character varying, _date_process timestamp without time zone, _generated_task boolean, _finalized_process boolean, _deleted_process boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
	-- official
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_official v where v.id_official = _id_official);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_official||' de la tabla official no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- flow_version
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_flow_version v where v.id_flow_version = _id_flow_version);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_flow_version||' de la tabla flow_version no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_CURRENT_ID = (select nextval('business.serial_process')-1);
	_COUNT = (select count(*) from business.view_process t where t.id_process = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from business.view_process t where t.number_process = _number_process);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO business.process(id_process, id_official, id_flow_version, number_process, date_process, generated_task, finalized_process, deleted_process) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6 ,$7 ,$8) RETURNING id_process LOOP
				_RETURNING = _X.id_process;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'process',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el number_process '||_number_process||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla process';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_process'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_process_create(id_user_ numeric, _id_official numeric, _id_flow_version numeric, _number_process character varying, _date_process timestamp without time zone, _generated_task boolean, _finalized_process boolean, _deleted_process boolean) OWNER TO app_nashor;

--
-- TOC entry 624 (class 1255 OID 21856)
-- Name: dml_process_create_modified(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_process_create_modified(id_user_ numeric, _id_flow numeric) RETURNS TABLE(id_process numeric, id_official numeric, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, deleted_process boolean, id_user numeric, id_area numeric, id_position numeric, number_flow_version numeric, status_flow_version boolean, creation_date_flow_version timestamp without time zone, id_flow numeric, name_flow character varying, description_flow character varying, acronym_flow character varying, acronym_task character varying, sequential_flow numeric)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_process_create_modified(id_user_ numeric, _id_flow numeric) OWNER TO postgres;

--
-- TOC entry 538 (class 1255 OID 21702)
-- Name: dml_process_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_process_delete(id_user_ numeric, _id_process numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_process t where t.id_process = _id_process);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_process t where t.id_process = _id_process and deleted_process = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','process', _id_process));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE business.process SET deleted_process=true WHERE id_process = _id_process RETURNING id_process LOOP
					_RETURNING = _X.id_process;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'process',_id_process,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_process||' no se encuentra registrado en la tabla process';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_process_delete(id_user_ numeric, _id_process numeric) OWNER TO app_nashor;

--
-- TOC entry 548 (class 1255 OID 21715)
-- Name: dml_process_item_create(numeric, numeric, numeric, numeric, numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_process_item_create(id_user_ numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _id_item numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
	-- official
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_official v where v.id_official = _id_official);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_official||' de la tabla official no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- process
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_process v where v.id_process = _id_process);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_process||' de la tabla process no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- task
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_task v where v.id_task = _id_task);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_task||' de la tabla task no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- level
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_level v where v.id_level = _id_level);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_level||' de la tabla level no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- item
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_item v where v.id_item = _id_item);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_item||' de la tabla item no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_CURRENT_ID = (select nextval('business.serial_process_item')-1);
	_COUNT = (select count(*) from business.view_process_item t where t.id_process_item = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		FOR _X IN INSERT INTO business.process_item(id_process_item, id_official, id_process, id_task, id_level, id_item) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6) RETURNING id_process_item LOOP
			_RETURNING = _X.id_process_item;
		END LOOP;
		
		IF (_RETURNING >= 1) THEN
			_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
				where cvuij.id_user = id_user_);
			
			IF (_SAVE_LOG) THEN
				_RESPONSE = (select * from core.dml_system_event_create(id_user_,'process_item',_CURRENT_ID,'CREATE', now()::timestamp, false));
				
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
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla process_item';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_process_item'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_item_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_process_item_create(id_user_ numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _id_item numeric) OWNER TO app_nashor;

--
-- TOC entry 632 (class 1255 OID 21867)
-- Name: dml_process_item_create_modified(numeric, numeric, numeric, numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_process_item_create_modified(id_user_ numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric) RETURNS TABLE(id_process_item numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, id_item numeric, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, number_task character varying, type_status_task business."TYPE_STATUS_TASK", date_task timestamp without time zone, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, id_item_category numeric, name_item character varying, description_item character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_process_item_create_modified(id_user_ numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric) OWNER TO postgres;

--
-- TOC entry 550 (class 1255 OID 21717)
-- Name: dml_process_item_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_process_item_delete(id_user_ numeric, _id_process_item numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_process_item t where t.id_process_item = _id_process_item);
		
	IF (_COUNT = 1) THEN
		_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','process_item', _id_process_item));
			
		IF (_COUNT_DEPENDENCY > 0) THEN
			_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		ELSE
			FOR _X IN DELETE FROM business.process_item WHERE id_process_item = _id_process_item RETURNING id_process_item LOOP
				_RETURNING = _X.id_process_item;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'process_item',_id_process_item,'DELETE', now()::timestamp, false));
					
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
		_EXCEPTION = 'El registro con id '||_id_process_item||' no se encuentra registrado en la tabla process_item';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_item_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_process_item_delete(id_user_ numeric, _id_process_item numeric) OWNER TO app_nashor;

--
-- TOC entry 634 (class 1255 OID 21869)
-- Name: dml_process_item_delete_modified(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_process_item_delete_modified(id_user_ numeric, _id_process_item numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_process_item_delete_modified(id_user_ numeric, _id_process_item numeric) OWNER TO postgres;

--
-- TOC entry 549 (class 1255 OID 21716)
-- Name: dml_process_item_update(numeric, numeric, numeric, numeric, numeric, numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_process_item_update(id_user_ numeric, _id_process_item numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _id_item numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_EXTERNALS_IDS NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN 
	-- official
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_official v where v.id_official = _id_official);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_official||' de la tabla official no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- process
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_process v where v.id_process = _id_process);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_process||' de la tabla process no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- task
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_task v where v.id_task = _id_task);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_task||' de la tabla task no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- level
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_level v where v.id_level = _id_level);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_level||' de la tabla level no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- item
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_item v where v.id_item = _id_item);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_item||' de la tabla item no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
 	_COUNT = (select count(*) from business.view_process_item t where t.id_process_item = _id_process_item);

	IF (_COUNT = 1) THEN
		FOR _X IN UPDATE business.process_item SET id_official=$3, id_process=$4, id_task=$5, id_level=$6, id_item=$7 WHERE id_process_item=$2 RETURNING id_process_item LOOP
			_RETURNING = _X.id_process_item;
		END LOOP;
			
		IF (_RETURNING >= 1) THEN
			_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
				where cvuij.id_user = id_user_);

			IF (_SAVE_LOG) THEN
				_RESPONSE = (select * from core.dml_system_event_create(id_user_,'process_item',_id_process_item,'UPDATE', now()::timestamp, false));
				
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
		_EXCEPTION = 'El registro con id '||_id_process_item||' no se encuentra registrado en la tabla process_item';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_item_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_process_item_update(id_user_ numeric, _id_process_item numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _id_item numeric) OWNER TO app_nashor;

--
-- TOC entry 633 (class 1255 OID 21868)
-- Name: dml_process_item_update_modified(numeric, numeric, numeric, numeric, numeric, numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_process_item_update_modified(id_user_ numeric, _id_process_item numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _id_item numeric) RETURNS TABLE(id_process_item numeric, id_official numeric, id_process numeric, id_task numeric, id_level numeric, id_item numeric, id_user numeric, id_area numeric, id_position numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, number_task character varying, type_status_task business."TYPE_STATUS_TASK", date_task timestamp without time zone, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, id_item_category numeric, name_item character varying, description_item character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_process_item_update_modified(id_user_ numeric, _id_process_item numeric, _id_official numeric, _id_process numeric, _id_task numeric, _id_level numeric, _id_item numeric) OWNER TO postgres;

--
-- TOC entry 537 (class 1255 OID 21701)
-- Name: dml_process_update(numeric, numeric, numeric, numeric, character varying, timestamp without time zone, boolean, boolean, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_process_update(id_user_ numeric, _id_process numeric, _id_official numeric, _id_flow_version numeric, _number_process character varying, _date_process timestamp without time zone, _generated_task boolean, _finalized_process boolean, _deleted_process boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
	-- official
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_official v where v.id_official = _id_official);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_official||' de la tabla official no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- flow_version
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_flow_version v where v.id_flow_version = _id_flow_version);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_flow_version||' de la tabla flow_version no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_COUNT = (select count(*) from business.view_process t where t.id_process = _id_process);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_process t where t.id_process = _id_process and deleted_process = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from business.view_process t where t.number_process = _number_process and t.id_process != _id_process);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE business.process SET id_official=$3, id_flow_version=$4, number_process=$5, date_process=$6, generated_task=$7, finalized_process=$8, deleted_process=$9 WHERE id_process=$2 RETURNING id_process LOOP
					_RETURNING = _X.id_process;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'process',_id_process,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el number_process '||_number_process||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_process||' no se encuentra registrado en la tabla process';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_process_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_process_update(id_user_ numeric, _id_process numeric, _id_official numeric, _id_flow_version numeric, _number_process character varying, _date_process timestamp without time zone, _generated_task boolean, _finalized_process boolean, _deleted_process boolean) OWNER TO app_nashor;

--
-- TOC entry 626 (class 1255 OID 21860)
-- Name: dml_process_update_finalized_process(numeric, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_process_update_finalized_process(_id_process numeric, _finalized_process boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RETURNING NUMERIC;
	_X RECORD;
BEGIN
	FOR _X IN UPDATE business.process SET finalized_process = _finalized_process WHERE id_process = _id_process RETURNING id_process LOOP
		_RETURNING = _X.id_process;
	END LOOP;

	IF (_RETURNING >= 1) THEN
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
			 
$$;


ALTER FUNCTION business.dml_process_update_finalized_process(_id_process numeric, _finalized_process boolean) OWNER TO postgres;

--
-- TOC entry 625 (class 1255 OID 21859)
-- Name: dml_process_update_modified(numeric, numeric, numeric, numeric, character varying, timestamp without time zone, boolean, boolean, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_process_update_modified(id_user_ numeric, _id_process numeric, _id_official numeric, _id_flow_version numeric, _number_process character varying, _date_process timestamp without time zone, _generated_task boolean, _finalized_process boolean, _deleted_process boolean) RETURNS TABLE(id_process numeric, id_official numeric, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, deleted_process boolean, id_user numeric, id_area numeric, id_position numeric, number_flow_version numeric, status_flow_version boolean, creation_date_flow_version timestamp without time zone, id_flow numeric, name_flow character varying, description_flow character varying, acronym_flow character varying, acronym_task character varying, sequential_flow numeric)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_process_update_modified(id_user_ numeric, _id_process numeric, _id_official numeric, _id_flow_version numeric, _number_process character varying, _date_process timestamp without time zone, _generated_task boolean, _finalized_process boolean, _deleted_process boolean) OWNER TO postgres;

--
-- TOC entry 627 (class 1255 OID 21718)
-- Name: dml_task_create(numeric, numeric, numeric, numeric, character varying, business."TYPE_STATUS_TASK", timestamp without time zone, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_task_create(id_user_ numeric, _id_process numeric, _id_official numeric, _id_level numeric, _number_task character varying, _type_status_task business."TYPE_STATUS_TASK", _date_task timestamp without time zone, _deleted_task boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
$_$;


ALTER FUNCTION business.dml_task_create(id_user_ numeric, _id_process numeric, _id_official numeric, _id_level numeric, _number_task character varying, _type_status_task business."TYPE_STATUS_TASK", _date_task timestamp without time zone, _deleted_task boolean) OWNER TO postgres;

--
-- TOC entry 628 (class 1255 OID 21861)
-- Name: dml_task_create_modified(numeric, numeric, numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_task_create_modified(id_user_ numeric, _id_process numeric, _id_official numeric, _id_level numeric) RETURNS TABLE(id_task numeric, id_process numeric, id_official numeric, id_level numeric, number_task character varying, type_status_task business."TYPE_STATUS_TASK", date_task timestamp without time zone, deleted_task boolean, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, id_user numeric, id_area numeric, id_position numeric, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, id_flow numeric, number_flow_version numeric, status_flow_version boolean, creation_date_flow_version timestamp without time zone, id_company numeric, name_flow character varying, description_flow character varying, acronym_flow character varying, acronym_task character varying, sequential_flow numeric)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_task_create_modified(id_user_ numeric, _id_process numeric, _id_official numeric, _id_level numeric) OWNER TO postgres;

--
-- TOC entry 552 (class 1255 OID 21720)
-- Name: dml_task_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_task_delete(id_user_ numeric, _id_task numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_task t where t.id_task = _id_task);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_task t where t.id_task = _id_task and deleted_task = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','task', _id_task));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE business.task SET deleted_task=true WHERE id_task = _id_task RETURNING id_task LOOP
					_RETURNING = _X.id_task;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'task',_id_task,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_task||' no se encuentra registrado en la tabla task';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_task_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_task_delete(id_user_ numeric, _id_task numeric) OWNER TO app_nashor;

--
-- TOC entry 630 (class 1255 OID 21863)
-- Name: dml_task_reasign(numeric, numeric, numeric, numeric, numeric, character varying, business."TYPE_STATUS_TASK", timestamp without time zone, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_task_reasign(id_user_ numeric, _id_task numeric, _id_process numeric, _id_official numeric, _id_level numeric, _number_task character varying, _type_status_task business."TYPE_STATUS_TASK", _date_task timestamp without time zone, _deleted_task boolean) RETURNS TABLE(id_task numeric, id_process numeric, id_official numeric, id_level numeric, number_task character varying, type_status_task business."TYPE_STATUS_TASK", date_task timestamp without time zone, deleted_task boolean, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, id_user numeric, id_area numeric, id_position numeric, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, id_flow numeric, number_flow_version numeric, status_flow_version boolean, creation_date_flow_version timestamp without time zone, id_company numeric, name_flow character varying, description_flow character varying, acronym_flow character varying, acronym_task character varying, sequential_flow numeric)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_task_reasign(id_user_ numeric, _id_task numeric, _id_process numeric, _id_official numeric, _id_level numeric, _number_task character varying, _type_status_task business."TYPE_STATUS_TASK", _date_task timestamp without time zone, _deleted_task boolean) OWNER TO postgres;

--
-- TOC entry 631 (class 1255 OID 21864)
-- Name: dml_task_send(numeric, numeric, numeric, numeric, numeric, character varying, business."TYPE_STATUS_TASK", timestamp without time zone, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_task_send(id_user_ numeric, _id_task numeric, _id_process numeric, _id_official numeric, _id_level numeric, _number_task character varying, _type_status_task business."TYPE_STATUS_TASK", _date_task timestamp without time zone, _deleted_task boolean) RETURNS TABLE(id_task numeric, id_process numeric, id_official numeric, id_level numeric, number_task character varying, type_status_task business."TYPE_STATUS_TASK", date_task timestamp without time zone, deleted_task boolean, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, id_user numeric, id_area numeric, id_position numeric, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, id_flow numeric, number_flow_version numeric, status_flow_version boolean, creation_date_flow_version timestamp without time zone, id_company numeric, name_flow character varying, description_flow character varying, acronym_flow character varying, acronym_task character varying, sequential_flow numeric)
    LANGUAGE plpgsql
    AS $$
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
	_FINALIZED_PROCESS BOOLEAN;
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
						RAISE NOTICE '%', _VALUE_PROCESS_CONTROL;
						RAISE NOTICE '%', _VALUE_AGAINST_NEXT_LEVEL;
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
							_POSITION_LEVEL_NEXT_LEVEL = (select bvfvl.id_level from business.view_flow_version_level bvfvl where bvfvl.position_level_father = _POSITION_LEVEL_NEXT_LEVEL and bvfvl.option_true = false);						

							-- Obtener el perfil del nivel de acuerdo al nivel
							_LEVEL_PROFILE_NEXT_LEVEL = (select bvl.id_level_profile from business.view_level bvl where bvl.id_level = _POSITION_LEVEL_NEXT_LEVEL);

							-- Obtener el funcionario de acuerdo al perfil del nivel (Se selecciona el funcionario que tenga menos tareas)								
							_OFFICIAL_NEXT_LEVEL =  (select bvlpoij.id_official from business.view_level_profile_official_inner_join bvlpoij where bvlpoij.id_level_profile = _LEVEL_PROFILE_NEXT_LEVEL order by bvlpoij.number_task asc limit 1);
							
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
						END IF;
					ELSE
						-- IS OPERATOR DISTINCT ==
						_EXCEPTION = 'IS OPERATOR DISTINCT ==';
						RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';	
					END IF;
				ELSE
					-- IS FINISH
					--_EXCEPTION = 'IS FINISH';
					--RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
					
					_FINALIZED_PROCESS = (select * from business.process_update_finalized_process(_id_process, true));
					
					IF (_FINALIZED_PROCESS) THEN
						RETURN QUERY select * from business.view_task_inner_join bvtij 
							where bvtij.id_task = _id_task;
					ELSE
						_EXCEPTION = 'Ocurrió un error al actualizar finalized_process';
						RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
					END IF;
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
$$;


ALTER FUNCTION business.dml_task_send(id_user_ numeric, _id_task numeric, _id_process numeric, _id_official numeric, _id_level numeric, _number_task character varying, _type_status_task business."TYPE_STATUS_TASK", _date_task timestamp without time zone, _deleted_task boolean) OWNER TO postgres;

--
-- TOC entry 551 (class 1255 OID 21719)
-- Name: dml_task_update(numeric, numeric, numeric, numeric, numeric, character varying, business."TYPE_STATUS_TASK", timestamp without time zone, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_task_update(id_user_ numeric, _id_task numeric, _id_process numeric, _id_official numeric, _id_level numeric, _number_task character varying, _type_status_task business."TYPE_STATUS_TASK", _date_task timestamp without time zone, _deleted_task boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
			
	_COUNT = (select count(*) from business.view_task t where t.id_task = _id_task);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_task t where t.id_task = _id_task and deleted_task = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from business.view_task t where t.id_task = _id_task and t.id_task != _id_task);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE business.task SET id_process=$3, id_official=$4, id_level=$5, number_task=$6, type_status_task=$7, date_task=$8, deleted_task=$9 WHERE id_task=$2 RETURNING id_task LOOP
					_RETURNING = _X.id_task;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'task',_id_task,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el id_task '||_id_task||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_task||' no se encuentra registrado en la tabla task';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_task_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_task_update(id_user_ numeric, _id_task numeric, _id_process numeric, _id_official numeric, _id_level numeric, _number_task character varying, _type_status_task business."TYPE_STATUS_TASK", _date_task timestamp without time zone, _deleted_task boolean) OWNER TO app_nashor;

--
-- TOC entry 629 (class 1255 OID 21862)
-- Name: dml_task_update_modified(numeric, numeric, numeric, numeric, numeric, character varying, business."TYPE_STATUS_TASK", timestamp without time zone, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_task_update_modified(id_user_ numeric, _id_task numeric, _id_process numeric, _id_official numeric, _id_level numeric, _number_task character varying, _type_status_task business."TYPE_STATUS_TASK", _date_task timestamp without time zone, _deleted_task boolean) RETURNS TABLE(id_task numeric, id_process numeric, id_official numeric, id_level numeric, number_task character varying, type_status_task business."TYPE_STATUS_TASK", date_task timestamp without time zone, deleted_task boolean, id_flow_version numeric, number_process character varying, date_process timestamp without time zone, generated_task boolean, finalized_process boolean, id_user numeric, id_area numeric, id_position numeric, id_template numeric, id_level_profile numeric, id_level_status numeric, name_level character varying, description_level character varying, id_flow numeric, number_flow_version numeric, status_flow_version boolean, creation_date_flow_version timestamp without time zone, id_company numeric, name_flow character varying, description_flow character varying, acronym_flow character varying, acronym_task character varying, sequential_flow numeric)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_task_update_modified(id_user_ numeric, _id_task numeric, _id_process numeric, _id_official numeric, _id_level numeric, _number_task character varying, _type_status_task business."TYPE_STATUS_TASK", _date_task timestamp without time zone, _deleted_task boolean) OWNER TO postgres;

--
-- TOC entry 539 (class 1255 OID 21703)
-- Name: dml_template_control_create(numeric, numeric, numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_template_control_create(id_user_ numeric, _id_template numeric, _id_control numeric, _ordinal_position numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
	-- template
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_template v where v.id_template = _id_template);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_template||' de la tabla template no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- control
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_control v where v.id_control = _id_control);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_control||' de la tabla control no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_CURRENT_ID = (select nextval('business.serial_template_control')-1);
	_COUNT = (select count(*) from business.view_template_control t where t.id_template_control = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		FOR _X IN INSERT INTO business.template_control(id_template_control, id_template, id_control, ordinal_position) VALUES (_CURRENT_ID, $2 ,$3 ,$4) RETURNING id_template_control LOOP
			_RETURNING = _X.id_template_control;
		END LOOP;
		
		IF (_RETURNING >= 1) THEN
			_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
				where cvuij.id_user = id_user_);
			
			IF (_SAVE_LOG) THEN
				_RESPONSE = (select * from core.dml_system_event_create(id_user_,'template_control',_CURRENT_ID,'CREATE', now()::timestamp, false));
				
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
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla template_control';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_template_control'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_template_control_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_template_control_create(id_user_ numeric, _id_template numeric, _id_control numeric, _ordinal_position numeric) OWNER TO app_nashor;

--
-- TOC entry 597 (class 1255 OID 21830)
-- Name: dml_template_control_create_modified(numeric, numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_template_control_create_modified(id_user_ numeric, _id_template numeric, _id_control numeric) RETURNS TABLE(id_template_control numeric, id_template numeric, id_control numeric, ordinal_position numeric, id_documentation_profile numeric, id_plugin_item numeric, plugin_attached_process boolean, plugin_item_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, type_control business."TYPE_CONTROL", title_control character varying, form_name_control character varying, initial_value_control character varying, required_control boolean, min_length_control numeric, max_length_control numeric, placeholder_control character varying, spell_check_control boolean, options_control json, in_use boolean, id_company numeric)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_template_control_create_modified(id_user_ numeric, _id_template numeric, _id_control numeric) OWNER TO postgres;

--
-- TOC entry 598 (class 1255 OID 21831)
-- Name: dml_template_control_create_with_new_control(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_template_control_create_with_new_control(id_user_ numeric, _id_template numeric) RETURNS TABLE(id_template_control numeric, id_template numeric, id_control numeric, ordinal_position numeric, id_documentation_profile numeric, id_plugin_item numeric, plugin_attached_process boolean, plugin_item_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, type_control business."TYPE_CONTROL", title_control character varying, form_name_control character varying, initial_value_control character varying, required_control boolean, min_length_control numeric, max_length_control numeric, placeholder_control character varying, spell_check_control boolean, options_control json, in_use boolean, id_company numeric)
    LANGUAGE plpgsql
    AS $$
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
			
$$;


ALTER FUNCTION business.dml_template_control_create_with_new_control(id_user_ numeric, _id_template numeric) OWNER TO postgres;

--
-- TOC entry 602 (class 1255 OID 21705)
-- Name: dml_template_control_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_template_control_delete(id_user_ numeric, _id_template_control numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
			 
$$;


ALTER FUNCTION business.dml_template_control_delete(id_user_ numeric, _id_template_control numeric) OWNER TO postgres;

--
-- TOC entry 603 (class 1255 OID 21836)
-- Name: dml_template_control_delete_modified(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_template_control_delete_modified(id_user_ numeric, _id_template_control numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
			 
$$;


ALTER FUNCTION business.dml_template_control_delete_modified(id_user_ numeric, _id_template_control numeric) OWNER TO postgres;

--
-- TOC entry 540 (class 1255 OID 21704)
-- Name: dml_template_control_update(numeric, numeric, numeric, numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_template_control_update(id_user_ numeric, _id_template_control numeric, _id_template numeric, _id_control numeric, _ordinal_position numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_EXTERNALS_IDS NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN 
	-- template
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_template v where v.id_template = _id_template);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_template||' de la tabla template no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- control
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_control v where v.id_control = _id_control);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_control||' de la tabla control no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
 	_COUNT = (select count(*) from business.view_template_control t where t.id_template_control = _id_template_control);

	IF (_COUNT = 1) THEN
		FOR _X IN UPDATE business.template_control SET id_template=$3, id_control=$4, ordinal_position=$5 WHERE id_template_control=$2 RETURNING id_template_control LOOP
			_RETURNING = _X.id_template_control;
		END LOOP;
			
		IF (_RETURNING >= 1) THEN
			_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
				where cvuij.id_user = id_user_);

			IF (_SAVE_LOG) THEN
				_RESPONSE = (select * from core.dml_system_event_create(id_user_,'template_control',_id_template_control,'UPDATE', now()::timestamp, false));
				
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
		_EXCEPTION = 'El registro con id '||_id_template_control||' no se encuentra registrado en la tabla template_control';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_template_control_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_template_control_update(id_user_ numeric, _id_template_control numeric, _id_template numeric, _id_control numeric, _ordinal_position numeric) OWNER TO app_nashor;

--
-- TOC entry 600 (class 1255 OID 21834)
-- Name: dml_template_control_update_control_properties_modified(numeric, numeric, numeric, numeric, numeric, numeric, business."TYPE_CONTROL", character varying, character varying, character varying, boolean, numeric, numeric, character varying, boolean, json, boolean, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_template_control_update_control_properties_modified(id_user_ numeric, _id_template_control numeric, _id_template numeric, _id_control numeric, _ordinal_position numeric, _id_company numeric, _type_control business."TYPE_CONTROL", _title_control character varying, _form_name_control character varying, _initial_value_control character varying, _required_control boolean, _min_length_control numeric, _max_length_control numeric, _placeholder_control character varying, _spell_check_control boolean, _options_control json, _in_use boolean, _deleted_control boolean) RETURNS TABLE(id_template_control numeric, id_template numeric, id_control numeric, ordinal_position numeric, id_documentation_profile numeric, id_plugin_item numeric, plugin_attached_process boolean, plugin_item_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, type_control business."TYPE_CONTROL", title_control character varying, form_name_control character varying, initial_value_control character varying, required_control boolean, min_length_control numeric, max_length_control numeric, placeholder_control character varying, spell_check_control boolean, options_control json, in_use boolean, id_company numeric)
    LANGUAGE plpgsql
    AS $$
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
			 
$$;


ALTER FUNCTION business.dml_template_control_update_control_properties_modified(id_user_ numeric, _id_template_control numeric, _id_template numeric, _id_control numeric, _ordinal_position numeric, _id_company numeric, _type_control business."TYPE_CONTROL", _title_control character varying, _form_name_control character varying, _initial_value_control character varying, _required_control boolean, _min_length_control numeric, _max_length_control numeric, _placeholder_control character varying, _spell_check_control boolean, _options_control json, _in_use boolean, _deleted_control boolean) OWNER TO postgres;

--
-- TOC entry 530 (class 1255 OID 21837)
-- Name: dml_template_control_update_ordinal_position(numeric, numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_template_control_update_ordinal_position(id_user_ numeric, _id_template_control numeric, _ordinal_position numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
			 
$$;


ALTER FUNCTION business.dml_template_control_update_ordinal_position(id_user_ numeric, _id_template_control numeric, _ordinal_position numeric) OWNER TO postgres;

--
-- TOC entry 601 (class 1255 OID 21835)
-- Name: dml_template_control_update_positions(numeric, numeric, json); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_template_control_update_positions(id_user_ numeric, _id_template numeric, _template_control json) RETURNS TABLE(id_template_control numeric, id_template numeric, id_control numeric, ordinal_position numeric, id_documentation_profile numeric, id_plugin_item numeric, plugin_attached_process boolean, plugin_item_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, type_control business."TYPE_CONTROL", title_control character varying, form_name_control character varying, initial_value_control character varying, required_control boolean, min_length_control numeric, max_length_control numeric, placeholder_control character varying, spell_check_control boolean, options_control json, in_use boolean, id_company numeric)
    LANGUAGE plpgsql
    AS $$
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
			 
$$;


ALTER FUNCTION business.dml_template_control_update_positions(id_user_ numeric, _id_template numeric, _template_control json) OWNER TO postgres;

--
-- TOC entry 502 (class 1255 OID 21667)
-- Name: dml_template_create(numeric, numeric, numeric, numeric, boolean, boolean, character varying, character varying, boolean, timestamp without time zone, boolean, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_template_create(id_user_ numeric, _id_company numeric, _id_documentation_profile numeric, _id_plugin_item numeric, _plugin_attached_process boolean, _plugin_item_process boolean, _name_template character varying, _description_template character varying, _status_template boolean, _last_change timestamp without time zone, _in_use boolean, _deleted_template boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
			 
	-- documentation_profile
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_documentation_profile v where v.id_documentation_profile = _id_documentation_profile);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_documentation_profile||' de la tabla documentation_profile no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- plugin_item
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_plugin_item v where v.id_plugin_item = _id_plugin_item);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_plugin_item||' de la tabla plugin_item no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_CURRENT_ID = (select nextval('business.serial_template')-1);
	_COUNT = (select count(*) from business.view_template t where t.id_template = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from business.view_template t where t.name_template = _name_template);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO business.template(id_template, id_company, id_documentation_profile, id_plugin_item, plugin_attached_process, plugin_item_process, name_template, description_template, status_template, last_change, in_use, deleted_template) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6 ,$7 ,$8 ,$9 ,$10 ,$11 ,$12) RETURNING id_template LOOP
				_RETURNING = _X.id_template;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'template',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el name_template '||_name_template||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla template';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''business.serial_template'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_template_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_template_create(id_user_ numeric, _id_company numeric, _id_documentation_profile numeric, _id_plugin_item numeric, _plugin_attached_process boolean, _plugin_item_process boolean, _name_template character varying, _description_template character varying, _status_template boolean, _last_change timestamp without time zone, _in_use boolean, _deleted_template boolean) OWNER TO app_nashor;

--
-- TOC entry 595 (class 1255 OID 21827)
-- Name: dml_template_create_modified(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_template_create_modified(id_user_ numeric, _id_company numeric) RETURNS TABLE(id_template numeric, id_company numeric, id_documentation_profile numeric, id_plugin_item numeric, plugin_attached_process boolean, plugin_item_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, in_use boolean, deleted_template boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, name_documentation_profile character varying, description_documentation_profile character varying, status_documentation_profile boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_template_create_modified(id_user_ numeric, _id_company numeric) OWNER TO postgres;

--
-- TOC entry 504 (class 1255 OID 21669)
-- Name: dml_template_delete(numeric, numeric); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_template_delete(id_user_ numeric, _id_template numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from business.view_template t where t.id_template = _id_template);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_template t where t.id_template = _id_template and deleted_template = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('business','template', _id_template));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE business.template SET deleted_template=true WHERE id_template = _id_template RETURNING id_template LOOP
					_RETURNING = _X.id_template;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'template',_id_template,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_template||' no se encuentra registrado en la tabla template';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_template_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION business.dml_template_delete(id_user_ numeric, _id_template numeric) OWNER TO app_nashor;

--
-- TOC entry 596 (class 1255 OID 21829)
-- Name: dml_template_delete_modified(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_template_delete_modified(id_user_ numeric, _id_template numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_template_delete_modified(id_user_ numeric, _id_template numeric) OWNER TO postgres;

--
-- TOC entry 503 (class 1255 OID 21668)
-- Name: dml_template_update(numeric, numeric, numeric, numeric, numeric, boolean, boolean, character varying, character varying, boolean, timestamp without time zone, boolean, boolean); Type: FUNCTION; Schema: business; Owner: app_nashor
--

CREATE FUNCTION business.dml_template_update(id_user_ numeric, _id_template numeric, _id_company numeric, _id_documentation_profile numeric, _id_plugin_item numeric, _plugin_attached_process boolean, _plugin_item_process boolean, _name_template character varying, _description_template character varying, _status_template boolean, _last_change timestamp without time zone, _in_use boolean, _deleted_template boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
			 
	-- documentation_profile
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_documentation_profile v where v.id_documentation_profile = _id_documentation_profile);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_documentation_profile||' de la tabla documentation_profile no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- plugin_item
	_COUNT_EXTERNALS_IDS = (select count(*) from business.view_plugin_item v where v.id_plugin_item = _id_plugin_item);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_plugin_item||' de la tabla plugin_item no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_COUNT = (select count(*) from business.view_template t where t.id_template = _id_template);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from business.view_template t where t.id_template = _id_template and deleted_template = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from business.view_template t where t.name_template = _name_template and t.id_template != _id_template);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE business.template SET id_company=$3, id_documentation_profile=$4, id_plugin_item=$5, plugin_attached_process=$6, plugin_item_process=$7, name_template=$8, description_template=$9, status_template=$10, last_change=$11, in_use=$12, deleted_template=$13 WHERE id_template=$2 RETURNING id_template LOOP
					_RETURNING = _X.id_template;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'template',_id_template,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el name_template '||_name_template||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_template||' no se encuentra registrado en la tabla template';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_template_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION business.dml_template_update(id_user_ numeric, _id_template numeric, _id_company numeric, _id_documentation_profile numeric, _id_plugin_item numeric, _plugin_attached_process boolean, _plugin_item_process boolean, _name_template character varying, _description_template character varying, _status_template boolean, _last_change timestamp without time zone, _in_use boolean, _deleted_template boolean) OWNER TO app_nashor;

--
-- TOC entry 442 (class 1255 OID 21832)
-- Name: dml_template_update_last_change(numeric, numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_template_update_last_change(id_user_ numeric, _id_template numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
			 
$$;


ALTER FUNCTION business.dml_template_update_last_change(id_user_ numeric, _id_template numeric) OWNER TO postgres;

--
-- TOC entry 637 (class 1255 OID 21828)
-- Name: dml_template_update_modified(numeric, numeric, numeric, numeric, numeric, boolean, boolean, character varying, character varying, boolean, timestamp without time zone, boolean, boolean); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.dml_template_update_modified(id_user_ numeric, _id_template numeric, _id_company numeric, _id_documentation_profile numeric, _id_plugin_item numeric, _plugin_attached_process boolean, _plugin_item_process boolean, _name_template character varying, _description_template character varying, _status_template boolean, _last_change timestamp without time zone, _in_use boolean, _deleted_template boolean) RETURNS TABLE(id_template numeric, id_company numeric, id_documentation_profile numeric, id_plugin_item numeric, plugin_attached_process boolean, plugin_item_process boolean, name_template character varying, description_template character varying, status_template boolean, last_change timestamp without time zone, in_use boolean, deleted_template boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, name_documentation_profile character varying, description_documentation_profile character varying, status_documentation_profile boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION business.dml_template_update_modified(id_user_ numeric, _id_template numeric, _id_company numeric, _id_documentation_profile numeric, _id_plugin_item numeric, _plugin_attached_process boolean, _plugin_item_process boolean, _name_template character varying, _description_template character varying, _status_template boolean, _last_change timestamp without time zone, _in_use boolean, _deleted_template boolean) OWNER TO postgres;

--
-- TOC entry 423 (class 1255 OID 21798)
-- Name: validation_flow_version(numeric); Type: FUNCTION; Schema: business; Owner: postgres
--

CREATE FUNCTION business.validation_flow_version(_id_flow_version numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
			 
$$;


ALTER FUNCTION business.validation_flow_version(_id_flow_version numeric) OWNER TO postgres;

--
-- TOC entry 428 (class 1255 OID 21177)
-- Name: auth_check_session(numeric, json); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.auth_check_session(_id_session numeric, _agent_session json) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_STATUS_SESSION BOOLEAN;
	_HOST CHARACTER VARYING;
	_BROWSER CHARACTER VARYING;
	_VERSION CHARACTER VARYING;
	_OS CHARACTER VARYING;
	_PLATFORM CHARACTER VARYING;
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN
	_STATUS_SESSION = (select cvs.status_session from core.view_session cvs where cvs.id_session = _id_session);
	
	_HOST = (select cvs.host_session from core.view_session cvs where cvs.id_session = _id_session);
	_BROWSER = (select (select cvs.agent_session from core.view_session cvs where cvs.id_session = _id_session)->>'browser');
	_VERSION = (select (select cvs.agent_session from core.view_session cvs where cvs.id_session = _id_session)->>'version');
	_OS = (select (select cvs.agent_session from core.view_session cvs where cvs.id_session = _id_session)->>'os');
	_PLATFORM = (select (select cvs.agent_session from core.view_session cvs where cvs.id_session = _id_session)->>'platform');
	
	IF (_STATUS_SESSION) THEN
		
		IF (_HOST = _agent_session->>'host') THEN
			
			IF (_BROWSER = _agent_session->'agent'->>'browser') THEN
				
				IF (_VERSION = _agent_session->'agent'->>'version') THEN
					
					IF (_OS = _agent_session->'agent'->>'os') THEN
						
						IF (_PLATFORM = _agent_session->'agent'->>'platform') THEN
							RETURN true;
						ELSE
							_EXCEPTION = 'EL platform del agent es incorrecto';
							RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
						END IF;
					ELSE
						_EXCEPTION = 'El SO del agent es incorrecto';
						RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
					END IF;
				ELSE
					_EXCEPTION = 'La version del agent es incorrecto';
					RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
				END IF;
			ELSE
				_EXCEPTION = 'El browser del agent es incorrecto';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
			END IF;
		ELSE
			_EXCEPTION = 'El host de la sesión es incorrecto';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
		END IF;
	ELSE
		_EXCEPTION = 'La sesión se encuentra cerrada';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
	END IF;
END;
-- select * from core.auth_check_session(11, '{"host":"172.18.2.3:3000","agent":{"browser":"Chrome","version":"98.0.4758.102","os":"Windows 10.0","platform":"Microsoft Windows","source":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36"}}')
$$;


ALTER FUNCTION core.auth_check_session(_id_session numeric, _agent_session json) OWNER TO postgres;

--
-- TOC entry 425 (class 1255 OID 21174)
-- Name: auth_check_user(character varying); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.auth_check_user(_name_user character varying) RETURNS TABLE(status_check_user boolean, _expiration_verification_code numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
	_COUNT_NAME_USER NUMERIC;
	_COUNT_PASSWORD_USER NUMERIC;
	_STATUS_USER BOOLEAN;
	_STATUS_COMPANY BOOLEAN;
	_STATUS_PROFILE BOOLEAN;
	_STATUS_TYPE_USER BOOLEAN;
	_NAME_TYPE_USER CHARACTER VARYING;
	_ID_COMPANY NUMERIC;
	_EXPIRATION_VERIFICATION_CODE NUMERIC;
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN
	-- Verificar que el usuario este registrado
	_COUNT_NAME_USER = (select count(*) from core.view_user cvu where cvu.name_user = _name_user);
	
	IF (_COUNT_NAME_USER >= 0) THEN
		-- Verificar el estado del usuario 
		_STATUS_USER = (select cvu.status_user from core.view_user cvu where cvu.name_user = _name_user);
		
		IF (_STATUS_USER) THEN
			-- Verificar el estado de la empresa del usuario				
			_STATUS_COMPANY = (select cvc.status_company from core.view_company cvc inner join core.view_user cvu on cvc.id_company = cvu.id_company where cvu.name_user = _name_user); 
			
			IF (_STATUS_COMPANY) THEN
				-- Verificar el estado del tipo de usuario				
				_STATUS_TYPE_USER = (select cvtu.status_type_user from core.view_type_user cvtu inner join core.view_user cvu on cvu.id_type_user = cvtu.id_type_user where cvu.name_user = _name_user);

				IF (_STATUS_TYPE_USER) THEN
					-- Verificar el estado del perfil				
					_STATUS_PROFILE = (select cvp.status_profile from core.view_profile cvp inner join core.view_type_user cvtu on cvp.id_profile = cvtu.id_profile inner join core.view_user cvu on cvtu.id_type_user = cvu.id_type_user where cvu.name_user = _name_user); 
					
					IF (_STATUS_PROFILE) THEN
						-- Obtener el id de la empresa
						_ID_COMPANY = (select cvc.id_company from core.view_company cvc inner join core.view_user cvu on cvc.id_company = cvu.id_company where cvu.name_user = _name_user);
						-- Obtener la configuración
						_EXPIRATION_VERIFICATION_CODE = (select cvs.expiration_verification_code from core.view_setting cvs inner join core.view_company cvc on cvc.id_setting = cvs.id_setting where cvc.id_company = _ID_COMPANY);
						-- Return query
						RETURN QUERY select true as status_check_user, _EXPIRATION_VERIFICATION_CODE as _expiration_verification_code;
					ELSE
						_EXCEPTION = 'El perfil del usuario '||_name_user||' se encuentra desactivado';
						RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
					END IF;
				ELSE
					_NAME_TYPE_USER = (select cvtu.name_type_user from core.view_type_user cvtu inner join core.view_user cvu on cvu.id_type_user = cvtu.id_type_user where cvu.name_user = _name_user);
					_EXCEPTION = 'El tipo de usuario '||_NAME_TYPE_USER||' se encuentra desactivado';
					RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
				END IF;
			ELSE
				_EXCEPTION = 'La empresa del usuario '||_name_user||' se encuentra desactivada';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
			END IF;
		ELSE
			_EXCEPTION = 'El usuario '||_name_user||' se encuentra desactivado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
		END IF;
	ELSE
		_EXCEPTION = 'El usuario '||_name_user||' no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
	END IF;
END;
-- select * from core.auth_check_user('alberto.aldas@gmail.com')
$$;


ALTER FUNCTION core.auth_check_user(_name_user character varying) OWNER TO postgres;

--
-- TOC entry 426 (class 1255 OID 21175)
-- Name: auth_reset_password(character varying, character varying); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.auth_reset_password(_name_user character varying, _new_password character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_COUNT_NAME_USER NUMERIC;
	_COUNT_PASSWORD_USER NUMERIC;
	_STATUS_USER BOOLEAN;
	_STATUS_COMPANY BOOLEAN;
	_STATUS_PROFILE BOOLEAN;
	_STATUS_RESET_PASSWORD BOOLEAN;
	_X RECORD;
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN
	-- Verificar que el usuario este registrado
	_COUNT_NAME_USER = (select count(*) from core.view_user cvu where cvu.name_user = _name_user);
	
	IF (_COUNT_NAME_USER >= 0) THEN
		-- Verificar el estado del usuario 
		_STATUS_USER = (select cvu.status_user from core.view_user cvu where cvu.name_user = _name_user);
		
		IF (_STATUS_USER) THEN
			-- Verificar el estado de la empresa del usuario				
			_STATUS_COMPANY = (select cvc.status_company from core.view_company cvc inner join core.view_user cvu on cvc.id_company = cvu.id_company where cvu.name_user = _name_user); 
			
			IF (_STATUS_COMPANY) THEN
				-- Verificar el estado del perfil				
				_STATUS_PROFILE = (select cvp.status_profile from core.view_profile cvp inner join core.view_type_user vtu on vtu.id_profile = cvp.id_profile inner join core.view_user cvu on vtu.id_type_user = cvu.id_type_user where cvu.name_user = _name_user); 
				
				IF (_STATUS_PROFILE) THEN
					FOR _X IN UPDATE core.user u SET password_user = _new_password WHERE u.name_user = _name_user returning true as status_reset_password LOOP
						_STATUS_RESET_PASSWORD = _X.status_reset_password;
					END LOOP;
					
					IF (_STATUS_RESET_PASSWORD) THEN
						RETURN _STATUS_RESET_PASSWORD;
					ELSE
						_EXCEPTION = 'Ocurrió un error al restablecer la contraseña del usuario '||_name_user||'';
						RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
					END IF;
				ELSE
					_EXCEPTION = 'El perfil del usuario '||_name_user||' se encuentra desactivado';
					RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
				END IF;
			ELSE
				_EXCEPTION = 'La empresa del usuario '||_name_user||' se encuentra desactivada';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
			END IF;
		ELSE
			_EXCEPTION = 'El usuario '||_name_user||' se encuentra desactivado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
		END IF;
	ELSE
		_EXCEPTION = 'El usuario '||_name_user||' no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
	END IF;
END;
-- select * from core.auth_reset_password('alberto.aldas@gmail.com', 'nuevacontraseña')
$$;


ALTER FUNCTION core.auth_reset_password(_name_user character varying, _new_password character varying) OWNER TO postgres;

--
-- TOC entry 422 (class 1255 OID 21171)
-- Name: auth_sign_in(character varying, character varying, character varying, json); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.auth_sign_in(_name_user character varying, _password_user character varying, _host_session character varying, _agent_session json) RETURNS TABLE(status_sign_in boolean, id_session numeric, id_user numeric, id_company numeric, id_person numeric, id_type_user numeric, name_user character varying, avatar_user character varying, status_user boolean, id_setting numeric, name_company character varying, status_company boolean, expiration_token numeric, inactivity_time numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_profile numeric, name_type_user character varying, description_type_user character varying, status_type_user boolean, type_profile core."TYPE_PROFILE", name_profile character varying, description_profile character varying, status_profile boolean, navigation json)
    LANGUAGE plpgsql
    AS $$
DECLARE
	_SESSION_LIMIT NUMERIC;
	_SESSION_COUNT NUMERIC;
	_COUNT_NAME_USER NUMERIC;
	_COUNT_PASSWORD_USER NUMERIC;
	_STATUS_USER BOOLEAN;
	_STATUS_COMPANY BOOLEAN;
	_STATUS_TYPE_USER BOOLEAN;
	_STATUS_PROFILE BOOLEAN;
	_NAME_TYPE_USER CHARACTER VARYING;
	_COUNT_NAVIGATION NUMERIC;
	_ID_USER NUMERIC;
	_ID_SESSION NUMERIC;
	_X RECORD;
	_NAVIGATION TEXT DEFAULT '';
	_NAV JSON;
	_EXCEPTION TEXT DEFAULT '';
BEGIN
	-- Verificar que el usuario no exceda las sesiones segun la configuración de la empresa
	_SESSION_LIMIT = (select cvs.session_limit from core.view_user cvu inner join core.view_company cvc on cvu.id_company = cvc.id_company inner join core.view_setting cvs on cvc.id_setting = cvs.id_setting where cvu.name_user = _name_user);
	_SESSION_COUNT = (select count(*) from core.view_session cvs inner join core.view_user cvu on cvs.id_user = cvu.id_user where cvu.name_user = _name_user and cvs.status_session = true);
	
	IF (_SESSION_COUNT >= _SESSION_LIMIT) THEN
		_EXCEPTION = 'Ha excedido el máximo de sesiones activas por usuario';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
	END IF;
	
	-- Verificar que el usuario este registrado
	_COUNT_NAME_USER = (select count(*) from core.view_user cvu where cvu.name_user = _name_user);
	
	IF (_COUNT_NAME_USER >= 1) THEN
		-- Verificar la contraseña del usuario
		_COUNT_PASSWORD_USER = (select count(*) from core.view_user cvu where cvu.name_user = _name_user and cvu.password_user = _password_user);
		
		IF (_COUNT_PASSWORD_USER >= 1) THEN
			-- Verificar el estado del usuario 
			_STATUS_USER = (select cvu.status_user from core.view_user cvu where cvu.name_user = _name_user);
			
			IF (_STATUS_USER) THEN
				-- Verificar el estado de la empresa del usuario				
				_STATUS_COMPANY = (select cvc.status_company from core.view_company cvc inner join core.view_user cvu on cvc.id_company = cvu.id_company where cvu.name_user = _name_user); 
				
				IF (_STATUS_COMPANY) THEN
					-- Verificar el estado del tipo de usuario				
					_STATUS_TYPE_USER = (select cvtu.status_type_user from core.view_type_user cvtu inner join core.view_user cvu on cvu.id_type_user = cvtu.id_type_user where cvu.name_user = _name_user);
					
					IF (_STATUS_TYPE_USER) THEN
						-- Verificar el estado del perfil				
						_STATUS_PROFILE = (select cvp.status_profile from core.view_profile cvp inner join core.view_type_user cvtu on cvp.id_profile = cvtu.id_profile inner join core.view_user cvu on cvtu.id_type_user = cvu.id_type_user where cvu.name_user = _name_user); 
						
						IF (_STATUS_PROFILE) THEN
							_COUNT_NAVIGATION = (select count(*) from core.view_navigation_inner_join_cvpn_cvp_cvtu_cvu cvnij
								where cvnij.name_user = _name_user and cvnij.status_navigation = true);

							IF (_COUNT_NAVIGATION >= 1) THEN
								-- OBTENER LA NAVEGACION DEL USUARIO LOGEADO DE ACUERDO A SU PERFIL DE USUARIO
								FOR _X IN select * from core.view_navigation_inner_join_cvpn_cvp_cvtu_cvu cvnij 
								where cvnij.name_user = _name_user and cvnij.status_navigation = true LOOP
									_NAVIGATION = _NAVIGATION || '"'||_X.type_navigation||'": '||_X.content_navigation||',';
								END LOOP;
								-- ELIMINAR ULTIMA ,
								-- RAISE NOTICE '%', _NAVIGATION;
								_NAVIGATION = (select substring(_NAVIGATION from 1 for (char_length(_NAVIGATION)-1)));
								-- TRANSFORMAR STRING TO JSON[]
								_NAV = '{'||_NAVIGATION||'}';
								-- RAISE NOTICE '%', _NAV; 
								-- RAISE NOTICE '%', _NAV->0; 
								-- RAISE NOTICE '%', _NAV->1; 

								_ID_USER = (select cvu.id_user from core.view_user cvu where cvu.name_user = _name_user);
								_ID_SESSION = (select * from core.dml_session_create(_ID_USER, _ID_USER, _host_session, _agent_session, now()::timestamp, now()::timestamp, true));

								RETURN QUERY select true as status_sign_in, _ID_SESSION as id_sesion, cvuij.*, _NAV from core.view_user_inner_join_cvc_cvs_cvp_cvtu_cvpro cvuij
									where cvuij.name_user = _name_user;
							ELSE
								_EXCEPTION = 'El usuario '||_name_user||' no tiene navegaciones activas en su perfil';
								RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
							END IF;
						ELSE
							_EXCEPTION = 'El perfil del usuario '||_name_user||' se encuentra desactivado';
							RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
						END IF;
					ELSE 
						_NAME_TYPE_USER = (select cvtu.name_type_user from core.view_type_user cvtu inner join core.view_user cvu on cvu.id_type_user = cvtu.id_type_user where cvu.name_user = _name_user);
						_EXCEPTION = 'El tipo de usuario '||_NAME_TYPE_USER||' se encuentra desactivado';
						RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
					END IF;
				ELSE
					_EXCEPTION = 'La empresa del usuario '||_name_user||' se encuentra desactivada';
					RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
				END IF;
			ELSE
				_EXCEPTION = 'El usuario '||_name_user||' se encuentra desactivado';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
			END IF;
		ELSE
			_EXCEPTION = 'La contraseña ingresada es incorrecta';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
		END IF;
	ELSE
		_EXCEPTION = 'El usuario '||_name_user||' no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
	END IF;
END;
	-- select * from  core.auth_sign_in('alberto.aldas@gmail.com', 'qd9HyK6TpiUzpuufxt/xAg==')
	-- select * from core.security_cap_aes_decrypt('qd9HyK6TpiUzpuufxt/xAg==')
$$;


ALTER FUNCTION core.auth_sign_in(_name_user character varying, _password_user character varying, _host_session character varying, _agent_session json) OWNER TO postgres;

--
-- TOC entry 427 (class 1255 OID 21176)
-- Name: auth_sign_out(character varying, numeric); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.auth_sign_out(_name_user character varying, _id_session numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_ID_USER NUMERIC;
	_RELEASE_SESSION boolean;
	_RESPONSE BOOLEAN;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN
	_ID_USER = (select cvu.id_user from core.view_user cvu where cvu.name_user = _name_user);
	_RELEASE_SESSION = (select * from core.dml_session_release(_id_session));
	
	IF (_RELEASE_SESSION) THEN
		_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.name_user = _name_user);

		IF (_SAVE_LOG) THEN
			_RESPONSE = (core.dml_system_event_create(_ID_USER,'session',_id_session,'singOut', now()::timestamp, false));
			IF (_RESPONSE != true) THEN
				_EXCEPTION = 'Ocurrió un error al registrar el evento del sistema';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
			END IF;
		END IF;
		RETURN true;
	ELSE
		_EXCEPTION = 'Ocurrió un error al cerrar la sessión';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
	END IF;
END;
$$;


ALTER FUNCTION core.auth_sign_out(_name_user character varying, _id_session numeric) OWNER TO postgres;

--
-- TOC entry 448 (class 1255 OID 21282)
-- Name: dml_academic_create(numeric, character varying, character varying, character varying, boolean); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_academic_create(id_user_ numeric, _title_academic character varying, _abbreviation_academic character varying, _level_academic character varying, _deleted_academic boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_RESPONSE BOOLEAN DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_ATT NUMERIC;
	_RETURNING NUMERIC;
	_CURRENT_ID NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_CURRENT_ID = (select nextval('core.serial_academic')-1);
	_COUNT = (select count(*) from core.view_academic t where t.id_academic = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from core.view_academic t where t.id_academic = _CURRENT_ID);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO core.academic(id_academic, title_academic, abbreviation_academic, level_academic, deleted_academic) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5) RETURNING id_academic LOOP
				_RETURNING = _X.id_academic;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'academic',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el id_academic '||_id_academic||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla academic';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''core.serial_academic'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_academic_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_academic_create(id_user_ numeric, _title_academic character varying, _abbreviation_academic character varying, _level_academic character varying, _deleted_academic boolean) OWNER TO app_nashor;

--
-- TOC entry 450 (class 1255 OID 21284)
-- Name: dml_academic_delete(numeric, numeric); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_academic_delete(id_user_ numeric, _id_academic numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from core.view_academic t where t.id_academic = _id_academic);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from core.view_academic t where t.id_academic = _id_academic and deleted_academic = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('core','academic', _id_academic));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE core.academic SET deleted_academic=true WHERE id_academic = _id_academic RETURNING id_academic LOOP
					_RETURNING = _X.id_academic;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'academic',_id_academic,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_academic||' no se encuentra registrado en la tabla academic';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_academic_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION core.dml_academic_delete(id_user_ numeric, _id_academic numeric) OWNER TO app_nashor;

--
-- TOC entry 449 (class 1255 OID 21283)
-- Name: dml_academic_update(numeric, numeric, character varying, character varying, character varying, boolean); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_academic_update(id_user_ numeric, _id_academic numeric, _title_academic character varying, _abbreviation_academic character varying, _level_academic character varying, _deleted_academic boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
	_COUNT = (select count(*) from core.view_academic t where t.id_academic = _id_academic);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from core.view_academic t where t.id_academic = _id_academic and deleted_academic = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from core.view_academic t where t.id_academic = _id_academic and t.id_academic != _id_academic);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE core.academic SET title_academic=$3, abbreviation_academic=$4, level_academic=$5, deleted_academic=$6 WHERE id_academic=$2 RETURNING id_academic LOOP
					_RETURNING = _X.id_academic;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'academic',_id_academic,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el id_academic '||_id_academic||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_academic||' no se encuentra registrado en la tabla academic';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_academic_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_academic_update(id_user_ numeric, _id_academic numeric, _title_academic character varying, _abbreviation_academic character varying, _level_academic character varying, _deleted_academic boolean) OWNER TO app_nashor;

--
-- TOC entry 435 (class 1255 OID 21270)
-- Name: dml_company_create(numeric, numeric, character varying, character varying, character varying, boolean, boolean); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_company_create(id_user_ numeric, _id_setting numeric, _name_company character varying, _acronym_company character varying, _address_company character varying, _status_company boolean, _deleted_company boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
	-- setting
	_COUNT_EXTERNALS_IDS = (select count(*) from core.view_setting v where v.id_setting = _id_setting);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_setting||' de la tabla setting no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_CURRENT_ID = (select nextval('core.serial_company')-1);
	_COUNT = (select count(*) from core.view_company t where t.id_company = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from core.view_company t where t.name_company = _name_company);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO core.company(id_company, id_setting, name_company, acronym_company, address_company, status_company, deleted_company) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6 ,$7) RETURNING id_company LOOP
				_RETURNING = _X.id_company;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'company',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el name_company '||_name_company||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla company';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''core.serial_company'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_company_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_company_create(id_user_ numeric, _id_setting numeric, _name_company character varying, _acronym_company character varying, _address_company character varying, _status_company boolean, _deleted_company boolean) OWNER TO app_nashor;

--
-- TOC entry 470 (class 1255 OID 21404)
-- Name: dml_company_create_modified(numeric); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.dml_company_create_modified(id_user_ numeric) RETURNS TABLE(id_company numeric, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, deleted_company boolean, expiration_token numeric, expiration_verification_code numeric, inactivity_time numeric, session_limit numeric, save_log boolean, save_file_alfresco boolean, modification_status boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION core.dml_company_create_modified(id_user_ numeric) OWNER TO postgres;

--
-- TOC entry 437 (class 1255 OID 21272)
-- Name: dml_company_delete(numeric, numeric); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_company_delete(id_user_ numeric, _id_company numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from core.view_company t where t.id_company = _id_company);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from core.view_company t where t.id_company = _id_company and deleted_company = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('core','company', _id_company));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE core.company SET deleted_company=true WHERE id_company = _id_company RETURNING id_company LOOP
					_RETURNING = _X.id_company;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'company',_id_company,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_company||' no se encuentra registrado en la tabla company';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_company_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION core.dml_company_delete(id_user_ numeric, _id_company numeric) OWNER TO app_nashor;

--
-- TOC entry 472 (class 1255 OID 21406)
-- Name: dml_company_delete_modified(numeric, numeric); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.dml_company_delete_modified(id_user_ numeric, _id_company numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION core.dml_company_delete_modified(id_user_ numeric, _id_company numeric) OWNER TO postgres;

--
-- TOC entry 436 (class 1255 OID 21271)
-- Name: dml_company_update(numeric, numeric, numeric, character varying, character varying, character varying, boolean, boolean); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_company_update(id_user_ numeric, _id_company numeric, _id_setting numeric, _name_company character varying, _acronym_company character varying, _address_company character varying, _status_company boolean, _deleted_company boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
	-- setting
	_COUNT_EXTERNALS_IDS = (select count(*) from core.view_setting v where v.id_setting = _id_setting);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_setting||' de la tabla setting no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_COUNT = (select count(*) from core.view_company t where t.id_company = _id_company);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from core.view_company t where t.id_company = _id_company and deleted_company = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from core.view_company t where t.name_company = _name_company and t.id_company != _id_company);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE core.company SET id_setting=$3, name_company=$4, acronym_company=$5, address_company=$6, status_company=$7, deleted_company=$8 WHERE id_company=$2 RETURNING id_company LOOP
					_RETURNING = _X.id_company;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'company',_id_company,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el name_company '||_name_company||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_company||' no se encuentra registrado en la tabla company';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_company_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_company_update(id_user_ numeric, _id_company numeric, _id_setting numeric, _name_company character varying, _acronym_company character varying, _address_company character varying, _status_company boolean, _deleted_company boolean) OWNER TO app_nashor;

--
-- TOC entry 471 (class 1255 OID 21405)
-- Name: dml_company_update_modified(numeric, numeric, numeric, character varying, character varying, character varying, boolean, boolean, numeric, numeric, numeric, numeric, boolean, boolean, boolean); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.dml_company_update_modified(id_user_ numeric, _id_company numeric, _id_setting numeric, _name_company character varying, _acronym_company character varying, _address_company character varying, _status_company boolean, _deleted_company boolean, _expiration_token numeric, _expiration_verification_code numeric, _inactivity_time numeric, _session_limit numeric, _save_log boolean, _save_file_alfresco boolean, _modification_status boolean) RETURNS TABLE(id_company numeric, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, deleted_company boolean, expiration_token numeric, expiration_verification_code numeric, inactivity_time numeric, session_limit numeric, save_log boolean, save_file_alfresco boolean, modification_status boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION core.dml_company_update_modified(id_user_ numeric, _id_company numeric, _id_setting numeric, _name_company character varying, _acronym_company character varying, _address_company character varying, _status_company boolean, _deleted_company boolean, _expiration_token numeric, _expiration_verification_code numeric, _inactivity_time numeric, _session_limit numeric, _save_log boolean, _save_file_alfresco boolean, _modification_status boolean) OWNER TO postgres;

--
-- TOC entry 441 (class 1255 OID 21276)
-- Name: dml_job_create(numeric, character varying, character varying, character varying, character varying, boolean); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_job_create(id_user_ numeric, _name_job character varying, _address_job character varying, _phone_job character varying, _position_job character varying, _deleted_job boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_RESPONSE BOOLEAN DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_ATT NUMERIC;
	_RETURNING NUMERIC;
	_CURRENT_ID NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_CURRENT_ID = (select nextval('core.serial_job')-1);
	_COUNT = (select count(*) from core.view_job t where t.id_job = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from core.view_job t where t.id_job = _CURRENT_ID);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO core.job(id_job, name_job, address_job, phone_job, position_job, deleted_job) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6) RETURNING id_job LOOP
				_RETURNING = _X.id_job;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'job',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el id_job '||_id_job||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla job';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''core.serial_job'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_job_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_job_create(id_user_ numeric, _name_job character varying, _address_job character varying, _phone_job character varying, _position_job character varying, _deleted_job boolean) OWNER TO app_nashor;

--
-- TOC entry 444 (class 1255 OID 21278)
-- Name: dml_job_delete(numeric, numeric); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_job_delete(id_user_ numeric, _id_job numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from core.view_job t where t.id_job = _id_job);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from core.view_job t where t.id_job = _id_job and deleted_job = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('core','job', _id_job));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE core.job SET deleted_job=true WHERE id_job = _id_job RETURNING id_job LOOP
					_RETURNING = _X.id_job;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'job',_id_job,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_job||' no se encuentra registrado en la tabla job';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_job_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION core.dml_job_delete(id_user_ numeric, _id_job numeric) OWNER TO app_nashor;

--
-- TOC entry 443 (class 1255 OID 21277)
-- Name: dml_job_update(numeric, numeric, character varying, character varying, character varying, character varying, boolean); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_job_update(id_user_ numeric, _id_job numeric, _name_job character varying, _address_job character varying, _phone_job character varying, _position_job character varying, _deleted_job boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
	_COUNT = (select count(*) from core.view_job t where t.id_job = _id_job);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from core.view_job t where t.id_job = _id_job and deleted_job = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from core.view_job t where t.id_job = _id_job and t.id_job != _id_job);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE core.job SET name_job=$3, address_job=$4, phone_job=$5, position_job=$6, deleted_job=$7 WHERE id_job=$2 RETURNING id_job LOOP
					_RETURNING = _X.id_job;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'job',_id_job,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el id_job '||_id_job||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_job||' no se encuentra registrado en la tabla job';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_job_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_job_update(id_user_ numeric, _id_job numeric, _name_job character varying, _address_job character varying, _phone_job character varying, _position_job character varying, _deleted_job boolean) OWNER TO app_nashor;

--
-- TOC entry 438 (class 1255 OID 21273)
-- Name: dml_navigation_create(numeric, numeric, character varying, character varying, core."TYPE_NAVIGATION", boolean, json, boolean); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_navigation_create(id_user_ numeric, _id_company numeric, _name_navigation character varying, _description_navigation character varying, _type_navigation core."TYPE_NAVIGATION", _status_navigation boolean, _content_navigation json, _deleted_navigation boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
			
	_CURRENT_ID = (select nextval('core.serial_navigation')-1);
	_COUNT = (select count(*) from core.view_navigation t where t.id_navigation = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from core.view_navigation t where t.name_navigation = _name_navigation);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO core.navigation(id_navigation, id_company, name_navigation, description_navigation, type_navigation, status_navigation, content_navigation, deleted_navigation) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6 ,$7 ,$8) RETURNING id_navigation LOOP
				_RETURNING = _X.id_navigation;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'navigation',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el name_navigation '||_name_navigation||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla navigation';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''core.serial_navigation'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_navigation_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_navigation_create(id_user_ numeric, _id_company numeric, _name_navigation character varying, _description_navigation character varying, _type_navigation core."TYPE_NAVIGATION", _status_navigation boolean, _content_navigation json, _deleted_navigation boolean) OWNER TO app_nashor;

--
-- TOC entry 475 (class 1255 OID 21409)
-- Name: dml_navigation_create_modified(numeric, numeric, core."TYPE_NAVIGATION"); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.dml_navigation_create_modified(id_user_ numeric, _id_company numeric, _type_navigation core."TYPE_NAVIGATION") RETURNS TABLE(id_navigation numeric, id_company numeric, name_navigation character varying, description_navigation character varying, type_navigation core."TYPE_NAVIGATION", status_navigation boolean, content_navigation json, deleted_navigation boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION core.dml_navigation_create_modified(id_user_ numeric, _id_company numeric, _type_navigation core."TYPE_NAVIGATION") OWNER TO postgres;

--
-- TOC entry 440 (class 1255 OID 21275)
-- Name: dml_navigation_delete(numeric, numeric); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_navigation_delete(id_user_ numeric, _id_navigation numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from core.view_navigation t where t.id_navigation = _id_navigation);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from core.view_navigation t where t.id_navigation = _id_navigation and deleted_navigation = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('core','navigation', _id_navigation));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE core.navigation SET deleted_navigation=true WHERE id_navigation = _id_navigation RETURNING id_navigation LOOP
					_RETURNING = _X.id_navigation;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'navigation',_id_navigation,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_navigation||' no se encuentra registrado en la tabla navigation';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_navigation_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION core.dml_navigation_delete(id_user_ numeric, _id_navigation numeric) OWNER TO app_nashor;

--
-- TOC entry 439 (class 1255 OID 21274)
-- Name: dml_navigation_update(numeric, numeric, numeric, character varying, character varying, core."TYPE_NAVIGATION", boolean, json, boolean); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_navigation_update(id_user_ numeric, _id_navigation numeric, _id_company numeric, _name_navigation character varying, _description_navigation character varying, _type_navigation core."TYPE_NAVIGATION", _status_navigation boolean, _content_navigation json, _deleted_navigation boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
			
	_COUNT = (select count(*) from core.view_navigation t where t.id_navigation = _id_navigation);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from core.view_navigation t where t.id_navigation = _id_navigation and deleted_navigation = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from core.view_navigation t where t.name_navigation = _name_navigation and t.id_navigation != _id_navigation);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE core.navigation SET id_company=$3, name_navigation=$4, description_navigation=$5, type_navigation=$6, status_navigation=$7, content_navigation=$8, deleted_navigation=$9 WHERE id_navigation=$2 RETURNING id_navigation LOOP
					_RETURNING = _X.id_navigation;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'navigation',_id_navigation,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el name_navigation '||_name_navigation||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_navigation||' no se encuentra registrado en la tabla navigation';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_navigation_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_navigation_update(id_user_ numeric, _id_navigation numeric, _id_company numeric, _name_navigation character varying, _description_navigation character varying, _type_navigation core."TYPE_NAVIGATION", _status_navigation boolean, _content_navigation json, _deleted_navigation boolean) OWNER TO app_nashor;

--
-- TOC entry 476 (class 1255 OID 21410)
-- Name: dml_navigation_update_modified(numeric, numeric, numeric, character varying, character varying, core."TYPE_NAVIGATION", boolean, json, boolean); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.dml_navigation_update_modified(id_user_ numeric, _id_navigation numeric, _id_company numeric, _name_navigation character varying, _description_navigation character varying, _type_navigation core."TYPE_NAVIGATION", _status_navigation boolean, _content_navigation json, _deleted_navigation boolean) RETURNS TABLE(id_navigation numeric, id_company numeric, name_navigation character varying, description_navigation character varying, type_navigation core."TYPE_NAVIGATION", status_navigation boolean, content_navigation json, deleted_navigation boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION core.dml_navigation_update_modified(id_user_ numeric, _id_navigation numeric, _id_company numeric, _name_navigation character varying, _description_navigation character varying, _type_navigation core."TYPE_NAVIGATION", _status_navigation boolean, _content_navigation json, _deleted_navigation boolean) OWNER TO postgres;

--
-- TOC entry 445 (class 1255 OID 21279)
-- Name: dml_person_create(numeric, numeric, numeric, character varying, character varying, character varying, character varying, character varying, boolean); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_person_create(id_user_ numeric, _id_academic numeric, _id_job numeric, _dni_person character varying, _name_person character varying, _last_name_person character varying, _address_person character varying, _phone_person character varying, _deleted_person boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
	-- academic
	_COUNT_EXTERNALS_IDS = (select count(*) from core.view_academic v where v.id_academic = _id_academic);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_academic||' de la tabla academic no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- job
	_COUNT_EXTERNALS_IDS = (select count(*) from core.view_job v where v.id_job = _id_job);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_job||' de la tabla job no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_CURRENT_ID = (select nextval('core.serial_person')-1);
	_COUNT = (select count(*) from core.view_person t where t.id_person = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from core.view_person t where t.dni_person = _dni_person);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO core.person(id_person, id_academic, id_job, dni_person, name_person, last_name_person, address_person, phone_person, deleted_person) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6 ,$7 ,$8 ,$9) RETURNING id_person LOOP
				_RETURNING = _X.id_person;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'person',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el dni_person '||_dni_person||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla person';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''core.serial_person'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_person_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_person_create(id_user_ numeric, _id_academic numeric, _id_job numeric, _dni_person character varying, _name_person character varying, _last_name_person character varying, _address_person character varying, _phone_person character varying, _deleted_person boolean) OWNER TO app_nashor;

--
-- TOC entry 447 (class 1255 OID 21281)
-- Name: dml_person_delete(numeric, numeric); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_person_delete(id_user_ numeric, _id_person numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from core.view_person t where t.id_person = _id_person);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from core.view_person t where t.id_person = _id_person and deleted_person = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('core','person', _id_person));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE core.person SET deleted_person=true WHERE id_person = _id_person RETURNING id_person LOOP
					_RETURNING = _X.id_person;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'person',_id_person,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_person||' no se encuentra registrado en la tabla person';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_person_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION core.dml_person_delete(id_user_ numeric, _id_person numeric) OWNER TO app_nashor;

--
-- TOC entry 446 (class 1255 OID 21280)
-- Name: dml_person_update(numeric, numeric, numeric, numeric, character varying, character varying, character varying, character varying, character varying, boolean); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_person_update(id_user_ numeric, _id_person numeric, _id_academic numeric, _id_job numeric, _dni_person character varying, _name_person character varying, _last_name_person character varying, _address_person character varying, _phone_person character varying, _deleted_person boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
	-- academic
	_COUNT_EXTERNALS_IDS = (select count(*) from core.view_academic v where v.id_academic = _id_academic);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_academic||' de la tabla academic no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- job
	_COUNT_EXTERNALS_IDS = (select count(*) from core.view_job v where v.id_job = _id_job);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_job||' de la tabla job no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_COUNT = (select count(*) from core.view_person t where t.id_person = _id_person);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from core.view_person t where t.id_person = _id_person and deleted_person = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from core.view_person t where t.dni_person = _dni_person and t.id_person != _id_person);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE core.person SET id_academic=$3, id_job=$4, dni_person=$5, name_person=$6, last_name_person=$7, address_person=$8, phone_person=$9, deleted_person=$10 WHERE id_person=$2 RETURNING id_person LOOP
					_RETURNING = _X.id_person;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'person',_id_person,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el dni_person '||_dni_person||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_person||' no se encuentra registrado en la tabla person';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_person_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_person_update(id_user_ numeric, _id_person numeric, _id_academic numeric, _id_job numeric, _dni_person character varying, _name_person character varying, _last_name_person character varying, _address_person character varying, _phone_person character varying, _deleted_person boolean) OWNER TO app_nashor;

--
-- TOC entry 451 (class 1255 OID 21285)
-- Name: dml_profile_create(numeric, numeric, core."TYPE_PROFILE", character varying, character varying, boolean, boolean); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_profile_create(id_user_ numeric, _id_company numeric, _type_profile core."TYPE_PROFILE", _name_profile character varying, _description_profile character varying, _status_profile boolean, _deleted_profile boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
			
	_CURRENT_ID = (select nextval('core.serial_profile')-1);
	_COUNT = (select count(*) from core.view_profile t where t.id_profile = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from core.view_profile t where t.name_profile = _name_profile);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO core.profile(id_profile, id_company, type_profile, name_profile, description_profile, status_profile, deleted_profile) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6 ,$7) RETURNING id_profile LOOP
				_RETURNING = _X.id_profile;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'profile',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el name_profile '||_name_profile||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla profile';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''core.serial_profile'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_profile_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_profile_create(id_user_ numeric, _id_company numeric, _type_profile core."TYPE_PROFILE", _name_profile character varying, _description_profile character varying, _status_profile boolean, _deleted_profile boolean) OWNER TO app_nashor;

--
-- TOC entry 477 (class 1255 OID 21411)
-- Name: dml_profile_create_modified(numeric, numeric); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.dml_profile_create_modified(id_user_ numeric, _id_company numeric) RETURNS TABLE(id_profile numeric, id_company numeric, type_profile core."TYPE_PROFILE", name_profile character varying, description_profile character varying, status_profile boolean, deleted_profile boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION core.dml_profile_create_modified(id_user_ numeric, _id_company numeric) OWNER TO postgres;

--
-- TOC entry 453 (class 1255 OID 21287)
-- Name: dml_profile_delete(numeric, numeric); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_profile_delete(id_user_ numeric, _id_profile numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from core.view_profile t where t.id_profile = _id_profile);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from core.view_profile t where t.id_profile = _id_profile and deleted_profile = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('core','profile', _id_profile));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE core.profile SET deleted_profile=true WHERE id_profile = _id_profile RETURNING id_profile LOOP
					_RETURNING = _X.id_profile;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'profile',_id_profile,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_profile||' no se encuentra registrado en la tabla profile';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_profile_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION core.dml_profile_delete(id_user_ numeric, _id_profile numeric) OWNER TO app_nashor;

--
-- TOC entry 431 (class 1255 OID 21413)
-- Name: dml_profile_delete_modified(numeric, numeric); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.dml_profile_delete_modified(id_user_ numeric, _id_profile numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION core.dml_profile_delete_modified(id_user_ numeric, _id_profile numeric) OWNER TO postgres;

--
-- TOC entry 454 (class 1255 OID 21288)
-- Name: dml_profile_navigation_create(numeric, numeric, numeric); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_profile_navigation_create(id_user_ numeric, _id_profile numeric, _id_navigation numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
	-- profile
	_COUNT_EXTERNALS_IDS = (select count(*) from core.view_profile v where v.id_profile = _id_profile);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_profile||' de la tabla profile no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- navigation
	_COUNT_EXTERNALS_IDS = (select count(*) from core.view_navigation v where v.id_navigation = _id_navigation);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_navigation||' de la tabla navigation no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_CURRENT_ID = (select nextval('core.serial_profile_navigation')-1);
	_COUNT = (select count(*) from core.view_profile_navigation t where t.id_profile_navigation = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		FOR _X IN INSERT INTO core.profile_navigation(id_profile_navigation, id_profile, id_navigation) VALUES (_CURRENT_ID, $2 ,$3) RETURNING id_profile_navigation LOOP
			_RETURNING = _X.id_profile_navigation;
		END LOOP;
		
		IF (_RETURNING >= 1) THEN
			_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
				where cvuij.id_user = id_user_);
			
			IF (_SAVE_LOG) THEN
				_RESPONSE = (select * from core.dml_system_event_create(id_user_,'profile_navigation',_CURRENT_ID,'CREATE', now()::timestamp, false));
				
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
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla profile_navigation';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''core.serial_profile_navigation'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_profile_navigation_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_profile_navigation_create(id_user_ numeric, _id_profile numeric, _id_navigation numeric) OWNER TO app_nashor;

--
-- TOC entry 481 (class 1255 OID 21416)
-- Name: dml_profile_navigation_create_modified(numeric, numeric); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.dml_profile_navigation_create_modified(id_user_ numeric, _id_profile numeric) RETURNS TABLE(id_profile_navigation numeric, id_profile numeric, id_navigation numeric, type_profile core."TYPE_PROFILE", name_profile character varying, description_profile character varying, status_profile boolean, name_navigation character varying, description_navigation character varying, type_navigation core."TYPE_NAVIGATION", status_navigation boolean, content_navigation json)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION core.dml_profile_navigation_create_modified(id_user_ numeric, _id_profile numeric) OWNER TO postgres;

--
-- TOC entry 456 (class 1255 OID 21290)
-- Name: dml_profile_navigation_delete(numeric, numeric); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_profile_navigation_delete(id_user_ numeric, _id_profile_navigation numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from core.view_profile_navigation t where t.id_profile_navigation = _id_profile_navigation);
		
	IF (_COUNT = 1) THEN
		_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('core','profile_navigation', _id_profile_navigation));
			
		IF (_COUNT_DEPENDENCY > 0) THEN
			_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		ELSE
			FOR _X IN DELETE FROM core.profile_navigation WHERE id_profile_navigation = _id_profile_navigation RETURNING id_profile_navigation LOOP
				_RETURNING = _X.id_profile_navigation;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'profile_navigation',_id_profile_navigation,'DELETE', now()::timestamp, false));
					
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
		_EXCEPTION = 'El registro con id '||_id_profile_navigation||' no se encuentra registrado en la tabla profile_navigation';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_profile_navigation_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION core.dml_profile_navigation_delete(id_user_ numeric, _id_profile_navigation numeric) OWNER TO app_nashor;

--
-- TOC entry 455 (class 1255 OID 21289)
-- Name: dml_profile_navigation_update(numeric, numeric, numeric, numeric); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_profile_navigation_update(id_user_ numeric, _id_profile_navigation numeric, _id_profile numeric, _id_navigation numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_EXTERNALS_IDS NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN 
	-- profile
	_COUNT_EXTERNALS_IDS = (select count(*) from core.view_profile v where v.id_profile = _id_profile);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_profile||' de la tabla profile no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- navigation
	_COUNT_EXTERNALS_IDS = (select count(*) from core.view_navigation v where v.id_navigation = _id_navigation);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_navigation||' de la tabla navigation no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
 	_COUNT = (select count(*) from core.view_profile_navigation t where t.id_profile_navigation = _id_profile_navigation);

	IF (_COUNT = 1) THEN
		FOR _X IN UPDATE core.profile_navigation SET id_profile=$3, id_navigation=$4 WHERE id_profile_navigation=$2 RETURNING id_profile_navigation LOOP
			_RETURNING = _X.id_profile_navigation;
		END LOOP;
			
		IF (_RETURNING >= 1) THEN
			_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
				where cvuij.id_user = id_user_);

			IF (_SAVE_LOG) THEN
				_RESPONSE = (select * from core.dml_system_event_create(id_user_,'profile_navigation',_id_profile_navigation,'UPDATE', now()::timestamp, false));
				
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
		_EXCEPTION = 'El registro con id '||_id_profile_navigation||' no se encuentra registrado en la tabla profile_navigation';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_profile_navigation_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_profile_navigation_update(id_user_ numeric, _id_profile_navigation numeric, _id_profile numeric, _id_navigation numeric) OWNER TO app_nashor;

--
-- TOC entry 482 (class 1255 OID 21417)
-- Name: dml_profile_navigation_update_modified(numeric, numeric, numeric, numeric); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.dml_profile_navigation_update_modified(id_user_ numeric, _id_profile_navigation numeric, _id_profile numeric, _id_navigation numeric) RETURNS TABLE(id_profile_navigation numeric, id_profile numeric, id_navigation numeric, type_profile core."TYPE_PROFILE", name_profile character varying, description_profile character varying, status_profile boolean, name_navigation character varying, description_navigation character varying, type_navigation core."TYPE_NAVIGATION", status_navigation boolean, content_navigation json)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION core.dml_profile_navigation_update_modified(id_user_ numeric, _id_profile_navigation numeric, _id_profile numeric, _id_navigation numeric) OWNER TO postgres;

--
-- TOC entry 452 (class 1255 OID 21286)
-- Name: dml_profile_update(numeric, numeric, numeric, core."TYPE_PROFILE", character varying, character varying, boolean, boolean); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_profile_update(id_user_ numeric, _id_profile numeric, _id_company numeric, _type_profile core."TYPE_PROFILE", _name_profile character varying, _description_profile character varying, _status_profile boolean, _deleted_profile boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
			
	_COUNT = (select count(*) from core.view_profile t where t.id_profile = _id_profile);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from core.view_profile t where t.id_profile = _id_profile and deleted_profile = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from core.view_profile t where t.name_profile = _name_profile and t.id_profile != _id_profile);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE core.profile SET id_company=$3, type_profile=$4, name_profile=$5, description_profile=$6, status_profile=$7, deleted_profile=$8 WHERE id_profile=$2 RETURNING id_profile LOOP
					_RETURNING = _X.id_profile;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'profile',_id_profile,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el name_profile '||_name_profile||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_profile||' no se encuentra registrado en la tabla profile';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_profile_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_profile_update(id_user_ numeric, _id_profile numeric, _id_company numeric, _type_profile core."TYPE_PROFILE", _name_profile character varying, _description_profile character varying, _status_profile boolean, _deleted_profile boolean) OWNER TO app_nashor;

--
-- TOC entry 478 (class 1255 OID 21412)
-- Name: dml_profile_update_modified(numeric, numeric, numeric, core."TYPE_PROFILE", character varying, character varying, boolean, boolean); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.dml_profile_update_modified(id_user_ numeric, _id_profile numeric, _id_company numeric, _type_profile core."TYPE_PROFILE", _name_profile character varying, _description_profile character varying, _status_profile boolean, _deleted_profile boolean) RETURNS TABLE(id_profile numeric, id_company numeric, type_profile core."TYPE_PROFILE", name_profile character varying, description_profile character varying, status_profile boolean, deleted_profile boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION core.dml_profile_update_modified(id_user_ numeric, _id_profile numeric, _id_company numeric, _type_profile core."TYPE_PROFILE", _name_profile character varying, _description_profile character varying, _status_profile boolean, _deleted_profile boolean) OWNER TO postgres;

--
-- TOC entry 489 (class 1255 OID 21424)
-- Name: dml_session_by_company_release_all(numeric, numeric); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.dml_session_by_company_release_all(id_user_ numeric, _id_company numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION core.dml_session_by_company_release_all(id_user_ numeric, _id_company numeric) OWNER TO postgres;

--
-- TOC entry 487 (class 1255 OID 21422)
-- Name: dml_session_by_session_release(numeric, numeric); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.dml_session_by_session_release(id_user_ numeric, _id_session numeric) RETURNS TABLE(id_session numeric, id_user numeric, host_session text, agent_session json, date_sign_in_session timestamp without time zone, date_sign_out_session timestamp without time zone, status_session boolean, id_company numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION core.dml_session_by_session_release(id_user_ numeric, _id_session numeric) OWNER TO postgres;

--
-- TOC entry 488 (class 1255 OID 21423)
-- Name: dml_session_by_user_release_all(numeric, numeric); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.dml_session_by_user_release_all(id_user_ numeric, _id_user numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION core.dml_session_by_user_release_all(id_user_ numeric, _id_user numeric) OWNER TO postgres;

--
-- TOC entry 467 (class 1255 OID 21300)
-- Name: dml_session_create(numeric, numeric, text, json, timestamp without time zone, timestamp without time zone, boolean); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_session_create(id_user_ numeric, _id_user numeric, _host_session text, _agent_session json, _date_sign_in_session timestamp without time zone, _date_sign_out_session timestamp without time zone, _status_session boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
	-- user
	_COUNT_EXTERNALS_IDS = (select count(*) from core.view_user v where v.id_user = _id_user);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_user||' de la tabla user no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_CURRENT_ID = (select nextval('core.serial_session')-1);
	_COUNT = (select count(*) from core.view_session t where t.id_session = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		FOR _X IN INSERT INTO core.session(id_session, id_user, host_session, agent_session, date_sign_in_session, date_sign_out_session, status_session) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6 ,$7) RETURNING id_session LOOP
			_RETURNING = _X.id_session;
		END LOOP;
		
		IF (_RETURNING >= 1) THEN
			_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
				where cvuij.id_user = id_user_);
			
			IF (_SAVE_LOG) THEN
				_RESPONSE = (select * from core.dml_system_event_create(id_user_,'session',_CURRENT_ID,'CREATE', now()::timestamp, false));
				
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
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla session';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''core.serial_session'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_session_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_session_create(id_user_ numeric, _id_user numeric, _host_session text, _agent_session json, _date_sign_in_session timestamp without time zone, _date_sign_out_session timestamp without time zone, _status_session boolean) OWNER TO app_nashor;

--
-- TOC entry 458 (class 1255 OID 21302)
-- Name: dml_session_delete(numeric, numeric); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_session_delete(id_user_ numeric, _id_session numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from core.view_session t where t.id_session = _id_session);
		
	IF (_COUNT = 1) THEN
		_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('core','session', _id_session));
			
		IF (_COUNT_DEPENDENCY > 0) THEN
			_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		ELSE
			FOR _X IN DELETE FROM core.session WHERE id_session = _id_session RETURNING id_session LOOP
				_RETURNING = _X.id_session;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'session',_id_session,'DELETE', now()::timestamp, false));
					
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
		_EXCEPTION = 'El registro con id '||_id_session||' no se encuentra registrado en la tabla session';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_session_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION core.dml_session_delete(id_user_ numeric, _id_session numeric) OWNER TO app_nashor;

--
-- TOC entry 486 (class 1255 OID 21421)
-- Name: dml_session_release(numeric); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.dml_session_release(_id_session numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION core.dml_session_release(_id_session numeric) OWNER TO postgres;

--
-- TOC entry 468 (class 1255 OID 21301)
-- Name: dml_session_update(numeric, numeric, numeric, text, json, timestamp without time zone, timestamp without time zone, boolean); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_session_update(id_user_ numeric, _id_session numeric, _id_user numeric, _host_session text, _agent_session json, _date_sign_in_session timestamp without time zone, _date_sign_out_session timestamp without time zone, _status_session boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_EXTERNALS_IDS NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN 
	-- user
	_COUNT_EXTERNALS_IDS = (select count(*) from core.view_user v where v.id_user = _id_user);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_user||' de la tabla user no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
 	_COUNT = (select count(*) from core.view_session t where t.id_session = _id_session);

	IF (_COUNT = 1) THEN
		FOR _X IN UPDATE core.session SET id_user=$3, host_session=$4, agent_session=$5, date_sign_in_session=$6, date_sign_out_session=$7, status_session=$8 WHERE id_session=$2 RETURNING id_session LOOP
			_RETURNING = _X.id_session;
		END LOOP;
			
		IF (_RETURNING >= 1) THEN
			_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
				where cvuij.id_user = id_user_);

			IF (_SAVE_LOG) THEN
				_RESPONSE = (select * from core.dml_system_event_create(id_user_,'session',_id_session,'UPDATE', now()::timestamp, false));
				
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
		_EXCEPTION = 'El registro con id '||_id_session||' no se encuentra registrado en la tabla session';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_session_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_session_update(id_user_ numeric, _id_session numeric, _id_user numeric, _host_session text, _agent_session json, _date_sign_in_session timestamp without time zone, _date_sign_out_session timestamp without time zone, _status_session boolean) OWNER TO app_nashor;

--
-- TOC entry 432 (class 1255 OID 21267)
-- Name: dml_setting_create(numeric, numeric, numeric, numeric, numeric, boolean, boolean, boolean, boolean); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_setting_create(id_user_ numeric, _expiration_token numeric, _expiration_verification_code numeric, _inactivity_time numeric, _session_limit numeric, _save_log boolean, _save_file_alfresco boolean, _modification_status boolean, _deleted_setting boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_RESPONSE BOOLEAN DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_ATT NUMERIC;
	_RETURNING NUMERIC;
	_CURRENT_ID NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_CURRENT_ID = (select nextval('core.serial_setting')-1);
	_COUNT = (select count(*) from core.view_setting t where t.id_setting = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from core.view_setting t where t.id_setting = _CURRENT_ID);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO core.setting(id_setting, expiration_token, expiration_verification_code, inactivity_time, session_limit, save_log, save_file_alfresco, modification_status, deleted_setting) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6 ,$7 ,$8 ,$9) RETURNING id_setting LOOP
				_RETURNING = _X.id_setting;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'setting',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el id_setting '||_id_setting||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla setting';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''core.serial_setting'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_setting_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_setting_create(id_user_ numeric, _expiration_token numeric, _expiration_verification_code numeric, _inactivity_time numeric, _session_limit numeric, _save_log boolean, _save_file_alfresco boolean, _modification_status boolean, _deleted_setting boolean) OWNER TO app_nashor;

--
-- TOC entry 434 (class 1255 OID 21269)
-- Name: dml_setting_delete(numeric, numeric); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_setting_delete(id_user_ numeric, _id_setting numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from core.view_setting t where t.id_setting = _id_setting);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from core.view_setting t where t.id_setting = _id_setting and deleted_setting = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('core','setting', _id_setting));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE core.setting SET deleted_setting=true WHERE id_setting = _id_setting RETURNING id_setting LOOP
					_RETURNING = _X.id_setting;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'setting',_id_setting,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_setting||' no se encuentra registrado en la tabla setting';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_setting_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION core.dml_setting_delete(id_user_ numeric, _id_setting numeric) OWNER TO app_nashor;

--
-- TOC entry 433 (class 1255 OID 21268)
-- Name: dml_setting_update(numeric, numeric, numeric, numeric, numeric, numeric, boolean, boolean, boolean, boolean); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_setting_update(id_user_ numeric, _id_setting numeric, _expiration_token numeric, _expiration_verification_code numeric, _inactivity_time numeric, _session_limit numeric, _save_log boolean, _save_file_alfresco boolean, _modification_status boolean, _deleted_setting boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
	_COUNT = (select count(*) from core.view_setting t where t.id_setting = _id_setting);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from core.view_setting t where t.id_setting = _id_setting and deleted_setting = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from core.view_setting t where t.id_setting = _id_setting and t.id_setting != _id_setting);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE core.setting SET expiration_token=$3, expiration_verification_code=$4, inactivity_time=$5, session_limit=$6, save_log=$7, save_file_alfresco=$8, modification_status=$9, deleted_setting=$10 WHERE id_setting=$2 RETURNING id_setting LOOP
					_RETURNING = _X.id_setting;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'setting',_id_setting,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el id_setting '||_id_setting||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_setting||' no se encuentra registrado en la tabla setting';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_setting_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_setting_update(id_user_ numeric, _id_setting numeric, _expiration_token numeric, _expiration_verification_code numeric, _inactivity_time numeric, _session_limit numeric, _save_log boolean, _save_file_alfresco boolean, _modification_status boolean, _deleted_setting boolean) OWNER TO app_nashor;

--
-- TOC entry 469 (class 1255 OID 21303)
-- Name: dml_system_event_create(numeric, character varying, numeric, character varying, timestamp without time zone, boolean); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_system_event_create(_id_user numeric, _table_system_event character varying, _row_system_event numeric, _action_system_event character varying, _date_system_event timestamp without time zone, _deleted_system_event boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
	_RESPONSE BOOLEAN DEFAULT false;
	_COUNT NUMERIC;
	_RETURNING NUMERIC;
	_CURRENT_ID NUMERIC;
	_X RECORD;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_CURRENT_ID = (select nextval('core.serial_system_event')-1);
	_COUNT = (select count(*) from core.view_system_event t where t.id_system_event = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		FOR _X IN INSERT INTO core.system_event(id_system_event, id_user, table_system_event, row_system_event, action_system_event, date_system_event, deleted_system_event) VALUES (_CURRENT_ID, $1 ,$2 ,$3 ,$4 ,$5 ,$6) RETURNING id_system_event LOOP
			_RETURNING = _X.id_system_event;
		END LOOP;
		
		IF (_RETURNING >= 1) THEN
			RETURN true;
		ELSE
			_EXCEPTION = 'Ocurrió un error al insertar el registro';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE 
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla system_event';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''core.serial_system_event'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_system_event_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_system_event_create(_id_user numeric, _table_system_event character varying, _row_system_event numeric, _action_system_event character varying, _date_system_event timestamp without time zone, _deleted_system_event boolean) OWNER TO app_nashor;

--
-- TOC entry 461 (class 1255 OID 21294)
-- Name: dml_type_user_create(numeric, numeric, numeric, character varying, character varying, boolean, boolean); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_type_user_create(id_user_ numeric, _id_company numeric, _id_profile numeric, _name_type_user character varying, _description_type_user character varying, _status_type_user boolean, _deleted_type_user boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
			 
	-- profile
	_COUNT_EXTERNALS_IDS = (select count(*) from core.view_profile v where v.id_profile = _id_profile);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_profile||' de la tabla profile no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_CURRENT_ID = (select nextval('core.serial_type_user')-1);
	_COUNT = (select count(*) from core.view_type_user t where t.id_type_user = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from core.view_type_user t where t.name_type_user = _name_type_user);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO core.type_user(id_type_user, id_company, id_profile, name_type_user, description_type_user, status_type_user, deleted_type_user) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6 ,$7) RETURNING id_type_user LOOP
				_RETURNING = _X.id_type_user;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'type_user',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el name_type_user '||_name_type_user||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla type_user';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''core.serial_type_user'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_type_user_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_type_user_create(id_user_ numeric, _id_company numeric, _id_profile numeric, _name_type_user character varying, _description_type_user character varying, _status_type_user boolean, _deleted_type_user boolean) OWNER TO app_nashor;

--
-- TOC entry 479 (class 1255 OID 21414)
-- Name: dml_type_user_create_modified(numeric); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.dml_type_user_create_modified(id_user_ numeric) RETURNS TABLE(id_type_user numeric, id_company numeric, id_profile numeric, name_type_user character varying, description_type_user character varying, status_type_user boolean, deleted_type_user boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, type_profile core."TYPE_PROFILE", name_profile character varying, description_profile character varying, status_profile boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION core.dml_type_user_create_modified(id_user_ numeric) OWNER TO postgres;

--
-- TOC entry 463 (class 1255 OID 21296)
-- Name: dml_type_user_delete(numeric, numeric); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_type_user_delete(id_user_ numeric, _id_type_user numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from core.view_type_user t where t.id_type_user = _id_type_user);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from core.view_type_user t where t.id_type_user = _id_type_user and deleted_type_user = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('core','type_user', _id_type_user));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE core.type_user SET deleted_type_user=true WHERE id_type_user = _id_type_user RETURNING id_type_user LOOP
					_RETURNING = _X.id_type_user;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'type_user',_id_type_user,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_type_user||' no se encuentra registrado en la tabla type_user';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_type_user_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION core.dml_type_user_delete(id_user_ numeric, _id_type_user numeric) OWNER TO app_nashor;

--
-- TOC entry 462 (class 1255 OID 21295)
-- Name: dml_type_user_update(numeric, numeric, numeric, numeric, character varying, character varying, boolean, boolean); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_type_user_update(id_user_ numeric, _id_type_user numeric, _id_company numeric, _id_profile numeric, _name_type_user character varying, _description_type_user character varying, _status_type_user boolean, _deleted_type_user boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
			 
	-- profile
	_COUNT_EXTERNALS_IDS = (select count(*) from core.view_profile v where v.id_profile = _id_profile);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_profile||' de la tabla profile no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_COUNT = (select count(*) from core.view_type_user t where t.id_type_user = _id_type_user);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from core.view_type_user t where t.id_type_user = _id_type_user and deleted_type_user = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from core.view_type_user t where t.name_type_user = _name_type_user and t.id_type_user != _id_type_user);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE core.type_user SET id_company=$3, id_profile=$4, name_type_user=$5, description_type_user=$6, status_type_user=$7, deleted_type_user=$8 WHERE id_type_user=$2 RETURNING id_type_user LOOP
					_RETURNING = _X.id_type_user;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'type_user',_id_type_user,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el name_type_user '||_name_type_user||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_type_user||' no se encuentra registrado en la tabla type_user';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_type_user_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_type_user_update(id_user_ numeric, _id_type_user numeric, _id_company numeric, _id_profile numeric, _name_type_user character varying, _description_type_user character varying, _status_type_user boolean, _deleted_type_user boolean) OWNER TO app_nashor;

--
-- TOC entry 480 (class 1255 OID 21415)
-- Name: dml_type_user_update_modified(numeric, numeric, numeric, numeric, character varying, character varying, boolean, boolean); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.dml_type_user_update_modified(id_user_ numeric, _id_type_user numeric, _id_company numeric, _id_profile numeric, _name_type_user character varying, _description_type_user character varying, _status_type_user boolean, _deleted_type_user boolean) RETURNS TABLE(id_type_user numeric, id_company numeric, id_profile numeric, name_type_user character varying, description_type_user character varying, status_type_user boolean, deleted_type_user boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, type_profile core."TYPE_PROFILE", name_profile character varying, description_profile character varying, status_profile boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION core.dml_type_user_update_modified(id_user_ numeric, _id_type_user numeric, _id_company numeric, _id_profile numeric, _name_type_user character varying, _description_type_user character varying, _status_type_user boolean, _deleted_type_user boolean) OWNER TO postgres;

--
-- TOC entry 457 (class 1255 OID 21291)
-- Name: dml_user_create(numeric, numeric, numeric, numeric, character varying, character varying, character varying, boolean, boolean); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_user_create(id_user_ numeric, _id_company numeric, _id_person numeric, _id_type_user numeric, _name_user character varying, _password_user character varying, _avatar_user character varying, _status_user boolean, _deleted_user boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
			 
	-- person
	_COUNT_EXTERNALS_IDS = (select count(*) from core.view_person v where v.id_person = _id_person);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_person||' de la tabla person no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- type_user
	_COUNT_EXTERNALS_IDS = (select count(*) from core.view_type_user v where v.id_type_user = _id_type_user);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_type_user||' de la tabla type_user no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_CURRENT_ID = (select nextval('core.serial_user')-1);
	_COUNT = (select count(*) from core.view_user t where t.id_user = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from core.view_user t where t.name_user = _name_user);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO core.user(id_user, id_company, id_person, id_type_user, name_user, password_user, avatar_user, status_user, deleted_user) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6 ,$7 ,$8 ,$9) RETURNING id_user LOOP
				_RETURNING = _X.id_user;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'user',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el name_user '||_name_user||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla user';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''core.serial_user'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_user_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_user_create(id_user_ numeric, _id_company numeric, _id_person numeric, _id_type_user numeric, _name_user character varying, _password_user character varying, _avatar_user character varying, _status_user boolean, _deleted_user boolean) OWNER TO app_nashor;

--
-- TOC entry 483 (class 1255 OID 21418)
-- Name: dml_user_create_modified(numeric); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.dml_user_create_modified(id_user_ numeric) RETURNS TABLE(id_user numeric, id_company numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, deleted_user boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_profile numeric, name_type_user character varying, description_type_user character varying, status_type_user boolean, title_academic character varying, abbreviation_academic character varying, level_academic character varying, name_job character varying, address_job character varying, phone_job character varying, position_job character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION core.dml_user_create_modified(id_user_ numeric) OWNER TO postgres;

--
-- TOC entry 460 (class 1255 OID 21293)
-- Name: dml_user_delete(numeric, numeric); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_user_delete(id_user_ numeric, _id_user numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from core.view_user t where t.id_user = _id_user);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from core.view_user t where t.id_user = _id_user and deleted_user = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('core','user', _id_user));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE core.user SET deleted_user=true WHERE id_user = _id_user RETURNING id_user LOOP
					_RETURNING = _X.id_user;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'user',_id_user,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_user||' no se encuentra registrado en la tabla user';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_user_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION core.dml_user_delete(id_user_ numeric, _id_user numeric) OWNER TO app_nashor;

--
-- TOC entry 485 (class 1255 OID 21420)
-- Name: dml_user_delete_modified(numeric, numeric); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.dml_user_delete_modified(id_user_ numeric, _id_user numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION core.dml_user_delete_modified(id_user_ numeric, _id_user numeric) OWNER TO postgres;

--
-- TOC entry 430 (class 1255 OID 21179)
-- Name: dml_user_remove_avatar(numeric); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.dml_user_remove_avatar(_id_user numeric) RETURNS TABLE(status_remove_avatar boolean, current_path character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
	_X RECORD;
	_AVATAR_USER CHARACTER VARYING;
	_ID_USER_DELETE NUMERIC;
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN
	_AVATAR_USER = (select cvu.avatar_user from core.view_user cvu where cvu.id_user = _id_user);
	-- Update Path	
	FOR _X IN UPDATE core.user ctu SET avatar_user = 'default.svg' WHERE ctu.id_user = _ID_USER returning id_user LOOP 
		_ID_USER_DELETE = _X.id_user;
	END LOOP;
	
	IF (_ID_USER_DELETE >= 1) THEN
		RETURN QUERY select true as status_remove_avatar, _AVATAR_USER as current_path;
	ELSE
		_EXCEPTION = 'Ocurrió un error al eliminar el avatar del user';
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
$$;


ALTER FUNCTION core.dml_user_remove_avatar(_id_user numeric) OWNER TO postgres;

--
-- TOC entry 459 (class 1255 OID 21292)
-- Name: dml_user_update(numeric, numeric, numeric, numeric, numeric, character varying, character varying, character varying, boolean, boolean); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_user_update(id_user_ numeric, _id_user numeric, _id_company numeric, _id_person numeric, _id_type_user numeric, _name_user character varying, _password_user character varying, _avatar_user character varying, _status_user boolean, _deleted_user boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
			 
	-- person
	_COUNT_EXTERNALS_IDS = (select count(*) from core.view_person v where v.id_person = _id_person);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_person||' de la tabla person no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			 
	-- type_user
	_COUNT_EXTERNALS_IDS = (select count(*) from core.view_type_user v where v.id_type_user = _id_type_user);
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = 'El id '||_id_type_user||' de la tabla type_user no se encuentra registrado';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
			
	_COUNT = (select count(*) from core.view_user t where t.id_user = _id_user);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from core.view_user t where t.id_user = _id_user and deleted_user = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from core.view_user t where t.name_user = _name_user and t.id_user != _id_user);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE core.user SET id_company=$3, id_person=$4, id_type_user=$5, name_user=$6, password_user=$7, avatar_user=$8, status_user=$9, deleted_user=$10 WHERE id_user=$2 RETURNING id_user LOOP
					_RETURNING = _X.id_user;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'user',_id_user,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el name_user '||_name_user||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_user||' no se encuentra registrado en la tabla user';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_user_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_user_update(id_user_ numeric, _id_user numeric, _id_company numeric, _id_person numeric, _id_type_user numeric, _name_user character varying, _password_user character varying, _avatar_user character varying, _status_user boolean, _deleted_user boolean) OWNER TO app_nashor;

--
-- TOC entry 484 (class 1255 OID 21419)
-- Name: dml_user_update_modified(numeric, numeric, numeric, numeric, numeric, character varying, character varying, character varying, boolean, boolean, numeric, numeric, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.dml_user_update_modified(id_user_ numeric, _id_user numeric, _id_company numeric, _id_person numeric, _id_type_user numeric, _name_user character varying, _password_user character varying, _avatar_user character varying, _status_user boolean, _deleted_user boolean, _id_academic numeric, _id_job numeric, _dni_person character varying, _name_person character varying, _last_name_person character varying, _address_person character varying, _phone_person character varying, _title_academic character varying, _abbreviation_academic character varying, _level_academic character varying, _name_job character varying, _address_job character varying, _phone_job character varying, _position_job character varying) RETURNS TABLE(id_user numeric, id_company numeric, id_person numeric, id_type_user numeric, name_user character varying, password_user character varying, avatar_user character varying, status_user boolean, deleted_user boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean, id_academic numeric, id_job numeric, dni_person character varying, name_person character varying, last_name_person character varying, address_person character varying, phone_person character varying, id_profile numeric, name_type_user character varying, description_type_user character varying, status_type_user boolean, title_academic character varying, abbreviation_academic character varying, level_academic character varying, name_job character varying, address_job character varying, phone_job character varying, position_job character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
 	_UPDATE_ACADEMIC BOOLEAN;
	_UPDATE_JOB BOOLEAN;
	_UPDATE_PERSON BOOLEAN;
	_UPDATE_USER BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_UPDATE_ACADEMIC = (select * from core.dml_academic_update(id_user_, _id_academic, _title_academic, _abbreviation_academic, _level_academic, false));
	
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
$$;


ALTER FUNCTION core.dml_user_update_modified(id_user_ numeric, _id_user numeric, _id_company numeric, _id_person numeric, _id_type_user numeric, _name_user character varying, _password_user character varying, _avatar_user character varying, _status_user boolean, _deleted_user boolean, _id_academic numeric, _id_job numeric, _dni_person character varying, _name_person character varying, _last_name_person character varying, _address_person character varying, _phone_person character varying, _title_academic character varying, _abbreviation_academic character varying, _level_academic character varying, _name_job character varying, _address_job character varying, _phone_job character varying, _position_job character varying) OWNER TO postgres;

--
-- TOC entry 429 (class 1255 OID 21178)
-- Name: dml_user_upload_avatar(numeric, character varying); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.dml_user_upload_avatar(_id_user numeric, _new_avatar character varying) RETURNS TABLE(status_upload_avatar boolean, old_path character varying, new_path character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
	_X RECORD;
	_AVATAR_USER CHARACTER VARYING;
	_ID_USER_UPDATE NUMERIC;
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN
	_AVATAR_USER = (select cvu.avatar_user from core.view_user cvu where cvu.id_user = _id_user);
	-- Update Path	
	FOR _X IN UPDATE core.user ctu SET avatar_user = _new_avatar WHERE ctu.id_user = _ID_USER returning id_user LOOP 
		_ID_USER_UPDATE = _X.id_user;
	END LOOP;
	
	IF (_ID_USER_UPDATE >= 1) THEN
		RETURN QUERY select true as status_upload_avatar, _AVATAR_USER as old_path, _new_avatar as new_path;
	ELSE
		_EXCEPTION = 'Ocurrió un error al actualizar el avatar del usuario';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%',SQLERRM USING DETAIL = '_database_auth';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database_auth';
		END IF;
END;
			
$$;


ALTER FUNCTION core.dml_user_upload_avatar(_id_user numeric, _new_avatar character varying) OWNER TO postgres;

--
-- TOC entry 464 (class 1255 OID 21297)
-- Name: dml_validation_create(numeric, numeric, core."TYPE_VALIDATION", boolean, character varying, character varying, boolean); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_validation_create(id_user_ numeric, _id_company numeric, _type_validation core."TYPE_VALIDATION", _status_validation boolean, _pattern_validation character varying, _message_validation character varying, _deleted_validation boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
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
			
	_CURRENT_ID = (select nextval('core.serial_validation')-1);
	_COUNT = (select count(*) from core.view_validation t where t.id_validation = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from core.view_validation t where t.id_validation = _CURRENT_ID);
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO core.validation(id_validation, id_company, type_validation, status_validation, pattern_validation, message_validation, deleted_validation) VALUES (_CURRENT_ID, $2 ,$3 ,$4 ,$5 ,$6 ,$7) RETURNING id_validation LOOP
				_RETURNING = _X.id_validation;
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'validation',_CURRENT_ID,'CREATE', now()::timestamp, false));
					
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
			_EXCEPTION = 'Ya existe un registro con el id_validation '||_id_validation||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_CURRENT_ID||' ya se encuentra registrado en la tabla validation';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE 'select setval(''core.serial_validation'', '||_CURRENT_ID||')';
		END IF;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_validation_create -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_validation_create(id_user_ numeric, _id_company numeric, _type_validation core."TYPE_VALIDATION", _status_validation boolean, _pattern_validation character varying, _message_validation character varying, _deleted_validation boolean) OWNER TO app_nashor;

--
-- TOC entry 473 (class 1255 OID 21407)
-- Name: dml_validation_create_modified(numeric, numeric, core."TYPE_VALIDATION"); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.dml_validation_create_modified(id_user_ numeric, _id_company numeric, _type_validation core."TYPE_VALIDATION") RETURNS TABLE(id_validation numeric, id_company numeric, type_validation core."TYPE_VALIDATION", status_validation boolean, pattern_validation character varying, message_validation character varying, deleted_validation boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION core.dml_validation_create_modified(id_user_ numeric, _id_company numeric, _type_validation core."TYPE_VALIDATION") OWNER TO postgres;

--
-- TOC entry 466 (class 1255 OID 21299)
-- Name: dml_validation_delete(numeric, numeric); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_validation_delete(id_user_ numeric, _id_validation numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
 	_COUNT = (select count(*) from core.view_validation t where t.id_validation = _id_validation);
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from core.view_validation t where t.id_validation = _id_validation and deleted_validation = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('core','validation', _id_validation));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = 'No se puede eliminar el registro, mantiene dependencia en otros procesos.';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			ELSE
				FOR _X IN UPDATE core.validation SET deleted_validation=true WHERE id_validation = _id_validation RETURNING id_validation LOOP
					_RETURNING = _X.id_validation;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'validation',_id_validation,'DELETE', now()::timestamp, false));
						
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
			_EXCEPTION = 'EL registro ya se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_validation||' no se encuentra registrado en la tabla validation';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_validation_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$$;


ALTER FUNCTION core.dml_validation_delete(id_user_ numeric, _id_validation numeric) OWNER TO app_nashor;

--
-- TOC entry 465 (class 1255 OID 21298)
-- Name: dml_validation_update(numeric, numeric, numeric, core."TYPE_VALIDATION", boolean, character varying, character varying, boolean); Type: FUNCTION; Schema: core; Owner: app_nashor
--

CREATE FUNCTION core.dml_validation_update(id_user_ numeric, _id_validation numeric, _id_company numeric, _type_validation core."TYPE_VALIDATION", _status_validation boolean, _pattern_validation character varying, _message_validation character varying, _deleted_validation boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
			
	_COUNT = (select count(*) from core.view_validation t where t.id_validation = _id_validation);
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from core.view_validation t where t.id_validation = _id_validation and deleted_validation = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from core.view_validation t where t.id_validation = _id_validation and t.id_validation != _id_validation);
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE core.validation SET id_company=$3, type_validation=$4, status_validation=$5, pattern_validation=$6, message_validation=$7, deleted_validation=$8 WHERE id_validation=$2 RETURNING id_validation LOOP
					_RETURNING = _X.id_validation;
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'validation',_id_validation,'UPDATE', now()::timestamp, false));
						
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
				_EXCEPTION = 'Ya existe un registro con el id_validation '||_id_validation||'';
				RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
			END IF;
		ELSE 
			_EXCEPTION = 'EL registro se encuentra eliminado';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	ELSE
		_EXCEPTION = 'El registro con id '||_id_validation||' no se encuentra registrado en la tabla validation';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_validation_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;$_$;


ALTER FUNCTION core.dml_validation_update(id_user_ numeric, _id_validation numeric, _id_company numeric, _type_validation core."TYPE_VALIDATION", _status_validation boolean, _pattern_validation character varying, _message_validation character varying, _deleted_validation boolean) OWNER TO app_nashor;

--
-- TOC entry 474 (class 1255 OID 21408)
-- Name: dml_validation_update_modified(numeric, numeric, numeric, core."TYPE_VALIDATION", boolean, character varying, character varying, boolean); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.dml_validation_update_modified(id_user_ numeric, _id_validation numeric, _id_company numeric, _type_validation core."TYPE_VALIDATION", _status_validation boolean, _pattern_validation character varying, _message_validation character varying, _deleted_validation boolean) RETURNS TABLE(id_validation numeric, id_company numeric, type_validation core."TYPE_VALIDATION", status_validation boolean, pattern_validation character varying, message_validation character varying, deleted_validation boolean, id_setting numeric, name_company character varying, acronym_company character varying, address_company character varying, status_company boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION core.dml_validation_update_modified(id_user_ numeric, _id_validation numeric, _id_company numeric, _type_validation core."TYPE_VALIDATION", _status_validation boolean, _pattern_validation character varying, _message_validation character varying, _deleted_validation boolean) OWNER TO postgres;

--
-- TOC entry 412 (class 1255 OID 20557)
-- Name: global_encryption_password(); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.global_encryption_password() RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
	-- (OJO) LA CONTRASEÑA TIENE QUE SER DE 16 DIGITOS --
  	_PASSWORD CHARACTER VARYING DEFAULT 'eNcR$NaShOr$2022';
BEGIN
	RETURN _PASSWORD;
END;
$_$;


ALTER FUNCTION core.global_encryption_password() OWNER TO postgres;

--
-- TOC entry 418 (class 1255 OID 20563)
-- Name: security_cap_aes_decrypt(text); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.security_cap_aes_decrypt(_text_encrypted text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
  	_HEX TEXT DEFAULT '';
  	_PASS_ENCRYPT_ENCRYPTED TEXT DEFAULT '';
  	_TEXT_ALGORITHM_ENCRYPTED TEXT DEFAULT '';
  	_TEXT TEXT DEFAULT '';
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN
	_PASS_ENCRYPT_ENCRYPTED = (select * from core.security_cap_algorithm_encrypt((select * from core.global_encryption_password())));
	_HEX = (select encode((_PASS_ENCRYPT_ENCRYPTED)::bytea, 'hex'));
	
	_TEXT_ALGORITHM_ENCRYPTED = (select convert_from(
	  core.decrypt_iv(
		decode(''||_text_encrypted||'','base64')::bytea,
		decode(''||_HEX||'','hex')::bytea,
		decode(''||_HEX||'','hex')::bytea, 
		'aes'
	  ),
	  'utf8'
	));
	
	_TEXT = (select * from core.security_cap_algorithm_decrypt(_TEXT_ALGORITHM_ENCRYPTED));

	RETURN _TEXT;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'security_cap_aes_decrypt -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$$;


ALTER FUNCTION core.security_cap_aes_decrypt(_text_encrypted text) OWNER TO postgres;

--
-- TOC entry 420 (class 1255 OID 20565)
-- Name: security_cap_aes_decrypt_object(text); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.security_cap_aes_decrypt_object(_text_encrypted text) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
	_DECRYPTED_TEXT text;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_DECRYPTED_TEXT = (select * from core.security_cap_aes_decrypt(_text_encrypted));
	RETURN _DECRYPTED_TEXT::json;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'security_cap_aes_decrypt_object -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
-- select * from core.security_cap_aes_decrypt_object('q/maCwb5jAr16GXzNEy7wO9tt/cJprFW9i5vrly4iS4TtRlmOrNUj/HvNqPVxsjVXIkTVz4WQCil9tGmoRZiIZr32PwHg8nLZYHwE1lxZDs=')
$$;


ALTER FUNCTION core.security_cap_aes_decrypt_object(_text_encrypted text) OWNER TO postgres;

--
-- TOC entry 417 (class 1255 OID 20562)
-- Name: security_cap_aes_encrypt(text); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.security_cap_aes_encrypt(_text text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
  	_HEX TEXT DEFAULT '';
	_PASS_ENCRYPT_ENCRYPTED TEXT DEFAULT '';
	_TEXT_ENCRYPTED TEXT DEFAULT '';
  	_CIPHER_TEXT TEXT DEFAULT '';
	_CIPHER_TEXT_BASE64 TEXT DEFAULT '';
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN	
	_PASS_ENCRYPT_ENCRYPTED = (select * from core.security_cap_algorithm_encrypt((select * from core.global_encryption_password())));
	_TEXT_ENCRYPTED = (select * from core.security_cap_algorithm_encrypt(_text));
	
	_HEX = (select encode((_PASS_ENCRYPT_ENCRYPTED)::bytea, 'hex'));
	
	_CIPHER_TEXT = (select core.encrypt_iv(
		(''||_TEXT_ENCRYPTED||'')::bytea,
		decode(''||_HEX||'','hex')::bytea,
		decode(''||_HEX||'','hex')::bytea,
		'aes'::text
	  )::text);
	  
	  _CIPHER_TEXT_BASE64 = (select encode((''||_CIPHER_TEXT||'')::bytea, 'base64'));
	  
	RETURN _CIPHER_TEXT_BASE64;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'security_cap_aes_encrypt -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$$;


ALTER FUNCTION core.security_cap_aes_encrypt(_text text) OWNER TO postgres;

--
-- TOC entry 419 (class 1255 OID 20564)
-- Name: security_cap_aes_encrypt_object(json); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.security_cap_aes_encrypt_object(_object json) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	RETURN (select * from core.security_cap_aes_encrypt(_object::text));
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'security_cap_aes_encrypt_object -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
-- select * from core.security_cap_aes_encrypt_object('[{"id":"id","title":"title","subtitle":"subtitle","type":"type","icon":"icon"}]');
$$;


ALTER FUNCTION core.security_cap_aes_encrypt_object(_object json) OWNER TO postgres;

--
-- TOC entry 416 (class 1255 OID 20561)
-- Name: security_cap_algorithm_decrypt(text); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.security_cap_algorithm_decrypt(_string_position_invert text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
  	_STRING_INVERT TEXT DEFAULT '';
	_TEXT TEXT DEFAULT '';
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN	
	_STRING_INVERT = (select * from core.security_cap_string_position_invert(_string_position_invert));
	_TEXT = (select * from core.security_cap_string_invert(_STRING_INVERT));
	RETURN _TEXT;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'security_cap_algorithm_decrypt -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$$;


ALTER FUNCTION core.security_cap_algorithm_decrypt(_string_position_invert text) OWNER TO postgres;

--
-- TOC entry 415 (class 1255 OID 20560)
-- Name: security_cap_algorithm_encrypt(text); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.security_cap_algorithm_encrypt(_text text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
  	_STRING_INVERT TEXT DEFAULT '';
	_STRING_POSITION_INVERT TEXT DEFAULT '';
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN	
	_STRING_INVERT = (select * from core.security_cap_string_invert(_text));
	_STRING_POSITION_INVERT = (select * from core.security_cap_string_position_invert(_STRING_INVERT));
	RETURN _STRING_POSITION_INVERT;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'security_cap_algorithm_encrypt -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$$;


ALTER FUNCTION core.security_cap_algorithm_encrypt(_text text) OWNER TO postgres;

--
-- TOC entry 413 (class 1255 OID 20558)
-- Name: security_cap_string_invert(text); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.security_cap_string_invert(_string text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
  	_INVERTED TEXT DEFAULT '';
	H_ TEXT DEFAULT '';
	_X RECORD;
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN	
	FOR _X IN REVERSE char_length(_string)..1 LOOP
		_INVERTED = CONCAT(_INVERTED, (select substring(_string, _X, 1)));
       END LOOP;
	RETURN _INVERTED;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'security_cap_string_invert -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$$;


ALTER FUNCTION core.security_cap_string_invert(_string text) OWNER TO postgres;

--
-- TOC entry 414 (class 1255 OID 20559)
-- Name: security_cap_string_position_invert(text); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.security_cap_string_position_invert(_string text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
  	_POSITION_INVERTED TEXT DEFAULT '';
	_FIRST TEXT DEFAULT '';
	_SECOND TEXT DEFAULT '';
	_INTERMEDIATE_POSITION INTEGER;
	_X RECORD;
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN	
	_INTERMEDIATE_POSITION = char_length(_string) / 2;
	_FIRST = substring(_string, 1, _INTERMEDIATE_POSITION);
	
	IF (char_length(_string) % 2 = 0)THEN
		_SECOND = substring(_string, _INTERMEDIATE_POSITION +1, char_length(_string));
		_POSITION_INVERTED = CONCAT(_SECOND,_FIRST);
	ELSE 
		_SECOND = substring(_string, _INTERMEDIATE_POSITION +2, char_length(_string));
		_POSITION_INVERTED = CONCAT(_SECOND,substring(_string, _INTERMEDIATE_POSITION+1, 1),_FIRST);
	END IF;
	RETURN _POSITION_INVERTED;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'security_cap_string_position_invert -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$$;


ALTER FUNCTION core.security_cap_string_position_invert(_string text) OWNER TO postgres;

--
-- TOC entry 421 (class 1255 OID 21170)
-- Name: utils_get_date_maximum_hour(); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.utils_get_date_maximum_hour() RETURNS timestamp without time zone
    LANGUAGE plpgsql
    AS $$
DECLARE
 	_DAY DOUBLE PRECISION;
	_DAY_FINAL CHARACTER VARYING;
 	_MONTH DOUBLE PRECISION;
	_MONTH_FINAL CHARACTER VARYING;
 	_YEAR DOUBLE PRECISION;
 	_YEAR_FINAL CHARACTER VARYING;
	_DATE CHARACTER VARYING;
	_EXCEPTION TEXT DEFAULT 'Internal Error';
BEGIN
	_DAY = (select extract(day from now()::timestamp));
	_MONTH = (select extract(month from now()::timestamp));
	_YEAR = (select extract(year from now()::timestamp));
	
	IF (_DAY <= 9) THEN
		_DAY_FINAL = '0'||_DAY||'';
	ELSE
		_DAY_FINAL = ''||_DAY||'';
	END IF;
	
	IF (_MONTH <= 9) THEN
		_MONTH_FINAL = '0'||_MONTH||'';
	ELSE
		_MONTH_FINAL = ''||_MONTH||'';
	END IF;
	
	_YEAR_FINAL = ''||_YEAR||'';
	
	_DATE = ''||_YEAR_FINAL||'-'||_MONTH_FINAL||'-'||_DAY_FINAL||' 23:59:59';
	
	return _DATE::timestamp without time zone;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'utils_get_date_maximum_hour -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%', 'utils_get_date_maximum_hour -> '||_EXCEPTION||'' USING DETAIL = '_database';
		END IF;
END;
			 
$$;


ALTER FUNCTION core.utils_get_date_maximum_hour() OWNER TO postgres;

--
-- TOC entry 406 (class 1255 OID 20506)
-- Name: utils_get_table_dependency(character varying, character varying, numeric); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.utils_get_table_dependency(_schema character varying, _table_name character varying, _id_deleted numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT_TABLE NUMERIC;
	_COUNT_ID NUMERIC;
	_COUNT NUMERIC = 0;
	_COUNT_ROW_DELETED NUMERIC; 
	_TABLE CHARACTER VARYING DEFAULT '';
	_ID CHARACTER VARYING DEFAULT '';
	_X RECORD;
	_Y RECORD;
	_Z RECORD;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_COUNT_TABLE = (SELECT count(*) FROM information_schema.tables iet WHERE iet.table_schema = ''||_schema||'' and iet.table_type = 'BASE TABLE' and iet.table_name = ''||_table_name||'');
	
	IF (_COUNT_TABLE != 1) THEN
		_EXCEPTION = 'La tabla '||_table_name||' no se encuentra registrada';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	ELSE
		FOR _X IN EXECUTE 'SELECT count(*) FROM '||_schema||'.'||_table_name||' t WHERE t.id_'||_table_name||' = '||_id_deleted||'' LOOP
			_COUNT_ID = _X.count;
		END LOOP;
		
		IF (_COUNT_ID = 0) THEN
			_EXCEPTION = 'El registro con id '||_id_deleted||' no se encuentra registrado en la tabla '||_table_name||'';
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		ELSE 
			FOR _Y IN SELECT iec.table_name::character varying as _table FROM information_schema.columns iec WHERE iec.table_schema = ''||_schema||'' and iec.column_name = 'id_'||_table_name||'' and iec.is_nullable = 'NO' and iec.ordinal_position != 1 LOOP
				_TABLE = ''||_schema||'.'||_Y._table||'';
				_ID = 't.id_'||_table_name||'';
				
				_COUNT_ROW_DELETED = (SELECT count(*) FROM information_schema.columns t WHERE t.table_schema = ''||_schema||'' and t.table_name = ''||_Y._table||'' and t.column_name = 'deleted_'||_Y._table||'');
				
				IF (_COUNT_ROW_DELETED) THEN
					FOR _Z IN EXECUTE 'select count(*) from '||_schema||'.view_'||_Y._table||' t where '||_ID||' = '||_id_deleted||'' LOOP
						-- DEBUG
						IF (_Z.count >= 1) THEN
							-- RAISE NOTICE 'TABLE = %', _Y._table;
							-- RAISE NOTICE 'ID = %', _id_deleted;
						END IF;
						-- DEBUG
						_COUNT = _COUNT + _Z.count;
					END LOOP;
				ELSE
					FOR _Z IN EXECUTE 'select count(*) from '||_TABLE||' t where '||_ID||' = '||_id_deleted||'' LOOP
						-- DEBUG
						IF (_Z.count >= 1) THEN
							-- RAISE NOTICE 'TABLE = %', _Y._table;
							-- RAISE NOTICE 'ID = %', _id_deleted;
						END IF;
						-- DEBUG
						_COUNT = _COUNT + _Z.count;
					END LOOP;
				END IF;
			END LOOP;
			RETURN _COUNT;
		END IF;
	END IF;
	exception when others then 
		-- -- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'utils_get_table_dependency -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
 -- select * from core.utils_get_table_dependency('core','user', 1)
$$;


ALTER FUNCTION core.utils_get_table_dependency(_schema character varying, _table_name character varying, _id_deleted numeric) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 20657)
-- Name: area; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.area (
    id_area numeric(5,0) NOT NULL,
    id_company numeric(5,0) NOT NULL,
    name_area character varying(100),
    description_area character varying(250),
    deleted_area boolean
);


ALTER TABLE business.area OWNER TO app_nashor;

--
-- TOC entry 224 (class 1259 OID 20700)
-- Name: attached; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.attached (
    id_attached numeric(5,0) NOT NULL,
    id_company numeric(5,0) NOT NULL,
    name_attached character varying(100),
    description_attached character varying(250),
    length_mb_attached numeric(5,0),
    required_attached boolean,
    deleted_attached boolean
);


ALTER TABLE business.attached OWNER TO app_nashor;

--
-- TOC entry 241 (class 1259 OID 20791)
-- Name: column_process_item; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.column_process_item (
    id_column_process_item numeric(15,0) NOT NULL,
    id_plugin_item_column numeric(10,0) NOT NULL,
    id_process_item numeric(10,0) NOT NULL,
    value_column_process_item text,
    entry_date_column_process_item timestamp without time zone
);


ALTER TABLE business.column_process_item OWNER TO app_nashor;

--
-- TOC entry 222 (class 1259 OID 20687)
-- Name: control; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.control (
    id_control numeric(5,0) NOT NULL,
    id_company numeric(5,0) NOT NULL,
    type_control business."TYPE_CONTROL" NOT NULL,
    title_control character varying(50) NOT NULL,
    form_name_control character varying(50) NOT NULL,
    initial_value_control character varying(100) NOT NULL,
    required_control boolean NOT NULL,
    min_length_control numeric(3,0),
    max_length_control numeric(3,0),
    placeholder_control character varying(100),
    spell_check_control boolean,
    options_control json,
    in_use boolean,
    deleted_control boolean
);


ALTER TABLE business.control OWNER TO app_nashor;

--
-- TOC entry 225 (class 1259 OID 20705)
-- Name: documentation_profile; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.documentation_profile (
    id_documentation_profile numeric(5,0) NOT NULL,
    id_company numeric(5,0) NOT NULL,
    name_documentation_profile character varying(100),
    description_documentation_profile character varying(250),
    status_documentation_profile boolean,
    deleted_documentation_profile boolean
);


ALTER TABLE business.documentation_profile OWNER TO app_nashor;

--
-- TOC entry 226 (class 1259 OID 20710)
-- Name: documentation_profile_attached; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.documentation_profile_attached (
    id_documentation_profile_attached numeric(10,0) NOT NULL,
    id_documentation_profile numeric(5,0) NOT NULL,
    id_attached numeric(5,0) NOT NULL
);


ALTER TABLE business.documentation_profile_attached OWNER TO app_nashor;

--
-- TOC entry 228 (class 1259 OID 20720)
-- Name: flow; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.flow (
    id_flow numeric(5,0) NOT NULL,
    id_company numeric(5,0) NOT NULL,
    name_flow character varying(100),
    description_flow character varying(250),
    acronym_flow character varying(20),
    acronym_task character varying(20),
    sequential_flow numeric(10,0),
    deleted_flow boolean
);


ALTER TABLE business.flow OWNER TO app_nashor;

--
-- TOC entry 229 (class 1259 OID 20725)
-- Name: flow_version; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.flow_version (
    id_flow_version numeric(5,0) NOT NULL,
    id_flow numeric(5,0) NOT NULL,
    number_flow_version numeric(5,0),
    status_flow_version boolean,
    creation_date_flow_version timestamp without time zone,
    deleted_flow_version boolean
);


ALTER TABLE business.flow_version OWNER TO app_nashor;

--
-- TOC entry 231 (class 1259 OID 20735)
-- Name: flow_version_level; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.flow_version_level (
    id_flow_version_level numeric(10,0) NOT NULL,
    id_flow_version numeric(5,0) NOT NULL,
    id_level numeric(5,0),
    position_level numeric(5,0) NOT NULL,
    position_level_father numeric(5,0),
    type_element business."TYPE_ELEMENT" NOT NULL,
    id_control character varying(5),
    operator business."TYPE_OPERATOR",
    value_against character varying(250),
    option_true boolean,
    x numeric(10,0),
    y numeric(10,0)
);


ALTER TABLE business.flow_version_level OWNER TO app_nashor;

--
-- TOC entry 233 (class 1259 OID 20745)
-- Name: item; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.item (
    id_item numeric(5,0) NOT NULL,
    id_company numeric(5,0) NOT NULL,
    id_item_category numeric(5,0) NOT NULL,
    name_item character varying(100),
    description_item character varying(250),
    deleted_item boolean
);


ALTER TABLE business.item OWNER TO app_nashor;

--
-- TOC entry 232 (class 1259 OID 20740)
-- Name: item_category; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.item_category (
    id_item_category numeric(5,0) NOT NULL,
    id_company numeric(5,0) NOT NULL,
    name_item_category character varying(100),
    description_item_category character varying(250),
    deleted_item_category boolean
);


ALTER TABLE business.item_category OWNER TO app_nashor;

--
-- TOC entry 230 (class 1259 OID 20730)
-- Name: level; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.level (
    id_level numeric(5,0) NOT NULL,
    id_company numeric(5,0) NOT NULL,
    id_template numeric(5,0) NOT NULL,
    id_level_profile numeric(5,0) NOT NULL,
    id_level_status numeric(5,0) NOT NULL,
    name_level character varying(100),
    description_level character varying(250),
    deleted_level boolean
);


ALTER TABLE business.level OWNER TO app_nashor;

--
-- TOC entry 218 (class 1259 OID 20667)
-- Name: level_profile; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.level_profile (
    id_level_profile numeric(5,0) NOT NULL,
    id_company numeric(5,0) NOT NULL,
    name_level_profile character varying(100),
    description_level_profile character varying(250),
    deleted_level_profile boolean
);


ALTER TABLE business.level_profile OWNER TO app_nashor;

--
-- TOC entry 219 (class 1259 OID 20672)
-- Name: level_profile_official; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.level_profile_official (
    id_level_profile_official numeric(10,0) NOT NULL,
    id_level_profile numeric(5,0) NOT NULL,
    id_official numeric(10,0) NOT NULL,
    official_modifier boolean
);


ALTER TABLE business.level_profile_official OWNER TO app_nashor;

--
-- TOC entry 227 (class 1259 OID 20715)
-- Name: level_status; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.level_status (
    id_level_status numeric(5,0) NOT NULL,
    id_company numeric(5,0) NOT NULL,
    name_level_status character varying(100),
    description_level_status character varying(250),
    color_level_status character varying(9),
    deleted_level_status boolean
);


ALTER TABLE business.level_status OWNER TO app_nashor;

--
-- TOC entry 215 (class 1259 OID 20652)
-- Name: official; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.official (
    id_official numeric(10,0) NOT NULL,
    id_company numeric(5,0) NOT NULL,
    id_user numeric(10,0) NOT NULL,
    id_area numeric(5,0) NOT NULL,
    id_position numeric(5,0) NOT NULL,
    deleted_official boolean
);


ALTER TABLE business.official OWNER TO app_nashor;

--
-- TOC entry 239 (class 1259 OID 20781)
-- Name: plugin_item; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.plugin_item (
    id_plugin_item numeric(5,0) NOT NULL,
    id_company numeric(5,0) NOT NULL,
    name_plugin_item character varying(100),
    description_plugin_item character varying(250),
    select_plugin_item boolean
);


ALTER TABLE business.plugin_item OWNER TO app_nashor;

--
-- TOC entry 240 (class 1259 OID 20786)
-- Name: plugin_item_column; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.plugin_item_column (
    id_plugin_item_column numeric(10,0) NOT NULL,
    id_plugin_item numeric(5,0) NOT NULL,
    name_plugin_item_column character varying(100),
    lenght_plugin_item_column numeric(10,0)
);


ALTER TABLE business.plugin_item_column OWNER TO app_nashor;

--
-- TOC entry 217 (class 1259 OID 20662)
-- Name: position; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business."position" (
    id_position numeric(5,0) NOT NULL,
    id_company numeric(5,0) NOT NULL,
    name_position character varying(100),
    description_position character varying(250),
    deleted_position boolean
);


ALTER TABLE business."position" OWNER TO app_nashor;

--
-- TOC entry 220 (class 1259 OID 20677)
-- Name: process; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.process (
    id_process numeric(10,0) NOT NULL,
    id_official numeric(10,0) NOT NULL,
    id_flow_version numeric(5,0) NOT NULL,
    number_process character varying(150),
    date_process timestamp without time zone,
    generated_task boolean,
    finalized_process boolean,
    deleted_process boolean
);


ALTER TABLE business.process OWNER TO app_nashor;

--
-- TOC entry 237 (class 1259 OID 20765)
-- Name: process_attached; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.process_attached (
    id_process_attached numeric(10,0) NOT NULL,
    id_official numeric(10,0) NOT NULL,
    id_process numeric(10,0) NOT NULL,
    id_task numeric(10,0) NOT NULL,
    id_level numeric(5,0) NOT NULL,
    id_attached numeric(5,0) NOT NULL,
    file_name character varying(250),
    length_mb character varying(10),
    extension character varying(10),
    server_path character varying(250),
    alfresco_path character varying(250),
    upload_date timestamp without time zone,
    deleted_process_attached boolean
);


ALTER TABLE business.process_attached OWNER TO app_nashor;

--
-- TOC entry 236 (class 1259 OID 20760)
-- Name: process_comment; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.process_comment (
    id_process_comment numeric(10,0) NOT NULL,
    id_official numeric(10,0) NOT NULL,
    id_process numeric(10,0) NOT NULL,
    id_task numeric(10,0) NOT NULL,
    id_level numeric(5,0) NOT NULL,
    value_process_comment character varying(250),
    date_process_comment timestamp without time zone,
    deleted_process_comment boolean
);


ALTER TABLE business.process_comment OWNER TO app_nashor;

--
-- TOC entry 238 (class 1259 OID 20773)
-- Name: process_control; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.process_control (
    id_process_control numeric(10,0) NOT NULL,
    id_official numeric(10,0) NOT NULL,
    id_process numeric(10,0) NOT NULL,
    id_task numeric(10,0) NOT NULL,
    id_level numeric(5,0) NOT NULL,
    id_control numeric(5,0) NOT NULL,
    value_process_control text,
    last_change_process_control timestamp without time zone,
    deleted_process_control boolean
);


ALTER TABLE business.process_control OWNER TO app_nashor;

--
-- TOC entry 234 (class 1259 OID 20750)
-- Name: process_item; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.process_item (
    id_process_item numeric(10,0) NOT NULL,
    id_official numeric(10,0) NOT NULL,
    id_process numeric(10,0) NOT NULL,
    id_task numeric(10,0) NOT NULL,
    id_level numeric(5,0) NOT NULL,
    id_item numeric(5,0)
);


ALTER TABLE business.process_item OWNER TO app_nashor;

--
-- TOC entry 282 (class 1259 OID 21495)
-- Name: serial_area; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_area
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999
    CACHE 1;


ALTER TABLE business.serial_area OWNER TO app_nashor;

--
-- TOC entry 287 (class 1259 OID 21505)
-- Name: serial_attached; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_attached
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999
    CACHE 1;


ALTER TABLE business.serial_attached OWNER TO app_nashor;

--
-- TOC entry 307 (class 1259 OID 21545)
-- Name: serial_column_process_item; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_column_process_item
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 999999999999999
    CACHE 1;


ALTER TABLE business.serial_column_process_item OWNER TO app_nashor;

--
-- TOC entry 286 (class 1259 OID 21503)
-- Name: serial_control; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_control
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999
    CACHE 1;


ALTER TABLE business.serial_control OWNER TO app_nashor;

--
-- TOC entry 288 (class 1259 OID 21507)
-- Name: serial_documentation_profile; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_documentation_profile
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999
    CACHE 1;


ALTER TABLE business.serial_documentation_profile OWNER TO app_nashor;

--
-- TOC entry 298 (class 1259 OID 21527)
-- Name: serial_documentation_profile_attached; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_documentation_profile_attached
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999999
    CACHE 1;


ALTER TABLE business.serial_documentation_profile_attached OWNER TO app_nashor;

--
-- TOC entry 290 (class 1259 OID 21511)
-- Name: serial_flow; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_flow
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999
    CACHE 1;


ALTER TABLE business.serial_flow OWNER TO app_nashor;

--
-- TOC entry 363 (class 1259 OID 22174)
-- Name: serial_flow_id_1; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_flow_id_1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999999
    CACHE 1;


ALTER TABLE business.serial_flow_id_1 OWNER TO app_nashor;

--
-- TOC entry 299 (class 1259 OID 21529)
-- Name: serial_flow_version; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_flow_version
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999
    CACHE 1;


ALTER TABLE business.serial_flow_version OWNER TO app_nashor;

--
-- TOC entry 300 (class 1259 OID 21531)
-- Name: serial_flow_version_level; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_flow_version_level
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999999
    CACHE 1;


ALTER TABLE business.serial_flow_version_level OWNER TO app_nashor;

--
-- TOC entry 293 (class 1259 OID 21517)
-- Name: serial_item; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_item
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999
    CACHE 1;


ALTER TABLE business.serial_item OWNER TO app_nashor;

--
-- TOC entry 292 (class 1259 OID 21515)
-- Name: serial_item_category; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_item_category
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999
    CACHE 1;


ALTER TABLE business.serial_item_category OWNER TO app_nashor;

--
-- TOC entry 291 (class 1259 OID 21513)
-- Name: serial_level; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_level
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999
    CACHE 1;


ALTER TABLE business.serial_level OWNER TO app_nashor;

--
-- TOC entry 284 (class 1259 OID 21499)
-- Name: serial_level_profile; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_level_profile
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999
    CACHE 1;


ALTER TABLE business.serial_level_profile OWNER TO app_nashor;

--
-- TOC entry 295 (class 1259 OID 21521)
-- Name: serial_level_profile_official; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_level_profile_official
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999999
    CACHE 1;


ALTER TABLE business.serial_level_profile_official OWNER TO app_nashor;

--
-- TOC entry 289 (class 1259 OID 21509)
-- Name: serial_level_status; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_level_status
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999
    CACHE 1;


ALTER TABLE business.serial_level_status OWNER TO app_nashor;

--
-- TOC entry 281 (class 1259 OID 21493)
-- Name: serial_official; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_official
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999999
    CACHE 1;


ALTER TABLE business.serial_official OWNER TO app_nashor;

--
-- TOC entry 294 (class 1259 OID 21519)
-- Name: serial_plugin_item; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_plugin_item
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999
    CACHE 1;


ALTER TABLE business.serial_plugin_item OWNER TO app_nashor;

--
-- TOC entry 306 (class 1259 OID 21543)
-- Name: serial_plugin_item_column; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_plugin_item_column
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999999
    CACHE 1;


ALTER TABLE business.serial_plugin_item_column OWNER TO app_nashor;

--
-- TOC entry 283 (class 1259 OID 21497)
-- Name: serial_position; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_position
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999
    CACHE 1;


ALTER TABLE business.serial_position OWNER TO app_nashor;

--
-- TOC entry 296 (class 1259 OID 21523)
-- Name: serial_process; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_process
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999999
    CACHE 1;


ALTER TABLE business.serial_process OWNER TO app_nashor;

--
-- TOC entry 304 (class 1259 OID 21539)
-- Name: serial_process_attached; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_process_attached
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999999
    CACHE 1;


ALTER TABLE business.serial_process_attached OWNER TO app_nashor;

--
-- TOC entry 303 (class 1259 OID 21537)
-- Name: serial_process_comment; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_process_comment
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999999
    CACHE 1;


ALTER TABLE business.serial_process_comment OWNER TO app_nashor;

--
-- TOC entry 305 (class 1259 OID 21541)
-- Name: serial_process_control; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_process_control
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999999
    CACHE 1;


ALTER TABLE business.serial_process_control OWNER TO app_nashor;

--
-- TOC entry 301 (class 1259 OID 21533)
-- Name: serial_process_item; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_process_item
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999999
    CACHE 1;


ALTER TABLE business.serial_process_item OWNER TO app_nashor;

--
-- TOC entry 302 (class 1259 OID 21535)
-- Name: serial_task; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_task
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999999
    CACHE 1;


ALTER TABLE business.serial_task OWNER TO app_nashor;

--
-- TOC entry 285 (class 1259 OID 21501)
-- Name: serial_template; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_template
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999
    CACHE 1;


ALTER TABLE business.serial_template OWNER TO app_nashor;

--
-- TOC entry 297 (class 1259 OID 21525)
-- Name: serial_template_control; Type: SEQUENCE; Schema: business; Owner: app_nashor
--

CREATE SEQUENCE business.serial_template_control
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999999
    CACHE 1;


ALTER TABLE business.serial_template_control OWNER TO app_nashor;

--
-- TOC entry 235 (class 1259 OID 20755)
-- Name: task; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.task (
    id_task numeric(10,0) NOT NULL,
    id_process numeric(10,0) NOT NULL,
    id_official numeric(10,0) NOT NULL,
    id_level numeric(5,0) NOT NULL,
    number_task character varying(120),
    type_status_task business."TYPE_STATUS_TASK" NOT NULL,
    date_task timestamp without time zone,
    deleted_task boolean
);


ALTER TABLE business.task OWNER TO app_nashor;

--
-- TOC entry 221 (class 1259 OID 20682)
-- Name: template; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.template (
    id_template numeric(5,0) NOT NULL,
    id_company numeric(5,0) NOT NULL,
    id_documentation_profile numeric(5,0),
    id_plugin_item numeric(5,0),
    plugin_attached_process boolean,
    plugin_item_process boolean,
    name_template character varying(100),
    description_template character varying(250),
    status_template boolean,
    last_change timestamp without time zone,
    in_use boolean,
    deleted_template boolean
);


ALTER TABLE business.template OWNER TO app_nashor;

--
-- TOC entry 223 (class 1259 OID 20695)
-- Name: template_control; Type: TABLE; Schema: business; Owner: app_nashor
--

CREATE TABLE business.template_control (
    id_template_control numeric(10,0) NOT NULL,
    id_template numeric(5,0) NOT NULL,
    id_control numeric(5,0) NOT NULL,
    ordinal_position numeric(3,0) NOT NULL
);


ALTER TABLE business.template_control OWNER TO app_nashor;

--
-- TOC entry 309 (class 1259 OID 21551)
-- Name: view_area; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_area AS
 SELECT bva.id_area,
    bva.id_company,
    bva.name_area,
    bva.description_area,
    bva.deleted_area
   FROM business.area bva
  WHERE (bva.deleted_area = false)
  ORDER BY bva.id_area DESC;


ALTER TABLE business.view_area OWNER TO app_nashor;

--
-- TOC entry 203 (class 1259 OID 20571)
-- Name: company; Type: TABLE; Schema: core; Owner: app_nashor
--

CREATE TABLE core.company (
    id_company numeric(5,0) NOT NULL,
    id_setting numeric(5,0) NOT NULL,
    name_company character varying(100),
    acronym_company character varying(50),
    address_company character varying(250),
    status_company boolean,
    deleted_company boolean
);


ALTER TABLE core.company OWNER TO app_nashor;

--
-- TOC entry 256 (class 1259 OID 21219)
-- Name: view_company; Type: VIEW; Schema: core; Owner: app_nashor
--

CREATE VIEW core.view_company AS
 SELECT cvc.id_company,
    cvc.id_setting,
    cvc.name_company,
    cvc.acronym_company,
    cvc.address_company,
    cvc.status_company,
    cvc.deleted_company
   FROM core.company cvc
  WHERE (cvc.deleted_company = false)
  ORDER BY cvc.id_company DESC;


ALTER TABLE core.view_company OWNER TO app_nashor;

--
-- TOC entry 335 (class 1259 OID 21878)
-- Name: view_area_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_area_inner_join AS
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
   FROM (business.view_area bva
     JOIN core.view_company cvc ON ((bva.id_company = cvc.id_company)))
  WHERE (bva.deleted_area = false)
  ORDER BY bva.id_area DESC;


ALTER TABLE business.view_area_inner_join OWNER TO postgres;

--
-- TOC entry 314 (class 1259 OID 21571)
-- Name: view_attached; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_attached AS
 SELECT bva.id_attached,
    bva.id_company,
    bva.name_attached,
    bva.description_attached,
    bva.length_mb_attached,
    bva.required_attached,
    bva.deleted_attached
   FROM business.attached bva
  WHERE (bva.deleted_attached = false)
  ORDER BY bva.id_attached DESC;


ALTER TABLE business.view_attached OWNER TO app_nashor;

--
-- TOC entry 338 (class 1259 OID 21891)
-- Name: view_attached_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_attached_inner_join AS
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
   FROM (business.view_attached bva
     JOIN core.view_company cvc ON ((bva.id_company = cvc.id_company)))
  WHERE (bva.deleted_attached = false)
  ORDER BY bva.id_attached DESC;


ALTER TABLE business.view_attached_inner_join OWNER TO postgres;

--
-- TOC entry 334 (class 1259 OID 21651)
-- Name: view_column_process_item; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_column_process_item AS
 SELECT bvcpi.id_column_process_item,
    bvcpi.id_plugin_item_column,
    bvcpi.id_process_item,
    bvcpi.value_column_process_item,
    bvcpi.entry_date_column_process_item
   FROM business.column_process_item bvcpi
  ORDER BY bvcpi.id_column_process_item DESC;


ALTER TABLE business.view_column_process_item OWNER TO app_nashor;

--
-- TOC entry 333 (class 1259 OID 21647)
-- Name: view_plugin_item_column; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_plugin_item_column AS
 SELECT bvpic.id_plugin_item_column,
    bvpic.id_plugin_item,
    bvpic.name_plugin_item_column,
    bvpic.lenght_plugin_item_column
   FROM business.plugin_item_column bvpic
  ORDER BY bvpic.id_plugin_item_column DESC;


ALTER TABLE business.view_plugin_item_column OWNER TO app_nashor;

--
-- TOC entry 328 (class 1259 OID 21627)
-- Name: view_process_item; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_process_item AS
 SELECT bvpi.id_process_item,
    bvpi.id_official,
    bvpi.id_process,
    bvpi.id_task,
    bvpi.id_level,
    bvpi.id_item
   FROM business.process_item bvpi
  ORDER BY bvpi.id_process_item DESC;


ALTER TABLE business.view_process_item OWNER TO app_nashor;

--
-- TOC entry 358 (class 1259 OID 21988)
-- Name: view_column_process_item_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_column_process_item_inner_join AS
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
   FROM ((business.view_column_process_item bvcpi
     JOIN business.view_plugin_item_column bvpic ON ((bvcpi.id_plugin_item_column = bvpic.id_plugin_item_column)))
     JOIN business.view_process_item bvpi ON ((bvcpi.id_process_item = bvpi.id_process_item)))
  ORDER BY bvcpi.id_column_process_item DESC;


ALTER TABLE business.view_column_process_item_inner_join OWNER TO postgres;

--
-- TOC entry 313 (class 1259 OID 21567)
-- Name: view_control; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_control AS
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
    bvc.deleted_control
   FROM business.control bvc
  WHERE (bvc.deleted_control = false)
  ORDER BY bvc.id_control DESC;


ALTER TABLE business.view_control OWNER TO app_nashor;

--
-- TOC entry 343 (class 1259 OID 21915)
-- Name: view_control_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_control_inner_join AS
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
   FROM (business.view_control bvc
     JOIN core.view_company cvc ON ((bvc.id_company = cvc.id_company)))
  WHERE (bvc.deleted_control = false)
  ORDER BY bvc.id_control DESC;


ALTER TABLE business.view_control_inner_join OWNER TO postgres;

--
-- TOC entry 318 (class 1259 OID 21587)
-- Name: view_level; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_level AS
 SELECT bvl.id_level,
    bvl.id_company,
    bvl.id_template,
    bvl.id_level_profile,
    bvl.id_level_status,
    bvl.name_level,
    bvl.description_level,
    bvl.deleted_level
   FROM business.level bvl
  WHERE (bvl.deleted_level = false)
  ORDER BY bvl.id_level DESC;


ALTER TABLE business.view_level OWNER TO app_nashor;

--
-- TOC entry 312 (class 1259 OID 21563)
-- Name: view_template; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_template AS
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
    bvt.deleted_template
   FROM business.template bvt
  WHERE (bvt.deleted_template = false)
  ORDER BY bvt.id_template DESC;


ALTER TABLE business.view_template OWNER TO app_nashor;

--
-- TOC entry 324 (class 1259 OID 21611)
-- Name: view_template_control; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_template_control AS
 SELECT bvtc.id_template_control,
    bvtc.id_template,
    bvtc.id_control,
    bvtc.ordinal_position
   FROM business.template_control bvtc
  ORDER BY bvtc.id_template_control DESC;


ALTER TABLE business.view_template_control OWNER TO app_nashor;

--
-- TOC entry 355 (class 1259 OID 21973)
-- Name: view_control_inner_join_bvt_bvtc_bvc; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_control_inner_join_bvt_bvtc_bvc AS
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
   FROM (((business.view_level bvl
     JOIN business.view_template bvt ON ((bvl.id_template = bvt.id_template)))
     JOIN business.view_template_control bvtc ON ((bvt.id_template = bvtc.id_template)))
     JOIN business.view_control bvc ON ((bvtc.id_control = bvc.id_control)))
  ORDER BY bvc.id_control DESC;


ALTER TABLE business.view_control_inner_join_bvt_bvtc_bvc OWNER TO postgres;

--
-- TOC entry 315 (class 1259 OID 21575)
-- Name: view_documentation_profile; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_documentation_profile AS
 SELECT bvdp.id_documentation_profile,
    bvdp.id_company,
    bvdp.name_documentation_profile,
    bvdp.description_documentation_profile,
    bvdp.status_documentation_profile,
    bvdp.deleted_documentation_profile
   FROM business.documentation_profile bvdp
  WHERE (bvdp.deleted_documentation_profile = false)
  ORDER BY bvdp.id_documentation_profile DESC;


ALTER TABLE business.view_documentation_profile OWNER TO app_nashor;

--
-- TOC entry 325 (class 1259 OID 21615)
-- Name: view_documentation_profile_attached; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_documentation_profile_attached AS
 SELECT bvdpa.id_documentation_profile_attached,
    bvdpa.id_documentation_profile,
    bvdpa.id_attached
   FROM business.documentation_profile_attached bvdpa
  ORDER BY bvdpa.id_documentation_profile_attached DESC;


ALTER TABLE business.view_documentation_profile_attached OWNER TO app_nashor;

--
-- TOC entry 340 (class 1259 OID 21901)
-- Name: view_documentation_profile_attached_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_documentation_profile_attached_inner_join AS
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
   FROM ((business.view_documentation_profile_attached bvdpa
     JOIN business.view_documentation_profile bvdp ON ((bvdpa.id_documentation_profile = bvdp.id_documentation_profile)))
     JOIN business.view_attached bva ON ((bvdpa.id_attached = bva.id_attached)))
  ORDER BY bvdpa.id_documentation_profile_attached DESC;


ALTER TABLE business.view_documentation_profile_attached_inner_join OWNER TO postgres;

--
-- TOC entry 339 (class 1259 OID 21896)
-- Name: view_documentation_profile_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_documentation_profile_inner_join AS
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
   FROM (business.view_documentation_profile bvdp
     JOIN core.view_company cvc ON ((bvdp.id_company = cvc.id_company)))
  WHERE (bvdp.deleted_documentation_profile = false)
  ORDER BY bvdp.id_documentation_profile DESC;


ALTER TABLE business.view_documentation_profile_inner_join OWNER TO postgres;

--
-- TOC entry 317 (class 1259 OID 21583)
-- Name: view_flow; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_flow AS
 SELECT bvf.id_flow,
    bvf.id_company,
    bvf.name_flow,
    bvf.description_flow,
    bvf.acronym_flow,
    bvf.acronym_task,
    bvf.sequential_flow,
    bvf.deleted_flow
   FROM business.flow bvf
  WHERE (bvf.deleted_flow = false)
  ORDER BY bvf.id_flow DESC;


ALTER TABLE business.view_flow OWNER TO app_nashor;

--
-- TOC entry 347 (class 1259 OID 21934)
-- Name: view_flow_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_flow_inner_join AS
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
   FROM (business.view_flow bvf
     JOIN core.view_company cvc ON ((bvf.id_company = cvc.id_company)))
  WHERE (bvf.deleted_flow = false)
  ORDER BY bvf.id_flow DESC;


ALTER TABLE business.view_flow_inner_join OWNER TO postgres;

--
-- TOC entry 326 (class 1259 OID 21619)
-- Name: view_flow_version; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_flow_version AS
 SELECT bvfv.id_flow_version,
    bvfv.id_flow,
    bvfv.number_flow_version,
    bvfv.status_flow_version,
    bvfv.creation_date_flow_version,
    bvfv.deleted_flow_version
   FROM business.flow_version bvfv
  WHERE (bvfv.deleted_flow_version = false)
  ORDER BY bvfv.id_flow_version DESC;


ALTER TABLE business.view_flow_version OWNER TO app_nashor;

--
-- TOC entry 352 (class 1259 OID 21958)
-- Name: view_flow_version_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_flow_version_inner_join AS
 SELECT bvfv.id_flow_version,
    bvfv.id_flow,
    bvfv.number_flow_version,
    bvfv.status_flow_version,
    bvfv.creation_date_flow_version,
    bvfv.deleted_flow_version,
    bvf.id_company,
    bvf.name_flow,
    bvf.description_flow
   FROM (business.view_flow_version bvfv
     JOIN business.view_flow bvf ON ((bvfv.id_flow = bvf.id_flow)))
  WHERE (bvfv.deleted_flow_version = false)
  ORDER BY bvfv.id_flow_version DESC;


ALTER TABLE business.view_flow_version_inner_join OWNER TO postgres;

--
-- TOC entry 327 (class 1259 OID 21623)
-- Name: view_flow_version_level; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_flow_version_level AS
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
    bvfvl.y
   FROM business.flow_version_level bvfvl
  ORDER BY bvfvl.id_flow_version_level DESC;


ALTER TABLE business.view_flow_version_level OWNER TO app_nashor;

--
-- TOC entry 353 (class 1259 OID 21963)
-- Name: view_flow_version_level_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_flow_version_level_inner_join AS
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
   FROM ((business.view_flow_version_level bvfvl
     JOIN business.view_flow_version bvfv ON ((bvfvl.id_flow_version = bvfv.id_flow_version)))
     JOIN business.view_level bvl ON ((bvfvl.id_level = bvl.id_level)))
  ORDER BY bvfvl.id_flow_version_level DESC;


ALTER TABLE business.view_flow_version_level_inner_join OWNER TO postgres;

--
-- TOC entry 320 (class 1259 OID 21595)
-- Name: view_item; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_item AS
 SELECT bvi.id_item,
    bvi.id_company,
    bvi.id_item_category,
    bvi.name_item,
    bvi.description_item,
    bvi.deleted_item
   FROM business.item bvi
  WHERE (bvi.deleted_item = false)
  ORDER BY bvi.id_item DESC;


ALTER TABLE business.view_item OWNER TO app_nashor;

--
-- TOC entry 319 (class 1259 OID 21591)
-- Name: view_item_category; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_item_category AS
 SELECT bvic.id_item_category,
    bvic.id_company,
    bvic.name_item_category,
    bvic.description_item_category,
    bvic.deleted_item_category
   FROM business.item_category bvic
  WHERE (bvic.deleted_item_category = false)
  ORDER BY bvic.id_item_category DESC;


ALTER TABLE business.view_item_category OWNER TO app_nashor;

--
-- TOC entry 341 (class 1259 OID 21906)
-- Name: view_item_category_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_item_category_inner_join AS
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
   FROM (business.view_item_category bvic
     JOIN core.view_company cvc ON ((bvic.id_company = cvc.id_company)))
  WHERE (bvic.deleted_item_category = false)
  ORDER BY bvic.id_item_category DESC;


ALTER TABLE business.view_item_category_inner_join OWNER TO postgres;

--
-- TOC entry 342 (class 1259 OID 21910)
-- Name: view_item_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_item_inner_join AS
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
   FROM ((business.view_item bvi
     JOIN core.view_company cvc ON ((bvi.id_company = cvc.id_company)))
     JOIN business.view_item_category bvic ON ((bvi.id_item_category = bvic.id_item_category)))
  WHERE (bvi.deleted_item = false)
  ORDER BY bvi.id_item DESC;


ALTER TABLE business.view_item_inner_join OWNER TO postgres;

--
-- TOC entry 311 (class 1259 OID 21559)
-- Name: view_level_profile; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_level_profile AS
 SELECT bvlp.id_level_profile,
    bvlp.id_company,
    bvlp.name_level_profile,
    bvlp.description_level_profile,
    bvlp.deleted_level_profile
   FROM business.level_profile bvlp
  WHERE (bvlp.deleted_level_profile = false)
  ORDER BY bvlp.id_level_profile DESC;


ALTER TABLE business.view_level_profile OWNER TO app_nashor;

--
-- TOC entry 316 (class 1259 OID 21579)
-- Name: view_level_status; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_level_status AS
 SELECT bvls.id_level_status,
    bvls.id_company,
    bvls.name_level_status,
    bvls.description_level_status,
    bvls.color_level_status,
    bvls.deleted_level_status
   FROM business.level_status bvls
  WHERE (bvls.deleted_level_status = false)
  ORDER BY bvls.id_level_status DESC;


ALTER TABLE business.view_level_status OWNER TO app_nashor;

--
-- TOC entry 351 (class 1259 OID 21953)
-- Name: view_level_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_level_inner_join AS
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
   FROM ((((business.view_level bvl
     JOIN core.view_company cvc ON ((bvl.id_company = cvc.id_company)))
     JOIN business.view_template bvt ON ((bvl.id_template = bvt.id_template)))
     JOIN business.view_level_profile bvlp ON ((bvl.id_level_profile = bvlp.id_level_profile)))
     JOIN business.view_level_status bvls ON ((bvl.id_level_status = bvls.id_level_status)))
  WHERE (bvl.deleted_level = false)
  ORDER BY bvl.id_level DESC;


ALTER TABLE business.view_level_inner_join OWNER TO postgres;

--
-- TOC entry 349 (class 1259 OID 21944)
-- Name: view_level_profile_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_level_profile_inner_join AS
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
   FROM (business.view_level_profile bvlp
     JOIN core.view_company cvc ON ((bvlp.id_company = cvc.id_company)))
  WHERE (bvlp.deleted_level_profile = false)
  ORDER BY bvlp.id_level_profile DESC;


ALTER TABLE business.view_level_profile_inner_join OWNER TO postgres;

--
-- TOC entry 322 (class 1259 OID 21603)
-- Name: view_level_profile_official; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_level_profile_official AS
 SELECT bvlpo.id_level_profile_official,
    bvlpo.id_level_profile,
    bvlpo.id_official,
    bvlpo.official_modifier
   FROM business.level_profile_official bvlpo
  ORDER BY bvlpo.id_level_profile_official DESC;


ALTER TABLE business.view_level_profile_official OWNER TO app_nashor;

--
-- TOC entry 308 (class 1259 OID 21547)
-- Name: view_official; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_official AS
 SELECT bvo.id_official,
    bvo.id_company,
    bvo.id_user,
    bvo.id_area,
    bvo.id_position,
    bvo.deleted_official
   FROM business.official bvo
  WHERE (bvo.deleted_official = false)
  ORDER BY bvo.id_official DESC;


ALTER TABLE business.view_official OWNER TO app_nashor;

--
-- TOC entry 329 (class 1259 OID 21631)
-- Name: view_task; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_task AS
 SELECT bvt.id_task,
    bvt.id_process,
    bvt.id_official,
    bvt.id_level,
    bvt.number_task,
    bvt.type_status_task,
    bvt.date_task,
    bvt.deleted_task
   FROM business.task bvt
  WHERE (bvt.deleted_task = false)
  ORDER BY bvt.id_task DESC;


ALTER TABLE business.view_task OWNER TO app_nashor;

--
-- TOC entry 206 (class 1259 OID 20592)
-- Name: person; Type: TABLE; Schema: core; Owner: app_nashor
--

CREATE TABLE core.person (
    id_person numeric(10,0) NOT NULL,
    id_academic numeric(10,0) NOT NULL,
    id_job numeric(10,0) NOT NULL,
    dni_person character varying(20),
    name_person character varying(150),
    last_name_person character varying(150),
    address_person character varying(150),
    phone_person character varying(13),
    deleted_person boolean
);


ALTER TABLE core.person OWNER TO app_nashor;

--
-- TOC entry 210 (class 1259 OID 20615)
-- Name: user; Type: TABLE; Schema: core; Owner: app_nashor
--

CREATE TABLE core."user" (
    id_user numeric(10,0) NOT NULL,
    id_company numeric(5,0) NOT NULL,
    id_person numeric(10,0) NOT NULL,
    id_type_user numeric(5,0) NOT NULL,
    name_user character varying(320),
    password_user character varying(250),
    avatar_user character varying(50),
    status_user boolean,
    deleted_user boolean
);


ALTER TABLE core."user" OWNER TO app_nashor;

--
-- TOC entry 259 (class 1259 OID 21231)
-- Name: view_person; Type: VIEW; Schema: core; Owner: app_nashor
--

CREATE VIEW core.view_person AS
 SELECT cvp.id_person,
    cvp.id_academic,
    cvp.id_job,
    cvp.dni_person,
    cvp.name_person,
    cvp.last_name_person,
    cvp.address_person,
    cvp.phone_person,
    cvp.deleted_person
   FROM core.person cvp
  WHERE (cvp.deleted_person = false)
  ORDER BY cvp.id_person DESC;


ALTER TABLE core.view_person OWNER TO app_nashor;

--
-- TOC entry 263 (class 1259 OID 21247)
-- Name: view_user; Type: VIEW; Schema: core; Owner: app_nashor
--

CREATE VIEW core.view_user AS
 SELECT cvu.id_user,
    cvu.id_company,
    cvu.id_person,
    cvu.id_type_user,
    cvu.name_user,
    cvu.password_user,
    cvu.avatar_user,
    cvu.status_user,
    cvu.deleted_user
   FROM core."user" cvu
  WHERE (cvu.deleted_user = false)
  ORDER BY cvu.id_user DESC;


ALTER TABLE core.view_user OWNER TO app_nashor;

--
-- TOC entry 350 (class 1259 OID 21948)
-- Name: view_level_profile_official_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_level_profile_official_inner_join AS
 SELECT (( SELECT count(*) AS count
           FROM business.view_task bvt
          WHERE ((bvt.id_official = bvlpo.id_official) AND (bvt.type_status_task = 'progress'::business."TYPE_STATUS_TASK"))))::numeric AS number_task,
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
   FROM ((((business.view_level_profile_official bvlpo
     JOIN business.view_level_profile bvlp ON ((bvlpo.id_level_profile = bvlp.id_level_profile)))
     JOIN business.view_official bvo ON ((bvlpo.id_official = bvo.id_official)))
     JOIN core.view_user cvu ON ((bvo.id_user = cvu.id_user)))
     JOIN core.view_person cvp ON ((cvu.id_person = cvp.id_person)))
  ORDER BY bvlpo.id_level_profile_official DESC;


ALTER TABLE business.view_level_profile_official_inner_join OWNER TO postgres;

--
-- TOC entry 348 (class 1259 OID 21939)
-- Name: view_level_status_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_level_status_inner_join AS
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
   FROM (business.view_level_status bvls
     JOIN core.view_company cvc ON ((bvls.id_company = cvc.id_company)))
  WHERE (bvls.deleted_level_status = false)
  ORDER BY bvls.id_level_status DESC;


ALTER TABLE business.view_level_status_inner_join OWNER TO postgres;

--
-- TOC entry 310 (class 1259 OID 21555)
-- Name: view_position; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_position AS
 SELECT bvp.id_position,
    bvp.id_company,
    bvp.name_position,
    bvp.description_position,
    bvp.deleted_position
   FROM business."position" bvp
  WHERE (bvp.deleted_position = false)
  ORDER BY bvp.id_position DESC;


ALTER TABLE business.view_position OWNER TO app_nashor;

--
-- TOC entry 202 (class 1259 OID 20566)
-- Name: academic; Type: TABLE; Schema: core; Owner: app_nashor
--

CREATE TABLE core.academic (
    id_academic numeric(10,0) NOT NULL,
    title_academic character varying(250),
    abbreviation_academic character varying(50),
    level_academic character varying(100),
    deleted_academic boolean
);


ALTER TABLE core.academic OWNER TO app_nashor;

--
-- TOC entry 204 (class 1259 OID 20576)
-- Name: job; Type: TABLE; Schema: core; Owner: app_nashor
--

CREATE TABLE core.job (
    id_job numeric(10,0) NOT NULL,
    name_job character varying(200),
    address_job character varying(200),
    phone_job character varying(13),
    position_job character varying(150),
    deleted_job boolean
);


ALTER TABLE core.job OWNER TO app_nashor;

--
-- TOC entry 213 (class 1259 OID 20642)
-- Name: type_user; Type: TABLE; Schema: core; Owner: app_nashor
--

CREATE TABLE core.type_user (
    id_type_user numeric(5,0) NOT NULL,
    id_company numeric(5,0) NOT NULL,
    id_profile numeric(5,0) NOT NULL,
    name_type_user character varying(100),
    description_type_user character varying(250),
    status_type_user boolean,
    deleted_type_user boolean
);


ALTER TABLE core.type_user OWNER TO app_nashor;

--
-- TOC entry 260 (class 1259 OID 21235)
-- Name: view_academic; Type: VIEW; Schema: core; Owner: app_nashor
--

CREATE VIEW core.view_academic AS
 SELECT cva.id_academic,
    cva.title_academic,
    cva.abbreviation_academic,
    cva.level_academic,
    cva.deleted_academic
   FROM core.academic cva
  WHERE (cva.deleted_academic = false)
  ORDER BY cva.id_academic DESC;


ALTER TABLE core.view_academic OWNER TO app_nashor;

--
-- TOC entry 258 (class 1259 OID 21227)
-- Name: view_job; Type: VIEW; Schema: core; Owner: app_nashor
--

CREATE VIEW core.view_job AS
 SELECT cvj.id_job,
    cvj.name_job,
    cvj.address_job,
    cvj.phone_job,
    cvj.position_job,
    cvj.deleted_job
   FROM core.job cvj
  WHERE (cvj.deleted_job = false)
  ORDER BY cvj.id_job DESC;


ALTER TABLE core.view_job OWNER TO app_nashor;

--
-- TOC entry 264 (class 1259 OID 21251)
-- Name: view_type_user; Type: VIEW; Schema: core; Owner: app_nashor
--

CREATE VIEW core.view_type_user AS
 SELECT cvtu.id_type_user,
    cvtu.id_company,
    cvtu.id_profile,
    cvtu.name_type_user,
    cvtu.description_type_user,
    cvtu.status_type_user,
    cvtu.deleted_type_user
   FROM core.type_user cvtu
  WHERE (cvtu.deleted_type_user = false)
  ORDER BY cvtu.id_type_user DESC;


ALTER TABLE core.view_type_user OWNER TO app_nashor;

--
-- TOC entry 337 (class 1259 OID 21886)
-- Name: view_official_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_official_inner_join AS
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
   FROM ((((((((business.view_official bvo
     JOIN core.view_company cvc ON ((bvo.id_company = cvc.id_company)))
     JOIN core.view_user cvu ON ((bvo.id_user = cvu.id_user)))
     JOIN core.view_person cvp ON ((cvu.id_person = cvp.id_person)))
     JOIN core.view_academic cva ON ((cvp.id_academic = cva.id_academic)))
     JOIN core.view_job cvj ON ((cvp.id_job = cvj.id_job)))
     JOIN core.view_type_user cvtu ON ((cvu.id_type_user = cvtu.id_type_user)))
     JOIN business.view_area bva ON ((bvo.id_area = bva.id_area)))
     JOIN business.view_position bvp ON ((bvo.id_position = bvp.id_position)))
  WHERE (bvo.deleted_official = false)
  ORDER BY bvo.id_official DESC;


ALTER TABLE business.view_official_inner_join OWNER TO postgres;

--
-- TOC entry 321 (class 1259 OID 21599)
-- Name: view_plugin_item; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_plugin_item AS
 SELECT bvpi.id_plugin_item,
    bvpi.id_company,
    bvpi.name_plugin_item,
    bvpi.description_plugin_item,
    bvpi.select_plugin_item
   FROM business.plugin_item bvpi
  ORDER BY bvpi.id_plugin_item DESC;


ALTER TABLE business.view_plugin_item OWNER TO app_nashor;

--
-- TOC entry 362 (class 1259 OID 22008)
-- Name: view_plugin_item_column_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_plugin_item_column_inner_join AS
 SELECT bvpic.id_plugin_item_column,
    bvpic.id_plugin_item,
    bvpic.name_plugin_item_column,
    bvpic.lenght_plugin_item_column,
    bvpi.id_company,
    bvpi.name_plugin_item,
    bvpi.description_plugin_item,
    bvpi.select_plugin_item
   FROM (business.view_plugin_item_column bvpic
     JOIN business.view_plugin_item bvpi ON ((bvpic.id_plugin_item = bvpi.id_plugin_item)))
  ORDER BY bvpic.id_plugin_item_column DESC;


ALTER TABLE business.view_plugin_item_column_inner_join OWNER TO postgres;

--
-- TOC entry 344 (class 1259 OID 21920)
-- Name: view_plugin_item_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_plugin_item_inner_join AS
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
   FROM (business.view_plugin_item bvpi
     JOIN core.view_company cvc ON ((bvpi.id_company = cvc.id_company)))
  ORDER BY bvpi.id_plugin_item DESC;


ALTER TABLE business.view_plugin_item_inner_join OWNER TO postgres;

--
-- TOC entry 336 (class 1259 OID 21882)
-- Name: view_position_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_position_inner_join AS
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
   FROM (business.view_position bvp
     JOIN core.view_company cvc ON ((bvp.id_company = cvc.id_company)))
  WHERE (bvp.deleted_position = false)
  ORDER BY bvp.id_position DESC;


ALTER TABLE business.view_position_inner_join OWNER TO postgres;

--
-- TOC entry 323 (class 1259 OID 21607)
-- Name: view_process; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_process AS
 SELECT bvp.id_process,
    bvp.id_official,
    bvp.id_flow_version,
    bvp.number_process,
    bvp.date_process,
    bvp.generated_task,
    bvp.finalized_process,
    bvp.deleted_process
   FROM business.process bvp
  WHERE (bvp.deleted_process = false)
  ORDER BY bvp.id_process DESC;


ALTER TABLE business.view_process OWNER TO app_nashor;

--
-- TOC entry 331 (class 1259 OID 21639)
-- Name: view_process_attached; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_process_attached AS
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
    bvpa.deleted_process_attached
   FROM business.process_attached bvpa
  WHERE (bvpa.deleted_process_attached = false)
  ORDER BY bvpa.id_process_attached DESC;


ALTER TABLE business.view_process_attached OWNER TO app_nashor;

--
-- TOC entry 359 (class 1259 OID 21993)
-- Name: view_process_attached_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_process_attached_inner_join AS
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
    bvt.type_status_task,
    bvt.date_task,
    bvl.id_template,
    bvl.id_level_profile,
    bvl.id_level_status,
    bvl.name_level,
    bvl.description_level,
    bva.name_attached,
    bva.description_attached,
    bva.length_mb_attached,
    bva.required_attached
   FROM (((((((business.view_process_attached bvpa
     JOIN business.view_official bvo ON ((bvpa.id_official = bvo.id_official)))
     JOIN core.view_user cvu ON ((bvo.id_user = cvu.id_user)))
     JOIN core.view_person cvp ON ((cvu.id_person = cvp.id_person)))
     JOIN business.view_process bvp ON ((bvpa.id_process = bvp.id_process)))
     JOIN business.view_task bvt ON ((bvpa.id_task = bvt.id_task)))
     JOIN business.view_level bvl ON ((bvpa.id_level = bvl.id_level)))
     JOIN business.view_attached bva ON ((bvpa.id_attached = bva.id_attached)))
  WHERE (bvpa.deleted_process_attached = false)
  ORDER BY bvpa.id_process_attached DESC;


ALTER TABLE business.view_process_attached_inner_join OWNER TO postgres;

--
-- TOC entry 330 (class 1259 OID 21635)
-- Name: view_process_comment; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_process_comment AS
 SELECT bvpc.id_process_comment,
    bvpc.id_official,
    bvpc.id_process,
    bvpc.id_task,
    bvpc.id_level,
    bvpc.value_process_comment,
    bvpc.date_process_comment,
    bvpc.deleted_process_comment
   FROM business.process_comment bvpc
  WHERE (bvpc.deleted_process_comment = false)
  ORDER BY bvpc.id_process_comment DESC;


ALTER TABLE business.view_process_comment OWNER TO app_nashor;

--
-- TOC entry 361 (class 1259 OID 22003)
-- Name: view_process_comment_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_process_comment_inner_join AS
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
    bvt.type_status_task,
    bvt.date_task,
    bvl.id_template,
    bvl.id_level_profile,
    bvl.id_level_status,
    bvl.name_level,
    bvl.description_level
   FROM ((((((business.view_process_comment bvpc
     JOIN business.view_official bvo ON ((bvpc.id_official = bvo.id_official)))
     JOIN core.view_user cvu ON ((bvo.id_user = cvu.id_user)))
     JOIN core.view_person cvp ON ((cvu.id_person = cvp.id_person)))
     JOIN business.view_process bvp ON ((bvpc.id_process = bvp.id_process)))
     JOIN business.view_task bvt ON ((bvpc.id_task = bvt.id_task)))
     JOIN business.view_level bvl ON ((bvpc.id_level = bvl.id_level)))
  WHERE (bvpc.deleted_process_comment = false)
  ORDER BY bvpc.id_process_comment DESC;


ALTER TABLE business.view_process_comment_inner_join OWNER TO postgres;

--
-- TOC entry 332 (class 1259 OID 21643)
-- Name: view_process_control; Type: VIEW; Schema: business; Owner: app_nashor
--

CREATE VIEW business.view_process_control AS
 SELECT bvpc.id_process_control,
    bvpc.id_official,
    bvpc.id_process,
    bvpc.id_task,
    bvpc.id_level,
    bvpc.id_control,
    bvpc.value_process_control,
    bvpc.last_change_process_control,
    bvpc.deleted_process_control
   FROM business.process_control bvpc
  WHERE (bvpc.deleted_process_control = false)
  ORDER BY bvpc.id_process_control DESC;


ALTER TABLE business.view_process_control OWNER TO app_nashor;

--
-- TOC entry 360 (class 1259 OID 21998)
-- Name: view_process_control_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_process_control_inner_join AS
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
    bvt.type_status_task,
    bvt.date_task,
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
   FROM (((((((business.view_process_control bvpc
     JOIN business.view_official bvo ON ((bvpc.id_official = bvo.id_official)))
     JOIN core.view_user cvu ON ((bvo.id_user = cvu.id_user)))
     JOIN core.view_person cvp ON ((cvu.id_person = cvp.id_person)))
     JOIN business.view_process bvp ON ((bvpc.id_process = bvp.id_process)))
     JOIN business.view_task bvt ON ((bvpc.id_task = bvt.id_task)))
     JOIN business.view_level bvl ON ((bvpc.id_level = bvl.id_level)))
     JOIN business.view_control bvc ON ((bvpc.id_control = bvc.id_control)))
  WHERE (bvpc.deleted_process_control = false)
  ORDER BY bvpc.id_process_control DESC;


ALTER TABLE business.view_process_control_inner_join OWNER TO postgres;

--
-- TOC entry 354 (class 1259 OID 21968)
-- Name: view_process_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_process_inner_join AS
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
   FROM (((business.view_process bvp
     JOIN business.view_official bvo ON ((bvp.id_official = bvo.id_official)))
     JOIN business.view_flow_version bvfv ON ((bvp.id_flow_version = bvfv.id_flow_version)))
     JOIN business.view_flow bvf ON ((bvfv.id_flow = bvf.id_flow)))
  WHERE (bvp.deleted_process = false)
  ORDER BY bvp.id_process DESC;


ALTER TABLE business.view_process_inner_join OWNER TO postgres;

--
-- TOC entry 357 (class 1259 OID 21983)
-- Name: view_process_item_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_process_item_inner_join AS
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
    bvt.type_status_task,
    bvt.date_task,
    bvl.id_template,
    bvl.id_level_profile,
    bvl.id_level_status,
    bvl.name_level,
    bvl.description_level,
    bvi.id_item_category,
    bvi.name_item,
    bvi.description_item
   FROM (((((((business.view_process_item bvpi
     JOIN business.view_official bvo ON ((bvpi.id_official = bvo.id_official)))
     JOIN core.view_user cvu ON ((bvo.id_user = cvu.id_user)))
     JOIN core.view_person cvp ON ((cvu.id_person = cvp.id_person)))
     JOIN business.view_process bvp ON ((bvpi.id_process = bvp.id_process)))
     JOIN business.view_task bvt ON ((bvpi.id_task = bvt.id_task)))
     JOIN business.view_level bvl ON ((bvpi.id_level = bvl.id_level)))
     JOIN business.view_item bvi ON ((bvpi.id_item = bvi.id_item)))
  ORDER BY bvpi.id_process_item DESC;


ALTER TABLE business.view_process_item_inner_join OWNER TO postgres;

--
-- TOC entry 356 (class 1259 OID 21978)
-- Name: view_task_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_task_inner_join AS
 SELECT bvt.id_task,
    bvt.id_process,
    bvt.id_official,
    bvt.id_level,
    bvt.number_task,
    bvt.type_status_task,
    bvt.date_task,
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
   FROM (((((business.view_task bvt
     JOIN business.view_process bvp ON ((bvt.id_process = bvp.id_process)))
     JOIN business.view_flow_version bvfv ON ((bvp.id_flow_version = bvfv.id_flow_version)))
     JOIN business.view_flow bvf ON ((bvfv.id_flow = bvf.id_flow)))
     JOIN business.view_official bvo ON ((bvt.id_official = bvo.id_official)))
     JOIN business.view_level bvl ON ((bvt.id_level = bvl.id_level)))
  WHERE (bvt.deleted_task = false)
  ORDER BY bvt.id_task DESC;


ALTER TABLE business.view_task_inner_join OWNER TO postgres;

--
-- TOC entry 346 (class 1259 OID 21929)
-- Name: view_template_control_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_template_control_inner_join AS
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
   FROM (((business.view_template_control bvtc
     JOIN business.view_template bvt ON ((bvtc.id_template = bvt.id_template)))
     JOIN business.view_control bvc ON ((bvtc.id_control = bvc.id_control)))
     JOIN core.view_company bvco ON ((bvt.id_company = bvco.id_company)))
  ORDER BY bvtc.id_template_control DESC;


ALTER TABLE business.view_template_control_inner_join OWNER TO postgres;

--
-- TOC entry 345 (class 1259 OID 21924)
-- Name: view_template_inner_join; Type: VIEW; Schema: business; Owner: postgres
--

CREATE VIEW business.view_template_inner_join AS
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
   FROM ((business.view_template bvt
     JOIN core.view_company cvc ON ((bvt.id_company = cvc.id_company)))
     JOIN business.view_documentation_profile bvdp ON ((bvt.id_documentation_profile = bvdp.id_documentation_profile)))
  WHERE (bvt.deleted_template = false)
  ORDER BY bvt.id_template DESC;


ALTER TABLE business.view_template_inner_join OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 20584)
-- Name: navigation; Type: TABLE; Schema: core; Owner: app_nashor
--

CREATE TABLE core.navigation (
    id_navigation numeric(5,0) NOT NULL,
    id_company numeric(5,0) NOT NULL,
    name_navigation character varying(100),
    description_navigation character varying(250),
    type_navigation core."TYPE_NAVIGATION" NOT NULL,
    status_navigation boolean,
    content_navigation json,
    deleted_navigation boolean
);


ALTER TABLE core.navigation OWNER TO app_nashor;

--
-- TOC entry 207 (class 1259 OID 20600)
-- Name: profile; Type: TABLE; Schema: core; Owner: app_nashor
--

CREATE TABLE core.profile (
    id_profile numeric(5,0) NOT NULL,
    id_company numeric(5,0) NOT NULL,
    type_profile core."TYPE_PROFILE" NOT NULL,
    name_profile character varying(100),
    description_profile character varying(250),
    status_profile boolean,
    deleted_profile boolean
);


ALTER TABLE core.profile OWNER TO app_nashor;

--
-- TOC entry 208 (class 1259 OID 20605)
-- Name: profile_navigation; Type: TABLE; Schema: core; Owner: app_nashor
--

CREATE TABLE core.profile_navigation (
    id_profile_navigation numeric(10,0) NOT NULL,
    id_profile numeric(5,0) NOT NULL,
    id_navigation numeric(5,0) NOT NULL
);


ALTER TABLE core.profile_navigation OWNER TO app_nashor;

--
-- TOC entry 247 (class 1259 OID 21199)
-- Name: serial_academic; Type: SEQUENCE; Schema: core; Owner: app_nashor
--

CREATE SEQUENCE core.serial_academic
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999999
    CACHE 1;


ALTER TABLE core.serial_academic OWNER TO app_nashor;

--
-- TOC entry 243 (class 1259 OID 21191)
-- Name: serial_company; Type: SEQUENCE; Schema: core; Owner: app_nashor
--

CREATE SEQUENCE core.serial_company
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999
    CACHE 1;


ALTER TABLE core.serial_company OWNER TO app_nashor;

--
-- TOC entry 245 (class 1259 OID 21195)
-- Name: serial_job; Type: SEQUENCE; Schema: core; Owner: app_nashor
--

CREATE SEQUENCE core.serial_job
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999999
    CACHE 1;


ALTER TABLE core.serial_job OWNER TO app_nashor;

--
-- TOC entry 244 (class 1259 OID 21193)
-- Name: serial_navigation; Type: SEQUENCE; Schema: core; Owner: app_nashor
--

CREATE SEQUENCE core.serial_navigation
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999
    CACHE 1;


ALTER TABLE core.serial_navigation OWNER TO app_nashor;

--
-- TOC entry 246 (class 1259 OID 21197)
-- Name: serial_person; Type: SEQUENCE; Schema: core; Owner: app_nashor
--

CREATE SEQUENCE core.serial_person
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999999
    CACHE 1;


ALTER TABLE core.serial_person OWNER TO app_nashor;

--
-- TOC entry 248 (class 1259 OID 21201)
-- Name: serial_profile; Type: SEQUENCE; Schema: core; Owner: app_nashor
--

CREATE SEQUENCE core.serial_profile
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999
    CACHE 1;


ALTER TABLE core.serial_profile OWNER TO app_nashor;

--
-- TOC entry 249 (class 1259 OID 21203)
-- Name: serial_profile_navigation; Type: SEQUENCE; Schema: core; Owner: app_nashor
--

CREATE SEQUENCE core.serial_profile_navigation
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999999
    CACHE 1;


ALTER TABLE core.serial_profile_navigation OWNER TO app_nashor;

--
-- TOC entry 253 (class 1259 OID 21211)
-- Name: serial_session; Type: SEQUENCE; Schema: core; Owner: app_nashor
--

CREATE SEQUENCE core.serial_session
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 999999999999999
    CACHE 1;


ALTER TABLE core.serial_session OWNER TO app_nashor;

--
-- TOC entry 242 (class 1259 OID 21189)
-- Name: serial_setting; Type: SEQUENCE; Schema: core; Owner: app_nashor
--

CREATE SEQUENCE core.serial_setting
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999
    CACHE 1;


ALTER TABLE core.serial_setting OWNER TO app_nashor;

--
-- TOC entry 254 (class 1259 OID 21213)
-- Name: serial_system_event; Type: SEQUENCE; Schema: core; Owner: app_nashor
--

CREATE SEQUENCE core.serial_system_event
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 999999999999999
    CACHE 1;


ALTER TABLE core.serial_system_event OWNER TO app_nashor;

--
-- TOC entry 251 (class 1259 OID 21207)
-- Name: serial_type_user; Type: SEQUENCE; Schema: core; Owner: app_nashor
--

CREATE SEQUENCE core.serial_type_user
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999
    CACHE 1;


ALTER TABLE core.serial_type_user OWNER TO app_nashor;

--
-- TOC entry 250 (class 1259 OID 21205)
-- Name: serial_user; Type: SEQUENCE; Schema: core; Owner: app_nashor
--

CREATE SEQUENCE core.serial_user
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999999
    CACHE 1;


ALTER TABLE core.serial_user OWNER TO app_nashor;

--
-- TOC entry 252 (class 1259 OID 21209)
-- Name: serial_validation; Type: SEQUENCE; Schema: core; Owner: app_nashor
--

CREATE SEQUENCE core.serial_validation
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999
    CACHE 1;


ALTER TABLE core.serial_validation OWNER TO app_nashor;

--
-- TOC entry 212 (class 1259 OID 20634)
-- Name: session; Type: TABLE; Schema: core; Owner: app_nashor
--

CREATE TABLE core.session (
    id_session numeric(15,0) NOT NULL,
    id_user numeric(10,0) NOT NULL,
    host_session text,
    agent_session json,
    date_sign_in_session timestamp without time zone,
    date_sign_out_session timestamp without time zone,
    status_session boolean
);


ALTER TABLE core.session OWNER TO app_nashor;

--
-- TOC entry 209 (class 1259 OID 20610)
-- Name: setting; Type: TABLE; Schema: core; Owner: app_nashor
--

CREATE TABLE core.setting (
    id_setting numeric(5,0) NOT NULL,
    expiration_token numeric(10,0),
    expiration_verification_code numeric(10,0),
    inactivity_time numeric(10,0),
    session_limit numeric(3,0),
    save_log boolean,
    save_file_alfresco boolean,
    modification_status boolean,
    deleted_setting boolean
);


ALTER TABLE core.setting OWNER TO app_nashor;

--
-- TOC entry 214 (class 1259 OID 20647)
-- Name: system_event; Type: TABLE; Schema: core; Owner: app_nashor
--

CREATE TABLE core.system_event (
    id_system_event numeric(15,0) NOT NULL,
    id_user numeric(10,0) NOT NULL,
    table_system_event character varying(50),
    row_system_event numeric(10,0),
    action_system_event character varying(50),
    date_system_event timestamp without time zone,
    deleted_system_event boolean
);


ALTER TABLE core.system_event OWNER TO app_nashor;

--
-- TOC entry 211 (class 1259 OID 20623)
-- Name: validation; Type: TABLE; Schema: core; Owner: app_nashor
--

CREATE TABLE core.validation (
    id_validation numeric(5,0) NOT NULL,
    id_company numeric(5,0) NOT NULL,
    type_validation core."TYPE_VALIDATION" NOT NULL,
    status_validation boolean,
    pattern_validation character varying(500),
    message_validation character varying(250),
    deleted_validation boolean
);


ALTER TABLE core.validation OWNER TO app_nashor;

--
-- TOC entry 255 (class 1259 OID 21215)
-- Name: view_setting; Type: VIEW; Schema: core; Owner: app_nashor
--

CREATE VIEW core.view_setting AS
 SELECT cvs.id_setting,
    cvs.expiration_token,
    cvs.expiration_verification_code,
    cvs.inactivity_time,
    cvs.session_limit,
    cvs.save_log,
    cvs.save_file_alfresco,
    cvs.modification_status,
    cvs.deleted_setting
   FROM core.setting cvs
  WHERE (cvs.deleted_setting = false)
  ORDER BY cvs.id_setting DESC;


ALTER TABLE core.view_setting OWNER TO app_nashor;

--
-- TOC entry 272 (class 1259 OID 21445)
-- Name: view_company_inner_join; Type: VIEW; Schema: core; Owner: postgres
--

CREATE VIEW core.view_company_inner_join AS
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
   FROM (core.view_company cvc
     JOIN core.view_setting cvs ON ((cvc.id_setting = cvs.id_setting)))
  WHERE (cvc.deleted_company = false)
  ORDER BY cvc.id_company DESC;


ALTER TABLE core.view_company_inner_join OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 21223)
-- Name: view_navigation; Type: VIEW; Schema: core; Owner: app_nashor
--

CREATE VIEW core.view_navigation AS
 SELECT cvn.id_navigation,
    cvn.id_company,
    cvn.name_navigation,
    cvn.description_navigation,
    cvn.type_navigation,
    cvn.status_navigation,
    cvn.content_navigation,
    cvn.deleted_navigation
   FROM core.navigation cvn
  WHERE (cvn.deleted_navigation = false)
  ORDER BY cvn.id_navigation DESC;


ALTER TABLE core.view_navigation OWNER TO app_nashor;

--
-- TOC entry 274 (class 1259 OID 21455)
-- Name: view_navigation_inner_join; Type: VIEW; Schema: core; Owner: postgres
--

CREATE VIEW core.view_navigation_inner_join AS
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
   FROM (core.view_navigation cvn
     JOIN core.view_company cvc ON ((cvn.id_company = cvc.id_company)))
  WHERE (cvn.deleted_navigation = false)
  ORDER BY cvn.id_navigation DESC;


ALTER TABLE core.view_navigation_inner_join OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 21239)
-- Name: view_profile; Type: VIEW; Schema: core; Owner: app_nashor
--

CREATE VIEW core.view_profile AS
 SELECT cvp.id_profile,
    cvp.id_company,
    cvp.type_profile,
    cvp.name_profile,
    cvp.description_profile,
    cvp.status_profile,
    cvp.deleted_profile
   FROM core.profile cvp
  WHERE (cvp.deleted_profile = false)
  ORDER BY cvp.id_profile DESC;


ALTER TABLE core.view_profile OWNER TO app_nashor;

--
-- TOC entry 262 (class 1259 OID 21243)
-- Name: view_profile_navigation; Type: VIEW; Schema: core; Owner: app_nashor
--

CREATE VIEW core.view_profile_navigation AS
 SELECT cvpn.id_profile_navigation,
    cvpn.id_profile,
    cvpn.id_navigation
   FROM core.profile_navigation cvpn
  ORDER BY cvpn.id_profile_navigation DESC;


ALTER TABLE core.view_profile_navigation OWNER TO app_nashor;

--
-- TOC entry 271 (class 1259 OID 21440)
-- Name: view_navigation_inner_join_cvpn_cvp_cvtu_cvu; Type: VIEW; Schema: core; Owner: postgres
--

CREATE VIEW core.view_navigation_inner_join_cvpn_cvp_cvtu_cvu AS
 SELECT vn.id_navigation,
    vn.name_navigation,
    vn.description_navigation,
    vn.type_navigation,
    vn.status_navigation,
    vn.content_navigation,
    vn.deleted_navigation,
    vu.id_user,
    vu.id_company,
    vu.id_person,
    vu.id_type_user,
    vu.name_user,
    vu.password_user,
    vu.avatar_user,
    vu.status_user,
    vu.deleted_user
   FROM ((((core.view_navigation vn
     JOIN core.view_profile_navigation vpn ON ((vn.id_navigation = vpn.id_navigation)))
     JOIN core.view_profile vp ON ((vp.id_profile = vpn.id_profile)))
     JOIN core.view_type_user vtu ON ((vtu.id_profile = vp.id_profile)))
     JOIN core.view_user vu ON ((vu.id_type_user = vtu.id_type_user)));


ALTER TABLE core.view_navigation_inner_join_cvpn_cvp_cvtu_cvu OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 21460)
-- Name: view_profile_inner_join; Type: VIEW; Schema: core; Owner: postgres
--

CREATE VIEW core.view_profile_inner_join AS
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
   FROM (core.view_profile cvp
     JOIN core.view_company cvc ON ((cvp.id_company = cvc.id_company)))
  WHERE (cvp.deleted_profile = false)
  ORDER BY cvp.id_profile DESC;


ALTER TABLE core.view_profile_inner_join OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 21470)
-- Name: view_profile_navigation_inner_join; Type: VIEW; Schema: core; Owner: postgres
--

CREATE VIEW core.view_profile_navigation_inner_join AS
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
   FROM ((core.view_profile_navigation cvpn
     JOIN core.view_profile cvp ON ((cvpn.id_profile = cvp.id_profile)))
     JOIN core.view_navigation cvn ON ((cvpn.id_navigation = cvn.id_navigation)))
  ORDER BY cvpn.id_profile_navigation DESC;


ALTER TABLE core.view_profile_navigation_inner_join OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 21259)
-- Name: view_session; Type: VIEW; Schema: core; Owner: app_nashor
--

CREATE VIEW core.view_session AS
 SELECT cvs.id_session,
    cvs.id_user,
    cvs.host_session,
    cvs.agent_session,
    cvs.date_sign_in_session,
    cvs.date_sign_out_session,
    cvs.status_session
   FROM core.session cvs
  ORDER BY cvs.id_session DESC;


ALTER TABLE core.view_session OWNER TO app_nashor;

--
-- TOC entry 279 (class 1259 OID 21480)
-- Name: view_session_inner_join; Type: VIEW; Schema: core; Owner: postgres
--

CREATE VIEW core.view_session_inner_join AS
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
   FROM (core.view_session cvs
     JOIN core.view_user cvu ON ((cvs.id_user = cvu.id_user)))
  ORDER BY cvs.id_session DESC;


ALTER TABLE core.view_session_inner_join OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 21263)
-- Name: view_system_event; Type: VIEW; Schema: core; Owner: app_nashor
--

CREATE VIEW core.view_system_event AS
 SELECT cvse.id_system_event,
    cvse.id_user,
    cvse.table_system_event,
    cvse.row_system_event,
    cvse.action_system_event,
    cvse.date_system_event,
    cvse.deleted_system_event
   FROM core.system_event cvse
  WHERE (cvse.deleted_system_event = false)
  ORDER BY cvse.id_system_event DESC;


ALTER TABLE core.view_system_event OWNER TO app_nashor;

--
-- TOC entry 280 (class 1259 OID 21485)
-- Name: view_system_event_inner_join; Type: VIEW; Schema: core; Owner: postgres
--

CREATE VIEW core.view_system_event_inner_join AS
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
   FROM (core.view_system_event cvse
     JOIN core.view_user cvu ON ((cvse.id_user = cvu.id_user)))
  WHERE (cvse.deleted_system_event = false)
  ORDER BY cvse.id_system_event DESC;


ALTER TABLE core.view_system_event_inner_join OWNER TO postgres;

--
-- TOC entry 276 (class 1259 OID 21465)
-- Name: view_type_user_inner_join; Type: VIEW; Schema: core; Owner: postgres
--

CREATE VIEW core.view_type_user_inner_join AS
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
   FROM ((core.view_type_user cvtu
     JOIN core.view_company cvc ON ((cvtu.id_company = cvc.id_company)))
     JOIN core.view_profile cvp ON ((cvtu.id_profile = cvp.id_profile)))
  WHERE (cvtu.deleted_type_user = false)
  ORDER BY cvtu.id_type_user DESC;


ALTER TABLE core.view_type_user_inner_join OWNER TO postgres;

--
-- TOC entry 278 (class 1259 OID 21475)
-- Name: view_user_inner_join; Type: VIEW; Schema: core; Owner: postgres
--

CREATE VIEW core.view_user_inner_join AS
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
    cva.level_academic,
    cvj.name_job,
    cvj.address_job,
    cvj.phone_job,
    cvj.position_job
   FROM (((((core.view_user cvu
     JOIN core.view_company cvc ON ((cvu.id_company = cvc.id_company)))
     JOIN core.view_person cvp ON ((cvu.id_person = cvp.id_person)))
     JOIN core.view_type_user cvtu ON ((cvu.id_type_user = cvtu.id_type_user)))
     JOIN core.view_academic cva ON ((cvp.id_academic = cva.id_academic)))
     JOIN core.view_job cvj ON ((cvp.id_job = cvj.id_job)))
  WHERE (cvu.deleted_user = false)
  ORDER BY cvu.id_user DESC;


ALTER TABLE core.view_user_inner_join OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 21430)
-- Name: view_user_inner_join_cvc_cvs; Type: VIEW; Schema: core; Owner: postgres
--

CREATE VIEW core.view_user_inner_join_cvc_cvs AS
 SELECT cvs.save_log,
    cvu.id_user,
    cvu.name_user
   FROM ((core.view_user cvu
     JOIN core.view_company cvc ON ((cvu.id_company = cvc.id_company)))
     JOIN core.view_setting cvs ON ((cvc.id_setting = cvs.id_setting)));


ALTER TABLE core.view_user_inner_join_cvc_cvs OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 21435)
-- Name: view_user_inner_join_cvc_cvs_cvp_cvtu_cvpro; Type: VIEW; Schema: core; Owner: postgres
--

CREATE VIEW core.view_user_inner_join_cvc_cvs_cvp_cvtu_cvpro AS
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
   FROM (((((core.view_user vu
     JOIN core.view_company vc ON ((vu.id_company = vc.id_company)))
     JOIN core.view_setting vs ON ((vc.id_setting = vs.id_setting)))
     JOIN core.view_person vp ON ((vu.id_person = vp.id_person)))
     JOIN core.view_type_user vtu ON ((vtu.id_type_user = vu.id_type_user)))
     JOIN core.view_profile vpr ON ((vpr.id_profile = vtu.id_profile)));


ALTER TABLE core.view_user_inner_join_cvc_cvs_cvp_cvtu_cvpro OWNER TO postgres;

--
-- TOC entry 265 (class 1259 OID 21255)
-- Name: view_validation; Type: VIEW; Schema: core; Owner: app_nashor
--

CREATE VIEW core.view_validation AS
 SELECT cvv.id_validation,
    cvv.id_company,
    cvv.type_validation,
    cvv.status_validation,
    cvv.pattern_validation,
    cvv.message_validation,
    cvv.deleted_validation
   FROM core.validation cvv
  WHERE (cvv.deleted_validation = false)
  ORDER BY cvv.id_validation DESC;


ALTER TABLE core.view_validation OWNER TO app_nashor;

--
-- TOC entry 268 (class 1259 OID 21425)
-- Name: view_validation_inner_company_user; Type: VIEW; Schema: core; Owner: postgres
--

CREATE VIEW core.view_validation_inner_company_user AS
 SELECT vv.id_validation,
    vv.id_company,
    vv.type_validation,
    vv.status_validation,
    vv.pattern_validation,
    vv.message_validation,
    vv.deleted_validation,
    vu.name_user
   FROM ((core.view_validation vv
     JOIN core.view_company vc ON ((vv.id_company = vc.id_company)))
     JOIN core.view_user vu ON ((vu.id_company = vc.id_company)))
  WHERE (vv.status_validation = true);


ALTER TABLE core.view_validation_inner_company_user OWNER TO postgres;

--
-- TOC entry 273 (class 1259 OID 21450)
-- Name: view_validation_inner_join; Type: VIEW; Schema: core; Owner: postgres
--

CREATE VIEW core.view_validation_inner_join AS
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
   FROM (core.view_validation cvv
     JOIN core.view_company cvc ON ((cvv.id_company = cvc.id_company)))
  WHERE (cvv.deleted_validation = false)
  ORDER BY cvv.id_validation DESC;


ALTER TABLE core.view_validation_inner_join OWNER TO postgres;

--
-- TOC entry 4096 (class 0 OID 20657)
-- Dependencies: 216
-- Data for Name: area; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.area (id_area, id_company, name_area, description_area, deleted_area) FROM stdin;
1	1	TICS	Unidad de TICS / Sistemas	f
2	1	Bodega	Unidad de Bodega	f
3	1	Administrativo	Dirección Administrativa	f
4	1	Compras Públicas	Unidad de Compras Públicas	f
5	1	Alcaldía	Alcaldía	f
6	1	Financiero	Dirección Financiera	f
\.


--
-- TOC entry 4104 (class 0 OID 20700)
-- Dependencies: 224
-- Data for Name: attached; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.attached (id_attached, id_company, name_attached, description_attached, length_mb_attached, required_attached, deleted_attached) FROM stdin;
1	1	Informe de factibilidad	Suba el informe de factibilidad	2	t	f
2	1	información para la adquisición	Suba la información para la adquisición	2	t	f
3	1	Partida presupuestaria	Suba la partida presupuestaria	2	t	f
4	1	Orden de compra	Suba la orden de compra	2	t	f
\.


--
-- TOC entry 4121 (class 0 OID 20791)
-- Dependencies: 241
-- Data for Name: column_process_item; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.column_process_item (id_column_process_item, id_plugin_item_column, id_process_item, value_column_process_item, entry_date_column_process_item) FROM stdin;
\.


--
-- TOC entry 4102 (class 0 OID 20687)
-- Dependencies: 222
-- Data for Name: control; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.control (id_control, id_company, type_control, title_control, form_name_control, initial_value_control, required_control, min_length_control, max_length_control, placeholder_control, spell_check_control, options_control, in_use, deleted_control) FROM stdin;
1	1	radioButton	Seleccione el tipo de solicitud	tipo_solicitud		t	1	1		f	[{"name":"Bienes","value":"bienes"},{"name":"Servicios","value":"servicios"}]	t	f
2	1	radioButton	Hay todo en stock?	todo_completo		t	1	1		f	[{"name":"Si","value":"si"},{"name":"No","value":"no"}]	t	f
3	1	radioButton	Desea aprobar la entrega?	aprobacion_entrega		t	1	1		f	[{"name":"Si","value":"si"},{"name":"No","value":"no"}]	t	f
4	1	radioButton	Desea aprobar que continue el proceso de compra?	aprobacion_proceso		t	1	1		f	[{"name":"Si","value":"si"},{"name":"No","value":"no"}]	t	f
5	1	radioButton	Hay partida presupuestaria?	existencia_partida		t	1	1		f	[{"name":"Si","value":"si"},{"name":"No","value":"no"}]	t	f
6	1	radioButton	Desea aprobar la compra?	aprobacion_proceso_compra		t	1	1		f	[{"name":"Si","value":"si"},{"name":"No","value":"no"}]	t	f
\.


--
-- TOC entry 4105 (class 0 OID 20705)
-- Dependencies: 225
-- Data for Name: documentation_profile; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.documentation_profile (id_documentation_profile, id_company, name_documentation_profile, description_documentation_profile, status_documentation_profile, deleted_documentation_profile) FROM stdin;
1	1	Solicitud	Perfil de documentación para la solicitud de materiales	t	f
2	1	Compras públicas (subida)	Perfil de documentación para compras públicas (subida)	t	f
3	1	Financiero (partida presupuestaria)	Perfil de documentación para Financiero (partida presupuestaria)	t	f
4	1	Compras públicas (orden de compra)	Perfil de documentación para Compras públicas (orden de compra)	t	f
\.


--
-- TOC entry 4106 (class 0 OID 20710)
-- Dependencies: 226
-- Data for Name: documentation_profile_attached; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.documentation_profile_attached (id_documentation_profile_attached, id_documentation_profile, id_attached) FROM stdin;
1	1	1
2	2	2
3	3	3
4	4	4
\.


--
-- TOC entry 4108 (class 0 OID 20720)
-- Dependencies: 228
-- Data for Name: flow; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.flow (id_flow, id_company, name_flow, description_flow, acronym_flow, acronym_task, sequential_flow, deleted_flow) FROM stdin;
1	1	Solicitud de materiales	Flujo para solicitud de materiales	SM	T	1	f
\.


--
-- TOC entry 4109 (class 0 OID 20725)
-- Dependencies: 229
-- Data for Name: flow_version; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.flow_version (id_flow_version, id_flow, number_flow_version, status_flow_version, creation_date_flow_version, deleted_flow_version) FROM stdin;
1	1	1	t	2022-09-22 10:57:25.828	f
\.


--
-- TOC entry 4111 (class 0 OID 20735)
-- Dependencies: 231
-- Data for Name: flow_version_level; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.flow_version_level (id_flow_version_level, id_flow_version, id_level, position_level, position_level_father, type_element, id_control, operator, value_against, option_true, x, y) FROM stdin;
1	1	1	1	0	level	0	==		f	50	120
2	1	2	2	1	level	0	==		f	407	130
3	1	2	3	2	conditional	1	==	bienes	f	422	315
4	1	3	4	3	level	0	==		t	130	524
5	1	5	5	3	level	0	==		f	663	511
6	1	4	6	4	level	0	==		f	126	750
7	1	4	7	6	conditional	2	==	si	f	121	974
\.


--
-- TOC entry 4113 (class 0 OID 20745)
-- Dependencies: 233
-- Data for Name: item; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.item (id_item, id_company, id_item_category, name_item, description_item, deleted_item) FROM stdin;
1	1	1	Mouse	Este es un mouse	f
2	1	1	Teclado	Este es un teclado	f
3	1	1	Impresora	Esta es una impresora	f
\.


--
-- TOC entry 4112 (class 0 OID 20740)
-- Dependencies: 232
-- Data for Name: item_category; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.item_category (id_item_category, id_company, name_item_category, description_item_category, deleted_item_category) FROM stdin;
1	1	Equipos de informática	categoría para equipos de informática	f
\.


--
-- TOC entry 4110 (class 0 OID 20730)
-- Dependencies: 230
-- Data for Name: level; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.level (id_level, id_company, id_template, id_level_profile, id_level_status, name_level, description_level, deleted_level) FROM stdin;
1	1	1	1	1	Solicitud	Nivel para la solicitud de materiales	f
2	1	2	1	2	Fiscalización Equipos informáticos	Aquí se encargan de fiscalizar los equipos informáticos	f
3	1	3	2	2	revisión (Bodega)	Aquí bodega revisa si hay los bienes en stock	f
4	1	4	3	2	aprobación Administrativo	Aquí el director administrativo aprueba la entrega de los bienes	f
5	1	5	4	2	Compras públicas (subida)	El departamento de compras públicas recibe la lista de materiales para la adquisición	f
6	1	6	5	2	Alcaldía (autorización proceso)	El Alcalde autoriza que el proceso continue	f
7	1	7	6	2	Financiero (partida presupuestaria)	Financiero verifican la partida presupuestaria	f
8	1	8	5	2	Alcaldía (autorización compra)	El Alcalde autoriza que se efectué la compra	f
9	1	9	4	3	Compras públicas (orden de compra)	Se genera la orden de compra	f
\.


--
-- TOC entry 4098 (class 0 OID 20667)
-- Dependencies: 218
-- Data for Name: level_profile; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.level_profile (id_level_profile, id_company, name_level_profile, description_level_profile, deleted_level_profile) FROM stdin;
1	1	Perfil TICS	Perfil para TICS	f
2	1	Perfil Bodega	Perfil para Bodega	f
3	1	Perfil Administrativo	Perfil para Administrativo	f
4	1	Perfil Compras públicas	Perfil para Compras públicas 	f
5	1	Perfil Alcaldía	Perfil para Alcaldía	f
6	1	Perfil Financiero	Perfil para Financiero	f
\.


--
-- TOC entry 4099 (class 0 OID 20672)
-- Dependencies: 219
-- Data for Name: level_profile_official; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.level_profile_official (id_level_profile_official, id_level_profile, id_official, official_modifier) FROM stdin;
1	1	1	f
2	1	2	t
3	2	3	t
4	3	4	f
5	4	5	f
6	5	6	f
7	6	7	f
\.


--
-- TOC entry 4107 (class 0 OID 20715)
-- Dependencies: 227
-- Data for Name: level_status; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.level_status (id_level_status, id_company, name_level_status, description_level_status, color_level_status, deleted_level_status) FROM stdin;
1	1	Iniciado	Estado iniciado	#d32f2f	f
2	1	En proceso	Estado en proceso	#ffeb3b	f
3	1	Finalizado	Estado de finalizado	#4caf50	f
\.


--
-- TOC entry 4095 (class 0 OID 20652)
-- Dependencies: 215
-- Data for Name: official; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.official (id_official, id_company, id_user, id_area, id_position, deleted_official) FROM stdin;
1	1	2	1	1	f
2	1	3	1	2	f
3	1	4	2	3	f
4	1	5	3	4	f
5	1	6	4	5	f
6	1	7	5	6	f
7	1	8	6	7	f
\.


--
-- TOC entry 4119 (class 0 OID 20781)
-- Dependencies: 239
-- Data for Name: plugin_item; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.plugin_item (id_plugin_item, id_company, name_plugin_item, description_plugin_item, select_plugin_item) FROM stdin;
1	1	Plugin para compras publicas	Este plugin es para que compras publicas pueda seleccionar cantidad y poner el CPC	f
\.


--
-- TOC entry 4120 (class 0 OID 20786)
-- Dependencies: 240
-- Data for Name: plugin_item_column; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.plugin_item_column (id_plugin_item_column, id_plugin_item, name_plugin_item_column, lenght_plugin_item_column) FROM stdin;
1	1	CANTIDAD	5
2	1	CPC	20
3	1	STOCK	20
4	1	COMPRA	20
\.


--
-- TOC entry 4097 (class 0 OID 20662)
-- Dependencies: 217
-- Data for Name: position; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business."position" (id_position, id_company, name_position, description_position, deleted_position) FROM stdin;
1	1	Asistente de Tecnologías de la Información	Cargo para el Asistente de Tecnologías de la Información	f
2	1	Administrador de TICS	Cargo para el Administrador de TICS	f
3	1	Guardalmacén General (Delegado)	Cargo para el Guardalmacén General (Delegado)	f
4	1	Director Administrativo	Cargo para el Director Administrativo	f
5	1	Administrador Portal Compras Públicas	Cargo para el Administrador Portal Compras Públicas	f
6	1	Alcalde GAD Municipal Cantón Pastaza	Cargo para el Alcalde GAD Municipal Cantón Pastaza	f
7	1	Directora Financiera	Cargo para la Directora Financiera	f
\.


--
-- TOC entry 4100 (class 0 OID 20677)
-- Dependencies: 220
-- Data for Name: process; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.process (id_process, id_official, id_flow_version, number_process, date_process, generated_task, finalized_process, deleted_process) FROM stdin;
\.


--
-- TOC entry 4117 (class 0 OID 20765)
-- Dependencies: 237
-- Data for Name: process_attached; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.process_attached (id_process_attached, id_official, id_process, id_task, id_level, id_attached, file_name, length_mb, extension, server_path, alfresco_path, upload_date, deleted_process_attached) FROM stdin;
\.


--
-- TOC entry 4116 (class 0 OID 20760)
-- Dependencies: 236
-- Data for Name: process_comment; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.process_comment (id_process_comment, id_official, id_process, id_task, id_level, value_process_comment, date_process_comment, deleted_process_comment) FROM stdin;
\.


--
-- TOC entry 4118 (class 0 OID 20773)
-- Dependencies: 238
-- Data for Name: process_control; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.process_control (id_process_control, id_official, id_process, id_task, id_level, id_control, value_process_control, last_change_process_control, deleted_process_control) FROM stdin;
\.


--
-- TOC entry 4114 (class 0 OID 20750)
-- Dependencies: 234
-- Data for Name: process_item; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.process_item (id_process_item, id_official, id_process, id_task, id_level, id_item) FROM stdin;
\.


--
-- TOC entry 4115 (class 0 OID 20755)
-- Dependencies: 235
-- Data for Name: task; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.task (id_task, id_process, id_official, id_level, number_task, type_status_task, date_task, deleted_task) FROM stdin;
\.


--
-- TOC entry 4101 (class 0 OID 20682)
-- Dependencies: 221
-- Data for Name: template; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.template (id_template, id_company, id_documentation_profile, id_plugin_item, plugin_attached_process, plugin_item_process, name_template, description_template, status_template, last_change, in_use, deleted_template) FROM stdin;
1	1	1	1	t	t	SM - Solicitud	Plantilla para la solicitud de materiales	t	2022-09-22 10:41:23.053169	f	f
2	1	1	1	f	f	SM - Fiscalización equipos informáticos	Plantilla para la fiscalización de equipos informáticos	t	2022-09-22 10:58:09.283	f	f
3	1	1	1	f	f	SM - Revisión (bodega)	Plantilla para la revisión de bodega	t	2022-09-22 10:15:31.320818	f	f
4	1	1	1	f	f	SM - Aprobación Administrativo	Plantilla la aprobación de administrativo	t	2022-09-22 10:10:09.216223	f	f
5	1	2	1	t	f	SM - Compras públicas (subida)	Plantilla para la subida de información en compras públicas	t	2022-09-22 10:11:00.383672	f	f
6	1	1	1	f	f	SM - Alcaldía (autorización proceso)	Plantilla la autorización del proceso en alcaldía	t	2022-09-22 10:11:00.383672	f	f
7	1	3	1	t	f	SM - Financiero (partida presupuestaria)	Plantilla para la subida de partida presupuestaria en financiero	t	2022-09-22 15:11:00.383672	f	f
8	1	1	1	f	f	SM - Alcaldía (autorización compra)	Plantilla para la autorización de la compra en alcaldía	t	2022-09-22 10:11:00.383672	f	f
9	1	4	1	t	f	SM - Compras públicas (orden de compra)	Plantilla para la generación de la orden de compra en compras públicas	t	2022-09-22 10:11:00.383672	f	f
\.


--
-- TOC entry 4103 (class 0 OID 20695)
-- Dependencies: 223
-- Data for Name: template_control; Type: TABLE DATA; Schema: business; Owner: app_nashor
--

COPY business.template_control (id_template_control, id_template, id_control, ordinal_position) FROM stdin;
1	2	1	1
2	3	2	1
3	4	3	1
4	6	4	1
5	7	5	1
6	8	6	1
\.


--
-- TOC entry 4082 (class 0 OID 20566)
-- Dependencies: 202
-- Data for Name: academic; Type: TABLE DATA; Schema: core; Owner: app_nashor
--

COPY core.academic (id_academic, title_academic, abbreviation_academic, level_academic, deleted_academic) FROM stdin;
1				f
2				f
3				f
4				f
5				f
6				f
7				f
8				f
\.


--
-- TOC entry 4083 (class 0 OID 20571)
-- Dependencies: 203
-- Data for Name: company; Type: TABLE DATA; Schema: core; Owner: app_nashor
--

COPY core.company (id_company, id_setting, name_company, acronym_company, address_company, status_company, deleted_company) FROM stdin;
1	1	ALBERTO ALDAS	BETO	PUYO	t	f
\.


--
-- TOC entry 4084 (class 0 OID 20576)
-- Dependencies: 204
-- Data for Name: job; Type: TABLE DATA; Schema: core; Owner: app_nashor
--

COPY core.job (id_job, name_job, address_job, phone_job, position_job, deleted_job) FROM stdin;
1					f
2					f
3					f
4					f
5					f
6					f
7					f
8					f
\.


--
-- TOC entry 4085 (class 0 OID 20584)
-- Dependencies: 205
-- Data for Name: navigation; Type: TABLE DATA; Schema: core; Owner: app_nashor
--

COPY core.navigation (id_navigation, id_company, name_navigation, description_navigation, type_navigation, status_navigation, content_navigation, deleted_navigation) FROM stdin;
1	1	Super Administrador (Por defecto)	Navegación por defecto para el super administrador	defaultNavigation	t	[\n\t{\n\t\t"id": "core",\n\t\t"title": "Core",\n\t\t"subtitle": "Administración core del sistema",\n\t\t"type": "group",\n\t\t"icon": "heroicons_outline:chip",\n\t\t"children": [\n\t\t\t{\n\t\t\t\t"id": "core.company",\n\t\t\t\t"title": "Empresa",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:office-building",\n\t\t\t\t"link": "/core/company"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "core.navigation",\n\t\t\t\t"title": "Navegación",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:template",\n\t\t\t\t"link": "/core/navigation"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "core.profile",\n\t\t\t\t"title": "Perfil",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:user-group",\n\t\t\t\t"link": "/core/profile"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "core.type-user",\n\t\t\t\t"title": "Tipo de usuario",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "mat_outline:category",\n\t\t\t\t"link": "/core/type-user"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "core.user",\n\t\t\t\t"title": "Usuario",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:user",\n\t\t\t\t"link": "/core/user"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "core.session",\n\t\t\t\t"title": "Sesiones",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:login",\n\t\t\t\t"link": "/core/session"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "core.system-event",\n\t\t\t\t"title": "Eventos del sistema",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "mat_outline:event",\n\t\t\t\t"link": "/core/system-event"\n\t\t\t}\n\t\t]\n\t},\n\t{\n\t\t"id": "business",\n\t\t"title": "Business",\n\t\t"subtitle": "Administración business del sistema",\n\t\t"type": "group",\n\t\t"icon": "heroicons_outline:cube-transparent",\n\t\t"children": [\n\t\t\t{\n\t\t\t\t"id": "business.area",\n\t\t\t\t"title": "Area",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:view-boards",\n\t\t\t\t"link": "/business/area"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.position",\n\t\t\t\t"title": "Cargo",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:collection",\n\t\t\t\t"link": "/business/position"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.official",\n\t\t\t\t"title": "Funcionario",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:user-circle",\n\t\t\t\t"link": "/business/official"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.plugin-attached",\n\t\t\t\t"title": "Plugin anexo",\n\t\t\t\t"type": "collapsable",\n\t\t\t\t"icon": "mat_outline:ballot",\n\t\t\t\t"children": [\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.attached",\n\t\t\t\t\t\t"title": "Anexo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:link",\n\t\t\t\t\t\t"link": "/business/attached"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.documentation-profile",\n\t\t\t\t\t\t"title": "Perfil de docuemntación",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:document-text",\n\t\t\t\t\t\t"link": "/business/documentation-profile"\n\t\t\t\t\t}\n\t\t\t\t]\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.plugin-item",\n\t\t\t\t"title": "Plugin articulo",\n\t\t\t\t"type": "collapsable",\n\t\t\t\t"icon": "mat_outline:ballot",\n\t\t\t\t"children": [\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.plugin-item",\n\t\t\t\t\t\t"title": "Plugin Item",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "mat_outline:category",\n\t\t\t\t\t\t"link": "/business/plugin-item"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.item-category",\n\t\t\t\t\t\t"title": "Categoría del artículo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "mat_outline:category",\n\t\t\t\t\t\t"link": "/business/item-category"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.item",\n\t\t\t\t\t\t"title": "Artículo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:cube",\n\t\t\t\t\t\t"link": "/business/item"\n\t\t\t\t\t}\n\t\t\t\t]\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.bpm",\n\t\t\t\t"title": "BPM",\n\t\t\t\t"type": "collapsable",\n\t\t\t\t"icon": "heroicons_outline:cube-transparent",\n\t\t\t\t"children": [\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.level-status",\n\t\t\t\t\t\t"title": "Estado del nivel",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:status-online",\n\t\t\t\t\t\t"link": "/business/level-status"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.level-profile",\n\t\t\t\t\t\t"title": "Perfil del nivel",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:user-group",\n\t\t\t\t\t\t"link": "/business/level-profile"\n\t\t\t\t\t},\n\t\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.template",\n\t\t\t\t\t\t"title": "Plantilla",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:template",\n\t\t\t\t\t\t"link": "/business/template"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.level",\n\t\t\t\t\t\t"title": "Nivel",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:menu",\n\t\t\t\t\t\t"link": "/business/level"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.flow",\n\t\t\t\t\t\t"title": "Flujo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "mat_outline:account_tree",\n\t\t\t\t\t\t"link": "/business/flow"\n\t\t\t\t\t}\n\t\t\t\t]\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.process",\n\t\t\t\t"title": "Proceso",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:document",\n\t\t\t\t"link": "/business/process"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.task",\n\t\t\t\t"title": "Tarea",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "mat_outline:task",\n\t\t\t\t"link": "/business/task"\n\t\t\t}\n\t\t]\n\t},\n\t{\n\t\t"id": "report",\n\t\t"title": "Reportes",\n\t\t"subtitle": "Reportes del sistema",\n\t\t"type": "basic",\n\t\t"link": "/report"\n\t}\n]	f
2	1	Super Administrador (Compacta)	Navegación compacta para el super administrador	compactNavigation	t	[\n  {\n    "id": "core",\n    "title": "Core",\n    "type": "aside",\n    "icon": "heroicons_outline:chip",\n    "children": []\n  },\n  {\n    "id": "business",\n    "title": "Business",\n    "type": "aside",\n    "icon": "mat_outline:business",\n    "children": []\n  },\n  {\n    "id": "report",\n    "title": "Reportes",\n    "type": "aside",\n    "icon": "mat_outline:document",\n    "children": []\n  }\n]	f
3	1	Super Administrador (Futurista)	Navegación futurista para el super administrador	futuristicNavigation	t	[\n\t{\n\t\t"id": "core",\n\t\t"title": "Core",\n\t\t"subtitle": "Administración core del sistema",\n\t\t"type": "group",\n\t\t"icon": "heroicons_outline:chip",\n\t\t"children": [\n\t\t\t{\n\t\t\t\t"id": "core.company",\n\t\t\t\t"title": "Empresa",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:office-building",\n\t\t\t\t"link": "/core/company"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "core.navigation",\n\t\t\t\t"title": "Navegación",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:template",\n\t\t\t\t"link": "/core/navigation"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "core.profile",\n\t\t\t\t"title": "Perfil",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:user-group",\n\t\t\t\t"link": "/core/profile"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "core.type-user",\n\t\t\t\t"title": "Tipo de usuario",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "mat_outline:category",\n\t\t\t\t"link": "/core/type-user"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "core.user",\n\t\t\t\t"title": "Usuario",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:user",\n\t\t\t\t"link": "/core/user"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "core.session",\n\t\t\t\t"title": "Sesiones",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:login",\n\t\t\t\t"link": "/core/session"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "core.system-event",\n\t\t\t\t"title": "Eventos del sistema",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "mat_outline:event",\n\t\t\t\t"link": "/core/system-event"\n\t\t\t}\n\t\t]\n\t},\n\t{\n\t\t"id": "business",\n\t\t"title": "Business",\n\t\t"subtitle": "Administración business del sistema",\n\t\t"type": "group",\n\t\t"icon": "heroicons_outline:cube-transparent",\n\t\t"children": [\n\t\t\t{\n\t\t\t\t"id": "business.area",\n\t\t\t\t"title": "Area",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:view-boards",\n\t\t\t\t"link": "/business/area"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.position",\n\t\t\t\t"title": "Cargo",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:collection",\n\t\t\t\t"link": "/business/position"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.official",\n\t\t\t\t"title": "Funcionario",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:user-circle",\n\t\t\t\t"link": "/business/official"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.plugin-attached",\n\t\t\t\t"title": "Plugin anexo",\n\t\t\t\t"type": "collapsable",\n\t\t\t\t"icon": "mat_outline:ballot",\n\t\t\t\t"children": [\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.attached",\n\t\t\t\t\t\t"title": "Anexo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:link",\n\t\t\t\t\t\t"link": "/business/attached"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.documentation-profile",\n\t\t\t\t\t\t"title": "Perfil de docuemntación",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:document-text",\n\t\t\t\t\t\t"link": "/business/documentation-profile"\n\t\t\t\t\t}\n\t\t\t\t]\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.plugin-item",\n\t\t\t\t"title": "Plugin articulo",\n\t\t\t\t"type": "collapsable",\n\t\t\t\t"icon": "mat_outline:ballot",\n\t\t\t\t"children": [\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.plugin-item",\n\t\t\t\t\t\t"title": "Plugin Item",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "mat_outline:category",\n\t\t\t\t\t\t"link": "/business/plugin-item"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.item-category",\n\t\t\t\t\t\t"title": "Categoría del artículo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "mat_outline:category",\n\t\t\t\t\t\t"link": "/business/item-category"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.item",\n\t\t\t\t\t\t"title": "Artículo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:cube",\n\t\t\t\t\t\t"link": "/business/item"\n\t\t\t\t\t}\n\t\t\t\t]\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.bpm",\n\t\t\t\t"title": "BPM",\n\t\t\t\t"type": "collapsable",\n\t\t\t\t"icon": "heroicons_outline:cube-transparent",\n\t\t\t\t"children": [\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.level-status",\n\t\t\t\t\t\t"title": "Estado del nivel",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:status-online",\n\t\t\t\t\t\t"link": "/business/level-status"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.level-profile",\n\t\t\t\t\t\t"title": "Perfil del nivel",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:user-group",\n\t\t\t\t\t\t"link": "/business/level-profile"\n\t\t\t\t\t},\n\t\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.template",\n\t\t\t\t\t\t"title": "Plantilla",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:template",\n\t\t\t\t\t\t"link": "/business/template"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.level",\n\t\t\t\t\t\t"title": "Nivel",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:menu",\n\t\t\t\t\t\t"link": "/business/level"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.flow",\n\t\t\t\t\t\t"title": "Flujo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "mat_outline:account_tree",\n\t\t\t\t\t\t"link": "/business/flow"\n\t\t\t\t\t}\n\t\t\t\t]\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.process",\n\t\t\t\t"title": "Proceso",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:document",\n\t\t\t\t"link": "/business/process"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.task",\n\t\t\t\t"title": "Tarea",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "mat_outline:task",\n\t\t\t\t"link": "/business/task"\n\t\t\t}\n\t\t]\n\t},\n\t{\n\t\t"id": "report",\n\t\t"title": "Reportes",\n\t\t"subtitle": "Reportes del sistema",\n\t\t"type": "basic",\n\t\t"link": "/report"\n\t}\n]	f
4	1	Super Administrador (Horizontal)	Navegación horizontal para el super administrador	horizontalNavigation	t	[\n  {\n    "id": "core",\n    "title": "Core",\n    "type": "aside",\n    "icon": "heroicons_outline:chip",\n    "children": []\n  },\n  {\n    "id": "business",\n    "title": "Business",\n    "type": "aside",\n    "icon": "mat_outline:business",\n    "children": []\n  },\n  {\n    "id": "report",\n    "title": "Reportes",\n    "type": "aside",\n    "icon": "mat_outline:document",\n    "children": []\n  }\n]	f
5	1	Administrador (Por defecto)	Navegación por defecto para el administrador	defaultNavigation	t	[\n\t{\n\t\t"id": "business",\n\t\t"title": "Business",\n\t\t"subtitle": "Administración business del sistema",\n\t\t"type": "group",\n\t\t"icon": "heroicons_outline:cube-transparent",\n\t\t"children": [\n\t\t\t{\n\t\t\t\t"id": "business.area",\n\t\t\t\t"title": "Area",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:view-boards",\n\t\t\t\t"link": "/business/area"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.position",\n\t\t\t\t"title": "Cargo",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:collection",\n\t\t\t\t"link": "/business/position"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.official",\n\t\t\t\t"title": "Funcionario",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:user-circle",\n\t\t\t\t"link": "/business/official"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.plugin-attached",\n\t\t\t\t"title": "Plugin anexo",\n\t\t\t\t"type": "collapsable",\n\t\t\t\t"icon": "mat_outline:ballot",\n\t\t\t\t"children": [\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.attached",\n\t\t\t\t\t\t"title": "Anexo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:link",\n\t\t\t\t\t\t"link": "/business/attached"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.documentation-profile",\n\t\t\t\t\t\t"title": "Perfil de docuemntación",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:document-text",\n\t\t\t\t\t\t"link": "/business/documentation-profile"\n\t\t\t\t\t}\n\t\t\t\t]\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.plugin-item",\n\t\t\t\t"title": "Plugin articulo",\n\t\t\t\t"type": "collapsable",\n\t\t\t\t"icon": "mat_outline:ballot",\n\t\t\t\t"children": [\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.plugin-item",\n\t\t\t\t\t\t"title": "Categoría del artículo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "mat_outline:category",\n\t\t\t\t\t\t"link": "/business/plugin-item"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.item-category",\n\t\t\t\t\t\t"title": "Categoría del artículo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "mat_outline:category",\n\t\t\t\t\t\t"link": "/business/item-category"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.item",\n\t\t\t\t\t\t"title": "Artículo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:cube",\n\t\t\t\t\t\t"link": "/business/item"\n\t\t\t\t\t}\n\t\t\t\t]\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.bpm",\n\t\t\t\t"title": "BPM",\n\t\t\t\t"type": "collapsable",\n\t\t\t\t"icon": "heroicons_outline:cube-transparent",\n\t\t\t\t"children": [\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.level-status",\n\t\t\t\t\t\t"title": "Estado del nivel",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:status-online",\n\t\t\t\t\t\t"link": "/business/level-status"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.level-profile",\n\t\t\t\t\t\t"title": "Perfil del nivel",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:user-group",\n\t\t\t\t\t\t"link": "/business/level-profile"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.template",\n\t\t\t\t\t\t"title": "Plantilla",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:template",\n\t\t\t\t\t\t"link": "/business/template"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.level",\n\t\t\t\t\t\t"title": "Nivel",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:menu",\n\t\t\t\t\t\t"link": "/business/level"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.flow",\n\t\t\t\t\t\t"title": "Flujo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "mat_outline:account_tree",\n\t\t\t\t\t\t"link": "/business/flow"\n\t\t\t\t\t}\n\t\t\t\t]\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.process",\n\t\t\t\t"title": "Proceso",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:document",\n\t\t\t\t"link": "/business/process"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.task",\n\t\t\t\t"title": "Tarea",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "mat_outline:task",\n\t\t\t\t"link": "/business/task"\n\t\t\t}\n\t\t]\n\t},\n\t{\n\t\t"id": "report",\n\t\t"title": "Reportes",\n\t\t"subtitle": "Reportes del sistema",\n\t\t"type": "basic",\n\t\t"link": "/report"\n\t}\n]	f
6	1	Administrador (Compacta)	Navegación compacta para el administrador	compactNavigation	t	[\n\t{\n\t\t"id": "business",\n\t\t"title": "Business",\n\t\t"type": "aside",\n\t\t"icon": "mat_outline:business",\n\t\t"children": []\n\t},\n\t{\n\t\t"id": "report",\n\t\t"title": "Reportes",\n\t\t"type": "aside",\n\t\t"icon": "mat_outline:document",\n\t\t"children": []\n\t}\n]	f
7	1	Administrador (Futurista)	Navegación futurista para el administrador	futuristicNavigation	t	[\n\t{\n\t\t"id": "business",\n\t\t"title": "Business",\n\t\t"subtitle": "Administración business del sistema",\n\t\t"type": "group",\n\t\t"icon": "heroicons_outline:cube-transparent",\n\t\t"children": [\n\t\t\t{\n\t\t\t\t"id": "business.area",\n\t\t\t\t"title": "Area",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:view-boards",\n\t\t\t\t"link": "/business/area"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.position",\n\t\t\t\t"title": "Cargo",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:collection",\n\t\t\t\t"link": "/business/position"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.official",\n\t\t\t\t"title": "Funcionario",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:user-circle",\n\t\t\t\t"link": "/business/official"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.plugin-attached",\n\t\t\t\t"title": "Plugin anexo",\n\t\t\t\t"type": "collapsable",\n\t\t\t\t"icon": "mat_outline:ballot",\n\t\t\t\t"children": [\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.attached",\n\t\t\t\t\t\t"title": "Anexo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:link",\n\t\t\t\t\t\t"link": "/business/attached"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.documentation-profile",\n\t\t\t\t\t\t"title": "Perfil de docuemntación",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:document-text",\n\t\t\t\t\t\t"link": "/business/documentation-profile"\n\t\t\t\t\t}\n\t\t\t\t]\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.plugin-item",\n\t\t\t\t"title": "Plugin articulo",\n\t\t\t\t"type": "collapsable",\n\t\t\t\t"icon": "mat_outline:ballot",\n\t\t\t\t"children": [\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.plugin-item",\n\t\t\t\t\t\t"title": "Categoría del artículo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "mat_outline:category",\n\t\t\t\t\t\t"link": "/business/plugin-item"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.item-category",\n\t\t\t\t\t\t"title": "Categoría del artículo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "mat_outline:category",\n\t\t\t\t\t\t"link": "/business/item-category"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.item",\n\t\t\t\t\t\t"title": "Artículo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:cube",\n\t\t\t\t\t\t"link": "/business/item"\n\t\t\t\t\t}\n\t\t\t\t]\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.bpm",\n\t\t\t\t"title": "BPM",\n\t\t\t\t"type": "collapsable",\n\t\t\t\t"icon": "heroicons_outline:cube-transparent",\n\t\t\t\t"children": [\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.level-status",\n\t\t\t\t\t\t"title": "Estado del nivel",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:status-online",\n\t\t\t\t\t\t"link": "/business/level-status"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.level-profile",\n\t\t\t\t\t\t"title": "Perfil del nivel",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:user-group",\n\t\t\t\t\t\t"link": "/business/level-profile"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.template",\n\t\t\t\t\t\t"title": "Plantilla",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:template",\n\t\t\t\t\t\t"link": "/business/template"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.level",\n\t\t\t\t\t\t"title": "Nivel",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:menu",\n\t\t\t\t\t\t"link": "/business/level"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.flow",\n\t\t\t\t\t\t"title": "Flujo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "mat_outline:account_tree",\n\t\t\t\t\t\t"link": "/business/flow"\n\t\t\t\t\t}\n\t\t\t\t]\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.process",\n\t\t\t\t"title": "Proceso",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:document",\n\t\t\t\t"link": "/business/process"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.task",\n\t\t\t\t"title": "Tarea",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "mat_outline:task",\n\t\t\t\t"link": "/business/task"\n\t\t\t}\n\t\t]\n\t},\n\t{\n\t\t"id": "report",\n\t\t"title": "Reportes",\n\t\t"subtitle": "Reportes del sistema",\n\t\t"type": "basic",\n\t\t"link": "/report"\n\t}\n]	f
8	1	Administrador (Horizontal)	Navegación horizontal para el administrador	horizontalNavigation	t	[\n\t{\n\t\t"id": "business",\n\t\t"title": "Business",\n\t\t"type": "aside",\n\t\t"icon": "mat_outline:business",\n\t\t"children": []\n\t},\n\t{\n\t\t"id": "report",\n\t\t"title": "Reportes",\n\t\t"type": "aside",\n\t\t"icon": "mat_outline:document",\n\t\t"children": []\n\t}\n]	f
9	1	Fiscalizador (Por defecto)	Navegación por defecto para el fiscalizador	defaultNavigation	t	[\n\t{\n\t\t"id": "business",\n\t\t"title": "Business",\n\t\t"subtitle": "Administración business del sistema",\n\t\t"type": "group",\n\t\t"icon": "heroicons_outline:cube-transparent",\n\t\t"children": [\n\t\t\t{\n\t\t\t\t"id": "business.plugin-attached",\n\t\t\t\t"title": "Plugin anexo",\n\t\t\t\t"type": "collapsable",\n\t\t\t\t"icon": "mat_outline:ballot",\n\t\t\t\t"children": [\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.attached",\n\t\t\t\t\t\t"title": "Anexo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:link",\n\t\t\t\t\t\t"link": "/business/attached"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.documentation-profile",\n\t\t\t\t\t\t"title": "Perfil de docuemntación",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:document-text",\n\t\t\t\t\t\t"link": "/business/documentation-profile"\n\t\t\t\t\t}\n\t\t\t\t]\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.process",\n\t\t\t\t"title": "Proceso",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:document",\n\t\t\t\t"link": "/business/process"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.task",\n\t\t\t\t"title": "Tarea",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "mat_outline:task",\n\t\t\t\t"link": "/business/task"\n\t\t\t}\n\t\t]\n\t},\n\t{\n\t\t"id": "report",\n\t\t"title": "Reportes",\n\t\t"subtitle": "Reportes del sistema",\n\t\t"type": "basic",\n\t\t"link": "/report"\n\t}\n]	f
10	1	Fiscalizador (Compacta)	Navegación compacta para el fiscalizador	compactNavigation	t	[\n\t{\n\t\t"id": "business",\n\t\t"title": "Business",\n\t\t"type": "aside",\n\t\t"icon": "mat_outline:business",\n\t\t"children": []\n\t},\n\t{\n\t\t"id": "report",\n\t\t"title": "Reportes",\n\t\t"type": "aside",\n\t\t"icon": "mat_outline:document",\n\t\t"children": []\n\t}\n]	f
11	1	Fiscalizador (Futurista)	Navegación futurista para el fiscalizador	futuristicNavigation	t	[\n\t{\n\t\t"id": "business",\n\t\t"title": "Business",\n\t\t"subtitle": "Administración business del sistema",\n\t\t"type": "group",\n\t\t"icon": "heroicons_outline:cube-transparent",\n\t\t"children": [\n\t\t\t{\n\t\t\t\t"id": "business.plugin-attached",\n\t\t\t\t"title": "Plugin anexo",\n\t\t\t\t"type": "collapsable",\n\t\t\t\t"icon": "mat_outline:ballot",\n\t\t\t\t"children": [\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.attached",\n\t\t\t\t\t\t"title": "Anexo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:link",\n\t\t\t\t\t\t"link": "/business/attached"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.documentation-profile",\n\t\t\t\t\t\t"title": "Perfil de docuemntación",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:document-text",\n\t\t\t\t\t\t"link": "/business/documentation-profile"\n\t\t\t\t\t}\n\t\t\t\t]\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.process",\n\t\t\t\t"title": "Proceso",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:document",\n\t\t\t\t"link": "/business/process"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.task",\n\t\t\t\t"title": "Tarea",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "mat_outline:task",\n\t\t\t\t"link": "/business/task"\n\t\t\t}\n\t\t]\n\t},\n\t{\n\t\t"id": "report",\n\t\t"title": "Reportes",\n\t\t"subtitle": "Reportes del sistema",\n\t\t"type": "basic",\n\t\t"link": "/report"\n\t}\n]	f
12	1	Fiscalizador (Horizontal)	Navegación horizontal para el fiscalizador	horizontalNavigation	t	[\n\t{\n\t\t"id": "business",\n\t\t"title": "Business",\n\t\t"type": "aside",\n\t\t"icon": "mat_outline:business",\n\t\t"children": []\n\t},\n\t{\n\t\t"id": "report",\n\t\t"title": "Reportes",\n\t\t"type": "aside",\n\t\t"icon": "mat_outline:document",\n\t\t"children": []\n\t}\n]	f
13	1	Gestor de inventario (Por defecto)	Navegación por defecto para el gestor de inventario	defaultNavigation	t	[\n\t{\n\t\t"id": "business",\n\t\t"title": "Business",\n\t\t"subtitle": "Administración business del sistema",\n\t\t"type": "group",\n\t\t"icon": "heroicons_outline:cube-transparent",\n\t\t"children": [\n\t\t\t{\n\t\t\t\t"id": "business.plugin-item",\n\t\t\t\t"title": "Plugin articulo",\n\t\t\t\t"type": "collapsable",\n\t\t\t\t"icon": "mat_outline:ballot",\n\t\t\t\t"children": [\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.plugin-item",\n\t\t\t\t\t\t"title": "Categoría del artículo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "mat_outline:category",\n\t\t\t\t\t\t"link": "/business/plugin-item"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.item-category",\n\t\t\t\t\t\t"title": "Categoría del artículo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "mat_outline:category",\n\t\t\t\t\t\t"link": "/business/item-category"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.item",\n\t\t\t\t\t\t"title": "Artículo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:cube",\n\t\t\t\t\t\t"link": "/business/item"\n\t\t\t\t\t}\n\t\t\t\t]\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.process",\n\t\t\t\t"title": "Proceso",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:document",\n\t\t\t\t"link": "/business/process"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.task",\n\t\t\t\t"title": "Tarea",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "mat_outline:task",\n\t\t\t\t"link": "/business/task"\n\t\t\t}\n\t\t]\n\t},\n\t{\n\t\t"id": "report",\n\t\t"title": "Reportes",\n\t\t"subtitle": "Reportes del sistema",\n\t\t"type": "basic",\n\t\t"link": "/report"\n\t}\n]	f
14	1	Gestor de inventario (Compacta)	Navegación compacta para el gestor de inventario	compactNavigation	t	[\n\t{\n\t\t"id": "business",\n\t\t"title": "Business",\n\t\t"type": "aside",\n\t\t"icon": "mat_outline:business",\n\t\t"children": []\n\t},\n\t{\n\t\t"id": "report",\n\t\t"title": "Reportes",\n\t\t"type": "aside",\n\t\t"icon": "mat_outline:document",\n\t\t"children": []\n\t}\n]	f
15	1	Gestor de inventario (Futurista)	Navegación futurista para el gestor de inventario	futuristicNavigation	t	[\n\t{\n\t\t"id": "business",\n\t\t"title": "Business",\n\t\t"subtitle": "Administración business del sistema",\n\t\t"type": "group",\n\t\t"icon": "heroicons_outline:cube-transparent",\n\t\t"children": [\n\t\t\t{\n\t\t\t\t"id": "business.plugin-item",\n\t\t\t\t"title": "Plugin articulo",\n\t\t\t\t"type": "collapsable",\n\t\t\t\t"icon": "mat_outline:ballot",\n\t\t\t\t"children": [\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.plugin-item",\n\t\t\t\t\t\t"title": "Categoría del artículo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "mat_outline:category",\n\t\t\t\t\t\t"link": "/business/plugin-item"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.item-category",\n\t\t\t\t\t\t"title": "Categoría del artículo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "mat_outline:category",\n\t\t\t\t\t\t"link": "/business/item-category"\n\t\t\t\t\t},\n\t\t\t\t\t{\n\t\t\t\t\t\t"id": "business.item",\n\t\t\t\t\t\t"title": "Artículo",\n\t\t\t\t\t\t"type": "basic",\n\t\t\t\t\t\t"icon": "heroicons_outline:cube",\n\t\t\t\t\t\t"link": "/business/item"\n\t\t\t\t\t}\n\t\t\t\t]\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.process",\n\t\t\t\t"title": "Proceso",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:document",\n\t\t\t\t"link": "/business/process"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.task",\n\t\t\t\t"title": "Tarea",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "mat_outline:task",\n\t\t\t\t"link": "/business/task"\n\t\t\t}\n\t\t]\n\t},\n\t{\n\t\t"id": "report",\n\t\t"title": "Reportes",\n\t\t"subtitle": "Reportes del sistema",\n\t\t"type": "basic",\n\t\t"link": "/report"\n\t}\n]	f
16	1	Gestor de inventario (Horizontal)	Navegación horizontal para el gestor de inventario	horizontalNavigation	t	[\n\t{\n\t\t"id": "business",\n\t\t"title": "Business",\n\t\t"type": "aside",\n\t\t"icon": "mat_outline:business",\n\t\t"children": []\n\t},\n\t{\n\t\t"id": "report",\n\t\t"title": "Reportes",\n\t\t"type": "aside",\n\t\t"icon": "mat_outline:document",\n\t\t"children": []\n\t}\n]	f
17	1	Solicitante (Por defecto)	Navegación por defecto para el solicitante	defaultNavigation	t	[\n\t{\n\t\t"id": "business",\n\t\t"title": "Business",\n\t\t"subtitle": "Administración business del sistema",\n\t\t"type": "group",\n\t\t"icon": "heroicons_outline:cube-transparent",\n\t\t"children": [\n\t\t\t{\n\t\t\t\t"id": "business.process",\n\t\t\t\t"title": "Proceso",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:document",\n\t\t\t\t"link": "/business/process"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.task",\n\t\t\t\t"title": "Tarea",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "mat_outline:task",\n\t\t\t\t"link": "/business/task"\n\t\t\t}\n\t\t]\n\t}\n]	f
18	1	Solicitante (Compacta)	Navegación compacta para el solicitante	compactNavigation	t	[\n\t{\n\t\t"id": "business",\n\t\t"title": "Business",\n\t\t"type": "aside",\n\t\t"icon": "mat_outline:business",\n\t\t"children": []\n\t}\n]	f
19	1	Solicitante (Futurista)	Navegación futurista para el solicitante	futuristicNavigation	t	[\n\t{\n\t\t"id": "business",\n\t\t"title": "Business",\n\t\t"subtitle": "Administración business del sistema",\n\t\t"type": "group",\n\t\t"icon": "heroicons_outline:cube-transparent",\n\t\t"children": [\n\t\t\t{\n\t\t\t\t"id": "business.process",\n\t\t\t\t"title": "Proceso",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "heroicons_outline:document",\n\t\t\t\t"link": "/business/process"\n\t\t\t},\n\t\t\t{\n\t\t\t\t"id": "business.task",\n\t\t\t\t"title": "Tarea",\n\t\t\t\t"type": "basic",\n\t\t\t\t"icon": "mat_outline:task",\n\t\t\t\t"link": "/business/task"\n\t\t\t}\n\t\t]\n\t}\n]	f
20	1	Solicitante (Horizontal)	Navegación horizontal para el solicitante	horizontalNavigation	t	[\n\t{\n\t\t"id": "business",\n\t\t"title": "Business",\n\t\t"type": "aside",\n\t\t"icon": "mat_outline:business",\n\t\t"children": []\n\t}\n]	f
\.


--
-- TOC entry 4086 (class 0 OID 20592)
-- Dependencies: 206
-- Data for Name: person; Type: TABLE DATA; Schema: core; Owner: app_nashor
--

COPY core.person (id_person, id_academic, id_job, dni_person, name_person, last_name_person, address_person, phone_person, deleted_person) FROM stdin;
1	1	1	1600744443	ALBERTO	ALDAS	PUYO	+593	f
2	2	2	1600495970	Javier David	Noboa Pumalema	PUYO	+593	f
3	3	3	1600369746	Alberto Alexander	Aldás Villacrés	PUYO	+593	f
4	4	4	1708237480	Mario Segundo	Granda	PUYO	+593	f
5	5	5	1600156952	Ricardo Raúl	Freire Castillo	PUYO	+593	f
6	6	6	1715105597	Jaime Rolando	Gallardo Diaz	PUYO	+593	f
7	7	7	1600296006	Edwin Oswaldo	Zuñiga Calderón	PUYO	+593	f
8	8	8	1803578051	Verónica de los Angeles	Viteri Fiallos	PUYO	+593	f
\.


--
-- TOC entry 4087 (class 0 OID 20600)
-- Dependencies: 207
-- Data for Name: profile; Type: TABLE DATA; Schema: core; Owner: app_nashor
--

COPY core.profile (id_profile, id_company, type_profile, name_profile, description_profile, status_profile, deleted_profile) FROM stdin;
1	1	administator	Perfil Super Administrador	Perfil de usuario para el super administrador	t	f
2	1	commonProfile	Perfil Administrador	Perfil de usuario para el administrador	t	f
3	1	commonProfile	Perfil Fiscalizador	Perfil de usuario para el fiscalizador	t	f
4	1	commonProfile	Perfil Gestor de inventario	Perfil de usuario para el gestor de inventario	t	f
5	1	commonProfile	Perfil Solicitante	Perfil de usuario para el solicitante	t	f
\.


--
-- TOC entry 4088 (class 0 OID 20605)
-- Dependencies: 208
-- Data for Name: profile_navigation; Type: TABLE DATA; Schema: core; Owner: app_nashor
--

COPY core.profile_navigation (id_profile_navigation, id_profile, id_navigation) FROM stdin;
1	1	1
2	1	2
3	1	3
4	1	4
5	2	5
6	2	6
7	2	7
8	2	8
9	3	9
10	3	10
11	3	11
12	3	12
13	4	13
14	4	14
15	4	15
16	4	16
17	5	17
18	5	18
19	5	19
20	5	20
\.


--
-- TOC entry 4092 (class 0 OID 20634)
-- Dependencies: 212
-- Data for Name: session; Type: TABLE DATA; Schema: core; Owner: app_nashor
--

COPY core.session (id_session, id_user, host_session, agent_session, date_sign_in_session, date_sign_out_session, status_session) FROM stdin;
1	1	10.0.0.30	{"browser":"Chrome","version":"113.0.0.0","os":"Windows 10.0","platform":"Microsoft Windows","source":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36"}	2023-05-24 02:52:17.142709	2023-05-24 02:52:19.715713	f
\.


--
-- TOC entry 4089 (class 0 OID 20610)
-- Dependencies: 209
-- Data for Name: setting; Type: TABLE DATA; Schema: core; Owner: app_nashor
--

COPY core.setting (id_setting, expiration_token, expiration_verification_code, inactivity_time, session_limit, save_log, save_file_alfresco, modification_status, deleted_setting) FROM stdin;
1	604800	300	86400	999	f	f	f	f
\.


--
-- TOC entry 4094 (class 0 OID 20647)
-- Dependencies: 214
-- Data for Name: system_event; Type: TABLE DATA; Schema: core; Owner: app_nashor
--

COPY core.system_event (id_system_event, id_user, table_system_event, row_system_event, action_system_event, date_system_event, deleted_system_event) FROM stdin;
\.


--
-- TOC entry 4093 (class 0 OID 20642)
-- Dependencies: 213
-- Data for Name: type_user; Type: TABLE DATA; Schema: core; Owner: app_nashor
--

COPY core.type_user (id_type_user, id_company, id_profile, name_type_user, description_type_user, status_type_user, deleted_type_user) FROM stdin;
1	1	1	Super Administrador	Tipo de usuario para el super administrador	t	f
2	1	2	Administrador	Tipo de usuario para el administrador	t	f
3	1	3	Fiscalizador	Tipo de usuario para el fiscalizador	t	f
4	1	4	Gestor de inventario	Tipo de usuario para el gestor de inventario	t	f
5	1	5	Solicitante	Tipo de usuario para el solicitante	t	f
\.


--
-- TOC entry 4090 (class 0 OID 20615)
-- Dependencies: 210
-- Data for Name: user; Type: TABLE DATA; Schema: core; Owner: app_nashor
--

COPY core."user" (id_user, id_company, id_person, id_type_user, name_user, password_user, avatar_user, status_user, deleted_user) FROM stdin;
1	1	1	1	alberto.aldas@gmail.com	qd9HyK6TpiUzpuufxt/xAg==	default.svg	t	f
2	1	2	5	javier@nashor.puyo.gob.ec	kCDBvVvdctK+O4iiAprwPQ==	default.svg	t	f
3	1	3	2	beto@nashor.puyo.gob.ec	kCDBvVvdctK+O4iiAprwPQ==	default.svg	t	f
4	1	4	4	mario@nashor.puyo.gob.ec	kCDBvVvdctK+O4iiAprwPQ==	default.svg	t	f
5	1	5	3	ricardo@nashor.puyo.gob.ec	kCDBvVvdctK+O4iiAprwPQ==	default.svg	t	f
6	1	6	3	rolando@nashor.puyo.gob.ec	kCDBvVvdctK+O4iiAprwPQ==	default.svg	t	f
7	1	7	3	oswaldo@nashor.puyo.gob.ec	kCDBvVvdctK+O4iiAprwPQ==	default.svg	t	f
8	1	8	3	veronica@nashor.puyo.gob.ec	kCDBvVvdctK+O4iiAprwPQ==	default.svg	t	f
\.


--
-- TOC entry 4091 (class 0 OID 20623)
-- Dependencies: 211
-- Data for Name: validation; Type: TABLE DATA; Schema: core; Owner: app_nashor
--

COPY core.validation (id_validation, id_company, type_validation, status_validation, pattern_validation, message_validation, deleted_validation) FROM stdin;
1	1	validationPassword	f	RegExp	No cumple con la RegExp	f
2	1	validationDNI	f	RegExp	No cumple con la RegExp	f
3	1	validationPhoneNumber	f	RegExp	No cumple con la RegExp	f
\.


--
-- TOC entry 4169 (class 0 OID 0)
-- Dependencies: 282
-- Name: serial_area; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_area', 7, true);


--
-- TOC entry 4170 (class 0 OID 0)
-- Dependencies: 287
-- Name: serial_attached; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_attached', 5, true);


--
-- TOC entry 4171 (class 0 OID 0)
-- Dependencies: 307
-- Name: serial_column_process_item; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_column_process_item', 1, true);


--
-- TOC entry 4172 (class 0 OID 0)
-- Dependencies: 286
-- Name: serial_control; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_control', 7, true);


--
-- TOC entry 4173 (class 0 OID 0)
-- Dependencies: 288
-- Name: serial_documentation_profile; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_documentation_profile', 5, true);


--
-- TOC entry 4174 (class 0 OID 0)
-- Dependencies: 298
-- Name: serial_documentation_profile_attached; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_documentation_profile_attached', 5, true);


--
-- TOC entry 4175 (class 0 OID 0)
-- Dependencies: 290
-- Name: serial_flow; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_flow', 2, true);


--
-- TOC entry 4176 (class 0 OID 0)
-- Dependencies: 363
-- Name: serial_flow_id_1; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_flow_id_1', 5, true);


--
-- TOC entry 4177 (class 0 OID 0)
-- Dependencies: 299
-- Name: serial_flow_version; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_flow_version', 2, true);


--
-- TOC entry 4178 (class 0 OID 0)
-- Dependencies: 300
-- Name: serial_flow_version_level; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_flow_version_level', 8, true);


--
-- TOC entry 4179 (class 0 OID 0)
-- Dependencies: 293
-- Name: serial_item; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_item', 4, true);


--
-- TOC entry 4180 (class 0 OID 0)
-- Dependencies: 292
-- Name: serial_item_category; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_item_category', 2, true);


--
-- TOC entry 4181 (class 0 OID 0)
-- Dependencies: 291
-- Name: serial_level; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_level', 10, true);


--
-- TOC entry 4182 (class 0 OID 0)
-- Dependencies: 284
-- Name: serial_level_profile; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_level_profile', 7, true);


--
-- TOC entry 4183 (class 0 OID 0)
-- Dependencies: 295
-- Name: serial_level_profile_official; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_level_profile_official', 8, true);


--
-- TOC entry 4184 (class 0 OID 0)
-- Dependencies: 289
-- Name: serial_level_status; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_level_status', 4, true);


--
-- TOC entry 4185 (class 0 OID 0)
-- Dependencies: 281
-- Name: serial_official; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_official', 8, true);


--
-- TOC entry 4186 (class 0 OID 0)
-- Dependencies: 294
-- Name: serial_plugin_item; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_plugin_item', 2, true);


--
-- TOC entry 4187 (class 0 OID 0)
-- Dependencies: 306
-- Name: serial_plugin_item_column; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_plugin_item_column', 5, true);


--
-- TOC entry 4188 (class 0 OID 0)
-- Dependencies: 283
-- Name: serial_position; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_position', 8, true);


--
-- TOC entry 4189 (class 0 OID 0)
-- Dependencies: 296
-- Name: serial_process; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_process', 1, true);


--
-- TOC entry 4190 (class 0 OID 0)
-- Dependencies: 304
-- Name: serial_process_attached; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_process_attached', 1, true);


--
-- TOC entry 4191 (class 0 OID 0)
-- Dependencies: 303
-- Name: serial_process_comment; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_process_comment', 1, true);


--
-- TOC entry 4192 (class 0 OID 0)
-- Dependencies: 305
-- Name: serial_process_control; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_process_control', 1, true);


--
-- TOC entry 4193 (class 0 OID 0)
-- Dependencies: 301
-- Name: serial_process_item; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_process_item', 1, true);


--
-- TOC entry 4194 (class 0 OID 0)
-- Dependencies: 302
-- Name: serial_task; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_task', 1, true);


--
-- TOC entry 4195 (class 0 OID 0)
-- Dependencies: 285
-- Name: serial_template; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_template', 10, true);


--
-- TOC entry 4196 (class 0 OID 0)
-- Dependencies: 297
-- Name: serial_template_control; Type: SEQUENCE SET; Schema: business; Owner: app_nashor
--

SELECT pg_catalog.setval('business.serial_template_control', 7, true);


--
-- TOC entry 4197 (class 0 OID 0)
-- Dependencies: 247
-- Name: serial_academic; Type: SEQUENCE SET; Schema: core; Owner: app_nashor
--

SELECT pg_catalog.setval('core.serial_academic', 9, true);


--
-- TOC entry 4198 (class 0 OID 0)
-- Dependencies: 243
-- Name: serial_company; Type: SEQUENCE SET; Schema: core; Owner: app_nashor
--

SELECT pg_catalog.setval('core.serial_company', 2, true);


--
-- TOC entry 4199 (class 0 OID 0)
-- Dependencies: 245
-- Name: serial_job; Type: SEQUENCE SET; Schema: core; Owner: app_nashor
--

SELECT pg_catalog.setval('core.serial_job', 9, true);


--
-- TOC entry 4200 (class 0 OID 0)
-- Dependencies: 244
-- Name: serial_navigation; Type: SEQUENCE SET; Schema: core; Owner: app_nashor
--

SELECT pg_catalog.setval('core.serial_navigation', 21, true);


--
-- TOC entry 4201 (class 0 OID 0)
-- Dependencies: 246
-- Name: serial_person; Type: SEQUENCE SET; Schema: core; Owner: app_nashor
--

SELECT pg_catalog.setval('core.serial_person', 9, true);


--
-- TOC entry 4202 (class 0 OID 0)
-- Dependencies: 248
-- Name: serial_profile; Type: SEQUENCE SET; Schema: core; Owner: app_nashor
--

SELECT pg_catalog.setval('core.serial_profile', 6, true);


--
-- TOC entry 4203 (class 0 OID 0)
-- Dependencies: 249
-- Name: serial_profile_navigation; Type: SEQUENCE SET; Schema: core; Owner: app_nashor
--

SELECT pg_catalog.setval('core.serial_profile_navigation', 21, true);


--
-- TOC entry 4204 (class 0 OID 0)
-- Dependencies: 253
-- Name: serial_session; Type: SEQUENCE SET; Schema: core; Owner: app_nashor
--

SELECT pg_catalog.setval('core.serial_session', 2, true);


--
-- TOC entry 4205 (class 0 OID 0)
-- Dependencies: 242
-- Name: serial_setting; Type: SEQUENCE SET; Schema: core; Owner: app_nashor
--

SELECT pg_catalog.setval('core.serial_setting', 2, true);


--
-- TOC entry 4206 (class 0 OID 0)
-- Dependencies: 254
-- Name: serial_system_event; Type: SEQUENCE SET; Schema: core; Owner: app_nashor
--

SELECT pg_catalog.setval('core.serial_system_event', 1, true);


--
-- TOC entry 4207 (class 0 OID 0)
-- Dependencies: 251
-- Name: serial_type_user; Type: SEQUENCE SET; Schema: core; Owner: app_nashor
--

SELECT pg_catalog.setval('core.serial_type_user', 6, true);


--
-- TOC entry 4208 (class 0 OID 0)
-- Dependencies: 250
-- Name: serial_user; Type: SEQUENCE SET; Schema: core; Owner: app_nashor
--

SELECT pg_catalog.setval('core.serial_user', 9, true);


--
-- TOC entry 4209 (class 0 OID 0)
-- Dependencies: 252
-- Name: serial_validation; Type: SEQUENCE SET; Schema: core; Owner: app_nashor
--

SELECT pg_catalog.setval('core.serial_validation', 4, true);


--
-- TOC entry 3746 (class 2606 OID 20661)
-- Name: area area_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.area
    ADD CONSTRAINT area_pkey PRIMARY KEY (id_area);


--
-- TOC entry 3762 (class 2606 OID 20704)
-- Name: attached attached_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.attached
    ADD CONSTRAINT attached_pkey PRIMARY KEY (id_attached);


--
-- TOC entry 3796 (class 2606 OID 20798)
-- Name: column_process_item column_process_item_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.column_process_item
    ADD CONSTRAINT column_process_item_pkey PRIMARY KEY (id_column_process_item);


--
-- TOC entry 3758 (class 2606 OID 20694)
-- Name: control control_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.control
    ADD CONSTRAINT control_pkey PRIMARY KEY (id_control);


--
-- TOC entry 3766 (class 2606 OID 20714)
-- Name: documentation_profile_attached documentation_profile_attached_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.documentation_profile_attached
    ADD CONSTRAINT documentation_profile_attached_pkey PRIMARY KEY (id_documentation_profile_attached);


--
-- TOC entry 3764 (class 2606 OID 20709)
-- Name: documentation_profile documentation_profile_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.documentation_profile
    ADD CONSTRAINT documentation_profile_pkey PRIMARY KEY (id_documentation_profile);


--
-- TOC entry 3770 (class 2606 OID 20724)
-- Name: flow flow_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.flow
    ADD CONSTRAINT flow_pkey PRIMARY KEY (id_flow);


--
-- TOC entry 3776 (class 2606 OID 20739)
-- Name: flow_version_level flow_version_level_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.flow_version_level
    ADD CONSTRAINT flow_version_level_pkey PRIMARY KEY (id_flow_version_level);


--
-- TOC entry 3772 (class 2606 OID 20729)
-- Name: flow_version flow_version_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.flow_version
    ADD CONSTRAINT flow_version_pkey PRIMARY KEY (id_flow_version);


--
-- TOC entry 3778 (class 2606 OID 20744)
-- Name: item_category item_category_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.item_category
    ADD CONSTRAINT item_category_pkey PRIMARY KEY (id_item_category);


--
-- TOC entry 3780 (class 2606 OID 20749)
-- Name: item item_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.item
    ADD CONSTRAINT item_pkey PRIMARY KEY (id_item);


--
-- TOC entry 3774 (class 2606 OID 20734)
-- Name: level level_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.level
    ADD CONSTRAINT level_pkey PRIMARY KEY (id_level);


--
-- TOC entry 3752 (class 2606 OID 20676)
-- Name: level_profile_official level_profile_official_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.level_profile_official
    ADD CONSTRAINT level_profile_official_pkey PRIMARY KEY (id_level_profile_official);


--
-- TOC entry 3750 (class 2606 OID 20671)
-- Name: level_profile level_profile_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.level_profile
    ADD CONSTRAINT level_profile_pkey PRIMARY KEY (id_level_profile);


--
-- TOC entry 3768 (class 2606 OID 20719)
-- Name: level_status level_status_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.level_status
    ADD CONSTRAINT level_status_pkey PRIMARY KEY (id_level_status);


--
-- TOC entry 3744 (class 2606 OID 20656)
-- Name: official official_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.official
    ADD CONSTRAINT official_pkey PRIMARY KEY (id_official);


--
-- TOC entry 3794 (class 2606 OID 20790)
-- Name: plugin_item_column plugin_item_column_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.plugin_item_column
    ADD CONSTRAINT plugin_item_column_pkey PRIMARY KEY (id_plugin_item_column);


--
-- TOC entry 3792 (class 2606 OID 20785)
-- Name: plugin_item plugin_item_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.plugin_item
    ADD CONSTRAINT plugin_item_pkey PRIMARY KEY (id_plugin_item);


--
-- TOC entry 3748 (class 2606 OID 20666)
-- Name: position position_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business."position"
    ADD CONSTRAINT position_pkey PRIMARY KEY (id_position);


--
-- TOC entry 3788 (class 2606 OID 20772)
-- Name: process_attached process_attached_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process_attached
    ADD CONSTRAINT process_attached_pkey PRIMARY KEY (id_process_attached);


--
-- TOC entry 3786 (class 2606 OID 20764)
-- Name: process_comment process_comment_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process_comment
    ADD CONSTRAINT process_comment_pkey PRIMARY KEY (id_process_comment);


--
-- TOC entry 3790 (class 2606 OID 20780)
-- Name: process_control process_control_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process_control
    ADD CONSTRAINT process_control_pkey PRIMARY KEY (id_process_control);


--
-- TOC entry 3782 (class 2606 OID 20754)
-- Name: process_item process_item_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process_item
    ADD CONSTRAINT process_item_pkey PRIMARY KEY (id_process_item);


--
-- TOC entry 3754 (class 2606 OID 20681)
-- Name: process process_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process
    ADD CONSTRAINT process_pkey PRIMARY KEY (id_process);


--
-- TOC entry 3784 (class 2606 OID 20759)
-- Name: task task_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.task
    ADD CONSTRAINT task_pkey PRIMARY KEY (id_task);


--
-- TOC entry 3760 (class 2606 OID 20699)
-- Name: template_control template_control_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.template_control
    ADD CONSTRAINT template_control_pkey PRIMARY KEY (id_template_control);


--
-- TOC entry 3756 (class 2606 OID 20686)
-- Name: template template_pkey; Type: CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.template
    ADD CONSTRAINT template_pkey PRIMARY KEY (id_template);


--
-- TOC entry 3718 (class 2606 OID 20570)
-- Name: academic academic_pkey; Type: CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core.academic
    ADD CONSTRAINT academic_pkey PRIMARY KEY (id_academic);


--
-- TOC entry 3720 (class 2606 OID 20575)
-- Name: company company_pkey; Type: CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core.company
    ADD CONSTRAINT company_pkey PRIMARY KEY (id_company);


--
-- TOC entry 3722 (class 2606 OID 20583)
-- Name: job job_pkey; Type: CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core.job
    ADD CONSTRAINT job_pkey PRIMARY KEY (id_job);


--
-- TOC entry 3724 (class 2606 OID 20591)
-- Name: navigation navigation_pkey; Type: CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core.navigation
    ADD CONSTRAINT navigation_pkey PRIMARY KEY (id_navigation);


--
-- TOC entry 3726 (class 2606 OID 20599)
-- Name: person person_pkey; Type: CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core.person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id_person);


--
-- TOC entry 3730 (class 2606 OID 20609)
-- Name: profile_navigation profile_navigation_pkey; Type: CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core.profile_navigation
    ADD CONSTRAINT profile_navigation_pkey PRIMARY KEY (id_profile_navigation);


--
-- TOC entry 3728 (class 2606 OID 20604)
-- Name: profile profile_pkey; Type: CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core.profile
    ADD CONSTRAINT profile_pkey PRIMARY KEY (id_profile);


--
-- TOC entry 3738 (class 2606 OID 20641)
-- Name: session session_pkey; Type: CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (id_session);


--
-- TOC entry 3732 (class 2606 OID 20614)
-- Name: setting setting_pkey; Type: CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core.setting
    ADD CONSTRAINT setting_pkey PRIMARY KEY (id_setting);


--
-- TOC entry 3742 (class 2606 OID 20651)
-- Name: system_event system_event_pkey; Type: CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core.system_event
    ADD CONSTRAINT system_event_pkey PRIMARY KEY (id_system_event);


--
-- TOC entry 3740 (class 2606 OID 20646)
-- Name: type_user type_user_pkey; Type: CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core.type_user
    ADD CONSTRAINT type_user_pkey PRIMARY KEY (id_type_user);


--
-- TOC entry 3734 (class 2606 OID 20622)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id_user);


--
-- TOC entry 3736 (class 2606 OID 20630)
-- Name: validation validation_pkey; Type: CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core.validation
    ADD CONSTRAINT validation_pkey PRIMARY KEY (id_validation);


--
-- TOC entry 3816 (class 2606 OID 20894)
-- Name: area area_id_company_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.area
    ADD CONSTRAINT area_id_company_fkey FOREIGN KEY (id_company) REFERENCES core.company(id_company) NOT VALID;


--
-- TOC entry 3829 (class 2606 OID 20959)
-- Name: attached attached_id_company_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.attached
    ADD CONSTRAINT attached_id_company_fkey FOREIGN KEY (id_company) REFERENCES core.company(id_company) NOT VALID;


--
-- TOC entry 3869 (class 2606 OID 21159)
-- Name: column_process_item column_process_item_id_plugin_item_column_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.column_process_item
    ADD CONSTRAINT column_process_item_id_plugin_item_column_fkey FOREIGN KEY (id_plugin_item_column) REFERENCES business.plugin_item_column(id_plugin_item_column) NOT VALID;


--
-- TOC entry 3870 (class 2606 OID 21164)
-- Name: column_process_item column_process_item_id_process_item_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.column_process_item
    ADD CONSTRAINT column_process_item_id_process_item_fkey FOREIGN KEY (id_process_item) REFERENCES business.process_item(id_process_item) NOT VALID;


--
-- TOC entry 3826 (class 2606 OID 20944)
-- Name: control control_id_company_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.control
    ADD CONSTRAINT control_id_company_fkey FOREIGN KEY (id_company) REFERENCES core.company(id_company) NOT VALID;


--
-- TOC entry 3831 (class 2606 OID 20969)
-- Name: documentation_profile_attached documentation_profile_attached_id_attached_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.documentation_profile_attached
    ADD CONSTRAINT documentation_profile_attached_id_attached_fkey FOREIGN KEY (id_attached) REFERENCES business.attached(id_attached) NOT VALID;


--
-- TOC entry 3832 (class 2606 OID 20974)
-- Name: documentation_profile_attached documentation_profile_attached_id_documentation_profile_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.documentation_profile_attached
    ADD CONSTRAINT documentation_profile_attached_id_documentation_profile_fkey FOREIGN KEY (id_documentation_profile) REFERENCES business.documentation_profile(id_documentation_profile) NOT VALID;


--
-- TOC entry 3830 (class 2606 OID 20964)
-- Name: documentation_profile documentation_profile_id_company_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.documentation_profile
    ADD CONSTRAINT documentation_profile_id_company_fkey FOREIGN KEY (id_company) REFERENCES core.company(id_company) NOT VALID;


--
-- TOC entry 3834 (class 2606 OID 20984)
-- Name: flow flow_id_company_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.flow
    ADD CONSTRAINT flow_id_company_fkey FOREIGN KEY (id_company) REFERENCES core.company(id_company) NOT VALID;


--
-- TOC entry 3835 (class 2606 OID 20989)
-- Name: flow_version flow_version_id_flow_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.flow_version
    ADD CONSTRAINT flow_version_id_flow_fkey FOREIGN KEY (id_flow) REFERENCES business.flow(id_flow) NOT VALID;


--
-- TOC entry 3840 (class 2606 OID 21014)
-- Name: flow_version_level flow_version_level_id_flow_version_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.flow_version_level
    ADD CONSTRAINT flow_version_level_id_flow_version_fkey FOREIGN KEY (id_flow_version) REFERENCES business.flow_version(id_flow_version) NOT VALID;


--
-- TOC entry 3841 (class 2606 OID 21019)
-- Name: flow_version_level flow_version_level_id_level_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.flow_version_level
    ADD CONSTRAINT flow_version_level_id_level_fkey FOREIGN KEY (id_level) REFERENCES business.level(id_level) NOT VALID;


--
-- TOC entry 3842 (class 2606 OID 21024)
-- Name: item_category item_category_id_company_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.item_category
    ADD CONSTRAINT item_category_id_company_fkey FOREIGN KEY (id_company) REFERENCES core.company(id_company) NOT VALID;


--
-- TOC entry 3843 (class 2606 OID 21029)
-- Name: item item_id_company_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.item
    ADD CONSTRAINT item_id_company_fkey FOREIGN KEY (id_company) REFERENCES core.company(id_company) NOT VALID;


--
-- TOC entry 3844 (class 2606 OID 21034)
-- Name: item item_id_item_category_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.item
    ADD CONSTRAINT item_id_item_category_fkey FOREIGN KEY (id_item_category) REFERENCES business.item_category(id_item_category) NOT VALID;


--
-- TOC entry 3836 (class 2606 OID 20994)
-- Name: level level_id_company_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.level
    ADD CONSTRAINT level_id_company_fkey FOREIGN KEY (id_company) REFERENCES core.company(id_company) NOT VALID;


--
-- TOC entry 3837 (class 2606 OID 20999)
-- Name: level level_id_level_profile_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.level
    ADD CONSTRAINT level_id_level_profile_fkey FOREIGN KEY (id_level_profile) REFERENCES business.level_profile(id_level_profile) NOT VALID;


--
-- TOC entry 3838 (class 2606 OID 21004)
-- Name: level level_id_level_status_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.level
    ADD CONSTRAINT level_id_level_status_fkey FOREIGN KEY (id_level_status) REFERENCES business.level_status(id_level_status) NOT VALID;


--
-- TOC entry 3839 (class 2606 OID 21009)
-- Name: level level_id_template_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.level
    ADD CONSTRAINT level_id_template_fkey FOREIGN KEY (id_template) REFERENCES business.template(id_template) NOT VALID;


--
-- TOC entry 3818 (class 2606 OID 20904)
-- Name: level_profile level_profile_id_company_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.level_profile
    ADD CONSTRAINT level_profile_id_company_fkey FOREIGN KEY (id_company) REFERENCES core.company(id_company) NOT VALID;


--
-- TOC entry 3819 (class 2606 OID 20909)
-- Name: level_profile_official level_profile_official_id_level_profile_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.level_profile_official
    ADD CONSTRAINT level_profile_official_id_level_profile_fkey FOREIGN KEY (id_level_profile) REFERENCES business.level_profile(id_level_profile) NOT VALID;


--
-- TOC entry 3820 (class 2606 OID 20914)
-- Name: level_profile_official level_profile_official_id_official_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.level_profile_official
    ADD CONSTRAINT level_profile_official_id_official_fkey FOREIGN KEY (id_official) REFERENCES business.official(id_official) NOT VALID;


--
-- TOC entry 3833 (class 2606 OID 20979)
-- Name: level_status level_status_id_company_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.level_status
    ADD CONSTRAINT level_status_id_company_fkey FOREIGN KEY (id_company) REFERENCES core.company(id_company) NOT VALID;


--
-- TOC entry 3814 (class 2606 OID 20884)
-- Name: official official_id_area_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.official
    ADD CONSTRAINT official_id_area_fkey FOREIGN KEY (id_area) REFERENCES business.area(id_area) NOT VALID;


--
-- TOC entry 3812 (class 2606 OID 20874)
-- Name: official official_id_company_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.official
    ADD CONSTRAINT official_id_company_fkey FOREIGN KEY (id_company) REFERENCES core.company(id_company) NOT VALID;


--
-- TOC entry 3815 (class 2606 OID 20889)
-- Name: official official_id_position_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.official
    ADD CONSTRAINT official_id_position_fkey FOREIGN KEY (id_position) REFERENCES business."position"(id_position) NOT VALID;


--
-- TOC entry 3813 (class 2606 OID 20879)
-- Name: official official_id_user_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.official
    ADD CONSTRAINT official_id_user_fkey FOREIGN KEY (id_user) REFERENCES core."user"(id_user) NOT VALID;


--
-- TOC entry 3868 (class 2606 OID 21154)
-- Name: plugin_item_column plugin_item_column_id_plugin_item_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.plugin_item_column
    ADD CONSTRAINT plugin_item_column_id_plugin_item_fkey FOREIGN KEY (id_plugin_item) REFERENCES business.plugin_item(id_plugin_item) NOT VALID;


--
-- TOC entry 3867 (class 2606 OID 21149)
-- Name: plugin_item plugin_item_id_company_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.plugin_item
    ADD CONSTRAINT plugin_item_id_company_fkey FOREIGN KEY (id_company) REFERENCES core.company(id_company) NOT VALID;


--
-- TOC entry 3817 (class 2606 OID 20899)
-- Name: position position_id_company_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business."position"
    ADD CONSTRAINT position_id_company_fkey FOREIGN KEY (id_company) REFERENCES core.company(id_company) NOT VALID;


--
-- TOC entry 3861 (class 2606 OID 21119)
-- Name: process_attached process_attached_id_attached_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process_attached
    ADD CONSTRAINT process_attached_id_attached_fkey FOREIGN KEY (id_attached) REFERENCES business.attached(id_attached) NOT VALID;


--
-- TOC entry 3860 (class 2606 OID 21114)
-- Name: process_attached process_attached_id_level_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process_attached
    ADD CONSTRAINT process_attached_id_level_fkey FOREIGN KEY (id_level) REFERENCES business.level(id_level) NOT VALID;


--
-- TOC entry 3857 (class 2606 OID 21099)
-- Name: process_attached process_attached_id_official_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process_attached
    ADD CONSTRAINT process_attached_id_official_fkey FOREIGN KEY (id_official) REFERENCES business.official(id_official) NOT VALID;


--
-- TOC entry 3858 (class 2606 OID 21104)
-- Name: process_attached process_attached_id_process_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process_attached
    ADD CONSTRAINT process_attached_id_process_fkey FOREIGN KEY (id_process) REFERENCES business.process(id_process) NOT VALID;


--
-- TOC entry 3859 (class 2606 OID 21109)
-- Name: process_attached process_attached_id_task_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process_attached
    ADD CONSTRAINT process_attached_id_task_fkey FOREIGN KEY (id_task) REFERENCES business.task(id_task) NOT VALID;


--
-- TOC entry 3856 (class 2606 OID 21094)
-- Name: process_comment process_comment_id_level_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process_comment
    ADD CONSTRAINT process_comment_id_level_fkey FOREIGN KEY (id_level) REFERENCES business.level(id_level) NOT VALID;


--
-- TOC entry 3853 (class 2606 OID 21079)
-- Name: process_comment process_comment_id_official_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process_comment
    ADD CONSTRAINT process_comment_id_official_fkey FOREIGN KEY (id_official) REFERENCES business.official(id_official) NOT VALID;


--
-- TOC entry 3854 (class 2606 OID 21084)
-- Name: process_comment process_comment_id_process_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process_comment
    ADD CONSTRAINT process_comment_id_process_fkey FOREIGN KEY (id_process) REFERENCES business.process(id_process) NOT VALID;


--
-- TOC entry 3855 (class 2606 OID 21089)
-- Name: process_comment process_comment_id_task_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process_comment
    ADD CONSTRAINT process_comment_id_task_fkey FOREIGN KEY (id_task) REFERENCES business.task(id_task) NOT VALID;


--
-- TOC entry 3866 (class 2606 OID 21144)
-- Name: process_control process_control_id_control_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process_control
    ADD CONSTRAINT process_control_id_control_fkey FOREIGN KEY (id_control) REFERENCES business.control(id_control) NOT VALID;


--
-- TOC entry 3865 (class 2606 OID 21139)
-- Name: process_control process_control_id_level_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process_control
    ADD CONSTRAINT process_control_id_level_fkey FOREIGN KEY (id_level) REFERENCES business.level(id_level) NOT VALID;


--
-- TOC entry 3862 (class 2606 OID 21124)
-- Name: process_control process_control_id_official_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process_control
    ADD CONSTRAINT process_control_id_official_fkey FOREIGN KEY (id_official) REFERENCES business.official(id_official) NOT VALID;


--
-- TOC entry 3863 (class 2606 OID 21129)
-- Name: process_control process_control_id_process_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process_control
    ADD CONSTRAINT process_control_id_process_fkey FOREIGN KEY (id_process) REFERENCES business.process(id_process) NOT VALID;


--
-- TOC entry 3864 (class 2606 OID 21134)
-- Name: process_control process_control_id_task_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process_control
    ADD CONSTRAINT process_control_id_task_fkey FOREIGN KEY (id_task) REFERENCES business.task(id_task) NOT VALID;


--
-- TOC entry 3822 (class 2606 OID 20924)
-- Name: process process_id_flow_version_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process
    ADD CONSTRAINT process_id_flow_version_fkey FOREIGN KEY (id_flow_version) REFERENCES business.flow_version(id_flow_version) NOT VALID;


--
-- TOC entry 3821 (class 2606 OID 20919)
-- Name: process process_id_official_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process
    ADD CONSTRAINT process_id_official_fkey FOREIGN KEY (id_official) REFERENCES business.official(id_official) NOT VALID;


--
-- TOC entry 3849 (class 2606 OID 21059)
-- Name: process_item process_item_id_item_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process_item
    ADD CONSTRAINT process_item_id_item_fkey FOREIGN KEY (id_item) REFERENCES business.item(id_item) NOT VALID;


--
-- TOC entry 3848 (class 2606 OID 21054)
-- Name: process_item process_item_id_level_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process_item
    ADD CONSTRAINT process_item_id_level_fkey FOREIGN KEY (id_level) REFERENCES business.level(id_level) NOT VALID;


--
-- TOC entry 3845 (class 2606 OID 21039)
-- Name: process_item process_item_id_official_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process_item
    ADD CONSTRAINT process_item_id_official_fkey FOREIGN KEY (id_official) REFERENCES business.official(id_official) NOT VALID;


--
-- TOC entry 3846 (class 2606 OID 21044)
-- Name: process_item process_item_id_process_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process_item
    ADD CONSTRAINT process_item_id_process_fkey FOREIGN KEY (id_process) REFERENCES business.process(id_process) NOT VALID;


--
-- TOC entry 3847 (class 2606 OID 21049)
-- Name: process_item process_item_id_task_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.process_item
    ADD CONSTRAINT process_item_id_task_fkey FOREIGN KEY (id_task) REFERENCES business.task(id_task) NOT VALID;


--
-- TOC entry 3852 (class 2606 OID 21074)
-- Name: task task_id_level_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.task
    ADD CONSTRAINT task_id_level_fkey FOREIGN KEY (id_level) REFERENCES business.level(id_level) NOT VALID;


--
-- TOC entry 3851 (class 2606 OID 21069)
-- Name: task task_id_official_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.task
    ADD CONSTRAINT task_id_official_fkey FOREIGN KEY (id_official) REFERENCES business.official(id_official) NOT VALID;


--
-- TOC entry 3850 (class 2606 OID 21064)
-- Name: task task_id_process_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.task
    ADD CONSTRAINT task_id_process_fkey FOREIGN KEY (id_process) REFERENCES business.process(id_process) NOT VALID;


--
-- TOC entry 3827 (class 2606 OID 20949)
-- Name: template_control template_control_id_control_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.template_control
    ADD CONSTRAINT template_control_id_control_fkey FOREIGN KEY (id_control) REFERENCES business.control(id_control) NOT VALID;


--
-- TOC entry 3828 (class 2606 OID 20954)
-- Name: template_control template_control_id_template_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.template_control
    ADD CONSTRAINT template_control_id_template_fkey FOREIGN KEY (id_template) REFERENCES business.template(id_template) NOT VALID;


--
-- TOC entry 3823 (class 2606 OID 20929)
-- Name: template template_id_company_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.template
    ADD CONSTRAINT template_id_company_fkey FOREIGN KEY (id_company) REFERENCES core.company(id_company) NOT VALID;


--
-- TOC entry 3824 (class 2606 OID 20934)
-- Name: template template_id_documentation_profile_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.template
    ADD CONSTRAINT template_id_documentation_profile_fkey FOREIGN KEY (id_documentation_profile) REFERENCES business.documentation_profile(id_documentation_profile) NOT VALID;


--
-- TOC entry 3825 (class 2606 OID 20939)
-- Name: template template_id_plugin_item_fkey; Type: FK CONSTRAINT; Schema: business; Owner: app_nashor
--

ALTER TABLE ONLY business.template
    ADD CONSTRAINT template_id_plugin_item_fkey FOREIGN KEY (id_plugin_item) REFERENCES business.plugin_item(id_plugin_item) NOT VALID;


--
-- TOC entry 3797 (class 2606 OID 20799)
-- Name: company company_id_setting_fkey; Type: FK CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core.company
    ADD CONSTRAINT company_id_setting_fkey FOREIGN KEY (id_setting) REFERENCES core.setting(id_setting) NOT VALID;


--
-- TOC entry 3798 (class 2606 OID 20804)
-- Name: navigation navigation_id_company_fkey; Type: FK CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core.navigation
    ADD CONSTRAINT navigation_id_company_fkey FOREIGN KEY (id_company) REFERENCES core.company(id_company) NOT VALID;


--
-- TOC entry 3800 (class 2606 OID 20814)
-- Name: person person_id_academic_fkey; Type: FK CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core.person
    ADD CONSTRAINT person_id_academic_fkey FOREIGN KEY (id_academic) REFERENCES core.academic(id_academic) NOT VALID;


--
-- TOC entry 3799 (class 2606 OID 20809)
-- Name: person person_id_job_fkey; Type: FK CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core.person
    ADD CONSTRAINT person_id_job_fkey FOREIGN KEY (id_job) REFERENCES core.job(id_job) NOT VALID;


--
-- TOC entry 3801 (class 2606 OID 20819)
-- Name: profile profile_id_company_fkey; Type: FK CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core.profile
    ADD CONSTRAINT profile_id_company_fkey FOREIGN KEY (id_company) REFERENCES core.company(id_company) NOT VALID;


--
-- TOC entry 3803 (class 2606 OID 20829)
-- Name: profile_navigation profile_navigation_id_navigation_fkey; Type: FK CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core.profile_navigation
    ADD CONSTRAINT profile_navigation_id_navigation_fkey FOREIGN KEY (id_navigation) REFERENCES core.navigation(id_navigation) NOT VALID;


--
-- TOC entry 3802 (class 2606 OID 20824)
-- Name: profile_navigation profile_navigation_id_profile_fkey; Type: FK CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core.profile_navigation
    ADD CONSTRAINT profile_navigation_id_profile_fkey FOREIGN KEY (id_profile) REFERENCES core.profile(id_profile) NOT VALID;


--
-- TOC entry 3808 (class 2606 OID 20854)
-- Name: session session_id_user_fkey; Type: FK CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core.session
    ADD CONSTRAINT session_id_user_fkey FOREIGN KEY (id_user) REFERENCES core."user"(id_user) NOT VALID;


--
-- TOC entry 3811 (class 2606 OID 20869)
-- Name: system_event system_event_id_user_fkey; Type: FK CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core.system_event
    ADD CONSTRAINT system_event_id_user_fkey FOREIGN KEY (id_user) REFERENCES core."user"(id_user) NOT VALID;


--
-- TOC entry 3809 (class 2606 OID 20859)
-- Name: type_user type_user_id_company_fkey; Type: FK CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core.type_user
    ADD CONSTRAINT type_user_id_company_fkey FOREIGN KEY (id_company) REFERENCES core.company(id_company) NOT VALID;


--
-- TOC entry 3810 (class 2606 OID 20864)
-- Name: type_user type_user_id_profile_fkey; Type: FK CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core.type_user
    ADD CONSTRAINT type_user_id_profile_fkey FOREIGN KEY (id_profile) REFERENCES core.profile(id_profile) NOT VALID;


--
-- TOC entry 3804 (class 2606 OID 20834)
-- Name: user user_id_company_fkey; Type: FK CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core."user"
    ADD CONSTRAINT user_id_company_fkey FOREIGN KEY (id_company) REFERENCES core.company(id_company) NOT VALID;


--
-- TOC entry 3805 (class 2606 OID 20839)
-- Name: user user_id_person_fkey; Type: FK CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core."user"
    ADD CONSTRAINT user_id_person_fkey FOREIGN KEY (id_person) REFERENCES core.person(id_person) NOT VALID;


--
-- TOC entry 3806 (class 2606 OID 20844)
-- Name: user user_id_type_user_fkey; Type: FK CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core."user"
    ADD CONSTRAINT user_id_type_user_fkey FOREIGN KEY (id_type_user) REFERENCES core.type_user(id_type_user) NOT VALID;


--
-- TOC entry 3807 (class 2606 OID 20849)
-- Name: validation validation_id_company_fkey; Type: FK CONSTRAINT; Schema: core; Owner: app_nashor
--

ALTER TABLE ONLY core.validation
    ADD CONSTRAINT validation_id_company_fkey FOREIGN KEY (id_company) REFERENCES core.company(id_company) NOT VALID;


-- Completed on 2023-05-23 21:58:02

--
-- PostgreSQL database dump complete
--

