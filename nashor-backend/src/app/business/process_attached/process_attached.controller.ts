import fs from 'fs';
import path from 'path';
import { generateRandomNumber } from '../../../utils/global';
import { verifyToken } from '../../../utils/jwt';
import { _messages } from '../../../utils/message/message';
import { Payload } from '../../core/auth/auth.types';
import { ProcessAttached } from './process_attached.class';

var ID_COMPANY: number = 0;

export const validation = (
	process_attached: ProcessAttached,
	url: string,
	token: string
) => {
	return new Promise<ProcessAttached | ProcessAttached[] | boolean | any>(
		async (resolve, reject) => {
			/**
			 * Capa de Autentificación con el token
			 */
			let validationStatus: boolean = false;

			if (token) {
				await verifyToken(token)
					.then(async (decoded: Payload) => {
						ID_COMPANY = decoded.company.id_company;
						/**
						 * Capa de validaciones
						 */
						if (url == '/create' || url == '/update') {
							attributeValidate(
								'id_user_',
								process_attached.id_user_,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'id_process_attached',
								process_attached.id_process_attached,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/create' || url == '/update') {
							attributeValidate(
								'file_name',
								process_attached.file_name,
								'string',
								250
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/create' || url == '/update') {
							attributeValidate(
								'length_mb',
								process_attached.length_mb,
								'string',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/create' || url == '/update') {
							attributeValidate(
								'extension',
								process_attached.extension,
								'string',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'server_path',
								process_attached.server_path,
								'string',
								250
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'alfresco_path',
								process_attached.alfresco_path,
								'string',
								250
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'upload_date',
								process_attached.upload_date,
								'string',
								30
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation official
						 */

						if (url == '/create' || url == '/update') {
							attributeValidate(
								'id_official',
								process_attached.official.id_official,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation process
						 */

						if (url == '/create' || url == '/update') {
							attributeValidate(
								'id_process',
								process_attached.process.id_process,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation task
						 */

						if (url == '/create' || url == '/update') {
							attributeValidate(
								'id_task',
								process_attached.task.id_task,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation level
						 */

						if (url == '/create' || url == '/update') {
							attributeValidate(
								'id_level',
								process_attached.level.id_level,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation attached
						 */

						if (url == '/update') {
							attributeValidate(
								'id_attached',
								process_attached.attached.id_attached,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Continuar solo si no ocurrio errores en la validación
						 */
						if (!validationStatus) {
							/**
							 * Instance the class
							 */
							const _process_attached = new ProcessAttached();
							/**
							 * Execute the url depending on the path
							 */
							if (url == '/create') {
								const pathBase: string = `./file_store`;
								/**
								 * Folder base
								 */
								if (!fs.existsSync(pathBase)) {
									fs.mkdir(pathBase, (error) => {
										if (error) {
											reject(`Ocurrió un error al crear la carpeta base`);
										}
									});
								}
								/**
								 * Folder process_attached
								 */
								const pathProcessAttached: string = `./file_store/process_attached`;
								if (!fs.existsSync(pathProcessAttached)) {
									fs.mkdir(pathProcessAttached, (error) => {
										if (error) {
											reject(
												`Ocurrió un error al crear la carpeta process_attached`
											);
										}
									});
								}
								/**
								 * Folder process
								 */
								const pathProcess: string = `./file_store/process_attached/${process_attached.process.id_process}`;
								if (!fs.existsSync(pathProcess)) {
									fs.mkdir(pathProcess, (error) => {
										if (error) {
											reject(
												`Ocurrió un error al crear la carpeta process ${process_attached.process.id_process}`
											);
										}
									});
								}
								/**
								 * Folder level
								 */
								const pathLevel: string = `./file_store/process_attached/${process_attached.process.id_process}/${process_attached.level.id_level}`;
								if (!fs.existsSync(pathLevel)) {
									fs.mkdir(pathLevel, (error) => {
										if (error) {
											reject(
												`Ocurrió un error al crear la carpeta level ${process_attached.level.id_level}`
											);
										}
									});
								}

								const pathInitialFile: string = `./${process_attached.file_name}${process_attached.extension}`;
								/**
								 * Create folder task
								 */
								if (fs.existsSync(pathInitialFile)) {
									const pathTask = `./file_store/process_attached/${process_attached.process.id_process}/${process_attached.level.id_level}/${process_attached.task.id_task}`;

									if (!fs.existsSync(pathTask)) {
										fs.mkdir(pathTask, (error) => {
											if (error) {
												reject(
													`Ocurrió un error al crear la carpeta  task ${process_attached.task._action_date_task}`
												);
											}
										});
									}

									const nameFile = `${
										process_attached.file_name
									}_${generateRandomNumber(6)}`;

									const newPath: string = `${pathTask}/${nameFile}${process_attached.extension}`;

									fs.rename(pathInitialFile, newPath, async (err) => {
										if (err) {
											reject(
												`Ocurrió un error al guardar el archivo ${process_attached.file_name}`
											);
										} else {
											/** set required attributes for action */
											/** set required attributes for action */
											_process_attached.id_user_ = process_attached.id_user_;
											_process_attached.official = process_attached.official;
											_process_attached.process = process_attached.process;
											_process_attached.task = process_attached.task;
											_process_attached.level = process_attached.level;
											_process_attached.attached = process_attached.attached;
											_process_attached.file_name = nameFile;
											_process_attached.length_mb = process_attached.length_mb;
											_process_attached.extension = process_attached.extension;
											_process_attached.server_path = newPath;

											await _process_attached
												.create(ID_COMPANY)
												.then((_processAttached: ProcessAttached) => {
													resolve(_processAttached);
												})
												.catch((error: any) => {
													reject(error);
												});
										}
									});
								} else {
									reject('No se recibio el archivo');
								}
							} else if (url.substring(0, 15) == '/byOfficialRead') {
								const id_official: any = process_attached.official;

								if (id_official >= 1) {
									/** set required attributes for action */
									_process_attached.official = process_attached.official;
									_process_attached.process = process_attached.process;
									await _process_attached
										.byOfficialRead()
										.then((_process_attacheds: ProcessAttached[]) => {
											resolve(_process_attacheds);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'official'
										),
									});
								}
							} else if (url.substring(0, 14) == '/byProcessRead') {
								const id_process: any = process_attached.process;

								if (id_process >= 1) {
									/** set required attributes for action */
									_process_attached.process = process_attached.process;
									_process_attached.process = process_attached.process;
									await _process_attached
										.byProcessRead()
										.then((_process_attacheds: ProcessAttached[]) => {
											resolve(_process_attacheds);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'process'
										),
									});
								}
							} else if (url.substring(0, 11) == '/byTaskRead') {
								const id_task: any = process_attached.task;

								if (id_task >= 1) {
									/** set required attributes for action */
									_process_attached.task = process_attached.task;
									_process_attached.process = process_attached.process;
									await _process_attached
										.byTaskRead()
										.then((_process_attacheds: ProcessAttached[]) => {
											resolve(_process_attacheds);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'task'
										),
									});
								}
							} else if (url.substring(0, 12) == '/byLevelRead') {
								const id_level: any = process_attached.level;

								if (id_level >= 1) {
									/** set required attributes for action */
									_process_attached.level = process_attached.level;
									_process_attached.process = process_attached.process;
									await _process_attached
										.byLevelRead()
										.then((_process_attacheds: ProcessAttached[]) => {
											resolve(_process_attacheds);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'level'
										),
									});
								}
							} else if (url.substring(0, 15) == '/byAttachedRead') {
								const id_attached: any = process_attached.attached;

								if (id_attached >= 1) {
									/** set required attributes for action */
									_process_attached.attached = process_attached.attached;
									_process_attached.process = process_attached.process;
									await _process_attached
										.byAttachedRead()
										.then((_process_attacheds: ProcessAttached[]) => {
											resolve(_process_attacheds);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'attached'
										),
									});
								}
							} else if (url.substring(0, 13) == '/specificRead') {
								const id_process_attached: any =
									process_attached.id_process_attached;

								if (id_process_attached >= 1) {
									/** set required attributes for action */
									_process_attached.id_process_attached =
										process_attached.id_process_attached;
									await _process_attached
										.specificRead()
										.then((_processAttached: ProcessAttached) => {
											resolve(_processAttached);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'process_attached'
										),
									});
								}
							} else if (url == '/update') {
								/** set required attributes for action */
								_process_attached.id_user_ = process_attached.id_user_;
								_process_attached.id_process_attached =
									process_attached.id_process_attached;
								_process_attached.official = process_attached.official;
								_process_attached.process = process_attached.process;
								_process_attached.task = process_attached.task;
								_process_attached.level = process_attached.level;
								_process_attached.attached = process_attached.attached;
								_process_attached.file_name = process_attached.file_name;
								_process_attached.length_mb = process_attached.length_mb;
								_process_attached.extension = process_attached.extension;
								_process_attached.server_path = process_attached.server_path;
								_process_attached.alfresco_path =
									process_attached.alfresco_path;
								_process_attached.upload_date = process_attached.upload_date;
								await _process_attached
									.update()
									.then((_processAttached: ProcessAttached) => {
										resolve(_processAttached);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 7) == '/delete') {
								/** set required attributes for action */
								_process_attached.id_user_ = process_attached.id_user_;
								_process_attached.id_process_attached =
									process_attached.id_process_attached;
								await _process_attached
									.delete()
									.then((response: boolean) => {
										resolve(response);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url == '/downloadFile') {
								/** set required attributes for action */
								_process_attached.server_path = process_attached.server_path;

								/**
								 * Armar el path final
								 */
								const pathFinal = `${path.resolve(
									'./'
								)}${_process_attached.server_path?.substring(
									1,
									_process_attached.server_path.length
								)}`;
								/**
								 * Si existe el comprobante segun el path, resolvemos el path Final
								 */
								if (fs.existsSync(pathFinal)) {
									resolve(pathFinal);
								} else {
									reject('No se encontro el recurso!');
								}
							}
						}
					})
					.catch((error) => {
						reject(error);
					});
			} else {
				reject(_messages[5]);
			}
		}
	);
};

/**
 * Función para validar un campo de acuerdo a los criterios ingresados
 * @param attribute nombre del atributo a validar
 * @param value valor a validar
 * @param type tipo de dato correcto del atributo (string, number, boolean, object)
 * @param _length longitud correcta del atributo
 * @returns true || error
 */
const attributeValidate = (
	attribute: string,
	value: any,
	type: string,
	_length: number = 0
) => {
	return new Promise<Boolean>((resolve, reject) => {
		if (value != undefined || value != null) {
			if (typeof value == `${type}`) {
				if (typeof value == 'string' || typeof value == 'number') {
					if (value.toString().length > _length) {
						reject({
							..._messages[8],
							description: _messages[8].description
								.replace('_nameAttribute', `${attribute}`)
								.replace('_expectedCharacters', `${_length}`),
						});
					} else {
						resolve(true);
					}
				} else {
					resolve(true);
				}
			} else {
				reject({
					..._messages[7],
					description: _messages[7].description
						.replace('_nameAttribute', `${attribute}`)
						.replace('_expectedType', `${type}`),
				});
			}
		} else {
			reject({
				..._messages[6],
				description: _messages[6].description.replace(
					'_nameAttribute',
					`${attribute}`
				),
			});
		}
	});
};
