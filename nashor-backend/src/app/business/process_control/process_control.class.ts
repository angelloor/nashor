import { Control } from '../control/control.class';
import { _control } from '../control/control.data';
import { Level } from '../level/level.class';
import { _level } from '../level/level.data';
import { Official } from '../official/official.class';
import { _official } from '../official/official.data';
import { Process } from '../process/process.class';
import { _process } from '../process/process.data';
import { Task } from '../task/task.class';
import { _task } from '../task/task.data';
import {
	dml_process_control_create,
	dml_process_control_delete,
	dml_process_control_update,
	view_process_control_by_control_read,
	view_process_control_by_level_read,
	view_process_control_by_official_read,
	view_process_control_by_process_read,
	view_process_control_by_task_read,
	view_process_control_specific_read,
} from './process_control.store';

export class ProcessControl {
	/** Attributes */
	public id_user_?: number;
	public id_process_control: number;
	public official: Official;
	public process: Process;
	public task: Task;
	public level: Level;
	public control: Control;
	public value_process_control?: string;
	public last_change_process_control?: string;
	public deleted_process_control?: boolean;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_process_control: number = 0,
		official: Official = _official,
		process: Process = _process,
		task: Task = _task,
		level: Level = _level,
		control: Control = _control,
		value_process_control: string = '',
		last_change_process_control: string = '',
		deleted_process_control: boolean = false
	) {
		this.id_user_ = id_user_;
		this.id_process_control = id_process_control;
		this.official = official;
		this.process = process;
		this.task = task;
		this.level = level;
		this.control = control;
		this.value_process_control = value_process_control;
		this.last_change_process_control = last_change_process_control;
		this.deleted_process_control = deleted_process_control;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_process_control(id_process_control: number) {
		this.id_process_control = id_process_control;
	}
	get _id_process_control() {
		return this.id_process_control;
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

	set _control(control: Control) {
		this.control = control;
	}
	get _control() {
		return this.control;
	}

	set _value_process_control(value_process_control: string) {
		this.value_process_control = value_process_control;
	}
	get _value_process_control() {
		return this.value_process_control!;
	}

	set _last_change_process_control(last_change_process_control: string) {
		this.last_change_process_control = last_change_process_control;
	}
	get _last_change_process_control() {
		return this.last_change_process_control!;
	}

	set _deleted_process_control(deleted_process_control: boolean) {
		this.deleted_process_control = deleted_process_control;
	}
	get _deleted_process_control() {
		return this.deleted_process_control!;
	}

	/** Methods */
	create() {
		return new Promise<ProcessControl>(async (resolve, reject) => {
			await dml_process_control_create(this)
				.then((processControls: ProcessControl[]) => {
					/**
					 * Mutate response
					 */
					const _processControls = this.mutateResponse(processControls);

					resolve(_processControls[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byOfficialRead() {
		return new Promise<ProcessControl[]>(async (resolve, reject) => {
			await view_process_control_by_official_read(this)
				.then((processControls: ProcessControl[]) => {
					/**
					 * Mutate response
					 */
					const _processControls = this.mutateResponse(processControls);

					resolve(_processControls);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byProcessRead() {
		return new Promise<ProcessControl[]>(async (resolve, reject) => {
			await view_process_control_by_process_read(this)
				.then((processControls: ProcessControl[]) => {
					/**
					 * Mutate response
					 */
					const _processControls = this.mutateResponse(processControls);

					resolve(_processControls);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byTaskRead() {
		return new Promise<ProcessControl[]>(async (resolve, reject) => {
			await view_process_control_by_task_read(this)
				.then((processControls: ProcessControl[]) => {
					/**
					 * Mutate response
					 */
					const _processControls = this.mutateResponse(processControls);

					resolve(_processControls);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byLevelRead() {
		return new Promise<ProcessControl[]>(async (resolve, reject) => {
			await view_process_control_by_level_read(this)
				.then((processControls: ProcessControl[]) => {
					/**
					 * Mutate response
					 */
					const _processControls = this.mutateResponse(processControls);

					resolve(_processControls);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byControlRead() {
		return new Promise<ProcessControl[]>(async (resolve, reject) => {
			await view_process_control_by_control_read(this)
				.then((processControls: ProcessControl[]) => {
					/**
					 * Mutate response
					 */
					const _processControls = this.mutateResponse(processControls);

					resolve(_processControls);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<ProcessControl>(async (resolve, reject) => {
			await view_process_control_specific_read(this)
				.then((processControls: ProcessControl[]) => {
					/**
					 * Mutate response
					 */
					const _processControls = this.mutateResponse(processControls);

					resolve(_processControls[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<ProcessControl>(async (resolve, reject) => {
			await dml_process_control_update(this)
				.then((processControls: ProcessControl[]) => {
					/**
					 * Mutate response
					 */
					const _processControls = this.mutateResponse(processControls);

					resolve(_processControls[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_process_control_delete(this)
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
	 * @param processControls
	 * @returns
	 */
	private mutateResponse(processControls: ProcessControl[]): ProcessControl[] {
		let _processControls: ProcessControl[] = [];

		processControls.map((item: any) => {
			let _processControl: ProcessControl | any = {
				...item,
				official: {
					id_official: item.id_official,
					company: { id_company: item.id_company },
					user: {
						id_user: item.id_user,
						person: {
							id_person: item.id_person,
							academic: {
								id_academic: item.id_academic,
							},
							job: {
								id_job: item.id_job,
							},
							dni_person: item.dni_person,
							name_person: item.name_person,
							last_name_person: item.last_name_person,
							address_person: item.address_person,
							phone_person: item.phone_person,
						},
						type_user: {
							id_type_user: item.id_type_user,
						},
						name_user: item.name_user,
						password_user: item.password_user,
						avatar_user: item.avatar_user,
						status_user: item.status_user,
					},
					area: { id_area: item.id_area },
					position: { id_position: item.id_position },
				},
				process: {
					id_process: item.id_process,
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
					number_task: item.number_task,
					type_status_task: item.type_status_task,
					date_task: item.date_task,
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
				control: {
					id_control: item.id_control,
					company: { id_company: item.id_company },
					type_control: item.type_control,
					title_control: item.title_control,
					form_name_control: item.form_name_control,
					initial_value_control: item.initial_value_control,
					required_control: item.required_control,
					min_length_control: item.min_length_control,
					max_length_control: item.max_length_control,
					placeholder_control: item.placeholder_control,
					spell_check_control: item.spell_check_control,
					options_control: item.options_control,
					in_use: item.in_use,
				},
				/**
				 * Generate structure of second level the entity (is important add the ids of entity)
				 * similar the return of read
				 */
			};
			/**
			 * delete ids of principal object level
			 */

			delete _processControl.id_official;
			delete _processControl.id_company;
			delete _processControl.id_user;
			delete _processControl.id_area;
			delete _processControl.id_position;
			delete _processControl.id_process;
			delete _processControl.id_official;
			delete _processControl.id_flow_version;
			delete _processControl.number_process;
			delete _processControl.date_process;
			delete _processControl.generated_task;
			delete _processControl.finalized_process;
			delete _processControl.id_task;
			delete _processControl.id_process;
			delete _processControl.id_official;
			delete _processControl.id_level;
			delete _processControl.number_task;
			delete _processControl.type_status_task;
			delete _processControl.date_task;
			delete _processControl.id_level;
			delete _processControl.id_company;
			delete _processControl.id_template;
			delete _processControl.id_level_profile;
			delete _processControl.id_level_status;
			delete _processControl.name_level;
			delete _processControl.description_level;
			delete _processControl.id_control;
			delete _processControl.id_company;
			delete _processControl.type_control;
			delete _processControl.title_control;
			delete _processControl.form_name_control;
			delete _processControl.initial_value_control;
			delete _processControl.required_control;
			delete _processControl.min_length_control;
			delete _processControl.max_length_control;
			delete _processControl.placeholder_control;
			delete _processControl.spell_check_control;
			delete _processControl.options_control;
			delete _processControl.in_use;

			delete _processControl.id_person;
			delete _processControl.id_type_user;
			delete _processControl.name_user;
			delete _processControl.password_user;
			delete _processControl.avatar_user;
			delete _processControl.status_user;

			delete _processControl.id_academic;
			delete _processControl.id_job;
			delete _processControl.dni_person;
			delete _processControl.name_person;
			delete _processControl.last_name_person;
			delete _processControl.address_person;
			delete _processControl.phone_person;

			_processControls.push(_processControl);
		});

		return _processControls;
	}
}
