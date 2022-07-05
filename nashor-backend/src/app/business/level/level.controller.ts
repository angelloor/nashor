import { verifyToken } from '../../../utils/jwt';
import { _messages } from '../../../utils/message/message';
import { Level } from './level.class';

export const validation = (level: Level, url: string, token: string) => {
	return new Promise<Level | Level[] | boolean | any>(
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
							attributeValidate('id_user_', level.id_user_, 'number', 10).catch(
								(err) => {
									validationStatus = true;
									reject(err);
								}
							);
						}

						if (url == '/update') {
							attributeValidate('id_level', level.id_level, 'number', 5).catch(
								(err) => {
									validationStatus = true;
									reject(err);
								}
							);
						}

						if (url == '/update') {
							attributeValidate(
								'name_level',
								level.name_level,
								'string',
								100
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'description_level',
								level.description_level,
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
								level.company.id_company,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation template
						 */

						if (url == '/update') {
							attributeValidate(
								'id_template',
								level.template.id_template,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation levelProfile
						 */

						if (url == '/update') {
							attributeValidate(
								'id_level_profile',
								level.level_profile.id_level_profile,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation levelStatus
						 */

						if (url == '/update') {
							attributeValidate(
								'id_level_status',
								level.level_status.id_level_status,
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
							const _level = new Level();
							/**
							 * Execute the url depending on the path
							 */
							if (url == '/create') {
								/** set required attributes for action */
								_level.id_user_ = level.id_user_;
								_level.template = level.template;
								_level.company = level.company;
								await _level
									.create()
									.then((_level: Level) => {
										resolve(_level);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 10) == '/queryRead') {
								/** set required attributes for action */
								_level.name_level = level.name_level;
								await _level
									.queryRead()
									.then((_levels: Level[]) => {
										resolve(_levels);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 19) == '/byCompanyQueryRead') {
								const id_company: any = level.company;

								if (id_company >= 1) {
									/** set required attributes for action */
									_level.company = level.company;
									_level.name_level = level.name_level;
									await _level
										.byCompanyQueryRead()
										.then((_levels: Level[]) => {
											resolve(_levels);
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
							} else if (url.substring(0, 20) == '/byTemplateQueryRead') {
								const id_template: any = level.template;

								if (id_template >= 1) {
									/** set required attributes for action */
									_level.template = level.template;
									_level.name_level = level.name_level;
									await _level
										.byTemplateQueryRead()
										.then((_levels: Level[]) => {
											resolve(_levels);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'template'
										),
									});
								}
							} else if (url.substring(0, 24) == '/byLevelProfileQueryRead') {
								const id_level_profile: any = level.level_profile;

								if (id_level_profile >= 1) {
									/** set required attributes for action */
									_level.level_profile = level.level_profile;
									_level.name_level = level.name_level;
									await _level
										.byLevelProfileQueryRead()
										.then((_levels: Level[]) => {
											resolve(_levels);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'level_profile'
										),
									});
								}
							} else if (url.substring(0, 23) == '/byLevelStatusQueryRead') {
								const id_level_status: any = level.level_status;

								if (id_level_status >= 1) {
									/** set required attributes for action */
									_level.level_status = level.level_status;
									_level.name_level = level.name_level;
									await _level
										.byLevelStatusQueryRead()
										.then((_levels: Level[]) => {
											resolve(_levels);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'level_status'
										),
									});
								}
							} else if (url.substring(0, 13) == '/specificRead') {
								const id_level: any = level.id_level;

								if (id_level >= 1) {
									/** set required attributes for action */
									_level.id_level = level.id_level;
									await _level
										.specificRead()
										.then((_level: Level) => {
											resolve(_level);
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
							} else if (url == '/update') {
								/** set required attributes for action */
								_level.id_user_ = level.id_user_;
								_level.id_level = level.id_level;
								_level.company = level.company;
								_level.template = level.template;
								_level.level_profile = level.level_profile;
								_level.level_status = level.level_status;
								_level.name_level = level.name_level;
								_level.description_level = level.description_level;
								await _level
									.update()
									.then((_level: Level) => {
										resolve(_level);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 7) == '/delete') {
								/** set required attributes for action */
								_level.id_user_ = level.id_user_;
								_level.id_level = level.id_level;
								await _level
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
