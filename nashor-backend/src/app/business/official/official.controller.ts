import { verifyToken } from '../../../utils/jwt';
import { _messages } from '../../../utils/message/message';
import { Official } from './official.class';

export const validation = (official: Official, url: string, token: string) => {
	return new Promise<Official | Official[] | boolean | any>(
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
								official.id_user_,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'id_official',
								official.id_official,
								'number',
								10
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
								official.company.id_company,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation user
						 */

						if (url == '/update') {
							attributeValidate(
								'id_user',
								official.user.id_user,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'id_company',
								official.user.company.id_company,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'id_person',
								official.user.person.id_person,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'id_type_user',
								official.user.type_user.id_type_user,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'name_user',
								official.user.name_user,
								'string',
								320
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'password_user',
								official.user.password_user,
								'string',
								250
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'avatar_user',
								official.user.avatar_user,
								'string',
								50
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'status_user',
								official.user.status_user,
								'boolean'
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation person
						 */
						if (url == '/update') {
							attributeValidate(
								'id_academic',
								official.user.person.academic.id_academic,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'title_academic',
								official.user.person.academic.title_academic,
								'string',
								250
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'abbreviation_academic',
								official.user.person.academic.abbreviation_academic,
								'string',
								50
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'nivel_academic',
								official.user.person.academic.nivel_academic,
								'string',
								100
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'id_job',
								official.user.person.job.id_job,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'name_job',
								official.user.person.job.name_job,
								'string',
								200
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'address_job',
								official.user.person.job.address_job,
								'string',
								200
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'phone_job',
								official.user.person.job.phone_job,
								'string',
								13
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'position_job',
								official.user.person.job.position_job,
								'string',
								150
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'dni_person',
								official.user.person.dni_person,
								'string',
								20
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'name_person',
								official.user.person.name_person,
								'string',
								150
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'last_name_person',
								official.user.person.last_name_person,
								'string',
								150
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'address_person',
								official.user.person.address_person,
								'string',
								150
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'phone_person',
								official.user.person.phone_person,
								'string',
								13
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation area
						 */

						if (url == '/update') {
							attributeValidate(
								'id_area',
								official.area.id_area,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation position
						 */

						if (url == '/update') {
							attributeValidate(
								'id_position',
								official.position.id_position,
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
							const _official = new Official();
							/**
							 * Execute the url depending on the path
							 */
							if (url == '/create') {
								/** set required attributes for action */
								_official.id_user_ = official.id_user_;
								_official.company = official.company;
								await _official
									.create()
									.then((_official: Official) => {
										resolve(_official);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 10) == '/queryRead') {
								/** set required attributes for action */
								_official.user = official.user;
								await _official
									.queryRead()
									.then((_officials: Official[]) => {
										resolve(_officials);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 19) == '/byCompanyQueryRead') {
								const id_company: any = official.company;

								if (id_company >= 1) {
									/** set required attributes for action */
									_official.company = official.company;
									_official.user = official.user;
									await _official
										.byCompanyQueryRead()
										.then((_officials: Official[]) => {
											resolve(_officials);
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
							} else if (url.substring(0, 16) == '/byAreaQueryRead') {
								const id_area: any = official.area;

								if (id_area >= 1) {
									/** set required attributes for action */
									_official.area = official.area;
									_official.user = official.user;
									await _official
										.byAreaQueryRead()
										.then((_officials: Official[]) => {
											resolve(_officials);
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
							} else if (url.substring(0, 20) == '/byPositionQueryRead') {
								const id_position: any = official.position;

								if (id_position >= 1) {
									/** set required attributes for action */
									_official.position = official.position;
									_official.user = official.user;
									await _official
										.byPositionQueryRead()
										.then((_officials: Official[]) => {
											resolve(_officials);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'position'
										),
									});
								}
							} else if (url.substring(0, 13) == '/specificRead') {
								const id_official: any = official.id_official;

								if (id_official >= 1) {
									/** set required attributes for action */
									_official.id_official = official.id_official;
									await _official
										.specificRead()
										.then((_official: Official) => {
											resolve(_official);
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
							} else if (url == '/update') {
								/** set required attributes for action */
								_official.id_user_ = official.id_user_;
								_official.id_official = official.id_official;
								_official.company = official.company;
								_official.user = official.user;
								_official.area = official.area;
								_official.position = official.position;
								await _official
									.update()
									.then((_official: Official) => {
										resolve(_official);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 7) == '/delete') {
								/** set required attributes for action */
								_official.id_user_ = official.id_user_;
								_official.id_official = official.id_official;
								await _official
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
