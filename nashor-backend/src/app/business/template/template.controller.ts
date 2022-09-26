import { checkDateString, FullDate } from '../../../utils/date';
import { verifyToken } from '../../../utils/jwt';
import { _messages } from '../../../utils/message/message';
import { Template } from './template.class';

export const validation = (template: Template, url: string, token: string) => {
	return new Promise<Template | Template[] | boolean | any>(
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
								template.id_user_,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'id_template',
								template.id_template,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'plugin_attached_process',
								template.plugin_attached_process,
								'boolean'
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}
						if (url == '/update') {
							attributeValidate(
								'plugin_item_process',
								template.plugin_item_process,
								'boolean'
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'name_template',
								template.name_template,
								'string',
								100
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'description_template',
								template.description_template,
								'string',
								250
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'status_template',
								template.status_template,
								'boolean'
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'last_change',
								template.last_change,
								'string',
								30
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});

							/**
							 * checkDateString
							 */
							await checkDateString(template.last_change!)
								.then((fullDate: FullDate) => {
									template.last_change = `${fullDate.fullYear}-${fullDate.month}-${fullDate.day} ${fullDate.hours}:${fullDate.minutes}:${fullDate.seconds}.${fullDate.milliSeconds}`;
								})
								.catch(() => {
									validationStatus = true;
									reject({
										..._messages[12],
										description: _messages[12].description.replace(
											'value_date',
											template.last_change!
										),
									});
								});
						}

						if (url == '/update') {
							attributeValidate('in_use', template.in_use, 'boolean').catch(
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
								template.company.id_company,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation documentationProfile
						 */

						if (url == '/update') {
							attributeValidate(
								'id_documentation_profile',
								template.documentation_profile.id_documentation_profile,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation pluginItem
						 */

						if (url == '/update') {
							attributeValidate(
								'id_plugin_item',
								template.plugin_item.id_plugin_item,
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
							const _template = new Template();
							/**
							 * Execute the url depending on the path
							 */
							if (url == '/create') {
								/** set required attributes for action */
								_template.id_user_ = template.id_user_;
								_template.company = template.company;
								await _template
									.create()
									.then((_template: Template) => {
										resolve(_template);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 10) == '/queryRead') {
								/** set required attributes for action */
								_template.name_template = template.name_template;
								await _template
									.queryRead()
									.then((_templates: Template[]) => {
										resolve(_templates);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 19) == '/byCompanyQueryRead') {
								const id_company: any = template.company;

								if (id_company >= 1) {
									/** set required attributes for action */
									_template.company = template.company;
									_template.name_template = template.name_template;
									await _template
										.byCompanyQueryRead()
										.then((_templates: Template[]) => {
											resolve(_templates);
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
							} else if (
								url.substring(0, 32) == '/byDocumentationProfileQueryRead'
							) {
								const id_documentation_profile: any =
									template.documentation_profile;

								if (id_documentation_profile >= 1) {
									/** set required attributes for action */
									_template.documentation_profile =
										template.documentation_profile;
									_template.name_template = template.name_template;
									await _template
										.byDocumentationProfileQueryRead()
										.then((_templates: Template[]) => {
											resolve(_templates);
										})
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
							} else if (url.substring(0, 13) == '/specificRead') {
								const id_template: any = template.id_template;

								if (id_template >= 1) {
									/** set required attributes for action */
									_template.id_template = template.id_template;
									await _template
										.specificRead()
										.then((_template: Template) => {
											resolve(_template);
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
							} else if (url == '/update') {
								/** set required attributes for action */
								_template.id_user_ = template.id_user_;
								_template.id_template = template.id_template;
								_template.company = template.company;
								_template.documentation_profile =
									template.documentation_profile;
								_template.plugin_item = template.plugin_item;
								_template.plugin_attached_process =
									template.plugin_attached_process;
								_template.plugin_item_process = template.plugin_item_process;
								_template.name_template = template.name_template;
								_template.description_template = template.description_template;
								_template.status_template = template.status_template;
								_template.last_change = template.last_change;
								_template.in_use = template.in_use;
								await _template
									.update()
									.then((_template: Template) => {
										resolve(_template);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 7) == '/delete') {
								/** set required attributes for action */
								_template.id_user_ = template.id_user_;
								_template.id_template = template.id_template;
								await _template
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
