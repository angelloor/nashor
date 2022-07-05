import { Flow } from '../flow/flow.class';
import { _flow } from '../flow/flow.data';
import {
	dml_flow_version_create,
	dml_flow_version_delete,
	dml_flow_version_update,
	view_flow_version_by_flow_read,
	view_flow_version_specific_read,
} from './flow_version.store';

export class FlowVersion {
	/** Attributes */
	public id_user_?: number;
	public id_flow_version: number;
	public flow: Flow;
	public number_flow_version?: number;
	public status_flow_version?: boolean;
	public creation_date_flow_version?: string;
	public deleted_flow_version?: boolean;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_flow_version: number = 0,
		flow: Flow = _flow,
		number_flow_version: number = 0,
		status_flow_version: boolean = false,
		creation_date_flow_version: string = '',
		deleted_flow_version: boolean = false
	) {
		this.id_user_ = id_user_;
		this.id_flow_version = id_flow_version;
		this.flow = flow;
		this.number_flow_version = number_flow_version;
		this.status_flow_version = status_flow_version;
		this.creation_date_flow_version = creation_date_flow_version;
		this.deleted_flow_version = deleted_flow_version;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_flow_version(id_flow_version: number) {
		this.id_flow_version = id_flow_version;
	}
	get _id_flow_version() {
		return this.id_flow_version;
	}

	set _flow(flow: Flow) {
		this.flow = flow;
	}
	get _flow() {
		return this.flow;
	}

	set _number_flow_version(number_flow_version: number) {
		this.number_flow_version = number_flow_version;
	}
	get _number_flow_version() {
		return this.number_flow_version!;
	}

	set _status_flow_version(status_flow_version: boolean) {
		this.status_flow_version = status_flow_version;
	}
	get _status_flow_version() {
		return this.status_flow_version!;
	}

	set _creation_date_flow_version(creation_date_flow_version: string) {
		this.creation_date_flow_version = creation_date_flow_version;
	}
	get _creation_date_flow_version() {
		return this.creation_date_flow_version!;
	}

	set _deleted_flow_version(deleted_flow_version: boolean) {
		this.deleted_flow_version = deleted_flow_version;
	}
	get _deleted_flow_version() {
		return this.deleted_flow_version!;
	}

	/** Methods */
	create() {
		return new Promise<FlowVersion>(async (resolve, reject) => {
			await dml_flow_version_create(this)
				.then((flowVersions: FlowVersion[]) => {
					/**
					 * Mutate response
					 */
					const _flowVersions = this.mutateResponse(flowVersions);

					resolve(_flowVersions[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byFlowRead() {
		return new Promise<FlowVersion[]>(async (resolve, reject) => {
			await view_flow_version_by_flow_read(this)
				.then((flowVersions: FlowVersion[]) => {
					/**
					 * Mutate response
					 */
					const _flowVersions = this.mutateResponse(flowVersions);

					resolve(_flowVersions);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<FlowVersion>(async (resolve, reject) => {
			await view_flow_version_specific_read(this)
				.then((flowVersions: FlowVersion[]) => {
					/**
					 * Mutate response
					 */
					const _flowVersions = this.mutateResponse(flowVersions);

					resolve(_flowVersions[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<FlowVersion>(async (resolve, reject) => {
			await dml_flow_version_update(this)
				.then((flowVersions: FlowVersion[]) => {
					/**
					 * Mutate response
					 */
					const _flowVersions = this.mutateResponse(flowVersions);

					resolve(_flowVersions[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_flow_version_delete(this)
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
	 * @param flowVersions
	 * @returns
	 */
	private mutateResponse(flowVersions: FlowVersion[]): FlowVersion[] {
		let _flowVersions: FlowVersion[] = [];

		flowVersions.map((item: any) => {
			let _flowVersion: FlowVersion | any = {
				...item,
				flow: {
					id_flow: item.id_flow,
					company: { id_company: item.id_company },
					process_type: { id_process_type: item.id_process_type },
					name_flow: item.name_flow,
					description_flow: item.description_flow,
				},
				/**
				 * Generate structure of second level the entity (is important add the ids of entity)
				 * similar the return of read
				 */
			};
			/**
			 * delete ids of principal object level
			 */

			delete _flowVersion.id_flow;
			delete _flowVersion.id_company;
			delete _flowVersion.id_process_type;
			delete _flowVersion.name_flow;
			delete _flowVersion.description_flow;

			_flowVersions.push(_flowVersion);
		});

		return _flowVersions;
	}
}
