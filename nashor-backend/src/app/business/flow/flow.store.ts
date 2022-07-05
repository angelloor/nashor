import { clientANGELPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { Flow } from './flow.class';

export const dml_flow_create = (flow: Flow) => {
	return new Promise<Flow[]>(async (resolve, reject) => {
		const query = `select * from business.dml_flow_create_modified(${flow.id_user_},${flow.company.id_company},${flow.process_type.id_process_type})`;

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

export const view_flow_query_read = (flow: Flow) => {
	return new Promise<Flow[]>(async (resolve, reject) => {
		const query = `select * from business.view_flow_inner_join bvfij${
			flow.name_flow != '*'
				? ` where lower(bvfij.name_flow) LIKE '%${flow.name_flow}%'`
				: ``
		} order by bvfij.id_flow desc`;

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

export const view_flow_by_company_query_read = (flow: Flow) => {
	return new Promise<Flow[]>(async (resolve, reject) => {
		const query = `select * from business.view_flow_inner_join bvfij${
			flow.name_flow != '*'
				? ` where lower(bvfij.name_flow) LIKE '%${flow.name_flow}%' and bvfij.id_company = ${flow.company}`
				: ` where bvfij.id_company = ${flow.company}`
		} order by bvfij.id_flow desc`;

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

export const view_flow_by_process_type_query_read = (flow: Flow) => {
	return new Promise<Flow[]>(async (resolve, reject) => {
		const query = `select * from business.view_flow_inner_join bvfij${
			flow.name_flow != '*'
				? ` where lower(bvfij.name_flow) LIKE '%${flow.name_flow}%' and bvfij.id_process_type = ${flow.process_type}`
				: ` where bvfij.id_process_type = ${flow.process_type}`
		} order by bvfij.id_flow desc`;

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

export const view_flow_specific_read = (flow: Flow) => {
	return new Promise<Flow[]>(async (resolve, reject) => {
		const query = `select * from business.view_flow_inner_join bvfij where bvfij.id_flow = ${flow.id_flow}`;

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

export const dml_flow_update = (flow: Flow) => {
	return new Promise<Flow[]>(async (resolve, reject) => {
		const query = `select * from business.dml_flow_update_modified(${flow.id_user_},
			${flow.id_flow},
			${flow.company.id_company},
			${flow.process_type.id_process_type},
			'${flow.name_flow}',
			'${flow.description_flow}',
			${flow.deleted_flow})`;

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

export const dml_flow_delete = (flow: Flow) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_flow_delete(${flow.id_user_},${flow.id_flow}) as result`;

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
