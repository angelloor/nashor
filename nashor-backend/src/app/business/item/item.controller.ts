import { verifyToken } from '../../../utils/jwt';
import { _messages } from '../../../utils/message/message';
import { Item } from './item.class';

export const validation = (item: Item, url: string, token: string) => {
	return new Promise<Item | Item[] | boolean | any>(async (resolve, reject) => {
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
						attributeValidate('id_user_', item.id_user_, 'number', 10).catch(
							(err) => {
								validationStatus = true;
								reject(err);
							}
						);
					}

					if (url == '/update') {
						attributeValidate('id_item', item.id_item, 'number', 5).catch(
							(err) => {
								validationStatus = true;
								reject(err);
							}
						);
					}

					if (url == '/update') {
						attributeValidate('name_item', item.name_item, 'string', 100).catch(
							(err) => {
								validationStatus = true;
								reject(err);
							}
						);
					}

					if (url == '/update') {
						attributeValidate(
							'description_item',
							item.description_item,
							'string',
							250
						).catch((err) => {
							validationStatus = true;
							reject(err);
						});
					}

					if (url == '/update') {
						attributeValidate('cpc_item', item.cpc_item, 'string', 100).catch(
							(err) => {
								validationStatus = true;
								reject(err);
							}
						);
					}

					/**
					 * Validation company
					 */

					if (url == '/update') {
						attributeValidate(
							'id_company',
							item.company.id_company,
							'number',
							5
						).catch((err) => {
							validationStatus = true;
							reject(err);
						});
					}

					/**
					 * Validation itemCategory
					 */

					if (url == '/update') {
						attributeValidate(
							'id_item_category',
							item.item_category.id_item_category,
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
						const _item = new Item();
						/**
						 * Execute the url depending on the path
						 */
						if (url == '/create') {
							/** set required attributes for action */
							_item.id_user_ = item.id_user_;
							_item.company = item.company;
							await _item
								.create()
								.then((_item: Item) => {
									resolve(_item);
								})
								.catch((error: any) => {
									reject(error);
								});
						} else if (url.substring(0, 10) == '/queryRead') {
							/** set required attributes for action */
							_item.name_item = item.name_item;
							await _item
								.queryRead()
								.then((_items: Item[]) => {
									resolve(_items);
								})
								.catch((error: any) => {
									reject(error);
								});
						} else if (url.substring(0, 19) == '/byCompanyQueryRead') {
							const id_company: any = item.company;

							if (id_company >= 1) {
								/** set required attributes for action */
								_item.company = item.company;
								_item.name_item = item.name_item;
								await _item
									.byCompanyQueryRead()
									.then((_items: Item[]) => {
										resolve(_items);
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
						} else if (url.substring(0, 24) == '/byItemCategoryQueryRead') {
							const id_item_category: any = item.item_category;

							if (id_item_category >= 1) {
								/** set required attributes for action */
								_item.item_category = item.item_category;
								_item.name_item = item.name_item;
								await _item
									.byItemCategoryQueryRead()
									.then((_items: Item[]) => {
										resolve(_items);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else {
								reject({
									..._messages[11],
									description: _messages[11].description.replace(
										'name_entity',
										'item_category'
									),
								});
							}
						} else if (url.substring(0, 13) == '/specificRead') {
							const id_item: any = item.id_item;

							if (id_item >= 1) {
								/** set required attributes for action */
								_item.id_item = item.id_item;
								await _item
									.specificRead()
									.then((_item: Item) => {
										resolve(_item);
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
						} else if (url == '/update') {
							/** set required attributes for action */
							_item.id_user_ = item.id_user_;
							_item.id_item = item.id_item;
							_item.company = item.company;
							_item.item_category = item.item_category;
							_item.name_item = item.name_item;
							_item.description_item = item.description_item;
							_item.cpc_item = item.cpc_item;
							await _item
								.update()
								.then((_item: Item) => {
									resolve(_item);
								})
								.catch((error: any) => {
									reject(error);
								});
						} else if (url.substring(0, 7) == '/delete') {
							/** set required attributes for action */
							_item.id_user_ = item.id_user_;
							_item.id_item = item.id_item;
							await _item
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
