import { clientNASHORPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { Process } from './process.class';

export const dml_process_create = (process: Process) => {
	return new Promise<Process[]>(async (resolve, reject) => {
		const query = `select * from business.dml_process_create_modified(${process.id_user_}, ${process.flow_version.id_flow_version})`;

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

export const view_process_query_read = (process: Process) => {
	return new Promise<Process[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_inner_join bvpij${
			process.number_process != '*'
				? ` where lower(bvpij.number_process) LIKE '%${process.number_process}%'`
				: ``
		} order by bvpij.id_process desc`;

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

export const view_process_by_official_query_read = (process: Process) => {
	return new Promise<Process[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_inner_join bvpij${
			process.number_process != '*'
				? ` where lower(bvpij.number_process) LIKE '%${process.number_process}%' and bvpij.id_official = ${process.official}`
				: ` where bvpij.id_official = ${process.official}`
		} order by bvpij.id_process desc`;

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

export const view_process_by_flow_version_query_read = (process: Process) => {
	return new Promise<Process[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_inner_join bvpij${
			process.number_process != '*'
				? ` where lower(bvpij.number_process) LIKE '%${process.number_process}%' and bvpij.id_flow_version = ${process.flow_version}`
				: ` where bvpij.id_flow_version = ${process.flow_version}`
		} order by bvpij.id_process desc`;

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

export const view_process_specific_read = (process: Process) => {
	return new Promise<Process[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_inner_join bvpij where bvpij.id_process = ${process.id_process}`;

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

export const dml_process_update = (process: Process) => {
	return new Promise<Process[]>(async (resolve, reject) => {
		const query = `select * from business.dml_process_update_modified(${process.id_user_},
			${process.id_process},
			${process.official.id_official},
			${process.flow_version.id_flow_version},
			'${process.number_process}',
			'${process.date_process}',
			${process.generated_task},
			${process.finalized_process},
			${process.deleted_process})`;

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

export const dml_process_delete = (process: Process) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_process_delete(${process.id_user_},${process.id_process}) as result`;

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
