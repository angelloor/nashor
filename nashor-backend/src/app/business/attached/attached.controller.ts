import { verifyToken } from '../../../utils/jwt';
import { _messages } from '../../../utils/message/message';
import { Attached } from './attached.class';

export const validation = (attached: Attached, url: string, token: string) => {
	return new Promise<Attached | Attached[] | boolean | any>(
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
								attached.id_user_,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'id_attached',
								attached.id_attached,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'name_attached',
								attached.name_attached,
								'string',
								100
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'description_attached',
								attached.description_attached,
								'string',
								250
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'length_mb_attached',
								attached.length_mb_attached,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'required_attached',
								attached.required_attached,
								'boolean'
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
								attached.company.id_company,
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
							const _attached = new Attached();
							/**
							 * Execute the url depending on the path
							 */
							if (url == '/create') {
								/** set required attributes for action */
								_attached.id_user_ = attached.id_user_;
								_attached.company = attached.company;
								await _attached
									.create()
									.then((_attached: Attached) => {
										resolve(_attached);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 10) == '/queryRead') {
								/** set required attributes for action */
								_attached.name_attached = attached.name_attached;
								await _attached
									.queryRead()
									.then((_attacheds: Attached[]) => {
										resolve(_attacheds);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 19) == '/byCompanyQueryRead') {
								const id_company: any = attached.company;

								if (id_company >= 1) {
									/** set required attributes for action */
									_attached.company = attached.company;
									_attached.name_attached = attached.name_attached;
									await _attached
										.byCompanyQueryRead()
										.then((_attacheds: Attached[]) => {
											resolve(_attacheds);
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
								const id_attached: any = attached.id_attached;

								if (id_attached >= 1) {
									/** set required attributes for action */
									_attached.id_attached = attached.id_attached;
									await _attached
										.specificRead()
										.then((_attached: Attached) => {
											resolve(_attached);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'attached'
										),
									});
								}
							} else if (url == '/update') {
								/** set required attributes for action */
								_attached.id_user_ = attached.id_user_;
								_attached.id_attached = attached.id_attached;
								_attached.company = attached.company;
								_attached.name_attached = attached.name_attached;
								_attached.description_attached = attached.description_attached;
								_attached.length_mb_attached = attached.length_mb_attached;
								_attached.required_attached = attached.required_attached;
								await _attached
									.update()
									.then((_attached: Attached) => {
										resolve(_attached);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 7) == '/delete') {
								/** set required attributes for action */
								_attached.id_user_ = attached.id_user_;
								_attached.id_attached = attached.id_attached;
								await _attached
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
