import { clientANGELPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { LevelStatus } from './level_status.class';

export const dml_level_status_create = (level_status: LevelStatus) => {
	return new Promise<LevelStatus[]>(async (resolve, reject) => {
		const query = `select * from business.dml_level_status_create_modified(${level_status.id_user_},${level_status.company.id_company})`;

		// console.log(query);

		try {
			const response = await clientANGELPostgreSQL.query(query);
			resolve(response.rows);
		} catch (error: any) {
			if (error.detail == '_database') {
				reject({
					..._messages[3],
					description: error.toString().slice(7),
				});
			} else {
				reject(error.toString());
			}
		}
	});
};

export const view_level_status_query_read = (level_status: LevelStatus) => {
	return new Promise<LevelStatus[]>(async (resolve, reject) => {
		const query = `select * from business.view_level_status_inner_join bvlsij${
			level_status.name_level_status != '*'
				? ` where lower(bvlsij.name_level_status) LIKE '%${level_status.name_level_status}%'`
				: ``
		} order by bvlsij.id_level_status desc`;

		// console.log(query);

		try {
			const response = await clientANGELPostgreSQL.query(query);
			resolve(response.rows);
		} catch (error: any) {
			if (error.detail == '_database') {
				reject({
					..._messages[3],
					description: error.toString().slice(7),
				});
			} else {
				reject(error.toString());
			}
		}
	});
};

export const view_level_status_by_company_query_read = (
	level_status: LevelStatus
) => {
	return new Promise<LevelStatus[]>(async (resolve, reject) => {
		const query = `select * from business.view_level_status_inner_join bvlsij${
			level_status.name_level_status != '*'
				? ` where lower(bvlsij.name_level_status) LIKE '%${level_status.name_level_status}%' and bvlsij.id_company = ${level_status.company}`
				: ` where bvlsij.id_company = ${level_status.company}`
		} order by bvlsij.id_level_status desc`;

		// console.log(query);

		try {
			const response = await clientANGELPostgreSQL.query(query);
			resolve(response.rows);
		} catch (error: any) {
			if (error.detail == '_database') {
				reject({
					..._messages[3],
					description: error.toString().slice(7),
				});
			} else {
				reject(error.toString());
			}
		}
	});
};

export const view_level_status_specific_read = (level_status: LevelStatus) => {
	return new Promise<LevelStatus[]>(async (resolve, reject) => {
		const query = `select * from business.view_level_status_inner_join bvlsij where bvlsij.id_level_status = ${level_status.id_level_status}`;

		// console.log(query);

		try {
			const response = await clientANGELPostgreSQL.query(query);
			resolve(response.rows);
		} catch (error: any) {
			if (error.detail == '_database') {
				reject({
					..._messages[3],
					description: error.toString().slice(7),
				});
			} else {
				reject(error.toString());
			}
		}
	});
};

export const dml_level_status_update = (level_status: LevelStatus) => {
	return new Promise<LevelStatus[]>(async (resolve, reject) => {
		const query = `select * from business.dml_level_status_update_modified(${level_status.id_user_},
			${level_status.id_level_status},
			${level_status.company.id_company},
			'${level_status.name_level_status}',
			'${level_status.description_level_status}',
			'${level_status.color_level_status}',
			${level_status.deleted_level_status})`;

		// console.log(query);

		try {
			const response = await clientANGELPostgreSQL.query(query);
			resolve(response.rows);
		} catch (error: any) {
			if (error.detail == '_database') {
				reject({
					..._messages[3],
					description: error.toString().slice(7),
				});
			} else {
				reject(error.toString());
			}
		}
	});
};

export const dml_level_status_delete = (level_status: LevelStatus) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_level_status_delete(${level_status.id_user_},${level_status.id_level_status}) as result`;

		// console.log(query);

		try {
			const response = await clientANGELPostgreSQL.query(query);
			resolve(response.rows[0].result);
		} catch (error: any) {
			if (error.detail == '_database') {
				reject({
					..._messages[3],
					description: error.toString().slice(7),
				});
			} else {
				reject(error.toString());
			}
		}
	});
};
