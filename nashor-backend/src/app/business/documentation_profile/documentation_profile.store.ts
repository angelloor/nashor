import { clientNASHORPostgreSQL } from '../../../utils/conections';
import { _messages } from '../../../utils/message/message';
import { DocumentationProfile } from './documentation_profile.class';

export const dml_documentation_profile_create = (
	documentation_profile: DocumentationProfile
) => {
	return new Promise<DocumentationProfile[]>(async (resolve, reject) => {
		const query = `select * from business.dml_documentation_profile_create_modified(${documentation_profile.id_user_}, ${documentation_profile.company.id_company})`;

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

export const view_documentation_profile_query_read = (
	documentation_profile: DocumentationProfile
) => {
	return new Promise<DocumentationProfile[]>(async (resolve, reject) => {
		const query = `select * from business.view_documentation_profile_inner_join bvdpij${
			documentation_profile.name_documentation_profile != '*'
				? ` where lower(bvdpij.name_documentation_profile) LIKE '%${documentation_profile.name_documentation_profile}%'`
				: ``
		} order by bvdpij.id_documentation_profile desc`;

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

export const view_documentation_profile_by_company_query_read = (
	documentation_profile: DocumentationProfile
) => {
	return new Promise<DocumentationProfile[]>(async (resolve, reject) => {
		const query = `select * from business.view_documentation_profile_inner_join bvdpij${
			documentation_profile.name_documentation_profile != '*'
				? ` where lower(bvdpij.name_documentation_profile) LIKE '%${documentation_profile.name_documentation_profile}%' and bvdpij.id_company = ${documentation_profile.company}`
				: ` where bvdpij.id_company = ${documentation_profile.company}`
		} order by bvdpij.id_documentation_profile desc`;

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

export const view_documentation_profile_specific_read = (
	documentation_profile: DocumentationProfile
) => {
	return new Promise<DocumentationProfile[]>(async (resolve, reject) => {
		const query = `select * from business.view_documentation_profile_inner_join bvdpij where bvdpij.id_documentation_profile = ${documentation_profile.id_documentation_profile}`;

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

export const dml_documentation_profile_update = (
	documentation_profile: DocumentationProfile
) => {
	return new Promise<DocumentationProfile[]>(async (resolve, reject) => {
		const query = `select * from business.dml_documentation_profile_update_modified(${documentation_profile.id_user_},
			${documentation_profile.id_documentation_profile},
			${documentation_profile.company.id_company},
			'${documentation_profile.name_documentation_profile}',
			'${documentation_profile.description_documentation_profile}',
			${documentation_profile.status_documentation_profile},
			${documentation_profile.deleted_documentation_profile})`;

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

export const dml_documentation_profile_delete = (
	documentation_profile: DocumentationProfile
) => {
	return new Promise<boolean>(async (resolve, reject) => {
		const query = `select * from business.dml_documentation_profile_delete_modified(${documentation_profile.id_user_},${documentation_profile.id_documentation_profile}) as result`;

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
