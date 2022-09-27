import { verifyToken } from '../../../utils/jwt';
import { _messages } from '../../../utils/message/message';
import { ColumnProcessItem } from './column_process_item.class';

export const validation = (
	column_process_item: ColumnProcessItem,
	url: string,
	token: string
) => {
	return new Promise<ColumnProcessItem | ColumnProcessItem[] | boolean | any>(
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
								column_process_item.id_user_,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'id_column_process_item',
								column_process_item.id_column_process_item,
								'number',
								15
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'value_column_process_item',
								column_process_item.value_column_process_item,
								'string',
								9999999999
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'entry_date_column_process_item',
								column_process_item.entry_date_column_process_item,
								'string',
								30
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation pluginItemColumn
						 */

						if (url == '/update') {
							attributeValidate(
								'id_plugin_item_column',
								column_process_item.plugin_item_column.id_plugin_item_column,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation processItem
						 */

						if (url == '/update') {
							attributeValidate(
								'id_process_item',
								column_process_item.process_item.id_process_item,
								'number',
								10
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
							const _column_process_item = new ColumnProcessItem();
							/**
							 * Execute the url depending on the path
							 */
							if (url == '/create') {
								/** set required attributes for action */
								_column_process_item.id_user_ = column_process_item.id_user_;
								_column_process_item.plugin_item_column =
									column_process_item.plugin_item_column;
								_column_process_item.process_item =
									column_process_item.process_item;
								_column_process_item.value_column_process_item =
									column_process_item.value_column_process_item;
								await _column_process_item
									.create()
									.then((_columnProcessItem: ColumnProcessItem) => {
										resolve(_columnProcessItem);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 10) == '/queryRead') {
								/** set required attributes for action */
								_column_process_item.value_column_process_item =
									column_process_item.value_column_process_item;
								await _column_process_item
									.queryRead()
									.then((_columnProcessItems: ColumnProcessItem[]) => {
										resolve(_columnProcessItems);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (
								url.substring(0, 28) == '/byPluginItemColumnQueryRead'
							) {
								const id_plugin_item_column: any =
									column_process_item.plugin_item_column;

								if (id_plugin_item_column >= 1) {
									/** set required attributes for action */
									_column_process_item.plugin_item_column =
										column_process_item.plugin_item_column;
									_column_process_item.value_column_process_item =
										column_process_item.value_column_process_item;
									await _column_process_item
										.byPluginItemColumnQueryRead()
										.then((_column_process_items: ColumnProcessItem[]) => {
											resolve(_column_process_items);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'plugin_item_column'
										),
									});
								}
							} else if (url.substring(0, 23) == '/byProcessItemQueryRead') {
								const id_process_item: any = column_process_item.process_item;

								if (id_process_item >= 1) {
									/** set required attributes for action */
									_column_process_item.process_item =
										column_process_item.process_item;
									_column_process_item.value_column_process_item =
										column_process_item.value_column_process_item;
									await _column_process_item
										.byProcessItemQueryRead()
										.then((_column_process_items: ColumnProcessItem[]) => {
											resolve(_column_process_items);
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
							} else if (
								url.substring(0, 37) == '/byPluginItemColumnAndProcessItemRead'
							) {
								const id_plugin_item_column: any =
									column_process_item.plugin_item_column;
								const id_process_item: any = column_process_item.process_item;

								if (id_plugin_item_column >= 1 && id_process_item >= 1) {
									/** set required attributes for action */
									_column_process_item.plugin_item_column =
										column_process_item.plugin_item_column;
									_column_process_item.process_item =
										column_process_item.process_item;
									await _column_process_item
										.byPluginItemColumnAndProcessItemRead()
										.then((_column_process_item: ColumnProcessItem) => {
											resolve(_column_process_item);
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
							} else if (url.substring(0, 13) == '/specificRead') {
								const id_column_process_item: any =
									column_process_item.id_column_process_item;

								if (id_column_process_item >= 1) {
									/** set required attributes for action */
									_column_process_item.id_column_process_item =
										column_process_item.id_column_process_item;
									await _column_process_item
										.specificRead()
										.then((_columnProcessItem: ColumnProcessItem) => {
											resolve(_columnProcessItem);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'column_process_item'
										),
									});
								}
							} else if (url == '/update') {
								/** set required attributes for action */
								_column_process_item.id_user_ = column_process_item.id_user_;
								_column_process_item.id_column_process_item =
									column_process_item.id_column_process_item;
								_column_process_item.plugin_item_column =
									column_process_item.plugin_item_column;
								_column_process_item.process_item =
									column_process_item.process_item;
								_column_process_item.value_column_process_item =
									column_process_item.value_column_process_item;
								_column_process_item.entry_date_column_process_item =
									column_process_item.entry_date_column_process_item;
								await _column_process_item
									.update()
									.then((_columnProcessItem: ColumnProcessItem) => {
										resolve(_columnProcessItem);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 7) == '/delete') {
								/** set required attributes for action */
								_column_process_item.id_user_ = column_process_item.id_user_;
								_column_process_item.id_column_process_item =
									column_process_item.id_column_process_item;
								await _column_process_item
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
