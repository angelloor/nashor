import { clientANGELPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { TemplateControl } from './template_control.class';

export const dml_template_control_create = (
	template_control: TemplateControl
) => {
	return new Promise<TemplateControl[]>(async (resolve, reject) => {
		const query = `select * from business.dml_template_control_create_modified(${template_control.id_user_}, ${template_control.template.id_template}, ${template_control.control.id_control})`;

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

export const dml_template_control_create_with_new_control = (
	template_control: TemplateControl
) => {
	return new Promise<TemplateControl[]>(async (resolve, reject) => {
		const query = `select * from business.dml_template_control_create_with_new_control(${template_control.id_user_}, ${template_control.template.id_template})`;

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

export const view_template_control_by_template_read = (
	template_control: TemplateControl
) => {
	return new Promise<TemplateControl[]>(async (resolve, reject) => {
		const query = `select * from business.view_template_control_inner_join bvtcij where bvtcij.id_template = ${template_control.template} order by bvtcij.ordinal_position asc`;

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

export const view_template_control_by_control_read = (
	template_control: TemplateControl
) => {
	return new Promise<TemplateControl[]>(async (resolve, reject) => {
		const query = `select * from business.view_template_control_inner_join bvtcij where bvtcij.id_control = ${template_control.control} order by bvtcij.id_template_control desc`;

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

export const view_template_control_specific_read = (
	template_control: TemplateControl
) => {
	return new Promise<TemplateControl[]>(async (resolve, reject) => {
		const query = `select * from business.view_template_control_inner_join bvtcij where bvtcij.id_template_control = ${template_control.id_template_control}`;

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

export const dml_template_control_update_control_properties = (
	template_control: TemplateControl
) => {
	return new Promise<TemplateControl[]>(async (resolve, reject) => {
		const query = `select * from business.dml_template_control_update_control_properties_modified(${
			template_control.id_user_
		},
			${template_control.id_template_control},
			${template_control.template.id_template},
			${template_control.control.id_control},
			${template_control.ordinal_position},
			${template_control.control.company.id_company},
			'${template_control.control.type_control}',
			'${template_control.control.title_control}',
			'${template_control.control.form_name_control}',
			'${template_control.control.initial_value_control}',
			${template_control.control.required_control},
			${template_control.control.min_length_control},
			${template_control.control.max_length_control},
			'${template_control.control.placeholder_control}',
			${template_control.control.spell_check_control},
			'${JSON.stringify(template_control.control.options_control)}',
			${template_control.control.in_use},
			false)`;

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

export const dml_template_control_update_positions = (
	template_control: TemplateControl
) => {
	return new Promise<TemplateControl[]>(async (resolve, reject) => {
		const query = `select * from business.dml_template_control_update_positions(${
			template_control.id_user_
		}, ${template_control.template.id_template}, '${JSON.stringify(
			template_control.template_control
		)}')`;

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

export const dml_template_control_delete = (
	template_control: TemplateControl
) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_template_control_delete(${template_control.id_user_},${template_control.id_template_control}) as result`;

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
