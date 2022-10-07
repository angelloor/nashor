import { verifyToken } from '../../../utils/jwt';
import { _messages } from '../../../utils/message/message';
import { Control, validationTypeControl } from './control.class';

export const validation = (control: Control, url: string, token: string) => {
	return new Promise<Control | Control[] | boolean | any>(
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
								control.id_user_,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'id_control',
								control.id_control,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							validationTypeControl(
								'type_control',
								control.type_control!
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'title_control',
								control.title_control,
								'string',
								50
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'form_name_control',
								control.form_name_control,
								'string',
								50
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'initial_value_control',
								control.initial_value_control,
								'string',
								100
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'required_control',
								control.required_control,
								'boolean'
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'min_length_control',
								control.min_length_control,
								'number',
								3
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'max_length_control',
								control.max_length_control,
								'number',
								3
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'placeholder_control',
								control.placeholder_control,
								'string',
								100
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'spell_check_control',
								control.spell_check_control,
								'boolean'
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'options_control',
								control.options_control,
								'object'
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate('in_use', control.in_use, 'boolean').catch(
								(err) => {
									validationStatus = true;
									reject(err);
								}
							);
						}

						/**
						 * Validation company
						 */

						if (url == '/create' || url == '/update') {
							attributeValidate(
								'id_company',
								control.company.id_company,
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
							const _control = new Control();
							/**
							 * Execute the url depending on the path
							 */
							if (url.substring(0, 10) == '/queryRead') {
								/** set required attributes for action */
								_control.form_name_control = control.form_name_control;
								await _control
									.queryRead()
									.then((_controls: Control[]) => {
										resolve(_controls);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 19) == '/byCompanyQueryRead') {
								const id_company: any = control.company;

								if (id_company >= 1) {
									/** set required attributes for action */
									_control.company = control.company;
									_control.form_name_control = control.form_name_control;
									await _control
										.byCompanyQueryRead()
										.then((_controls: Control[]) => {
											resolve(_controls);
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
							} else if (url.substring(0, 16) == '/byPositionLevel') {
								const id_user_: any = control.id_user_;

								if (id_user_ >= 1) {
									/** set required attributes for action */
									_control.id_user_ = control.id_user_;
									_control.form_name_control = control.form_name_control;
									await _control
										.byPositionLevel()
										.then((_controls: Control[]) => {
											resolve(_controls);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'user'
										),
									});
								}
							} else if (url.substring(0, 13) == '/specificRead') {
								const id_control: any = control.id_control;

								if (id_control >= 1) {
									/** set required attributes for action */
									_control.id_control = control.id_control;
									await _control
										.specificRead()
										.then((_control: Control) => {
											resolve(_control);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'control'
										),
									});
								}
							} else if (url == '/update') {
								/** set required attributes for action */
								_control.id_user_ = control.id_user_;
								_control.id_control = control.id_control;
								_control.company = control.company;
								_control.type_control = control.type_control;
								_control.title_control = control.title_control;
								_control.form_name_control = control.form_name_control;
								_control.initial_value_control = control.initial_value_control;
								_control.required_control = control.required_control;
								_control.min_length_control = control.min_length_control;
								_control.max_length_control = control.max_length_control;
								_control.placeholder_control = control.placeholder_control;
								_control.spell_check_control = control.spell_check_control;
								_control.options_control = control.options_control;
								_control.in_use = control.in_use;
								await _control
									.update()
									.then((_control: Control) => {
										resolve(_control);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 7) == '/delete') {
								/** set required attributes for action */
								_control.id_user_ = control.id_user_;
								_control.id_control = control.id_control;
								await _control
									.delete()
									.then((response: boolean) => {
										resolve(response);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 14) == '/cascadeDelete') {
								/** set required attributes for action */
								_control.id_user_ = control.id_user_;
								_control.id_control = control.id_control;
								await _control
									.cascadeDelete()
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
