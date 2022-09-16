import { clientNASHORPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { Item } from './item.class';

export const dml_item_create = (item: Item) => {
	return new Promise<Item[]>(async (resolve, reject) => {
		const query = `select * from business.dml_item_create_modified(${item.id_user_}, ${item.company.id_company})`;

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

export const view_item_query_read = (item: Item) => {
	return new Promise<Item[]>(async (resolve, reject) => {
		const query = `select * from business.view_item_inner_join bviij${
			item.name_item != '*'
				? ` where lower(bviij.name_item) LIKE '%${item.name_item}%'`
				: ``
		} order by bviij.id_item desc`;

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

export const view_item_by_company_query_read = (item: Item) => {
	return new Promise<Item[]>(async (resolve, reject) => {
		const query = `select * from business.view_item_inner_join bviij${
			item.name_item != '*'
				? ` where lower(bviij.name_item) LIKE '%${item.name_item}%' and bviij.id_company = ${item.company}`
				: ` where bviij.id_company = ${item.company}`
		} order by bviij.id_item desc`;

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

export const view_item_by_item_category_query_read = (item: Item) => {
	return new Promise<Item[]>(async (resolve, reject) => {
		const query = `select * from business.view_item_inner_join bviij${
			item.name_item != '*'
				? ` where lower(bviij.name_item) LIKE '%${item.name_item}%' and bviij.id_item_category = ${item.item_category}`
				: ` where bviij.id_item_category = ${item.item_category}`
		} order by bviij.id_item desc`;

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

export const view_item_specific_read = (item: Item) => {
	return new Promise<Item[]>(async (resolve, reject) => {
		const query = `select * from business.view_item_inner_join bviij where bviij.id_item = ${item.id_item}`;

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

export const dml_item_update = (item: Item) => {
	return new Promise<Item[]>(async (resolve, reject) => {
		const query = `select * from business.dml_item_update_modified(${item.id_user_},
			${item.id_item},
			${item.company.id_company},
			${item.item_category.id_item_category},
			'${item.name_item}',
			'${item.description_item}',
			'${item.cpc_item}',
			${item.deleted_item})`;

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

export const dml_item_delete = (item: Item) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_item_delete(${item.id_user_},${item.id_item}) as result`;

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
