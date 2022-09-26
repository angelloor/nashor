import { clientNASHORPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { PluginItem } from './plugin_item.class';

export const dml_plugin_item_create = (plugin_item: PluginItem) => {
	return new Promise<PluginItem[]>(async (resolve, reject) => {
		const query = `select * from business.dml_plugin_item_create_modified(${plugin_item.id_user_}, ${plugin_item.company.id_company})`;

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

export const view_plugin_item_query_read = (plugin_item: PluginItem) => {
	return new Promise<PluginItem[]>(async (resolve, reject) => {
		const query = `select * from business.view_plugin_item_inner_join bvpiij${
			plugin_item.name_plugin_item != '*'
				? ` where lower(bvpiij.name_plugin_item) LIKE '%${plugin_item.name_plugin_item}%'`
				: ``
		} order by bvpiij.id_plugin_item desc`;

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

export const view_plugin_item_by_company_query_read = (
	plugin_item: PluginItem
) => {
	return new Promise<PluginItem[]>(async (resolve, reject) => {
		const query = `select * from business.view_plugin_item_inner_join bvpiij${
			plugin_item.name_plugin_item != '*'
				? ` where lower(bvpiij.name_plugin_item) LIKE '%${plugin_item.name_plugin_item}%' and bvpiij.id_company = ${plugin_item.company}`
				: ` where bvpiij.id_company = ${plugin_item.company}`
		} order by bvpiij.id_plugin_item desc`;

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

export const view_plugin_item_specific_read = (plugin_item: PluginItem) => {
	return new Promise<PluginItem[]>(async (resolve, reject) => {
		const query = `select * from business.view_plugin_item_inner_join bvpiij where bvpiij.id_plugin_item = ${plugin_item.id_plugin_item}`;

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

export const dml_plugin_item_update = (plugin_item: PluginItem) => {
	return new Promise<PluginItem[]>(async (resolve, reject) => {
		const query = `select * from business.dml_plugin_item_update_modified(${plugin_item.id_user_},
			${plugin_item.id_plugin_item},
			${plugin_item.company.id_company},
			'${plugin_item.name_plugin_item}',
			'${plugin_item.description_plugin_item}')`;

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

export const dml_plugin_item_delete = (plugin_item: PluginItem) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_plugin_item_delete(${plugin_item.id_user_},${plugin_item.id_plugin_item}) as result`;

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
