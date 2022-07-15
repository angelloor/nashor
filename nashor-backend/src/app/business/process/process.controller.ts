import { checkDateString, FullDate } from '../../../utils/date';
import { verifyToken } from '../../../utils/jwt';
import { _messages } from '../../../utils/message/message';
import { Process } from './process.class';

export const validation = (process: Process, url: string, token: string) => {
	return new Promise<Process | Process[] | boolean | any>(
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
								process.id_user_,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'id_process',
								process.id_process,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'number_process',
								process.number_process,
								'string',
								150
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'date_process',
								process.date_process,
								'string',
								30
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});

							/**
							 * checkDateString
							 */
							await checkDateString(process.date_process!)
								.then((fullDate: FullDate) => {
									process.date_process = `${fullDate.fullYear}-${fullDate.month}-${fullDate.day} ${fullDate.hours}:${fullDate.minutes}:${fullDate.seconds}.${fullDate.milliSeconds}`;
								})
								.catch(() => {
									validationStatus = true;
									reject({
										..._messages[12],
										description: _messages[12].description.replace(
											'value_date',
											process.date_process!
										),
									});
								});
						}

						if (url == '/update') {
							attributeValidate(
								'generated_task',
								process.generated_task,
								'boolean'
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'finalized_process',
								process.finalized_process,
								'boolean'
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation processType
						 */

						if (url == '/create' || url == '/update') {
							attributeValidate(
								'id_process_type',
								process.process_type.id_process_type,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation official
						 */

						if (url == '/update') {
							attributeValidate(
								'id_official',
								process.official.id_official,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation flowVersion
						 */

						if (url == '/update') {
							attributeValidate(
								'id_flow_version',
								process.flow_version.id_flow_version,
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
							const _process = new Process();
							/**
							 * Execute the url depending on the path
							 */
							if (url == '/create') {
								/** set required attributes for action */
								_process.id_user_ = process.id_user_;
								_process.process_type = process.process_type;
								await _process
									.create()
									.then((_process: Process) => {
										resolve(_process);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 10) == '/queryRead') {
								/** set required attributes for action */
								_process.number_process = process.number_process;
								await _process
									.queryRead()
									.then((_processs: Process[]) => {
										resolve(_processs);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 23) == '/byProcessTypeQueryRead') {
								const id_process_type: any = process.process_type;

								if (id_process_type >= 1) {
									/** set required attributes for action */
									_process.process_type = process.process_type;
									_process.number_process = process.number_process;
									await _process
										.byProcessTypeQueryRead()
										.then((_processs: Process[]) => {
											resolve(_processs);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'process_type'
										),
									});
								}
							} else if (url.substring(0, 20) == '/byOfficialQueryRead') {
								const id_official: any = process.official;

								if (id_official >= 0) {
									/** set required attributes for action */
									_process.official = process.official;
									_process.number_process = process.number_process;
									await _process
										.byOfficialQueryRead()
										.then((_processs: Process[]) => {
											resolve(_processs);
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
							} else if (url.substring(0, 23) == '/byFlowVersionQueryRead') {
								const id_flow_version: any = process.flow_version;

								if (id_flow_version >= 1) {
									/** set required attributes for action */
									_process.flow_version = process.flow_version;
									_process.number_process = process.number_process;
									await _process
										.byFlowVersionQueryRead()
										.then((_processs: Process[]) => {
											resolve(_processs);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'flow_version'
										),
									});
								}
							} else if (url.substring(0, 13) == '/specificRead') {
								const id_process: any = process.id_process;

								if (id_process >= 1) {
									/** set required attributes for action */
									_process.id_process = process.id_process;
									await _process
										.specificRead()
										.then((_process: Process) => {
											resolve(_process);
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
							} else if (url == '/update') {
								/** set required attributes for action */
								_process.id_user_ = process.id_user_;
								_process.id_process = process.id_process;
								_process.process_type = process.process_type;
								_process.official = process.official;
								_process.flow_version = process.flow_version;
								_process.number_process = process.number_process;
								_process.date_process = process.date_process;
								_process.generated_task = process.generated_task;
								_process.finalized_process = process.finalized_process;
								await _process
									.update()
									.then((_process: Process) => {
										resolve(_process);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 7) == '/delete') {
								/** set required attributes for action */
								_process.id_user_ = process.id_user_;
								_process.id_process = process.id_process;
								await _process
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
