import { _messages } from '../../../utils/message/message';
import { Level } from '../level/level.class';
import { _level } from '../level/level.data';
import { Official } from '../official/official.class';
import { _official } from '../official/official.data';
import { Process } from '../process/process.class';
import { _process } from '../process/process.data';
import {
	dml_task_create,
	dml_task_delete,
	dml_task_reasign,
	dml_task_send,
	dml_task_update,
	view_task_by_level_query_read,
	view_task_by_official_query_read,
	view_task_by_process_exclude_reassigned_read,
	view_task_by_process_query_read,
	view_task_query_read,
	view_task_specific_read,
} from './task.store';

export class Task {
	/** Attributes */
	public id_user_?: number;
	public id_task: number;
	public process: Process;
	public official: Official;
	public level: Level;
	public number_task?: string;
	public type_status_task?: TYPE_STATUS_TASK;
	public date_task?: string;
	public deleted_task?: boolean;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_task: number = 0,
		process: Process = _process,
		official: Official = _official,
		level: Level = _level,
		number_task: string = '',
		type_status_task: TYPE_STATUS_TASK = 'progress',
		date_task: string = '',
		deleted_task: boolean = false
	) {
		this.id_user_ = id_user_;
		this.id_task = id_task;
		this.process = process;
		this.official = official;
		this.level = level;
		this.number_task = number_task;
		this.type_status_task = type_status_task;
		this.date_task = date_task;
		this.deleted_task = deleted_task;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_task(id_task: number) {
		this.id_task = id_task;
	}
	get _id_task() {
		return this.id_task;
	}

	set _process(process: Process) {
		this.process = process;
	}
	get _process() {
		return this.process;
	}

	set _official(official: Official) {
		this.official = official;
	}
	get _official() {
		return this.official;
	}

	set _level(level: Level) {
		this.level = level;
	}
	get _level() {
		return this.level;
	}

	set _number_task(number_task: string) {
		this.number_task = number_task;
	}
	get _number_task() {
		return this.number_task!;
	}

	set _type_status_task(type_status_task: TYPE_STATUS_TASK) {
		this.type_status_task = type_status_task;
	}
	get _type_status_task() {
		return this.type_status_task!;
	}

	set _action_date_task(date_task: string) {
		this.date_task = date_task;
	}
	get _action_date_task() {
		return this.date_task!;
	}

	set _deleted_task(deleted_task: boolean) {
		this.deleted_task = deleted_task;
	}
	get _deleted_task() {
		return this.deleted_task!;
	}

	/** Methods */
	create() {
		return new Promise<Task>(async (resolve, reject) => {
			await dml_task_create(this)
				.then((tasks: Task[]) => {
					/**
					 * Mutate response
					 */
					const _tasks = this.mutateResponse(tasks);

					resolve(_tasks[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	queryRead() {
		return new Promise<Task[]>(async (resolve, reject) => {
			await view_task_query_read(this)
				.then((tasks: Task[]) => {
					/**
					 * Mutate response
					 */
					const _tasks = this.mutateResponse(tasks);

					resolve(_tasks);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byProcessQueryRead() {
		return new Promise<Task[]>(async (resolve, reject) => {
			await view_task_by_process_query_read(this)
				.then((tasks: Task[]) => {
					/**
					 * Mutate response
					 */
					const _tasks = this.mutateResponse(tasks);

					resolve(_tasks);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byProcessExcludeReassignedRead() {
		return new Promise<Task[]>(async (resolve, reject) => {
			await view_task_by_process_exclude_reassigned_read(this)
				.then((tasks: Task[]) => {
					/**
					 * Mutate response
					 */
					const _tasks = this.mutateResponse(tasks);

					resolve(_tasks);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byOfficialQueryRead() {
		return new Promise<Task[]>(async (resolve, reject) => {
			await view_task_by_official_query_read(this)
				.then((tasks: Task[]) => {
					/**
					 * Mutate response
					 */
					const _tasks = this.mutateResponse(tasks);

					resolve(_tasks);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byLevelQueryRead() {
		return new Promise<Task[]>(async (resolve, reject) => {
			await view_task_by_level_query_read(this)
				.then((tasks: Task[]) => {
					/**
					 * Mutate response
					 */
					const _tasks = this.mutateResponse(tasks);

					resolve(_tasks);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<Task>(async (resolve, reject) => {
			await view_task_specific_read(this)
				.then((tasks: Task[]) => {
					/**
					 * Mutate response
					 */
					const _tasks = this.mutateResponse(tasks);

					resolve(_tasks[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<Task>(async (resolve, reject) => {
			await dml_task_update(this)
				.then((tasks: Task[]) => {
					/**
					 * Mutate response
					 */
					const _tasks = this.mutateResponse(tasks);

					resolve(_tasks[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	reasign() {
		return new Promise<Task>(async (resolve, reject) => {
			await dml_task_reasign(this)
				.then((tasks: Task[]) => {
					/**
					 * Mutate response
					 */
					const _tasks = this.mutateResponse(tasks);

					resolve(_tasks[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	send() {
		return new Promise<Task>(async (resolve, reject) => {
			await dml_task_send(this)
				.then((tasks: Task[]) => {
					/**
					 * Mutate response
					 */
					const _tasks = this.mutateResponse(tasks);

					resolve(_tasks[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_task_delete(this)
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
	 * @param tasks
	 * @returns
	 */
	private mutateResponse(tasks: Task[]): Task[] {
		let _tasks: Task[] = [];

		tasks.map((item: any) => {
			let _task: Task | any = {
				...item,
				process: {
					id_process: item.id_process,
					flow: { id_flow: item.id_flow },
					official: { id_official: item.id_official },
					flow_version: {
						id_flow_version: item.id_flow_version,
						flow: {
							id_flow: item.id_flow,
							company: { id_company: item.id_company },
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
					number_process: item.number_process,
					date_process: item.date_process,
					generated_task: item.generated_task,
					finalized_process: item.finalized_process,
				},
				official: {
					id_official: item.id_official,
					company: { id_company: item.id_company },
					user: { id_user: item.id_user },
					area: { id_area: item.id_area },
					position: { id_position: item.id_position },
				},
				level: {
					id_level: item.id_level,
					company: { id_company: item.id_company },
					template: { id_template: item.id_template },
					level_profile: { id_level_profile: item.id_level_profile },
					level_status: { id_level_status: item.id_level_status },
					name_level: item.name_level,
					description_level: item.description_level,
				},
				/**
				 * Generate structure of second level the entity (is important add the ids of entity)
				 * similar the return of read
				 */
			};
			/**
			 * delete ids of principal object level
			 */

			delete _task.id_process;
			delete _task.id_flow;
			delete _task.id_official;
			delete _task.id_flow_version;
			delete _task.number_process;
			delete _task.date_process;
			delete _task.generated_task;
			delete _task.finalized_process;
			delete _task.id_official;
			delete _task.id_company;
			delete _task.id_user;
			delete _task.id_area;
			delete _task.id_position;
			delete _task.id_level;
			delete _task.id_company;
			delete _task.id_template;
			delete _task.id_level_profile;
			delete _task.id_level_status;
			delete _task.name_level;
			delete _task.description_level;

			delete _task.number_flow_version;
			delete _task.status_flow_version;
			delete _task.creation_date_flow_version;
			delete _task.name_flow;
			delete _task.description_flow;
			delete _task.acronym_flow;
			delete _task.acronym_task;
			delete _task.sequential_flow;

			_tasks.push(_task);
		});

		return _tasks;
	}
}

/**
 * Type Enum TYPE_STATUS_TASK
 */
export type TYPE_STATUS_TASK =
	| 'created'
	| 'progress'
	| 'reassigned'
	| 'dispatched';

export interface TYPE_STATUS_TASK_ENUM {
	name_type: string;
	value_type: TYPE_STATUS_TASK;
}

export const _typeStatusTask: TYPE_STATUS_TASK_ENUM[] = [
	{
		name_type: 'Creado',
		value_type: 'created',
	},
	{
		name_type: 'En progeso',
		value_type: 'progress',
	},
	{
		name_type: 'Reasignado',
		value_type: 'reassigned',
	},
	{
		name_type: 'Enviado',
		value_type: 'dispatched',
	},
];

export const validationTypeStatusTask = (
	attribute: string,
	value: string | TYPE_STATUS_TASK
) => {
	return new Promise<Boolean>((resolve, reject) => {
		const typeStatusTask = _typeStatusTask.find(
			(typeStatusTask: TYPE_STATUS_TASK_ENUM) =>
				typeStatusTask.value_type == value
		);

		if (!typeStatusTask) {
			reject({
				..._messages[7],
				description: _messages[7].description
					.replace('_nameAttribute', `${attribute}`)
					.replace('_expectedType', 'TYPE_STATUS_TASK'),
			});
		}
	});
};

/**
 * Type Enum TYPE_STATUS_TASK
 */
