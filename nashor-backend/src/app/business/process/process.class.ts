import { FlowVersion } from '../flow_version/flow_version.class';
import { _flowVersion } from '../flow_version/flow_version.data';
import { Official } from '../official/official.class';
import { _official } from '../official/official.data';
import {
	dml_process_create,
	dml_process_delete,
	dml_process_update,
	view_process_by_flow_version_query_read,
	view_process_by_official_query_read,
	view_process_query_read,
	view_process_specific_read
} from './process.store';

export class Process {
	/** Attributes */
	public id_user_?: number;
	public id_process: number;
	public official: Official;
	public flow_version: FlowVersion;
	public number_process?: string;
	public date_process?: string;
	public generated_task?: boolean;
	public finalized_process?: boolean;
	public deleted_process?: boolean;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_process: number = 0,
		official: Official = _official,
		flow_version: FlowVersion = _flowVersion,
		number_process: string = '',
		date_process: string = '',
		generated_task: boolean = false,
		finalized_process: boolean = false,
		deleted_process: boolean = false
	) {
		this.id_user_ = id_user_;
		this.id_process = id_process;
		this.official = official;
		this.flow_version = flow_version;
		this.number_process = number_process;
		this.date_process = date_process;
		this.generated_task = generated_task;
		this.finalized_process = finalized_process;
		this.deleted_process = deleted_process;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_process(id_process: number) {
		this.id_process = id_process;
	}
	get _id_process() {
		return this.id_process;
	}

	set _official(official: Official) {
		this.official = official;
	}
	get _official() {
		return this.official;
	}

	set _flow_version(flow_version: FlowVersion) {
		this.flow_version = flow_version;
	}
	get _flow_version() {
		return this.flow_version;
	}

	set _number_process(number_process: string) {
		this.number_process = number_process;
	}
	get _number_process() {
		return this.number_process!;
	}

	set _date_process(date_process: string) {
		this.date_process = date_process;
	}
	get _date_process() {
		return this.date_process!;
	}

	set _generated_task(generated_task: boolean) {
		this.generated_task = generated_task;
	}
	get _generated_task() {
		return this.generated_task!;
	}

	set _finalized_process(finalized_process: boolean) {
		this.finalized_process = finalized_process;
	}
	get _finalized_process() {
		return this.finalized_process!;
	}

	set _deleted_process(deleted_process: boolean) {
		this.deleted_process = deleted_process;
	}
	get _deleted_process() {
		return this.deleted_process!;
	}

	/** Methods */
	create() {
		return new Promise<Process>(async (resolve, reject) => {
			await dml_process_create(this)
				.then((processs: Process[]) => {
					/**
					 * Mutate response
					 */
					const _processs = this.mutateResponse(processs);

					resolve(_processs[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	queryRead() {
		return new Promise<Process[]>(async (resolve, reject) => {
			await view_process_query_read(this)
				.then((processs: Process[]) => {
					/**
					 * Mutate response
					 */
					const _processs = this.mutateResponse(processs);

					resolve(_processs);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byOfficialQueryRead() {
		return new Promise<Process[]>(async (resolve, reject) => {
			await view_process_by_official_query_read(this)
				.then((processs: Process[]) => {
					/**
					 * Mutate response
					 */
					const _processs = this.mutateResponse(processs);

					resolve(_processs);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byFlowVersionQueryRead() {
		return new Promise<Process[]>(async (resolve, reject) => {
			await view_process_by_flow_version_query_read(this)
				.then((processs: Process[]) => {
					/**
					 * Mutate response
					 */
					const _processs = this.mutateResponse(processs);

					resolve(_processs);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<Process>(async (resolve, reject) => {
			await view_process_specific_read(this)
				.then((processs: Process[]) => {
					/**
					 * Mutate response
					 */
					const _processs = this.mutateResponse(processs);

					resolve(_processs[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<Process>(async (resolve, reject) => {
			await dml_process_update(this)
				.then((processs: Process[]) => {
					/**
					 * Mutate response
					 */
					const _processs = this.mutateResponse(processs);

					resolve(_processs[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_process_delete(this)
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
	 * @param processs
	 * @returns
	 */
	private mutateResponse(processs: Process[]): Process[] {
		let _processs: Process[] = [];

		processs.map((item: any) => {
			let _process: Process | any = {
				...item,
				official: {
					id_official: item.id_official,
					company: { id_company: item.id_company },
					user: { id_user: item.id_user },
					area: { id_area: item.id_area },
					position: { id_position: item.id_position },
				},
				flow_version: {
					id_flow_version: item.id_flow_version,
					flow: {
						id_flow: item.id_flow,
						name_flow: item.name_flow,
						description_flow: item.description_flow,
						acronym_flow: item.acronym_flow,
						acronym_task: item.acronym_task,
						sequential_flow: item.sequential_flow,
					},
					number_flow_version: item.number_flow_version,
					status_flow_version: item.status_flow_version,
					creation_date_flow_version: item.creation_date_flow_version,
				},
				/**
				 * Generate structure of second level the entity (is important add the ids of entity)
				 * similar the return of read
				 */
			};
			/**
			 * delete ids of principal object level
			 */

			delete _process.id_company;
			delete _process.id_official;
			delete _process.id_company;
			delete _process.id_user;
			delete _process.id_area;
			delete _process.id_position;
			delete _process.id_flow_version;
			delete _process.id_flow;
			delete _process.name_flow;
			delete _process.description_flow;
			delete _process.acronym_flow;
			delete _process.acronym_task;
			delete _process.sequential_flow;
			delete _process.number_flow_version;
			delete _process.status_flow_version;
			delete _process.creation_date_flow_version;

			_processs.push(_process);
		});

		return _processs;
	}
}
