import { verifyToken } from '../../../utils/jwt';
import { _messages } from '../../../utils/message/message';
import { ProcessComment } from './process_comment.class';

export const validation = (
	process_comment: ProcessComment,
	url: string,
	token: string
) => {
	return new Promise<ProcessComment | ProcessComment[] | boolean | any>(
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
								process_comment.id_user_,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'id_process_comment',
								process_comment.id_process_comment,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'value_process_comment',
								process_comment.value_process_comment,
								'string',
								250
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'date_process_comment',
								process_comment.date_process_comment,
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

						if (url == '/update') {
							attributeValidate(
								'id_official',
								process_comment.official.id_official,
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

						if (url == '/update') {
							attributeValidate(
								'id_process',
								process_comment.process.id_process,
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

						if (url == '/update') {
							attributeValidate(
								'id_task',
								process_comment.task.id_task,
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

						if (url == '/update') {
							attributeValidate(
								'id_level',
								process_comment.level.id_level,
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
							const _process_comment = new ProcessComment();
							/**
							 * Execute the url depending on the path
							 */
							if (url == '/create') {
								/** set required attributes for action */
								_process_comment.id_user_ = process_comment.id_user_;
								_process_comment.official = process_comment.official;
								_process_comment.process = process_comment.process;
								_process_comment.task = process_comment.task;
								_process_comment.level = process_comment.level;
								await _process_comment
									.create()
									.then((_processComment: ProcessComment) => {
										resolve(_processComment);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 15) == '/byOfficialRead') {
								const id_official: any = process_comment.official;

								if (id_official >= 1) {
									/** set required attributes for action */
									_process_comment.official = process_comment.official;
									_process_comment.process = process_comment.process;
									await _process_comment
										.byOfficialRead()
										.then((_process_comments: ProcessComment[]) => {
											resolve(_process_comments);
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
								const id_process: any = process_comment.process;

								if (id_process >= 1) {
									/** set required attributes for action */
									_process_comment.process = process_comment.process;
									_process_comment.process = process_comment.process;
									await _process_comment
										.byProcessRead()
										.then((_process_comments: ProcessComment[]) => {
											resolve(_process_comments);
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
								const id_task: any = process_comment.task;

								if (id_task >= 1) {
									/** set required attributes for action */
									_process_comment.task = process_comment.task;
									_process_comment.process = process_comment.process;
									await _process_comment
										.byTaskRead()
										.then((_process_comments: ProcessComment[]) => {
											resolve(_process_comments);
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
								const id_level: any = process_comment.level;

								if (id_level >= 1) {
									/** set required attributes for action */
									_process_comment.level = process_comment.level;
									_process_comment.process = process_comment.process;
									await _process_comment
										.byLevelRead()
										.then((_process_comments: ProcessComment[]) => {
											resolve(_process_comments);
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
								const id_process_comment: any =
									process_comment.id_process_comment;

								if (id_process_comment >= 1) {
									/** set required attributes for action */
									_process_comment.id_process_comment =
										process_comment.id_process_comment;
									await _process_comment
										.specificRead()
										.then((_processComment: ProcessComment) => {
											resolve(_processComment);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'process_comment'
										),
									});
								}
							} else if (url == '/update') {
								/** set required attributes for action */
								_process_comment.id_user_ = process_comment.id_user_;
								_process_comment.id_process_comment =
									process_comment.id_process_comment;
								_process_comment.official = process_comment.official;
								_process_comment.process = process_comment.process;
								_process_comment.task = process_comment.task;
								_process_comment.level = process_comment.level;
								_process_comment.value_process_comment =
									process_comment.value_process_comment;
								_process_comment.date_process_comment =
									process_comment.date_process_comment;
								await _process_comment
									.update()
									.then((_processComment: ProcessComment) => {
										resolve(_processComment);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 7) == '/delete') {
								/** set required attributes for action */
								_process_comment.id_user_ = process_comment.id_user_;
								_process_comment.id_process_comment =
									process_comment.id_process_comment;
								await _process_comment
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
