import { verifyToken } from '../../../utils/jwt';
import { _messages } from '../../../utils/message/message';
import { PluginItemColumn } from './plugin_item_column.class';

export const validation = (
	plugin_item_column: PluginItemColumn,
	url: string,
	token: string
) => {
	return new Promise<PluginItemColumn | PluginItemColumn[] | boolean | any>(
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
								plugin_item_column.id_user_,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'id_plugin_item_column',
								plugin_item_column.id_plugin_item_column,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'name_plugin_item_column',
								plugin_item_column.name_plugin_item_column,
								'string',
								100
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'lenght_plugin_item_column',
								plugin_item_column.lenght_plugin_item_column,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation pluginItem
						 */

						if (url == '/update') {
							attributeValidate(
								'id_plugin_item',
								plugin_item_column.plugin_item.id_plugin_item,
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
							const _plugin_item_column = new PluginItemColumn();
							/**
							 * Execute the url depending on the path
							 */
							if (url == '/create') {
								/** set required attributes for action */
								_plugin_item_column.plugin_item =
									plugin_item_column.plugin_item;
								await _plugin_item_column
									.create()
									.then((_pluginItemColumn: PluginItemColumn) => {
										resolve(_pluginItemColumn);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 10) == '/queryRead') {
								/** set required attributes for action */
								_plugin_item_column.name_plugin_item_column =
									plugin_item_column.name_plugin_item_column;
								await _plugin_item_column
									.queryRead()
									.then((_pluginItemColumns: PluginItemColumn[]) => {
										resolve(_pluginItemColumns);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 22) == '/byPluginItemQueryRead') {
								const id_plugin_item: any = plugin_item_column.plugin_item;

								if (id_plugin_item >= 1) {
									/** set required attributes for action */
									_plugin_item_column.plugin_item =
										plugin_item_column.plugin_item;
									_plugin_item_column.name_plugin_item_column =
										plugin_item_column.name_plugin_item_column;
									await _plugin_item_column
										.byPluginItemQueryRead()
										.then((_plugin_item_columns: PluginItemColumn[]) => {
											resolve(_plugin_item_columns);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'plugin_item'
										),
									});
								}
							} else if (url.substring(0, 13) == '/specificRead') {
								const id_plugin_item_column: any =
									plugin_item_column.id_plugin_item_column;

								if (id_plugin_item_column >= 1) {
									/** set required attributes for action */
									_plugin_item_column.id_plugin_item_column =
										plugin_item_column.id_plugin_item_column;
									await _plugin_item_column
										.specificRead()
										.then((_pluginItemColumn: PluginItemColumn) => {
											resolve(_pluginItemColumn);
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
							} else if (url == '/update') {
								/** set required attributes for action */
								_plugin_item_column.id_user_ = plugin_item_column.id_user_;
								_plugin_item_column.id_plugin_item_column =
									plugin_item_column.id_plugin_item_column;
								_plugin_item_column.plugin_item =
									plugin_item_column.plugin_item;
								_plugin_item_column.name_plugin_item_column =
									plugin_item_column.name_plugin_item_column;
								_plugin_item_column.lenght_plugin_item_column =
									plugin_item_column.lenght_plugin_item_column;
								await _plugin_item_column
									.update()
									.then((_pluginItemColumn: PluginItemColumn) => {
										resolve(_pluginItemColumn);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 7) == '/delete') {
								/** set required attributes for action */
								_plugin_item_column.id_user_ = plugin_item_column.id_user_;
								_plugin_item_column.id_plugin_item_column =
									plugin_item_column.id_plugin_item_column;
								await _plugin_item_column
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
