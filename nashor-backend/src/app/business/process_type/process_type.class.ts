import { Company } from '../../core/company/company.class';
import { _company } from '../../core/company/company.data';
import {
	dml_process_type_create,
	dml_process_type_delete,
	dml_process_type_update,
	view_process_type_by_company_query_read,
	view_process_type_query_read,
	view_process_type_specific_read,
} from './process_type.store';

export class ProcessType {
	/** Attributes */
	public id_user_?: number;
	public id_process_type: number;
	public company: Company;
	public name_process_type?: string;
	public description_process_type?: string;
	public acronym_process_type?: string;
	public sequential_process_type?: number;
	public deleted_process_type?: boolean;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_process_type: number = 0,
		company: Company = _company,
		name_process_type: string = '',
		description_process_type: string = '',
		acronym_process_type: string = '',
		sequential_process_type: number = 0,
		deleted_process_type: boolean = false
	) {
		this.id_user_ = id_user_;
		this.id_process_type = id_process_type;
		this.company = company;
		this.name_process_type = name_process_type;
		this.description_process_type = description_process_type;
		this.acronym_process_type = acronym_process_type;
		this.sequential_process_type = sequential_process_type;
		this.deleted_process_type = deleted_process_type;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_process_type(id_process_type: number) {
		this.id_process_type = id_process_type;
	}
	get _id_process_type() {
		return this.id_process_type;
	}

	set _company(company: Company) {
		this.company = company;
	}
	get _company() {
		return this.company;
	}

	set _name_process_type(name_process_type: string) {
		this.name_process_type = name_process_type;
	}
	get _name_process_type() {
		return this.name_process_type!;
	}

	set _description_process_type(description_process_type: string) {
		this.description_process_type = description_process_type;
	}
	get _description_process_type() {
		return this.description_process_type!;
	}

	set _acronym_process_type(acronym_process_type: string) {
		this.acronym_process_type = acronym_process_type;
	}
	get _acronym_process_type() {
		return this.acronym_process_type!;
	}

	set _sequential_process_type(sequential_process_type: number) {
		this.sequential_process_type = sequential_process_type;
	}
	get _sequential_process_type() {
		return this.sequential_process_type!;
	}

	set _deleted_process_type(deleted_process_type: boolean) {
		this.deleted_process_type = deleted_process_type;
	}
	get _deleted_process_type() {
		return this.deleted_process_type!;
	}

	/** Methods */
	create() {
		return new Promise<ProcessType>(async (resolve, reject) => {
			await dml_process_type_create(this)
				.then((processTypes: ProcessType[]) => {
					/**
					 * Mutate response
					 */
					const _processTypes = this.mutateResponse(processTypes);

					resolve(_processTypes[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	queryRead() {
		return new Promise<ProcessType[]>(async (resolve, reject) => {
			await view_process_type_query_read(this)
				.then((processTypes: ProcessType[]) => {
					/**
					 * Mutate response
					 */
					const _processTypes = this.mutateResponse(processTypes);

					resolve(_processTypes);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byCompanyQueryRead() {
		return new Promise<ProcessType[]>(async (resolve, reject) => {
			await view_process_type_by_company_query_read(this)
				.then((processTypes: ProcessType[]) => {
					/**
					 * Mutate response
					 */
					const _processTypes = this.mutateResponse(processTypes);

					resolve(_processTypes);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<ProcessType>(async (resolve, reject) => {
			await view_process_type_specific_read(this)
				.then((processTypes: ProcessType[]) => {
					/**
					 * Mutate response
					 */
					const _processTypes = this.mutateResponse(processTypes);

					resolve(_processTypes[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<ProcessType>(async (resolve, reject) => {
			await dml_process_type_update(this)
				.then((processTypes: ProcessType[]) => {
					/**
					 * Mutate response
					 */
					const _processTypes = this.mutateResponse(processTypes);

					resolve(_processTypes[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_process_type_delete(this)
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
	 * @param processTypes
	 * @returns
	 */
	private mutateResponse(processTypes: ProcessType[]): ProcessType[] {
		let _processTypes: ProcessType[] = [];

		processTypes.map((item: any) => {
			let _processType: ProcessType | any = {
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

			delete _processType.id_company;
			delete _processType.id_setting;
			delete _processType.name_company;
			delete _processType.acronym_company;
			delete _processType.address_company;
			delete _processType.status_company;

			_processTypes.push(_processType);
		});

		return _processTypes;
	}
}
