import { clientANGELPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { ProcessItem } from './process_item.class';

export const dml_process_item_create = (process_item: ProcessItem) => {
	return new Promise<ProcessItem[]>(async (resolve, reject) => {
		const query = `select * from business.dml_process_item_create_modified(${process_item.id_user_}, ${process_item.official.id_official}, ${process_item.process.id_process}, ${process_item.task.id_task}, ${process_item.level.id_level})`;

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

export const view_process_item_by_official_read = (
	process_item: ProcessItem
) => {
	return new Promise<ProcessItem[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_item_inner_join bvpiij where bvpiij.id_official = ${process_item.official} order by bvpiij.id_process_item desc`;

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

export const view_process_item_by_process_read = (
	process_item: ProcessItem
) => {
	return new Promise<ProcessItem[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_item_inner_join bvpiij where bvpiij.id_process = ${process_item.process} order by bvpiij.id_process_item desc`;

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

export const view_process_item_by_task_read = (process_item: ProcessItem) => {
	return new Promise<ProcessItem[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_item_inner_join bvpiij where bvpiij.id_task = ${process_item.task} order by bvpiij.id_process_item desc`;

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

export const view_process_item_by_level_read = (process_item: ProcessItem) => {
	return new Promise<ProcessItem[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_item_inner_join bvpiij where bvpiij.id_level = ${process_item.level} order by bvpiij.id_process_item desc`;

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

export const view_process_item_by_item_read = (process_item: ProcessItem) => {
	return new Promise<ProcessItem[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_item_inner_join bvpiij where bvpiij.id_item = ${process_item.item} order by bvpiij.id_process_item desc`;

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

export const view_process_item_specific_read = (process_item: ProcessItem) => {
	return new Promise<ProcessItem[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_item_inner_join bvpiij where bvpiij.id_process_item = ${process_item.id_process_item}`;

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

export const dml_process_item_update = (process_item: ProcessItem) => {
	return new Promise<ProcessItem[]>(async (resolve, reject) => {
		const query = `select * from business.dml_process_item_update_modified(${process_item.id_user_},
			${process_item.id_process_item},
			${process_item.official.id_official},
			${process_item.process.id_process},
			${process_item.task.id_task},
			${process_item.level.id_level},
			${process_item.item.id_item},
			${process_item.amount_process_item},
			'${process_item.features_process_item}',
			'${process_item.entry_date_process_item}')`;

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

export const dml_process_item_delete = (process_item: ProcessItem) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_process_item_delete(${process_item.id_user_},${process_item.id_process_item}) as result`;

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
