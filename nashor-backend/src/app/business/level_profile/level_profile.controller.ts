import { verifyToken } from '../../../utils/jwt';
import { _messages } from '../../../utils/message/message';
import { LevelProfile } from './level_profile.class';

export const validation = (
	level_profile: LevelProfile,
	url: string,
	token: string
) => {
	return new Promise<LevelProfile | LevelProfile[] | boolean | any>(
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
								level_profile.id_user_,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'id_level_profile',
								level_profile.id_level_profile,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'name_level_profile',
								level_profile.name_level_profile,
								'string',
								100
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'description_level_profile',
								level_profile.description_level_profile,
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
								level_profile.company.id_company,
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
							const _level_profile = new LevelProfile();
							/**
							 * Execute the url depending on the path
							 */
							if (url == '/create') {
								/** set required attributes for action */
								_level_profile.id_user_ = level_profile.id_user_;
								_level_profile.company = level_profile.company;
								await _level_profile
									.create()
									.then((_levelProfile: LevelProfile) => {
										resolve(_levelProfile);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 10) == '/queryRead') {
								/** set required attributes for action */
								_level_profile.name_level_profile =
									level_profile.name_level_profile;
								await _level_profile
									.queryRead()
									.then((_levelProfiles: LevelProfile[]) => {
										resolve(_levelProfiles);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 19) == '/byCompanyQueryRead') {
								const id_company: any = level_profile.company;

								if (id_company >= 1) {
									/** set required attributes for action */
									_level_profile.company = level_profile.company;
									_level_profile.name_level_profile =
										level_profile.name_level_profile;
									await _level_profile
										.byCompanyQueryRead()
										.then((_level_profiles: LevelProfile[]) => {
											resolve(_level_profiles);
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
								const id_level_profile: any = level_profile.id_level_profile;

								if (id_level_profile >= 1) {
									/** set required attributes for action */
									_level_profile.id_level_profile =
										level_profile.id_level_profile;
									await _level_profile
										.specificRead()
										.then((_levelProfile: LevelProfile) => {
											resolve(_levelProfile);
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
							} else if (url == '/update') {
								/** set required attributes for action */
								_level_profile.id_user_ = level_profile.id_user_;
								_level_profile.id_level_profile =
									level_profile.id_level_profile;
								_level_profile.company = level_profile.company;
								_level_profile.name_level_profile =
									level_profile.name_level_profile;
								_level_profile.description_level_profile =
									level_profile.description_level_profile;
								await _level_profile
									.update()
									.then((_levelProfile: LevelProfile) => {
										resolve(_levelProfile);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 7) == '/delete') {
								/** set required attributes for action */
								_level_profile.id_user_ = level_profile.id_user_;
								_level_profile.id_level_profile =
									level_profile.id_level_profile;
								await _level_profile
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
