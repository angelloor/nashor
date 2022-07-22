import { verifyToken } from '../../../utils/jwt';
import { _messages } from '../../../utils/message/message';
import { TemplateControl } from './template_control.class';

export const validation = (
	template_control: TemplateControl,
	url: string,
	token: string
) => {
	return new Promise<TemplateControl | TemplateControl[] | boolean | any>(
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
						if (
							url == '/create' ||
							url == '/createWithNewControl' ||
							url == '/update'
						) {
							attributeValidate(
								'id_user_',
								template_control.id_user_,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'id_template_control',
								template_control.id_template_control,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation template
						 */

						if (
							url == '/create' ||
							url == '/createWithNewControl' ||
							url == '/update' ||
							url == '/updatePositions'
						) {
							attributeValidate(
								'id_template',
								template_control.template.id_template,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation control
						 */

						if (
							url == '/create' ||
							url == '/update' ||
							url == '/updateControlProperties'
						) {
							attributeValidate(
								'id_control',
								template_control.control.id_control,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}
						if (url == '/update' || url == '/updateControlProperties') {
							attributeValidate(
								'type_control',
								template_control.control.type_control,
								'string',
								11
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update' || url == '/updateControlProperties') {
							attributeValidate(
								'title_control',
								template_control.control.title_control,
								'string',
								50
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update' || url == '/updateControlProperties') {
							attributeValidate(
								'form_name_control',
								template_control.control.form_name_control,
								'string',
								50
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update' || url == '/updateControlProperties') {
							attributeValidate(
								'initial_value_control',
								template_control.control.initial_value_control,
								'string',
								100
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update' || url == '/updateControlProperties') {
							attributeValidate(
								'required_control',
								template_control.control.required_control,
								'boolean'
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update' || url == '/updateControlProperties') {
							attributeValidate(
								'min_length_control',
								template_control.control.min_length_control,
								'number',
								3
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update' || url == '/updateControlProperties') {
							attributeValidate(
								'max_length_control',
								template_control.control.max_length_control,
								'number',
								3
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update' || url == '/updateControlProperties') {
							attributeValidate(
								'placeholder_control',
								template_control.control.placeholder_control,
								'string',
								100
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update' || url == '/updateControlProperties') {
							attributeValidate(
								'spell_check_control',
								template_control.control.spell_check_control,
								'boolean'
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update' || url == '/updateControlProperties') {
							attributeValidate(
								'ordinal_position',
								template_control.ordinal_position,
								'number',
								3
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
							const _template_control = new TemplateControl();
							/**
							 * Execute the url depending on the path
							 */
							if (url == '/create') {
								/** set required attributes for action */
								_template_control.id_user_ = template_control.id_user_;
								_template_control.template = template_control.template;
								_template_control.control = template_control.control;
								await _template_control
									.create()
									.then((_templateControl: TemplateControl) => {
										resolve(_templateControl);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url == '/createWithNewControl') {
								/** set required attributes for action */
								_template_control.id_user_ = template_control.id_user_;
								_template_control.template = template_control.template;
								await _template_control
									.createWithNewControl()
									.then((_templateControl: TemplateControl) => {
										resolve(_templateControl);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 15) == '/byTemplateRead') {
								const id_template: any = template_control.template;

								if (id_template >= 1) {
									/** set required attributes for action */
									_template_control.template = template_control.template;
									_template_control.template = template_control.template;
									await _template_control
										.byTemplateRead()
										.then((_template_controls: TemplateControl[]) => {
											resolve(_template_controls);
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
							} else if (url.substring(0, 14) == '/byControlRead') {
								const id_control: any = template_control.control;

								if (id_control >= 1) {
									/** set required attributes for action */
									_template_control.control = template_control.control;
									_template_control.template = template_control.template;
									await _template_control
										.byControlRead()
										.then((_template_controls: TemplateControl[]) => {
											resolve(_template_controls);
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
							} else if (url.substring(0, 13) == '/specificRead') {
								const id_template_control: any =
									template_control.id_template_control;

								if (id_template_control >= 1) {
									/** set required attributes for action */
									_template_control.id_template_control =
										template_control.id_template_control;
									await _template_control
										.specificRead()
										.then((_templateControl: TemplateControl) => {
											resolve(_templateControl);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'template_control'
										),
									});
								}
							} else if (url == '/updateControlProperties') {
								/** set required attributes for action */
								_template_control.id_user_ = template_control.id_user_;
								_template_control.id_template_control =
									template_control.id_template_control;
								_template_control.template = template_control.template;
								_template_control.control = template_control.control;
								_template_control.ordinal_position =
									template_control.ordinal_position;
								await _template_control
									.updateControlProperties()
									.then((_templateControl: TemplateControl) => {
										resolve(_templateControl);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url == '/updatePositions') {
								/** set required attributes for action */
								_template_control.id_user_ = template_control.id_user_;
								_template_control.template = template_control.template;
								_template_control.template_control =
									template_control.template_control;
								await _template_control
									.updatePositions()
									.then((_templateControl: TemplateControl[]) => {
										resolve(_templateControl);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 7) == '/delete') {
								/** set required attributes for action */
								_template_control.id_user_ = template_control.id_user_;
								_template_control.id_template_control =
									template_control.id_template_control;
								await _template_control
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
