import { clientNASHORPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { ProcessAttached } from './process_attached.class';

export const dml_process_attached_create = (
	process_attached: ProcessAttached
) => {
	return new Promise<ProcessAttached[]>(async (resolve, reject) => {
		const query = `select * from business.dml_process_attached_create_modified(${process_attached.id_user_}, 
			${process_attached.official.id_official}, 
			${process_attached.process.id_process}, 
			${process_attached.task.id_task}, 
			${process_attached.level.id_level}, 
			${process_attached.attached.id_attached},
			'${process_attached.file_name}',
			'${process_attached.length_mb}',
			'${process_attached.extension}',
			'${process_attached.server_path}',
			'${process_attached.alfresco_path}')`;

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

export const view_process_attached_by_official_read = (
	process_attached: ProcessAttached
) => {
	return new Promise<ProcessAttached[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_attached_inner_join bvpaij where bvpaij.id_official = ${process_attached.official} order by bvpaij.id_process_attached desc`;

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

export const view_process_attached_by_process_read = (
	process_attached: ProcessAttached
) => {
	return new Promise<ProcessAttached[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_attached_inner_join bvpaij where bvpaij.id_process = ${process_attached.process} order by bvpaij.id_process_attached desc`;

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

export const view_process_attached_by_task_read = (
	process_attached: ProcessAttached
) => {
	return new Promise<ProcessAttached[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_attached_inner_join bvpaij where bvpaij.id_task = ${process_attached.task} order by bvpaij.id_process_attached desc`;

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

export const view_process_attached_by_level_read = (
	process_attached: ProcessAttached
) => {
	return new Promise<ProcessAttached[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_attached_inner_join bvpaij where bvpaij.id_level = ${process_attached.level} order by bvpaij.id_process_attached desc`;

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

export const view_process_attached_by_attached_read = (
	process_attached: ProcessAttached
) => {
	return new Promise<ProcessAttached[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_attached_inner_join bvpaij where bvpaij.id_attached = ${process_attached.attached} order by bvpaij.id_process_attached desc`;

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

export const view_process_attached_specific_read = (
	process_attached: ProcessAttached
) => {
	return new Promise<ProcessAttached[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_attached_inner_join bvpaij where bvpaij.id_process_attached = ${process_attached.id_process_attached}`;

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

export const dml_process_attached_update = (
	process_attached: ProcessAttached
) => {
	return new Promise<ProcessAttached[]>(async (resolve, reject) => {
		const query = `select * from business.dml_process_attached_update_modified(${process_attached.id_user_},
			${process_attached.id_process_attached},
			${process_attached.official.id_official},
			${process_attached.process.id_process},
			${process_attached.task.id_task},
			${process_attached.level.id_level},
			${process_attached.attached.id_attached},
			'${process_attached.file_name}',
			'${process_attached.length_mb}',
			'${process_attached.extension}',
			'${process_attached.server_path}',
			'${process_attached.alfresco_path}',
			'${process_attached.upload_date}',
			${process_attached.deleted_process_attached})`;

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

export const dml_process_attached_delete = (
	process_attached: ProcessAttached
) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_process_attached_delete(${process_attached.id_user_},${process_attached.id_process_attached}) as result`;

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
