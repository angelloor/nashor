import { clientNASHORPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { Task } from './task.class';

export const dml_task_create = (task: Task) => {
	return new Promise<Task[]>(async (resolve, reject) => {
		const query = `select * from business.dml_task_create_modified(
			${task.id_user_},${task.process.id_process},${task.official.id_official},${task.level.id_level})`;

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

export const view_task_query_read = (task: Task) => {
	return new Promise<Task[]>(async (resolve, reject) => {
		const number_process: any = task.process;

		const query = `select * from business.view_task_inner_join bvtij${
			number_process != '*'
				? ` where lower(number_process) LIKE '%${number_process}%'`
				: ``
		} order by bvtij.id_task desc`;

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

export const view_task_by_process_query_read = (task: Task) => {
	return new Promise<Task[]>(async (resolve, reject) => {
		const number_process: any = task.process;

		const query = `select * from business.view_task_inner_join bvtij${
			number_process != '*'
				? ` where lower(number_process) LIKE '%${number_process}%' and bvtij.id_process = ${task.level}`
				: ` where bvtij.id_process = ${task.level}`
		} order by bvtij.id_task asc`;

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

export const view_task_by_official_query_read = (task: Task) => {
	return new Promise<Task[]>(async (resolve, reject) => {
		const number_process: any = task.process;

		const query = `select * from business.view_task_inner_join bvtij${
			number_process != '*'
				? ` where lower(number_process) LIKE '%${number_process}%' and bvtij.id_official = ${task.official}`
				: ` where bvtij.id_official = ${task.official}`
		} order by bvtij.id_task desc`;

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

export const view_task_by_level_query_read = (task: Task) => {
	return new Promise<Task[]>(async (resolve, reject) => {
		const number_process: any = task.process;

		const query = `select * from business.view_task_inner_join bvtij${
			number_process != '*'
				? ` where lower(number_process) LIKE '%${number_process}%' and bvtij.id_level = ${task.level}`
				: ` where bvtij.id_level = ${task.level}`
		} order by bvtij.id_task desc`;

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

export const view_task_specific_read = (task: Task) => {
	return new Promise<Task[]>(async (resolve, reject) => {
		const query = `select * from business.view_task_inner_join bvtij where bvtij.id_task = ${task.id_task}`;

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

export const dml_task_update = (task: Task) => {
	return new Promise<Task[]>(async (resolve, reject) => {
		const query = `select * from business.dml_task_update_modified(${task.id_user_},
			${task.id_task},
			${task.process.id_process},
			${task.official.id_official},
			${task.level.id_level},
			'${task.number_task}',
			'${task.type_status_task}',
			'${task.date_task}',
			${task.deleted_task})`;

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

export const dml_task_reasign = (task: Task) => {
	return new Promise<Task[]>(async (resolve, reject) => {
		const query = `select * from business.dml_task_reasign(${task.id_user_},
			${task.id_task},
			${task.process.id_process},
			${task.official.id_official},
			${task.level.id_level},
			'${task.number_task}',
			'${task.type_status_task}',
			'${task.date_task}',
			${task.deleted_task})`;

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

export const dml_task_send = (task: Task) => {
	return new Promise<Task[]>(async (resolve, reject) => {
		const query = `select * from business.dml_task_send(${task.id_user_},
			${task.id_task},
			${task.process.id_process},
			${task.official.id_official},
			${task.level.id_level},
			'${task.number_task}',
			'${task.type_status_task}',
			'${task.date_task}',
			${task.deleted_task})`;

		console.log(query);

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

export const dml_task_delete = (task: Task) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_task_delete(${task.id_user_},${task.id_task}) as result`;

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
