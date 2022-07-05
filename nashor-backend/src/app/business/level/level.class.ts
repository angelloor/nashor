import { Company } from '../../core/company/company.class';
import { _company } from '../../core/company/company.data';
import { LevelProfile } from '../level_profile/level_profile.class';
import { _levelProfile } from '../level_profile/level_profile.data';
import { LevelStatus } from '../level_status/level_status.class';
import { _levelStatus } from '../level_status/level_status.data';
import { Template } from '../template/template.class';
import { _template } from '../template/template.data';
import {
	dml_level_create,
	dml_level_delete,
	dml_level_update,
	view_level_by_company_query_read,
	view_level_by_level_profile_query_read,
	view_level_by_level_status_query_read,
	view_level_by_template_query_read,
	view_level_query_read,
	view_level_specific_read,
} from './level.store';

export class Level {
	/** Attributes */
	public id_user_?: number;
	public id_level: number;
	public company: Company;
	public template: Template;
	public level_profile: LevelProfile;
	public level_status: LevelStatus;
	public name_level?: string;
	public description_level?: string;
	public deleted_level?: boolean;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_level: number = 0,
		company: Company = _company,
		template: Template = _template,
		level_profile: LevelProfile = _levelProfile,
		level_status: LevelStatus = _levelStatus,
		name_level: string = '',
		description_level: string = '',
		deleted_level: boolean = false
	) {
		this.id_user_ = id_user_;
		this.id_level = id_level;
		this.company = company;
		this.template = template;
		this.level_profile = level_profile;
		this.level_status = level_status;
		this.name_level = name_level;
		this.description_level = description_level;
		this.deleted_level = deleted_level;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_level(id_level: number) {
		this.id_level = id_level;
	}
	get _id_level() {
		return this.id_level;
	}

	set _company(company: Company) {
		this.company = company;
	}
	get _company() {
		return this.company;
	}

	set _template(template: Template) {
		this.template = template;
	}
	get _template() {
		return this.template;
	}

	set _level_profile(level_profile: LevelProfile) {
		this.level_profile = level_profile;
	}
	get _level_profile() {
		return this.level_profile;
	}

	set _level_status(level_status: LevelStatus) {
		this.level_status = level_status;
	}
	get _level_status() {
		return this.level_status;
	}

	set _name_level(name_level: string) {
		this.name_level = name_level;
	}
	get _name_level() {
		return this.name_level!;
	}

	set _description_level(description_level: string) {
		this.description_level = description_level;
	}
	get _description_level() {
		return this.description_level!;
	}

	set _deleted_level(deleted_level: boolean) {
		this.deleted_level = deleted_level;
	}
	get _deleted_level() {
		return this.deleted_level!;
	}

	/** Methods */
	create() {
		return new Promise<Level>(async (resolve, reject) => {
			await dml_level_create(this)
				.then((levels: Level[]) => {
					/**
					 * Mutate response
					 */
					const _levels = this.mutateResponse(levels);

					resolve(_levels[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	queryRead() {
		return new Promise<Level[]>(async (resolve, reject) => {
			await view_level_query_read(this)
				.then((levels: Level[]) => {
					/**
					 * Mutate response
					 */
					const _levels = this.mutateResponse(levels);

					resolve(_levels);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byCompanyQueryRead() {
		return new Promise<Level[]>(async (resolve, reject) => {
			await view_level_by_company_query_read(this)
				.then((levels: Level[]) => {
					/**
					 * Mutate response
					 */
					const _levels = this.mutateResponse(levels);

					resolve(_levels);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byTemplateQueryRead() {
		return new Promise<Level[]>(async (resolve, reject) => {
			await view_level_by_template_query_read(this)
				.then((levels: Level[]) => {
					/**
					 * Mutate response
					 */
					const _levels = this.mutateResponse(levels);

					resolve(_levels);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byLevelProfileQueryRead() {
		return new Promise<Level[]>(async (resolve, reject) => {
			await view_level_by_level_profile_query_read(this)
				.then((levels: Level[]) => {
					/**
					 * Mutate response
					 */
					const _levels = this.mutateResponse(levels);

					resolve(_levels);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byLevelStatusQueryRead() {
		return new Promise<Level[]>(async (resolve, reject) => {
			await view_level_by_level_status_query_read(this)
				.then((levels: Level[]) => {
					/**
					 * Mutate response
					 */
					const _levels = this.mutateResponse(levels);

					resolve(_levels);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<Level>(async (resolve, reject) => {
			await view_level_specific_read(this)
				.then((levels: Level[]) => {
					/**
					 * Mutate response
					 */
					const _levels = this.mutateResponse(levels);

					resolve(_levels[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<Level>(async (resolve, reject) => {
			await dml_level_update(this)
				.then((levels: Level[]) => {
					/**
					 * Mutate response
					 */
					const _levels = this.mutateResponse(levels);

					resolve(_levels[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_level_delete(this)
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
	 * @param levels
	 * @returns
	 */
	private mutateResponse(levels: Level[]): Level[] {
		let _levels: Level[] = [];

		levels.map((item: any) => {
			let _level: Level | any = {
				...item,
				company: {
					id_company: item.id_company,
					setting: { id_setting: item.id_setting },
					name_company: item.name_company,
					acronym_company: item.acronym_company,
					address_company: item.address_company,
					status_company: item.status_company,
				},
				template: {
					id_template: item.id_template,
					company: { id_company: item.id_company },
					documentation_profile: {
						id_documentation_profile: item.id_documentation_profile,
					},
					plugin_item_process: item.plugin_item_process,
					plugin_attached_process: item.plugin_attached_process,
					name_template: item.name_template,
					description_template: item.description_template,
					status_template: item.status_template,
					last_change: item.last_change,
					in_use: item.in_use,
				},
				level_profile: {
					id_level_profile: item.id_level_profile,
					company: { id_company: item.id_company },
					name_level_profile: item.name_level_profile,
					description_level_profile: item.description_level_profile,
				},
				level_status: {
					id_level_status: item.id_level_status,
					company: { id_company: item.id_company },
					name_level_status: item.name_level_status,
					description_level_status: item.description_level_status,
					color_level_status: item.color_level_status,
				},
				/**
				 * Generate structure of second level the entity (is important add the ids of entity)
				 * similar the return of read
				 */
			};
			/**
			 * delete ids of principal object level
			 */

			delete _level.id_company;
			delete _level.id_setting;
			delete _level.name_company;
			delete _level.acronym_company;
			delete _level.address_company;
			delete _level.status_company;
			delete _level.id_template;
			delete _level.id_company;
			delete _level.id_documentation_profile;
			delete _level.plugin_item_process;
			delete _level.plugin_attached_process;
			delete _level.name_template;
			delete _level.description_template;
			delete _level.status_template;
			delete _level.last_change;
			delete _level.in_use;
			delete _level.id_level_profile;
			delete _level.id_company;
			delete _level.name_level_profile;
			delete _level.description_level_profile;
			delete _level.id_level_status;
			delete _level.id_company;
			delete _level.name_level_status;
			delete _level.description_level_status;
			delete _level.color_level_status;

			_levels.push(_level);
		});

		return _levels;
	}
}
