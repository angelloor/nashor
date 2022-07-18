export interface DataLogin {
	ticket: string;
}

export enum Sities {
	NASHOR = 'nashor',
}

export enum Models {
	NASHOR = 'nashor',
}

export enum Types {
	process_attached = 'process_attached',
}

export enum Path {
	NASHOR = 'cm:process_attached',
	name = 'process_attached',
	title = 'Carpeta para los anexos',
	description = 'Carpeta para los anexos del proceso',
}

export class ProcessAttachedType {
	public id_process_attached: string;
	public id_official: string;
	public id_process: string;
	public id_task: string;
	public id_level: string;
	public id_attached: string;
	public file_name: string;
	public length_mb: string;
	public extension: string;
	public server_path: string;
	public upload_date: string;

	constructor(
		id_process_attached: string = '',
		id_official: string = '',
		id_process: string = '',
		id_task: string = '',
		id_level: string = '',
		id_attached: string = '',
		file_name: string = '',
		length_mb: string = '',
		extension: string = '',
		server_path: string = '',
		alfresco_path: string = '',
		upload_date: string = ''
	) {
		this.id_process_attached = id_process_attached;
		this.id_official = id_official;
		this.id_process = id_process;
		this.id_task = id_task;
		this.id_level = id_level;
		this.id_attached = id_attached;
		this.file_name = file_name;
		this.length_mb = length_mb;
		this.extension = extension;
		this.server_path = server_path;
		this.upload_date = upload_date;
	}
	/** Setters and Getters */
	set _id_process_attached(id_process_attached: string) {
		this.id_process_attached = id_process_attached;
	}
	get _id_process_attached() {
		return this.id_process_attached;
	}

	set _id_official(id_official: string) {
		this.id_official = id_official;
	}
	get _id_official() {
		return this.id_official;
	}

	set _id_process(id_process: string) {
		this.id_process = id_process;
	}
	get _id_process() {
		return this.id_process;
	}

	set _id_task(id_task: string) {
		this.id_task = id_task;
	}
	get _id_task() {
		return this.id_task;
	}

	set _id_level(id_level: string) {
		this.id_level = id_level;
	}
	get _id_level() {
		return this.id_level;
	}

	set _id_attached(id_attached: string) {
		this.id_attached = id_attached;
	}
	get _id_attached() {
		return this.id_attached;
	}

	set _file_name(file_name: string) {
		this.file_name = file_name;
	}
	get _file_name() {
		return this.file_name;
	}

	set _length_mb(length_mb: string) {
		this.length_mb = length_mb;
	}
	get _length_mb() {
		return this.length_mb;
	}

	set _extension(extension: string) {
		this.extension = extension;
	}
	get _extension() {
		return this.extension;
	}

	set _server_path(server_path: string) {
		this.server_path = server_path;
	}
	get _server_path() {
		return this.server_path;
	}

	set _upload_date(upload_date: string) {
		this.upload_date = upload_date;
	}
	get _upload_date() {
		return this.upload_date;
	}
}

export interface Documento {
	nombre: string;
	accesoDescarga: string;
	tipo: string;
	referencia: string;
	xPathLocationPadre: string;
	xPathLocation: string;
	propiedades: Propiedades;
}

interface Propiedades {
	'cm:title': string;
	'cm:creator': Autor;
	'cm:modifier': Autor;
	'cm:created': DateRegister;
	'cm:name': string;
	'sys:store-protocol': string;
	'sys:node-dbid': string;
	'sys:store-identifier': string;
	'sys:locale': string;
	'cm:modified': DateRegister;
	'cm:description': string;
	'sys:node-uuid': string;
}

interface Autor {
	firstName: string;
	lastName: string;
	displayName: string;
	userName: string;
}

interface DateRegister {
	iso8601: string;
	value: string;
}
