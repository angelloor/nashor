import { LevelProfile } from '../level_profile/level_profile.class';
import { _levelProfile } from '../level_profile/level_profile.data';
import { Official } from '../official/official.class';
import { _official } from '../official/official.data';
import {
	dml_level_profile_official_create,
	dml_level_profile_official_delete,
	dml_level_profile_official_update,
	view_level_profile_official_by_level_profile_read,
	view_level_profile_official_specific_read,
} from './level_profile_official.store';

export class LevelProfileOfficial {
	/** Attributes */
	public id_user_?: number;
	public id_level_profile_official: number;
	public level_profile: LevelProfile;
	public official: Official;
	public official_modifier?: boolean;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_level_profile_official: number = 0,
		level_profile: LevelProfile = _levelProfile,
		official: Official = _official,
		official_modifier: boolean = false
	) {
		this.id_user_ = id_user_;
		this.id_level_profile_official = id_level_profile_official;
		this.level_profile = level_profile;
		this.official = official;
		this.official_modifier = official_modifier;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_level_profile_official(id_level_profile_official: number) {
		this.id_level_profile_official = id_level_profile_official;
	}
	get _id_level_profile_official() {
		return this.id_level_profile_official;
	}

	set _level_profile(level_profile: LevelProfile) {
		this.level_profile = level_profile;
	}
	get _level_profile() {
		return this.level_profile;
	}

	set _official(official: Official) {
		this.official = official;
	}
	get _official() {
		return this.official;
	}

	set _official_modifier(official_modifier: boolean) {
		this.official_modifier = official_modifier;
	}
	get _official_modifier() {
		return this.official_modifier!;
	}

	/** Methods */
	create() {
		return new Promise<LevelProfileOfficial>(async (resolve, reject) => {
			await dml_level_profile_official_create(this)
				.then((levelProfileOfficials: LevelProfileOfficial[]) => {
					/**
					 * Mutate response
					 */
					const _levelProfileOfficials = this.mutateResponse(
						levelProfileOfficials
					);

					resolve(_levelProfileOfficials[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byLevelProfileRead() {
		return new Promise<LevelProfileOfficial[]>(async (resolve, reject) => {
			await view_level_profile_official_by_level_profile_read(this)
				.then((levelProfileOfficials: LevelProfileOfficial[]) => {
					/**
					 * Mutate response
					 */
					const _levelProfileOfficials = this.mutateResponse(
						levelProfileOfficials
					);

					resolve(_levelProfileOfficials);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<LevelProfileOfficial>(async (resolve, reject) => {
			await view_level_profile_official_specific_read(this)
				.then((levelProfileOfficials: LevelProfileOfficial[]) => {
					/**
					 * Mutate response
					 */
					const _levelProfileOfficials = this.mutateResponse(
						levelProfileOfficials
					);

					resolve(_levelProfileOfficials[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<LevelProfileOfficial>(async (resolve, reject) => {
			await dml_level_profile_official_update(this)
				.then((levelProfileOfficials: LevelProfileOfficial[]) => {
					/**
					 * Mutate response
					 */
					const _levelProfileOfficials = this.mutateResponse(
						levelProfileOfficials
					);

					resolve(_levelProfileOfficials[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_level_profile_official_delete(this)
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
	 * @param levelProfileOfficials
	 * @returns
	 */
	private mutateResponse(
		levelProfileOfficials: LevelProfileOfficial[]
	): LevelProfileOfficial[] {
		let _levelProfileOfficials: LevelProfileOfficial[] = [];

		levelProfileOfficials.map((item: any) => {
			let _levelProfileOfficial: LevelProfileOfficial | any = {
				...item,
				level_profile: {
					id_level_profile: item.id_level_profile,
					company: { id_company: item.id_company },
					name_level_profile: item.name_level_profile,
					description_level_profile: item.description_level_profile,
				},
				official: {
					id_official: item.id_official,
					company: { id_company: item.id_company },
					user: {
						id_user: item.id_user,
						person: {
							id_person: item.id_person,
							academic: {
								id_academic: item.id_academic,
							},
							job: {
								id_job: item.id_job,
							},
							dni_person: item.dni_person,
							name_person: item.name_person,
							last_name_person: item.last_name_person,
							address_person: item.address_person,
							phone_person: item.phone_person,
						},
						type_user: {
							id_type_user: item.id_type_user,
						},
						name_user: item.name_user,
						password_user: item.password_user,
						avatar_user: item.avatar_user,
						status_user: item.status_user,
					},
					area: { id_area: item.id_area },
					position: { id_position: item.id_position },
				},
				/**
				 * Generate structure of second level the entity (is important add the ids of entity)
				 * similar the return of read
				 */
			};
			/**
			 * delete ids of principal object level
			 */

			delete _levelProfileOfficial.id_level_profile;
			delete _levelProfileOfficial.id_company;
			delete _levelProfileOfficial.name_level_profile;
			delete _levelProfileOfficial.description_level_profile;
			delete _levelProfileOfficial.id_official;
			delete _levelProfileOfficial.id_company;
			delete _levelProfileOfficial.id_user;
			delete _levelProfileOfficial.id_area;
			delete _levelProfileOfficial.id_position;

			delete _levelProfileOfficial.id_person;
			delete _levelProfileOfficial.id_profile;
			delete _levelProfileOfficial.type_user;
			delete _levelProfileOfficial.name_user;
			delete _levelProfileOfficial.password_user;
			delete _levelProfileOfficial.avatar_user;
			delete _levelProfileOfficial.status_user;

			delete _levelProfileOfficial.id_academic;
			delete _levelProfileOfficial.id_job;
			delete _levelProfileOfficial.dni_person;
			delete _levelProfileOfficial.name_person;
			delete _levelProfileOfficial.last_name_person;
			delete _levelProfileOfficial.address_person;
			delete _levelProfileOfficial.phone_person;

			_levelProfileOfficials.push(_levelProfileOfficial);
		});

		return _levelProfileOfficials;
	}
}
