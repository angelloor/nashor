import { clientNASHORPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { Control } from './control.class';

export const view_control_query_read = (control: Control) => {
	return new Promise<Control[]>(async (resolve, reject) => {
		const query = `select * from business.view_control_inner_join bvcij${
			control.form_name_control != '*'
				? ` where lower(bvcij.form_name_control) LIKE '%${control.form_name_control}%'
					or lower(bvcij.title_control) LIKE '%${control.form_name_control}%'`
				: ``
		} order by bvcij.id_control desc`;

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

export const view_control_by_company_query_read = (control: Control) => {
	return new Promise<Control[]>(async (resolve, reject) => {
		const query = `select * from business.view_control_inner_join bvcij${
			control.form_name_control != '*'
				? ` where lower(bvcij.form_name_control) LIKE '%${control.form_name_control}%'
					or lower(bvcij.title_control) LIKE '%${control.form_name_control}%' 
					and bvcij.id_company = ${control.company}`
				: ` where bvcij.id_company = ${control.company}`
		} order by bvcij.id_control desc`;

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

export const view_control_by_position_level_read = (control: Control) => {
	return new Promise<Control[]>(async (resolve, reject) => {
		const query = `select * from business.dml_control_by_position_level(${control.id_user_}, ${control.form_name_control})`;

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

export const view_control_specific_read = (control: Control) => {
	return new Promise<Control[]>(async (resolve, reject) => {
		const query = `select * from business.view_control_inner_join bvcij where bvcij.id_control = ${control.id_control}`;

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

export const dml_control_update = (control: Control) => {
	return new Promise<Control[]>(async (resolve, reject) => {
		const query = `select * from business.dml_control_update_modified(${
			control.id_user_
		},
			${control.id_control},
			${control.company.id_company},
			'${control.type_control}',
			'${control.title_control}',
			'${control.form_name_control}',
			'${control.initial_value_control}',
			${control.required_control},
			${control.min_length_control},
			${control.max_length_control},
			'${control.placeholder_control}',
			${control.spell_check_control},
			'${JSON.stringify(control.options_control)}',
			${control.in_use},
			${control.deleted_control})`;

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

export const dml_control_delete = (control: Control) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_control_delete(${control.id_user_},${control.id_control}) as result`;

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

export const dml_control_delete_cascade = (control: Control) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_control_delete_cascade(${control.id_user_},${control.id_control}) as result`;

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
