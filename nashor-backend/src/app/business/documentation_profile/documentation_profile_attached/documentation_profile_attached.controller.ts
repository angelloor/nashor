import { verifyToken } from '../../../../utils/jwt';
import { _messages } from '../../../../utils/message/message';
import { DocumentationProfileAttached } from './documentation_profile_attached.class';

export const validation = (
	documentation_profile_attached: DocumentationProfileAttached,
	url: string,
	token: string
) => {
	return new Promise<
		| DocumentationProfileAttached
		| DocumentationProfileAttached[]
		| boolean
		| any
	>(async (resolve, reject) => {
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
							documentation_profile_attached.id_user_,
							'number',
							10
						).catch((err) => {
							validationStatus = true;
							reject(err);
						});
					}

					if (url == '/update') {
						attributeValidate(
							'id_documentation_profile_attached',
							documentation_profile_attached.id_documentation_profile_attached,
							'number',
							10
						).catch((err) => {
							validationStatus = true;
							reject(err);
						});
					}

					/**
					 * Validation documentationProfile
					 */

					if (url == '/create' || url == '/update') {
						attributeValidate(
							'id_documentation_profile',
							documentation_profile_attached.documentation_profile
								.id_documentation_profile,
							'number',
							5
						).catch((err) => {
							validationStatus = true;
							reject(err);
						});
					}

					/**
					 * Validation attached
					 */

					if (url == '/update') {
						attributeValidate(
							'id_attached',
							documentation_profile_attached.attached.id_attached,
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
						const _documentation_profile_attached =
							new DocumentationProfileAttached();
						/**
						 * Execute the url depending on the path
						 */
						if (url == '/create') {
							/** set required attributes for action */
							_documentation_profile_attached.id_user_ =
								documentation_profile_attached.id_user_;
							_documentation_profile_attached.documentation_profile =
								documentation_profile_attached.documentation_profile;
							await _documentation_profile_attached
								.create()
								.then(
									(
										_documentationProfileAttached: DocumentationProfileAttached
									) => {
										resolve(_documentationProfileAttached);
									}
								)
								.catch((error: any) => {
									reject(error);
								});
						} else if (url.substring(0, 27) == '/byDocumentationProfileRead') {
							const id_documentation_profile: any =
								documentation_profile_attached.documentation_profile;

							if (id_documentation_profile >= 1) {
								/** set required attributes for action */
								_documentation_profile_attached.documentation_profile =
									documentation_profile_attached.documentation_profile;
								await _documentation_profile_attached
									.byDocumentationProfileRead()
									.then(
										(
											_documentation_profile_attacheds: DocumentationProfileAttached[]
										) => {
											resolve(_documentation_profile_attacheds);
										}
									)
									.catch((error: any) => {
										reject(error);
									});
							} else {
								reject({
									..._messages[11],
									description: _messages[11].description.replace(
										'name_entity',
										'documentation_profile'
									),
								});
							}
						} else if (url.substring(0, 15) == '/byAttachedRead') {
							const id_attached: any = documentation_profile_attached.attached;

							if (id_attached >= 1) {
								/** set required attributes for action */
								_documentation_profile_attached.attached =
									documentation_profile_attached.attached;
								await _documentation_profile_attached
									.byAttachedRead()
									.then(
										(
											_documentation_profile_attacheds: DocumentationProfileAttached[]
										) => {
											resolve(_documentation_profile_attacheds);
										}
									)
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
						} else if (url.substring(0, 13) == '/specificRead') {
							const id_documentation_profile_attached: any =
								documentation_profile_attached.id_documentation_profile_attached;

							if (id_documentation_profile_attached >= 1) {
								/** set required attributes for action */
								_documentation_profile_attached.id_documentation_profile_attached =
									documentation_profile_attached.id_documentation_profile_attached;
								await _documentation_profile_attached
									.specificRead()
									.then(
										(
											_documentationProfileAttached: DocumentationProfileAttached
										) => {
											resolve(_documentationProfileAttached);
										}
									)
									.catch((error: any) => {
										reject(error);
									});
							} else {
								reject({
									..._messages[11],
									description: _messages[11].description.replace(
										'name_entity',
										'documentation_profile_attached'
									),
								});
							}
						} else if (url == '/update') {
							/** set required attributes for action */
							_documentation_profile_attached.id_user_ =
								documentation_profile_attached.id_user_;
							_documentation_profile_attached.id_documentation_profile_attached =
								documentation_profile_attached.id_documentation_profile_attached;
							_documentation_profile_attached.documentation_profile =
								documentation_profile_attached.documentation_profile;
							_documentation_profile_attached.attached =
								documentation_profile_attached.attached;
							await _documentation_profile_attached
								.update()
								.then(
									(
										_documentationProfileAttached: DocumentationProfileAttached
									) => {
										resolve(_documentationProfileAttached);
									}
								)
								.catch((error: any) => {
									reject(error);
								});
						} else if (url.substring(0, 7) == '/delete') {
							/** set required attributes for action */
							_documentation_profile_attached.id_user_ =
								documentation_profile_attached.id_user_;
							_documentation_profile_attached.id_documentation_profile_attached =
								documentation_profile_attached.id_documentation_profile_attached;
							await _documentation_profile_attached
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
