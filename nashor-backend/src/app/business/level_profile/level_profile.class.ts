import { Company } from '../../core/company/company.class';
import { _company } from '../../core/company/company.data';
import {
	dml_level_profile_create,
	dml_level_profile_delete,
	dml_level_profile_update,
	view_level_profile_by_company_query_read,
	view_level_profile_query_read,
	view_level_profile_specific_read,
} from './level_profile.store';

export class LevelProfile {
	/** Attributes */
	public id_user_?: number;
	public id_level_profile: number;
	public company: Company;
	public name_level_profile?: string;
	public description_level_profile?: string;
	public deleted_level_profile?: boolean;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_level_profile: number = 0,
		company: Company = _company,
		name_level_profile: string = '',
		description_level_profile: string = '',
		deleted_level_profile: boolean = false
	) {
		this.id_user_ = id_user_;
		this.id_level_profile = id_level_profile;
		this.company = company;
		this.name_level_profile = name_level_profile;
		this.description_level_profile = description_level_profile;
		this.deleted_level_profile = deleted_level_profile;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_level_profile(id_level_profile: number) {
		this.id_level_profile = id_level_profile;
	}
	get _id_level_profile() {
		return this.id_level_profile;
	}

	set _company(company: Company) {
		this.company = company;
	}
	get _company() {
		return this.company;
	}

	set _name_level_profile(name_level_profile: string) {
		this.name_level_profile = name_level_profile;
	}
	get _name_level_profile() {
		return this.name_level_profile!;
	}

	set _description_level_profile(description_level_profile: string) {
		this.description_level_profile = description_level_profile;
	}
	get _description_level_profile() {
		return this.description_level_profile!;
	}

	set _deleted_level_profile(deleted_level_profile: boolean) {
		this.deleted_level_profile = deleted_level_profile;
	}
	get _deleted_level_profile() {
		return this.deleted_level_profile!;
	}

	/** Methods */
	create() {
		return new Promise<LevelProfile>(async (resolve, reject) => {
			await dml_level_profile_create(this)
				.then((levelProfiles: LevelProfile[]) => {
					/**
					 * Mutate response
					 */
					const _levelProfiles = this.mutateResponse(levelProfiles);

					resolve(_levelProfiles[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	queryRead() {
		return new Promise<LevelProfile[]>(async (resolve, reject) => {
			await view_level_profile_query_read(this)
				.then((levelProfiles: LevelProfile[]) => {
					/**
					 * Mutate response
					 */
					const _levelProfiles = this.mutateResponse(levelProfiles);

					resolve(_levelProfiles);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byCompanyQueryRead() {
		return new Promise<LevelProfile[]>(async (resolve, reject) => {
			await view_level_profile_by_company_query_read(this)
				.then((levelProfiles: LevelProfile[]) => {
					/**
					 * Mutate response
					 */
					const _levelProfiles = this.mutateResponse(levelProfiles);

					resolve(_levelProfiles);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<LevelProfile>(async (resolve, reject) => {
			await view_level_profile_specific_read(this)
				.then((levelProfiles: LevelProfile[]) => {
					/**
					 * Mutate response
					 */
					const _levelProfiles = this.mutateResponse(levelProfiles);

					resolve(_levelProfiles[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<LevelProfile>(async (resolve, reject) => {
			await dml_level_profile_update(this)
				.then((levelProfiles: LevelProfile[]) => {
					/**
					 * Mutate response
					 */
					const _levelProfiles = this.mutateResponse(levelProfiles);

					resolve(_levelProfiles[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_level_profile_delete(this)
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
	 * @param levelProfiles
	 * @returns
	 */
	private mutateResponse(levelProfiles: LevelProfile[]): LevelProfile[] {
		let _levelProfiles: LevelProfile[] = [];

		levelProfiles.map((item: any) => {
			let _levelProfile: LevelProfile | any = {
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

			delete _levelProfile.id_company;
			delete _levelProfile.id_setting;
			delete _levelProfile.name_company;
			delete _levelProfile.acronym_company;
			delete _levelProfile.address_company;
			delete _levelProfile.status_company;

			_levelProfiles.push(_levelProfile);
		});

		return _levelProfiles;
	}
}
