import { verifyToken } from '../../../utils/jwt';
import { _messages } from '../../../utils/message/message';
import { Area } from './area.class';

export const validation = (area: Area, url: string, token: string) => {
	return new Promise<Area | Area[] | boolean | any>(async (resolve, reject) => {
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
						attributeValidate('id_user_', area.id_user_, 'number', 10).catch(
							(err) => {
								validationStatus = true;
								reject(err);
							}
						);
					}

					if (url == '/update') {
						attributeValidate('id_area', area.id_area, 'number', 5).catch(
							(err) => {
								validationStatus = true;
								reject(err);
							}
						);
					}

					if (url == '/update') {
						attributeValidate('name_area', area.name_area, 'string', 100).catch(
							(err) => {
								validationStatus = true;
								reject(err);
							}
						);
					}

					if (url == '/update') {
						attributeValidate(
							'description_area',
							area.description_area,
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
							area.company.id_company,
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
						const _area = new Area();
						/**
						 * Execute the url depending on the path
						 */
						if (url == '/create') {
							/** set required attributes for action */
							_area.id_user_ = area.id_user_;
							_area.company = area.company;
							await _area
								.create()
								.then((_area: Area) => {
									resolve(_area);
								})
								.catch((error: any) => {
									reject(error);
								});
						} else if (url.substring(0, 10) == '/queryRead') {
							/** set required attributes for action */
							_area.name_area = area.name_area;
							await _area
								.queryRead()
								.then((_areas: Area[]) => {
									resolve(_areas);
								})
								.catch((error: any) => {
									reject(error);
								});
						} else if (url.substring(0, 19) == '/byCompanyQueryRead') {
							const id_company: any = area.company;

							if (id_company >= 1) {
								/** set required attributes for action */
								_area.company = area.company;
								_area.name_area = area.name_area;
								await _area
									.byCompanyQueryRead()
									.then((_areas: Area[]) => {
										resolve(_areas);
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
							const id_area: any = area.id_area;

							if (id_area >= 1) {
								/** set required attributes for action */
								_area.id_area = area.id_area;
								await _area
									.specificRead()
									.then((_area: Area) => {
										resolve(_area);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else {
								reject({
									..._messages[11],
									description: _messages[11].description.replace(
										'name_entity',
										'area'
									),
								});
							}
						} else if (url == '/update') {
							/** set required attributes for action */
							_area.id_user_ = area.id_user_;
							_area.id_area = area.id_area;
							_area.company = area.company;
							_area.name_area = area.name_area;
							_area.description_area = area.description_area;
							await _area
								.update()
								.then((_area: Area) => {
									resolve(_area);
								})
								.catch((error: any) => {
									reject(error);
								});
						} else if (url.substring(0, 7) == '/delete') {
							/** set required attributes for action */
							_area.id_user_ = area.id_user_;
							_area.id_area = area.id_area;
							await _area
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
