import { clientNASHORPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { PluginItemColumn } from './plugin_item_column.class';

export const dml_plugin_item_column_create = (
	plugin_item_column: PluginItemColumn
) => {
	return new Promise<PluginItemColumn[]>(async (resolve, reject) => {
		const query = `select * from business.dml_plugin_item_column_create_modified(${plugin_item_column.id_user_}, ${plugin_item_column.plugin_item.id_plugin_item})`;

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

export const view_plugin_item_column_query_read = (
	plugin_item_column: PluginItemColumn
) => {
	return new Promise<PluginItemColumn[]>(async (resolve, reject) => {
		const query = `select * from business.view_plugin_item_column_inner_join bvpicij${
			plugin_item_column.name_plugin_item_column != '*'
				? ` where lower(bvpicij.name_plugin_item_column) LIKE '%${plugin_item_column.name_plugin_item_column}%'`
				: ``
		} order by bvpicij.id_plugin_item_column desc`;

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

export const view_plugin_item_column_by_plugin_item_query_read = (
	plugin_item_column: PluginItemColumn
) => {
	return new Promise<PluginItemColumn[]>(async (resolve, reject) => {
		const query = `select * from business.view_plugin_item_column_inner_join bvpicij${
			plugin_item_column.name_plugin_item_column != '*'
				? ` where lower(bvpicij.name_plugin_item_column) LIKE '%${plugin_item_column.name_plugin_item_column}%' and bvpicij.id_plugin_item = ${plugin_item_column.plugin_item}`
				: ` where bvpicij.id_plugin_item = ${plugin_item_column.plugin_item}`
		} order by bvpicij.id_plugin_item_column desc`;

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

export const view_plugin_item_column_specific_read = (
	plugin_item_column: PluginItemColumn
) => {
	return new Promise<PluginItemColumn[]>(async (resolve, reject) => {
		const query = `select * from business.view_plugin_item_column_inner_join bvpicij where bvpicij.id_plugin_item_column = ${plugin_item_column.id_plugin_item_column}`;

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

export const dml_plugin_item_column_update = (
	plugin_item_column: PluginItemColumn
) => {
	return new Promise<PluginItemColumn[]>(async (resolve, reject) => {
		const query = `select * from business.dml_plugin_item_column_update_modified(${plugin_item_column.id_user_},
			${plugin_item_column.id_plugin_item_column},
			${plugin_item_column.plugin_item.id_plugin_item},
			'${plugin_item_column.name_plugin_item_column}',
			${plugin_item_column.lenght_plugin_item_column})`;

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

export const dml_plugin_item_column_delete = (
	plugin_item_column: PluginItemColumn
) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_plugin_item_column_delete(${plugin_item_column.id_user_},${plugin_item_column.id_plugin_item_column}) as result`;

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
