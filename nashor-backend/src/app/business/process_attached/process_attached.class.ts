import { Alfresco } from '../../../utils/alfresco/alfresco';
import {
	Documento,
	Models,
	Path,
	ProcessAttachedType,
	Sities,
	Types,
} from '../../../utils/alfresco/alfresco.types';
import { parseDateToString } from '../../../utils/date';
import { Company } from '../../core/company/company.class';
import { Attached } from '../attached/attached.class';
import { _attached } from '../attached/attached.data';
import { Level } from '../level/level.class';
import { _level } from '../level/level.data';
import { Official } from '../official/official.class';
import { _official } from '../official/official.data';
import { Process } from '../process/process.class';
import { _process } from '../process/process.data';
import { Task } from '../task/task.class';
import { _task } from '../task/task.data';
import {
	dml_process_attached_create,
	dml_process_attached_delete,
	dml_process_attached_update,
	view_process_attached_by_attached_read,
	view_process_attached_by_level_read,
	view_process_attached_by_official_read,
	view_process_attached_by_process_read,
	view_process_attached_by_task_read,
	view_process_attached_specific_read,
} from './process_attached.store';

export class ProcessAttached {
	/** Attributes */
	public id_user_?: number;
	public id_process_attached: number;
	public official: Official;
	public process: Process;
	public task: Task;
	public level: Level;
	public attached: Attached;
	public file_name?: string;
	public length_mb?: string;
	public extension?: string;
	public server_path?: string;
	public alfresco_path?: string;
	public upload_date?: string;
	public deleted_process_attached?: boolean;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_process_attached: number = 0,
		official: Official = _official,
		process: Process = _process,
		task: Task = _task,
		level: Level = _level,
		attached: Attached = _attached,
		file_name: string = '',
		length_mb: string = '',
		extension: string = '',
		server_path: string = '',
		alfresco_path: string = '',
		upload_date: string = '',
		deleted_process_attached: boolean = false
	) {
		this.id_user_ = id_user_;
		this.id_process_attached = id_process_attached;
		this.official = official;
		this.process = process;
		this.task = task;
		this.level = level;
		this.attached = attached;
		this.file_name = file_name;
		this.length_mb = length_mb;
		this.extension = extension;
		this.server_path = server_path;
		this.alfresco_path = alfresco_path;
		this.upload_date = upload_date;
		this.deleted_process_attached = deleted_process_attached;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_process_attached(id_process_attached: number) {
		this.id_process_attached = id_process_attached;
	}
	get _id_process_attached() {
		return this.id_process_attached;
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

	set _attached(attached: Attached) {
		this.attached = attached;
	}
	get _attached() {
		return this.attached;
	}

	set _file_name(file_name: string) {
		this.file_name = file_name;
	}
	get _file_name() {
		return this.file_name!;
	}

	set _length_mb(length_mb: string) {
		this.length_mb = length_mb;
	}
	get _length_mb() {
		return this.length_mb!;
	}

	set _extension(extension: string) {
		this.extension = extension;
	}
	get _extension() {
		return this.extension!;
	}

	set _server_path(server_path: string) {
		this.server_path = server_path;
	}
	get _server_path() {
		return this.server_path!;
	}

	set _alfresco_path(alfresco_path: string) {
		this.alfresco_path = alfresco_path;
	}
	get _alfresco_path() {
		return this.alfresco_path!;
	}

	set _upload_date(upload_date: string) {
		this.upload_date = upload_date;
	}
	get _upload_date() {
		return this.upload_date!;
	}

	set _deleted_process_attached(deleted_process_attached: boolean) {
		this.deleted_process_attached = deleted_process_attached;
	}
	get _deleted_process_attached() {
		return this.deleted_process_attached!;
	}

	/** Methods */
	create(id_company: number) {
		return new Promise<ProcessAttached>(async (resolve, reject) => {
			const _company = new Company();
			let save_file_alfresco: boolean = false;

			_company.id_company = id_company;
			await _company
				.specificRead()
				.then((_company: Company) => {
					save_file_alfresco = _company.setting.save_file_alfresco!;
				})
				.catch((error: any) => {
					reject(error);
				});

			await dml_process_attached_create(this)
				.then(async (processAttacheds: ProcessAttached[]) => {
					/**
					 * Mutate response
					 */
					const _processAttacheds = this.mutateResponse(processAttacheds);

					if (save_file_alfresco) {
						this.id_process_attached = _processAttacheds[0].id_process_attached;
						const date: any = _processAttacheds[0].upload_date!;

						this.upload_date = parseDateToString(date);

						await this.saveAlfresco(this)
							.then(async (_workspace: string) => {
								this.alfresco_path = _workspace;

								await this.update()
									.then((_processAttached: ProcessAttached) => {
										resolve(_processAttached);
									})
									.catch((error: any) => {
										reject(error);
									});
							})
							.catch((error: any) => {
								reject(error);
							});
					} else {
						resolve(_processAttacheds[0]);
					}
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byOfficialRead() {
		return new Promise<ProcessAttached[]>(async (resolve, reject) => {
			await view_process_attached_by_official_read(this)
				.then((processAttacheds: ProcessAttached[]) => {
					/**
					 * Mutate response
					 */
					const _processAttacheds = this.mutateResponse(processAttacheds);

					resolve(_processAttacheds);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byProcessRead() {
		return new Promise<ProcessAttached[]>(async (resolve, reject) => {
			await view_process_attached_by_process_read(this)
				.then((processAttacheds: ProcessAttached[]) => {
					/**
					 * Mutate response
					 */
					const _processAttacheds = this.mutateResponse(processAttacheds);

					resolve(_processAttacheds);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byTaskRead() {
		return new Promise<ProcessAttached[]>(async (resolve, reject) => {
			await view_process_attached_by_task_read(this)
				.then((processAttacheds: ProcessAttached[]) => {
					/**
					 * Mutate response
					 */
					const _processAttacheds = this.mutateResponse(processAttacheds);

					resolve(_processAttacheds);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byLevelRead() {
		return new Promise<ProcessAttached[]>(async (resolve, reject) => {
			await view_process_attached_by_level_read(this)
				.then((processAttacheds: ProcessAttached[]) => {
					/**
					 * Mutate response
					 */
					const _processAttacheds = this.mutateResponse(processAttacheds);

					resolve(_processAttacheds);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byAttachedRead() {
		return new Promise<ProcessAttached[]>(async (resolve, reject) => {
			await view_process_attached_by_attached_read(this)
				.then((processAttacheds: ProcessAttached[]) => {
					/**
					 * Mutate response
					 */
					const _processAttacheds = this.mutateResponse(processAttacheds);

					resolve(_processAttacheds);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<ProcessAttached>(async (resolve, reject) => {
			await view_process_attached_specific_read(this)
				.then((processAttacheds: ProcessAttached[]) => {
					/**
					 * Mutate response
					 */
					const _processAttacheds = this.mutateResponse(processAttacheds);

					resolve(_processAttacheds[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<ProcessAttached>(async (resolve, reject) => {
			await dml_process_attached_update(this)
				.then((processAttacheds: ProcessAttached[]) => {
					/**
					 * Mutate response
					 */
					const _processAttacheds = this.mutateResponse(processAttacheds);

					resolve(_processAttacheds[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_process_attached_delete(this)
				.then((response: boolean) => {
					resolve(response);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}
	/**
	 * saveAlfresco
	 * @returns
	 */
	saveAlfresco(process_attached: ProcessAttached): Promise<string> {
		return new Promise<string>(async (resolve, reject) => {
			/**
			 * Instace Alfresco
			 */
			const _alfresco = new Alfresco();

			const base_path_alfresco: string = `cm:${process_attached.process.id_process}/cm:${process_attached.level.id_level}/cm:${process_attached.task.id_task}`;

			_alfresco._model = Models.NASHOR;
			_alfresco._type = Types.process_attached;
			_alfresco._sitie = Sities.NASHOR;
			_alfresco._path_to_save = `${Path.NASHOR}/${base_path_alfresco}`;
			/**
			 * Construir el archivo con sus propiedades
			 */
			const file: ProcessAttachedType | any = {
				id_process_attached: process_attached.id_process_attached,
				id_official: process_attached.official.id_official,
				id_process: process_attached.process.id_process,
				id_task: process_attached.task.id_task,
				id_level: process_attached.level.id_level,
				id_attached: process_attached.attached.id_attached,
				file_name: process_attached.file_name,
				length_mb: process_attached.length_mb,
				extension: process_attached.extension,
				server_path: process_attached.server_path,
				upload_date: process_attached.upload_date,
			};
			/**
			 * Set the file
			 */
			_alfresco.file = file;
			/**
			 * Buscar carpeta solicitud y crear si no existe
			 */
			await _alfresco
				.searchFile(`/${Path.NASHOR}`)
				.then(async (documentos: Documento[]) => {
					if (documentos.length == 0) {
						/**
						 * Buscamos el nodo principal
						 */
						await _alfresco
							.searchFile('') // '' es igual al directorio base de documentLibrary
							.then(async (documentos: Documento[]) => {
								if (documentos.length > 0) {
									const referencia = documentos[0].referencia;
									const nodeIdDocumentLibrary = referencia.slice(
										24,
										referencia.length
									);

									await _alfresco
										.createFolder(
											nodeIdDocumentLibrary,
											`${Path.name}`,
											`${Path.title}`,
											`${Path.description}`
										)
										.catch((error: string) => {
											reject(error);
											return;
										});
								} else {
									reject(
										`No se encontró documentLibrary del sitio ${_alfresco._sitie}`
									);
								}
							})
							.catch((error: string) => {
								reject(error);
								return;
							});
					}
				})
				.catch((error: string) => {
					reject(error);
					return;
				});
			/**
			 * saveFile
			 */
			await _alfresco
				.saveFile()
				.then(async (workspace: string) => {
					if (workspace != undefined) {
						resolve(workspace);
					} else {
						reject('No se recibio el workspace del archivo en Alfresco');
					}
				})
				.catch((error: string) => {
					reject(error);
				});
		});
	}

	/**
	 * Eliminar ids de entidades externas y formatear la informacion en el esquema correspondiente
	 * @param processAttacheds
	 * @returns
	 */
	private mutateResponse(
		processAttacheds: ProcessAttached[]
	): ProcessAttached[] {
		let _processAttacheds: ProcessAttached[] = [];

		processAttacheds.map((item: any) => {
			let _processAttached: ProcessAttached | any = {
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
				attached: {
					id_attached: item.id_attached,
					company: { id_company: item.id_company },
					name_attached: item.name_attached,
					description_attached: item.description_attached,
					length_mb_attached: parseInt(item.length_mb_attached),
					required_attached: item.required_attached,
				},
				/**
				 * Generate structure of second level the entity (is important add the ids of entity)
				 * similar the return of read
				 */
			};
			/**
			 * delete ids of principal object level
			 */

			delete _processAttached.id_official;
			delete _processAttached.id_company;
			delete _processAttached.id_user;
			delete _processAttached.id_area;
			delete _processAttached.id_position;
			delete _processAttached.id_process;
			delete _processAttached.id_official;
			delete _processAttached.id_flow_version;
			delete _processAttached.number_process;
			delete _processAttached.date_process;
			delete _processAttached.generated_task;
			delete _processAttached.finalized_process;
			delete _processAttached.id_task;
			delete _processAttached.id_process;
			delete _processAttached.id_official;
			delete _processAttached.id_level;
			delete _processAttached.number_task;
			delete _processAttached.type_status_task;
			delete _processAttached.date_task;
			delete _processAttached.id_level;
			delete _processAttached.id_company;
			delete _processAttached.id_template;
			delete _processAttached.id_level_profile;
			delete _processAttached.id_level_status;
			delete _processAttached.name_level;
			delete _processAttached.description_level;
			delete _processAttached.id_attached;
			delete _processAttached.id_company;
			delete _processAttached.name_attached;
			delete _processAttached.description_attached;
			delete _processAttached.length_mb_attached;
			delete _processAttached.required_attached;

			delete _processAttached.id_person;
			delete _processAttached.id_type_user;
			delete _processAttached.name_user;
			delete _processAttached.password_user;
			delete _processAttached.avatar_user;
			delete _processAttached.status_user;

			delete _processAttached.id_academic;
			delete _processAttached.id_job;
			delete _processAttached.dni_person;
			delete _processAttached.name_person;
			delete _processAttached.last_name_person;
			delete _processAttached.address_person;
			delete _processAttached.phone_person;

			_processAttacheds.push(_processAttached);
		});

		return _processAttacheds;
	}
}
