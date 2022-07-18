import { clientANGELPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { ProcessComment } from './process_comment.class';

export const dml_process_comment_create = (process_comment: ProcessComment) => {
	return new Promise<ProcessComment[]>(async (resolve, reject) => {
		const query = `select * from business.dml_process_comment_create_modified(${process_comment.id_user_},
			${process_comment.official.id_official},
			${process_comment.process.id_process},
			${process_comment.task.id_task},
			${process_comment.level.id_level})`;
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

export const view_process_comment_by_official_read = (
	process_comment: ProcessComment
) => {
	return new Promise<ProcessComment[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_comment_inner_join bvpcij where bvpcij.id_official = ${process_comment.official} order by bvpcij.id_process_comment desc`;

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

export const view_process_comment_by_process_read = (
	process_comment: ProcessComment
) => {
	return new Promise<ProcessComment[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_comment_inner_join bvpcij where bvpcij.id_process = ${process_comment.process} order by bvpcij.id_process_comment desc`;

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

export const view_process_comment_by_task_read = (
	process_comment: ProcessComment
) => {
	return new Promise<ProcessComment[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_comment_inner_join bvpcij where bvpcij.id_task = ${process_comment.task} order by bvpcij.id_process_comment desc`;

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

export const view_process_comment_by_level_read = (
	process_comment: ProcessComment
) => {
	return new Promise<ProcessComment[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_comment_inner_join bvpcij where bvpcij.id_level = ${process_comment.level} order by bvpcij.id_process_comment desc`;

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

export const view_process_comment_specific_read = (
	process_comment: ProcessComment
) => {
	return new Promise<ProcessComment[]>(async (resolve, reject) => {
		const query = `select * from business.view_process_comment_inner_join bvpcij where bvpcij.id_process_comment = ${process_comment.id_process_comment}`;

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

export const dml_process_comment_update = (process_comment: ProcessComment) => {
	return new Promise<ProcessComment[]>(async (resolve, reject) => {
		const query = `select * from business.dml_process_comment_update_modified(${process_comment.id_user_},
			${process_comment.id_process_comment},
			${process_comment.official.id_official},
			${process_comment.process.id_process},
			${process_comment.task.id_task},
			${process_comment.level.id_level},
			'${process_comment.value_process_comment}',
			'${process_comment.date_process_comment}',
			${process_comment.deleted_process_comment})`;

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

export const dml_process_comment_delete = (process_comment: ProcessComment) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_process_comment_delete(${process_comment.id_user_},${process_comment.id_process_comment}) as result`;

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
