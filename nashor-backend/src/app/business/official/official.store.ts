import { clientANGELPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { Official } from './official.class';

export const dml_official_create = (official: Official) => {
	return new Promise<Official[]>(async (resolve, reject) => {
		const query = `select * from business.dml_official_create_modified(${official.id_user_}, ${official.company.id_company})`;

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

export const view_official_query_read = (official: Official) => {
	return new Promise<Official[]>(async (resolve, reject) => {
		const name_user: any = official.user;

		const query = `select * from business.view_official_inner_join bvoij${
			name_user != '*'
				? ` where (lower(bvoij.name_user) LIKE '%${name_user}%' or lower(bvoij.dni_person) LIKE '%${name_user}%'  or lower(bvoij.name_person) LIKE '%${name_user}%')`
				: ``
		} order by bvoij.id_official desc`;

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

export const view_official_by_company_query_read = (official: Official) => {
	return new Promise<Official[]>(async (resolve, reject) => {
		const name_user: any = official.user;

		const query = `select * from business.view_official_inner_join bvoij${
			name_user != '*'
				? ` where (lower(bvoij.name_user) LIKE '%${name_user}%' or lower(bvoij.dni_person) LIKE '%${name_user}%'  or lower(bvoij.name_person) LIKE '%${name_user}%') and bvoij.id_company = ${official.company}`
				: ` where bvoij.id_company = ${official.company}`
		} order by bvoij.id_official desc`;

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

export const view_official_by_user_read = (official: Official) => {
	return new Promise<Official[]>(async (resolve, reject) => {
		const query = `select * from business.view_official_inner_join bvoij where bvoij.id_user = ${official.user}`;

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

export const view_official_by_area_query_read = (official: Official) => {
	return new Promise<Official[]>(async (resolve, reject) => {
		const name_user: any = official.user;

		const query = `select * from business.view_official_inner_join bvoij${
			name_user != '*'
				? ` where (lower(bvoij.name_user) LIKE '%${name_user}%' or lower(bvoij.dni_person) LIKE '%${name_user}%'  or lower(bvoij.name_person) LIKE '%${name_user}%') and bvoij.id_area = ${official.area}`
				: ` where bvoij.id_area = ${official.area}`
		} order by bvoij.id_official desc`;

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

export const view_official_by_position_query_read = (official: Official) => {
	return new Promise<Official[]>(async (resolve, reject) => {
		const name_user: any = official.user;

		const query = `select * from business.view_official_inner_join bvoij${
			name_user != '*'
				? ` where (lower(bvoij.name_user) LIKE '%${name_user}%' or lower(bvoij.dni_person) LIKE '%${name_user}%'  or lower(bvoij.name_person) LIKE '%${name_user}%') and bvoij.id_position = ${official.position}`
				: ` where bvoij.id_position = ${official.position}`
		} order by bvoij.id_official desc`;

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

export const view_official_specific_read = (official: Official) => {
	return new Promise<Official[]>(async (resolve, reject) => {
		const query = `select * from business.view_official_inner_join bvoij where bvoij.id_official = ${official.id_official}`;

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

export const dml_official_update = (official: Official) => {
	return new Promise<Official[]>(async (resolve, reject) => {
		const query = `select * from business.dml_official_update_modified(${official.id_user_},
			${official.id_official},
			${official.user.id_user},
			${official.user.company.id_company},
			${official.user.person.id_person},
			${official.user.type_user.id_type_user},
			'${official.user.name_user}',
			'${official.user.password_user}',
			'${official.user.avatar_user}',
			${official.user.status_user},
			${official.user.person.academic.id_academic},
			${official.user.person.job.id_job},
			'${official.user.person.dni_person}',
			'${official.user.person.name_person}',
			'${official.user.person.last_name_person}',
			'${official.user.person.address_person}',
			'${official.user.person.phone_person}',
			'${official.user.person.academic.title_academic}',
			'${official.user.person.academic.abbreviation_academic}',
			'${official.user.person.academic.nivel_academic}',
			'${official.user.person.job.name_job}',
			'${official.user.person.job.address_job}',
			'${official.user.person.job.phone_job}',
			'${official.user.person.job.position_job}',
			${official.area.id_area},
			${official.position.id_position})`;

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

export const dml_official_delete = (official: Official) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_official_delete_modified(${official.id_user_},${official.id_official}) as result`;

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
