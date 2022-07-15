import { verifyToken } from '../../../utils/jwt';
import { _messages } from '../../../utils/message/message';
import { LevelProfileOfficial } from './level_profile_official.class';

export const validation = (
	level_profile_official: LevelProfileOfficial,
	url: string,
	token: string
) => {
	return new Promise<
		LevelProfileOfficial | LevelProfileOfficial[] | boolean | any
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
							level_profile_official.id_user_,
							'number',
							10
						).catch((err) => {
							validationStatus = true;
							reject(err);
						});
					}

					if (url == '/update') {
						attributeValidate(
							'id_level_profile_official',
							level_profile_official.id_level_profile_official,
							'number',
							10
						).catch((err) => {
							validationStatus = true;
							reject(err);
						});
					}

					if (url == '/update') {
						attributeValidate(
							'official_modifier',
							level_profile_official.official_modifier,
							'boolean'
						).catch((err) => {
							validationStatus = true;
							reject(err);
						});
					}

					/**
					 * Validation levelProfile
					 */

					if (url == '/create' || url == '/update') {
						attributeValidate(
							'id_level_profile',
							level_profile_official.level_profile.id_level_profile,
							'number',
							5
						).catch((err) => {
							validationStatus = true;
							reject(err);
						});
					}

					/**
					 * Validation official
					 */

					if (url == '/update') {
						attributeValidate(
							'id_official',
							level_profile_official.official.id_official,
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
						const _level_profile_official = new LevelProfileOfficial();
						/**
						 * Execute the url depending on the path
						 */
						if (url == '/create') {
							/** set required attributes for action */
							_level_profile_official.id_user_ =
								level_profile_official.id_user_;
							_level_profile_official.level_profile =
								level_profile_official.level_profile;
							await _level_profile_official
								.create()
								.then((_levelProfileOfficial: LevelProfileOfficial) => {
									resolve(_levelProfileOfficial);
								})
								.catch((error: any) => {
									reject(error);
								});
						} else if (url.substring(0, 19) == '/byLevelProfileRead') {
							const id_level_profile: any =
								level_profile_official.level_profile;

							if (id_level_profile >= 1) {
								/** set required attributes for action */
								_level_profile_official.level_profile =
									level_profile_official.level_profile;
								_level_profile_official.level_profile =
									level_profile_official.level_profile;
								await _level_profile_official
									.byLevelProfileRead()
									.then((_level_profile_officials: LevelProfileOfficial[]) => {
										resolve(_level_profile_officials);
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
						} else if (url.substring(0, 13) == '/specificRead') {
							const id_level_profile_official: any =
								level_profile_official.id_level_profile_official;

							if (id_level_profile_official >= 1) {
								/** set required attributes for action */
								_level_profile_official.id_level_profile_official =
									level_profile_official.id_level_profile_official;
								await _level_profile_official
									.specificRead()
									.then((_levelProfileOfficial: LevelProfileOfficial) => {
										resolve(_levelProfileOfficial);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else {
								reject({
									..._messages[11],
									description: _messages[11].description.replace(
										'name_entity',
										'level_profile_official'
									),
								});
							}
						} else if (url == '/update') {
							/** set required attributes for action */
							_level_profile_official.id_user_ =
								level_profile_official.id_user_;
							_level_profile_official.id_level_profile_official =
								level_profile_official.id_level_profile_official;
							_level_profile_official.level_profile =
								level_profile_official.level_profile;
							_level_profile_official.official =
								level_profile_official.official;
							_level_profile_official.official_modifier =
								level_profile_official.official_modifier;
							await _level_profile_official
								.update()
								.then((_levelProfileOfficial: LevelProfileOfficial) => {
									resolve(_levelProfileOfficial);
								})
								.catch((error: any) => {
									reject(error);
								});
						} else if (url.substring(0, 7) == '/delete') {
							/** set required attributes for action */
							_level_profile_official.id_user_ =
								level_profile_official.id_user_;
							_level_profile_official.id_level_profile_official =
								level_profile_official.id_level_profile_official;
							await _level_profile_official
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
