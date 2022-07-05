import { clientANGELPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { FlowVersion } from './flow_version.class';

export const dml_flow_version_create = (flow_version: FlowVersion) => {
	return new Promise<FlowVersion[]>(async (resolve, reject) => {
		const query = `select * from business.dml_flow_version_create_modified(${flow_version.id_user_},${flow_version.flow.id_flow})`;

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

export const view_flow_version_by_flow_read = (flow_version: FlowVersion) => {
	return new Promise<FlowVersion[]>(async (resolve, reject) => {
		const query = `select * from business.view_flow_version_inner_join bvfvij where bvfvij.id_flow = ${flow_version.flow} order by bvfvij.id_flow_version desc`;

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

export const view_flow_version_specific_read = (flow_version: FlowVersion) => {
	return new Promise<FlowVersion[]>(async (resolve, reject) => {
		const query = `select * from business.view_flow_version_inner_join bvfvij where bvfvij.id_flow_version = ${flow_version.id_flow_version}`;

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

export const dml_flow_version_update = (flow_version: FlowVersion) => {
	return new Promise<FlowVersion[]>(async (resolve, reject) => {
		const query = `select * from business.dml_flow_version_update_modified(${flow_version.id_user_},
			${flow_version.id_flow_version},
			${flow_version.flow.id_flow},
			${flow_version.number_flow_version},
			${flow_version.status_flow_version},
			'${flow_version.creation_date_flow_version}',
			${flow_version.deleted_flow_version})`;

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

export const dml_flow_version_delete = (flow_version: FlowVersion) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_flow_version_delete(${flow_version.id_user_},${flow_version.id_flow_version}) as result`;

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
