import { Company } from '../../core/company/company.class';
import { _company } from '../../core/company/company.data';
import {
	dml_area_create,
	dml_area_delete,
	dml_area_update,
	view_area_by_company_query_read,
	view_area_query_read,
	view_area_specific_read,
} from './area.store';

export class Area {
	/** Attributes */
	public id_user_?: number;
	public id_area: number;
	public company: Company;
	public name_area?: string;
	public description_area?: string;
	public deleted_area?: boolean;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_area: number = 0,
		company: Company = _company,
		name_area: string = '',
		description_area: string = '',
		deleted_area: boolean = false
	) {
		this.id_user_ = id_user_;
		this.id_area = id_area;
		this.company = company;
		this.name_area = name_area;
		this.description_area = description_area;
		this.deleted_area = deleted_area;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_area(id_area: number) {
		this.id_area = id_area;
	}
	get _id_area() {
		return this.id_area;
	}

	set _company(company: Company) {
		this.company = company;
	}
	get _company() {
		return this.company;
	}

	set _name_area(name_area: string) {
		this.name_area = name_area;
	}
	get _name_area() {
		return this.name_area!;
	}

	set _description_area(description_area: string) {
		this.description_area = description_area;
	}
	get _description_area() {
		return this.description_area!;
	}

	set _deleted_area(deleted_area: boolean) {
		this.deleted_area = deleted_area;
	}
	get _deleted_area() {
		return this.deleted_area!;
	}

	/** Methods */
	create() {
		return new Promise<Area>(async (resolve, reject) => {
			await dml_area_create(this)
				.then((areas: Area[]) => {
					/**
					 * Mutate response
					 */
					const _areas = this.mutateResponse(areas);

					resolve(_areas[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	queryRead() {
		return new Promise<Area[]>(async (resolve, reject) => {
			await view_area_query_read(this)
				.then((areas: Area[]) => {
					/**
					 * Mutate response
					 */
					const _areas = this.mutateResponse(areas);

					resolve(_areas);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byCompanyQueryRead() {
		return new Promise<Area[]>(async (resolve, reject) => {
			await view_area_by_company_query_read(this)
				.then((areas: Area[]) => {
					/**
					 * Mutate response
					 */
					const _areas = this.mutateResponse(areas);

					resolve(_areas);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<Area>(async (resolve, reject) => {
			await view_area_specific_read(this)
				.then((areas: Area[]) => {
					/**
					 * Mutate response
					 */
					const _areas = this.mutateResponse(areas);

					resolve(_areas[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<Area>(async (resolve, reject) => {
			await dml_area_update(this)
				.then((areas: Area[]) => {
					/**
					 * Mutate response
					 */
					const _areas = this.mutateResponse(areas);

					resolve(_areas[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_area_delete(this)
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
	 * @param areas
	 * @returns
	 */
	private mutateResponse(areas: Area[]): Area[] {
		let _areas: Area[] = [];

		areas.map((item: any) => {
			let _area: Area | any = {
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

			delete _area.id_company;
			delete _area.id_setting;
			delete _area.name_company;
			delete _area.acronym_company;
			delete _area.address_company;
			delete _area.status_company;

			_areas.push(_area);
		});

		return _areas;
	}
}
