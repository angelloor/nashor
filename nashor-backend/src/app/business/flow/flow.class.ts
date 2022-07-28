import { Company } from '../../core/company/company.class';
import { _company } from '../../core/company/company.data';
import {
	dml_flow_create,
	dml_flow_delete,
	dml_flow_update,
	view_flow_by_company_query_read,
	view_flow_query_read,
	view_flow_specific_read,
} from './flow.store';

export class Flow {
	/** Attributes */
	public id_user_?: number;
	public id_flow: number;
	public company: Company;
	public name_flow?: string;
	public description_flow?: string;
	public acronym_flow?: string;
	public acronym_task?: string;
	public sequential_flow?: number;
	public deleted_flow?: boolean;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_flow: number = 0,
		company: Company = _company,
		name_flow: string = '',
		description_flow: string = '',
		acronym_flow: string = '',
		acronym_task: string = '',
		sequential_flow: number = 0,
		deleted_flow: boolean = false
	) {
		this.id_user_ = id_user_;
		this.id_flow = id_flow;
		this.company = company;
		this.name_flow = name_flow;
		this.description_flow = description_flow;
		this.acronym_flow = acronym_flow;
		this.acronym_task = acronym_task;
		this.sequential_flow = sequential_flow;
		this.deleted_flow = deleted_flow;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_flow(id_flow: number) {
		this.id_flow = id_flow;
	}
	get _id_flow() {
		return this.id_flow;
	}

	set _company(company: Company) {
		this.company = company;
	}
	get _company() {
		return this.company;
	}

	set _name_flow(name_flow: string) {
		this.name_flow = name_flow;
	}
	get _name_flow() {
		return this.name_flow!;
	}

	set _description_flow(description_flow: string) {
		this.description_flow = description_flow;
	}
	get _description_flow() {
		return this.description_flow!;
	}

	set _acronym_flow(acronym_flow: string) {
		this.acronym_flow = acronym_flow;
	}
	get _acronym_flow() {
		return this.acronym_flow!;
	}

	set _acronym_task(acronym_task: string) {
		this.acronym_task = acronym_task;
	}
	get _acronym_task() {
		return this.acronym_task!;
	}

	set _sequential_flow(sequential_flow: number) {
		this.sequential_flow = sequential_flow;
	}
	get _sequential_flow() {
		return this.sequential_flow!;
	}

	set _deleted_flow(deleted_flow: boolean) {
		this.deleted_flow = deleted_flow;
	}
	get _deleted_flow() {
		return this.deleted_flow!;
	}

	/** Methods */
	create() {
		return new Promise<Flow>(async (resolve, reject) => {
			await dml_flow_create(this)
				.then((flows: Flow[]) => {
					/**
					 * Mutate response
					 */
					const _flows = this.mutateResponse(flows);

					resolve(_flows[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	queryRead() {
		return new Promise<Flow[]>(async (resolve, reject) => {
			await view_flow_query_read(this)
				.then((flows: Flow[]) => {
					/**
					 * Mutate response
					 */
					const _flows = this.mutateResponse(flows);

					resolve(_flows);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byCompanyQueryRead() {
		return new Promise<Flow[]>(async (resolve, reject) => {
			await view_flow_by_company_query_read(this)
				.then((flows: Flow[]) => {
					/**
					 * Mutate response
					 */
					const _flows = this.mutateResponse(flows);

					resolve(_flows);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<Flow>(async (resolve, reject) => {
			await view_flow_specific_read(this)
				.then((flows: Flow[]) => {
					/**
					 * Mutate response
					 */
					const _flows = this.mutateResponse(flows);

					resolve(_flows[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<Flow>(async (resolve, reject) => {
			await dml_flow_update(this)
				.then((flows: Flow[]) => {
					/**
					 * Mutate response
					 */
					const _flows = this.mutateResponse(flows);

					resolve(_flows[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_flow_delete(this)
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
	 * @param flows
	 * @returns
	 */
	private mutateResponse(flows: Flow[]): Flow[] {
		let _flows: Flow[] = [];

		flows.map((item: any) => {
			let _flow: Flow | any = {
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

			delete _flow.id_company;
			delete _flow.id_setting;
			delete _flow.name_company;
			delete _flow.acronym_company;
			delete _flow.address_company;
			delete _flow.status_company;

			_flows.push(_flow);
		});

		return _flows;
	}
}
