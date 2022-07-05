import { clientANGELPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { LevelProfile } from './level_profile.class';

export const dml_level_profile_create = (level_profile: LevelProfile) => {
	return new Promise<LevelProfile[]>(async (resolve, reject) => {
		const query = `select * from business.dml_level_profile_create_modified(${level_profile.id_user_},${level_profile.company.id_company})`;

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

export const view_level_profile_query_read = (level_profile: LevelProfile) => {
	return new Promise<LevelProfile[]>(async (resolve, reject) => {
		const query = `select * from business.view_level_profile_inner_join bvlpij${
			level_profile.name_level_profile != '*'
				? ` where lower(bvlpij.name_level_profile) LIKE '%${level_profile.name_level_profile}%'`
				: ``
		} order by bvlpij.id_level_profile desc`;

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

export const view_level_profile_by_company_query_read = (
	level_profile: LevelProfile
) => {
	return new Promise<LevelProfile[]>(async (resolve, reject) => {
		const query = `select * from business.view_level_profile_inner_join bvlpij${
			level_profile.name_level_profile != '*'
				? ` where lower(bvlpij.name_level_profile) LIKE '%${level_profile.name_level_profile}%' and bvlpij.id_company = ${level_profile.company}`
				: ` where bvlpij.id_company = ${level_profile.company}`
		} order by bvlpij.id_level_profile desc`;

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

export const view_level_profile_specific_read = (
	level_profile: LevelProfile
) => {
	return new Promise<LevelProfile[]>(async (resolve, reject) => {
		const query = `select * from business.view_level_profile_inner_join bvlpij where bvlpij.id_level_profile = ${level_profile.id_level_profile}`;

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

export const dml_level_profile_update = (level_profile: LevelProfile) => {
	return new Promise<LevelProfile[]>(async (resolve, reject) => {
		const query = `select * from business.dml_level_profile_update_modified(${level_profile.id_user_},
			${level_profile.id_level_profile},
			${level_profile.company.id_company},
			'${level_profile.name_level_profile}',
			'${level_profile.description_level_profile}',
			${level_profile.deleted_level_profile})`;

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

export const dml_level_profile_delete = (level_profile: LevelProfile) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_level_profile_delete_modified(${level_profile.id_user_},${level_profile.id_level_profile}) as result`;

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
