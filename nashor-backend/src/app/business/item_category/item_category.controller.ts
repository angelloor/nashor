import { verifyToken } from '../../../utils/jwt';
import { _messages } from '../../../utils/message/message';
import { ItemCategory } from './item_category.class';

export const validation = (
	item_category: ItemCategory,
	url: string,
	token: string
) => {
	return new Promise<ItemCategory | ItemCategory[] | boolean | any>(
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
								item_category.id_user_,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'id_item_category',
								item_category.id_item_category,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'name_item_category',
								item_category.name_item_category,
								'string',
								100
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'description_item_category',
								item_category.description_item_category,
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

						if (url == '/create' || url == '/update') {
							attributeValidate(
								'id_company',
								item_category.company.id_company,
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
							const _item_category = new ItemCategory();
							/**
							 * Execute the url depending on the path
							 */
							if (url == '/create') {
								/** set required attributes for action */
								_item_category.id_user_ = item_category.id_user_;
								_item_category.company = item_category.company;
								await _item_category
									.create()
									.then((_itemCategory: ItemCategory) => {
										resolve(_itemCategory);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 10) == '/queryRead') {
								/** set required attributes for action */
								_item_category.name_item_category =
									item_category.name_item_category;
								await _item_category
									.queryRead()
									.then((_itemCategorys: ItemCategory[]) => {
										resolve(_itemCategorys);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 19) == '/byCompanyQueryRead') {
								const id_company: any = item_category.company;

								if (id_company >= 1) {
									/** set required attributes for action */
									_item_category.company = item_category.company;
									_item_category.name_item_category =
										item_category.name_item_category;
									await _item_category
										.byCompanyQueryRead()
										.then((_item_categorys: ItemCategory[]) => {
											resolve(_item_categorys);
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
								const id_item_category: any = item_category.id_item_category;

								if (id_item_category >= 1) {
									/** set required attributes for action */
									_item_category.id_item_category =
										item_category.id_item_category;
									await _item_category
										.specificRead()
										.then((_itemCategory: ItemCategory) => {
											resolve(_itemCategory);
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
							} else if (url == '/update') {
								/** set required attributes for action */
								_item_category.id_user_ = item_category.id_user_;
								_item_category.id_item_category =
									item_category.id_item_category;
								_item_category.company = item_category.company;
								_item_category.name_item_category =
									item_category.name_item_category;
								_item_category.description_item_category =
									item_category.description_item_category;
								await _item_category
									.update()
									.then((_itemCategory: ItemCategory) => {
										resolve(_itemCategory);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 7) == '/delete') {
								/** set required attributes for action */
								_item_category.id_user_ = item_category.id_user_;
								_item_category.id_item_category =
									item_category.id_item_category;
								await _item_category
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
