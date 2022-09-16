import { clientNASHORPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { Level } from './level.class';

export const dml_level_create = (level: Level) => {
	return new Promise<Level[]>(async (resolve, reject) => {
		const query = `select * from business.dml_level_create_modified(${level.id_user_},${level.company.id_company},${level.template.id_template})`;

		// console.log(query);

		try {
			const response = await clientNASHORPostgreSQL.query(query);
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

export const view_level_query_read = (level: Level) => {
	return new Promise<Level[]>(async (resolve, reject) => {
		const query = `select * from business.view_level_inner_join bvlij${
			level.name_level != '*'
				? ` where lower(bvlij.name_level) LIKE '%${level.name_level}%'`
				: ``
		} order by bvlij.id_level desc`;

		// console.log(query);

		try {
			const response = await clientNASHORPostgreSQL.query(query);
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

export const view_level_by_company_query_read = (level: Level) => {
	return new Promise<Level[]>(async (resolve, reject) => {
		const query = `select * from business.view_level_inner_join bvlij${
			level.name_level != '*'
				? ` where lower(bvlij.name_level) LIKE '%${level.name_level}%' and bvlij.id_company = ${level.company}`
				: ` where bvlij.id_company = ${level.company}`
		} order by bvlij.id_level desc`;

		// console.log(query);

		try {
			const response = await clientNASHORPostgreSQL.query(query);
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

export const view_level_by_template_query_read = (level: Level) => {
	return new Promise<Level[]>(async (resolve, reject) => {
		const query = `select * from business.view_level_inner_join bvlij${
			level.name_level != '*'
				? ` where lower(bvlij.name_level) LIKE '%${level.name_level}%' and bvlij.id_template = ${level.template}`
				: ` where bvlij.id_template = ${level.template}`
		} order by bvlij.id_level desc`;

		// console.log(query);

		try {
			const response = await clientNASHORPostgreSQL.query(query);
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

export const view_level_by_level_profile_query_read = (level: Level) => {
	return new Promise<Level[]>(async (resolve, reject) => {
		const query = `select * from business.view_level_inner_join bvlij${
			level.name_level != '*'
				? ` where lower(bvlij.name_level) LIKE '%${level.name_level}%' and bvlij.id_level_profile = ${level.level_profile}`
				: ` where bvlij.id_level_profile = ${level.level_profile}`
		} order by bvlij.id_level desc`;

		// console.log(query);

		try {
			const response = await clientNASHORPostgreSQL.query(query);
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

export const view_level_by_level_status_query_read = (level: Level) => {
	return new Promise<Level[]>(async (resolve, reject) => {
		const query = `select * from business.view_level_inner_join bvlij${
			level.name_level != '*'
				? ` where lower(bvlij.name_level) LIKE '%${level.name_level}%' and bvlij.id_level_status = ${level.level_status}`
				: ` where bvlij.id_level_status = ${level.level_status}`
		} order by bvlij.id_level desc`;

		// console.log(query);

		try {
			const response = await clientNASHORPostgreSQL.query(query);
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

export const view_level_specific_read = (level: Level) => {
	return new Promise<Level[]>(async (resolve, reject) => {
		const query = `select * from business.view_level_inner_join bvlij where bvlij.id_level = ${level.id_level}`;

		// console.log(query);

		try {
			const response = await clientNASHORPostgreSQL.query(query);
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

export const dml_level_update = (level: Level) => {
	return new Promise<Level[]>(async (resolve, reject) => {
		const query = `select * from business.dml_level_update_modified(${level.id_user_},
			${level.id_level},
			${level.company.id_company},
			${level.template.id_template},
			${level.level_profile.id_level_profile},
			${level.level_status.id_level_status},
			'${level.name_level}',
			'${level.description_level}',
			${level.deleted_level})`;

		// console.log(query);

		try {
			const response = await clientNASHORPostgreSQL.query(query);
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

export const dml_level_delete = (level: Level) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_level_delete(${level.id_user_},${level.id_level}) as result`;

		// console.log(query);

		try {
			const response = await clientNASHORPostgreSQL.query(query);
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
