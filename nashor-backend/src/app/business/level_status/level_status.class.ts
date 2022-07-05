import { Company } from '../../core/company/company.class';
import { _company } from '../../core/company/company.data';
import {
	dml_level_status_create,
	dml_level_status_delete,
	dml_level_status_update,
	view_level_status_by_company_query_read,
	view_level_status_query_read,
	view_level_status_specific_read
} from './level_status.store';

export class LevelStatus {
	/** Attributes */
	public id_user_?: number;
	public id_level_status: number;
	public company: Company;
	public name_level_status?: string;
	public description_level_status?: string;
	public color_level_status?: string;
	public deleted_level_status?: boolean;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_level_status: number = 0,
		company: Company = _company,
		name_level_status: string = '',
		description_level_status: string = '',
		color_level_status: string = '',
		deleted_level_status: boolean = false
	) {
		this.id_user_ = id_user_;
		this.id_level_status = id_level_status;
		this.company = company;
		this.name_level_status = name_level_status;
		this.description_level_status = description_level_status;
		this.color_level_status = color_level_status;
		this.deleted_level_status = deleted_level_status;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_level_status(id_level_status: number) {
		this.id_level_status = id_level_status;
	}
	get _id_level_status() {
		return this.id_level_status;
	}

	set _company(company: Company) {
		this.company = company;
	}
	get _company() {
		return this.company;
	}

	set _name_level_status(name_level_status: string) {
		this.name_level_status = name_level_status;
	}
	get _name_level_status() {
		return this.name_level_status!;
	}

	set _description_level_status(description_level_status: string) {
		this.description_level_status = description_level_status;
	}
	get _description_level_status() {
		return this.description_level_status!;
	}

	set _color_level_status(color_level_status: string) {
		this.color_level_status = color_level_status;
	}
	get _color_level_status() {
		return this.color_level_status!;
	}

	set _deleted_level_status(deleted_level_status: boolean) {
		this.deleted_level_status = deleted_level_status;
	}
	get _deleted_level_status() {
		return this.deleted_level_status!;
	}

	/** Methods */
	create() {
		return new Promise<LevelStatus>(async (resolve, reject) => {
			await dml_level_status_create(this)
				.then((levelStatuss: LevelStatus[]) => {
					/**
					 * Mutate response
					 */
					const _levelStatuss = this.mutateResponse(levelStatuss);

					resolve(_levelStatuss[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	queryRead() {
		return new Promise<LevelStatus[]>(async (resolve, reject) => {
			await view_level_status_query_read(this)
				.then((levelStatuss: LevelStatus[]) => {
					/**
					 * Mutate response
					 */
					const _levelStatuss = this.mutateResponse(levelStatuss);

					resolve(_levelStatuss);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byCompanyQueryRead() {
		return new Promise<LevelStatus[]>(async (resolve, reject) => {
			await view_level_status_by_company_query_read(this)
				.then((levelStatuss: LevelStatus[]) => {
					/**
					 * Mutate response
					 */
					const _levelStatuss = this.mutateResponse(levelStatuss);

					resolve(_levelStatuss);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<LevelStatus>(async (resolve, reject) => {
			await view_level_status_specific_read(this)
				.then((levelStatuss: LevelStatus[]) => {
					/**
					 * Mutate response
					 */
					const _levelStatuss = this.mutateResponse(levelStatuss);

					resolve(_levelStatuss[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<LevelStatus>(async (resolve, reject) => {
			await dml_level_status_update(this)
				.then((levelStatuss: LevelStatus[]) => {
					/**
					 * Mutate response
					 */
					const _levelStatuss = this.mutateResponse(levelStatuss);

					resolve(_levelStatuss[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_level_status_delete(this)
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
	 * @param levelStatuss
	 * @returns
	 */
	private mutateResponse(levelStatuss: LevelStatus[]): LevelStatus[] {
		let _levelStatuss: LevelStatus[] = [];

		levelStatuss.map((item: any) => {
			let _levelStatus: LevelStatus | any = {
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

			delete _levelStatus.id_company;
			delete _levelStatus.id_setting;
			delete _levelStatus.name_company;
			delete _levelStatus.acronym_company;
			delete _levelStatus.address_company;
			delete _levelStatus.status_company;

			_levelStatuss.push(_levelStatus);
		});

		return _levelStatuss;
	}
}
