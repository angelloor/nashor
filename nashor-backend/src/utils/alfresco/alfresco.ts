import axios from 'axios';
import FormData from 'form-data';
import fs from 'fs';
import {
	DataLogin,
	Documento,
	ProcessAttachedType,
	Types,
} from './alfresco.types';

export class Alfresco {
	public alfresco_host: string;
	public alfresco_port: string;
	public alfresco_user: string;
	public alfresco_password: string;
	public modifier?: string;
	public model?: string;
	public type?: string;
	public sitie?: string;
	public path_to_save?: string;
	public file: ProcessAttachedType | any;
	private server: string;
	constructor(
		alfresco_host: string = process.env.ALFRESCO_HOST!,
		alfresco_port: string = process.env.ALFRESCO_PORT!,
		alfresco_user: string = process.env.ALFRESCO_USER!,
		alfresco_password: string = process.env.ALFRESCO_PASSWORD!,
		modifier: string = 'Angel Loor',
		model: string = '',
		type: string = '',
		sitie: string = '',
		path_to_save: string = '',
		file: ProcessAttachedType | any = ''
	) {
		this.alfresco_host = alfresco_host;
		this.alfresco_port = alfresco_port;
		this.alfresco_user = alfresco_user;
		this.alfresco_password = alfresco_password;
		this.modifier = modifier;
		this.model = model;
		this.type = type;
		this.sitie = sitie;
		this.path_to_save = path_to_save;
		this.file = file;
		this.server = `http://${this._alfresco_host}:${this._alfresco_port}`;
	}

	/** Setters and Getters */
	set _alfresco_host(alfresco_host: string) {
		this.alfresco_host = alfresco_host;
	}
	get _alfresco_host() {
		return this.alfresco_host;
	}

	set _alfresco_port(alfresco_port: string) {
		this.alfresco_port = alfresco_port;
	}
	get _alfresco_port() {
		return this.alfresco_port;
	}

	set _alfresco_user(alfresco_user: string) {
		this.alfresco_user = alfresco_user;
	}
	get _alfresco_user() {
		return this.alfresco_user;
	}

	set _alfresco_password(alfresco_password: string) {
		this.alfresco_password = alfresco_password;
	}
	get _alfresco_password() {
		return this.alfresco_password;
	}

	set _modifier(modifier: string) {
		this.modifier = modifier;
	}
	get _modifier() {
		return this.modifier!;
	}

	set _model(model: string) {
		this.model = model;
	}
	get _model() {
		return this.model!;
	}

	set _type(type: string) {
		this.type = type;
	}
	get _type() {
		return this.type!;
	}

	set _sitie(sitie: string) {
		this.sitie = sitie;
	}
	get _sitie() {
		return this.sitie!;
	}

	set _path_to_save(path_to_save: string) {
		this.path_to_save = path_to_save;
	}
	get _path_to_save() {
		return this.path_to_save!;
	}

	set _file(file: ProcessAttachedType | any) {
		this.file = file;
	}
	get _file() {
		return this.file!;
	}
	/**
	 * getTicket
	 * @returns
	 */
	private getTicket() {
		return new Promise<DataLogin>(async (resolve, reject) => {
			try {
				const urlService: string = `${this.server}/alfresco/service/api/login.json?u=${this._alfresco_user}&pw=${this._alfresco_password}`;

				await axios
					.get(urlService)
					.then(async (response: any) => {
						resolve(response.data.data);
					})
					.catch((error: any) => {
						reject(error.toString());
					});
			} catch (error: any) {
				reject(error.toString());
			}
		});
	}
	/**
	 * saveFile
	 * @returns
	 */
	saveFile = () => {
		return new Promise<string>(async (resolve, reject) => {
			const urlService: string = `${this.server}/alfresco/service/com/general/guardar`;

			let ticket: string = '';
			let formData: FormData = new FormData();

			await this.getTicket()
				.then((_dataLogin: DataLogin) => {
					ticket = _dataLogin.ticket;
				})
				.catch((error: any) => {
					reject(error);
				});

			await this.createFormData()
				.then((_formData: FormData) => {
					formData = _formData;
				})
				.catch((error: any) => {
					reject(error);
				});

			await axios
				.post(`${urlService}?alf_ticket=${ticket}`, formData, {
					headers: formData.getHeaders(),
				})
				.then(async (response: any) => {
					resolve(response.data.referencia);
				})
				.catch((error: any) => {
					reject(error.toString());
				});
		});
	};
	/**
	 * createFormData
	 * @returns
	 */
	createFormData = () => {
		return new Promise<FormData>((resolve, reject) => {
			try {
				const formData = new FormData();
				formData.append('archivo', fs.createReadStream(this.file.server_path));
				formData.append('modificadoPor', this.modifier);
				formData.append('tipo', `${this.model}:${this.type}`);
				formData.append(
					'ubicacion',
					`/app:company_home/st:sites/cm:${this.sitie}/cm:documentLibrary/${this.path_to_save}`
				);
				/**
				 * Armar propiedades de acuerdo al typo de archivo que se va a guardar
				 */
				if (this.type == Types.process_attached) {
					formData.append(
						'propiedades',
						`
						{
							"cm:name": {"value": "${this.file.file_name}${this.file.extension}","type": "string"},
							"${this.model}:id_process_attached": { "value": "${this.file.id_process_attached}", "type": "string" },
							"${this.model}:id_official": { "value": "${this.file.id_official}", "type": "string" },
							"${this.model}:id_process": { "value": "${this.file.id_process}", "type": "string" },
							"${this.model}:id_task": { "value": "${this.file.id_task}", "type": "string" },
							"${this.model}:id_level": { "value": "${this.file.id_level}", "type": "string" },
							"${this.model}:id_attached": { "value": "${this.file.id_attached}", "type": "string" },
							"${this.model}:file_name": { "value": "${this.file.file_name}", "type": "string" },
							"${this.model}:length_mb": { "value": "${this.file.length_mb}", "type": "string" },
							"${this.model}:extension": { "value": "${this.file.extension}", "type": "string" },
							"${this.model}:server_path": { "value": "${this.file.server_path}", "type": "string" },
							"${this.model}:upload_date": { "value": "${this.file.upload_date}", "type": "date" },
						}
					`
					);
				}
				resolve(formData);
			} catch (error: any) {
				reject(error.toString());
			}
		});
	};
	/**
	 * searchFile
	 * @param pathFinal
	 * @returns
	 */
	searchFile = (pathFinal: string) => {
		return new Promise<Documento[]>(async (resolve, reject) => {
			const urlService: string = `${this.server}/alfresco/service/com/general/buscar`;
			const path = `PATH:"/app:company_home/st:sites/cm:${this.sitie}/cm:documentLibrary${pathFinal}"`;

			let ticket: string = '';

			await this.getTicket()
				.then((_dataLogin: DataLogin) => {
					ticket = _dataLogin.ticket;
				})
				.catch((error: any) => {
					reject(error);
				});

			await axios
				.get(`${urlService}?alf_ticket=${ticket}&query=${path}`)
				.then(async (response: any) => {
					const documentos: Documento[] = response.data.documentos;
					resolve(documentos);
				})
				.catch((error: any) => {
					reject(error.toString());
				});
		});
	};
	/**
	 * createFolder
	 * @param nodeId
	 * @param name
	 * @param title
	 * @param description
	 * @returns
	 */
	createFolder = (
		nodeId: string,
		name: string,
		title: string,
		description: string
	) => {
		return new Promise(async (resolve, reject) => {
			const urlService: string = `${this.server}/alfresco/api/-default-/public/alfresco/versions/1/nodes`;

			let ticket: string = '';

			await this.getTicket()
				.then((_dataLogin: DataLogin) => {
					ticket = _dataLogin.ticket;
				})
				.catch((error: any) => {
					reject(error);
				});

			const body = {
				name: name,
				nodeType: 'cm:folder',
				properties: {
					'cm:title': title,
					'cm:description': description,
				},
			};

			await axios
				.post(`${urlService}/${nodeId}/children?alf_ticket=${ticket}`, body, {
					method: 'POST',
					headers: { 'Content-Type': 'application/json' },
				})
				.then(async (response: any) => {
					resolve(response.statusText);
				})
				.catch((error: any) => {
					reject(error.toString());
				});
		});
	};
	/**
	 * deleteFolder
	 * @param nodeId
	 * @returns
	 */
	deleteFolder = (nodeId: string) => {
		return new Promise<string>(async (resolve, reject) => {
			const urlService: string = `${this.server}/alfresco/api/-default-/public/alfresco/versions/1/nodes`;

			let ticket: string = '';

			await this.getTicket()
				.then((_dataLogin: DataLogin) => {
					ticket = _dataLogin.ticket;
				})
				.catch((error: any) => {
					reject(error);
				});

			await axios
				.delete(`${urlService}/${nodeId}/?alf_ticket=${ticket}`, {
					method: 'DELETE',
					headers: { 'Content-Type': 'application/json' },
				})
				.then(async (response: any) => {
					if (response.status == 204) {
						resolve('MessageAPI: Carpeta eliminada correctamente');
					} else {
						reject(response);
					}
				})
				.catch((error: any) => {
					reject(error.toString());
				});
		});
	};
}
