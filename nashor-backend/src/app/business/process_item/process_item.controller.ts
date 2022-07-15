import { verifyToken } from '../../../utils/jwt';
import { _messages } from '../../../utils/message/message';
import { ProcessItem } from './process_item.class';

export const validation = (
	process_item: ProcessItem,
	url: string,
	token: string
) => {
	return new Promise<ProcessItem | ProcessItem[] | boolean | any>(
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
								process_item.id_user_,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'id_process_item',
								process_item.id_process_item,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'amount_process_item',
								process_item.amount_process_item,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'features_process_item',
								process_item.features_process_item,
								'string',
								250
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'entry_date_process_item',
								process_item.entry_date_process_item,
								'timestamp without time zone'
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
								process_item.official.id_official,
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
								process_item.process.id_process,
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
								process_item.task.id_task,
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
								process_item.level.id_level,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation item
						 */

						if (url == '/update') {
							attributeValidate(
								'id_item',
								process_item.item.id_item,
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
							const _process_item = new ProcessItem();
							/**
							 * Execute the url depending on the path
							 */
							if (url == '/create') {
								/** set required attributes for action */
								_process_item.id_user_ = process_item.id_user_;
								await _process_item
									.create()
									.then((_processItem: ProcessItem) => {
										resolve(_processItem);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 15) == '/byOfficialRead') {
								const id_official: any = process_item.official;

								if (id_official >= 1) {
									/** set required attributes for action */
									_process_item.official = process_item.official;
									await _process_item
										.byOfficialRead()
										.then((_process_items: ProcessItem[]) => {
											resolve(_process_items);
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
								const id_process: any = process_item.process;

								if (id_process >= 1) {
									/** set required attributes for action */
									_process_item.process = process_item.process;
									await _process_item
										.byProcessRead()
										.then((_process_items: ProcessItem[]) => {
											resolve(_process_items);
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
								const id_task: any = process_item.task;

								if (id_task >= 1) {
									/** set required attributes for action */
									_process_item.task = process_item.task;
									await _process_item
										.byTaskRead()
										.then((_process_items: ProcessItem[]) => {
											resolve(_process_items);
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
								const id_level: any = process_item.level;

								if (id_level >= 1) {
									/** set required attributes for action */
									_process_item.level = process_item.level;
									await _process_item
										.byLevelRead()
										.then((_process_items: ProcessItem[]) => {
											resolve(_process_items);
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
							} else if (url.substring(0, 11) == '/byItemRead') {
								const id_item: any = process_item.item;

								if (id_item >= 1) {
									/** set required attributes for action */
									_process_item.item = process_item.item;
									await _process_item
										.byItemRead()
										.then((_process_items: ProcessItem[]) => {
											resolve(_process_items);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'item'
										),
									});
								}
							} else if (url.substring(0, 13) == '/specificRead') {
								const id_process_item: any = process_item.id_process_item;

								if (id_process_item >= 1) {
									/** set required attributes for action */
									_process_item.id_process_item = process_item.id_process_item;
									await _process_item
										.specificRead()
										.then((_processItem: ProcessItem) => {
											resolve(_processItem);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'process_item'
										),
									});
								}
							} else if (url == '/update') {
								/** set required attributes for action */
								_process_item.id_user_ = process_item.id_user_;
								_process_item.id_process_item = process_item.id_process_item;
								_process_item.official = process_item.official;
								_process_item.process = process_item.process;
								_process_item.task = process_item.task;
								_process_item.level = process_item.level;
								_process_item.item = process_item.item;
								_process_item.amount_process_item =
									process_item.amount_process_item;
								_process_item.features_process_item =
									process_item.features_process_item;
								_process_item.entry_date_process_item =
									process_item.entry_date_process_item;
								await _process_item
									.update()
									.then((_processItem: ProcessItem) => {
										resolve(_processItem);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 7) == '/delete') {
								/** set required attributes for action */
								_process_item.id_user_ = process_item.id_user_;
								_process_item.id_process_item = process_item.id_process_item;
								await _process_item
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
