import { Item } from '../item/item.class';
import { _item } from '../item/item.data';
import { Level } from '../level/level.class';
import { _level } from '../level/level.data';
import { Official } from '../official/official.class';
import { _official } from '../official/official.data';
import { Process } from '../process/process.class';
import { _process } from '../process/process.data';
import { Task } from '../task/task.class';
import { _task } from '../task/task.data';
import {
	dml_process_item_create,
	dml_process_item_delete,
	dml_process_item_update,
	view_process_item_by_item_read,
	view_process_item_by_level_read,
	view_process_item_by_official_read,
	view_process_item_by_process_read,
	view_process_item_by_task_read,
	view_process_item_specific_read,
} from './process_item.store';

export class ProcessItem {
	/** Attributes */
	public id_user_?: number;
	public id_process_item: number;
	public official: Official;
	public process: Process;
	public task: Task;
	public level: Level;
	public item: Item;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_process_item: number = 0,
		official: Official = _official,
		process: Process = _process,
		task: Task = _task,
		level: Level = _level,
		item: Item = _item
	) {
		this.id_user_ = id_user_;
		this.id_process_item = id_process_item;
		this.official = official;
		this.process = process;
		this.task = task;
		this.level = level;
		this.item = item;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_process_item(id_process_item: number) {
		this.id_process_item = id_process_item;
	}
	get _id_process_item() {
		return this.id_process_item;
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

	set _item(item: Item) {
		this.item = item;
	}
	get _item() {
		return this.item;
	}

	/** Methods */
	create() {
		return new Promise<ProcessItem>(async (resolve, reject) => {
			await dml_process_item_create(this)
				.then((processItems: ProcessItem[]) => {
					/**
					 * Mutate response
					 */
					const _processItems = this.mutateResponse(processItems);

					resolve(_processItems[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byOfficialRead() {
		return new Promise<ProcessItem[]>(async (resolve, reject) => {
			await view_process_item_by_official_read(this)
				.then((processItems: ProcessItem[]) => {
					/**
					 * Mutate response
					 */
					const _processItems = this.mutateResponse(processItems);

					resolve(_processItems);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byProcessRead() {
		return new Promise<ProcessItem[]>(async (resolve, reject) => {
			await view_process_item_by_process_read(this)
				.then((processItems: ProcessItem[]) => {
					/**
					 * Mutate response
					 */
					const _processItems = this.mutateResponse(processItems);

					resolve(_processItems);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byTaskRead() {
		return new Promise<ProcessItem[]>(async (resolve, reject) => {
			await view_process_item_by_task_read(this)
				.then((processItems: ProcessItem[]) => {
					/**
					 * Mutate response
					 */
					const _processItems = this.mutateResponse(processItems);

					resolve(_processItems);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byLevelRead() {
		return new Promise<ProcessItem[]>(async (resolve, reject) => {
			await view_process_item_by_level_read(this)
				.then((processItems: ProcessItem[]) => {
					/**
					 * Mutate response
					 */
					const _processItems = this.mutateResponse(processItems);

					resolve(_processItems);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byItemRead() {
		return new Promise<ProcessItem[]>(async (resolve, reject) => {
			await view_process_item_by_item_read(this)
				.then((processItems: ProcessItem[]) => {
					/**
					 * Mutate response
					 */
					const _processItems = this.mutateResponse(processItems);

					resolve(_processItems);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<ProcessItem>(async (resolve, reject) => {
			await view_process_item_specific_read(this)
				.then((processItems: ProcessItem[]) => {
					/**
					 * Mutate response
					 */
					const _processItems = this.mutateResponse(processItems);

					resolve(_processItems[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<ProcessItem>(async (resolve, reject) => {
			await dml_process_item_update(this)
				.then((processItems: ProcessItem[]) => {
					/**
					 * Mutate response
					 */
					const _processItems = this.mutateResponse(processItems);

					resolve(_processItems[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_process_item_delete(this)
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
	 * @param processItems
	 * @returns
	 */
	private mutateResponse(processItems: ProcessItem[]): ProcessItem[] {
		let _processItems: ProcessItem[] = [];

		processItems.map((item: any) => {
			let _processItem: ProcessItem | any = {
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
				item: {
					id_item: item.id_item,
					company: { id_company: item.id_company },
					item_category: { id_item_category: item.id_item_category },
					name_item: item.name_item,
					description_item: item.description_item,
				},
				/**
				 * Generate structure of second level the entity (is important add the ids of entity)
				 * similar the return of read
				 */
			};
			/**
			 * delete ids of principal object level
			 */

			delete _processItem.id_official;
			delete _processItem.id_company;
			delete _processItem.id_user;
			delete _processItem.id_area;
			delete _processItem.id_position;
			delete _processItem.id_process;
			delete _processItem.id_official;
			delete _processItem.id_flow_version;
			delete _processItem.number_process;
			delete _processItem.date_process;
			delete _processItem.generated_task;
			delete _processItem.finalized_process;
			delete _processItem.id_task;
			delete _processItem.id_process;
			delete _processItem.id_official;
			delete _processItem.id_level;
			delete _processItem.number_task;
			delete _processItem.type_status_task;
			delete _processItem.date_task;
			delete _processItem.id_level;
			delete _processItem.id_company;
			delete _processItem.id_template;
			delete _processItem.id_level_profile;
			delete _processItem.id_level_status;
			delete _processItem.name_level;
			delete _processItem.description_level;
			delete _processItem.id_item;
			delete _processItem.id_company;
			delete _processItem.id_item_category;
			delete _processItem.name_item;
			delete _processItem.description_item;

			delete _processItem.id_person;
			delete _processItem.id_type_user;
			delete _processItem.name_user;
			delete _processItem.password_user;
			delete _processItem.avatar_user;
			delete _processItem.status_user;

			delete _processItem.id_academic;
			delete _processItem.id_job;
			delete _processItem.dni_person;
			delete _processItem.name_person;
			delete _processItem.last_name_person;
			delete _processItem.address_person;
			delete _processItem.phone_person;

			_processItems.push(_processItem);
		});

		return _processItems;
	}
}
