import { clientNASHORPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { LevelProfileOfficial } from './level_profile_official.class';

export const dml_level_profile_official_create = (
	level_profile_official: LevelProfileOfficial
) => {
	return new Promise<LevelProfileOfficial[]>(async (resolve, reject) => {
		const query = `select * from business.dml_level_profile_official_create_modified(${level_profile_official.id_user_}, ${level_profile_official.level_profile.id_level_profile})`;
		console.log(
			'🚀 ~ file: level_profile_official.store.ts ~ line 10 ~ returnnewPromise<LevelProfileOfficial[]> ~ query',
			query
		);

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

export const view_level_profile_official_by_level_profile_read = (
	level_profile_official: LevelProfileOfficial
) => {
	return new Promise<LevelProfileOfficial[]>(async (resolve, reject) => {
		const query = `select * from business.view_level_profile_official_inner_join bvlpoij where bvlpoij.id_level_profile = ${level_profile_official.level_profile} order by bvlpoij.id_level_profile_official asc`;

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

export const view_level_profile_official_specific_read = (
	level_profile_official: LevelProfileOfficial
) => {
	return new Promise<LevelProfileOfficial[]>(async (resolve, reject) => {
		const query = `select * from business.view_level_profile_official_inner_join bvlpoij where bvlpoij.id_level_profile_official = ${level_profile_official.id_level_profile_official}`;

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

export const dml_level_profile_official_update = (
	level_profile_official: LevelProfileOfficial
) => {
	return new Promise<LevelProfileOfficial[]>(async (resolve, reject) => {
		const query = `select * from business.dml_level_profile_official_update_modified(${level_profile_official.id_user_},
			${level_profile_official.id_level_profile_official},
			${level_profile_official.level_profile.id_level_profile},
			${level_profile_official.official.id_official},
			${level_profile_official.official_modifier})`;

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

export const dml_level_profile_official_delete = (
	level_profile_official: LevelProfileOfficial
) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_level_profile_official_delete(${level_profile_official.id_user_},${level_profile_official.id_level_profile_official}) as result`;

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
