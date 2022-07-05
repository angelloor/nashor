import { clientANGELPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { Position } from './position.class';

export const dml_position_create = (position: Position) => {
	return new Promise<Position[]>(async (resolve, reject) => {
		const query = `select * from business.dml_position_create_modified(${position.id_user_},${position.company.id_company})`;

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

export const view_position_query_read = (position: Position) => {
	return new Promise<Position[]>(async (resolve, reject) => {
		const query = `select * from business.view_position_inner_join bvpij${
			position.name_position != '*'
				? ` where lower(bvpij.name_position) LIKE '%${position.name_position}%'`
				: ``
		} order by bvpij.id_position desc`;

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

export const view_position_by_company_query_read = (position: Position) => {
	return new Promise<Position[]>(async (resolve, reject) => {
		const query = `select * from business.view_position_inner_join bvpij${
			position.name_position != '*'
				? ` where lower(bvpij.name_position) LIKE '%${position.name_position}%' and bvpij.id_company = ${position.company}`
				: ` where bvpij.id_company = ${position.company}`
		} order by bvpij.id_position desc`;

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

export const view_position_specific_read = (position: Position) => {
	return new Promise<Position[]>(async (resolve, reject) => {
		const query = `select * from business.view_position_inner_join bvpij where bvpij.id_position = ${position.id_position}`;

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

export const dml_position_update = (position: Position) => {
	return new Promise<Position[]>(async (resolve, reject) => {
		const query = `select * from business.dml_position_update_modified(${position.id_user_},
			${position.id_position},
			${position.company.id_company},
			'${position.name_position}',
			'${position.description_position}',
			${position.deleted_position})`;

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

export const dml_position_delete = (position: Position) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_position_delete(${position.id_user_},${position.id_position}) as result`;

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
