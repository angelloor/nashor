import { Company } from '../../core/company/company.class';
import { _company } from '../../core/company/company.data';
import {
	dml_documentation_profile_create,
	dml_documentation_profile_delete,
	dml_documentation_profile_update,
	view_documentation_profile_by_company_query_read,
	view_documentation_profile_query_read,
	view_documentation_profile_specific_read,
} from './documentation_profile.store';

export class DocumentationProfile {
	/** Attributes */
	public id_user_?: number;
	public id_documentation_profile: number;
	public company: Company;
	public name_documentation_profile?: string;
	public description_documentation_profile?: string;
	public status_documentation_profile?: boolean;
	public deleted_documentation_profile?: boolean;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_documentation_profile: number = 0,
		company: Company = _company,
		name_documentation_profile: string = '',
		description_documentation_profile: string = '',
		status_documentation_profile: boolean = false,
		deleted_documentation_profile: boolean = false
	) {
		this.id_user_ = id_user_;
		this.id_documentation_profile = id_documentation_profile;
		this.company = company;
		this.name_documentation_profile = name_documentation_profile;
		this.description_documentation_profile = description_documentation_profile;
		this.status_documentation_profile = status_documentation_profile;
		this.deleted_documentation_profile = deleted_documentation_profile;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_documentation_profile(id_documentation_profile: number) {
		this.id_documentation_profile = id_documentation_profile;
	}
	get _id_documentation_profile() {
		return this.id_documentation_profile;
	}

	set _company(company: Company) {
		this.company = company;
	}
	get _company() {
		return this.company;
	}

	set _name_documentation_profile(name_documentation_profile: string) {
		this.name_documentation_profile = name_documentation_profile;
	}
	get _name_documentation_profile() {
		return this.name_documentation_profile!;
	}

	set _description_documentation_profile(
		description_documentation_profile: string
	) {
		this.description_documentation_profile = description_documentation_profile;
	}
	get _description_documentation_profile() {
		return this.description_documentation_profile!;
	}

	set _status_documentation_profile(status_documentation_profile: boolean) {
		this.status_documentation_profile = status_documentation_profile;
	}
	get _status_documentation_profile() {
		return this.status_documentation_profile!;
	}

	set _deleted_documentation_profile(deleted_documentation_profile: boolean) {
		this.deleted_documentation_profile = deleted_documentation_profile;
	}
	get _deleted_documentation_profile() {
		return this.deleted_documentation_profile!;
	}

	/** Methods */
	create() {
		return new Promise<DocumentationProfile>(async (resolve, reject) => {
			await dml_documentation_profile_create(this)
				.then((documentationProfiles: DocumentationProfile[]) => {
					/**
					 * Mutate response
					 */
					const _documentationProfiles = this.mutateResponse(
						documentationProfiles
					);

					resolve(_documentationProfiles[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	queryRead() {
		return new Promise<DocumentationProfile[]>(async (resolve, reject) => {
			await view_documentation_profile_query_read(this)
				.then((documentationProfiles: DocumentationProfile[]) => {
					/**
					 * Mutate response
					 */
					const _documentationProfiles = this.mutateResponse(
						documentationProfiles
					);

					resolve(_documentationProfiles);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byCompanyQueryRead() {
		return new Promise<DocumentationProfile[]>(async (resolve, reject) => {
			await view_documentation_profile_by_company_query_read(this)
				.then((documentationProfiles: DocumentationProfile[]) => {
					/**
					 * Mutate response
					 */
					const _documentationProfiles = this.mutateResponse(
						documentationProfiles
					);

					resolve(_documentationProfiles);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<DocumentationProfile>(async (resolve, reject) => {
			await view_documentation_profile_specific_read(this)
				.then((documentationProfiles: DocumentationProfile[]) => {
					/**
					 * Mutate response
					 */
					const _documentationProfiles = this.mutateResponse(
						documentationProfiles
					);

					resolve(_documentationProfiles[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<DocumentationProfile>(async (resolve, reject) => {
			await dml_documentation_profile_update(this)
				.then((documentationProfiles: DocumentationProfile[]) => {
					/**
					 * Mutate response
					 */
					const _documentationProfiles = this.mutateResponse(
						documentationProfiles
					);

					resolve(_documentationProfiles[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_documentation_profile_delete(this)
				.then((response: boolean) => {
					resolve(response);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	/**
	 * Eliminar ids de entidades externas y formatear la informacion en el esquema correspondiente
	 * @param documentationProfiles
	 * @returns
	 */
	private mutateResponse(
		documentationProfiles: DocumentationProfile[]
	): DocumentationProfile[] {
		let _documentationProfiles: DocumentationProfile[] = [];

		documentationProfiles.map((item: any) => {
			let _documentationProfile: DocumentationProfile | any = {
				...item,
				company: {
					id_company: item.id_company,
					setting: { id_setting: item.id_setting },
					name_company: item.name_company,
					acronym_company: item.acronym_company,
					address_company: item.address_company,
					status_company: item.status_company,
				},
				/**
				 * Generate structure of second level the entity (is important add the ids of entity)
				 * similar the return of read
				 */
			};
			/**
			 * delete ids of principal object level
			 */

			delete _documentationProfile.id_company;
			delete _documentationProfile.id_setting;
			delete _documentationProfile.name_company;
			delete _documentationProfile.acronym_company;
			delete _documentationProfile.address_company;
			delete _documentationProfile.status_company;

			_documentationProfiles.push(_documentationProfile);
		});

		return _documentationProfiles;
	}
}
