import { clientNASHORPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { ItemCategory } from './item_category.class';

export const dml_item_category_create = (item_category: ItemCategory) => {
	return new Promise<ItemCategory[]>(async (resolve, reject) => {
		const query = `select * from business.dml_item_category_create_modified(${item_category.id_user_}, ${item_category.company.id_company})`;

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

export const view_item_category_query_read = (item_category: ItemCategory) => {
	return new Promise<ItemCategory[]>(async (resolve, reject) => {
		const query = `select * from business.view_item_category_inner_join bvicij${
			item_category.name_item_category != '*'
				? ` where lower(bvicij.name_item_category) LIKE '%${item_category.name_item_category}%'`
				: ``
		} order by bvicij.id_item_category desc`;

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

export const view_item_category_by_company_query_read = (
	item_category: ItemCategory
) => {
	return new Promise<ItemCategory[]>(async (resolve, reject) => {
		const query = `select * from business.view_item_category_inner_join bvicij${
			item_category.name_item_category != '*'
				? ` where lower(bvicij.name_item_category) LIKE '%${item_category.name_item_category}%' and bvicij.id_company = ${item_category.company}`
				: ` where bvicij.id_company = ${item_category.company}`
		} order by bvicij.id_item_category desc`;

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

export const view_item_category_specific_read = (
	item_category: ItemCategory
) => {
	return new Promise<ItemCategory[]>(async (resolve, reject) => {
		const query = `select * from business.view_item_category_inner_join bvicij where bvicij.id_item_category = ${item_category.id_item_category}`;

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

export const dml_item_category_update = (item_category: ItemCategory) => {
	return new Promise<ItemCategory[]>(async (resolve, reject) => {
		const query = `select * from business.dml_item_category_update_modified(${item_category.id_user_},
			${item_category.id_item_category},
			${item_category.company.id_company},
			'${item_category.name_item_category}',
			'${item_category.description_item_category}',
			${item_category.deleted_item_category})`;

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

export const dml_item_category_delete = (item_category: ItemCategory) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_item_category_delete(${item_category.id_user_},${item_category.id_item_category}) as result`;

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
