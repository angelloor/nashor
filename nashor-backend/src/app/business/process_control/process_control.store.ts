import { clientNASHORPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { ProcessControl } from './process_control.class';

export const dml_process_control_create = (process_control: ProcessControl) => {
	return new Promise<ProcessControl[]>(async (resolve, reject) => {
		const query = `select * from business.dml_process_control_create_modified(${process_control.id_user_},
			${process_control.official.id_official},
			${process_control.process.id_process},
			${process_control.task.id_task},
			${process_control.level.id_level},
			${process_control.control.id_control},
			'${process_control.value_process_control}')`;

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

export const view_process_control_by_official_read = (
	process_control: ProcessControl
) => {
	return new Promise<ProcessControl[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_control_inner_join bvpcij where bvpcij.id_official = ${process_control.official} order by bvpcij.id_process_control desc`;

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

export const view_process_control_by_process_read = (
	process_control: ProcessControl
) => {
	return new Promise<ProcessControl[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_control_inner_join bvpcij where bvpcij.id_process = ${process_control.process} order by bvpcij.id_process_control desc`;

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

export const view_process_control_by_task_read = (
	process_control: ProcessControl
) => {
	return new Promise<ProcessControl[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_control_inner_join bvpcij where bvpcij.id_task = ${process_control.task} order by bvpcij.id_process_control desc`;

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

export const view_process_control_by_level_read = (
	process_control: ProcessControl
) => {
	return new Promise<ProcessControl[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_control_inner_join bvpcij where bvpcij.id_level = ${process_control.level} order by bvpcij.id_process_control desc`;

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

export const view_process_control_by_control_read = (
	process_control: ProcessControl
) => {
	return new Promise<ProcessControl[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_control_inner_join bvpcij where bvpcij.id_control = ${process_control.control} order by bvpcij.id_process_control desc`;

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

export const view_process_control_specific_read = (
	process_control: ProcessControl
) => {
	return new Promise<ProcessControl[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_control_inner_join bvpcij where bvpcij.id_process_control = ${process_control.id_process_control}`;

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

export const dml_process_control_update = (process_control: ProcessControl) => {
	return new Promise<ProcessControl[]>(async (resolve, reject) => {
		const query = `select * from business.dml_process_control_update_modified(${process_control.id_user_},
			${process_control.id_process_control},
			${process_control.official.id_official},
			${process_control.process.id_process},
			${process_control.task.id_task},
			${process_control.level.id_level},
			${process_control.control.id_control},
			'${process_control.value_process_control}',
			'${process_control.last_change_process_control}',
			${process_control.deleted_process_control})`;

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

export const dml_process_control_delete = (process_control: ProcessControl) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_process_control_delete(${process_control.id_user_},${process_control.id_process_control}) as result`;

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
