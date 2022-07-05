------------------------------ README ------------------------------
-- Estas son funciones experimentales, las cuales se han desarrollado para que funcionen de manera general
-- Para que no tenga poblemas al momento de ejecutarlas, se tiene que seguir la siguiente normalizacion
-- Para el nombrado de las entidades se debe usar snake_case (LOWER)
-- Las llaves primarias tienen que nombrarse de la siguiente manera ejem: tabla user - PK - id_user
-- Las llaves primarias tienen que ocupara la primera posicion ordinal en la tabla que se encuentran.
-- Si la tabla tiene llaves primarias compuestas no hay problema ya que esta implementacion no toma en cuenta estos casos

-- Definición de las funciones para crear vistas, secuencias, funciones CRUD

------------------------------ UTILS ------------------------------
-- FUNCTION: dev.utils_limit_number(numeric)
-- DROP FUNCTION IF EXISTS dev.utils_limit_number(numeric);

CREATE OR REPLACE FUNCTION dev.utils_limit_number(
	digitos numeric)
    RETURNS numeric
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_NUMBER_CHARACTER TEXT DEFAULT '';
	_X RECORD;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	FOR _X IN 1..digitos LOOP
		_NUMBER_CHARACTER = ''||_NUMBER_CHARACTER||'9';
    END LOOP;
	return _NUMBER_CHARACTER::numeric;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'utils_limit_number -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION dev.utils_limit_number(numeric)
    OWNER TO postgres;

-- FUNCTION: dev.utils_get_alias(character varying, character varying)
-- DROP FUNCTION IF EXISTS dev.utils_get_alias(character varying, character varying);

CREATE OR REPLACE FUNCTION dev.utils_get_alias(
	_schema character varying,
	_table_name character varying)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_ALIAS_SCHEME CHARACTER VARYING;
	_ALIAS_TABLE CHARACTER VARYING;
	_ALIAS CHARACTER VARYING;
	_LETTER CHARACTER VARYING;
	_NEXT_LETTER CHARACTER VARYING;
	_X RECORD;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	FOR _X IN 1..(char_length(_table_name)) LOOP
		_LETTER = (select substring(_table_name from _X for 1));
		_NEXT_LETTER = (select substring(_table_name from _X + 1 for 1));
		IF (_X = 1) THEN
			_ALIAS_TABLE = _LETTER;
		END IF;
		IF (_LETTER = '_') THEN
			_ALIAS_TABLE = ''||_ALIAS_TABLE||''||_NEXT_LETTER||'';
		END IF;
	END LOOP;
	_ALIAS_SCHEME = (select substring(_schema from 1 for 1));
	_ALIAS = ''||_ALIAS_SCHEME||'v'||_ALIAS_TABLE||'';
	return _ALIAS;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'utils_get_alias -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION dev.utils_get_alias(character varying, character varying)
    OWNER TO postgres;

-- FUNCTION: dev.utils_get_schema(character varying)
-- DROP FUNCTION IF EXISTS dev.utils_get_schema(character varying);

CREATE OR REPLACE FUNCTION dev.utils_get_schema(
	_table character varying)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_SCHEMA CHARACTER VARYING;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_SCHEMA = ((select iet.table_schema from information_schema.tables iet where iet.table_name = _table)::character varying);
	RETURN _SCHEMA; 
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'utils_get_schema -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;      
END;
$BODY$;

ALTER FUNCTION dev.utils_get_schema(character varying)
    OWNER TO postgres;

-- FUNCTION: dev.utils_get_columns(character varying, character varying)
-- DROP FUNCTION dev.utils_get_columns(character varying, character varying);

CREATE OR REPLACE FUNCTION dev.utils_get_columns(
	_schema character varying,
	_table_name character varying)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_COLUMNS CHARACTER VARYING DEFAULT '';
	_X RECORD;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	FOR _X IN EXECUTE 'SELECT iec.column_name FROM information_schema.columns iec WHERE iec.table_schema = '''||_schema||''' and iec.table_name = '''||_table_name||''' order by iec.ordinal_position asc'  LOOP
		_COLUMNS = ''||_COLUMNS||' '||_X.column_name||',';
	END LOOP;
	return (select substring(_COLUMNS from 2 for (char_length(_COLUMNS)-2)));
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'utils_get_columns -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION dev.utils_get_columns(character varying, character varying)
    OWNER TO postgres;

-- FUNCTION: dev.utils_get_columns_alias(character varying, character varying)
-- DROP FUNCTION IF EXISTS dev.utils_get_columns_alias(character varying, character varying);

CREATE OR REPLACE FUNCTION dev.utils_get_columns_alias(
	_schema character varying,
	_table_name character varying)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_COLUMNS_ALIAS CHARACTER VARYING DEFAULT '';
	_ALIAS CHARACTER VARYING;
	_X RECORD;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ALIAS = (select * from dev.utils_get_alias(_schema, _table_name));
	FOR _X IN EXECUTE 'SELECT iec.column_name FROM information_schema.columns iec WHERE iec.table_schema = '''||_schema||''' and iec.table_name = '''||_table_name||''' order by iec.ordinal_position asc'  LOOP
		_COLUMNS_ALIAS = ''||_COLUMNS_ALIAS||' '||_ALIAS||'.'||_X.column_name||',';
	END LOOP;
	return (select substring(_COLUMNS_ALIAS from 2 for (char_length(_COLUMNS_ALIAS)-2)));
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'utils_get_columns_alias -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION dev.utils_get_columns_alias(character varying, character varying)
    OWNER TO postgres;

-- FUNCTION: dev.utils_get_columns_alias_exclude_id_and_deleted(character varying, character varying, character varying[])
-- DROP FUNCTION IF EXISTS dev.utils_get_columns_alias_exclude_id_and_deleted(character varying, character varying, character varying[]);

CREATE OR REPLACE FUNCTION dev.utils_get_columns_alias_exclude_id_and_deleted(
	_schema character varying,
	_table_name character varying,
	_exclude_column_in_external_table character varying[])
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_COLUMNS_ALIAS CHARACTER VARYING DEFAULT '';
	_ALIAS CHARACTER VARYING;
	_X RECORD;
	_VALUE_EXCLUDE CHARACTER VARYING;
	_IS_EXCLUDE BOOLEAN DEFAULT FALSE;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_ALIAS = (select * from dev.utils_get_alias(_schema, _table_name));
	FOR _X IN EXECUTE 'SELECT iec.column_name FROM information_schema.columns iec WHERE iec.table_schema = '''||_schema||''' and iec.table_name = '''||_table_name||''' order by iec.ordinal_position asc'  LOOP
		FOREACH _VALUE_EXCLUDE IN ARRAY _exclude_column_in_external_table LOOP
			IF (_X.column_name = _VALUE_EXCLUDE) THEN
				_IS_EXCLUDE = TRUE;
			END IF;
		END LOOP;
			
		IF (_X.column_name != 'id_'||_table_name||'' and _X.column_name != 'deleted_'||_table_name||'' and NOT _IS_EXCLUDE) THEN
			_COLUMNS_ALIAS = ''||_COLUMNS_ALIAS||' '||_ALIAS||'.'||_X.column_name||',';
		END IF;
		_IS_EXCLUDE = FALSE;
	END LOOP;
	return (select substring(_COLUMNS_ALIAS from 2 for (char_length(_COLUMNS_ALIAS)-2)));
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'utils_get_columns_alias_exclude_id_and_deleted -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION dev.utils_get_columns_alias_exclude_id_and_deleted(character varying, character varying, character varying[])
    OWNER TO postgres;

-- FUNCTION: dev.utils_get_columns_type(character varying, character varying)
-- DROP FUNCTION IF EXISTS dev.utils_get_columns_type(character varying, character varying);

CREATE OR REPLACE FUNCTION dev.utils_get_columns_type(
	_schema character varying,
	_table_name character varying)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_COLUMNS_TYPE CHARACTER VARYING DEFAULT '';
	_X RECORD;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	FOR _X IN EXECUTE 'SELECT iec.column_name, iec.data_type, iec.udt_name, iec.udt_schema FROM information_schema.columns iec WHERE iec.table_schema = '''||_schema||''' and iec.table_name = '''||_table_name||''' order by iec.ordinal_position asc'  LOOP
		IF (_X.data_type = 'USER-DEFINED') THEN
			_COLUMNS_TYPE = ''||_COLUMNS_TYPE||' '||_X.column_name||' '||_X.udt_schema||'."'||_X.udt_name||'",';
		ELSE
			_COLUMNS_TYPE = ''||_COLUMNS_TYPE||' '||_X.column_name||' '||_X.data_type||',';
		END IF;
	END LOOP;
	return (select substring(_COLUMNS_TYPE from 2 for (char_length(_COLUMNS_TYPE)-2)));
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'utils_get_columns_type -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION dev.utils_get_columns_type(character varying, character varying)
    OWNER TO postgres;

-- FUNCTION: dev.utils_get_columns_type_exclude_id_and_deleted(character varying, character varying, character varying[])
-- DROP FUNCTION IF EXISTS dev.utils_get_columns_type_exclude_id_and_deleted(character varying, character varying, character varying[]);

CREATE OR REPLACE FUNCTION dev.utils_get_columns_type_exclude_id_and_deleted(
	_schema character varying,
	_table_name character varying,
	_exclude_column_in_external_table character varying[])
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_COLUMNS_TYPE CHARACTER VARYING DEFAULT '';
	_X RECORD;
	_VALUE_EXCLUDE CHARACTER VARYING;
	_IS_EXCLUDE BOOLEAN DEFAULT FALSE;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	FOR _X IN EXECUTE 'SELECT iec.column_name, iec.data_type, iec.udt_name, iec.udt_schema FROM information_schema.columns iec WHERE iec.table_schema = '''||_schema||''' and iec.table_name = '''||_table_name||''' order by iec.ordinal_position asc'  LOOP
		IF (_X.data_type = 'USER-DEFINED') THEN		
			FOREACH _VALUE_EXCLUDE IN ARRAY _exclude_column_in_external_table LOOP
				IF (_X.column_name = _VALUE_EXCLUDE) THEN
					_IS_EXCLUDE = TRUE;
				END IF;
			END LOOP;
			
			IF (NOT _IS_EXCLUDE) THEN
				_COLUMNS_TYPE = ''||_COLUMNS_TYPE||' '||_X.column_name||' '||_X.udt_schema||'."'||_X.udt_name||'",';
			END IF;
			_IS_EXCLUDE = FALSE;
		ELSE
			FOREACH _VALUE_EXCLUDE IN ARRAY _exclude_column_in_external_table LOOP
				IF (_X.column_name = _VALUE_EXCLUDE) THEN
					_IS_EXCLUDE = TRUE;
				END IF;
			END LOOP;
			
			IF (_X.column_name != 'id_'||_table_name||'' and _X.column_name != 'deleted_'||_table_name||'' and NOT _IS_EXCLUDE) THEN
				_COLUMNS_TYPE = ''||_COLUMNS_TYPE||' '||_X.column_name||' '||_X.data_type||',';
			END IF;
			_IS_EXCLUDE = FALSE;
		END IF;
	END LOOP;
	return (select substring(_COLUMNS_TYPE from 2 for (char_length(_COLUMNS_TYPE)-2)));
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'utils_get_columns_type_exclude_id_and_deleted -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION dev.utils_get_columns_type_exclude_id_and_deleted(character varying, character varying, character varying[])
    OWNER TO postgres;

-- FUNCTION: dev.utils_get_columns_backend(character varying, character varying)
-- DROP FUNCTION IF EXISTS dev.utils_get_columns_backend(character varying, character varying);

CREATE OR REPLACE FUNCTION dev.utils_get_columns_backend(
	_schema character varying,
	_table_name character varying)
    RETURNS TABLE(column_name_ character varying, column_type_ character varying, length_character_ numeric, lenght_numeric_ numeric, column_udt_name_ character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	RETURN QUERY SELECT cast(iec.column_name as character varying), cast(iec.data_type as character varying), cast(iec.character_maximum_length as numeric), cast(iec.numeric_precision as numeric), cast(iec.udt_name as character varying) FROM information_schema.columns iec WHERE iec.table_schema = ''||_schema||'' and iec.table_name = ''||_table_name||'' order by iec.ordinal_position asc; 
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'utils_get_columns_backend -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION dev.utils_get_columns_backend(character varying, character varying)
    OWNER TO postgres;

-- FUNCTION: dev.utils_get_columns_function(character varying, character varying, character varying[])
-- DROP FUNCTION IF EXISTS dev.utils_get_columns_function(character varying, character varying, character varying[]);

CREATE OR REPLACE FUNCTION dev.utils_get_columns_function(
	_schema character varying,
	_table character varying,
	_exclude_column_in_external_table character varying[])
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_TABLE_EXISTS NUMERIC;
	_COLUMNS_FUNCTION CHARACTER VARYING;
	_COLUMN_NAME CHARACTER VARYING;
	_COLUMN_ID CHARACTER VARYING;
	_COLUMN_ENTITY CHARACTER VARYING;
	_SCHEME_ENTITY CHARACTER VARYING;
	_COLUMNS_FUNCTION_EXTERNAL CHARACTER VARYING;
	_X RECORD;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_TABLE_EXISTS = (select * from dev.utils_table_exists(_schema, _table));
	
	IF (_TABLE_EXISTS >= 1) THEN
		_COLUMNS_FUNCTION = (select * from dev.utils_get_columns_type(_schema, _table));
	
		FOR _X IN select * from dev.utils_get_columns_backend(_schema, _table) LOOP
			_COLUMN_NAME = _X.column_name_;
			_COLUMN_ID = (select substring(_COLUMN_NAME from 0 for 4));
			_COLUMN_ENTITY = (select substring(_COLUMN_NAME from 4 for (char_length(_COLUMN_NAME))));

			IF (_COLUMN_ID = 'id_' and _COLUMN_ENTITY != _table ) THEN
				_SCHEME_ENTITY = (select * from dev.utils_get_schema(_COLUMN_ENTITY));
				
				_COLUMNS_FUNCTION_EXTERNAL = (select * from dev.utils_get_columns_type_exclude_id_and_deleted(_SCHEME_ENTITY, _COLUMN_ENTITY, _exclude_column_in_external_table));
				_COLUMNS_FUNCTION = ''||_COLUMNS_FUNCTION||', '||_COLUMNS_FUNCTION_EXTERNAL||'';
			END IF;
		END LOOP;
		RETURN _COLUMNS_FUNCTION;
	ELSE
		_EXCEPTION = '_schema | _table is incorrect';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'utils_get_columns_function -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION dev.utils_get_columns_function(character varying, character varying, character varying[])
    OWNER TO postgres;

-- FUNCTION: dev.utils_get_param_delete(character varying, character varying)
-- DROP FUNCTION dev.utils_get_param_delete(character varying, character varying);

CREATE OR REPLACE FUNCTION dev.utils_get_param_delete(
	_schema character varying,
	_table_name character varying)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_PARAM_DELETE CHARACTER VARYING DEFAULT '';
	_X RECORD;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	FOR _X IN EXECUTE 'SELECT iec.column_name, iec.data_type FROM information_schema.columns iec WHERE iec.table_schema = '''||_schema||''' and iec.table_name = '''||_table_name||''' and iec.ordinal_position = 1'  LOOP
		_PARAM_DELETE = ''||_PARAM_DELETE||' _'||_X.column_name||' '||_X.data_type||',';
    END LOOP;
	return (select substring(_PARAM_DELETE from 2 for (char_length(_PARAM_DELETE)-2)));
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'utils_get_param_delete -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION dev.utils_get_param_delete(character varying, character varying)
    OWNER TO postgres;

-- FUNCTION: dev.utils_get_params(character varying, character varying)
-- DROP FUNCTION dev.utils_get_params(character varying, character varying);

CREATE OR REPLACE FUNCTION dev.utils_get_params(
	_schema character varying,
	_table_name character varying)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_PARAMS CHARACTER VARYING DEFAULT '';
	_X RECORD;	
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
     FOR _X IN EXECUTE 'SELECT iec.column_name, iec.data_type, iec.udt_name FROM information_schema.columns iec WHERE iec.table_schema = '''||_schema||''' and iec.table_name = '''||_table_name||''' order by iec.ordinal_position asc'  LOOP
		IF (_X.data_type = 'USER-DEFINED') THEN
			_PARAMS = ''||_PARAMS||' _'||_X.column_name||' '||_schema||'."'||_X.udt_name||'",';
		ELSE
			_PARAMS = ''||_PARAMS||' _'||_X.column_name||' '||_X.data_type||',';
		END IF;
    END LOOP;
	return (select substring(_PARAMS from 2 for (char_length(_PARAMS)-2)));
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'utils_get_params -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION dev.utils_get_params(character varying, character varying)
    OWNER TO postgres;

-- FUNCTION: dev.utils_get_params_exclude_id(character varying, character varying)
-- DROP FUNCTION dev.utils_get_params_exclude_id(character varying, character varying);

CREATE OR REPLACE FUNCTION dev.utils_get_params_exclude_id(
	_schema character varying,
	_table_name character varying)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_PARAMS CHARACTER VARYING DEFAULT '';
	_X RECORD;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
    FOR _X IN EXECUTE 'SELECT iec.column_name, iec.data_type, iec.udt_name FROM information_schema.columns iec WHERE iec.table_schema = '''||_schema||''' and iec.table_name = '''||_table_name||''' and iec.ordinal_position != 1 order by iec.ordinal_position asc'  LOOP
		IF (_X.data_type = 'USER-DEFINED') THEN
			_PARAMS = ''||_PARAMS||' _'||_X.column_name||' '||_schema||'."'||_X.udt_name||'",';
		ELSE
			_PARAMS = ''||_PARAMS||' _'||_X.column_name||' '||_X.data_type||',';
		END IF;
    END LOOP;
	return (select substring(_PARAMS from 2 for (char_length(_PARAMS)-2)));
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'utils_get_params_exclude_id -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION dev.utils_get_params_exclude_id(character varying, character varying)
    OWNER TO postgres;

-- FUNCTION: dev.utils_get_params_execute_function(character varying, character varying)
-- DROP FUNCTION IF EXISTS dev.utils_get_params_execute_function(character varying, character varying);

CREATE OR REPLACE FUNCTION dev.utils_get_params_execute_function(
	_schema character varying,
	_table_name character varying)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_PARAMS CHARACTER VARYING DEFAULT '';
	_X RECORD;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
    FOR _X IN EXECUTE 'SELECT iec.column_name, iec.data_type, iec.udt_name FROM information_schema.columns iec WHERE iec.table_schema = '''||_schema||''' and iec.table_name = '''||_table_name||''' and iec.ordinal_position != 1 order by iec.ordinal_position asc'  LOOP
		_PARAMS = ''||_PARAMS||' _'||_X.column_name||',';
    END LOOP;
	return (select substring(_PARAMS from 2 for (char_length(_PARAMS)-2)));
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'utils_get_params_execute_function -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION dev.utils_get_params_execute_function(character varying, character varying)
    OWNER TO postgres;

-- FUNCTION: dev.utils_get_query_update(character varying, character varying)
-- DROP FUNCTION dev.utils_get_query_update(character varying, character varying);

CREATE OR REPLACE FUNCTION dev.utils_get_query_update(
	_schema character varying,
	_table_name character varying)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_QUERY_TO_UPDATE CHARACTER VARYING DEFAULT '';
	_ID_TABLE CHARACTER VARYING DEFAULT '';
	_RESULT_QUERY CHARACTER VARYING DEFAULT '';
	_X RECORD;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
    FOR _X IN EXECUTE 'SELECT iec.column_name, iec.ordinal_position FROM information_schema.columns iec WHERE iec.table_schema = '''||_schema||''' and iec.table_name = '''||_table_name||''' order by iec.ordinal_position asc'  LOOP
		IF (_X.ordinal_position != 1) THEN 
			_QUERY_TO_UPDATE = ''||_QUERY_TO_UPDATE||' '||_X.column_name||'=$'||(_X.ordinal_position)+1||',';
		END IF;
		IF (_X.ordinal_position = 1) THEN 
			_ID_TABLE = ''||_ID_TABLE||' '||_X.column_name||'=$'||(_X.ordinal_position)+1||',';
		END IF;
    END LOOP;

	_QUERY_TO_UPDATE = (select substring(_QUERY_TO_UPDATE from 2 for (char_length(_QUERY_TO_UPDATE)-2)));
	_ID_TABLE = (select substring(_ID_TABLE from 2 for (char_length(_ID_TABLE)-2)));

	RETURN 'SET '||_QUERY_TO_UPDATE||' WHERE '||_ID_TABLE||'';
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'utils_get_query_update -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION dev.utils_get_query_update(character varying, character varying)
    OWNER TO postgres;

-- FUNCTION: dev.utils_get_values_insert(character varying, character varying, numeric)
-- DROP FUNCTION dev.utils_get_values_insert(character varying, character varying, numeric);

CREATE OR REPLACE FUNCTION dev.utils_get_values_insert(
	_schema character varying,
	_table_name character varying,
	_increment numeric)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_VALUES_INSERT CHARACTER VARYING DEFAULT '';
	_X RECORD;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	FOR _X IN EXECUTE 'SELECT iec.ordinal_position FROM information_schema.columns iec WHERE iec.table_schema = '''||_schema||''' and iec.table_name = '''||_table_name||''' and iec.ordinal_position != 1 order by iec.ordinal_position asc'  LOOP
		_VALUES_INSERT = ''||_VALUES_INSERT||'$'||(_X.ordinal_position)- _increment||' ,';
    END LOOP;
	return (select substring(_VALUES_INSERT from 1 for (char_length(_VALUES_INSERT)-2)));
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'utils_get_values_insert -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION dev.utils_get_values_insert(character varying, character varying, numeric)
    OWNER TO postgres;

-- FUNCTION: dev.utils_table_exists(character varying, character varying)
-- DROP FUNCTION dev.utils_table_exists(character varying, character varying);

CREATE OR REPLACE FUNCTION dev.utils_table_exists(
	_schema character varying,
	_table_name character varying)
    RETURNS numeric
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	return (SELECT count(*) FROM information_schema.tables iet WHERE iet.table_type = 'BASE TABLE' and iet.table_schema = ''||_schema||'' and iet.table_name = ''||_table_name||'');
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'utils_table_exists -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION dev.utils_table_exists(character varying, character varying)
    OWNER TO postgres;

-- FUNCTION: core.utils_get_table_dependency(character varying, character varying, numeric)
-- DROP FUNCTION IF EXISTS core.utils_get_table_dependency(character varying, character varying, numeric);

CREATE OR REPLACE FUNCTION core.utils_get_table_dependency(
	_schema character varying,
	_table_name character varying,
	_id_deleted numeric)
    RETURNS numeric
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
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
$BODY$;

ALTER FUNCTION core.utils_get_table_dependency(character varying, character varying, numeric)
    OWNER TO postgres;

-- FUNCTION: dev.utils_generate_external_id_validation(character varying, character varying)
-- DROP FUNCTION IF EXISTS dev.utils_generate_external_id_validation(character varying, character varying);

CREATE OR REPLACE FUNCTION dev.utils_generate_external_id_validation(
	_schema character varying,
	_table_name character varying)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_ID CHARACTER VARYING;
	_NAME_TABLE CHARACTER VARYING;
	_SCHEMA_TABLE CHARACTER VARYING;
	_EXTERNAL_ID_VALIDATION CHARACTER VARYING DEFAULT '';
	_X RECORD;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	FOR _X IN EXECUTE 'SELECT iec.column_name, iec.data_type FROM information_schema.columns iec WHERE iec.table_schema = '''||_schema||''' and iec.table_name = '''||_table_name||''' order by iec.ordinal_position asc'  LOOP
		_ID = (select substring(_X.column_name from 1 for 3));
		_NAME_TABLE = (select substring(_X.column_name from 4 for (char_length(_X.column_name))));
		_SCHEMA_TABLE = (SELECT iet.table_schema FROM information_schema.tables iet WHERE iet.table_name = _NAME_TABLE);
			
		IF ((select substring(_X.column_name from 1 for 3)) = 'id_' and (select substring(_X.column_name from 4 for (char_length(_X.column_name)))) != _table_name) THEN
			_EXTERNAL_ID_VALIDATION = ''||_EXTERNAL_ID_VALIDATION||' 
	-- '||_NAME_TABLE||'
	_COUNT_EXTERNALS_IDS = (select count(*) from '||_SCHEMA_TABLE||'.view_'||_NAME_TABLE||' v where v.id_'||_NAME_TABLE||' = _id_'||_NAME_TABLE||');
		
	IF (_COUNT_EXTERNALS_IDS = 0) THEN
		_EXCEPTION = ''''El id ''''||_id_'||_NAME_TABLE||'||'''' de la tabla '||_NAME_TABLE||' no se encuentra registrado'''';
		RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
	END IF;
			';
		END IF;
	END LOOP;
	return _EXTERNAL_ID_VALIDATION;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'utils_generate_external_id_validation -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION dev.utils_generate_external_id_validation(character varying, character varying)
    OWNER TO postgres;

------------------------------ Funciones DDL ------------------------------
-- FUNCTION: dev.ddl_config(character varying)
-- DROP FUNCTION dev.ddl_config(character varying);

CREATE OR REPLACE FUNCTION dev.ddl_config(
	_schema character varying)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_X RECORD;
	_COLUMN_NAME CHARACTER VARYING DEFAULT '';
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	
	EXECUTE 'DROP TABLE IF EXISTS dev.ddl_config';
	
	EXECUTE '
	CREATE TABLE dev.ddl_config
	(
	  table_name character varying(100),
	  sequence boolean,
	  view boolean,
	  crud boolean,
	  haved_handler_attribute character varying(100)
	)
	WITH (
	  OIDS=FALSE
	);
	ALTER TABLE dev.ddl_config
	  OWNER TO postgres;
	';
  
	FOR _X IN (select iet.table_name from information_schema.tables iet where iet.table_schema = ''||_SCHEMA||'' and iet.table_type = 'BASE TABLE') LOOP
		_COLUMN_NAME = (select iec.column_name from information_schema.columns iec where iec.table_schema = ''||_SCHEMA||'' and iec.table_name = ''||_X.table_name||'' and iec.ordinal_position = 1);
		IF (_COLUMN_NAME = 'id_'||_X.table_name||'') THEN
			INSERT INTO dev.ddl_config(table_name, sequence, view, crud, haved_handler_attribute) VALUES (_X.table_name, true, true, true, 'id_'||_X.table_name||'');
		END IF;
	END LOOP;
	RETURN true;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'ddl_config -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION dev.ddl_config(character varying)
    OWNER TO postgres;

-- FUNCTION: dev.ddl_create_crud(character varying, character varying, character varying)
-- DROP FUNCTION dev.ddl_create_crud(character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION dev.ddl_create_crud(
	_schema character varying,
	_table_name character varying,
	_duplicate_handler_attribute character varying)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_PARAMS CHARACTER VARYING DEFAULT '';
	_PARAMS_EXCLUDE_ID CHARACTER VARYING DEFAULT '';
	_PARAM_DELETE CHARACTER VARYING DEFAULT '';
	_VALUES_INSERT CHARACTER VARYING DEFAULT '';
	_VALUES_INSERT_PLUS CHARACTER VARYING DEFAULT '';
	_QUERY_UPDATE CHARACTER VARYING DEFAULT '';
	_COLUMNS CHARACTER VARYING DEFAULT '';
	_COLUMNS_ALIAS CHARACTER VARYING DEFAULT '';
	_COLUMNS_TYPE CHARACTER VARYING DEFAULT '';
	_EXTERNAL_ID_VALIDATION CHARACTER VARYING DEFAULT '';
	_EXTERNAL_ID_VALIDATION_ATTRIBUTE CHARACTER VARYING DEFAULT '';
	_HAVED_COLUMN_DELETED CHARACTER VARYING DEFAULT '';
	_HAVED_HANDLER_ATTRIBUTE NUMERIC;
	_ATTRIBUTE_TO_QUERY CHARACTER VARYING DEFAULT '';
	_SERIAL_TABLE CHARACTER VARYING DEFAULT '';
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_PARAMS = (select dev.utils_get_params(_schema,_table_name));
	_PARAMS_EXCLUDE_ID = (select dev.utils_get_params_exclude_id(_schema,_table_name));
	_PARAM_DELETE = (select dev.utils_get_param_delete(_schema,_table_name));
	_VALUES_INSERT = (select dev.utils_get_values_insert(_schema,_table_name, 1));
	_VALUES_INSERT_PLUS = (select dev.utils_get_values_insert(_schema,_table_name, 0));
	_QUERY_UPDATE = (select dev.utils_get_query_update(_schema,_table_name));
	_COLUMNS = (select dev.utils_get_columns(_schema,_table_name));
	_COLUMNS_ALIAS = (select dev.utils_get_columns_alias(_schema,_table_name));
	_COLUMNS_TYPE = (select dev.utils_get_columns_type(_schema,_table_name));
	_EXTERNAL_ID_VALIDATION = (select * from dev.utils_generate_external_id_validation(_schema,_table_name));
	
	IF (_EXTERNAL_ID_VALIDATION != '') THEN 
		_EXTERNAL_ID_VALIDATION_ATTRIBUTE = '
	_COUNT_EXTERNALS_IDS NUMERIC;';
	END IF;

	_SERIAL_TABLE = ''||_schema||'.serial_'||_table_name||'';
	
	_HAVED_COLUMN_DELETED = (select (select iec.column_name as column from information_schema.columns iec where iec.table_schema = ''||_schema||'' and iec.table_name = ''||_table_name||'' and iec.column_name = 'deleted_'||_table_name||'')::character varying);
	
	-- Verificar si el _duplicate_handler_attribute existe en la tabla ingresada
	_HAVED_HANDLER_ATTRIBUTE = (select count(*) from information_schema.columns iec where iec.table_schema = ''||_schema||'' and iec.table_name = ''||_table_name||'' and iec.column_name = ''||_duplicate_handler_attribute||'');

	IF (_HAVED_HANDLER_ATTRIBUTE = 0) THEN 
		_EXCEPTION = 'El atributo '||_duplicate_handler_attribute||' no existe en la tabla '||_table_name||'';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	
	-- COMPARAR SI LA TABLE ES EVENTOS DEL SISTEMA --
	
	IF (_table_name = 'system_event') THEN
		--CREATE
		EXECUTE '
			CREATE OR REPLACE FUNCTION '||_schema||'.dml_'||_table_name||'_create('||_PARAMS_EXCLUDE_ID||')
			RETURNS boolean AS
			''
DECLARE
	_RESPONSE BOOLEAN DEFAULT false;
	_COUNT NUMERIC;
	_RETURNING NUMERIC;
	_CURRENT_ID NUMERIC;
	_X RECORD;
	_EXCEPTION CHARACTER VARYING DEFAULT ''''Internal Error'''';
BEGIN
	_CURRENT_ID = (select nextval('''''||_SERIAL_TABLE||''''')-1);
	_COUNT = (select count(*) from '||_schema||'.view_'||_table_name||' t where t.id_'||_table_name||' = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		FOR _X IN INSERT INTO '||_schema||'.'||_table_name||'('||_COLUMNS||') VALUES (_CURRENT_ID, '||_VALUES_INSERT||') RETURNING id_'||_table_name||' LOOP
			_RETURNING = _X.id_'||_table_name||';
		END LOOP;
		
		IF (_RETURNING >= 1) THEN
			RETURN true;
		ELSE
			_EXCEPTION = ''''Ocurrió un error al insertar el registro'''';
			RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
		END IF;
	ELSE 
		_EXCEPTION = ''''El registro con id ''''||_CURRENT_ID||'''' ya se encuentra registrado en la tabla '||_table_name||''''';
		RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
	END IF;
	exception when others then 
		-- RAISE NOTICE ''''%'''', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE ''''select setval('''''''''||_SERIAL_TABLE||''''''''', ''''||_CURRENT_ID||'''')'''';
		END IF;
		IF (_EXCEPTION = ''''Internal Error'''') THEN
			RAISE EXCEPTION ''''%'''', ''''dml_'||_table_name||'_create -> ''''||SQLERRM||'''''''' USING DETAIL = ''''_database'''';
		ELSE
			RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
		END IF;
END;''
			LANGUAGE plpgsql VOLATILE
			COST 100;
			';
	ELSE
		IF (_HAVED_COLUMN_DELETED = 'deleted_'||_table_name||'') THEN
			--CREATE
			IF (_duplicate_handler_attribute = 'id_'||_table_name||'') THEN
				_ATTRIBUTE_TO_QUERY = '_CURRENT_ID';
			ELSE
				_ATTRIBUTE_TO_QUERY = '_'||_duplicate_handler_attribute||'';
			END IF;
		
        EXECUTE '
			CREATE OR REPLACE FUNCTION '||_schema||'.dml_'||_table_name||'_create(id_user_ numeric,'||_PARAMS_EXCLUDE_ID||')
			RETURNS NUMERIC AS
			''
DECLARE
	_RESPONSE BOOLEAN DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_ATT NUMERIC;'||_EXTERNAL_ID_VALIDATION_ATTRIBUTE||'
	_RETURNING NUMERIC;
	_CURRENT_ID NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT ''''Internal Error'''';
BEGIN'||_EXTERNAL_ID_VALIDATION||'
	_CURRENT_ID = (select nextval('''''||_SERIAL_TABLE||''''')-1);
	_COUNT = (select count(*) from '||_schema||'.view_'||_table_name||' t where t.id_'||_table_name||' = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		_COUNT_ATT = (select count(*) from '||_schema||'.view_'||_table_name||' t where t.'||_duplicate_handler_attribute||' = '||_ATTRIBUTE_TO_QUERY||');
	
		IF (_COUNT_ATT = 0) THEN 
			FOR _X IN INSERT INTO '||_schema||'.'||_table_name||'('||_COLUMNS||') VALUES (_CURRENT_ID, '||_VALUES_INSERT_PLUS||') RETURNING id_'||_table_name||' LOOP
				_RETURNING = _X.id_'||_table_name||';
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'''''||_table_name||''''',_CURRENT_ID,''''CREATE'''', now()::timestamp, false));
					
					IF (_RESPONSE != true) THEN
						_EXCEPTION = ''''Ocurrió un error al registrar el evento del sistema'''';
						RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
					ELSE
						RETURN _CURRENT_ID;
					END IF;
				ELSE 
					RETURN _CURRENT_ID;
				END IF;
			ELSE
				_EXCEPTION = ''''Ocurrió un error al insertar el registro'''';
				RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
			END IF;
		ELSE
			_EXCEPTION = ''''Ya existe un registro con el '||_duplicate_handler_attribute||' ''''||_'||_duplicate_handler_attribute||'||'''''''';
			RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
		END IF;
	ELSE
		_EXCEPTION = ''''El registro con id ''''||_CURRENT_ID||'''' ya se encuentra registrado en la tabla '||_table_name||''''';
		RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
	END IF;
	exception when others then 
		-- RAISE NOTICE ''''%'''', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE ''''select setval('''''''''||_SERIAL_TABLE||''''''''', ''''||_CURRENT_ID||'''')'''';
		END IF;
		IF (_EXCEPTION = ''''Internal Error'''') THEN
			RAISE EXCEPTION ''''%'''', ''''dml_'||_table_name||'_create -> ''''||SQLERRM||'''''''' USING DETAIL = ''''_database'''';
		ELSE
			RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
		END IF;
END;''
			LANGUAGE plpgsql VOLATILE
			COST 100;
			';

        --UPDATE
        EXECUTE '
			CREATE OR REPLACE FUNCTION '||_schema||'.dml_'||_table_name||'_update(id_user_ numeric,'||_PARAMS||')
			RETURNS boolean AS
			''
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_ATT NUMERIC;
	_COUNT_DELETED NUMERIC;'||_EXTERNAL_ID_VALIDATION_ATTRIBUTE||'
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT ''''Internal Error'''';
BEGIN'||_EXTERNAL_ID_VALIDATION||'
	_COUNT = (select count(*) from '||_schema||'.view_'||_table_name||' t where t.id_'||_table_name||' = _id_'||_table_name||');
	
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from '||_schema||'.view_'||_table_name||' t where t.id_'||_table_name||' = _id_'||_table_name||' and deleted_'||_table_name||' = true); 
		IF (_COUNT_DELETED = 0) THEN
			_COUNT_ATT = (select count(*) from '||_schema||'.view_'||_table_name||' t where t.'||_duplicate_handler_attribute||' = _'||_duplicate_handler_attribute||' and t.id_'||_table_name||' != _id_'||_table_name||');
			
			IF (_COUNT_ATT = 0) THEN 
				FOR _X IN UPDATE '||_schema||'.'||_TABLE_NAME||' '||_QUERY_UPDATE||' RETURNING id_'||_table_name||' LOOP
					_RETURNING = _X.id_'||_table_name||';
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'''''||_table_name||''''',_id_'||_table_name||',''''UPDATE'''', now()::timestamp, false));
						
						IF (_RESPONSE != true) THEN
							_EXCEPTION = ''''Ocurrió un error al registrar el evento del sistema'''';
							RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
						ELSE
							RETURN _RESPONSE;
						END IF;
					ELSE
						RETURN true;
					END IF;
				ELSE
					_EXCEPTION = ''''Ocurrió un error al actualizar el registro'''';
					RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
				END IF;
			ELSE
				_EXCEPTION = ''''Ya existe un registro con el '||_duplicate_handler_attribute||' ''''||_'||_duplicate_handler_attribute||'||'''''''';
				RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
			END IF;
		ELSE 
			_EXCEPTION = ''''EL registro se encuentra eliminado'''';
			RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
		END IF;
	ELSE
		_EXCEPTION = ''''El registro con id ''''||_id_'||_table_name||'||'''' no se encuentra registrado en la tabla '||_table_name||''''';
		RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
	END IF;
	exception when others then 
		-- RAISE NOTICE ''''%'''', SQLERRM;
		IF (_EXCEPTION = ''''Internal Error'''') THEN
			RAISE EXCEPTION ''''%'''', ''''dml_'||_table_name||'_update -> ''''||SQLERRM||'''''''' USING DETAIL = ''''_database'''';
		ELSE
			RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
		END IF;
END;''
			LANGUAGE plpgsql VOLATILE
			COST 100
			';

		--DELETE
        EXECUTE '
			CREATE OR REPLACE FUNCTION '||_schema||'.dml_'||_table_name||'_delete(id_user_ numeric,'||_PARAM_DELETE||')
			RETURNS boolean AS
			''
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DELETED NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT ''''Internal Error'''';
BEGIN
 	_COUNT = (select count(*) from '||_schema||'.view_'||_table_name||' t where t.id_'||_table_name||' = _id_'||_table_name||');
		
	IF (_COUNT = 1) THEN
		_COUNT_DELETED = (select count(*) from '||_schema||'.view_'||_table_name||' t where t.id_'||_table_name||' = _id_'||_table_name||' and deleted_'||_table_name||' = true); 
		
		IF (_COUNT_DELETED = 0) THEN 
			_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('''''||_schema||''''','''''||_table_name||''''', _id_'||_table_name||'));
			
			IF (_COUNT_DEPENDENCY > 0) THEN
				_EXCEPTION = ''''No se puede eliminar el registro, mantiene dependencia en otros procesos.'''';
				RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
			ELSE
				FOR _X IN UPDATE '||_schema||'.'||_TABLE_NAME||' SET deleted_'||_TABLE_NAME||'=true WHERE id_'||_TABLE_NAME||' = _id_'||_table_name||' RETURNING id_'||_table_name||' LOOP
					_RETURNING = _X.id_'||_table_name||';
				END LOOP;
				
				IF (_RETURNING >= 1) THEN
					_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
						where cvuij.id_user = id_user_);

					IF (_SAVE_LOG) THEN
						_RESPONSE = (select * from core.dml_system_event_create(id_user_,'''''||_table_name||''''',_id_'||_table_name||',''''DELETE'''', now()::timestamp, false));
						
						IF (_RESPONSE != true) THEN
							_EXCEPTION = ''''Ocurrió un error al registrar el evento del sistema'''';
							RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
						ELSE
							RETURN _RESPONSE;
						END IF;
					ELSE
						RETURN true;
					END IF;
				ELSE
					_EXCEPTION = ''''Ocurrió un error al eliminar el registro'''';
					RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
				END IF;
			END IF;
		ELSE
			_EXCEPTION = ''''EL registro ya se encuentra eliminado'''';
			RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
		END IF;
	ELSE
		_EXCEPTION = ''''El registro con id ''''||_id_'||_table_name||'||'''' no se encuentra registrado en la tabla '||_table_name||''''';
		RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
	END IF;
	exception when others then 
		-- RAISE NOTICE ''''%'''', SQLERRM;
		IF (_EXCEPTION = ''''Internal Error'''') THEN
			RAISE EXCEPTION ''''%'''', ''''dml_'||_table_name||'_delete -> ''''||SQLERRM||'''''''' USING DETAIL = ''''_database'''';
		ELSE
			RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
		END IF;
END;''
			LANGUAGE plpgsql VOLATILE
			COST 100
			';
		ELSE 
		--CREATE
        EXECUTE '
			CREATE OR REPLACE FUNCTION '||_schema||'.dml_'||_table_name||'_create(id_user_ numeric,'||_PARAMS_EXCLUDE_ID||')
			RETURNS NUMERIC AS
			''
DECLARE
	_RESPONSE BOOLEAN DEFAULT false;
	_COUNT NUMERIC;'||_EXTERNAL_ID_VALIDATION_ATTRIBUTE||'
	_RETURNING NUMERIC;
	_CURRENT_ID NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT ''''Internal Error'''';
BEGIN'||_EXTERNAL_ID_VALIDATION||'
	_CURRENT_ID = (select nextval('''''||_SERIAL_TABLE||''''')-1);
	_COUNT = (select count(*) from '||_schema||'.view_'||_table_name||' t where t.id_'||_table_name||' = _CURRENT_ID);
	
	IF (_COUNT = 0) THEN
		FOR _X IN INSERT INTO '||_schema||'.'||_table_name||'('||_COLUMNS||') VALUES (_CURRENT_ID, '||_VALUES_INSERT_PLUS||') RETURNING id_'||_table_name||' LOOP
			_RETURNING = _X.id_'||_table_name||';
		END LOOP;
		
		IF (_RETURNING >= 1) THEN
			_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
				where cvuij.id_user = id_user_);
			
			IF (_SAVE_LOG) THEN
				_RESPONSE = (select * from core.dml_system_event_create(id_user_,'''''||_table_name||''''',_CURRENT_ID,''''CREATE'''', now()::timestamp, false));
				
				IF (_RESPONSE != true) THEN
					_EXCEPTION = ''''Ocurrió un error al registrar el evento del sistema'''';
					RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
				ELSE
					RETURN _CURRENT_ID;
				END IF;
			ELSE 
				RETURN _CURRENT_ID;
			END IF;
		ELSE
			_EXCEPTION = ''''Ocurrió un error al insertar el registro'''';
			RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
		END IF;
	ELSE
		_EXCEPTION = ''''El registro con id ''''||_CURRENT_ID||'''' ya se encuentra registrado en la tabla '||_table_name||''''';
		RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
	END IF;
	exception when others then 
		-- RAISE NOTICE ''''%'''', SQLERRM;
		IF (_CURRENT_ID >= 1) THEN
			EXECUTE ''''select setval('''''''''||_SERIAL_TABLE||''''''''', ''''||_CURRENT_ID||'''')'''';
		END IF;
		IF (_EXCEPTION = ''''Internal Error'''') THEN
			RAISE EXCEPTION ''''%'''', ''''dml_'||_table_name||'_create -> ''''||SQLERRM||'''''''' USING DETAIL = ''''_database'''';
		ELSE
			RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
		END IF;
END;''
			LANGUAGE plpgsql VOLATILE
			COST 100;
			';
        --UPDATE
        EXECUTE '
			CREATE OR REPLACE FUNCTION '||_schema||'.dml_'||_table_name||'_update(id_user_ numeric,'||_PARAMS||')
			RETURNS boolean AS
			''
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;'||_EXTERNAL_ID_VALIDATION_ATTRIBUTE||'
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT ''''Internal Error'''';
BEGIN'||_EXTERNAL_ID_VALIDATION||'
 	_COUNT = (select count(*) from '||_schema||'.view_'||_table_name||' t where t.id_'||_table_name||' = _id_'||_table_name||');

	IF (_COUNT = 1) THEN
		FOR _X IN UPDATE '||_schema||'.'||_TABLE_NAME||' '||_QUERY_UPDATE||' RETURNING id_'||_table_name||' LOOP
			_RETURNING = _X.id_'||_table_name||';
		END LOOP;
			
		IF (_RETURNING >= 1) THEN
			_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
				where cvuij.id_user = id_user_);

			IF (_SAVE_LOG) THEN
				_RESPONSE = (select * from core.dml_system_event_create(id_user_,'''''||_table_name||''''',_id_'||_table_name||',''''UPDATE'''', now()::timestamp, false));
				
				IF (_RESPONSE != true) THEN
					_EXCEPTION = ''''Ocurrió un error al registrar el evento del sistema'''';
					RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
				ELSE
					RETURN _RESPONSE;
				END IF;
			ELSE
				RETURN true;
			END IF;
		ELSE
			_EXCEPTION = ''''Ocurrió un error al actualizar el registro'''';
			RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
		END IF;
	ELSE
		_EXCEPTION = ''''El registro con id ''''||_id_'||_table_name||'||'''' no se encuentra registrado en la tabla '||_table_name||''''';
		RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
	END IF;
	exception when others then 
		-- RAISE NOTICE ''''%'''', SQLERRM;
		IF (_EXCEPTION = ''''Internal Error'''') THEN
			RAISE EXCEPTION ''''%'''', ''''dml_'||_table_name||'_update -> ''''||SQLERRM||'''''''' USING DETAIL = ''''_database'''';
		ELSE
			RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
		END IF;
END;''
			LANGUAGE plpgsql VOLATILE
			COST 100
			';
		--DELETE
        EXECUTE '
			CREATE OR REPLACE FUNCTION '||_schema||'.dml_'||_table_name||'_delete(id_user_ numeric,'||_PARAM_DELETE||')
			RETURNS boolean AS
			''
DECLARE
	_RESPONSE boolean DEFAULT false;
	_COUNT NUMERIC;
	_COUNT_DEPENDENCY NUMERIC;
	_RETURNING NUMERIC;
	_X RECORD;
	_SAVE_LOG BOOLEAN DEFAULT false;
	_EXCEPTION CHARACTER VARYING DEFAULT ''''Internal Error'''';
BEGIN
 	_COUNT = (select count(*) from '||_schema||'.view_'||_table_name||' t where t.id_'||_table_name||' = _id_'||_table_name||');
		
	IF (_COUNT = 1) THEN
		_COUNT_DEPENDENCY = (select * from core.utils_get_table_dependency('''''||_schema||''''','''''||_table_name||''''', _id_'||_table_name||'));
			
		IF (_COUNT_DEPENDENCY > 0) THEN
			_EXCEPTION = ''''No se puede eliminar el registro, mantiene dependencia en otros procesos.'''';
			RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
		ELSE
			FOR _X IN DELETE FROM '||_schema||'.'||_TABLE_NAME||' WHERE id_'||_TABLE_NAME||' = _id_'||_table_name||' RETURNING id_'||_table_name||' LOOP
				_RETURNING = _X.id_'||_table_name||';
			END LOOP;
			
			IF (_RETURNING >= 1) THEN
				_SAVE_LOG = (select cvuij.save_log from core.view_user_inner_join_cvc_cvs cvuij
					where cvuij.id_user = id_user_);

				IF (_SAVE_LOG) THEN
					_RESPONSE = (select * from core.dml_system_event_create(id_user_,'''''||_table_name||''''',_id_'||_table_name||',''''DELETE'''', now()::timestamp, false));
					
					IF (_RESPONSE != true) THEN
						_EXCEPTION = ''''Ocurrió un error al registrar el evento del sistema'''';
						RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
					ELSE
						RETURN _RESPONSE;
					END IF;
				ELSE
					RETURN true;
				END IF;
			ELSE
				_EXCEPTION = ''''Ocurrió un error al eliminar el registro'''';
				RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
			END IF;
		END IF;
	ELSE
		_EXCEPTION = ''''El registro con id ''''||_id_'||_table_name||'||'''' no se encuentra registrado en la tabla '||_table_name||''''';
		RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
	END IF;
	exception when others then 
		-- RAISE NOTICE ''''%'''', SQLERRM;
		IF (_EXCEPTION = ''''Internal Error'''') THEN
			RAISE EXCEPTION ''''%'''', ''''dml_'||_table_name||'_delete -> ''''||SQLERRM||'''''''' USING DETAIL = ''''_database'''';
		ELSE
			RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
		END IF;
END;''
			LANGUAGE plpgsql VOLATILE
			COST 100
			';
		END IF;
	END IF;
	RETURN true; 
	exception when others then 
		-- -- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'ddl_create_crud -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	
END;
$BODY$;

ALTER FUNCTION dev.ddl_create_crud(character varying, character varying, character varying)
    OWNER TO postgres;

-- FUNCTION: dev.ddl_create_crud_modified(character varying, character varying, character varying[])
-- DROP FUNCTION IF EXISTS dev.ddl_create_crud_modified(character varying, character varying, character varying[]);

CREATE OR REPLACE FUNCTION dev.ddl_create_crud_modified(
	_schema character varying,
	_table_name character varying,
	_exclude_column_in_external_table character varying[])
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_PARAMS CHARACTER VARYING DEFAULT '';
	_PARAM_DELETE CHARACTER VARYING DEFAULT '';
	_COLUMNS_TYPE CHARACTER VARYING DEFAULT '';
	_ALIAS CHARACTER VARYING;
	_PARAMS_EXCLUDE_ID CHARACTER VARYING;
	_PARAMS_EXECUTE_FUNCTION CHARACTER VARYING;
	_SERIAL_TABLE CHARACTER VARYING DEFAULT '';
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_PARAMS = (select dev.utils_get_params(_schema,_table_name));
	_PARAM_DELETE = (select dev.utils_get_param_delete(_schema,_table_name));
	_COLUMNS_TYPE = (select dev.utils_get_columns_function(_schema,_table_name,_exclude_column_in_external_table));
	_ALIAS = (select * from dev.utils_get_alias(_schema, _table_name));
	_PARAMS_EXCLUDE_ID = (select dev.utils_get_params_exclude_id(_schema,_table_name));
	_PARAMS_EXECUTE_FUNCTION = (select * from dev.utils_get_params_execute_function(_schema, _table_name));

	_SERIAL_TABLE = ''||_schema||'.serial_'||_table_name||'';
		--CREATE
		EXECUTE 'DROP FUNCTION IF EXISTS '||_schema||'.dml_'||_table_name||'_create_modified(id_user_ numeric)';
		
        EXECUTE '
			CREATE OR REPLACE FUNCTION '||_schema||'.dml_'||_table_name||'_create_modified(id_user_ numeric)
			RETURNS TABLE('||_COLUMNS_TYPE||') AS
			''
DECLARE
	_ID_'||UPPER(_table_name)||' NUMERIC;
	_EXCEPTION CHARACTER VARYING DEFAULT ''''Internal Error'''';
BEGIN
	_ID_'||UPPER(_table_name)||' = (select * from '||_schema||'.dml_'||_table_name||'_create(id_user_, '||_PARAMS_EXECUTE_FUNCTION||'));
	
	IF (_ID_'||UPPER(_table_name)||' >= 1) THEN
		RETURN QUERY select * from '||_schema||'.view_'||_table_name||'_inner_join '||_ALIAS||'ij 
			where '||_ALIAS||'ij.id_'||_table_name||' = _ID_'||UPPER(_table_name)||';
	ELSE
		_EXCEPTION = ''''Ocurrió un error al ingresar '||_table_name||''''';
		RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
	END IF;
	exception when others then 
		-- RAISE NOTICE ''''%'''', SQLERRM;
		IF (_EXCEPTION = ''''Internal Error'''') THEN
			RAISE EXCEPTION ''''%'''', ''''dml_'||_table_name||'_create_modified -> ''''||SQLERRM||'''''''' USING DETAIL = ''''_database'''';
		ELSE
			RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
		END IF;
END;''
			LANGUAGE plpgsql VOLATILE
			COST 100;
			';

		--UPDATE
		EXECUTE 'DROP FUNCTION IF EXISTS '||_schema||'.dml_'||_table_name||'_update_modified(id_user_ numeric,'||_PARAMS||')';
		
        EXECUTE '
			 CREATE OR REPLACE FUNCTION '||_schema||'.dml_'||_table_name||'_update_modified(id_user_ numeric,'||_PARAMS||')
			 RETURNS TABLE('||_COLUMNS_TYPE||') AS
			 ''
DECLARE
 	_UPDATE_'||UPPER(_table_name)||' BOOLEAN;
	_EXCEPTION CHARACTER VARYING DEFAULT ''''Internal Error'''';
BEGIN
 	_UPDATE_'||UPPER(_table_name)||' = (select * from '||_schema||'.dml_'||_table_name||'_update(id_user_, _id_'||_table_name||', '||_PARAMS_EXECUTE_FUNCTION||'));

 	IF (_UPDATE_'||UPPER(_table_name)||') THEN
		RETURN QUERY select * from '||_schema||'.view_'||_table_name||'_inner_join '||_ALIAS||'ij 
			where '||_ALIAS||'ij.id_'||_table_name||' = _id_'||_table_name||';
	ELSE
		_EXCEPTION = ''''Ocurrió un error al actualizar '||_table_name||''''';
		RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
	END IF;
	exception when others then 
		-- RAISE NOTICE ''''%'''', SQLERRM;
		IF (_EXCEPTION = ''''Internal Error'''') THEN
			RAISE EXCEPTION ''''%'''', ''''dml_'||_table_name||'_update_modified -> ''''||SQLERRM||'''''''' USING DETAIL = ''''_database'''';
		ELSE
			RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
		END IF;
END;''
			LANGUAGE plpgsql VOLATILE
			COST 100
			';
		--DELETE
		EXECUTE 'DROP FUNCTION IF EXISTS '||_schema||'.dml_'||_table_name||'_delete_modified(id_user_ numeric,'||_PARAM_DELETE||')';
		
        EXECUTE '
			CREATE OR REPLACE FUNCTION '||_schema||'.dml_'||_table_name||'_delete_modified(id_user_ numeric,'||_PARAM_DELETE||')
			RETURNS boolean AS
			''
DECLARE
	_EXCEPTION CHARACTER VARYING DEFAULT ''''Internal Error'''';
BEGIN
 	-- Obtener los ids de los registros que se eliminaran
	-- select * from dev.utils_get_columns_type('''''||_schema||''''', '''''''')
	
	-- Eliminar registros en cascada
	
	-- Retornar true
	exception when others then 
		-- RAISE NOTICE ''''%'''', SQLERRM;
		IF (_EXCEPTION = ''''Internal Error'''') THEN
			RAISE EXCEPTION ''''%'''', ''''dml_'||_table_name||'_delete_modified -> ''''||SQLERRM||'''''''' USING DETAIL = ''''_database'''';
		ELSE
			RAISE EXCEPTION ''''%'''',_EXCEPTION USING DETAIL = ''''_database'''';
		END IF;
END;''
			LANGUAGE plpgsql VOLATILE
			COST 100
			';
	RETURN true; 
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'ddl_create_crud_modified -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
	
END;
$BODY$;

ALTER FUNCTION dev.ddl_create_crud_modified(character varying, character varying, character varying[])
    OWNER TO postgres;

-- FUNCTION: dev.ddl_create_sequences(character varying)
-- DROP FUNCTION dev.ddl_create_sequences(character varying);

CREATE OR REPLACE FUNCTION dev.ddl_create_sequences(
	_schema character varying)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_LIMIT_NUMBER NUMERIC;
	_IS_TRUE BOOLEAN DEFAULT false;
	_X RECORD;
	_Y RECORD;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	FOR _X IN (select iet.table_name from information_schema.tables iet where iet.table_schema = ''||_SCHEMA||'' and iet.table_type = 'BASE TABLE') LOOP
		_IS_TRUE = (select dc.sequence from dev.ddl_config dc where dc.table_name = ''||_X.table_name||'');
				
		IF (_IS_TRUE) THEN
			FOR _Y IN EXECUTE 'SELECT iec.numeric_precision as logitud_identificador FROM information_schema.columns iec WHERE table_name = '''||_X.table_name||''' and iec.ordinal_position = 1' LOOP
				_LIMIT_NUMBER = (select dev.utils_limit_number(_Y.logitud_identificador));
			END LOOP;
			EXECUTE 'CREATE SEQUENCE IF NOT EXISTS '||_SCHEMA||'.serial_'||_X.table_name||' INCREMENT 1 MINVALUE  1 MAXVALUE '||_LIMIT_NUMBER||' START 1 CACHE 1';
		END IF;
	END LOOP;
	RETURN true;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'ddl_create_sequences -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION dev.ddl_create_sequences(character varying)
    OWNER TO postgres;

-- FUNCTION: dev.ddl_create_view(character varying)
-- DROP FUNCTION IF EXISTS dev.ddl_create_view(character varying);

CREATE OR REPLACE FUNCTION dev.ddl_create_view(
	_schema character varying)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_IS_TRUE BOOLEAN DEFAULT false;
	_HAVED_COLUMN_DELETED CHARACTER VARYING DEFAULT '';
	_X RECORD;
	_Y RECORD;
	_ALIAS_TABLE CHARACTER VARYING;
	_TABLE_NAME CHARACTER VARYING;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN	
	FOR _X IN (select iet.table_name from information_schema.tables iet where iet.table_schema = ''||_SCHEMA||'' and iet.table_type = 'BASE TABLE') LOOP
		_TABLE_NAME = _X.table_name;
		_IS_TRUE = (select dc.view from dev.ddl_config dc where dc.table_name = ''||_TABLE_NAME||'');

		RAISE NOTICE '%', _TABLE_NAME;

		IF (_IS_TRUE) THEN
			_HAVED_COLUMN_DELETED = (select (SELECT iec.column_name as column from information_schema.columns iec where iec.table_schema = ''||_SCHEMA||'' and iec.table_name = ''||_TABLE_NAME||'' and iec.column_name = 'deleted_'||_TABLE_NAME||'')::character varying);

			_ALIAS_TABLE = (select * from dev.utils_get_alias(_schema, _TABLE_NAME));

			IF (_HAVED_COLUMN_DELETED = 'deleted_'||_TABLE_NAME||'') THEN
				EXECUTE 'CREATE OR REPLACE VIEW '||_SCHEMA||'.view_'||_TABLE_NAME||' AS SELECT * FROM '||_SCHEMA||'.'||_TABLE_NAME||' '||_ALIAS_TABLE||' WHERE '||_ALIAS_TABLE||'.deleted_'||_TABLE_NAME||' = false order by '||_ALIAS_TABLE||'.id_'||_TABLE_NAME||' desc';
			ELSE 
				EXECUTE 'CREATE OR REPLACE VIEW '||_SCHEMA||'.view_'||_TABLE_NAME||' AS SELECT * FROM '||_SCHEMA||'.'||_TABLE_NAME||' '||_ALIAS_TABLE||' order by '||_ALIAS_TABLE||'.id_'||_TABLE_NAME||' desc';
			END IF;
		END IF;
    END LOOP;
	RETURN true;   
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'ddl_create_view -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;     
END;
$BODY$;

ALTER FUNCTION dev.ddl_create_view(character varying)
    OWNER TO postgres;

-- FUNCTION: dev.ddl_create_view_inner_table(character varying, character varying, character varying[])
-- DROP FUNCTION IF EXISTS dev.ddl_create_view_inner_table(character varying, character varying, character varying[]);

CREATE OR REPLACE FUNCTION dev.ddl_create_view_inner_table(
	_schema character varying,
	_table character varying,
	_exclude_column_in_external_table character varying[])
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_HAVED_COLUMN_DELETED NUMERIC;
	_TABLE_EXISTS NUMERIC;
	_COLUMNS_VIEW CHARACTER VARYING;
	_COLUMNS_VIEW_EXTERNAL CHARACTER VARYING;
	_COLUMN_NAME CHARACTER VARYING;
	_COLUMN_ID CHARACTER VARYING;
	_COLUMN_ENTITY CHARACTER VARYING;
	_SCHEME_ENTITY CHARACTER VARYING;
	_INNER_JOIN CHARACTER VARYING DEFAULT '';
	_INNER_JOIN_EXTERNAL CHARACTER VARYING;
	_ALIAS_ENTITY CHARACTER VARYING;
	_ALIAS_TABLE CHARACTER VARYING;
	_QUERY_WITH_DELETE CHARACTER VARYING;
	_QUERY_WITHOUT_DELETE CHARACTER VARYING;
	_X RECORD;
	_Y RECORD;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	_TABLE_EXISTS = (select * from dev.utils_table_exists(_schema, _table));
	
	IF (_TABLE_EXISTS >= 1) THEN
		_COLUMNS_VIEW = (select * from dev.utils_get_columns_alias(_schema, _table));
		_ALIAS_ENTITY = (select * from dev.utils_get_alias(_schema, _table));
	
		FOR _X IN select * from dev.utils_get_columns_backend(_schema, _table) LOOP
			_COLUMN_NAME = _X.column_name_;
			_COLUMN_ID = (select substring(_COLUMN_NAME from 0 for 4));
			_COLUMN_ENTITY = (select substring(_COLUMN_NAME from 4 for (char_length(_COLUMN_NAME))));

			IF (_COLUMN_ID = 'id_' and _COLUMN_ENTITY != _table ) THEN
				_SCHEME_ENTITY = (select * from dev.utils_get_schema(_COLUMN_ENTITY));
				_COLUMNS_VIEW_EXTERNAL = (select * from dev.utils_get_columns_alias_exclude_id_and_deleted(_SCHEME_ENTITY, _COLUMN_ENTITY, _exclude_column_in_external_table));
				
				_ALIAS_TABLE = (select * from dev.utils_get_alias(_SCHEME_ENTITY, _COLUMN_ENTITY));
				
				_INNER_JOIN_EXTERNAL = '
	inner join '||_SCHEME_ENTITY||'.view_'||_COLUMN_ENTITY||' '||_ALIAS_TABLE||' on '||_ALIAS_ENTITY||'.id_'||_COLUMN_ENTITY||' = '||_ALIAS_TABLE||'.id_'||_COLUMN_ENTITY||'';

				_INNER_JOIN = ''||_INNER_JOIN||''||_INNER_JOIN_EXTERNAL||'';

				_COLUMNS_VIEW = ''||_COLUMNS_VIEW||', '||_COLUMNS_VIEW_EXTERNAL||'';
			END IF;
		END LOOP;

		_HAVED_COLUMN_DELETED = (select (select count(*) from information_schema.columns iec where iec.table_schema = ''||_schema||'' and iec.table_name = ''||_table||'' and iec.column_name = 'deleted_'||_table||'')::numeric);

		IF (_HAVED_COLUMN_DELETED >= 1) THEN
			_QUERY_WITH_DELETE = 'select '||_COLUMNS_VIEW||' from '||_schema||'.view_'||_table||' '||_ALIAS_ENTITY||' '||_INNER_JOIN||' 
	where '||_ALIAS_ENTITY||'.deleted_'||_table||' = false
	order by '||_ALIAS_ENTITY||'.id_'||_table||' desc;';

			EXECUTE 'DROP VIEW IF EXISTS '||_schema||'.view_'||_table||'_inner_join';
			EXECUTE 'CREATE OR REPLACE VIEW '||_schema||'.view_'||_table||'_inner_join AS '||_QUERY_WITH_DELETE||'';
		ELSE 
			_QUERY_WITHOUT_DELETE = 'select '||_COLUMNS_VIEW||' from '||_schema||'.view_'||_table||' '||_ALIAS_ENTITY||' '||_INNER_JOIN||'
	order by '||_ALIAS_ENTITY||'.id_'||_table||' desc;';
			
			EXECUTE 'DROP VIEW IF EXISTS '||_schema||'.view_'||_table||'_inner_join';
			EXECUTE 'CREATE OR REPLACE VIEW '||_schema||'.view_'||_table||'_inner_join AS '||_QUERY_WITHOUT_DELETE||'';
		END IF;
		RETURN true; 
	ELSE
		_EXCEPTION = '_schema | _table is incorrect';
		RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
	END IF;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'ddl_create_view_inner_table -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
	-- USE
	-- select * from dev.ddl_create_view_inner_table('core', 'type_user', array['id_company'])
$BODY$;

ALTER FUNCTION dev.ddl_create_view_inner_table(character varying, character varying, character varying[])
    OWNER TO postgres;

-- FUNCTION: dev.ddl_create_view_inner_table_all(character varying, character varying)
-- DROP FUNCTION IF EXISTS dev.ddl_create_view_inner_table_all(character varying, character varying);

CREATE OR REPLACE FUNCTION dev.ddl_create_view_inner_table_all(
	_schema character varying,
	_exclude_column_in_external_table character varying)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_TABLE CHARACTER VARYING;
	_RESPONSE BOOLEAN DEFAULT FALSE;
	_X RECORD;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	FOR _X IN (select iet.table_name from information_schema.tables iet where iet.table_schema = ''||_SCHEMA||'' and iet.table_type = 'BASE TABLE') LOOP
		_TABLE = _X.table_name;
		_RESPONSE = (select * from dev.ddl_create_view_inner_table(_schema, _TABLE, _exclude_column_in_external_table));
    END LOOP;
	RETURN _RESPONSE;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'ddl_create_view_inner_table_all -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;  
	-- select * from dev.ddl_create_view_inner_table_all('business', ARRAY['id_company','id_official'])      
END;
$BODY$;

ALTER FUNCTION dev.ddl_create_view_inner_table_all(character varying, character varying)
    OWNER TO postgres;

-- FUNCTION: dev.ddl_create_crud_all(character varying)
-- DROP FUNCTION dev.ddl_create_crud_all(character varying);

CREATE OR REPLACE FUNCTION dev.ddl_create_crud_all(
	_schema character varying)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_RESPONSE BOOLEAN DEFAULT false;
	_IS_TRUE BOOLEAN DEFAULT false;
	_HANDLER_ATTRIBUTE CHARACTER VARYING DEFAULT '';
	_X RECORD;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	FOR _X IN (select iet.table_name from information_schema.tables iet where iet.table_schema = ''||_SCHEMA||'' and iet.table_type = 'BASE TABLE') LOOP
		_IS_TRUE = (select dc.crud from dev.ddl_config dc where dc.table_name = ''||_X.table_name||'');
			
		IF (_IS_TRUE) THEN 
			_HANDLER_ATTRIBUTE = (select dc.haved_handler_attribute from dev.ddl_config dc where dc.table_name = ''||_X.table_name||'');
			_RESPONSE = (select dev.ddl_create_crud(_schema, ''||_X.table_name||'', ''||_HANDLER_ATTRIBUTE||''));
		END IF;
	END LOOP;
	RETURN _RESPONSE;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'ddl_create_crud_all -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION dev.ddl_create_crud_all(character varying)
    OWNER TO postgres;

------------------------------ FUNCIONES DML ------------------------------
-- FUNCTION: dev.dml_reset_sequences(character varying)
-- DROP FUNCTION dev.dml_reset_sequences(character varying);

CREATE OR REPLACE FUNCTION dev.dml_reset_sequences(
	_schema character varying)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_EXIST BOOLEAN DEFAULT false;
	_X RECORD;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
	FOR _X IN (select iet.table_name from information_schema.tables iet where iet.table_schema = ''||_SCHEMA||'') LOOP
		_EXIST = (select true from information_schema.sequences ies where ies.sequence_name = 'serial_'||_X.table_name||'');
		IF (_EXIST) THEN 
			EXECUTE 'SELECT setval('''||_SCHEMA||'.serial_'||_X.table_name||''', 1)';
		END IF;
	END LOOP;
    RETURN true; 
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_reset_sequences -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;       
END;
$BODY$;

ALTER FUNCTION dev.dml_reset_sequences(character varying)
    OWNER TO postgres;

-- FUNCTION: dev.dml_truncate_all(character varying)
-- DROP FUNCTION dev.dml_truncate_all(character varying);

CREATE OR REPLACE FUNCTION dev.dml_truncate_all(
	_schema character varying)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	_X RECORD;
	_EXCEPTION CHARACTER VARYING DEFAULT 'Internal Error';
BEGIN
    FOR _X IN (select iet.table_name from information_schema.tables iet where iet.table_schema = ''||_schema||'' and iet.table_type = 'BASE TABLE') LOOP
		EXECUTE 'TRUNCATE TABLE '||_schema||'.'||_X.table_name||' CASCADE';
    END LOOP;
    RETURN true;
	exception when others then 
		-- RAISE NOTICE '%', SQLERRM;
		IF (_EXCEPTION = 'Internal Error') THEN
			RAISE EXCEPTION '%', 'dml_truncate_all -> '||SQLERRM||'' USING DETAIL = '_database';
		ELSE
			RAISE EXCEPTION '%',_EXCEPTION USING DETAIL = '_database';
		END IF;
END;
$BODY$;

ALTER FUNCTION dev.dml_truncate_all(character varying)
    OWNER TO postgres;

------------------------------ CORE SCHEME ------------------------------
------------------------------ SECURITY CAP ------------------------------
-- ENABLED pgcrypto
CREATE EXTENSION IF NOT EXISTS pgcrypto SCHEMA core;

-- FUNCTION: core.global_encryption_password()
-- DROP FUNCTION core.global_encryption_password();

CREATE OR REPLACE FUNCTION core.global_encryption_password(
	)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	-- (OJO) LA CONTRASEÑA TIENE QUE SER DE 16 DIGITOS --
  	_PASSWORD CHARACTER VARYING DEFAULT 'eNcR$NaShOr$2022';
BEGIN
	RETURN _PASSWORD;
END;
$BODY$;

ALTER FUNCTION core.global_encryption_password()
    OWNER TO postgres;
-- FUNCTION: core.security_cap_string_invert(text)
-- DROP FUNCTION core.security_cap_string_invert(text);

CREATE OR REPLACE FUNCTION core.security_cap_string_invert(
	_string text)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
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
$BODY$;

ALTER FUNCTION core.security_cap_string_invert(text)
    OWNER TO postgres;

-- FUNCTION: core.security_cap_string_position_invert(text)
-- DROP FUNCTION core.security_cap_string_position_invert(text);

CREATE OR REPLACE FUNCTION core.security_cap_string_position_invert(
	_string text)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
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
$BODY$;

ALTER FUNCTION core.security_cap_string_position_invert(text)
    OWNER TO postgres;

-- FUNCTION: core.security_cap_encrypt(text)
-- DROP FUNCTION core.security_cap_encrypt(text);

CREATE OR REPLACE FUNCTION core.security_cap_algorithm_encrypt(
	_text text)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
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
$BODY$;

ALTER FUNCTION core.security_cap_algorithm_encrypt(text)
    OWNER TO postgres;

-- FUNCTION: core.security_cap_decrypt(text)
-- DROP FUNCTION core.security_cap_decrypt(text);

CREATE OR REPLACE FUNCTION core.security_cap_algorithm_decrypt(
	_string_position_invert text)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
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
$BODY$;

ALTER FUNCTION core.security_cap_algorithm_decrypt(text)
    OWNER TO postgres;

-- FUNCTION: core.security_cap_string_encrypt(text)
-- DROP FUNCTION core.security_cap_string_encrypt(text);

CREATE OR REPLACE FUNCTION core.security_cap_aes_encrypt(
	_text text)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
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
$BODY$;

ALTER FUNCTION core.security_cap_aes_encrypt(text)
    OWNER TO postgres;

-- FUNCTION: core.security_cap_string_decrypt(text)
-- DROP FUNCTION core.security_cap_string_decrypt(text);

CREATE OR REPLACE FUNCTION core.security_cap_aes_decrypt(
	_text_encrypted text)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
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
$BODY$;

ALTER FUNCTION core.security_cap_aes_decrypt(text)
    OWNER TO postgres;

-- FUNCTION: core.security_cap_aes_encrypt_object(json)
-- DROP FUNCTION IF EXISTS core.security_cap_aes_encrypt_object(json);

CREATE OR REPLACE FUNCTION core.security_cap_aes_encrypt_object(
	_object json)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
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
$BODY$;

ALTER FUNCTION core.security_cap_aes_encrypt_object(json)
    OWNER TO postgres;

-- FUNCTION: core.security_cap_aes_decrypt_object(text)
-- DROP FUNCTION IF EXISTS core.security_cap_aes_decrypt_object(text);

CREATE OR REPLACE FUNCTION core.security_cap_aes_decrypt_object(
	_text_encrypted text)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
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
$BODY$;

ALTER FUNCTION core.security_cap_aes_decrypt_object(text)
    OWNER TO postgres;
