import { clientNASHORPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { Flow } from './flow.class';

export const dml_flow_create = (flow: Flow) => {
	return new Promise<Flow[]>(async (resolve, reject) => {
		const query = `select * from business.dml_flow_create_modified(${flow.id_user_},${flow.company.id_company})`;

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

export const view_flow_query_read = (flow: Flow) => {
	return new Promise<Flow[]>(async (resolve, reject) => {
		const query = `select * from business.view_flow_inner_join bvptij${
			flow.name_flow != '*'
				? ` where lower(bvptij.name_flow) LIKE '%${flow.name_flow}%'`
				: ``
		} order by bvptij.id_flow desc`;

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

export const view_flow_by_company_query_read = (flow: Flow) => {
	return new Promise<Flow[]>(async (resolve, reject) => {
		const query = `select * from business.view_flow_inner_join bvptij${
			flow.name_flow != '*'
				? ` where lower(bvptij.name_flow) LIKE '%${flow.name_flow}%' and bvptij.id_company = ${flow.company}`
				: ` where bvptij.id_company = ${flow.company}`
		} order by bvptij.id_flow desc`;

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

export const view_flow_specific_read = (flow: Flow) => {
	return new Promise<Flow[]>(async (resolve, reject) => {
		const query = `select * from business.view_flow_inner_join bvptij where bvptij.id_flow = ${flow.id_flow}`;

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

export const dml_flow_update = (flow: Flow) => {
	return new Promise<Flow[]>(async (resolve, reject) => {
		const query = `select * from business.dml_flow_update_modified(${flow.id_user_},
			${flow.id_flow},
			${flow.company.id_company},
			'${flow.name_flow}',
			'${flow.description_flow}',
			'${flow.acronym_flow}',
			'${flow.acronym_task}',
			${flow.sequential_flow},
			${flow.deleted_flow})`;

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

export const dml_flow_delete = (flow: Flow) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_flow_delete_modified(${flow.id_user_},${flow.id_flow}) as result`;

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
