import { clientANGELPostgreSQL } from '../utils/conections';

export const utils_table_exists = (scheme: string, entity: string) => {
	return new Promise<any>(async (resolve, reject) => {
		const query = `select dev.utils_table_exists('${scheme}', '${entity}') as count`;

		// console.log(query);

		try {
			const response = await clientANGELPostgreSQL.query(query);
			resolve(response.rows[0].count);
		} catch (error: any) {
			reject(error.toString());
		}
	});
};

export const utils_get_columns_backend = (scheme: string, entity: string) => {
	return new Promise<any>(async (resolve, reject) => {
		const query = `select * from dev.utils_get_columns_backend('${scheme}', '${entity}')`;

		// console.log(query);

		try {
			const response = await clientANGELPostgreSQL.query(query);
			resolve(response.rows);
		} catch (error: any) {
			reject(error.toString());
		}
	});
};

export const utils_get_alias = (scheme: string, entity: string) => {
	return new Promise<string>(async (resolve, reject) => {
		const query = `select * from dev.utils_get_alias('${scheme}', '${entity}')`;

		try {
			const response = await clientANGELPostgreSQL.query(query);
			resolve(response.rows[0].utils_get_alias);
		} catch (error: any) {
			reject(error.toString());
		}
	});
};

export const ddl_create_crud_modified = (
	scheme: string,
	entity: string,
	exclude_column_in_external_table: string[]
) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const exclude_column_string: string = utils_get_exclude_column_string(
			exclude_column_in_external_table
		);

		const query = `select * from dev.ddl_create_crud_modified('${scheme}', '${entity}', array[${
			exclude_column_string != '' ? exclude_column_string : "''"
		}])`;

		// console.log(query);

		try {
			const response = await clientANGELPostgreSQL.query(query);
			resolve(response.rows[0].ddl_create_crud_modified);
		} catch (error: any) {
			reject(error.toString());
		}
	});
};

export const ddl_create_view_inner_table = (
	scheme: string,
	entity: string,
	exclude_column_in_external_table: string[]
) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const exclude_column_string: string = utils_get_exclude_column_string(
			exclude_column_in_external_table
		);

		const query = `select * from dev.ddl_create_view_inner_table('${scheme}', '${entity}', array[${
			exclude_column_string != '' ? exclude_column_string : "''"
		}])`;

		// console.log(query);

		try {
			const response = await clientANGELPostgreSQL.query(query);
			resolve(response.rows[0].ddl_create_view_inner_table);
		} catch (error: any) {
			reject(error.toString());
		}
	});
};

export const utils_get_exclude_column_string = (
	exclude_column_in_external_table: string[]
): string => {
	let string: string = '';
	exclude_column_in_external_table.map((item: string) => {
		string += `'${item}',`;
	});
	return string.substring(0, string.length - 1);
};

export const utils_get_schema = (entity: string) => {
	return new Promise<string>(async (resolve, reject) => {
		const query = `select * from dev.utils_get_schema('${entity}')`;

		try {
			const response = await clientANGELPostgreSQL.query(query);
			resolve(response.rows[0].utils_get_schema);
		} catch (error: any) {
			reject(error.toString());
		}
	});
};
