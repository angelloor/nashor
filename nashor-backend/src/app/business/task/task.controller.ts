import { checkDateString, FullDate } from '../../../utils/date';
import { verifyToken } from '../../../utils/jwt';
import { _messages } from '../../../utils/message/message';
import {
	Task,
	validationTypeActionTask,
	validationTypeStatusTask,
} from './task.class';

export const validation = (task: Task, url: string, token: string) => {
	return new Promise<Task | Task[] | boolean | any>(async (resolve, reject) => {
		/**
		 * Capa de Autentificación con el token
		 */
		let validationStatus: boolean = false;

		if (token) {
			await verifyToken(token)
				.then(async () => {
					/**
					 * Capa de validaciones
					 */
					if (
						url == '/create' ||
						url == '/update' ||
						url == '/reasign' ||
						url == '/send'
					) {
						attributeValidate('id_user_', task.id_user_, 'number', 10).catch(
							(err) => {
								validationStatus = true;
								reject(err);
							}
						);
					}

					if (url == '/update' || url == '/reasign' || url == '/send') {
						attributeValidate('id_task', task.id_task, 'number', 10).catch(
							(err) => {
								validationStatus = true;
								reject(err);
							}
						);
					}

					if (url == '/update' || url == '/reasign' || url == '/send') {
						attributeValidate('id_task', task.number_task, 'string', 120).catch(
							(err) => {
								validationStatus = true;
								reject(err);
							}
						);
					}

					if (url == '/update' || url == '/reasign' || url == '/send') {
						attributeValidate(
							'creation_date_task',
							task.creation_date_task,
							'string',
							30
						).catch((err) => {
							validationStatus = true;
							reject(err);
						});

						/**
						 * checkDateString
						 */
						await checkDateString(task.creation_date_task!)
							.then((fullDate: FullDate) => {
								task.creation_date_task = `${fullDate.fullYear}-${fullDate.month}-${fullDate.day} ${fullDate.hours}:${fullDate.minutes}:${fullDate.seconds}.${fullDate.milliSeconds}`;
							})
							.catch(() => {
								validationStatus = true;
								reject({
									..._messages[12],
									description: _messages[12].description.replace(
										'value_date',
										task.creation_date_task!
									),
								});
							});
					}

					if (url == '/update' || url == '/reasign' || url == '/send') {
						validationTypeStatusTask(
							'type_status_task',
							task.type_status_task!
						).catch((err) => {
							validationStatus = true;
							reject(err);
						});
					}

					if (url == '/update' || url == '/reasign' || url == '/send') {
						validationTypeActionTask(
							'type_action_task',
							task.type_action_task!
						).catch((err) => {
							validationStatus = true;
							reject(err);
						});
					}

					if (url == '/update' || url == '/reasign' || url == '/send') {
						attributeValidate(
							'action_date_task',
							task.action_date_task,
							'string',
							30
						).catch((err) => {
							validationStatus = true;
							reject(err);
						});

						/**
						 * checkDateString
						 */
						await checkDateString(task.action_date_task!)
							.then((fullDate: FullDate) => {
								task.action_date_task = `${fullDate.fullYear}-${fullDate.month}-${fullDate.day} ${fullDate.hours}:${fullDate.minutes}:${fullDate.seconds}.${fullDate.milliSeconds}`;
							})
							.catch(() => {
								validationStatus = true;
								reject({
									..._messages[12],
									description: _messages[12].description.replace(
										'value_date',
										task.action_date_task!
									),
								});
							});
					}

					/**
					 * Validation process
					 */

					if (url == '/update' || url == '/reasign' || url == '/send') {
						attributeValidate(
							'id_process',
							task.process.id_process,
							'number',
							10
						).catch((err) => {
							validationStatus = true;
							reject(err);
						});
					}

					/**
					 * Validation official
					 */

					if (url == '/update' || url == '/reasign' || url == '/send') {
						attributeValidate(
							'id_official',
							task.official.id_official,
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

					if (url == '/update' || url == '/reasign' || url == '/send') {
						attributeValidate(
							'id_level',
							task.level.id_level,
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
						const _task = new Task();
						/**
						 * Execute the url depending on the path
						 */
						if (url == '/create') {
							/** set required attributes for action */
							_task.id_user_ = task.id_user_;
							_task.process = task.process;
							_task.official = task.official;
							_task.level = task.level;
							await _task
								.create()
								.then((_task: Task) => {
									resolve(_task);
								})
								.catch((error: any) => {
									reject(error);
								});
						} else if (url.substring(0, 10) == '/queryRead') {
							/** set required attributes for action */
							_task.process = task.process;
							await _task
								.queryRead()
								.then((_tasks: Task[]) => {
									resolve(_tasks);
								})
								.catch((error: any) => {
									reject(error);
								});
						} else if (url.substring(0, 19) == '/byProcessQueryRead') {
							const id_process: any = task.level;

							if (id_process >= 1) {
								/** set required attributes for action */
								_task.level = task.level;
								_task.process = task.process;
								await _task
									.byProcessQueryRead()
									.then((_tasks: Task[]) => {
										resolve(_tasks);
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
						} else if (url.substring(0, 20) == '/byOfficialQueryRead') {
							const id_official: any = task.official;

							if (id_official >= 0) {
								/** set required attributes for action */
								_task.official = task.official;
								_task.process = task.process;
								await _task
									.byOfficialQueryRead()
									.then((_tasks: Task[]) => {
										resolve(_tasks);
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
						} else if (url.substring(0, 17) == '/byLevelQueryRead') {
							const id_level: any = task.level;

							if (id_level >= 1) {
								/** set required attributes for action */
								_task.level = task.level;
								_task.process = task.process;
								await _task
									.byLevelQueryRead()
									.then((_tasks: Task[]) => {
										resolve(_tasks);
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
						} else if (url.substring(0, 13) == '/specificRead') {
							const id_task: any = task.id_task;

							if (id_task >= 1) {
								/** set required attributes for action */
								_task.id_task = task.id_task;
								await _task
									.specificRead()
									.then((_task: Task) => {
										resolve(_task);
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
						} else if (url == '/update') {
							/** set required attributes for action */
							_task.id_user_ = task.id_user_;
							_task.id_task = task.id_task;
							_task.process = task.process;
							_task.official = task.official;
							_task.level = task.level;
							_task.number_task = task.number_task;
							_task.creation_date_task = task.creation_date_task;
							_task.type_status_task = task.type_status_task;
							_task.type_action_task = task.type_action_task;
							_task.action_date_task = task.action_date_task;
							await _task
								.update()
								.then((_task: Task) => {
									resolve(_task);
								})
								.catch((error: any) => {
									reject(error);
								});
						} else if (url == '/reasign') {
							/** set required attributes for action */
							_task.id_user_ = task.id_user_;
							_task.id_task = task.id_task;
							_task.process = task.process;
							_task.official = task.official;
							_task.level = task.level;
							_task.number_task = task.number_task;
							_task.creation_date_task = task.creation_date_task;
							_task.type_status_task = task.type_status_task;
							_task.type_action_task = task.type_action_task;
							_task.action_date_task = task.action_date_task;
							await _task
								.reasign()
								.then((_task: Task) => {
									resolve(_task);
								})
								.catch((error: any) => {
									reject(error);
								});
						} else if (url == '/send') {
							/** set required attributes for action */
							_task.id_user_ = task.id_user_;
							_task.id_task = task.id_task;
							_task.process = task.process;
							_task.official = task.official;
							_task.level = task.level;
							_task.number_task = task.number_task;
							_task.creation_date_task = task.creation_date_task;
							_task.type_status_task = task.type_status_task;
							_task.type_action_task = task.type_action_task;
							_task.action_date_task = task.action_date_task;
							await _task
								.send()
								.then((_task: Task) => {
									resolve(_task);
								})
								.catch((error: any) => {
									reject(error);
								});
						} else if (url.substring(0, 7) == '/delete') {
							/** set required attributes for action */
							_task.id_user_ = task.id_user_;
							_task.id_task = task.id_task;
							await _task
								.delete()
								.then((response: boolean) => {
									resolve(response);
								})
								.catch((error: any) => {
									reject(error);
								});
						}
					}
				})
				.catch((error) => {
					reject(error);
				});
		} else {
			reject(_messages[5]);
		}
	});
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
