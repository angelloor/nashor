import { clientANGELPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { ProcessType } from './process_type.class';

export const dml_process_type_create = (process_type: ProcessType) => {
	return new Promise<ProcessType[]>(async (resolve, reject) => {
		const query = `select * from business.dml_process_type_create_modified(${process_type.id_user_},${process_type.company.id_company})`;

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

export const view_process_type_query_read = (process_type: ProcessType) => {
	return new Promise<ProcessType[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_type_inner_join bvptij${
			process_type.name_process_type != '*'
				? ` where lower(bvptij.name_process_type) LIKE '%${process_type.name_process_type}%'`
				: ``
		} order by bvptij.id_process_type desc`;

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

export const view_process_type_by_company_query_read = (
	process_type: ProcessType
) => {
	return new Promise<ProcessType[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_type_inner_join bvptij${
			process_type.name_process_type != '*'
				? ` where lower(bvptij.name_process_type) LIKE '%${process_type.name_process_type}%' and bvptij.id_company = ${process_type.company}`
				: ` where bvptij.id_company = ${process_type.company}`
		} order by bvptij.id_process_type desc`;

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

export const view_process_type_specific_read = (process_type: ProcessType) => {
	return new Promise<ProcessType[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_type_inner_join bvptij where bvptij.id_process_type = ${process_type.id_process_type}`;

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

export const dml_process_type_update = (process_type: ProcessType) => {
	return new Promise<ProcessType[]>(async (resolve, reject) => {
		const query = `select * from business.dml_process_type_update_modified(${process_type.id_user_},
			${process_type.id_process_type},
			${process_type.company.id_company},
			'${process_type.name_process_type}',
			'${process_type.description_process_type}',
			'${process_type.acronym_process_type}',
			${process_type.sequential_process_type},
			${process_type.deleted_process_type})`;

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

export const dml_process_type_delete = (process_type: ProcessType) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_process_type_delete_modified(${process_type.id_user_},${process_type.id_process_type}) as result`;

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
