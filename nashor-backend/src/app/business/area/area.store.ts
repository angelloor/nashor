import { clientNASHORPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { Area } from './area.class';

export const dml_area_create = (area: Area) => {
	return new Promise<Area[]>(async (resolve, reject) => {
		const query = `select * from business.dml_area_create_modified(${area.id_user_},${area.company.id_company})`;

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

export const view_area_query_read = (area: Area) => {
	return new Promise<Area[]>(async (resolve, reject) => {
		const query = `select * from business.view_area_inner_join bvaij${
			area.name_area != '*'
				? ` where lower(bvaij.name_area) LIKE '%${area.name_area}%'`
				: ``
		} order by bvaij.id_area desc`;

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

export const view_area_by_company_query_read = (area: Area) => {
	return new Promise<Area[]>(async (resolve, reject) => {
		const query = `select * from business.view_area_inner_join bvaij${
			area.name_area != '*'
				? ` where lower(bvaij.name_area) LIKE '%${area.name_area}%' and bvaij.id_company = ${area.company}`
				: ` where bvaij.id_company = ${area.company}`
		} order by bvaij.id_area desc`;

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

export const view_area_specific_read = (area: Area) => {
	return new Promise<Area[]>(async (resolve, reject) => {
		const query = `select * from business.view_area_inner_join bvaij where bvaij.id_area = ${area.id_area}`;

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

export const dml_area_update = (area: Area) => {
	return new Promise<Area[]>(async (resolve, reject) => {
		const query = `select * from business.dml_area_update_modified(${area.id_user_},
			${area.id_area},
			${area.company.id_company},
			'${area.name_area}',
			'${area.description_area}',
			${area.deleted_area})`;

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

export const dml_area_delete = (area: Area) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_area_delete(${area.id_user_},${area.id_area}) as result`;

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
