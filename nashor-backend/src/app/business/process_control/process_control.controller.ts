import { verifyToken } from '../../../utils/jwt';
import { _messages } from '../../../utils/message/message';
import { ProcessControl } from './process_control.class';

export const validation = (
	process_control: ProcessControl,
	url: string,
	token: string
) => {
	return new Promise<ProcessControl | ProcessControl[] | boolean | any>(
		async (resolve, reject) => {
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
						if (url == '/create' || url == '/update') {
							attributeValidate(
								'id_user_',
								process_control.id_user_,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'id_process_control',
								process_control.id_process_control,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/create' || url == '/update') {
							attributeValidate(
								'value_process_control',
								process_control.value_process_control,
								'string',
								9999999999
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'last_change_process_control',
								process_control.last_change_process_control,
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
								process_control.official.id_official,
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
								process_control.process.id_process,
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
								process_control.task.id_task,
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
								process_control.level.id_level,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation control
						 */

						if (url == '/create' || url == '/update') {
							attributeValidate(
								'id_control',
								process_control.control.id_control,
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
							const _process_control = new ProcessControl();
							/**
							 * Execute the url depending on the path
							 */
							if (url == '/create') {
								/** set required attributes for action */
								_process_control.id_user_ = process_control.id_user_;
								_process_control.official = process_control.official;
								_process_control.process = process_control.process;
								_process_control.task = process_control.task;
								_process_control.level = process_control.level;
								_process_control.control = process_control.control;
								_process_control.value_process_control =
									process_control.value_process_control;
								await _process_control
									.create()
									.then((_processControl: ProcessControl) => {
										resolve(_processControl);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 15) == '/byOfficialRead') {
								const id_official: any = process_control.official;

								if (id_official >= 1) {
									/** set required attributes for action */
									_process_control.official = process_control.official;
									_process_control.process = process_control.process;
									await _process_control
										.byOfficialRead()
										.then((_process_controls: ProcessControl[]) => {
											resolve(_process_controls);
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
								const id_process: any = process_control.process;

								if (id_process >= 1) {
									/** set required attributes for action */
									_process_control.process = process_control.process;
									_process_control.process = process_control.process;
									await _process_control
										.byProcessRead()
										.then((_process_controls: ProcessControl[]) => {
											resolve(_process_controls);
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
								const id_task: any = process_control.task;

								if (id_task >= 1) {
									/** set required attributes for action */
									_process_control.task = process_control.task;
									_process_control.process = process_control.process;
									await _process_control
										.byTaskRead()
										.then((_process_controls: ProcessControl[]) => {
											resolve(_process_controls);
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
								const id_level: any = process_control.level;

								if (id_level >= 1) {
									/** set required attributes for action */
									_process_control.level = process_control.level;
									_process_control.process = process_control.process;
									await _process_control
										.byLevelRead()
										.then((_process_controls: ProcessControl[]) => {
											resolve(_process_controls);
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
							} else if (url.substring(0, 14) == '/byControlRead') {
								const id_control: any = process_control.control;

								if (id_control >= 1) {
									/** set required attributes for action */
									_process_control.control = process_control.control;
									_process_control.process = process_control.process;
									await _process_control
										.byControlRead()
										.then((_process_controls: ProcessControl[]) => {
											resolve(_process_controls);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'control'
										),
									});
								}
							} else if (url.substring(0, 13) == '/specificRead') {
								const id_process_control: any =
									process_control.id_process_control;

								if (id_process_control >= 1) {
									/** set required attributes for action */
									_process_control.id_process_control =
										process_control.id_process_control;
									await _process_control
										.specificRead()
										.then((_processControl: ProcessControl) => {
											resolve(_processControl);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'process_control'
										),
									});
								}
							} else if (url == '/update') {
								/** set required attributes for action */
								_process_control.id_user_ = process_control.id_user_;
								_process_control.id_process_control =
									process_control.id_process_control;
								_process_control.official = process_control.official;
								_process_control.process = process_control.process;
								_process_control.task = process_control.task;
								_process_control.level = process_control.level;
								_process_control.control = process_control.control;
								_process_control.value_process_control =
									process_control.value_process_control;
								_process_control.last_change_process_control =
									process_control.last_change_process_control;
								await _process_control
									.update()
									.then((_processControl: ProcessControl) => {
										resolve(_processControl);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 7) == '/delete') {
								/** set required attributes for action */
								_process_control.id_user_ = process_control.id_user_;
								_process_control.id_process_control =
									process_control.id_process_control;
								await _process_control
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
