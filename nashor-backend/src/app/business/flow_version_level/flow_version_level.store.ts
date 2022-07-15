import { clientANGELPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { FlowVersionLevel } from './flow_version_level.class';

export const dml_flow_version_level_create = (
	flow_version_level: FlowVersionLevel
) => {
	return new Promise<FlowVersionLevel[]>(async (resolve, reject) => {
		const query = `select * from business.dml_flow_version_level_create_modified(${flow_version_level.id_user_},${flow_version_level.flow_version.id_flow_version},'${flow_version_level.type_element}')`;

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

export const view_flow_version_level_by_flow_version_read = (
	flow_version_level: FlowVersionLevel
) => {
	return new Promise<FlowVersionLevel[]>(async (resolve, reject) => {
		const query = `select * from business.view_flow_version_level_inner_join bvfvlij where bvfvlij.id_flow_version = ${flow_version_level.flow_version} order by bvfvlij.id_flow_version_level desc`;

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

export const view_flow_version_level_by_level_read = (
	flow_version_level: FlowVersionLevel
) => {
	return new Promise<FlowVersionLevel[]>(async (resolve, reject) => {
		const query = `select * from business.view_flow_version_level_inner_join bvfvlij where bvfvlij.id_level = ${flow_version_level.level} order by bvfvlij.id_flow_version_level desc`;

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

export const view_flow_version_level_specific_read = (
	flow_version_level: FlowVersionLevel
) => {
	return new Promise<FlowVersionLevel[]>(async (resolve, reject) => {
		const query = `select * from business.view_flow_version_level_inner_join bvfvlij where bvfvlij.id_flow_version_level = ${flow_version_level.id_flow_version_level}`;

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

export const dml_flow_version_level_update = (
	flow_version_level: FlowVersionLevel
) => {
	return new Promise<FlowVersionLevel[]>(async (resolve, reject) => {
		const query = `select * from business.dml_flow_version_level_update_modified(${flow_version_level.id_user_},
			${flow_version_level.id_flow_version_level},
			${flow_version_level.flow_version.id_flow_version},
			${flow_version_level.level.id_level},
			${flow_version_level.position_level},
			${flow_version_level.position_level_father},
			'${flow_version_level.type_element}',
			'${flow_version_level.id_control}',
			'${flow_version_level.operator}',
			'${flow_version_level.value_against}',
			${flow_version_level.option_true},
			${flow_version_level.x},
			${flow_version_level.y})`;

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

export const dml_flow_version_level_reset = (
	flow_version_level: FlowVersionLevel
) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_flow_version_level_reset(${flow_version_level.id_user_}, ${flow_version_level.flow_version.id_flow_version}) as result`;

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

export const dml_flow_version_level_delete = (
	flow_version_level: FlowVersionLevel
) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_flow_version_level_delete(${flow_version_level.id_user_},${flow_version_level.id_flow_version_level}) as result`;

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
