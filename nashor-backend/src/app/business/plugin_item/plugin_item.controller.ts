import { verifyToken } from '../../../utils/jwt';
import { _messages } from '../../../utils/message/message';
import { PluginItem } from './plugin_item.class';

export const validation = (
	plugin_item: PluginItem,
	url: string,
	token: string
) => {
	return new Promise<PluginItem | PluginItem[] | boolean | any>(
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
								plugin_item.id_user_,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'id_plugin_item',
								plugin_item.id_plugin_item,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'name_plugin_item',
								plugin_item.name_plugin_item,
								'string',
								100
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'description_plugin_item',
								plugin_item.description_plugin_item,
								'string',
								250
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation company
						 */

						if (url == '/update') {
							attributeValidate(
								'id_company',
								plugin_item.company.id_company,
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
							const _plugin_item = new PluginItem();
							/**
							 * Execute the url depending on the path
							 */
							if (url == '/create') {
								/** set required attributes for action */
								_plugin_item.id_user_ = plugin_item.id_user_;
								_plugin_item.company = plugin_item.company;
								await _plugin_item
									.create()
									.then((_pluginItem: PluginItem) => {
										resolve(_pluginItem);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 10) == '/queryRead') {
								/** set required attributes for action */
								_plugin_item.name_plugin_item = plugin_item.name_plugin_item;
								await _plugin_item
									.queryRead()
									.then((_pluginItems: PluginItem[]) => {
										resolve(_pluginItems);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 19) == '/byCompanyQueryRead') {
								const id_company: any = plugin_item.company;

								if (id_company >= 1) {
									/** set required attributes for action */
									_plugin_item.company = plugin_item.company;
									_plugin_item.name_plugin_item = plugin_item.name_plugin_item;
									await _plugin_item
										.byCompanyQueryRead()
										.then((_plugin_items: PluginItem[]) => {
											resolve(_plugin_items);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'company'
										),
									});
								}
							} else if (url.substring(0, 13) == '/specificRead') {
								const id_plugin_item: any = plugin_item.id_plugin_item;

								if (id_plugin_item >= 1) {
									/** set required attributes for action */
									_plugin_item.id_plugin_item = plugin_item.id_plugin_item;
									await _plugin_item
										.specificRead()
										.then((_pluginItem: PluginItem) => {
											resolve(_pluginItem);
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
							} else if (url == '/update') {
								/** set required attributes for action */
								_plugin_item.id_user_ = plugin_item.id_user_;
								_plugin_item.id_plugin_item = plugin_item.id_plugin_item;
								_plugin_item.company = plugin_item.company;
								_plugin_item.name_plugin_item = plugin_item.name_plugin_item;
								_plugin_item.description_plugin_item =
									plugin_item.description_plugin_item;
								await _plugin_item
									.update()
									.then((_pluginItem: PluginItem) => {
										resolve(_pluginItem);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 7) == '/delete') {
								/** set required attributes for action */
								_plugin_item.id_user_ = plugin_item.id_user_;
								_plugin_item.id_plugin_item = plugin_item.id_plugin_item;
								await _plugin_item
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
