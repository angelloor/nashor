import { Level } from '../level/level.class';
import { _level } from '../level/level.data';
import { Official } from '../official/official.class';
import { _official } from '../official/official.data';
import { Process } from '../process/process.class';
import { _process } from '../process/process.data';
import { Task } from '../task/task.class';
import { _task } from '../task/task.data';
import {
	dml_process_comment_create,
	dml_process_comment_delete,
	dml_process_comment_update,
	view_process_comment_by_level_read,
	view_process_comment_by_official_read,
	view_process_comment_by_process_read,
	view_process_comment_by_task_read,
	view_process_comment_specific_read,
} from './process_comment.store';

export class ProcessComment {
	/** Attributes */
	public id_user_?: number;
	public id_process_comment: number;
	public official: Official;
	public process: Process;
	public task: Task;
	public level: Level;
	public value_process_comment?: string;
	public date_process_comment?: string;
	public deleted_process_comment?: boolean;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_process_comment: number = 0,
		official: Official = _official,
		process: Process = _process,
		task: Task = _task,
		level: Level = _level,
		value_process_comment: string = '',
		date_process_comment: string = '',
		deleted_process_comment: boolean = false
	) {
		this.id_user_ = id_user_;
		this.id_process_comment = id_process_comment;
		this.official = official;
		this.process = process;
		this.task = task;
		this.level = level;
		this.value_process_comment = value_process_comment;
		this.date_process_comment = date_process_comment;
		this.deleted_process_comment = deleted_process_comment;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_process_comment(id_process_comment: number) {
		this.id_process_comment = id_process_comment;
	}
	get _id_process_comment() {
		return this.id_process_comment;
	}

	set _official(official: Official) {
		this.official = official;
	}
	get _official() {
		return this.official;
	}

	set _process(process: Process) {
		this.process = process;
	}
	get _process() {
		return this.process;
	}

	set _task(task: Task) {
		this.task = task;
	}
	get _task() {
		return this.task;
	}

	set _level(level: Level) {
		this.level = level;
	}
	get _level() {
		return this.level;
	}

	set _value_process_comment(value_process_comment: string) {
		this.value_process_comment = value_process_comment;
	}
	get _value_process_comment() {
		return this.value_process_comment!;
	}

	set _date_process_comment(date_process_comment: string) {
		this.date_process_comment = date_process_comment;
	}
	get _date_process_comment() {
		return this.date_process_comment!;
	}

	set _deleted_process_comment(deleted_process_comment: boolean) {
		this.deleted_process_comment = deleted_process_comment;
	}
	get _deleted_process_comment() {
		return this.deleted_process_comment!;
	}

	/** Methods */
	create() {
		return new Promise<ProcessComment>(async (resolve, reject) => {
			await dml_process_comment_create(this)
				.then((processComments: ProcessComment[]) => {
					/**
					 * Mutate response
					 */
					const _processComments = this.mutateResponse(processComments);

					resolve(_processComments[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byOfficialRead() {
		return new Promise<ProcessComment[]>(async (resolve, reject) => {
			await view_process_comment_by_official_read(this)
				.then((processComments: ProcessComment[]) => {
					/**
					 * Mutate response
					 */
					const _processComments = this.mutateResponse(processComments);

					resolve(_processComments);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byProcessRead() {
		return new Promise<ProcessComment[]>(async (resolve, reject) => {
			await view_process_comment_by_process_read(this)
				.then((processComments: ProcessComment[]) => {
					/**
					 * Mutate response
					 */
					const _processComments = this.mutateResponse(processComments);

					resolve(_processComments);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byTaskRead() {
		return new Promise<ProcessComment[]>(async (resolve, reject) => {
			await view_process_comment_by_task_read(this)
				.then((processComments: ProcessComment[]) => {
					/**
					 * Mutate response
					 */
					const _processComments = this.mutateResponse(processComments);

					resolve(_processComments);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byLevelRead() {
		return new Promise<ProcessComment[]>(async (resolve, reject) => {
			await view_process_comment_by_level_read(this)
				.then((processComments: ProcessComment[]) => {
					/**
					 * Mutate response
					 */
					const _processComments = this.mutateResponse(processComments);

					resolve(_processComments);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<ProcessComment>(async (resolve, reject) => {
			await view_process_comment_specific_read(this)
				.then((processComments: ProcessComment[]) => {
					/**
					 * Mutate response
					 */
					const _processComments = this.mutateResponse(processComments);

					resolve(_processComments[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<ProcessComment>(async (resolve, reject) => {
			await dml_process_comment_update(this)
				.then((processComments: ProcessComment[]) => {
					/**
					 * Mutate response
					 */
					const _processComments = this.mutateResponse(processComments);

					resolve(_processComments[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_process_comment_delete(this)
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
	 * @param processComments
	 * @returns
	 */
	private mutateResponse(processComments: ProcessComment[]): ProcessComment[] {
		let _processComments: ProcessComment[] = [];

		processComments.map((item: any) => {
			let _processComment: ProcessComment | any = {
				...item,
				official: {
					id_official: item.id_official,
					company: { id_company: item.id_company },
					user: { id_user: item.id_user },
					area: { id_area: item.id_area },
					position: { id_position: item.id_position },
				},
				process: {
					id_process: item.id_process,
					process_type: { id_process_type: item.id_process_type },
					official: { id_official: item.id_official },
					flow_version: { id_flow_version: item.id_flow_version },
					number_process: item.number_process,
					date_process: item.date_process,
					generated_task: item.generated_task,
					finalized_process: item.finalized_process,
				},
				task: {
					id_task: item.id_task,
					process: { id_process: item.id_process },
					official: { id_official: item.id_official },
					level: { id_level: item.id_level },
					creation_date_task: item.creation_date_task,
					type_status_task: item.type_status_task,
					type_action_task: item.type_action_task,
					action_date_task: item.action_date_task,
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

			delete _processComment.id_official;
			delete _processComment.id_company;
			delete _processComment.id_user;
			delete _processComment.id_area;
			delete _processComment.id_position;
			delete _processComment.id_process;
			delete _processComment.id_process_type;
			delete _processComment.id_official;
			delete _processComment.id_flow_version;
			delete _processComment.number_process;
			delete _processComment.date_process;
			delete _processComment.generated_task;
			delete _processComment.finalized_process;
			delete _processComment.id_task;
			delete _processComment.id_process;
			delete _processComment.id_official;
			delete _processComment.id_level;
			delete _processComment.creation_date_task;
			delete _processComment.type_status_task;
			delete _processComment.type_action_task;
			delete _processComment.action_date_task;
			delete _processComment.id_level;
			delete _processComment.id_company;
			delete _processComment.id_template;
			delete _processComment.id_level_profile;
			delete _processComment.id_level_status;
			delete _processComment.name_level;
			delete _processComment.description_level;

			_processComments.push(_processComment);
		});

		return _processComments;
	}
}
