import { Company } from '../../core/company/company.class';
import { _company } from '../../core/company/company.data';
import {
	dml_attached_create,
	dml_attached_delete,
	dml_attached_update,
	view_attached_by_company_query_read,
	view_attached_query_read,
	view_attached_specific_read,
} from './attached.store';

export class Attached {
	/** Attributes */
	public id_user_?: number;
	public id_attached: number;
	public company: Company;
	public name_attached?: string;
	public description_attached?: string;
	public length_mb_attached?: number;
	public required_attached?: boolean;
	public deleted_attached?: boolean;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_attached: number = 0,
		company: Company = _company,
		name_attached: string = '',
		description_attached: string = '',
		length_mb_attached: number = 0,
		required_attached: boolean = false,
		deleted_attached: boolean = false
	) {
		this.id_user_ = id_user_;
		this.id_attached = id_attached;
		this.company = company;
		this.name_attached = name_attached;
		this.description_attached = description_attached;
		this.length_mb_attached = length_mb_attached;
		this.required_attached = required_attached;
		this.deleted_attached = deleted_attached;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_attached(id_attached: number) {
		this.id_attached = id_attached;
	}
	get _id_attached() {
		return this.id_attached;
	}

	set _company(company: Company) {
		this.company = company;
	}
	get _company() {
		return this.company;
	}

	set _name_attached(name_attached: string) {
		this.name_attached = name_attached;
	}
	get _name_attached() {
		return this.name_attached!;
	}

	set _description_attached(description_attached: string) {
		this.description_attached = description_attached;
	}
	get _description_attached() {
		return this.description_attached!;
	}

	set _length_mb_attached(length_mb_attached: number) {
		this.length_mb_attached = length_mb_attached;
	}
	get _length_mb_attached() {
		return this.length_mb_attached!;
	}

	set _required_attached(required_attached: boolean) {
		this.required_attached = required_attached;
	}
	get _required_attached() {
		return this.required_attached!;
	}

	set _deleted_attached(deleted_attached: boolean) {
		this.deleted_attached = deleted_attached;
	}
	get _deleted_attached() {
		return this.deleted_attached!;
	}

	/** Methods */
	create() {
		return new Promise<Attached>(async (resolve, reject) => {
			await dml_attached_create(this)
				.then((attacheds: Attached[]) => {
					/**
					 * Mutate response
					 */
					const _attacheds = this.mutateResponse(attacheds);

					resolve(_attacheds[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	queryRead() {
		return new Promise<Attached[]>(async (resolve, reject) => {
			await view_attached_query_read(this)
				.then((attacheds: Attached[]) => {
					/**
					 * Mutate response
					 */
					const _attacheds = this.mutateResponse(attacheds);

					resolve(_attacheds);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byCompanyQueryRead() {
		return new Promise<Attached[]>(async (resolve, reject) => {
			await view_attached_by_company_query_read(this)
				.then((attacheds: Attached[]) => {
					/**
					 * Mutate response
					 */
					const _attacheds = this.mutateResponse(attacheds);

					resolve(_attacheds);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<Attached>(async (resolve, reject) => {
			await view_attached_specific_read(this)
				.then((attacheds: Attached[]) => {
					/**
					 * Mutate response
					 */
					const _attacheds = this.mutateResponse(attacheds);

					resolve(_attacheds[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<Attached>(async (resolve, reject) => {
			await dml_attached_update(this)
				.then((attacheds: Attached[]) => {
					/**
					 * Mutate response
					 */
					const _attacheds = this.mutateResponse(attacheds);

					resolve(_attacheds[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_attached_delete(this)
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
	 * @param attacheds
	 * @returns
	 */
	private mutateResponse(attacheds: Attached[]): Attached[] {
		let _attacheds: Attached[] = [];

		attacheds.map((item: any) => {
			let _attached: Attached | any = {
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

			delete _attached.id_company;
			delete _attached.id_setting;
			delete _attached.name_company;
			delete _attached.acronym_company;
			delete _attached.address_company;
			delete _attached.status_company;

			_attacheds.push(_attached);
		});

		return _attacheds;
	}
}
