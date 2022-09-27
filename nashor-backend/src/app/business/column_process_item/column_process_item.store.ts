import { clientNASHORPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { ColumnProcessItem } from './column_process_item.class';

export const dml_column_process_item_create = (
	column_process_item: ColumnProcessItem
) => {
	return new Promise<ColumnProcessItem[]>(async (resolve, reject) => {
		const query = `select * from business.dml_column_process_item_create_modified(${column_process_item.id_user_}, ${column_process_item.plugin_item_column.id_plugin_item_column}, ${column_process_item.process_item.id_process_item}, '${column_process_item.value_column_process_item}')`;

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

export const view_column_process_item_query_read = (
	column_process_item: ColumnProcessItem
) => {
	return new Promise<ColumnProcessItem[]>(async (resolve, reject) => {
		const query = `select * from business.view_column_process_item_inner_join bvcpiij${
			column_process_item.value_column_process_item != '*'
				? ` where lower(bvcpiij.value_column_process_item) LIKE '%${column_process_item.value_column_process_item}%'`
				: ``
		} order by bvcpiij.id_column_process_item desc`;

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

export const view_column_process_item_by_plugin_item_column_query_read = (
	column_process_item: ColumnProcessItem
) => {
	return new Promise<ColumnProcessItem[]>(async (resolve, reject) => {
		const query = `select * from business.view_column_process_item_inner_join bvcpiij${
			column_process_item.value_column_process_item != '*'
				? ` where lower(bvcpiij.value_column_process_item) LIKE '%${column_process_item.value_column_process_item}%' and bvcpiij.id_plugin_item_column = ${column_process_item.plugin_item_column}`
				: ` where bvcpiij.id_plugin_item_column = ${column_process_item.plugin_item_column}`
		} order by bvcpiij.id_column_process_item desc`;

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

export const view_column_process_item_by_process_item_query_read = (
	column_process_item: ColumnProcessItem
) => {
	return new Promise<ColumnProcessItem[]>(async (resolve, reject) => {
		const query = `select * from business.view_column_process_item_inner_join bvcpiij${
			column_process_item.value_column_process_item != '*'
				? ` where lower(bvcpiij.value_column_process_item) LIKE '%${column_process_item.value_column_process_item}%' and bvcpiij.id_process_item = ${column_process_item.process_item}`
				: ` where bvcpiij.id_process_item = ${column_process_item.process_item}`
		} order by bvcpiij.id_column_process_item desc`;

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

export const view_column_process_item_by_plugin_item_column_and_process_item_read =
	(column_process_item: ColumnProcessItem) => {
		return new Promise<ColumnProcessItem[]>(async (resolve, reject) => {
			const query = `select * from business.view_column_process_item_inner_join bvcpiij where bvcpiij.id_plugin_item_column = ${column_process_item.plugin_item_column} and bvcpiij.id_process_item = ${column_process_item.process_item}`;

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

export const view_column_process_item_specific_read = (
	column_process_item: ColumnProcessItem
) => {
	return new Promise<ColumnProcessItem[]>(async (resolve, reject) => {
		const query = `select * from business.view_column_process_item_inner_join bvcpiij where bvcpiij.id_column_process_item = ${column_process_item.id_column_process_item}`;

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

export const dml_column_process_item_update = (
	column_process_item: ColumnProcessItem
) => {
	return new Promise<ColumnProcessItem[]>(async (resolve, reject) => {
		const query = `select * from business.dml_column_process_item_update_modified(${column_process_item.id_user_},
			${column_process_item.id_column_process_item},
			${column_process_item.plugin_item_column.id_plugin_item_column},
			${column_process_item.process_item.id_process_item},
			'${column_process_item.value_column_process_item}',
			'${column_process_item.entry_date_column_process_item}')`;

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

export const dml_column_process_item_delete = (
	column_process_item: ColumnProcessItem
) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_column_process_item_delete(${column_process_item.id_user_},${column_process_item.id_column_process_item}) as result`;

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
