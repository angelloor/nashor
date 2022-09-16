import { clientNASHORPostgreSQL } from '../../../../utils/conections';
import { _messages } from '../../../../utils/message/message';
import { DocumentationProfileAttached } from './documentation_profile_attached.class';

export const dml_documentation_profile_attached_create = (
	documentation_profile_attached: DocumentationProfileAttached
) => {
	return new Promise<DocumentationProfileAttached[]>(
		async (resolve, reject) => {
			const query = `select * from business.dml_documentation_profile_attached_create_modified(${documentation_profile_attached.id_user_}, ${documentation_profile_attached.documentation_profile.id_documentation_profile})`;

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
		}
	);
};

export const view_documentation_profile_attached_by_documentation_profile_read =
	(documentation_profile_attached: DocumentationProfileAttached) => {
		return new Promise<DocumentationProfileAttached[]>(
			async (resolve, reject) => {
				const query = `select * from business.view_documentation_profile_attached_inner_join bvdpaij where bvdpaij.id_documentation_profile = ${documentation_profile_attached.documentation_profile}`;

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
			}
		);
	};

export const view_documentation_profile_attached_by_attached_read = (
	documentation_profile_attached: DocumentationProfileAttached
) => {
	return new Promise<DocumentationProfileAttached[]>(
		async (resolve, reject) => {
			const query = `select * from business.view_documentation_profile_attached_inner_join bvdpaij where bvdpaij.id_attached = ${documentation_profile_attached.attached}`;

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
		}
	);
};

export const view_documentation_profile_attached_specific_read = (
	documentation_profile_attached: DocumentationProfileAttached
) => {
	return new Promise<DocumentationProfileAttached[]>(
		async (resolve, reject) => {
			const query = `select * from business.view_documentation_profile_attached_inner_join bvdpaij where bvdpaij.id_documentation_profile_attached = ${documentation_profile_attached.id_documentation_profile_attached}`;

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
		}
	);
};

export const dml_documentation_profile_attached_update = (
	documentation_profile_attached: DocumentationProfileAttached
) => {
	return new Promise<DocumentationProfileAttached[]>(
		async (resolve, reject) => {
			const query = `select * from business.dml_documentation_profile_attached_update_modified(${documentation_profile_attached.id_user_},
			${documentation_profile_attached.id_documentation_profile_attached},
			${documentation_profile_attached.documentation_profile.id_documentation_profile},
			${documentation_profile_attached.attached.id_attached})`;

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
		}
	);
};

export const dml_documentation_profile_attached_delete = (
	documentation_profile_attached: DocumentationProfileAttached
) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_documentation_profile_attached_delete(${documentation_profile_attached.id_user_},${documentation_profile_attached.id_documentation_profile_attached}) as result`;

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
