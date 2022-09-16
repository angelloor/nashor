import { clientNASHORPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { Attached } from './attached.class';

export const dml_attached_create = (attached: Attached) => {
	return new Promise<Attached[]>(async (resolve, reject) => {
		const query = `select * from business.dml_attached_create_modified(${attached.id_user_}, ${attached.company.id_company})`;

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

export const view_attached_query_read = (attached: Attached) => {
	return new Promise<Attached[]>(async (resolve, reject) => {
		const query = `select * from business.view_attached_inner_join bvaij${
			attached.name_attached != '*'
				? ` where lower(bvaij.name_attached) LIKE '%${attached.name_attached}%'`
				: ``
		} order by bvaij.id_attached desc`;

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

export const view_attached_by_company_query_read = (attached: Attached) => {
	return new Promise<Attached[]>(async (resolve, reject) => {
		const query = `select * from business.view_attached_inner_join bvaij${
			attached.name_attached != '*'
				? ` where lower(bvaij.name_attached) LIKE '%${attached.name_attached}%' and bvaij.id_company = ${attached.company}`
				: ` where bvaij.id_company = ${attached.company}`
		} order by bvaij.id_attached desc`;

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

export const view_attached_specific_read = (attached: Attached) => {
	return new Promise<Attached[]>(async (resolve, reject) => {
		const query = `select * from business.view_attached_inner_join bvaij where bvaij.id_attached = ${attached.id_attached}`;

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

export const dml_attached_update = (attached: Attached) => {
	return new Promise<Attached[]>(async (resolve, reject) => {
		const query = `select * from business.dml_attached_update_modified(${attached.id_user_},
			${attached.id_attached},
			${attached.company.id_company},
			'${attached.name_attached}',
			'${attached.description_attached}',
			${attached.length_mb_attached},
			${attached.required_attached},
			${attached.deleted_attached})`;

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

export const dml_attached_delete = (attached: Attached) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_attached_delete(${attached.id_user_},${attached.id_attached}) as result`;

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
