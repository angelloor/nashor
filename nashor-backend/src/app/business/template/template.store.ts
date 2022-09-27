import { clientNASHORPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { Template } from './template.class';

export const dml_template_create = (template: Template) => {
	return new Promise<Template[]>(async (resolve, reject) => {
		const query = `select * from business.dml_template_create_modified(${template.id_user_}, ${template.company.id_company})`;

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

export const view_template_query_read = (template: Template) => {
	return new Promise<Template[]>(async (resolve, reject) => {
		const query = `select * from business.view_template_inner_join bvtij${
			template.name_template != '*'
				? ` where lower(bvtij.name_template) LIKE '%${template.name_template}%'`
				: ``
		} order by bvtij.id_template desc`;

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

export const view_template_by_company_query_read = (template: Template) => {
	return new Promise<Template[]>(async (resolve, reject) => {
		const query = `select * from business.view_template_inner_join bvtij${
			template.name_template != '*'
				? ` where lower(bvtij.name_template) LIKE '%${template.name_template}%' and bvtij.id_company = ${template.company}`
				: ` where bvtij.id_company = ${template.company}`
		} order by bvtij.id_template desc`;

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

export const view_template_by_documentation_profile_query_read = (
	template: Template
) => {
	return new Promise<Template[]>(async (resolve, reject) => {
		const query = `select * from business.view_template_inner_join bvtij${
			template.name_template != '*'
				? ` where lower(bvtij.name_template) LIKE '%${template.name_template}%' and bvtij.id_documentation_profile = ${template.documentation_profile}`
				: ` where bvtij.id_documentation_profile = ${template.documentation_profile}`
		} order by bvtij.id_template desc`;

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

export const view_template_specific_read = (template: Template) => {
	return new Promise<Template[]>(async (resolve, reject) => {
		const query = `select * from business.view_template_inner_join bvtij where bvtij.id_template = ${template.id_template}`;

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

export const dml_template_update = (template: Template) => {
	return new Promise<Template[]>(async (resolve, reject) => {
		const query = `select * from business.dml_template_update_modified(${template.id_user_},
			${template.id_template},
			${template.company.id_company},
			${template.documentation_profile.id_documentation_profile},
			${template.plugin_item.id_plugin_item},
			${template.plugin_attached_process},
			${template.plugin_item_process},
			'${template.name_template}',
			'${template.description_template}',
			${template.status_template},
			'${template.last_change}',
			${template.in_use},
			${template.deleted_template})`;

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

export const dml_template_delete = (template: Template) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_template_delete_modified(${template.id_user_},${template.id_template}) as result`;

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
